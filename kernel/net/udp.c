#include <kernel/net/udp.h>
#include <kernel/net/ipv4.h>
#include <kernel/net/checksum.h>
#include <kernel/net/byteorder.h>
#include <kernel/net/socket.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"

void udp_init(void) {
    ipv4_register_protocol(IPV4_PROTO_UDP, udp_receive);
}

int udp_receive(network_device_t *dev, packet_buffer_t *pkt, uint32_t src_ip, uint32_t dst_ip) {
    if (!dev || !pkt) return -1;
    
    // 1. Length validation (must at least contain UDP header)
    if (pkt->len < sizeof(udp_header_t)) {
        log_error("UDP RX: Packet too short (%d bytes)", pkt->len);
        return -1;
    }
    
    udp_header_t *udp = (udp_header_t *)pkt->data;
    uint16_t udp_len = net_ntohs(udp->length);
    
    // 3. Length field validation
    if (udp_len < sizeof(udp_header_t)) {
        log_error("UDP RX: Invalid length field (%d bytes)", udp_len);
        return -1;
    }
    
    // 4. Ensure packet contains all bytes specified by length field
    if (udp_len > pkt->len) {
        log_error("UDP RX: Truncated packet (udp_len=%d > pkt_len=%d)", udp_len, pkt->len);
        return -1;
    }
    
    // 5. Trim packet to UDP length (ignoring any IPv4 padding)
    pkt->len = udp_len;
    pkt->tail = pkt->data + udp_len;
    
    // 6. Verify checksum (if non-zero)
    if (udp->checksum != 0) {
        ipv4_pseudo_header_t psh;
        psh.src_ip = net_htonl(src_ip);
        psh.dst_ip = net_htonl(dst_ip);
        psh.zero = 0;
        psh.protocol = IPV4_PROTO_UDP;
        psh.length = net_htons(udp_len);
        
        uint32_t sum = net_checksum_accumulate(0, &psh, sizeof(ipv4_pseudo_header_t));
        sum = net_checksum_accumulate(sum, pkt->data, pkt->len);
        uint16_t checksum = net_checksum_finalize(sum);
        
        if (checksum != 0) {
            log_error("UDP RX: Bad checksum");
            return -1;
        }
    }
    
    uint16_t src_port = net_ntohs(udp->src_port);
    uint16_t dst_port = net_ntohs(udp->dst_port);
    
    log_info("UDP RX: src_port=%d, dst_port=%d, len=%d", src_port, dst_port, udp_len);
    
    // Strip UDP header for the handler
    net_packet_pull(pkt, sizeof(udp_header_t));
    
    // 8. Port dispatch via Socket registry
    sock_enqueue_rx(dst_ip, dst_port, src_ip, src_port, pkt->data, pkt->len);
    
    return 0;
}

int net_udp_send(network_device_t *dev, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    uint16_t payload_len = pkt->len;
    uint16_t udp_len = payload_len + sizeof(udp_header_t);
    
    udp_header_t *udp = (udp_header_t *)net_packet_push(pkt, sizeof(udp_header_t));
    if (!udp) {
        log_error("UDP TX: Failed to push header");
        return -1;
    }
    
    udp->src_port = net_htons(src_port);
    udp->dst_port = net_htons(dst_port);
    udp->length = net_htons(udp_len);
    udp->checksum = 0;
    
    // Calculate Checksum
    ipv4_pseudo_header_t psh;
    psh.src_ip = net_htonl(dev->ip_addr);
    psh.dst_ip = net_htonl(dst_ip);
    psh.zero = 0;
    psh.protocol = IPV4_PROTO_UDP;
    psh.length = net_htons(udp_len);
    
    uint32_t sum = net_checksum_accumulate(0, &psh, sizeof(ipv4_pseudo_header_t));
    sum = net_checksum_accumulate(sum, pkt->data, pkt->len);
    udp->checksum = net_checksum_finalize(sum);
    
    // In UDP, if the computed checksum is 0, it must be transmitted as all 1s (0xFFFF).
    if (udp->checksum == 0) {
        udp->checksum = 0xFFFF;
    }
    
    log_info("UDP TX: src_port=%d, dst_port=%d, len=%d", src_port, dst_port, udp_len);
    
    return net_ipv4_send(dev, dst_ip, IPV4_PROTO_UDP, pkt);
}
