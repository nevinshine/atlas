#include "../atlascrt/syscall.h"

void _start(void) {
    int fd = open("/dev/console", 0);
    if (fd < 0) {
        _exit(1);
    }
    
    const char *msg_start = "Starting A7.3 Process Lifecycle Test...\n";
    write(fd, msg_start, 40);
    
    int child_pid = fork();
    
    if (child_pid == 0) {
        // Child process
        const char *msg_child = "Hello from the Child Process!\n";
        write(fd, msg_child, 30);
        _exit(100);
    } else if (child_pid > 0) {
        // Parent process
        const char *msg_parent = "Hello from the Parent Process! Waiting for child...\n";
        write(fd, msg_parent, 52);
        
        int status = 0;
        waitpid(child_pid, &status);
        
        if (status == 100) {
            const char *msg_success = "Child exited successfully with correct status (100).\n";
            write(fd, msg_success, 53);
        } else {
            const char *msg_fail = "Child exited with incorrect status!\n";
            write(fd, msg_fail, 36);
        }
    } else {
        const char *msg_err = "Fork failed!\n";
        write(fd, msg_err, 13);
    }
    
    close(fd);
    _exit(42);
}
