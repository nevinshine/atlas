#include <stdio.h>

extern int abs(int j);
extern int atoi(const char *nptr);
extern long strtol(const char *nptr, char **endptr, int base);

int main() {
    int failed = 0;
    
    if (abs(-5) != 5 || abs(5) != 5 || abs(0) != 0) { printf("FAIL: abs\n"); failed++; }
    
    if (atoi("123") != 123 || atoi("-123") != -123 || atoi("  456") != 456) { printf("FAIL: atoi\n"); failed++; }
    
    char *end;
    if (strtol("123", &end, 10) != 123 || *end != '\0') { printf("FAIL: strtol 10\n"); failed++; }
    if (strtol("0x1A", &end, 0) != 26 || *end != '\0') { printf("FAIL: strtol 16\n"); failed++; }
    if (strtol("-10", &end, 10) != -10 || *end != '\0') { printf("FAIL: strtol neg\n"); failed++; }

    if (!failed) {
        printf("PASS: stdlib tests\n");
        return 0;
    }
    return 1;
}
