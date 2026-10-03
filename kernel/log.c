#include "kernel/log.h"
#include "lib/printf.h"
#include "drivers/console.h"
#include "drivers/serial.h"
#include <stdarg.h>

static void log_internal(const char *level, uint8_t color, const char *format, va_list args) {
    char buf[1024];
    vsprintf(buf, format, args);
    
    // Print to serial
    serial_puts("[");
    serial_puts(level);
    serial_puts("] ");
    serial_puts(buf);
    serial_puts("\n");
    
    // Print to console
    console_set_color(color, 0); // 0 is black
    console_puts("[");
    console_puts(level);
    console_puts("] ");
    console_set_color(7, 0); // Restore to light grey
    console_puts(buf);
    console_puts("\n");
}

void log_debug(const char *format, ...) {
    va_list args;
    va_start(args, format);
    log_internal("DEBUG", 9, format, args); // Light Blue
    va_end(args);
}

void log_info(const char *format, ...) {
    va_list args;
    va_start(args, format);
    log_internal("INFO", 10, format, args); // Light Green
    va_end(args);
}

void log_warn(const char *format, ...) {
    va_list args;
    va_start(args, format);
    log_internal("WARN", 14, format, args); // Light Brown
    va_end(args);
}

void log_error(const char *format, ...) {
    va_list args;
    va_start(args, format);
    log_internal("ERROR", 12, format, args); // Light Red
    va_end(args);
}

__attribute__((noreturn)) void panic(const char *format, ...) {
    va_list args;
    char buf[1024];
    
    va_start(args, format);
    vsprintf(buf, format, args);
    va_end(args);
    
    serial_puts("\n*** KERNEL PANIC ***\n");
    serial_puts(buf);
    serial_puts("\nSystem Halted.\n");
    
    console_set_color(15, 4); // White on Red
    console_puts("\n*** KERNEL PANIC ***\n");
    console_puts(buf);
    console_puts("\nSystem Halted.\n");
    
    while (1) {
        __asm__ volatile("cli; hlt");
    }
}
