#ifndef ATLAS_ARCH_IO_H
#define ATLAS_ARCH_IO_H

#include <stdint.h>

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ( "inb %1, %0"
                   : "=a"(ret)
                   : "Nd"(port) );
    return ret;
}

static inline void io_wait(void) {
    /* Port 0x80 is used for 'checkpoints' during POST. */
    /* Linux kernel seems to think it is free for use :-/ */
    __asm__ volatile ( "outb %%al, $0x80" : : "a"(0) );
}

#endif
