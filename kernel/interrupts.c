#include "kernel/interrupts.h"
#include "kernel/log.h"
#include "arch/x86/pic.h"
#include <stddef.h>

static interrupt_handler_t interrupt_handlers[256];

void register_interrupt_handler(uint8_t n, interrupt_handler_t handler) {
    interrupt_handlers[n] = handler;
}

void interrupt_dispatch(registers_t *regs) {
    // Send an EOI (End of Interrupt) signal to the PICs if this was a hardware interrupt.
    // We MUST do this before calling the handler, because if the handler is the
    // timer interrupt and it triggers a context switch, this function will not
    // resume until the thread is scheduled again. If it's a new thread, it may
    // never return here, and the PIC will be blocked forever waiting for an EOI!
    if (regs->int_no >= 32 && regs->int_no <= 47) {
        pic_send_eoi(regs->int_no - 32);
    }

    if (interrupt_handlers[regs->int_no] != 0) {
        interrupt_handler_t handler = interrupt_handlers[regs->int_no];
        handler(regs);
    } else {
        if (regs->int_no < 32) {
            panic("Unhandled Exception. Number: %d\n  EIP: 0x%x  CS: 0x%x\n  EFLAGS: 0x%x",
                   regs->int_no, regs->eip, regs->cs, regs->eflags);
        } else {
            log_warn("Unhandled IRQ or Interrupt: %d", regs->int_no);
        }
    }
}

uint32_t irq_save(void) {
    uint32_t flags;
    __asm__ volatile("pushf; pop %0; cli" : "=r"(flags) : : "memory");
    return flags;
}

void irq_restore(uint32_t flags) {
    __asm__ volatile("push %0; popf" : : "r"(flags) : "memory", "cc");
}

