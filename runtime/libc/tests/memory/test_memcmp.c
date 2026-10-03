#include <stdio.h>

extern int memcmp(const void *s1, const void *s2, size_t n);

int main() {
    const char *s1 = "hello";
    const char *s2 = "helxo";
    
    if (memcmp(s1, "hello", 5) == 0 && memcmp(s1, s2, 5) < 0 && memcmp(s2, s1, 5) > 0) {
        printf("PASS: memcmp\n");
        return 0;
    }
    printf("FAIL: memcmp\n");
    return 1;
}
