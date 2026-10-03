#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

static void print(const char *msg) {
    write(1, msg, strlen(msg));
}

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    
    print("Starting fdtest...\n");
    
    int fd[2];
    if (pipe(fd) < 0) {
        print("fdtest FAILED: pipe failed\n");
        return -1;
    }
    
    print("Testing dup2(fd, fd)...\n");
    if (dup2(fd[0], fd[0]) != fd[0]) {
        print("fdtest FAILED: dup2(fd, fd) failed\n");
        return -1;
    }
    
    print("Testing dup...\n");
    int dup_read = dup(fd[0]);
    if (dup_read < 0) {
        print("fdtest FAILED: dup failed\n");
        return -1;
    }
    
    print("Testing dup2 into existing...\n");
    if (dup2(fd[1], dup_read) != dup_read) {
        print("fdtest FAILED: dup2(valid, existing) failed\n");
        return -1;
    }
    
    print("Testing dup2 invalid...\n");
    if (dup2(99, fd[1]) != -1) {
        print("fdtest FAILED: dup2(invalid, existing) didn't return -1\n");
        return -1;
    }
    
    print("Testing stdout redirection...\n");
    int original_stdout = dup(STDOUT_FILENO);
    if (original_stdout < 0) {
        print("fdtest FAILED: failed to dup stdout\n");
        return -1;
    }
    
    if (dup2(fd[1], STDOUT_FILENO) != STDOUT_FILENO) {
        return -1;
    }
    
    char *msg = "Hello stdout pipe!\n";
    write(STDOUT_FILENO, msg, strlen(msg));
    
    dup2(original_stdout, STDOUT_FILENO);
    close(original_stdout);
    
    print("Reading back from pipe...\n");
    char buf[32];
    int n = read(fd[0], buf, sizeof(buf) - 1);
    if (n < 0) {
        print("fdtest FAILED: read from pipe failed\n");
        return -1;
    }
    buf[n] = '\0';
    
    print("Read back: ");
    print(buf);
    print("\n");
    
    close(fd[0]);
    close(fd[1]);
    close(dup_read);
    
    print("fdtest PASS\n");
    return 0;
}
