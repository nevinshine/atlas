#include <stdio.h>

extern size_t strlen(const char *s);
extern int strcmp(const char *s1, const char *s2);
extern int strncmp(const char *s1, const char *s2, size_t n);
extern char *strcpy(char *dest, const char *src);
extern char *strncpy(char *dest, const char *src, size_t n);
extern char *strchr(const char *s, int c);
extern char *strrchr(const char *s, int c);

int main() {
    int failed = 0;

    if (strlen("hello") != 5) { printf("FAIL: strlen\n"); failed++; }
    if (strcmp("abc", "abc") != 0 || strcmp("abc", "abd") >= 0 || strcmp("abd", "abc") <= 0) { printf("FAIL: strcmp\n"); failed++; }
    if (strncmp("abcd", "abce", 3) != 0 || strncmp("abcd", "abce", 4) >= 0) { printf("FAIL: strncmp\n"); failed++; }
    
    char buf[20];
    if (strcpy(buf, "hello") != buf || strcmp(buf, "hello") != 0) { printf("FAIL: strcpy\n"); failed++; }
    
    char buf2[20];
    if (strncpy(buf2, "hello", 3) != buf2 || strncmp(buf2, "hel", 3) != 0) { printf("FAIL: strncpy\n"); failed++; }

    if (strchr("hello", 'e') == NULL || *strchr("hello", 'e') != 'e') { printf("FAIL: strchr\n"); failed++; }
    if (strrchr("hello", 'l') == NULL || *(strrchr("hello", 'l') + 1) != 'o') { printf("FAIL: strrchr\n"); failed++; }

    if (!failed) {
        printf("PASS: string tests\n");
        return 0;
    }
    return 1;
}
