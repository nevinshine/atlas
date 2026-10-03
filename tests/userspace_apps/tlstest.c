#include <stdio.h>
#include <stdlib.h>

__thread int value;
__thread int value2 = 100;

int main(void) {
    printf("tlstest: initial value = %d, value2 = %d\n", value, value2);
    
    value = 42;
    value2 = 200;
    
    printf("tlstest: updated value = %d, value2 = %d\n", value, value2);
    
    if (value == 42 && value2 == 200) {
        printf("tlstest PASS\n");
        return 0;
    } else {
        printf("tlstest FAIL\n");
        return 1;
    }
}
