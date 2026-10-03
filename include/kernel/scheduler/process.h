#ifndef ATLAS_PROCESS_H
#define ATLAS_PROCESS_H

#include <stdint.h>
#include "kernel/list.h"
#include "kernel/vmm.h"
#include "kernel/fs/vfs.h"
#include "kernel/sync/waitqueue.h"

typedef struct process process_t; // Forward declaration

typedef enum {
    PROCESS_NEW,
    PROCESS_RUNNING,
    PROCESS_EXITING,
    PROCESS_ZOMBIE,
    PROCESS_DESTROYED
} process_state_t;

typedef struct vm_region {
    uintptr_t start;
    uintptr_t end;
    uint32_t flags; // Memory permissions (PAGE_PRESENT, PAGE_WRITE, PAGE_USER)
    
    // Type and Mapping properties
    int is_anonymous; // 1 if anonymous, 0 if file-backed
    int is_shared;    // 1 if MAP_SHARED, 0 if MAP_PRIVATE
    int is_lazy;      // 1 if demand paged, 0 if eager allocation
    
    // File backing
    file_t *file;
    uint32_t offset;
    
    // Ownership
    process_t *owner;
    
    struct vm_region *next;
} vm_region_t;

typedef struct address_space {
    uint32_t *page_directory; // Physical address of the page directory
    
    uintptr_t user_base;
    uintptr_t user_limit;
    
    uintptr_t heap_base;
    uintptr_t heap_end;
    
    uintptr_t mmap_next;
    
    uintptr_t stack_top;
} address_space_t;

typedef struct process {
    uint32_t pid;
    char name[32];
    
    process_state_t state;
    int exit_status;
    uint32_t generation;
    
    struct process *parent;
    list_t children;          // List of child processes
    
    wait_queue_t exit_wait_queue; // Parent waits on this for waitpid
    
    address_space_t *address_space;
    vm_region_t *vm_regions;
#define MAX_FDS 32
    file_t *fd_table[MAX_FDS];
    
    list_t threads; // List of thread_t
} process_t;

typedef struct exec_image {
    void *entry;
    void *user_stack;
    address_space_t *space;
    vm_region_t *regions; // Initial regions like stack
} exec_image_t;

/* Process lifecycle */
process_t *process_create(const char *name);
void process_destroy(process_t *proc);
int process_exec(process_t *proc, exec_image_t *image);
void process_exit(int status);
int process_waitpid(int pid, int *status);

#include "kernel/interrupts.h"
int process_fork(registers_t *regs);

/* Address space management */
address_space_t *address_space_create(void);
void address_space_destroy(address_space_t *as);
void switch_address_space(address_space_t *as);

#endif /* ATLAS_PROCESS_H */
