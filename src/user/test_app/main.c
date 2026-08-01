#include "../atlascrt/syscall.h"

void _start(void) {
    int fd = open("/dev/console", 0);
    if (fd >= 0) {
        // Trivial ioctl test
        ioctl(fd, 1, 0); // request = 1 (dummy), arg = 0
        
        const char *msg = "Hello from Ring 3 via VFS, DEVFS, and Device Manager!\n";
        write(fd, (void *)msg, 54);
        close(fd);
    }
    
    // Yield a few times to show we can
    yield();
    yield();
    
    // Exit gracefully
    _exit(42);
}
