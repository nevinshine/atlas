#include "kernel/heap.h"
#include "kernel/pmm.h"
#include "kernel/vmm.h"
#include "kernel/log.h"
#include "lib/memory.h"
#include "lib/printf.h"

#define HEAP_START 0xC0400000
#define HEAP_MAX   0xD0000000

#define CONFIG_HEAP_DEBUG

static struct heap_block *heap_head = NULL;
static uint32_t current_heap_end = HEAP_START;

// Statistics
static size_t stat_mapped_pages = 0;
static size_t stat_blocks_allocated = 0;
static size_t stat_free_blocks = 0;
static size_t stat_alloc_failures = 0;
static size_t stat_heap_expansions = 0;

static void merge_free_blocks(struct heap_block *block) {
    if (!block || !block->is_free) return;
    
    // Try to merge with next
    if (block->next && block->next->is_free) {
        block->capacity += sizeof(struct heap_block) + block->next->capacity;
        block->next = block->next->next;
        if (block->next) {
            block->next->prev = block;
        }
        stat_free_blocks--;
    }
    
    // Try to merge with prev
    if (block->prev && block->prev->is_free) {
        struct heap_block *prev = block->prev;
        prev->capacity += sizeof(struct heap_block) + block->capacity;
        prev->next = block->next;
        if (prev->next) {
            prev->next->prev = prev;
        }
        stat_free_blocks--;
    }
}

static bool expand_heap(size_t required_bytes) {
    // Calculate total pages needed, keeping in mind the header if we need a new block
    size_t total_required = required_bytes;
    
    // Check if the last block is free. If so, we only need to expand by the difference
    struct heap_block *last = heap_head;
    if (last) {
        while (last->next) {
            last = last->next;
        }
    }
    
    if (last && last->is_free) {
        if (last->capacity >= required_bytes) return true; // Shouldn't happen if expand_heap is called, but safe
        total_required = required_bytes - last->capacity;
    } else {
        total_required += sizeof(struct heap_block);
    }
    
    // Round up to nearest page
    size_t pages_needed = (total_required + PAGE_SIZE - 1) / PAGE_SIZE;
    
    if (current_heap_end + (pages_needed * PAGE_SIZE) > HEAP_MAX) {
        log_error("Heap expansion failed: out of virtual memory!");
        return false;
    }
    
    for (size_t i = 0; i < pages_needed; i++) {
        phys_addr_t frame = pmm_alloc_frame();
        if (!frame) {
            log_error("Heap expansion failed: out of physical memory!");
            return false;
        }
        vmm_map(current_heap_end, frame, PAGE_PRESENT | PAGE_WRITE);
        current_heap_end += PAGE_SIZE;
        stat_mapped_pages++;
    }
    
    stat_heap_expansions++;
    
    if (last && last->is_free) {
        last->capacity += pages_needed * PAGE_SIZE;
    } else {
        struct heap_block *new_block = (struct heap_block *)(current_heap_end - (pages_needed * PAGE_SIZE));
        new_block->magic = HEAP_MAGIC_FREE;
        new_block->capacity = (pages_needed * PAGE_SIZE) - sizeof(struct heap_block);
        new_block->is_free = true;
        new_block->flags = 0;
        new_block->next = NULL;
        new_block->prev = last;
        
        if (last) {
            last->next = new_block;
        } else {
            heap_head = new_block;
        }
        stat_free_blocks++;
    }
    
    return true;
}

void heap_init(void) {
    // Initial expansion to kickstart the heap (e.g., 4 pages = 16KB)
    if (!expand_heap(PAGE_SIZE * 4)) {
        panic("Failed to initialize heap");
    }
    log_info("Dynamic Kernel Heap initialized at 0x%x", HEAP_START);
}

void *kmalloc(size_t size, uint32_t flags) {
    if (size == 0) return NULL;
    
    // Ensure size is a multiple of 4 for alignment
    if (size % 4 != 0) {
        size += 4 - (size % 4);
    }

    // TODO: Handle KMALLOC_ALIGN4K later, for now just basic first fit
    
    struct heap_block *curr = heap_head;
    while (curr) {
        if (curr->is_free && curr->capacity >= size) {
            // Found a block. Can we split it?
            if (curr->capacity > size + sizeof(struct heap_block) + 4) {
                struct heap_block *new_block = (struct heap_block *)((uint32_t)curr + sizeof(struct heap_block) + size);
                new_block->magic = HEAP_MAGIC_FREE;
                new_block->capacity = curr->capacity - size - sizeof(struct heap_block);
                new_block->is_free = true;
                new_block->flags = 0;
                new_block->next = curr->next;
                new_block->prev = curr;
                
                if (new_block->next) {
                    new_block->next->prev = new_block;
                }
                
                curr->next = new_block;
                curr->capacity = size;
                stat_free_blocks++;
            }
            
            curr->is_free = false;
            curr->magic = HEAP_MAGIC_ALLOC;
            curr->flags = flags;
            stat_free_blocks--;
            stat_blocks_allocated++;
            
            void *ptr = (void *)((uint32_t)curr + sizeof(struct heap_block));
            if (flags & KMALLOC_ZERO) {
                memset(ptr, 0, curr->capacity);
            }
            
            return ptr;
        }
        curr = curr->next;
    }
    
    // No suitable block found, expand the heap
    if (expand_heap(size)) {
        return kmalloc(size, flags); // Try again
    }
    
    stat_alloc_failures++;
    return NULL;
}

