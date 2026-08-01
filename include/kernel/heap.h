#ifndef ATLAS_HEAP_H
#define ATLAS_HEAP_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#define HEAP_MAGIC_ALLOC 0xDEADBEEF
#define HEAP_MAGIC_FREE  0xBADC0FFE

#define KMALLOC_NORMAL   0x0
#define KMALLOC_ZERO     0x1
#define KMALLOC_ALIGN4K  0x2

struct heap_block {
    uint32_t magic;
    size_t capacity;      // bytes available in this block
    bool is_free;
    uint32_t flags;       // future extensions
    struct heap_block *next;
    struct heap_block *prev;
};

void heap_init(void);
void *kmalloc(size_t size, uint32_t flags);
void kfree(void *ptr);
void *kcalloc(size_t n, size_t size);
void *krealloc(void *ptr, size_t size, uint32_t flags);
void heap_dump(void);

#endif
