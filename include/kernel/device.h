#ifndef ATLAS_DEVICE_H
#define ATLAS_DEVICE_H

#include <stdint.h>
#include <stddef.h>
#include "kernel/fs/vfs.h"

// Forward declaration
struct device;

typedef enum {
    DEVICE_TYPE_CHAR,
    DEVICE_TYPE_BLOCK,
    DEVICE_TYPE_VIRTUAL
} device_type_t;

typedef struct device_ops {
    int (*open)(struct device *dev, uint32_t flags);
    int (*close)(struct device *dev);
    int (*read)(struct device *dev, void *buffer, size_t size, uint32_t offset);
    int (*write)(struct device *dev, const void *buffer, size_t size, uint32_t offset);
    int (*ioctl)(struct device *dev, uint32_t request, void *arg);
} device_ops_t;

typedef struct device {
    char name[32];
    device_type_t type;
    device_ops_t *ops;
    void *private_data;
    struct device *next;
} device_t;

// Standard Error Codes
#define ENOTSUP 95
#define ENOSYS  38

void device_manager_init(void);
int device_register(device_t *dev);
device_t *device_find(const char *name);

#endif
