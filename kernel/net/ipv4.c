#include <kernel/net/ipv4.h>
#include <kernel/net/arp.h>
#include <kernel/net/checksum.h>
#include <kernel/net/byteorder.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"

static ipv4_protocol_handler_t ipv4_handlers[256];
static uint16_t ip_id_counter = 0;

void ipv4_init(void) {
    memset(ipv4_handlers, 0, sizeof(ipv4_handlers));
}

void ipv4_register_protocol(uint8_t protocol, ipv4_protocol_handler_t handler) {
    ipv4_handlers[protocol] = handler;
}

int net_ipv4_send(network_device_t *dev, uint32_t dst_ip, uint8_t protocol, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    // We only support the standard 20-byte header right now
    uint32_t header_len = sizeof(ipv4_header_t);
    uint32_t total_len = pkt->len + header_len;
    
    ipv4_header_t *ip = (ipv4_header_t *)net_packet_push(pkt, header_len);
    if (!ip) {
        log_error("IPv4: Failed to push header");
        return -1;
    }
    
    ip->version_ihl = (4 << 4) | (header_len / 4);
    ip->tos = 0;
    ip->total_length = net_htons(total_len);
    ip->identification = net_htons(ip_id_counter++);
    ip->flags_fragment = 0; // No fragmentation
    ip->ttl = 64;
    ip->protocol = protocol;
    ip->src_ip = net_htonl(dev->ip_addr);
    ip->dst_ip = net_htonl(dst_ip);
    
    // Compute Checksum
    ip->checksum = 0;
    ip->checksum = net_checksum16(ip, header_len);
    
    log_info("IPv4: TX to %x (proto %d, len %d)", dst_ip, protocol, total_len);
    
    // ARP Resolution
    uint8_t target_mac[6];
    
    // Handle broadcast specially as requested for future-proofing
    if (dst_ip == 0xFFFFFFFF) {
        memset(target_mac, 0xFF, 6);
    } else {
        if (arp_resolve(dev, dst_ip, target_mac) != 0) {
            log_error("IPv4 TX: ARP resolution failed/pending for %x", dst_ip);
            // In a full stack, we would queue the packet. 
            // For 18D, our tests will ensure ARP is populated.
            net_free_packet(pkt);
            return -1;
        }
    }
    
    return net_eth_send(dev, pkt, ETH_TYPE_IPV4, target_mac);
}

int ipv4_receive(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    if (pkt->len < sizeof(ipv4_header_t)) {
        log_error("IPv4 RX: Packet too short (%d bytes)", pkt->len);
        net_free_packet(pkt);
        return -1;
    }
    
    ipv4_header_t *ip = (ipv4_header_t *)pkt->data;
    
    uint8_t version = (ip->version_ihl >> 4) & 0x0F;
    uint8_t ihl = ip->version_ihl & 0x0F;
    uint32_t header_len = ihl * 4;
    
    if (version != 4) {
        log_error("IPv4 RX: Unsupported version (%d)", version);
        net_free_packet(pkt);
        return -1;
    }
    
    if (header_len < 20 || header_len > pkt->len) {
        log_error("IPv4 RX: Invalid IHL (%d bytes)", header_len);
        net_free_packet(pkt);
        return -1;
    }
    
    uint32_t total_len = net_ntohs(ip->total_length);
    
    if (total_len < header_len || total_len > pkt->len) {
        log_error("IPv4 RX: Invalid total_length (%d)", total_len);
        net_free_packet(pkt);
        return -1;
    }
    
    // Trim any link-layer padding
    if (pkt->len > total_len) {
        pkt->len = total_len;
        pkt->tail = pkt->data + total_len;
    }
    
    if (net_checksum16(ip, header_len) != 0) {
        log_error("IPv4 RX: Bad checksum");
        net_free_packet(pkt);
        return -1;
    }
    
    if (ip->ttl == 0) {
        log_error("IPv4 RX: TTL expired");
        net_free_packet(pkt);
        return -1;
    }
    
    uint32_t dst_ip = net_ntohl(ip->dst_ip);
    uint32_t src_ip = net_ntohl(ip->src_ip);
    uint8_t proto = ip->protocol;
    
    // Local address filtering
    if (dst_ip != dev->ip_addr && dst_ip != 0xFFFFFFFF) {
        log_info("IPv4 RX: Dropping packet for foreign IP (%x)", dst_ip);
        net_free_packet(pkt);
        return 0;
    }
    
    log_info("IPv4 RX: src=%x, dst=%x, proto=%d, len=%d", src_ip, dst_ip, proto, total_len);
    
    // Strip IPv4 header
    net_packet_pull(pkt, header_len);
    
    // Protocol Demultiplexing
    ipv4_protocol_handler_t handler = ipv4_handlers[proto];
    if (handler) {
        handler(dev, pkt, src_ip, dst_ip);
    } else {
        log_error("IPv4 RX: Unknown protocol (%d)", proto);
    }
    
    // Explicit 18D packet ownership boundary: IPv4 frees the packet.
    net_free_packet(pkt);
    return 0;
}
