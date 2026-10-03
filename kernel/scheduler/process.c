#include "kernel/scheduler/process.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/heap.h"
#include "kernel/log.h"
#include "lib/memory.h"
#include "lib/string.h"

static uint32_t next_pid = 1;

process_t *process_create(const char *name) {
    process_t *proc = (process_t *)kmalloc(sizeof(process_t), KMALLOC_ZERO);
    if (!proc) {
        log_error("Failed to allocate process struct for '%s'", name);
        return NULL;
    }
    
    proc->pid = next_pid++;
    strncpy(proc->name, name, sizeof(proc->name) - 1);
    proc->name[sizeof(proc->name) - 1] = '\0';
    
    proc->state = PROCESS_NEW;
    proc->exit_status = 0;
    proc->generation = 0;
    proc->parent = NULL;
    list_init(&proc->children);
    waitqueue_init(&proc->exit_wait_queue);
    
    proc->address_space = address_space_create();
    if (!proc->address_space) {
        log_error("Failed to create address space for process '%s'", name);
        kfree(proc);
        return NULL;
    }
    
    proc->vm_regions = NULL;
    
    list_init(&proc->threads);
    
    for (int i = 0; i < MAX_FDS; i++) {
        proc->fd_table[i] = NULL;
    }
    
    log_info("Process created: PID %u '%s'", proc->pid, proc->name);
    return proc;
}

void process_destroy(process_t *proc) {
    if (!proc) return;
    
    proc->state = PROCESS_DESTROYED;
    log_info("Process destroyed: PID %u '%s'", proc->pid, proc->name);
    
    // Remove from parent's children list
    if (proc->parent) {
        list_node_t *node = list_find(&proc->parent->children, proc);
        if (node) {
            list_remove(&proc->parent->children, node);
        }
    }
    
    kfree(proc);
}

extern void scheduler_exit_current(void);
#include "kernel/scheduler/thread.h"
extern thread_t *current_thread;

void process_exit(int status) {
    thread_t *curr_thread = current_thread;
    if (!curr_thread || !curr_thread->process) {
        scheduler_exit_current();
        return;
    }
    
    process_t *proc = curr_thread->process;
    proc->state = PROCESS_EXITING;
    proc->exit_status = status;
    log_info("Process %d exited with status %d", proc->pid, status);
    
    // Close FDs
    for (int i = 0; i < MAX_FDS; i++) {
        if (proc->fd_table[i]) {
            vfs_close(proc->fd_table[i]);
            proc->fd_table[i] = NULL;
        }
    }
    
    // Unmap VM regions
    vm_region_t *curr = proc->vm_regions;
    while (curr) {
        vm_region_t *next = curr->next;
        kfree(curr);
        curr = next;
    }
    proc->vm_regions = NULL;
    
    // Destroy address space
    if (proc->address_space) {
        address_space_destroy(proc->address_space);
        proc->address_space = NULL;
    }
    
    // Transition to ZOMBIE
    proc->state = PROCESS_ZOMBIE;
    
    // Wake up parent
    if (proc->parent) {
        waitqueue_wake_all(&proc->parent->exit_wait_queue);
    }
    
    // Re-parent children to init (PID 1) - omitted for simplicity unless we have a real init
    // For now, we'll just orphan them or they'll be cleaned up if they exit.
    
    scheduler_exit_current();
}

int process_waitpid(int pid, int *status) {
    thread_t *curr_thread = current_thread;
    if (!curr_thread || !curr_thread->process) return -1;
    
    process_t *parent = curr_thread->process;
    
    // A process with no children cannot wait
    if (parent->children.count == 0) return -1;
    
    while (1) {
        process_t *found_zombie = NULL;
        
        list_node_t *curr = parent->children.head;
        while (curr) {
            process_t *child = (process_t *)curr->value;
            if ((pid <= 0 || child->pid == (uint32_t)pid) && child->state == PROCESS_ZOMBIE) {
                found_zombie = child;
                break;
            }
            curr = curr->next;
        }
        
        if (found_zombie) {
            int child_pid = found_zombie->pid;
            if (status) {
                *status = found_zombie->exit_status;
            }
            process_destroy(found_zombie);
            return child_pid;
        }
        
        // Wait for a child to exit
        spinlock_t dummy_lock = {0}; // Simplification: in a real kernel, we'd lock the parent or waitqueue
        waitqueue_sleep(&parent->exit_wait_queue, &dummy_lock);
    }
    return -1;
}

extern void fork_ret(void);

