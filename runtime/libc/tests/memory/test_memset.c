#include <stdio.h>
#include <string.h>

extern void *memset(void *s, int c, size_t n);

int main() {
    char buf[10] = {0};
    memset(buf, 'A', 5);
    if (strcmp(buf, "AAAAA") == 0) {
        printf("PASS: memset\n");
        return 0;
    }
    printf("FAIL: memset\n");
    return 1;
}
