#include <kernel/net/checksum.h>

uint32_t net_checksum_accumulate(uint32_t sum, const void *data, uint32_t len) {
    const uint16_t *ptr = (const uint16_t *)data;
    
    while (len > 1) {
        sum += *ptr++;
        len -= 2;
    }
    
    // Handle odd byte if present
    if (len == 1) {
        uint16_t odd = 0;
        *((uint8_t *)&odd) = *((const uint8_t *)ptr);
        sum += odd;
    }
    
    return sum;
}

uint16_t net_checksum_finalize(uint32_t sum) {
    // Fold 32-bit sum into 16-bit
    while (sum >> 16) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }
    
    return (uint16_t)(~sum);
}

uint16_t net_checksum16(const void *data, uint32_t len) {
    return net_checksum_finalize(net_checksum_accumulate(0, data, len));
}
