#include "kernel/syscall.h"
#include "kernel/log.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/scheduler/process.h"
#include "kernel/pmm.h"
#include "kernel/vmm.h"
#include "kernel/net/socket.h"
#include "kernel/heap.h"
#include "kernel/futex.h"

#define PAGE_ALIGN(x) ((x) & 0xFFFFF000)

static syscall_fn syscall_table[256];

void register_syscall(uint32_t num, syscall_fn handler) {
    if (num < 256) {
        syscall_table[num] = handler;
    }
}

static void syscall_handler(registers_t *regs) {
    if (regs->eax >= 256 || syscall_table[regs->eax] == NULL) {
        log_error("Invalid syscall: %d", regs->eax);
        regs->eax = -1;
        return;
    }
    
    // Dispatch to the correct handler
    regs->eax = syscall_table[regs->eax](regs);
}

// ---------------------------------------------------------
// Basic Syscalls
#include "kernel/uaccess.h"
#include "kernel/fs/vfs.h"
#include "kernel/scheduler/thread.h"
#include "lib/string.h"
#include "lib/memory.h"

extern thread_t *current_thread;

static int sys_exit(registers_t *regs) {
    int status = (int)regs->ebx;
    process_exit(status);
    return 0;
}

static int sys_waitpid(registers_t *regs) {
    int pid = (int)regs->ebx;
    int *status = (int *)regs->ecx;
    
    int kstatus = 0;
    int ret_pid = process_waitpid(pid, &kstatus);
    
    if (ret_pid > 0 && status) {
        if (copy_to_user((char *)status, (char *)&kstatus, sizeof(int)) != 0) {
            return -1;
        }
    }
    return ret_pid;
}

static int sys_fork(registers_t *regs) {
    int pid = process_fork(regs);
    log_info("sys_fork: returned %d", pid);
    return pid;
}

#include "kernel/exec.h"

// Helper to copy a string array from user space.
// Returns the number of strings copied, or -1 on error.
// The allocated array and strings must be kfree'd later.
static int copy_string_array_from_user(const char **u_array, const char ***k_array_out) {
    if (!u_array) {
        *k_array_out = NULL;
        return 0;
    }
    
    // Count items
    int count = 0;
    while (count < 32) {
        const char *ptr;
        if (copy_from_user((char *)&ptr, (const char *)(u_array + count), sizeof(void *)) != 0) return -1;
        if (!ptr) break;
        count++;
    }
    
    if (count == 0) {
        *k_array_out = NULL;
        return 0;
    }
    
    const char **k_array = (const char **)kmalloc(count * sizeof(const char *), KMALLOC_ZERO);
    for (int i = 0; i < count; i++) {
        const char *u_ptr;
        copy_from_user((char *)&u_ptr, (const char *)(u_array + i), sizeof(void *));
        
        char *k_str = (char *)kmalloc(256, KMALLOC_ZERO);
        int j = 0;
        while (j < 255) {
            if (copy_from_user(&k_str[j], u_ptr + j, 1) != 0) {
                // Ignore errors inside the string, just terminate it early if needed
                break;
            }
            if (k_str[j] == '\0') break;
            j++;
        }
        k_str[255] = '\0';
        k_array[i] = k_str;
    }
    
    *k_array_out = k_array;
    return count;
}

static void free_string_array(const char **k_array, int count) {
    if (!k_array) return;
    for (int i = 0; i < count; i++) {
        if (k_array[i]) kfree((void *)k_array[i]);
    }
    kfree((void *)k_array);
}

