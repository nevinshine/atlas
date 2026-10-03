#ifndef ATLAS_BLOCK_H
#define ATLAS_BLOCK_H

#include <stdint.h>
#include <stddef.h>
#include "kernel/device.h"
#include "kernel/sync/spinlock.h"

struct block_device;

typedef struct block_device_ops {
    int (*read_blocks)(struct block_device *bdev, uint64_t lba, uint32_t count, void *buffer);
    int (*write_blocks)(struct block_device *bdev, uint64_t lba, uint32_t count, const void *buffer);
} block_device_ops_t;

typedef struct block_device {
    device_t device;

    uint32_t block_size;
    uint64_t block_count;

    const block_device_ops_t *ops;

    void *private_data;

    // Lock to protect read-modify-write for unaligned partial block accesses
    spinlock_t rmw_lock;
} block_device_t;

int block_device_register(block_device_t *bdev);
block_device_t *block_device_find(const char *name);

#endif
