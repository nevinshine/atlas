#include "kernel/scheduler/process.h"
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
    
    log_info("Process destroyed: PID %u '%s'", proc->pid, proc->name);
    
    for (int i = 0; i < MAX_FDS; i++) {
        if (proc->fd_table[i]) {
            vfs_close(proc->fd_table[i]);
            proc->fd_table[i] = NULL;
        }
    }
    
    if (proc->address_space) {
        address_space_destroy(proc->address_space);
    }
    
    // Free vm_regions
    vm_region_t *curr = proc->vm_regions;
    while (curr) {
        vm_region_t *next = curr->next;
        kfree(curr);
        curr = next;
    }
    
    kfree(proc);
}

extern void scheduler_exit_current(void);
#include "kernel/scheduler/thread.h"
extern thread_t *current_thread;

void process_exit(int status) {
    if (current_thread && current_thread->process) {
        log_info("Process %d exited with status %d", current_thread->process->pid, status);
    }
    // In a real kernel, we would save status, notify parent, etc.
    // For now, exit the thread.
    scheduler_exit_current();
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
    as->heap_base = 0x8000000;
    as->heap_end = 0x8000000;
    as->stack_top = 0xBFFFF000;
    
    return as;
}

void address_space_destroy(address_space_t *as) {
    if (!as) return;
    // In a real OS, free physical pages mapped, then page tables, then directory.
    // For now, just free the struct.
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
    
    // Switch to process's address space
    switch_address_space(proc->address_space);
    
    // Jump to usermode
    jump_to_usermode((uint32_t)image->entry, (uint32_t)image->user_stack);
    
    return 0; // Should never reach here
}
