#include "stdio_internal.h"
#include <atlas/fs.h>

int fflush(FILE *stream) {
    if (!stream) {
        int res = 0;
        for (size_t i = 0; i < __stdio_manager.open_count; i++) {
            if (fflush(__stdio_manager.open_files[i]) == EOF) {
                res = EOF;
            }
        }
        return res;
    }
    
    if (stream->flags & FILE_FLAG_WRITE) {
        if (stream->pos > 0) {
            long written = write(stream->fd, stream->buffer, stream->pos);
            if (written != (long)stream->pos) {
                stream->error = 1;
                return EOF;
            }
            stream->pos = 0;
        }
    } else if (stream->flags & FILE_FLAG_READ) {
        // POSIX: For input streams, fflush discards any buffered data that has been fetched
        // from the underlying file, but has not been consumed by the application.
        // It requires adjusting the underlying file offset.
        if (stream->valid > stream->pos) {
            long remaining = stream->valid - stream->pos;
            lseek(stream->fd, -remaining, 1); // SEEK_CUR=1
            stream->valid = 0;
            stream->pos = 0;
        }
    }
    
    return 0;
}
