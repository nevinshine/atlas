#ifndef ARP_H
#define ARP_H

#include <stdint.h>
#include <kernel/net/net.h>
#include <kernel/net/ethernet.h>
#include <kernel/net/byteorder.h>

#define ARP_HTYPE_ETHERNET 1
#define ARP_PTYPE_IPV4     0x0800
#define ARP_OP_REQUEST     1
#define ARP_OP_REPLY       2

typedef struct {
    uint16_t htype;
    uint16_t ptype;
    uint8_t hlen;
    uint8_t plen;
    uint16_t oper;
    uint8_t sha[ETH_ALEN]; // Sender hardware address
    uint32_t spa;          // Sender protocol address (IPv4)
    uint8_t tha[ETH_ALEN]; // Target hardware address
    uint32_t tpa;          // Target protocol address (IPv4)
} __attribute__((packed)) arp_packet_t;

typedef enum {
    ARP_STATE_EMPTY,
    ARP_STATE_RESOLVED
} arp_state_t;

typedef struct {
    uint32_t ip;
    uint8_t mac[ETH_ALEN];
    arp_state_t state;
} arp_cache_entry_t;

void arp_init(void);

// Receive and process an ARP packet
int arp_receive(network_device_t *dev, packet_buffer_t *pkt);

// Send an ARP request
int arp_send_request(network_device_t *dev, uint32_t target_ip);

// Send an ARP reply
int arp_send_reply(network_device_t *dev, uint32_t target_ip, const uint8_t *target_mac);

// Resolve IP to MAC (returns 0 on success, updates out_mac)
int arp_resolve(network_device_t *dev, uint32_t ip, uint8_t *out_mac);

#endif // ARP_H
