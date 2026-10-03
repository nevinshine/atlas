#include <atlas/memory.h>

#define ALIGN_UP(x) (((x) + 7) & ~7)
#define HEAP_ALIGNMENT 8

typedef struct heap_block {
    size_t size;
    int is_free;
    struct heap_block *next;
    struct heap_block *prev;
} heap_block_t;

typedef struct {
    void *heap_start;
    void *heap_end;
    heap_block_t *free_list;
    size_t allocated_bytes;
    size_t free_bytes;
    size_t allocation_count;
} heap_manager_t;

static heap_manager_t manager = {0};

#define INITIAL_HEAP_SIZE (4 * 1024 * 1024) // 4 MB

static void heap_expand(size_t size) {
    // Round up size to page boundary
    size_t alloc_size = (size + 4095) & ~4095;
    if (alloc_size < INITIAL_HEAP_SIZE && !manager.heap_start) {
        alloc_size = INITIAL_HEAP_SIZE;
    }

    void *ptr = sbrk(alloc_size);
    if (ptr == (void *)-1) {
        return; // OOM
    }

    heap_block_t *block = (heap_block_t *)ptr;
    block->size = alloc_size - sizeof(heap_block_t);
    block->is_free = 1;
    block->next = NULL;
    block->prev = NULL;

    if (!manager.heap_start) {
        manager.heap_start = ptr;
        manager.heap_end = (char *)ptr + alloc_size;
        manager.free_list = block;
    } else {
        // If sbrk returned contiguous memory to our heap_end, we could coalesce.
        // For simplicity, we just push to the front of the free list.
        // A better implementation would check if ptr == manager.heap_end and merge with the last block.
        // For now, we maintain the simple list structure.
        block->next = manager.free_list;
        if (manager.free_list) {
            manager.free_list->prev = block;
        }
        manager.free_list = block;
        
        if ((char *)ptr + alloc_size > (char *)manager.heap_end) {
            manager.heap_end = (char *)ptr + alloc_size;
        }
    }
    
    manager.free_bytes += block->size;
}

void *atlas_malloc(size_t size) {
    if (size == 0) return NULL;

    size = ALIGN_UP(size);

    if (!manager.heap_start) {
        heap_expand(size + sizeof(heap_block_t));
    }

    heap_block_t *curr = manager.free_list;
    while (curr) {
        if (curr->is_free && curr->size >= size) {
            // Split block if possible
            if (curr->size >= size + sizeof(heap_block_t) + HEAP_ALIGNMENT) {
                heap_block_t *new_block = (heap_block_t *)((char *)curr + sizeof(heap_block_t) + size);
                new_block->size = curr->size - size - sizeof(heap_block_t);
                new_block->is_free = 1;
                
                // Insert new block after curr
                new_block->next = curr->next;
                new_block->prev = curr;
                if (curr->next) {
                    curr->next->prev = new_block;
                }
                curr->next = new_block;
                curr->size = size;
                
                manager.free_bytes -= sizeof(heap_block_t);
            }

            curr->is_free = 0;
            manager.allocated_bytes += curr->size;
            manager.free_bytes -= curr->size;
            manager.allocation_count++;
            
            return (void *)((char *)curr + sizeof(heap_block_t));
        }
        curr = curr->next;
    }

    // Need more memory
    heap_expand(size + sizeof(heap_block_t));
    
    // Try again
    curr = manager.free_list;
    while (curr) {
        if (curr->is_free && curr->size >= size) {
            // Found it
            if (curr->size >= size + sizeof(heap_block_t) + HEAP_ALIGNMENT) {
                heap_block_t *new_block = (heap_block_t *)((char *)curr + sizeof(heap_block_t) + size);
                new_block->size = curr->size - size - sizeof(heap_block_t);
                new_block->is_free = 1;
                
                new_block->next = curr->next;
                new_block->prev = curr;
                if (curr->next) {
                    curr->next->prev = new_block;
                }
                curr->next = new_block;
                curr->size = size;
                manager.free_bytes -= sizeof(heap_block_t);
            }
            curr->is_free = 0;
            manager.allocated_bytes += curr->size;
            manager.free_bytes -= curr->size;
            manager.allocation_count++;
            return (void *)((char *)curr + sizeof(heap_block_t));
        }
        curr = curr->next;
    }
    
    return NULL;
}

void atlas_free(void *ptr) {
    if (!ptr) return;

    heap_block_t *block = (heap_block_t *)((char *)ptr - sizeof(heap_block_t));
    if (block->is_free) return; // Double free

    block->is_free = 1;
    manager.allocated_bytes -= block->size;
    manager.free_bytes += block->size;
    manager.allocation_count--;

    // Coalesce right
    if (block->next && block->next->is_free) {
        if ((char *)block + sizeof(heap_block_t) + block->size == (char *)block->next) {
            block->size += sizeof(heap_block_t) + block->next->size;
            block->next = block->next->next;
            if (block->next) {
                block->next->prev = block;
            }
            manager.free_bytes += sizeof(heap_block_t);
        }
    }

    // Coalesce left
    if (block->prev && block->prev->is_free) {
        if ((char *)block->prev + sizeof(heap_block_t) + block->prev->size == (char *)block) {
            block->prev->size += sizeof(heap_block_t) + block->size;
            block->prev->next = block->next;
            if (block->next) {
                block->next->prev = block->prev;
            }
            manager.free_bytes += sizeof(heap_block_t);
        }
    }
}

void *atlas_calloc(size_t nmemb, size_t size) {
    size_t total = nmemb * size;
    void *ptr = atlas_malloc(total);
    if (ptr) {
        char *p = (char *)ptr;
        for (size_t i = 0; i < total; i++) p[i] = 0;
    }
    return ptr;
}

void *atlas_realloc(void *ptr, size_t size) {
    if (!ptr) return atlas_malloc(size);
    if (size == 0) {
        atlas_free(ptr);
        return NULL;
    }
    
    heap_block_t *block = (heap_block_t *)((char *)ptr - sizeof(heap_block_t));
    if (block->size >= size) {
        return ptr; // Already large enough
    }
    
    void *new_ptr = atlas_malloc(size);
    if (!new_ptr) return NULL;
    
    char *src = (char *)ptr;
    char *dst = (char *)new_ptr;
    for (size_t i = 0; i < block->size; i++) {
        dst[i] = src[i];
    }
    
    atlas_free(ptr);
    return new_ptr;
}
