#ifndef BYTEORDER_H
#define BYTEORDER_H

#include <stdint.h>

// Atlas currently targets x86 (32-bit), which is little-endian.
// Network byte order is big-endian.

static inline uint16_t net_htons(uint16_t v) {
    return (uint16_t)((v << 8) | (v >> 8));
}

static inline uint16_t net_ntohs(uint16_t v) {
    return net_htons(v);
}

static inline uint32_t net_htonl(uint32_t v) {
    return ((v & 0x000000FF) << 24) |
           ((v & 0x0000FF00) <<  8) |
           ((v & 0x00FF0000) >>  8) |
           ((v & 0xFF000000) >> 24);
}

static inline uint32_t net_ntohl(uint32_t v) {
    return net_htonl(v);
}

#endif // BYTEORDER_H
