#ifndef ICMP_H
#define ICMP_H

#include <stdint.h>
#include <kernel/net/net.h>

#define ICMP_TYPE_ECHO_REPLY   0
#define ICMP_TYPE_ECHO_REQUEST 8

typedef struct {
    uint8_t  type;
    uint8_t  code;
    uint16_t checksum;
    uint16_t identifier;
    uint16_t sequence;
} __attribute__((packed)) icmp_echo_header_t;

void icmp_init(void);

// ICMP receive handler (registered with IPv4)
int icmp_receive(network_device_t *dev, packet_buffer_t *pkt, uint32_t src_ip, uint32_t dst_ip);

#endif // ICMP_H
