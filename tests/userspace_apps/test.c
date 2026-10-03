#include <stdio.h>

extern char **environ;

int main(int argc, char **argv) {
    printf("exec target reached!\n");
    printf("argc: %d\n", argc);
    for (int i = 0; i < argc; i++) {
        printf("argv[%d]: %s\n", i, argv[i]);
    }
    
    int envc = 0;
    while (environ && environ[envc]) {
        printf("environ[%d]: %s\n", envc, environ[envc]);
        envc++;
    }
    
    return 0;
}
