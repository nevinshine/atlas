#ifndef ATLAS_INTERRUPTS_H
#define ATLAS_INTERRUPTS_H

#include <stdint.h>

// Registers pushed in interrupt.s
typedef struct {
    uint32_t ds;                                     // Data segment selector
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax; // Pushed by pusha.
    uint32_t int_no, err_code;                       // Interrupt number and error code (if applicable)
    uint32_t eip, cs, eflags, useresp, ss;           // Pushed by the processor automatically.
} registers_t;

typedef void (*interrupt_handler_t)(registers_t *);

void register_interrupt_handler(uint8_t n, interrupt_handler_t handler);
void interrupt_dispatch(registers_t *regs);

uint32_t irq_save(void);
void irq_restore(uint32_t flags);

#endif
