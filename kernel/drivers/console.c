#include "drivers/console.h"
#include "kernel/vmm.h"
#include "drivers/serial.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

#define VGA_PHYS 0x000B8000
#define VGA_VIRT (VGA_PHYS + KERNEL_VIRT_BASE)

static size_t console_row;
static size_t console_column;
static uint8_t console_color;
static uint16_t* console_buffer;

void console_init(void) {
    console_row = 0;
    console_column = 0;
    console_color = 7; // Light grey on black
    console_buffer = (uint16_t*) VGA_VIRT;
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            console_buffer[index] = ((uint16_t) ' ') | ((uint16_t) console_color << 8);
        }
    }
}

void console_set_color(uint8_t fg, uint8_t bg) {
    console_color = fg | (bg << 4);
}

void console_putchar(char c) {
    if (c == '\n') {
        console_column = 0;
        if (++console_row == VGA_HEIGHT) console_row = 0; // simplistic wrap
        return;
    }
    const size_t index = console_row * VGA_WIDTH + console_column;
    console_buffer[index] = ((uint16_t) c) | ((uint16_t) console_color << 8);
    if (++console_column == VGA_WIDTH) {
        console_column = 0;
        if (++console_row == VGA_HEIGHT) console_row = 0;
    }
}

void console_puts(const char *str) {
    while (*str) {
        console_putchar(*str++);
    }
}

void console_write(const char *buf, size_t size) {
    for (size_t i = 0; i < size; i++) {
        console_putchar(buf[i]);
        serial_putchar(buf[i]);
    }
}

// Device Framework Integration

#include "kernel/device.h"
#include "lib/string.h"

static int console_dev_write(device_t *dev, const void *buf, size_t count, uint32_t offset) {
    (void)dev;
    (void)offset;
    // log_info("console_dev_write called with count=%d", count);
    console_write((const char *)buf, count);
    return count;
}

static int console_dev_ioctl(device_t *dev, uint32_t request, void *arg) {
    (void)dev;
    (void)request;
    (void)arg;
    
    // Trivial ioctl for testing: return ENOSYS for everything right now
    return -ENOSYS;
}

static device_ops_t console_device_ops = {
    .open = NULL,
    .close = NULL,
    .read = NULL,
    .write = console_dev_write,
    .ioctl = console_dev_ioctl
};

static device_t console_device;

void console_dev_init(void) {
    strcpy(console_device.name, "console");
    console_device.type = DEVICE_TYPE_CHAR;
    console_device.ops = &console_device_ops;
    console_device.private_data = NULL; // No private state needed for this simple console
    
    device_register(&console_device);
}
