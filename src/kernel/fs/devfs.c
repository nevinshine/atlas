#include "kernel/fs/devfs.h"
#include "kernel/heap.h"
#include "lib/string.h"
#include "lib/memory.h"
#include "kernel/device.h"
#include "kernel/log.h"

static vfs_ops_t devfs_device_ops;
static vfs_ops_t devfs_dir_ops;
static filesystem_t devfs_fs;
static vfs_node_t *devfs_root_node = NULL;

static int devfs_open(vfs_node_t *node, file_t *file) {
    if (!node || !node->device) return -1;
    device_t *dev = (device_t *)node->device;
    if (dev->ops && dev->ops->open) {
        return dev->ops->open(dev, file->flags);
    }
    return 0; // Default success
}

static void devfs_close(file_t *file) {
    if (!file || !file->node || !file->node->device) return;
    device_t *dev = (device_t *)file->node->device;
    if (dev->ops && dev->ops->close) {
        dev->ops->close(dev);
    }
}

static int devfs_read(file_t *file, void *buffer, size_t size, uint32_t offset) {
    if (!file || !file->node || !file->node->device) return -1;
    device_t *dev = (device_t *)file->node->device;
    if (dev->ops && dev->ops->read) {
        return dev->ops->read(dev, buffer, size, offset);
    }
    return -1;
}

static int devfs_write(file_t *file, const void *buffer, size_t size, uint32_t offset) {
    if (!file || !file->node || !file->node->device) return -1;
    device_t *dev = (device_t *)file->node->device;
    if (dev->ops && dev->ops->write) {
        return dev->ops->write(dev, buffer, size, offset);
    }
    return -1;
}

static int devfs_ioctl(vfs_node_t *node, uint32_t request, void *arg) {
    if (!node || !node->device) return -ENOTSUP;
    device_t *dev = (device_t *)node->device;
    if (dev->ops && dev->ops->ioctl) {
        return dev->ops->ioctl(dev, request, arg);
    }
    return -ENOTSUP;
}

static vfs_node_t *devfs_finddir(vfs_node_t *node, const char *name) {
    if (!node || node != devfs_root_node) return NULL;
    
    device_t *dev = device_find(name);
    if (!dev) return NULL;
    
    // Dynamically allocate a VFS node for the device
    // In a full implementation, we might cache these nodes.
    vfs_node_t *dev_node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), KMALLOC_ZERO);
    if (!dev_node) return NULL;
    
    strcpy(dev_node->name, dev->name);
    if (dev->type == DEVICE_TYPE_CHAR) dev_node->flags = FS_CHARDEVICE;
    else if (dev->type == DEVICE_TYPE_BLOCK) dev_node->flags = FS_BLOCKDEVICE;
    else dev_node->flags = FS_FILE;
    
    dev_node->ops = &devfs_device_ops;
    dev_node->device = dev; // Link to the device_t
    
    return dev_node;
}

static vfs_node_t *devfs_mount_cb(const char *device) {
    (void)device;
    if (!devfs_root_node) {
        devfs_root_node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), KMALLOC_ZERO);
        strcpy(devfs_root_node->name, "dev");
        devfs_root_node->flags = FS_DIRECTORY;
        devfs_root_node->ops = &devfs_dir_ops;
    }
    return devfs_root_node;
}

void devfs_init(void) {
    memset(&devfs_device_ops, 0, sizeof(vfs_ops_t));
    devfs_device_ops.open = devfs_open;
    devfs_device_ops.close = devfs_close;
    devfs_device_ops.read = devfs_read;
    devfs_device_ops.write = devfs_write;
    devfs_device_ops.ioctl = devfs_ioctl;
    
    memset(&devfs_dir_ops, 0, sizeof(vfs_ops_t));
    devfs_dir_ops.finddir = devfs_finddir;
    
    strcpy(devfs_fs.name, "devfs");
    devfs_fs.mount = devfs_mount_cb;
    
    vfs_register_fs(&devfs_fs);
}

