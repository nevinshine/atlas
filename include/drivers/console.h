#ifndef ATLAS_CONSOLE_H
#define ATLAS_CONSOLE_H

#include <stddef.h>
#include <stdint.h>

void console_init(void);
void console_putchar(char c);
void console_puts(const char *str);
void console_write(const char *buf, size_t size);
void console_set_color(uint8_t fg, uint8_t bg);
void console_dev_init(void);

#endif
