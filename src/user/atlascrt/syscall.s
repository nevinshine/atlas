.global _exit
.type _exit, @function
.global write
.type write, @function
.global yield
.type yield, @function
.global open
.type open, @function
.global read
.type read, @function
.global close
.type close, @function

.section .text

# void _exit(int status)
_exit:
    push %ebx
    mov 8(%esp), %ebx
    mov $0, %eax
    int $0x80
    pop %ebx
    ret

# int write(int fd, const void *buf, size_t count)
write:
    push %ebx
    push %ecx
    push %edx
    mov 16(%esp), %ebx
    mov 20(%esp), %ecx
    mov 24(%esp), %edx
    mov $1, %eax
    int $0x80
    pop %edx
    pop %ecx
    pop %ebx
    ret

# int yield(void)
yield:
    mov $2, %eax
    int $0x80
    ret

# int open(const char *pathname, int flags)
open:
    push %ebx
    push %ecx
    mov 12(%esp), %ebx
    mov 16(%esp), %ecx
    mov $3, %eax
    int $0x80
    pop %ecx
    pop %ebx
    ret

# int read(int fd, void *buf, size_t count)
read:
    push %ebx
    push %ecx
    push %edx
    mov 16(%esp), %ebx
    mov 20(%esp), %ecx
    mov 24(%esp), %edx
    mov $4, %eax
    int $0x80
    pop %edx
    pop %ecx
    pop %ebx
    ret

# int close(int fd)
close:
    push %ebx
    mov 8(%esp), %ebx
    mov $5, %eax
    int $0x80
    pop %ebx
    ret

.global ioctl
.type ioctl, @function
# int ioctl(int fd, uint32_t request, void *arg)
ioctl:
    push %ebx
    push %ecx
    push %edx
    mov 16(%esp), %ebx
    mov 20(%esp), %ecx
    mov 24(%esp), %edx
    mov $6, %eax
    int $0x80
    pop %edx
    pop %ecx
    pop %ebx
    ret
