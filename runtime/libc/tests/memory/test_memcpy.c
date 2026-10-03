#include <stdio.h>
#include <string.h>

extern void *memcpy(void *dest, const void *src, size_t n);

int main() {
    char dest[20] = {0};
    const char *src = "hello";
    memcpy(dest, src, 5);
    if (strcmp(dest, "hello") == 0) {
        printf("PASS: memcpy\n");
        return 0;
    }
    printf("FAIL: memcpy\n");
    return 1;
}
