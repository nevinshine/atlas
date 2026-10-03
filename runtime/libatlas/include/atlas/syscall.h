#ifndef ATLAS_SYSCALL_H
#define ATLAS_SYSCALL_H

static inline long __atlas_syscall0(long n) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall1(long n, long a1) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a1)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall2(long n, long a1, long a2) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a1), "c"(a2)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall3(long n, long a1, long a2, long a3) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a1), "c"(a2), "d"(a3)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall4(long n, long a1, long a2, long a3, long a4) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a1), "c"(a2), "d"(a3), "S"(a4)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall5(long n, long a1, long a2, long a3, long a4, long a5) {
    long ret;
    __asm__ volatile (
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a1), "c"(a2), "d"(a3), "S"(a4), "D"(a5)
        : "memory"
    );
    return ret;
}

static inline long __atlas_syscall6(long n, long a1, long a2, long a3, long a4, long a5, long a6) {
    long ret;
    __asm__ volatile (
        "pushl %%ebp\n"
        "movl %7, %%ebp\n"
        "int $0x80\n"
        "popl %%ebp\n"
        : "=a"(ret)
        : "a"(n), "b"(a1), "c"(a2), "d"(a3), "S"(a4), "D"(a5), "m"(a6)
        : "memory"
    );
    return ret;
}

#endif
