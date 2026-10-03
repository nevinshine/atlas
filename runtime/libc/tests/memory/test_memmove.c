#include <stdio.h>
#include <string.h>

extern void *memmove(void *dest, const void *src, size_t n);

int main() {
    char buf[20] = "hello world";
    // Overlapping move right
    memmove(buf + 6, buf, 5);
    if (strcmp(buf, "hello hello") == 0) {
        printf("PASS: memmove\n");
        return 0;
    }
    printf("FAIL: memmove\n");
    return 1;
}
