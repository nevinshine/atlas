#ifndef ETHERNET_H
#define ETHERNET_H

#include <stdint.h>
#include <kernel/net/net.h>
#include <kernel/net/byteorder.h>

#define ETH_ALEN 6

#define ETH_TYPE_IPV4 0x0800
#define ETH_TYPE_ARP  0x0806

typedef struct {
    uint8_t dst[ETH_ALEN];
    uint8_t src[ETH_ALEN];
    uint16_t type;
} __attribute__((packed)) ethernet_header_t;

void net_eth_init(void);

// Encapsulate and send an Ethernet frame
int net_eth_send(network_device_t *dev, packet_buffer_t *pkt, uint16_t type, const uint8_t *dst_mac);

// Receive and parse an Ethernet frame
int net_eth_receive(network_device_t *dev, packet_buffer_t *pkt);

#endif // ETHERNET_H
