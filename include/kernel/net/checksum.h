#ifndef NET_CHECKSUM_H
#define NET_CHECKSUM_H

#include <stdint.h>

// Calculates the RFC 1071 standard 16-bit one's complement Internet Checksum.
// This handles arbitrary sizes including odd-byte lengths.
uint16_t net_checksum16(const void *data, uint32_t len);

// Incremental checksum API
// Use net_checksum_accumulate iteratively on multiple buffers.
// Note: If you pass chunks with odd lengths, you must manually align or handle the byte
// shift between calls. For simple cases, ensure intermediate buffers are even lengths.
uint32_t net_checksum_accumulate(uint32_t sum, const void *data, uint32_t len);

// Finalize the sum, folding it into 16-bits and applying one's complement.
uint16_t net_checksum_finalize(uint32_t sum);

#endif // NET_CHECKSUM_H
