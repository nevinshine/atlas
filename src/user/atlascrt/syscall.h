#ifndef ATLASCRT_SYSCALL_H
#define ATLASCRT_SYSCALL_H

#include <stdint.h>
#include <stddef.h>

void _exit(int status);
int write(int fd, const void *buf, size_t count);
int yield(void);
int open(const char *pathname, int flags);
int read(int fd, void *buf, size_t count);
int close(int fd);
int ioctl(int fd, uint32_t request, void *arg);

#endif
