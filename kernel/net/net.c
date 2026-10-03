#include <kernel/net/net.h>
#include <kernel/heap.h>
#include <kernel/log.h>
#include "lib/string.h"

static network_device_t *net_devices = NULL;

void net_init(void) {
    log_info("Initializing network layer...");
    net_devices = NULL;
}

void net_device_register(network_device_t *dev) {
    if (!dev) return;
    
    // Add to linked list
    dev->next = net_devices;
    net_devices = dev;
    
    log_info("Network device registered: %s (MAC: %02x:%02x:%02x:%02x:%02x:%02x, MTU: %d)",
             dev->name, dev->mac[0], dev->mac[1], dev->mac[2], dev->mac[3], dev->mac[4], dev->mac[5], dev->mtu);
}

network_device_t *net_dev_get(const char *name) {
    network_device_t *current = net_devices;
    while (current) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

packet_buffer_t *net_alloc_packet(uint32_t capacity) {
    packet_buffer_t *pkt = (packet_buffer_t *)kmalloc(sizeof(packet_buffer_t), KMALLOC_ZERO);
    if (!pkt) return NULL;
    
    pkt->head = (uint8_t *)kmalloc(capacity, KMALLOC_ZERO);
    if (!pkt->head) {
        kfree(pkt);
        return NULL;
    }
    
    pkt->capacity = capacity;
    
    // Start data in the middle to allow pushing headers (e.g. half capacity)
    // For smaller packets or specific layers, this could be customized.
    uint32_t start_offset = capacity / 2;
    pkt->data = pkt->head + start_offset;
    pkt->tail = pkt->data;
    pkt->len = 0;
    pkt->next = NULL;
    
    return pkt;
}

void net_free_packet(packet_buffer_t *pkt) {
    if (!pkt) return;
    if (pkt->head) {
        kfree(pkt->head);
    }
    kfree(pkt);
}

void *net_packet_push(packet_buffer_t *pkt, uint32_t len) {
    if (!pkt || len == 0) return NULL;
    
    // Check if we have enough headroom
    if ((uint32_t)(pkt->data - pkt->head) < len) {
        log_error("net_packet_push: insufficient headroom (need %d, have %d)", len, (uint32_t)(pkt->data - pkt->head));
        return NULL;
    }
    
    pkt->data -= len;
    pkt->len += len;
    return pkt->data;
}

void *net_packet_pull(packet_buffer_t *pkt, uint32_t len) {
    if (!pkt || len == 0) return NULL;
    
    // Check if we have enough data length
    if (pkt->len < len) {
        log_error("net_packet_pull: insufficient data length (need %d, have %d)", len, pkt->len);
        return NULL;
    }
    
    void *old_data = pkt->data;
    pkt->data += len;
    pkt->len -= len;
    return old_data;
}

void *net_packet_put(packet_buffer_t *pkt, uint32_t len) {
    if (!pkt || len == 0) return NULL;
    
    // Check if we have enough tailroom
    uint32_t tailroom = (pkt->head + pkt->capacity) - pkt->tail;
    if (tailroom < len) {
        log_error("net_packet_put: insufficient tailroom (need %d, have %d)", len, tailroom);
        return NULL;
    }
    
    void *old_tail = pkt->tail;
    pkt->tail += len;
    pkt->len += len;
    return old_tail;
}

int net_dev_xmit(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    if (dev->ops && dev->ops->xmit) {
        return dev->ops->xmit(dev, pkt);
    } else {
        // If no xmit function, we must still take ownership and free it.
        net_free_packet(pkt);
        return -1;
    }
}

int net_dev_rx(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    if (dev->rx_handler) {
        return dev->rx_handler(dev, pkt);
    }
    
    // If no link-layer handler is registered, drop the packet
    net_free_packet(pkt);
    return 0;
}
