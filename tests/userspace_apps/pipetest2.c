#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    
    printf("Starting pipetest2...\n");
    
    int fd[2];
    if (pipe(fd) < 0) {
        printf("pipetest2 FAILED: pipe failed\n");
        return -1;
    }
    
    // Test 1: Write to pipe with no readers
    int pid = fork();
    if (pid < 0) return -1;
    
    if (pid == 0) {
        // Child
        close(fd[0]); // Close reader
        
        // Wait a bit to ensure parent closes its reader
        yield();
        yield();
        yield();
        
        char *msg = "This should fail";
        int res = write(fd[1], msg, strlen(msg));
        if (res == -32 || res < 0) {
            printf("[Child] write to closed pipe returned %d\n", res);
        } else {
            printf("pipetest2 FAILED: write to closed pipe returned %d\n", res);
            _exit(1);
        }
        
        _exit(0);
    } else {
        // Parent
        close(fd[0]); // Close reader
        
        int status;
        waitpid(pid, &status, 0);
        
        if (status != 0) {
            printf("pipetest2 FAILED in child\n");
            return -1;
        }
    }
    
    // Parent still has fd[1] open, close it
    close(fd[1]);
    
    printf("pipetest2 PASS\n");
    return 0;
}
