#include "kernel/syscall.h"
#include "kernel/log.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/scheduler/process.h"

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

static int sys_open(registers_t *regs) {
    const char *path = (const char *)regs->ebx;
    uint32_t flags = (uint32_t)regs->ecx;
    
    // We should copy the path from user space, but for now we'll just check it
    // Properly, we should allocate a kernel buffer and copy_from_user.
    // Let's assume path is valid for now, or just limit size.
    if (!user_ptr_valid(path, 1)) return -1;
    
    file_t *f = vfs_open(path, flags);
    if (!f) return -1;
    
    process_t *proc = current_thread->process;
    for (int i = 0; i < MAX_FDS; i++) {
        if (proc->fd_table[i] == NULL) {
            proc->fd_table[i] = f;
            return i;
        }
    }
    
    vfs_close(f);
    return -1; // -EMFILE
}

static int sys_read(registers_t *regs) {
    int fd = (int)regs->ebx;
    void *buf = (void *)regs->ecx;
    size_t size = (size_t)regs->edx;
    
    if (fd < 0 || fd >= MAX_FDS) return -1;
    if (!user_ptr_valid(buf, size)) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    return vfs_read(f, buf, size);
}

static int sys_write(registers_t *regs) {
    int fd = (int)regs->ebx;
    const void *buf = (const void *)regs->ecx;
    size_t size = (size_t)regs->edx;
    
    if (fd < 0 || fd >= MAX_FDS) return -1;
    if (!user_ptr_valid(buf, size)) return -1;
    
    file_t *f = current_thread->process->fd_table[fd];
    if (!f) return -1;
    
    return vfs_write(f, buf, size);
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
    
    log_info("System Calls initialized.");
}