void kfree(void *ptr) {
    if (!ptr) return;
    
    struct heap_block *block = (struct heap_block *)((uint32_t)ptr - sizeof(struct heap_block));
    
#ifdef CONFIG_HEAP_DEBUG
    if (block->magic == HEAP_MAGIC_FREE) {
        panic("Double free detected! block=0x%x", (uint32_t)block);
    }
    if (block->magic != HEAP_MAGIC_ALLOC) {
        panic("Corrupted heap block or invalid pointer! block=0x%x, magic=0x%x", (uint32_t)block, block->magic);
    }
#endif

    block->is_free = true;
    block->magic = HEAP_MAGIC_FREE;
    stat_blocks_allocated--;
    stat_free_blocks++;
    
#ifdef CONFIG_HEAP_DEBUG
    // Poison the freed memory to catch use-after-free
    memset(ptr, 0xCC, block->capacity);
#endif

    merge_free_blocks(block);
}

void *kcalloc(size_t n, size_t size) {
    return kmalloc(n * size, KMALLOC_ZERO);
}

void *krealloc(void *ptr, size_t size, uint32_t flags) {
    if (!ptr) return kmalloc(size, flags);
    if (size == 0) {
        kfree(ptr);
        return NULL;
    }
    
    struct heap_block *block = (struct heap_block *)((uint32_t)ptr - sizeof(struct heap_block));
    
#ifdef CONFIG_HEAP_DEBUG
    if (block->magic != HEAP_MAGIC_ALLOC) {
        panic("krealloc on invalid/freed block! block=0x%x", (uint32_t)block);
    }
#endif

    // Align size
    if (size % 4 != 0) {
        size += 4 - (size % 4);
    }
    
    if (block->capacity >= size) {
        // Shrinking or fits perfectly.
        // TODO: Could split if shrinking by a lot, but this is fine for now
        return ptr;
    }
    
    // Try to merge with next block if it's free and large enough
    if (block->next && block->next->is_free) {
        size_t combined = block->capacity + sizeof(struct heap_block) + block->next->capacity;
        if (combined >= size) {
            // Expand into the next block
            block->capacity = combined;
            block->next = block->next->next;
            if (block->next) {
                block->next->prev = block;
            }
            stat_free_blocks--;
            
            // TODO: Could split the remainder if large enough
            return ptr;
        }
    }
    
    // Fallback: Allocate new block, copy, free old
    void *new_ptr = kmalloc(size, flags);
    if (new_ptr) {
        memcpy(new_ptr, ptr, block->capacity); // copy old data
        kfree(ptr);
    }
    return new_ptr;
}

void heap_dump(void) {
    log_info("========== HEAP STATISTICS ==========");
    log_info("Pages mapped         : %u", stat_mapped_pages);
    log_info("Heap expansions      : %u", stat_heap_expansions);
    log_info("Blocks allocated     : %u", stat_blocks_allocated);
    log_info("Free blocks          : %u", stat_free_blocks);
    log_info("Allocation failures  : %u", stat_alloc_failures);
    
    size_t total_free_bytes = 0;
    size_t total_alloc_bytes = 0;
    size_t largest_free = 0;
    size_t smallest_free = 0xFFFFFFFF;
    
    struct heap_block *curr = heap_head;
    while (curr) {
        if (curr->is_free) {
            total_free_bytes += curr->capacity;
            if (curr->capacity > largest_free) largest_free = curr->capacity;
            if (curr->capacity < smallest_free) smallest_free = curr->capacity;
        } else {
            total_alloc_bytes += curr->capacity;
        }
        curr = curr->next;
    }
    
    if (smallest_free == 0xFFFFFFFF) smallest_free = 0;
    
    size_t total_bytes = total_free_bytes + total_alloc_bytes;
    uint32_t frag_percent = total_bytes ? (stat_free_blocks * 100) / (total_bytes / 32 + 1) : 0; // naive fragmentation metric
    
    log_info("Allocated bytes      : %u", total_alloc_bytes);
    log_info("Free bytes           : %u", total_free_bytes);
    log_info("Largest free block   : %u", largest_free);
    log_info("Smallest free block  : %u", smallest_free);
    // log_info("Fragmentation        : %u%%", frag_percent);
    log_info("=====================================");
}
