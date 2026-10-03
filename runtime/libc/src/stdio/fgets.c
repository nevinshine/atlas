#include "stdio_internal.h"

char *fgets(char *s, int size, FILE *stream) {
    if (size <= 0 || !s || !stream) return NULL;
    
    int c;
    int count = 0;
    while (count < size - 1) {
        c = fgetc(stream);
        if (c == EOF) {
            if (count == 0) return NULL;
            break;
        }
        s[count++] = (char)c;
        if (c == '\n') break;
    }
    
    s[count] = '\0';
    return s;
}