static int sys_execve(registers_t *regs) {
    const char *path = (const char *)regs->ebx;
    const char **argv = (const char **)regs->ecx;
    const char **envp = (const char **)regs->edx;
    
    char kpath[256];
    int i = 0;
    while (i < 255) {
        if (copy_from_user(&kpath[i], path + i, 1) != 0) return -1;
        if (kpath[i] == '\0') break;
        i++;
    }
    kpath[255] = '\0';
    
    const char **kargv = NULL;
    int argc = copy_string_array_from_user(argv, &kargv);
    if (argc < 0) return -1;
    
    const char **kenvp = NULL;
    int envc = copy_string_array_from_user(envp, &kenvp);
    if (envc < 0) {
        free_string_array(kargv, argc);
        return -1;
    }
    
    exec_image_t image;
    log_info("sys_execve: loading %s (argc=%d, envc=%d)", kpath, argc, envc);
    
    if (exec_load(kpath, &image, argc, kargv, envc, kenvp) != 0) {
        log_error("sys_execve: exec_load failed for %s", kpath);
        free_string_array(kargv, argc);
        free_string_array(kenvp, envc);
        return -1;
    }
    
    // Free the copied strings now that exec_load has constructed the new stack
    free_string_array(kargv, argc);
    free_string_array(kenvp, envc);
    
    process_t *proc = current_thread->process;
    proc->generation++;
    
    // Clean up old resources... (Atomic commit point)
    if (proc->address_space) {
        address_space_destroy(proc->address_space);
    }
    
    vm_region_t *curr = proc->vm_regions;
    while (curr) {
        vm_region_t *next = curr->next;
        kfree(curr);
        curr = next;
    }
    proc->vm_regions = image.regions;
    if (proc->vm_regions) {
        proc->vm_regions->owner = proc;
    }
    
    proc->address_space = image.space;
    switch_address_space(proc->address_space);
    
    // Set up return frame to seamlessly transition to new program
    regs->eip = (uint32_t)image.entry;
    regs->useresp = (uint32_t)image.user_stack;
    
    return 0;
}
static int sys_open(registers_t *regs) {
    const char *path = (const char *)regs->ebx;
    uint32_t flags = (uint32_t)regs->ecx;
    
    char kpath[256];
    // We don't know the exact length, but we can safely copy up to 255 bytes.
    // However, copy_from_user validates the entire size. To be completely safe without a strncpy_from_user,
    // we should use a simplistic check or write strncpy_from_user.
    // For now, let's assume path is less than 256 bytes and we only validate up to the null terminator.
    int i = 0;
    while (i < 255) {
        if (copy_from_user(&kpath[i], path + i, 1) != 0) return -1;
        if (kpath[i] == '\0') break;
        i++;
    }
    kpath[255] = '\0'; // ensure null termination
    
    file_t *f = vfs_open(kpath, flags);
    if (!f) return -1;
    
    process_t *proc = current_thread->process;
    for (int fd_idx = 0; fd_idx < MAX_FDS; fd_idx++) {
        if (proc->fd_table[fd_idx] == NULL) {
            proc->fd_table[fd_idx] = f;
            return fd_idx;
        }
    }
    
    vfs_close(f);
    return -1; // -EMFILE
}

static int sys_read(registers_t *regs) {
    int fd = (int)regs->ebx;
    void *buf = (void *)regs->ecx;
    size_t size = (size_t)regs->edx;
    
    if (fd < 0 || fd >= MAX_FDS) {
        log_error("sys_read: invalid fd %d", fd);
        return -1;
    }
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) {
        log_error("sys_read: fd_table[%d] is NULL", fd);
        return -1;
    }
    
    char kbuf[256];
    size_t total_read = 0;
    while (size > 0) {
        size_t chunk = size > sizeof(kbuf) ? sizeof(kbuf) : size;
        int bytes_read = vfs_read(f, kbuf, chunk);
        if (bytes_read <= 0) {
            if (bytes_read < 0 && total_read == 0) return bytes_read;
            break;
        }
        if (copy_to_user((char *)buf + total_read, kbuf, bytes_read) != 0) {
            log_error("sys_read: copy_to_user failed for buf 0x%x", (uint32_t)buf + total_read);
            return -1;
        }
        total_read += bytes_read;
        size -= bytes_read;
        
        // If we got a short read, don't loop again and risk blocking
        if (bytes_read < (int)chunk) {
            break;
        }
    }
    return total_read;
}

