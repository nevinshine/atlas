#ifndef ATLAS_FS_H
#define ATLAS_FS_H

#include <stddef.h>

int open(const char *pathname, int flags, ...);
int close(int fd);
long read(int fd, void *buf, size_t count);
long write(int fd, const void *buf, size_t count);
long lseek(int fd, long offset, int whence);

#endif
