#include "kernel/block.h"
#include "kernel/heap.h"
#include "lib/memory.h"
#include "kernel/sync/spinlock.h"

static int block_vfs_read(struct device *dev, void *buffer, size_t size, uint32_t offset) {
    block_device_t *bdev = (block_device_t *)dev;
    if (!bdev || !bdev->ops || !bdev->ops->read_blocks || size == 0) return 0;

    uint64_t device_capacity = (uint64_t)bdev->block_size * bdev->block_count;
    if (offset >= device_capacity) return 0;
    
    if (offset + size < offset) return -1; 
    if (offset + size > device_capacity) {
        size = device_capacity - offset;
    }

    uint32_t block_size = bdev->block_size;
    uint8_t *user_buf = (uint8_t *)buffer;
    size_t bytes_read = 0;

    uint32_t first_block_offset = offset % block_size;
    uint64_t current_lba = offset / block_size;

    if (first_block_offset != 0) {
        uint32_t to_read = block_size - first_block_offset;
        if (to_read > size) to_read = size;

        uint8_t *bounce = kmalloc(block_size, KMALLOC_ZERO);
        if (!bounce) return -1;
        
        int res = bdev->ops->read_blocks(bdev, current_lba, 1, bounce);
        if (res < 0) {
            kfree(bounce);
            return res;
        }

        memcpy(user_buf, bounce + first_block_offset, to_read);
        kfree(bounce);

        bytes_read += to_read;
        user_buf += to_read;
        current_lba++;
    }

    size_t remaining = size - bytes_read;
    uint32_t full_blocks = remaining / block_size;

    if (full_blocks > 0) {
        int res = bdev->ops->read_blocks(bdev, current_lba, full_blocks, user_buf);
        if (res < 0) {
            return bytes_read > 0 ? (int)bytes_read : res;
        }
        uint32_t aligned_bytes = full_blocks * block_size;
        bytes_read += aligned_bytes;
        user_buf += aligned_bytes;
        current_lba += full_blocks;
        remaining -= aligned_bytes;
    }

    if (remaining > 0) {
        uint8_t *bounce = kmalloc(block_size, KMALLOC_ZERO);
        if (!bounce) return bytes_read > 0 ? (int)bytes_read : -1;
        
        int res = bdev->ops->read_blocks(bdev, current_lba, 1, bounce);
        if (res < 0) {
            kfree(bounce);
            return bytes_read > 0 ? (int)bytes_read : res;
        }

        memcpy(user_buf, bounce, remaining);
        kfree(bounce);
        bytes_read += remaining;
    }

    return (int)bytes_read;
}

static int block_vfs_write(struct device *dev, const void *buffer, size_t size, uint32_t offset) {
    block_device_t *bdev = (block_device_t *)dev;
    if (!bdev || !bdev->ops || !bdev->ops->write_blocks || size == 0) return 0;

    uint64_t device_capacity = (uint64_t)bdev->block_size * bdev->block_count;
    if (offset >= device_capacity) return 0;
    
    if (offset + size < offset) return -1;
    if (offset + size > device_capacity) {
        size = device_capacity - offset;
    }

    uint32_t block_size = bdev->block_size;
    const uint8_t *user_buf = (const uint8_t *)buffer;
    size_t bytes_written = 0;

    uint32_t first_block_offset = offset % block_size;
    uint64_t current_lba = offset / block_size;

    if (first_block_offset != 0) {
        uint32_t to_write = block_size - first_block_offset;
        if (to_write > size) to_write = size;

        uint8_t *bounce = kmalloc(block_size, KMALLOC_ZERO);
        if (!bounce) return -1;
        
        uint32_t flags;
        spin_lock_irqsave(&bdev->rmw_lock, &flags);
        
        int res = -1;
        if (bdev->ops->read_blocks) {
            res = bdev->ops->read_blocks(bdev, current_lba, 1, bounce);
        } else {
            memset(bounce, 0, block_size);
            res = 0;
        }
        
        if (res >= 0) {
            memcpy(bounce + first_block_offset, user_buf, to_write);
            res = bdev->ops->write_blocks(bdev, current_lba, 1, bounce);
        }
        
        spin_unlock_irqrestore(&bdev->rmw_lock, flags);
        kfree(bounce);
        
        if (res < 0) return res;

        bytes_written += to_write;
        user_buf += to_write;
        current_lba++;
    }

    size_t remaining = size - bytes_written;
    uint32_t full_blocks = remaining / block_size;

    if (full_blocks > 0) {
        int res = bdev->ops->write_blocks(bdev, current_lba, full_blocks, user_buf);
        if (res < 0) {
            return bytes_written > 0 ? (int)bytes_written : res;
        }
        uint32_t aligned_bytes = full_blocks * block_size;
        bytes_written += aligned_bytes;
        user_buf += aligned_bytes;
        current_lba += full_blocks;
        remaining -= aligned_bytes;
    }

    if (remaining > 0) {
        uint8_t *bounce = kmalloc(block_size, KMALLOC_ZERO);
        if (!bounce) return bytes_written > 0 ? (int)bytes_written : -1;
        
        uint32_t flags;
        spin_lock_irqsave(&bdev->rmw_lock, &flags);
        
        int res = -1;
        if (bdev->ops->read_blocks) {
            res = bdev->ops->read_blocks(bdev, current_lba, 1, bounce);
        } else {
            memset(bounce, 0, block_size);
            res = 0;
        }
        
        if (res >= 0) {
            memcpy(bounce, user_buf, remaining);
            res = bdev->ops->write_blocks(bdev, current_lba, 1, bounce);
        }
        
        spin_unlock_irqrestore(&bdev->rmw_lock, flags);
        kfree(bounce);
        
        if (res < 0) return bytes_written > 0 ? (int)bytes_written : res;
        
        bytes_written += remaining;
    }

    return (int)bytes_written;
}

static device_ops_t block_dev_ops = {
    .open = NULL,
    .close = NULL,
    .read = block_vfs_read,
    .write = block_vfs_write,
    .ioctl = NULL
};

int block_device_register(block_device_t *bdev) {
    if (!bdev) return -1;
    
    bdev->device.type = DEVICE_TYPE_BLOCK;
    bdev->device.ops = &block_dev_ops;
    bdev->rmw_lock.lock = 0;
    
    return device_register(&bdev->device);
}

block_device_t *block_device_find(const char *name) {
    device_t *dev = device_find(name);
    if (!dev || dev->type != DEVICE_TYPE_BLOCK) return NULL;
    return (block_device_t *)dev;
}
