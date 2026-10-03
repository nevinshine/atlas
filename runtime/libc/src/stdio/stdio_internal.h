#ifndef _LIBC_STDIO_INTERNAL_H
#define _LIBC_STDIO_INTERNAL_H

#include <stdio.h>
#include <stddef.h>

#define BUF_SIZE 4096

#define FILE_FLAG_READ  0x01
#define FILE_FLAG_WRITE 0x02
#define FILE_FLAG_LINE  0x04 // line buffered

struct FILE {
    int fd;

    unsigned char *buffer;
    size_t buf_size;

    size_t pos;
    size_t valid; // how much data in buffer is valid (for read)

    int flags;
    int eof;
    int error;
};

typedef struct {
    FILE *stdin;
    FILE *stdout;
    FILE *stderr;

    FILE **open_files;
    size_t open_count;
    size_t open_capacity;
} stdio_manager_t;

extern stdio_manager_t __stdio_manager;

void __stdio_init(void);

#endif
