#include "kernel/pmm.h"
#include "kernel/vmm.h"
#include "kernel/log.h"
#include "lib/memory.h"
#include "lib/printf.h"

// Defined in linker.ld
extern uint32_t kernel_start;
extern uint32_t kernel_end;

static memory_region_t regions[MAX_MEMORY_REGIONS];
static size_t region_count = 0;

static uint32_t *frame_bitmap;
static uint32_t total_frames = 0;
static uint32_t used_frames = 0;
static uint32_t total_memory_kb = 0;
static uint32_t reserved_memory_kb = 0;
static phys_addr_t bitmap_paddr;
static size_t bitmap_size_bytes = 0;

// Bitmap manipulation macros
#define BITMAP_SET(bit) (frame_bitmap[(bit) / 32] |= (1 << ((bit) % 32)))
#define BITMAP_CLEAR(bit) (frame_bitmap[(bit) / 32] &= ~(1 << ((bit) % 32)))
#define BITMAP_TEST(bit) (frame_bitmap[(bit) / 32] & (1 << ((bit) % 32)))

static void pmm_reserve_region(phys_addr_t start, size_t size) {
    phys_addr_t align_start = start / PAGE_SIZE;
    phys_addr_t align_end = (start + size + PAGE_SIZE - 1) / PAGE_SIZE;
    
    for (phys_addr_t i = align_start; i < align_end; i++) {
        if (!BITMAP_TEST(i)) {
            BITMAP_SET(i);
            used_frames++;
        }
    }
}

void pmm_init(multiboot_info_t *mboot_info) {
    if (!(mboot_info->flags & (1 << 6))) {
        panic("No memory map provided by Multiboot!");
    }

    multiboot_memory_map_t *mmap = (multiboot_memory_map_t *)mboot_info->mmap_addr;
    uint32_t mmap_length = mboot_info->mmap_length;

    uint32_t highest_address = 0;

    // 1. Discover memory
    while ((uint32_t)mmap < mboot_info->mmap_addr + mmap_length) {
        if (region_count < MAX_MEMORY_REGIONS) {
            regions[region_count].base = mmap->addr;
            regions[region_count].length = mmap->len;
            regions[region_count].type = mmap->type;
            region_count++;
        }
        
        total_memory_kb += mmap->len / 1024;
        if (mmap->type != MULTIBOOT_MEMORY_AVAILABLE) {
            reserved_memory_kb += mmap->len / 1024;
        }

        uint32_t region_end = mmap->addr + mmap->len;
        if (region_end > highest_address) {
            highest_address = region_end;
        }
        
        mmap = (multiboot_memory_map_t *)((uint32_t)mmap + mmap->size + sizeof(mmap->size));
    }

    // 2. Initialize Frame Bitmap
    total_frames = highest_address / PAGE_SIZE;
    bitmap_size_bytes = (total_frames / 8) + ((total_frames % 8) ? 1 : 0);
    
    // Place bitmap immediately after the kernel (in physical memory)
    bitmap_paddr = VIRT_TO_PHYS(&kernel_end);
    
    // We access the bitmap using its virtual address
    frame_bitmap = (uint32_t *)&kernel_end;
    
    // Initially mark everything as USED (safe by default)
    memset(frame_bitmap, 0xFF, bitmap_size_bytes);
    used_frames = total_frames;

    // 3. Mark AVAILABLE regions as FREE
    for (size_t i = 0; i < region_count; i++) {
        if (regions[i].type == MULTIBOOT_MEMORY_AVAILABLE) {
            phys_addr_t align_start = regions[i].base / PAGE_SIZE;
            phys_addr_t align_end = (regions[i].base + regions[i].length) / PAGE_SIZE;
            for (phys_addr_t j = align_start; j < align_end; j++) {
                BITMAP_CLEAR(j);
                used_frames--;
            }
        }
    }

    // 4. Reserve kernel, multiboot info, bitmap, and modules
    phys_addr_t phys_kernel_start = VIRT_TO_PHYS(&kernel_start);
    phys_addr_t phys_kernel_end = VIRT_TO_PHYS(&kernel_end);
    pmm_reserve_region(phys_kernel_start, phys_kernel_end - phys_kernel_start);
    pmm_reserve_region(bitmap_paddr, bitmap_size_bytes);

    // Reserve frame 0 — physical address 0x0 contains the real-mode IVT/BDA
    // and returning 0 from pmm_alloc_frame() is indistinguishable from NULL.
    pmm_reserve_region(0x0, PAGE_SIZE);
    
    // Reserve multiboot struct itself
    // Note: mboot_info was already translated to virtual by boot.s, but we need physical here
    pmm_reserve_region(VIRT_TO_PHYS(mboot_info), sizeof(multiboot_info_t));
    
    // Reserve modules
    if (mboot_info->flags & (1 << 3)) {
        multiboot_module_t *mods = (multiboot_module_t *)mboot_info->mods_addr;
        for (uint32_t i = 0; i < mboot_info->mods_count; i++) {
            pmm_reserve_region(mods[i].mod_start, mods[i].mod_end - mods[i].mod_start);
        }
    }
}

phys_addr_t pmm_alloc_frame(void) {
    for (uint32_t i = 0; i < total_frames; i++) {
        if (!BITMAP_TEST(i)) {
            BITMAP_SET(i);
            used_frames++;
            return i * PAGE_SIZE;
        }
    }
    panic("Out of physical memory!");
    return 0; // unreachable
}

void pmm_free_frame(phys_addr_t paddr) {
    uint32_t frame = paddr / PAGE_SIZE;
    if (frame < total_frames) {
        if (BITMAP_TEST(frame)) {
            BITMAP_CLEAR(frame);
            used_frames--;
        }
    }
}

phys_addr_t pmm_alloc_contiguous(size_t frames) {
    uint32_t start_frame = 0;
    uint32_t free_run = 0;

    for (uint32_t i = 0; i < total_frames; i++) {
        if (!BITMAP_TEST(i)) {
            if (free_run == 0) start_frame = i;
            free_run++;
            if (free_run == frames) {
                for (uint32_t j = start_frame; j < start_frame + frames; j++) {
                    BITMAP_SET(j);
                    used_frames++;
                }
                return start_frame * PAGE_SIZE;
            }
        } else {
            free_run = 0;
        }
    }
    panic("Failed to allocate %d contiguous frames!", frames);
    return 0; // unreachable
}

void pmm_print_map(void) {
    log_info("=== Physical Memory Map ===");
    for (size_t i = 0; i < region_count; i++) {
        const char *type_str = (regions[i].type == MULTIBOOT_MEMORY_AVAILABLE) ? "Available" : "Reserved";
        log_info("0x%x - 0x%x %s", 
                 (uint32_t)regions[i].base, 
                 (uint32_t)(regions[i].base + regions[i].length), 
                 type_str);
    }
}

void pmm_print_stats(void) {
    log_info("=== Memory Statistics ===");
    log_info("Total RAM:  %d KB", total_memory_kb);
    log_info("Reserved:   %d KB", reserved_memory_kb);
    log_info("Total Frames: %d", total_frames);
    log_info("Used Frames:  %d", used_frames);
    log_info("Free Frames:  %d", total_frames - used_frames);
    log_info("Bitmap Size:  %d B", bitmap_size_bytes);
    
    uint32_t kernel_start_val = (uint32_t)&kernel_start;
    uint32_t kernel_end_val = (uint32_t)&kernel_end;
    log_info("Kernel: 0x%x - 0x%x", kernel_start_val, kernel_end_val);
}
