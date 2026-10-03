#include "kernel/device.h"
#include "kernel/log.h"
#include "lib/string.h"

static device_t *device_list = NULL;

void device_manager_init(void) {
    device_list = NULL;
    log_info("Device Manager initialized.");
}

int device_register(device_t *dev) {
    if (!dev) return -1;
    
    // Check if a device with the same name already exists
    if (device_find(dev->name) != NULL) {
        log_error("Device manager: device '%s' already registered", dev->name);
        return -1;
    }
    
    dev->next = device_list;
    device_list = dev;
    
    log_info("Device registered: %s", dev->name);
    return 0;
}

device_t *device_find(const char *name) {
    if (!name) return NULL;
    
    for (device_t *curr = device_list; curr != NULL; curr = curr->next) {
        if (strcmp(curr->name, name) == 0) {
            return curr;
        }
    }
    return NULL;
}
