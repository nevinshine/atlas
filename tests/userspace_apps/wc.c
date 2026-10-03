#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

void do_wc(FILE *f, const char *name) {
    size_t lines = 0, words = 0, chars = 0;
    int in_word = 0;
    int c;
    
    while ((c = fgetc(f)) != EOF) {
        chars++;
        if (c == '\n') lines++;
        if (isspace(c)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    
    if (name) {
        printf(" %lu %lu %lu %s\n", lines, words, chars, name);
    } else {
        printf(" %lu %lu %lu\n", lines, words, chars);
    }
}

int main(int argc, char **argv) {
    if (argc == 1) {
        do_wc(stdin, NULL);
    } else {
        for (int i = 1; i < argc; i++) {
            FILE *f = fopen(argv[i], "r");
            if (!f) {
                fprintf(stderr, "wc: cannot open %s\n", argv[i]);
                continue;
            }
            do_wc(f, argv[i]);
            fclose(f);
        }
    }
    return 0;
}
