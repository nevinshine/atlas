#include "stdlib.h"
#include "ctype.h"

long strtol(const char *nptr, char **endptr, int base) {
    long res = 0;
    int sign = 1;
    
    while (isspace(*nptr)) nptr++;
    
    if (*nptr == '-' || *nptr == '+') {
        if (*nptr == '-') sign = -1;
        nptr++;
    }
    
    if (base == 0) {
        if (*nptr == '0') {
            if (*(nptr+1) == 'x' || *(nptr+1) == 'X') {
                base = 16;
                nptr += 2;
            } else {
                base = 8;
                nptr++;
            }
        } else {
            base = 10;
        }
    } else if (base == 16) {
        if (*nptr == '0' && (*(nptr+1) == 'x' || *(nptr+1) == 'X')) {
            nptr += 2;
        }
    }
    
    while (*nptr) {
        int val = -1;
        if (isdigit(*nptr)) val = *nptr - '0';
        else if (isalpha(*nptr)) val = tolower(*nptr) - 'a' + 10;
        
        if (val < 0 || val >= base) break;
        
        res = res * base + val;
        nptr++;
    }
    
    if (endptr) *endptr = (char *)nptr;
    
    return res * sign;
}