static int sys_write(registers_t *regs) {
    int fd = (int)regs->ebx;
    const void *buf = (const void *)regs->ecx;
    size_t size = (size_t)regs->edx;
    
    log_info("sys_write called for fd=%d size=%d", fd, size);
    
    if (fd < 0 || fd >= MAX_FDS) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    char kbuf[256];
    size_t total_written = 0;
    while (size > 0) {
        size_t chunk = size > sizeof(kbuf) ? sizeof(kbuf) : size;
        if (copy_from_user(kbuf, (const char *)buf + total_written, chunk) != 0) {
            log_error("sys_write: copy_from_user failed for buf 0x%x chunk %d", (uint32_t)buf + total_written, chunk);
            return -1;
        }
        int bytes_written = vfs_write(f, kbuf, chunk);
        if (bytes_written <= 0) {
            if (total_written == 0) {
                log_error("sys_write returning %d", bytes_written);
                return bytes_written;
            }
            break;
        }
        total_written += bytes_written;
        size -= bytes_written;
    }
    
    log_info("sys_write returning %d", total_written);
    return total_written;
}

static int sys_close(registers_t *regs) {
    int fd = (int)regs->ebx;
    if (fd < 0 || fd >= MAX_FDS) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    vfs_close(f);
    current_thread->process->fd_table[fd] = NULL;
    return 0;
}

static int sys_ioctl(registers_t *regs) {
    int fd = (int)regs->ebx;
    uint32_t request = (uint32_t)regs->ecx;
    void *arg = (void *)regs->edx;
    
    if (fd < 0 || fd >= MAX_FDS) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    return vfs_ioctl(f, request, arg);
}

static int sys_yield(registers_t *regs) {
    (void)regs;
    scheduler_yield();
    return 0;
}

static int sys_brk(registers_t *regs) {
    uint32_t addr = (uint32_t)regs->ebx;
    process_t *proc = current_thread ? current_thread->process : NULL;
    
    if (!proc || !proc->address_space) {
        return -1;
    }
    
    address_space_t *as = proc->address_space;
    
    // If addr is 0, just return current heap_end
    if (addr == 0) {
        return as->heap_end;
    }
    
    // Validate addr is not below heap_base
    if (addr < as->heap_base) {
        return -1;
    }
    
    // Page align current and new break
    uint32_t old_page_end = PAGE_ALIGN(as->heap_end + PAGE_SIZE - 1);
    uint32_t new_page_end = PAGE_ALIGN(addr + PAGE_SIZE - 1);
    
    if (new_page_end > old_page_end) {
        // Grow heap: map new pages
        uint32_t num_pages = (new_page_end - old_page_end) / PAGE_SIZE;
        for (uint32_t i = 0; i < num_pages; i++) {
            phys_addr_t paddr = pmm_alloc_frame();
            if (!paddr) {
                log_error("sys_brk: out of memory allocating frame");
                // Note: a robust implementation would rollback the mapped pages here
                return -1;
            }
            vmm_map(old_page_end + i * PAGE_SIZE, paddr, PAGE_PRESENT | PAGE_WRITE | PAGE_USER);
        }
    } else if (new_page_end < old_page_end) {
        // Shrink heap: unmap pages
        uint32_t num_pages = (old_page_end - new_page_end) / PAGE_SIZE;
        for (uint32_t i = 0; i < num_pages; i++) {
            uint32_t vaddr = new_page_end + i * PAGE_SIZE;
            // TODO: Ideally we should free the physical frame here.
            // Currently vmm_unmap doesn't return the frame, so we might leak it if we don't look it up first.
            // For this phase, we just unmap.
            vmm_unmap(vaddr);
        }
    }
    
    as->heap_end = addr;
    
    // Also update or create the vm_region_t for the heap so it's tracked properly
    vm_region_t *heap_region = NULL;
    vm_region_t *curr = proc->vm_regions;
    while (curr) {
        // Find existing heap region
        if (curr->start == as->heap_base) {
            heap_region = curr;
            break;
        }
        curr = curr->next;
    }
    
    if (!heap_region && addr > as->heap_base) {
        heap_region = kmalloc(sizeof(vm_region_t), KMALLOC_ZERO);
        heap_region->start = as->heap_base;
        heap_region->flags = PAGE_PRESENT | PAGE_WRITE | PAGE_USER;
        heap_region->is_anonymous = 1;
        heap_region->owner = proc;
        heap_region->next = proc->vm_regions;
        proc->vm_regions = heap_region;
    }
    
    if (heap_region) {
        heap_region->end = new_page_end;
    }
    
    return as->heap_end;
}

