#ifndef KERNEL_ATOMIC_H
#define KERNEL_ATOMIC_H

#include <stdint.h>

static inline uint32_t atomic_xchg(volatile uint32_t *addr, uint32_t val) {
    uint32_t result;
    __asm__ volatile("xchgl %0, %1"
                     : "=r"(result), "+m"(*addr)
                     : "0"(val)
                     : "memory");
    return result;
}

#endif /* KERNEL_ATOMIC_H */
