#ifndef DUMMY_NIC_H
#define DUMMY_NIC_H

#include <kernel/net/net.h>

void dummy_nic_init(void);
void dummy_inject_rx(network_device_t *dev, const uint8_t *data, uint32_t len);

#endif // DUMMY_NIC_H
