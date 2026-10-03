#ifndef IPV4_H
#define IPV4_H

#include <stdint.h>
#include <kernel/net/net.h>

#define IPV4_PROTO_ICMP 1
#define IPV4_PROTO_TCP  6
#define IPV4_PROTO_UDP  17

typedef struct {
    uint8_t  version_ihl;
    uint8_t  tos;
    uint16_t total_length;
    uint16_t identification;
    uint16_t flags_fragment;
    uint8_t  ttl;
    uint8_t  protocol;
    uint16_t checksum;
    uint32_t src_ip;
    uint32_t dst_ip;
} __attribute__((packed)) ipv4_header_t;

// Protocol handler signature
// Receives the network device, the packet (stripped of IP header), 
// and the source and destination IP addresses in network byte order.
typedef int (*ipv4_protocol_handler_t)(network_device_t *dev, packet_buffer_t *pkt, uint32_t src_ip, uint32_t dst_ip);

void ipv4_init(void);

// Register a protocol handler (e.g. UDP=17)
void ipv4_register_protocol(uint8_t protocol, ipv4_protocol_handler_t handler);

// Encapsulate and transmit an IPv4 packet
int net_ipv4_send(network_device_t *dev, uint32_t dst_ip, uint8_t protocol, packet_buffer_t *pkt);

// Receive and process an IPv4 packet from the link layer
int ipv4_receive(network_device_t *dev, packet_buffer_t *pkt);

#endif // IPV4_H
