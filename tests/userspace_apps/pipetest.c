#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    
    printf("pipetest starting.\n");
    
    int fd[2];
    if (pipe(fd) != 0) {
        printf("pipetest FAILED: pipe() returned error\n");
        return 1;
    }
    
    printf("pipe created: read=%d, write=%d\n", fd[0], fd[1]);
    
    int pid = fork();
    if (pid < 0) {
        printf("pipetest FAILED: fork error\n");
        return 1;
    }
    
    if (pid == 0) {
        // Child process
        close(fd[0]); // Close read end
        
        const char *msg = "Hello from Child!";
        printf("[Child] Writing to pipe...\n");
        
        int written = write(fd[1], msg, strlen(msg) + 1);
        if (written != (int)(strlen(msg) + 1)) {
            printf("[Child] FAILED to write full message\n");
            exit(1);
        }
        
        printf("[Child] Write complete. Exiting.\n");
        close(fd[1]);
        exit(0);
    } else {
        // Parent process
        close(fd[1]); // Close write end
        
        char buf[128];
        printf("[Parent] Waiting for data from child...\n");
        
        int bytes_read = read(fd[0], buf, sizeof(buf));
        
        if (bytes_read > 0) {
            printf("[Parent] Read %d bytes: '%s'\n", bytes_read, buf);
            if (strcmp(buf, "Hello from Child!") == 0) {
                printf("pipetest PASS\n");
            } else {
                printf("pipetest FAILED: incorrect message\n");
            }
        } else {
            printf("pipetest FAILED: read error or EOF (%d)\n", bytes_read);
        }
        
        close(fd[0]);
        
        int status;
        waitpid(pid, &status, 0);
    }
    
    return 0;
}
