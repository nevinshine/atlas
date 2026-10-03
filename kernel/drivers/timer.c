#include "drivers/timer.h"
#include "kernel/interrupts.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/log.h"
#include "arch/x86/io.h"

#define PIT_CHANNEL0 0x40
#define PIT_CMD      0x43

static volatile uint32_t tick_count = 0;

static void timer_callback(registers_t *regs) {
    (void)regs;
    tick_count++;
    scheduler_tick();
}

void timer_init(uint32_t frequency) {
    /* Register IRQ0 handler (interrupt 32 after PIC remap) */
    register_interrupt_handler(32, timer_callback);

    /* Configure PIT Channel 0 in rate generator mode */
    uint32_t divisor = 1193180 / frequency;

    outb(PIT_CMD, 0x36);                          /* Channel 0, lo/hi, rate generator */
    outb(PIT_CHANNEL0, (uint8_t)(divisor & 0xFF));       /* Low byte */
    outb(PIT_CHANNEL0, (uint8_t)((divisor >> 8) & 0xFF)); /* High byte */

    log_info("PIT initialized at %u Hz (divisor %u)", frequency, divisor);
}

uint32_t timer_get_ticks(void) {
    return tick_count;
}