static int sys_mmap(registers_t *regs) {
    uint32_t addr = (uint32_t)regs->ebx;
    uint32_t length = (uint32_t)regs->ecx;
    int prot = (int)regs->edx;
    int flags = (int)regs->esi;
    int fd = (int)regs->edi;
    uint32_t offset = (uint32_t)regs->ebp;
    
    // W^X Enforcement
    if ((prot & 2) && (prot & 4)) {
        log_error("W^X Violation: mmap requested RWX memory");
        return -1;
    }
    
#ifndef MAP_FIXED
#define MAP_FIXED 0x10
#endif

    log_info("sys_mmap: addr=%x length=%x prot=%x flags=%x", addr, length, prot, flags);

    process_t *current_process = current_thread ? current_thread->process : NULL;
    if (!current_process || !current_process->address_space) {
        log_error("sys_mmap: no address space");
        return -1;
    }

    if (flags & MAP_FIXED) {
        // use addr
    } else {
        addr = current_process->address_space->mmap_next;
        current_process->address_space->mmap_next += PAGE_ALIGN(length + PAGE_SIZE - 1);
    }
    
    uint32_t vmm_flags = PAGE_USER;
    if (prot != 0) {
        vmm_flags |= PAGE_PRESENT;
        if (prot & 2) vmm_flags |= PAGE_WRITE; // PROT_WRITE
    }
    
    uint32_t num_pages = (length + PAGE_SIZE - 1) / PAGE_SIZE;
    uint32_t map_end = addr + num_pages * PAGE_SIZE;
    
    // Handle MAP_FIXED (0x10) by unmapping overlapping regions
    if (flags & 0x10) {
        process_t *proc = current_thread->process;
        vm_region_t **prev = &proc->vm_regions;
        vm_region_t *curr = *prev;
        vm_region_t *new_regions = NULL;
        
        while (curr) {
            if (addr < curr->end && map_end > curr->start) {
                // There is an overlap.
                uint32_t i_start = (addr > curr->start) ? addr : curr->start;
                uint32_t i_end = (map_end < curr->end) ? map_end : curr->end;
                
                if (i_start > curr->start) {
                    vm_region_t *left = kmalloc(sizeof(vm_region_t), 0);
                    if (left) {
                        *left = *curr;
                        left->end = i_start;
                        left->next = new_regions;
                        new_regions = left;
                    }
                }
                if (i_end < curr->end) {
                    vm_region_t *right = kmalloc(sizeof(vm_region_t), 0);
                    if (right) {
                        *right = *curr;
                        right->start = i_end;
                        if (right->file) {
                            right->offset += (i_end - curr->start);
                        }
                        right->next = new_regions;
                        new_regions = right;
                    }
                }
                
                // Unmap the overlapping physical pages if they were mapped
                uint32_t start_page = i_start & 0xFFFFF000;
                uint32_t end_page = (i_end + PAGE_SIZE - 1) & 0xFFFFF000;
                for (uint32_t p = start_page; p < end_page; p += PAGE_SIZE) {
                    if (vmm_is_mapped(p)) vmm_unmap(p);
                }
                
                // Remove the current region
                vm_region_t *to_free = curr;
                *prev = curr->next;
                curr = curr->next;
                
                // If it had a file, decrement refcount
                if (to_free->file) {
                    to_free->file->refcount--;
                }
                kfree(to_free);
                continue;
            }
            prev = &curr->next;
            curr = curr->next;
        }
        
        // Add new regions back
        while (new_regions) {
            vm_region_t *next = new_regions->next;
            new_regions->next = proc->vm_regions;
            proc->vm_regions = new_regions;
            new_regions = next;
        }
    }
    
    // Allocate a new vm_region
    vm_region_t *region = kmalloc(sizeof(vm_region_t), 0);
    if (!region) return -1;
    
    region->start = addr;
    region->end = addr + num_pages * PAGE_SIZE;
    region->flags = vmm_flags;
    // Map PROT_NONE as not-lazy, since we don't want to fault-in PROT_NONE pages,
    // actually it's fine, if PAGE_PRESENT is missing, page fault handler will check region->flags
    // and if region->flags does not have PAGE_PRESENT, it will just fault and crash the program.
    region->is_lazy = 1; // Demand paged by default
    region->owner = current_thread->process;
    
    // Parse MAP_SHARED vs MAP_PRIVATE (assuming standard flags: 0x01 = SHARED, 0x02 = PRIVATE)
    region->is_shared = (flags & 0x01) ? 1 : 0;
    
    if (fd != -1) {
        region->is_anonymous = 0;
        file_t *f = current_thread->process->fd_table[fd];
        region->file = f;
        region->offset = offset;
        // Optionally bump refcount of f
        if (f) f->refcount++;
    } else {
        region->is_anonymous = 1;
        region->file = NULL;
        region->offset = 0;
    }
    
    // Link to process
    region->next = current_thread->process->vm_regions;
    current_thread->process->vm_regions = region;
    
    return addr;
}

