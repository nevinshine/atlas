#include "kernel/block.h"
#include "kernel/heap.h"
#include "lib/memory.h"
#include "lib/string.h"
#include "kernel/log.h"

#define RAMDISK_SIZE (1024 * 1024) // 1 MiB
#define RAMDISK_BLOCK_SIZE 512
#define RAMDISK_BLOCK_COUNT (RAMDISK_SIZE / RAMDISK_BLOCK_SIZE)

static uint8_t *ramdisk_data;
static block_device_t ramdisk_dev;

static int ramdisk_read_blocks(struct block_device *bdev, uint64_t lba, uint32_t count, void *buffer) {
    if (lba + count > bdev->block_count) return -1;
    if (lba + count < lba) return -1; // Overflow
    
    uint8_t *src = ramdisk_data + (lba * bdev->block_size);
    memcpy(buffer, src, count * bdev->block_size);
    return count;
}

static int ramdisk_write_blocks(struct block_device *bdev, uint64_t lba, uint32_t count, const void *buffer) {
    if (lba + count > bdev->block_count) return -1;
    if (lba + count < lba) return -1; // Overflow
    
    uint8_t *dst = ramdisk_data + (lba * bdev->block_size);
    memcpy(dst, buffer, count * bdev->block_size);
    return count;
}

static block_device_ops_t ramdisk_ops = {
    .read_blocks = ramdisk_read_blocks,
    .write_blocks = ramdisk_write_blocks
};

#include "../tests/userspace/ext2_blob.h"

void ramdisk_init(void) {
    ramdisk_data = kmalloc(RAMDISK_SIZE, KMALLOC_ZERO);
    if (!ramdisk_data) {
        log_error("Failed to allocate ramdisk");
        return;
    }
    
    // Copy the ext2 image into the ramdisk
    if (ext2_img_len > RAMDISK_SIZE) {
        log_error("ext2.img is larger than ramdisk size");
        return;
    }
    memcpy(ramdisk_data, ext2_img, ext2_img_len);
    
    strcpy(ramdisk_dev.device.name, "ram0");
    ramdisk_dev.block_size = RAMDISK_BLOCK_SIZE;
    ramdisk_dev.block_count = RAMDISK_BLOCK_COUNT;
    ramdisk_dev.ops = &ramdisk_ops;
    ramdisk_dev.private_data = ramdisk_data;
    
    if (block_device_register(&ramdisk_dev) != 0) {
        log_error("Failed to register ramdisk block device");
    } else {
        log_info("RAM disk registered at /dev/ram0 (%d blocks of %d bytes)", RAMDISK_BLOCK_COUNT, RAMDISK_BLOCK_SIZE);
    }
}
