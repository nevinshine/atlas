#include <stdio.h>

extern int isdigit(int c);
extern int isalpha(int c);
extern int isalnum(int c);
extern int isspace(int c);
extern int tolower(int c);
extern int toupper(int c);

int main() {
    int failed = 0;
    
    if (!isdigit('5') || isdigit('a')) { printf("FAIL: isdigit\n"); failed++; }
    if (!isalpha('a') || isalpha('1')) { printf("FAIL: isalpha\n"); failed++; }
    if (!isalnum('z') || !isalnum('9') || isalnum(' ')) { printf("FAIL: isalnum\n"); failed++; }
    if (!isspace(' ') || !isspace('\n') || isspace('a')) { printf("FAIL: isspace\n"); failed++; }
    if (tolower('A') != 'a' || tolower('z') != 'z') { printf("FAIL: tolower\n"); failed++; }
    if (toupper('a') != 'A' || toupper('Z') != 'Z') { printf("FAIL: toupper\n"); failed++; }

    if (!failed) {
        printf("PASS: ctype tests\n");
        return 0;
    }
    return 1;
}
