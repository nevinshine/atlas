#include "stdio_internal.h"
#include <string.h>

int fputs(const char *s, FILE *stream) {
    size_t len = strlen(s);
    if (len == 0) return 0;
    if (fwrite(s, 1, len, stream) != len) {
        return EOF;
    }
    return 0; // POSIX says "non-negative value" on success
}
