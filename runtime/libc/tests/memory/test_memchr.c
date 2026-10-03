#include <stdio.h>

extern void *memchr(const void *s, int c, size_t n);

int main() {
    const char *s = "hello world";
    if (memchr(s, 'w', 11) == s + 6 && memchr(s, 'z', 11) == NULL) {
        printf("PASS: memchr\n");
        return 0;
    }
    printf("FAIL: memchr\n");
    return 1;
}
