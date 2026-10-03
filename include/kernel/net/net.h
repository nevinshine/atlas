#ifndef NET_H
#define NET_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

// ----------------------------------------------------------------------------
// Packet Buffer Abstraction
// ----------------------------------------------------------------------------
typedef struct packet_buffer {
    uint8_t *head;       // Start of allocated buffer
    uint8_t *data;       // Start of active payload/headers
    uint8_t *tail;       // End of active payload (data + len)
    uint32_t len;        // Active length (tail - data)
    uint32_t capacity;   // Total capacity (head to head + capacity)
    struct packet_buffer *next; // For queues
} packet_buffer_t;

packet_buffer_t *net_alloc_packet(uint32_t capacity);
void net_free_packet(packet_buffer_t *pkt);

// Header manipulation
// push: subtracts from data, increases len (e.g. adding a header)
// pull: adds to data, decreases len (e.g. stripping a header)
// append (put): adds to tail, increases len (e.g. adding payload)
// These return a pointer to the new data/tail, or NULL on failure.
void *net_packet_push(packet_buffer_t *pkt, uint32_t len);
void *net_packet_pull(packet_buffer_t *pkt, uint32_t len);
void *net_packet_put(packet_buffer_t *pkt, uint32_t len);

// ----------------------------------------------------------------------------
// Network Device Abstraction
// ----------------------------------------------------------------------------

struct network_device;

typedef struct network_device_ops {
    int (*init)(struct network_device *dev);
    int (*xmit)(struct network_device *dev, packet_buffer_t *pkt); // TX
} network_device_ops_t;

typedef struct network_device {
    char name[16];
    uint8_t mac[6];
    uint32_t ip_addr; // IPv4 address
    uint16_t mtu;
    uint8_t flags;
    void *priv; // Driver specific
    network_device_ops_t *ops;
    
    // Link-layer protocol dispatcher
    int (*rx_handler)(struct network_device *dev, packet_buffer_t *pkt);

    struct network_device *next; // Global registry linked list
} network_device_t;

// Device flags
#define NET_DEV_FLAG_UP        0x01
#define NET_DEV_FLAG_LOOPBACK  0x02

// ----------------------------------------------------------------------------
// Core Network Layer
// ----------------------------------------------------------------------------
void net_init(void);
void net_device_register(network_device_t *dev);
network_device_t *net_dev_get(const char *name);

// Transmit a packet (caller yields ownership to driver)
int net_dev_xmit(network_device_t *dev, packet_buffer_t *pkt);

// Receive a packet (driver yields ownership to core)
int net_dev_rx(network_device_t *dev, packet_buffer_t *pkt);

#endif // NET_H