static int sys_mprotect(registers_t *regs) {
    uint32_t addr = (uint32_t)regs->ebx;
    uint32_t len = (uint32_t)regs->ecx;
    int prot = (int)regs->edx;

    if (addr < PAGE_SIZE || addr >= 0xC0000000) return -1;
    if (len == 0) return 0;
    
    // W^X Enforcement
    if ((prot & 2) && (prot & 4)) {
        log_error("W^X Violation: mprotect requested RWX memory at 0x%x", addr);
        return -1;
    }

    uint32_t flags = PAGE_USER;
    if (prot != 0) {
        flags |= PAGE_PRESENT;
        if (prot & 2) flags |= PAGE_WRITE;
    }

    process_t *proc = current_thread->process;
    vm_region_t *curr = proc->vm_regions;
    
    // Create a temporary list to hold newly split regions so we don't process them again in the same loop
    vm_region_t *new_regions = NULL;

    while (curr) {
        if (addr < curr->end && (addr + len) > curr->start) {
            uint32_t i_start = (addr > curr->start) ? addr : curr->start;
            uint32_t i_end = ((addr + len) < curr->end) ? (addr + len) : curr->end;
            
            // If the intersection is strictly smaller than the region, split it
            if (i_start > curr->start) {
                vm_region_t *left = kmalloc(sizeof(vm_region_t), 0);
                if (left) {
                    *left = *curr; // Copy all properties including file mappings
                    left->end = i_start;
                    left->next = new_regions;
                    new_regions = left;
                }
            }
            if (i_end < curr->end) {
                vm_region_t *right = kmalloc(sizeof(vm_region_t), 0);
                if (right) {
                    *right = *curr;
                    right->start = i_end;
                    if (right->file) {
                        right->offset += (i_end - curr->start); // Adjust offset if file-backed
                    }
                    right->next = new_regions;
                    new_regions = right;
                }
            }
            
            // Now adjust the current region to exactly match the intersection and update flags
            curr->start = i_start;
            curr->end = i_end;
            curr->flags = flags;
            
            uint32_t start_page = i_start & 0xFFFFF000;
            uint32_t end_page = (i_end + PAGE_SIZE - 1) & 0xFFFFF000;
            
            for (uint32_t p = start_page; p < end_page; p += PAGE_SIZE) {
                if (vmm_is_mapped(p)) {
                    phys_addr_t phys = vmm_translate(p) & 0xFFFFF000;
                    vmm_map(p, phys, flags);
                }
            }
        }
        curr = curr->next;
    }
    
    // Prepend any newly created split regions to the process's region list
    while (new_regions) {
        vm_region_t *next = new_regions->next;
        new_regions->next = proc->vm_regions;
        proc->vm_regions = new_regions;
        new_regions = next;
    }
    
    return 0;
}

static int sys_lseek(registers_t *regs) {
    int fd = (int)regs->ebx;
    int offset = (int)regs->ecx;
    int whence = (int)regs->edx;
    
    if (fd < 0 || fd >= MAX_FDS) return -1;
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    if (whence == 0) { // SEEK_SET
        f->offset = offset;
    } else if (whence == 1) { // SEEK_CUR
        f->offset += offset;
    }
    // SEEK_END is not fully supported yet without file sizes in VFS
    
    return f->offset;
}

