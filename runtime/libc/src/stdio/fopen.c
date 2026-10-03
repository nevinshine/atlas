#include "stdio_internal.h"
#include <fcntl.h>
#include <stdlib.h>
#include <atlas/fs.h>
#include <string.h>

FILE *fopen(const char *pathname, const char *mode) {
    __stdio_init();

    int flags = 0;
    int stdio_flags = 0;
    
    if (strchr(mode, 'r')) {
        flags = strchr(mode, '+') ? O_RDWR : O_RDONLY;
        stdio_flags = strchr(mode, '+') ? (FILE_FLAG_READ | FILE_FLAG_WRITE) : FILE_FLAG_READ;
    } else if (strchr(mode, 'w')) {
        flags = strchr(mode, '+') ? (O_RDWR | O_CREAT | O_TRUNC) : (O_WRONLY | O_CREAT | O_TRUNC);
        stdio_flags = strchr(mode, '+') ? (FILE_FLAG_READ | FILE_FLAG_WRITE) : FILE_FLAG_WRITE;
    } else if (strchr(mode, 'a')) {
        flags = strchr(mode, '+') ? (O_RDWR | O_CREAT | O_APPEND) : (O_WRONLY | O_CREAT | O_APPEND);
        stdio_flags = strchr(mode, '+') ? (FILE_FLAG_READ | FILE_FLAG_WRITE) : FILE_FLAG_WRITE;
    } else {
        return NULL;
    }

    int fd = open(pathname, flags, 0666);
    if (fd < 0) {
        return NULL;
    }

    FILE *f = malloc(sizeof(FILE));
    if (!f) {
        close(fd);
        return NULL;
    }

    f->fd = fd;
    f->buffer = malloc(BUF_SIZE);
    if (!f->buffer) {
        free(f);
        close(fd);
        return NULL;
    }

    f->buf_size = BUF_SIZE;
    f->pos = 0;
    f->valid = 0;
    f->flags = stdio_flags;
    f->eof = 0;
    f->error = 0;

    // Add to manager
    if (__stdio_manager.open_count == __stdio_manager.open_capacity) {
        size_t new_cap = __stdio_manager.open_capacity * 2;
        FILE **new_arr = realloc(__stdio_manager.open_files, new_cap * sizeof(FILE *));
        if (!new_arr) {
            free(f->buffer);
            free(f);
            close(fd);
            return NULL;
        }
        __stdio_manager.open_files = new_arr;
        __stdio_manager.open_capacity = new_cap;
    }
    
    __stdio_manager.open_files[__stdio_manager.open_count++] = f;

    return f;
}
