#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <atlas/process.h>

extern char **environ;

int main(int argc, char **argv) {
    printf("Init process attempting to exec nonexistent binary...\n");
    
    char *test_argv[] = {"/bin/nonexistent", NULL};
    int result = execve("/bin/nonexistent", test_argv, environ);
    
    printf("execve failed with result: %d (expected!)\n", result);
    
    printf("Init process executing /bin/memtest...\n");
    
    int pid = fork();
    if (pid == 0) {
        char *test_argv[] = {"/bin/memtest", NULL};
        execve("/bin/memtest", test_argv, environ);
        printf("execve memtest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("memtest finished with status: %d\n", status);
    }
    
    printf("\nInit process executing /bin/memfault...\n");
    
    pid = fork();
    if (pid == 0) {
        char *fault_argv[] = {"/bin/memfault", NULL};
        execve("/bin/memfault", fault_argv, environ);
        printf("execve memfault failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("memfault finished with status: %d (expected crash)\n", status);
    }
    printf("\nInit process executing /bin/tlstest...\n");
    
    pid = fork();
    if (pid == 0) {
        char *threadtest_argv[] = {"/bin/threadtest", NULL};
        execve("/bin/threadtest", threadtest_argv, environ);
        printf("execve threadtest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("threadtest finished with status: %d\n", status);
    }
    printf("\nInit process executing /bin/pthreadtest...\n");
    
    pid = fork();
    if (pid == 0) {
        char *pthreadtest_argv[] = {"/bin/pthreadtest", NULL};
        execve("/bin/pthreadtest", pthreadtest_argv, environ);
        printf("execve pthreadtest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("pthreadtest finished with status: %d\n", status);
    }
    
    printf("\nInit process executing /bin/pipetest...\n");
    
    pid = fork();
    if (pid == 0) {
        char *pipetest_argv[] = {"/bin/pipetest", NULL};
        execve("/bin/pipetest", pipetest_argv, environ);
        printf("execve pipetest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("pipetest finished with status: %d\n", status);
    }
    
    printf("\nInit process executing /bin/fdtest...\n");
    pid = fork();
    if (pid == 0) {
        char *fdtest_argv[] = {"/bin/fdtest", NULL};
        execve("/bin/fdtest", fdtest_argv, environ);
        printf("execve fdtest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("fdtest finished with status: %d\n", status);
    }
    
    printf("\nInit process executing /bin/pipetest2...\n");
    pid = fork();
    if (pid == 0) {
        char *pipetest2_argv[] = {"/bin/pipetest2", NULL};
        execve("/bin/pipetest2", pipetest2_argv, environ);
        printf("execve pipetest2 failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("pipetest2 finished with status: %d\n", status);
    }
    
    printf("\nInit process executing /bin/blocktest...\n");
    pid = fork();
    if (pid == 0) {
        char *blocktest_argv[] = {"/bin/blocktest", NULL};
        execve("/bin/blocktest", blocktest_argv, environ);
        printf("execve blocktest failed!\n");
        exit(1);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        printf("blocktest finished with status: %d\n", status);
    }
    
    printf("\nInit process finished tests.\n");
    while (1) {
        yield();
    }
    
    return 0;
}
