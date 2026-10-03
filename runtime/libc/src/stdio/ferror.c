#include "stdio_internal.h"

int feof(FILE *stream) {
    if (!stream) return 1;
    return stream->eof;
}

int ferror(FILE *stream) {
    if (!stream) return 1;
    return stream->error;
}

void clearerr(FILE *stream) {
    if (!stream) return;
    stream->eof = 0;
    stream->error = 0;
}
