#include <kernel/net/net.h>
#include <kernel/log.h>
#include "lib/string.h"
#include "lib/memory.h"
static network_device_t dummy_dev;

static int dummy_xmit(network_device_t *dev, packet_buffer_t *pkt) {
    if (!dev || !pkt) return -1;
    
    // Log transmission
    log_info("dummy0 TX: transmitted packet of %d bytes", pkt->len);
    
    // Driver assumes ownership and must free
    net_free_packet(pkt);
    return 0;
}

static int dummy_init(network_device_t *dev) {
    if (!dev) return -1;
    log_info("dummy0 initialized");
    return 0;
}

static network_device_ops_t dummy_ops = {
    .init = dummy_init,
    .xmit = dummy_xmit
};

void dummy_nic_init(void) {
    memset(&dummy_dev, 0, sizeof(network_device_t));
    strcpy(dummy_dev.name, "dummy0");
    dummy_dev.mac[0] = 0xDE;
    dummy_dev.mac[1] = 0xAD;
    dummy_dev.mac[2] = 0xBE;
    dummy_dev.mac[3] = 0xEF;
    dummy_dev.mac[4] = 0x00;
    dummy_dev.mac[5] = 0x01;
    dummy_dev.ip_addr = 0x0A000001; // 10.0.0.1 in hex representation (network byte order equivalent logic will just treat this as uint32_t)
    dummy_dev.mtu = 1500;
    dummy_dev.flags = NET_DEV_FLAG_UP | NET_DEV_FLAG_LOOPBACK;
    dummy_dev.ops = &dummy_ops;
    
    if (dummy_dev.ops->init) {
        dummy_dev.ops->init(&dummy_dev);
    }
    
    net_device_register(&dummy_dev);
}

// Emulates hardware receiving a packet and pushing it to the core layer
void dummy_inject_rx(network_device_t *dev, const uint8_t *data, uint32_t len) {
    if (!dev || !data || len == 0) return;
    
    // Allocate packet buffer (data starts at capacity / 2, so capacity needs to be at least len * 2)
    packet_buffer_t *pkt = net_alloc_packet(len * 2 + 64);
    if (!pkt) return;
    
    // Write data
    void *ptr = net_packet_put(pkt, len);
    if (!ptr) {
        net_free_packet(pkt);
        return;
    }
    memcpy(ptr, data, len);
    
    // Pass to network core. Core assumes ownership.
    net_dev_rx(dev, pkt);
}
