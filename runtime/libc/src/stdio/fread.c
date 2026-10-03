#include "stdio_internal.h"
#include <memory.h>
#include <atlas/fs.h>

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    if (!ptr || !stream || size == 0 || nmemb == 0) return 0;
    if (!(stream->flags & FILE_FLAG_READ)) {
        stream->error = 1;
        return 0;
    }
    
    size_t bytes_requested = size * nmemb;
    size_t bytes_read = 0;
    unsigned char *dst = (unsigned char *)ptr;
    
    while (bytes_requested > 0) {
        // Data available in buffer
        if (stream->valid > stream->pos) {
            size_t available = stream->valid - stream->pos;
            size_t to_copy = (available < bytes_requested) ? available : bytes_requested;
            memcpy(dst, stream->buffer + stream->pos, to_copy);
            stream->pos += to_copy;
            dst += to_copy;
            bytes_read += to_copy;
            bytes_requested -= to_copy;
        } else {
            // Buffer empty, need to fill
            if (stream->eof) break;
            
            // If the request is larger than the buffer, read directly into destination
            if (bytes_requested >= stream->buf_size) {
                long r = read(stream->fd, dst, bytes_requested);
                if (r < 0) {
                    stream->error = 1;
                    break;
                } else if (r == 0) {
                    stream->eof = 1;
                    break;
                } else {
                    dst += r;
                    bytes_read += r;
                    bytes_requested -= r;
                }
            } else {
                // Fill the buffer
                long r = read(stream->fd, stream->buffer, stream->buf_size);
                if (r < 0) {
                    stream->error = 1;
                    break;
                } else if (r == 0) {
                    stream->eof = 1;
                    break;
                } else {
                    stream->pos = 0;
                    stream->valid = r;
                }
            }
        }
    }
    
    return bytes_read / size;
}
