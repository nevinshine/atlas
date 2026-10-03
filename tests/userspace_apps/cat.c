#include <stdio.h>
#include <stdlib.h>

void do_cat(FILE *f) {
    char buf[4096];
    size_t bytes;
    while ((bytes = fread(buf, 1, sizeof(buf), f)) > 0) {
        fwrite(buf, 1, bytes, stdout);
    }
}

int main(int argc, char **argv) {
    if (argc == 1) {
        do_cat(stdin);
    } else {
        for (int i = 1; i < argc; i++) {
            FILE *f = fopen(argv[i], "r");
            if (!f) {
                fprintf(stderr, "cat: cannot open %s\n", argv[i]);
                continue;
            }
            do_cat(f);
            fclose(f);
        }
    }
    return 0;
}
