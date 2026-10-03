#ifndef NET_UDP_H
#define NET_UDP_H

#include <stdint.h>
#include <kernel/net/net.h>

// UDP Header (8 bytes)
typedef struct udp_header {
    uint16_t src_port;
    uint16_t dst_port;
    uint16_t length;
    uint16_t checksum;
} __attribute__((packed)) udp_header_t;

// IPv4 Pseudo-header for UDP/TCP checksum calculation (12 bytes)
typedef struct ipv4_pseudo_header {
    uint32_t src_ip;
    uint32_t dst_ip;
    uint8_t zero;
    uint8_t protocol;
    uint16_t length;
} __attribute__((packed)) ipv4_pseudo_header_t;

// UDP handler function type
typedef int (*udp_handler_t)(
    network_device_t *dev,
    packet_buffer_t *pkt,
    uint16_t src_port,
    uint16_t dst_port,
    uint32_t src_ip,
    uint32_t dst_ip
);

// Initialization
void udp_init(void);

// Register a handler for a specific destination port


// Receive a UDP packet
int udp_receive(network_device_t *dev, packet_buffer_t *pkt, uint32_t src_ip, uint32_t dst_ip);

// Send a UDP packet
int net_udp_send(
    network_device_t *dev,
    uint32_t dst_ip,
    uint16_t src_port,
    uint16_t dst_port,
    packet_buffer_t *pkt
);

#endif // NET_UDP_H
