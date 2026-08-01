#ifndef ATLAS_LOG_H
#define ATLAS_LOG_H

void log_debug(const char *format, ...);
void log_info(const char *format, ...);
void log_warn(const char *format, ...);
void log_error(const char *format, ...);

__attribute__((noreturn)) void panic(const char *format, ...);

#endif
