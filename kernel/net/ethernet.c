#include <kernel/net/ethernet.h>
#include <kernel/net/arp.h>
#include <kernel/net/ipv4.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"
static bool is_broadcast_mac(const uint8_t *mac) {
    for (int i = 0; i < ETH_ALEN; i++) {
        if (mac[i] != 0xFF) return false;
    }
    return true;
}

static bool is_mac_equal(const uint8_t *mac1, const uint8_t *mac2) {
    for (int i = 0; i < ETH_ALEN; i++) {
        if (mac1[i] != mac2[i]) return false;
    }
    return true;
}

int net_eth_send(network_device_t *dev, packet_buffer_t *pkt, uint16_t type, const uint8_t *dst_mac) {
    if (!dev || !pkt || !dst_mac) return -1;
    
    // Prepend Ethernet header
    ethernet_header_t *hdr = (ethernet_header_t *)net_packet_push(pkt, sizeof(ethernet_header_t));
    if (!hdr) {
        log_error("net_eth_send: Failed to push Ethernet header");
        return -1;
    }
    
    // Populate header
    memcpy(hdr->dst, dst_mac, ETH_ALEN);
    memcpy(hdr->src, dev->mac, ETH_ALEN);
    hdr->type = net_htons(type);
    
    log_info("Ethernet TX: %d bytes (Type: %x)", pkt->len, type);
    
    // Hand off to device layer
    return net_dev_xmit(dev, pkt);
}

int net_eth_receive(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    if (pkt->len < sizeof(ethernet_header_t)) {
        log_error("Ethernet RX: Malformed frame (len %d < %d), discarding", pkt->len, sizeof(ethernet_header_t));
        net_free_packet(pkt);
        return -1;
    }
    
    ethernet_header_t *hdr = (ethernet_header_t *)pkt->data;
    
    // MAC filtering
    if (!is_mac_equal(hdr->dst, dev->mac) && !is_broadcast_mac(hdr->dst)) {
        log_info("Ethernet RX: Frame discarded (Wrong destination MAC)");
        net_free_packet(pkt);
        return -1;
    }
    
    uint16_t type = net_ntohs(hdr->type);
    
    log_info("Ethernet RX: src=%x:%x:%x:%x:%x:%x, dst=%x:%x:%x:%x:%x:%x, type=%x",
             hdr->src[0], hdr->src[1], hdr->src[2], hdr->src[3], hdr->src[4], hdr->src[5],
             hdr->dst[0], hdr->dst[1], hdr->dst[2], hdr->dst[3], hdr->dst[4], hdr->dst[5],
             type);
             
    // Strip header
    net_packet_pull(pkt, sizeof(ethernet_header_t));
    
    // Hand off to network layer (IPv4, ARP) goes here later
    if (type == ETH_TYPE_ARP) {
        return arp_receive(dev, pkt);
    } else if (type == ETH_TYPE_IPV4) {
        return ipv4_receive(dev, pkt);
    }
    
    // For unknown types, free payload
    net_free_packet(pkt);
    return 0;
}

void net_eth_init(void) {
    // Register Ethernet receive handler on dummy0 (or globally for all ethernet-like devices)
    network_device_t *dummy = net_dev_get("dummy0");
    if (dummy) {
        dummy->rx_handler = net_eth_receive;
    }
}
