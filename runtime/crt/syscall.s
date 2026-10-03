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
.global waitpid
.type waitpid, @function
.global fork
.type fork, @function
.global exec
.type exec, @function

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

.global waitpid
waitpid:
    push %ebx
    push %ecx
    mov 12(%esp), %ebx
    mov 16(%esp), %ecx
    mov $11, %eax
    int $0x80
    pop %ecx
    pop %ebx
    ret

.global fork
fork:
    mov $12, %eax
    int $0x80
    ret

.global exec
exec:
    push %ebx
    mov 8(%esp), %ebx
    mov $13, %eax
    int $0x80
    pop %ebx
    ret

.global set_tls
set_tls:
    push %ebx
    mov 8(%esp), %ebx
    mov $15, %eax
    int $0x80
    pop %ebx
    ret

.global atlas_clone
atlas_clone:
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
    
    mov 24(%esp), %ebx /* flags */
    mov 28(%esp), %ecx /* stack_ptr */
    mov 32(%esp), %edx /* parent_tidptr */
    mov 36(%esp), %esi /* tls_val */
    mov 40(%esp), %edi /* child_tidptr */
    mov $16, %eax
    int $0x80
    
    test %eax, %eax
    jz 1f
    
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    ret
    
1:
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    ret

.global atlas_thread_exit
atlas_thread_exit:
    mov $17, %eax
    int $0x80
    /* Should never reach here */
1:  jmp 1b

.global mmap
.type mmap, @function
mmap:
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
    push %ebp
    
    # mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
    mov 28(%esp), %ebx # addr
    mov 32(%esp), %ecx # length
    mov 36(%esp), %edx # prot
    mov 40(%esp), %esi # flags
    mov 44(%esp), %edi # fd
    mov 48(%esp), %ebp # offset
    
    mov $8, %eax      # SYS_MMAP
    int $0x80
    
    pop %ebp
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    ret

.global pipe
.type pipe, @function
pipe:
    push %ebx
    mov 8(%esp), %ebx
    mov $19, %eax
    int $0x80
    pop %ebx
    ret

.global dup
.type dup, @function
dup:
    push %ebx
    mov 8(%esp), %ebx
    mov $20, %eax
    int $0x80
    pop %ebx
    ret

.global dup2
.type dup2, @function
dup2:
    push %ebx
    push %ecx
    mov 12(%esp), %ebx
    mov 16(%esp), %ecx
    mov $21, %eax
    int $0x80
    pop %ecx
    pop %ebx
    ret

.global lseek
.type lseek, @function
lseek:
    push %ebx
    push %ecx
    push %edx
    mov 16(%esp), %ebx
    mov 20(%esp), %ecx
    mov 24(%esp), %edx
    mov $7, %eax
    int $0x80
    pop %edx
    pop %ecx
    pop %ebx
    ret
