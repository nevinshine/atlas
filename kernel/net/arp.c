#include <kernel/net/arp.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"

#define ARP_CACHE_SIZE 32
static arp_cache_entry_t arp_cache[ARP_CACHE_SIZE];

void arp_init(void) {
    memset(arp_cache, 0, sizeof(arp_cache));
}

static void arp_update_cache(uint32_t ip, const uint8_t *mac) {
    // Look for existing entry
    for (int i = 0; i < ARP_CACHE_SIZE; i++) {
        if (arp_cache[i].state == ARP_STATE_RESOLVED && arp_cache[i].ip == ip) {
            memcpy(arp_cache[i].mac, mac, ETH_ALEN);
            return;
        }
    }
    
    // Find empty slot
    for (int i = 0; i < ARP_CACHE_SIZE; i++) {
        if (arp_cache[i].state == ARP_STATE_EMPTY) {
            arp_cache[i].ip = ip;
            memcpy(arp_cache[i].mac, mac, ETH_ALEN);
            arp_cache[i].state = ARP_STATE_RESOLVED;
            
            uint8_t *m = arp_cache[i].mac;
            log_info("ARP Cache: Inserted %x -> %x:%x:%x:%x:%x:%x", 
                     ip, m[0], m[1], m[2], m[3], m[4], m[5]);
            return;
        }
    }
    
    log_error("ARP Cache: Table full");
}

int arp_resolve(network_device_t *dev, uint32_t ip, uint8_t *out_mac) {
    if (!dev || !out_mac) return -1;
    
    for (int i = 0; i < ARP_CACHE_SIZE; i++) {
        if (arp_cache[i].state == ARP_STATE_RESOLVED && arp_cache[i].ip == ip) {
            memcpy(out_mac, arp_cache[i].mac, ETH_ALEN);
            return 0;
        }
    }
    
    // Not found, trigger request (but we don't wait in 18C)
    arp_send_request(dev, ip);
    return -1;
}

int arp_send_request(network_device_t *dev, uint32_t target_ip) {
    if (!dev) return -1;
    
    packet_buffer_t *pkt = net_alloc_packet(128);
    if (!pkt) return -1;
    
    // Allocate space for ARP payload
    net_packet_put(pkt, sizeof(arp_packet_t));
    
    arp_packet_t *arp = (arp_packet_t *)pkt->data;
    arp->htype = net_htons(ARP_HTYPE_ETHERNET);
    arp->ptype = net_htons(ARP_PTYPE_IPV4);
    arp->hlen = ETH_ALEN;
    arp->plen = 4; // IPv4 length
    arp->oper = net_htons(ARP_OP_REQUEST);
    
    memcpy(arp->sha, dev->mac, ETH_ALEN);
    arp->spa = net_htonl(dev->ip_addr);
    
    memset(arp->tha, 0, ETH_ALEN);
    arp->tpa = net_htonl(target_ip);
    
    uint8_t broadcast_mac[ETH_ALEN] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
    
    log_info("ARP: Sending request for %x", target_ip);
    return net_eth_send(dev, pkt, ETH_TYPE_ARP, broadcast_mac);
}

int arp_send_reply(network_device_t *dev, uint32_t target_ip, const uint8_t *target_mac) {
    if (!dev) return -1;
    
    packet_buffer_t *pkt = net_alloc_packet(128);
    if (!pkt) return -1;
    
    net_packet_put(pkt, sizeof(arp_packet_t));
    
    arp_packet_t *arp = (arp_packet_t *)pkt->data;
    arp->htype = net_htons(ARP_HTYPE_ETHERNET);
    arp->ptype = net_htons(ARP_PTYPE_IPV4);
    arp->hlen = ETH_ALEN;
    arp->plen = 4;
    arp->oper = net_htons(ARP_OP_REPLY);
    
    memcpy(arp->sha, dev->mac, ETH_ALEN);
    arp->spa = net_htonl(dev->ip_addr);
    
    memcpy(arp->tha, target_mac, ETH_ALEN);
    arp->tpa = net_htonl(target_ip);
    
    log_info("ARP: Sending reply to %x", target_ip);
    return net_eth_send(dev, pkt, ETH_TYPE_ARP, target_mac);
}

int arp_receive(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    if (pkt->len < sizeof(arp_packet_t)) {
        log_error("ARP: Malformed packet (len %d < %d)", pkt->len, sizeof(arp_packet_t));
        net_free_packet(pkt);
        return -1;
    }
    
    arp_packet_t *arp = (arp_packet_t *)pkt->data;
    
    if (net_ntohs(arp->htype) != ARP_HTYPE_ETHERNET ||
        net_ntohs(arp->ptype) != ARP_PTYPE_IPV4 ||
        arp->hlen != ETH_ALEN || arp->plen != 4) {
        log_error("ARP: Unsupported hardware or protocol type");
        net_free_packet(pkt);
        return -1;
    }
    
    uint16_t oper = net_ntohs(arp->oper);
    uint32_t sender_ip = net_ntohl(arp->spa);
    uint32_t target_ip = net_ntohl(arp->tpa);
    
    // Always update cache with sender's info
    arp_update_cache(sender_ip, arp->sha);
    
    if (oper == ARP_OP_REQUEST) {
        if (target_ip == dev->ip_addr) {
            log_info("ARP: Received request for our IP (%x), replying", target_ip);
            arp_send_reply(dev, sender_ip, arp->sha);
        } else {
            log_info("ARP: Ignoring request for foreign IP (%x)", target_ip);
        }
    } else if (oper == ARP_OP_REPLY) {
        if (target_ip == dev->ip_addr) {
            log_info("ARP: Received reply from %x", sender_ip);
        }
    }
    
    net_packet_pull(pkt, sizeof(arp_packet_t));
    net_free_packet(pkt); // End of the line for ARP payload
    return 0;
}