int process_fork(registers_t *regs) {
    thread_t *curr_thread = current_thread;
    if (!curr_thread || !curr_thread->process) return -1;
    
    process_t *parent = curr_thread->process;
    
    // Create new process
    process_t *child = process_create("forked");
    if (!child) return -1;
    
    // Free the default empty address space created by process_create
    address_space_destroy(child->address_space);
    
    // Clone address space
    child->address_space = (address_space_t *)kmalloc(sizeof(address_space_t), KMALLOC_ZERO);
    child->address_space->page_directory = vmm_clone_address_space();
    child->address_space->user_base = parent->address_space->user_base;
    child->address_space->user_limit = parent->address_space->user_limit;
    child->address_space->heap_base = parent->address_space->heap_base;
    child->address_space->heap_end = parent->address_space->heap_end;
    child->address_space->stack_top = parent->address_space->stack_top;
    
    // Clone vm_regions (metadata only, physical frames are shared via COW in vmm)
    vm_region_t *parent_region = parent->vm_regions;
    vm_region_t **child_region_ptr = &child->vm_regions;
    while (parent_region) {
        vm_region_t *new_region = (vm_region_t *)kmalloc(sizeof(vm_region_t), KMALLOC_ZERO);
        *new_region = *parent_region;
        new_region->owner = child;
        new_region->next = NULL;
        
        if (new_region->file) {
            new_region->file->refcount++;
        }
        
        *child_region_ptr = new_region;
        child_region_ptr = &new_region->next;
        parent_region = parent_region->next;
    }
    
    // Duplicate FDs
    for (int i = 0; i < MAX_FDS; i++) {
        if (parent->fd_table[i]) {
            child->fd_table[i] = parent->fd_table[i];
            child->fd_table[i]->refcount++;
        }
    }
    
    // Setup Parent-Child relationship
    child->parent = parent;
    list_push_back(&parent->children, child);
    
    // Create child thread
    thread_t *child_thread = thread_create(child->name, NULL, NULL);
    child_thread->process = child;
    list_push_back(&child->threads, child_thread);
    
    // Setup child thread's kernel stack to return to userspace via fork_ret
    uint32_t *stack_top = (uint32_t *)((uint32_t)child_thread->kernel_stack + child_thread->kernel_stack_size);
    
    // 1. Push a copy of the trap frame (registers_t)
    stack_top -= (sizeof(registers_t) / sizeof(uint32_t));
    registers_t *child_regs = (registers_t *)stack_top;
    *child_regs = *regs;
    child_regs->eax = 0; // Return 0 to the child
    
    // 2. Push the context_switch frame for fork_ret
    *(--stack_top) = (uint32_t)fork_ret; // ret target
    *(--stack_top) = 0x202;              // eflags
    *(--stack_top) = 0;                  // edi
    *(--stack_top) = 0;                  // esi
    *(--stack_top) = 0;                  // ebx
    *(--stack_top) = 0;                  // ebp
    
    child_thread->context.esp = (uint32_t)stack_top;
    
    // Enqueue child to run
    scheduler_enqueue(child_thread);
    
    return child->pid;
}

address_space_t *address_space_create(void) {
    address_space_t *as = (address_space_t *)kmalloc(sizeof(address_space_t), KMALLOC_ZERO);
    if (!as) return NULL;
    
    as->page_directory = vmm_clone_directory();
    if (!as->page_directory) {
        kfree(as);
        return NULL;
    }
    
    as->user_base = 0x400000;
    as->user_limit = 0x400000;
    as->mmap_next = 0x60000000;
    
    // ASLR Infrastructure (A7.2.3): Heap base randomization hook
    as->heap_base = 0x8000000; // Future: aslr_get_heap_base()
    as->heap_end = as->heap_base;
    
    // ASLR Infrastructure (A7.2.3): Stack top randomization hook
    as->stack_top = 0xBFFFF000; // Future: aslr_get_stack_top()
    
    return as;
}

void address_space_destroy(address_space_t *as) {
    if (!as) return;
    
    if (as->page_directory) {
        vmm_destroy_directory(as->page_directory);
    }
    
    kfree(as);
}

void switch_address_space(address_space_t *as) {
    if (!as || !as->page_directory) return;
    vmm_switch_directory(as->page_directory);
}

extern void jump_to_usermode(uint32_t entry_point, uint32_t user_stack);
#include "kernel/pmm.h"

int process_exec(process_t *proc, exec_image_t *image) {
    if (!proc || !image || !image->space) return -1;
    
    // Assign the address space to the process
    proc->address_space = image->space;
    proc->vm_regions = image->regions;
    if (proc->vm_regions) {
        proc->vm_regions->owner = proc;
    }
    
    // Switch to process's address space
    switch_address_space(proc->address_space);
    
    // Jump to usermode
    jump_to_usermode((uint32_t)image->entry, (uint32_t)image->user_stack);
    
    return 0; // Should never reach here
}