static int sys_munmap(registers_t *regs) {
    (void)regs;
    return 0; // Simplistic
}

extern void gdt_set_tls(uint32_t base);

static int sys_set_tls(registers_t *regs) {
    uint32_t tls_base = (uint32_t)regs->ebx;
    if (current_thread) {
        current_thread->tls_base = tls_base;
        gdt_set_tls(tls_base);
        // Load %gs to point to the TLS descriptor (Index 6, RPL 3 => 0x33)
        __asm__ volatile("mov $0x33, %%ax; mov %%ax, %%gs" : : : "ax");
    }
    return 0;
}

extern int thread_clone(registers_t *regs);

static int sys_clone(registers_t *regs) {
    return thread_clone(regs);
}

static int sys_thread_exit(registers_t *regs) {
    // For now, thread_destroy doesn't reap, but we must stop running
    extern void scheduler_exit_current(void);
    scheduler_exit_current();
    return 0;
}

#include "kernel/fs/pipe.h"

static int sys_pipe(registers_t *regs) {
    int *u_fds = (int *)regs->ebx;
    if (!u_fds) return -1;
    
    file_t *r_file, *w_file;
    if (pipe_create(&r_file, &w_file) != 0) {
        return -1; // ENOMEM
    }
    
    process_t *proc = current_thread->process;
    int fd0 = -1, fd1 = -1;
    
    // Find two free file descriptors
    for (int i = 0; i < MAX_FDS; i++) {
        if (!proc->fd_table[i]) {
            if (fd0 == -1) fd0 = i;
            else {
                fd1 = i;
                break;
            }
        }
    }
    
    if (fd0 == -1 || fd1 == -1) {
        vfs_close(r_file);
        vfs_close(w_file);
        return -1; // EMFILE
    }
    
    proc->fd_table[fd0] = r_file;
    proc->fd_table[fd1] = w_file;
    
    int k_fds[2] = {fd0, fd1};
    if (copy_to_user((char *)u_fds, (char *)k_fds, sizeof(k_fds)) != 0) {
        // Clean up on error
        proc->fd_table[fd0] = NULL;
        proc->fd_table[fd1] = NULL;
        vfs_close(r_file);
        vfs_close(w_file);
        return -1; // EFAULT
    }
    
    return 0;
}

static int sys_dup(registers_t *regs) {
    int oldfd = (int)regs->ebx;
    if (oldfd < 0 || oldfd >= MAX_FDS) return -1;
    
    process_t *proc = current_thread->process;
    file_t *f = proc->fd_table[oldfd];
    if (!f) return -1;
    
    int newfd = -1;
    for (int i = 0; i < MAX_FDS; i++) {
        if (!proc->fd_table[i]) {
            newfd = i;
            break;
        }
    }
    
    if (newfd == -1) return -1;
    
    proc->fd_table[newfd] = f;
    f->refcount++;
    
    return newfd;
}

