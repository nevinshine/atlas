#include "stdio_internal.h"

int fgetc(FILE *stream) {
    unsigned char c;
    if (fread(&c, 1, 1, stream) == 1) {
        return c;
    }
    return EOF;
}

int getc(FILE *stream) {
    return fgetc(stream);
}

int fputc(int c, FILE *stream) {
    unsigned char ch = (unsigned char)c;
    if (fwrite(&ch, 1, 1, stream) == 1) {
        return ch;
    }
    return EOF;
}

int putc(int c, FILE *stream) {
    return fputc(c, stream);
}
