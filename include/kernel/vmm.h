#ifndef ATLAS_VMM_H
#define ATLAS_VMM_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#define KERNEL_VIRT_BASE 0xC0000000

#define PHYS_TO_VIRT(p) ((uint32_t)(p) + KERNEL_VIRT_BASE)
#define VIRT_TO_PHYS(v) ((uint32_t)(v) - KERNEL_VIRT_BASE)

// Page Table Flags
#define PAGE_PRESENT  0x01
#define PAGE_WRITE    0x02
#define PAGE_USER     0x04

void vmm_init(void);
void vmm_map(uint32_t virt, uint32_t phys, uint32_t flags);
void vmm_unmap(uint32_t virt);
uint32_t vmm_translate(uint32_t virt);
bool vmm_is_mapped(uint32_t virt);
void vmm_invalidate(uint32_t virt);
uint32_t *vmm_clone_directory(void);
void vmm_switch_directory(uint32_t *phys_dir);

#endif