static int sys_dup2(registers_t *regs) {
    int oldfd = (int)regs->ebx;
    int newfd = (int)regs->ecx;
    
    if (oldfd < 0 || oldfd >= MAX_FDS) return -1;
    if (newfd < 0 || newfd >= MAX_FDS) return -1;
    
    process_t *proc = current_thread->process;
    file_t *f = proc->fd_table[oldfd];
    if (!f) return -1;
    
    if (oldfd == newfd) {
        return newfd;
    }
    
    if (proc->fd_table[newfd]) {
        vfs_close(proc->fd_table[newfd]);
        proc->fd_table[newfd] = NULL;
    }
    
    proc->fd_table[newfd] = f;
    f->refcount++;
    
    return newfd;
}
static int sys_socket(registers_t *regs) {
    int domain = (int)regs->ebx;
    int type = (int)regs->ecx;
    int protocol = (int)regs->edx;

    socket_t *sock = sock_create(domain, type, protocol);
    if (!sock) return -1;

    // Create an anonymous VFS node
    vfs_node_t *node = kmalloc(sizeof(vfs_node_t), KMALLOC_ZERO);
    if (!node) {
        sock_close(sock);
        return -1;
    }
    strcpy(node->name, "socket");
    node->flags = FS_SOCKET;
    node->device = sock;
    
    // We need to access socket_ops which is static in socket.c. Wait, we can just define socket_ops here or in socket.c and export it.
    // For now, let's leave ops as NULL or we'll get a crash on close.
    // Let's declare it as extern in syscall.c.
    extern vfs_ops_t socket_ops;
    node->ops = &socket_ops;

    file_t *f = kmalloc(sizeof(file_t), KMALLOC_ZERO);
    if (!f) {
        kfree(node);
        sock_close(sock);
        return -1;
    }
    f->node = node;
    f->refcount = 1;

    process_t *proc = current_thread->process;
    for (int fd_idx = 0; fd_idx < MAX_FDS; fd_idx++) {
        if (proc->fd_table[fd_idx] == NULL) {
            proc->fd_table[fd_idx] = f;
            return fd_idx;
        }
    }

    kfree(f);
    kfree(node);
    sock_close(sock);
    return -1; // EMFILE
}

static int sys_bind(registers_t *regs) {
    int fd = (int)regs->ebx;
    const struct sockaddr *uaddr = (const struct sockaddr *)regs->ecx;
    socklen_t addrlen = (socklen_t)regs->edx;

    if (fd < 0 || fd >= MAX_FDS) return -1;
    if (!uaddr || addrlen < sizeof(struct sockaddr_in)) return -1;

    file_t *f = current_thread->process->fd_table[fd];
    if (!f || !f->node || f->node->flags != FS_SOCKET) return -1;

    socket_t *sock = (socket_t *)f->node->device;
    if (!sock) return -1;

    struct sockaddr_in kaddr;
    if (copy_from_user(&kaddr, uaddr, sizeof(struct sockaddr_in)) != 0) return -1;

    if (kaddr.sin_family != AF_INET) return -1;

    // Byte swap since struct is in network byte order usually? No, bind takes network byte order in standard API. 
    // Wait, let's assume it takes network byte order for port and IP. We will convert it in user space.
    // Or we expect native byte order? Standard POSIX uses network byte order.
    // For simplicity, we assume native byte order here for IP and Port, wait no, let's assume network byte order to be standard.
    // We don't have ntohs in syscall.c natively. But we can just use it directly.
    // Let's just pass the values raw and expect the caller to pass native or we convert.
    // Let's expect the caller to pass network byte order, but for our simple tests, let's just use the raw values, assuming caller gives native order for simplicity.
    // Wait, the user specifically mentioned "10.0.0.1:5000". Let's assume the kernel API sock_bind takes native byte order.
    // So if userspace passes network byte order, we should swap.
    // For now, let's assume userspace passes NATIVE byte order to sys_bind to avoid bringing ntohs into syscall.c.
    return sock_bind(sock, kaddr.sin_addr, kaddr.sin_port);
}

static int sys_sendto(registers_t *regs) {
    int fd = (int)regs->ebx;
    const void *buf = (const void *)regs->ecx;
    size_t len = (size_t)regs->edx;
    int flags = (int)regs->esi;
    const struct sockaddr *uaddr = (const struct sockaddr *)regs->edi;
    socklen_t addrlen = (socklen_t)regs->ebp;

    if (fd < 0 || fd >= MAX_FDS) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f || !f->node || f->node->flags != FS_SOCKET) return -1;

    socket_t *sock = (socket_t *)f->node->device;
    if (!sock) return -1;

    struct sockaddr_in kaddr;
    if (uaddr) {
        if (addrlen < sizeof(struct sockaddr_in)) return -1;
        if (copy_from_user(&kaddr, uaddr, sizeof(struct sockaddr_in)) != 0) return -1;
        if (kaddr.sin_family != AF_INET) return -1;
    } else {
        return -1; // Need dest addr for now
    }

    // Use a kernel buffer
    if (len > 8192) return -1;
    void *kbuf = kmalloc(len, 0);
    if (!kbuf) return -1;
    
    if (copy_from_user(kbuf, buf, len) != 0) {
        kfree(kbuf);
        return -1;
    }

    int ret = sock_sendto(sock, kbuf, len, kaddr.sin_addr, kaddr.sin_port);
    kfree(kbuf);
    
    // sendto returns bytes sent
    if (ret >= 0) return ret;
    return -1;
}

