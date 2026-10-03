#include <kernel/net/icmp.h>
#include <kernel/net/ipv4.h>
#include <kernel/net/checksum.h>
#include <kernel/net/byteorder.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"

void icmp_init(void) {
    ipv4_register_protocol(IPV4_PROTO_ICMP, icmp_receive);
}

int icmp_receive(network_device_t *dev, packet_buffer_t *pkt, uint32_t src_ip, uint32_t dst_ip) {
    if (!dev || !pkt) {
        return -1;
    }
    
    // 1. Length validation
    if (pkt->len < sizeof(icmp_echo_header_t)) {
        log_error("ICMP RX: Packet too short (%d bytes)", pkt->len);
        return -1;
    }
    
    // 2. Checksum validation
    if (net_checksum16(pkt->data, pkt->len) != 0) {
        log_error("ICMP RX: Bad checksum");
        return -1;
    }
    
    icmp_echo_header_t *icmp = (icmp_echo_header_t *)pkt->data;
    
    // 3/4. Type/Code validation
    if (icmp->type != ICMP_TYPE_ECHO_REQUEST || icmp->code != 0) {
        log_info("ICMP RX: Ignoring type %d code %d", icmp->type, icmp->code);
        return 0;
    }
    
    log_info("ICMP RX: Echo Request from %x", src_ip);
    
    // 5. Construct Echo Reply
    // Allocate new packet for reply to ensure clean headroom
    packet_buffer_t *reply_pkt = net_alloc_packet(pkt->len * 2 + 64);
    if (!reply_pkt) {
        log_error("ICMP RX: Failed to allocate reply packet");
        return -1;
    }
    
    // Copy the entire ICMP message (header + payload)
    void *reply_data = net_packet_put(reply_pkt, pkt->len);
    if (!reply_data) {
        net_free_packet(reply_pkt);
        return -1;
    }
    memcpy(reply_data, pkt->data, pkt->len);
    
    // Modify the new packet to be an Echo Reply
    icmp_echo_header_t *reply_icmp = (icmp_echo_header_t *)reply_pkt->data;
    reply_icmp->type = ICMP_TYPE_ECHO_REPLY;
    reply_icmp->code = 0;
    
    // Identifier and sequence are already in network byte order, 
    // and payload is byte-for-byte identical, so no changes needed for them.
    // However, per requirements, we must be explicit about the wire format:
    uint16_t id = net_ntohs(reply_icmp->identifier);
    uint16_t seq = net_ntohs(reply_icmp->sequence);
    reply_icmp->identifier = net_htons(id);
    reply_icmp->sequence = net_htons(seq);
    
    // Recalculate ICMP checksum
    reply_icmp->checksum = 0;
    reply_icmp->checksum = net_checksum16(reply_pkt->data, reply_pkt->len);
    
    // 6. Send via IPv4 (note that dst_ip in the request becomes our dst, and our src_ip is used for routing back)
    log_info("ICMP TX: Echo Reply to %x", src_ip);
    return net_ipv4_send(dev, src_ip, IPV4_PROTO_ICMP, reply_pkt);
}
