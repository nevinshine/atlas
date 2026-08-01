#ifndef ATLAS_PMM_H
#define ATLAS_PMM_H

#include <stdint.h>
#include <stddef.h>
#include "kernel/multiboot.h"

typedef uint32_t phys_addr_t;

#define PAGE_SIZE 4096
#define MAX_MEMORY_REGIONS 32

typedef struct {
    uint64_t base;
    uint64_t length;
    uint32_t type;
} memory_region_t;

void pmm_init(multiboot_info_t *mboot_info);
phys_addr_t pmm_alloc_frame(void);
void pmm_free_frame(phys_addr_t paddr);
phys_addr_t pmm_alloc_contiguous(size_t frames);

void pmm_print_map(void);
void pmm_print_stats(void);

#endif