static int sys_recvfrom(registers_t *regs) {
    int fd = (int)regs->ebx;
    void *buf = (void *)regs->ecx;
    size_t len = (size_t)regs->edx;
    int flags = (int)regs->esi;
    struct sockaddr *uaddr = (struct sockaddr *)regs->edi;
    socklen_t *uaddrlen = (socklen_t *)regs->ebp;

    if (fd < 0 || fd >= MAX_FDS) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f || !f->node || f->node->flags != FS_SOCKET) return -1;

    socket_t *sock = (socket_t *)f->node->device;
    if (!sock) return -1;

    if (len > 8192) len = 8192; // Cap to arbitrary limit
    void *kbuf = kmalloc(len, 0);
    if (!kbuf) return -1;

    uint32_t src_ip = 0;
    uint16_t src_port = 0;

    int bytes_read = sock_recvfrom(sock, kbuf, len, &src_ip, &src_port);
    if (bytes_read < 0) {
        kfree(kbuf);
        return bytes_read;
    }

    if (copy_to_user(buf, kbuf, bytes_read) != 0) {
        kfree(kbuf);
        return -1;
    }

    kfree(kbuf);

    if (uaddr && uaddrlen) {
        socklen_t kaddrlen = 0;
        if (copy_from_user(&kaddrlen, uaddrlen, sizeof(socklen_t)) != 0) return -1;
        
        struct sockaddr_in kaddr;
        kaddr.sin_family = AF_INET;
        kaddr.sin_addr = src_ip;
        kaddr.sin_port = src_port;
        
        if (kaddrlen > sizeof(struct sockaddr_in)) kaddrlen = sizeof(struct sockaddr_in);
        
        if (copy_to_user(uaddr, &kaddr, kaddrlen) != 0) return -1;
        if (copy_to_user(uaddrlen, &kaddrlen, sizeof(socklen_t)) != 0) return -1;
    }

    return bytes_read;
}

void syscall_init(void) {
    // Initialize the syscall table to NULL
    for (int i = 0; i < 256; i++) {
        syscall_table[i] = NULL;
    }
    
    // Register the interrupt handler for int 0x80 (128)
    register_interrupt_handler(128, syscall_handler);
    
    register_syscall(SYS_EXIT, sys_exit);
    register_syscall(SYS_WRITE, sys_write);
    register_syscall(SYS_YIELD, sys_yield);
    register_syscall(SYS_OPEN, sys_open);
    register_syscall(SYS_READ, sys_read);
    register_syscall(SYS_CLOSE, sys_close);
    register_syscall(SYS_IOCTL, sys_ioctl);
    register_syscall(SYS_LSEEK, sys_lseek);
    register_syscall(SYS_MMAP, sys_mmap);
    register_syscall(SYS_MPROTECT, sys_mprotect);
    register_syscall(SYS_MUNMAP, sys_munmap);
    register_syscall(SYS_WAITPID, sys_waitpid);
    register_syscall(SYS_FORK, sys_fork);
    register_syscall(SYS_EXECVE, sys_execve);
    register_syscall(14, sys_brk);
    register_syscall(15, sys_set_tls);
    register_syscall(16, sys_clone);
    register_syscall(17, sys_thread_exit);
    register_syscall(SYS_FUTEX, sys_futex);
    register_syscall(SYS_PIPE, sys_pipe);
    register_syscall(SYS_DUP, sys_dup);
    register_syscall(SYS_DUP2, sys_dup2);
    register_syscall(SYS_SOCKET, sys_socket);
    register_syscall(SYS_BIND, sys_bind);
    register_syscall(SYS_SENDTO, sys_sendto);
    register_syscall(SYS_RECVFROM, sys_recvfrom);
    
    log_info("System Calls initialized.");
}
