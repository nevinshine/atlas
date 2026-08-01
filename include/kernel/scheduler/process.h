#ifndef ATLAS_PROCESS_H
#define ATLAS_PROCESS_H

#include <stdint.h>
#include "kernel/list.h"
#include "kernel/vmm.h"
#include "kernel/fs/vfs.h"

typedef struct vm_region {
    uintptr_t start;
    uintptr_t end;
    uint32_t flags;
    struct vm_region *next;
} vm_region_t;

typedef struct address_space {
    uint32_t *page_directory; // Physical address of the page directory
    
    uintptr_t user_base;
    uintptr_t user_limit;
    
    uintptr_t heap_base;
    uintptr_t heap_end;
    
    uintptr_t stack_top;
} address_space_t;

typedef struct process {
    uint32_t pid;
    char name[32];
    
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
} exec_image_t;

/* Process lifecycle */
process_t *process_create(const char *name);
void process_destroy(process_t *proc);
int process_exec(process_t *proc, exec_image_t *image);
void process_exit(int status);

/* Address space management */
address_space_t *address_space_create(void);
void address_space_destroy(address_space_t *as);
void switch_address_space(address_space_t *as);

#endif /* ATLAS_PROCESS_H */
