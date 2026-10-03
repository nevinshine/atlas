#include "stdio_internal.h"
#include <memory.h>
#include <atlas/fs.h>

size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream) {
    if (!ptr || !stream || size == 0 || nmemb == 0) return 0;
    if (!(stream->flags & FILE_FLAG_WRITE)) {
        stream->error = 1;
        return 0;
    }

    size_t bytes_to_write = size * nmemb;
    size_t bytes_written = 0;
    const unsigned char *src = (const unsigned char *)ptr;

    // Fast path for unbuffered I/O (e.g., stderr)
    if (stream->buf_size == 0 || !stream->buffer) {
        long w = write(stream->fd, src, bytes_to_write);
        if (w < 0) {
            stream->error = 1;
            return 0;
        }
        return w / size;
    }

    while (bytes_to_write > 0) {
        size_t space = stream->buf_size - stream->pos;
        if (space == 0) {
            if (fflush(stream) == EOF) break;
            space = stream->buf_size;
        }

        size_t to_copy = (bytes_to_write < space) ? bytes_to_write : space;
        
        memcpy(stream->buffer + stream->pos, src, to_copy);
        stream->pos += to_copy;
        
        // If line buffered and we just wrote a newline, flush
        if (stream->flags & FILE_FLAG_LINE) {
            if (memchr(src, '\n', to_copy)) {
                if (fflush(stream) == EOF) break;
            }
        }
        
        src += to_copy;
        bytes_written += to_copy;
        bytes_to_write -= to_copy;
    }
    
    return bytes_written / size;
}
