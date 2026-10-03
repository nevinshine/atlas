#include "stdio_internal.h"
#include <stdlib.h>
#include <atlas/fs.h>

int fclose(FILE *stream) {
    if (!stream) return EOF;
    
    int res = fflush(stream);
    int fd_res = close(stream->fd);
    
    if (stream->buffer && stream != stdin && stream != stdout && stream != stderr) {
        free(stream->buffer);
    }
    
    // Remove from manager
    for (size_t i = 0; i < __stdio_manager.open_count; i++) {
        if (__stdio_manager.open_files[i] == stream) {
            __stdio_manager.open_files[i] = __stdio_manager.open_files[__stdio_manager.open_count - 1];
            __stdio_manager.open_count--;
            break;
        }
    }
    
    if (stream != stdin && stream != stdout && stream != stderr) {
        free(stream);
    }
    
    return (res == EOF || fd_res < 0) ? EOF : 0;
}
