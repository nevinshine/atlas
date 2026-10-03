# Atlas vDSO ABI (Virtual Dynamically Shared Object)

This document defines the interface for the vDSO, an optimization layer mapped into every process to avoid the overhead of traditional syscalls for high-frequency queries.

## 1. Mechanics

During process creation (`sys_exec`), the kernel maps a specialized, read-only physical memory page into the high-memory area of the userspace address space.

The location of this page is not strictly fixed; its base address is passed to the userspace process through the Auxiliary Vector (`auxv`) using the `AT_SYSINFO_EHDR` tag.

## 2. Page Structure & Ownership

The vDSO page contains two distinct regions:

1. **`vdso_data` Struct**: A structured, tightly-packed data block continuously updated by the kernel (Uptime, Jiffies, CPU Topology).
2. **Executable Trampolines**: Native machine code functions placed directly in the vDSO mapping by the kernel.

### Included Capabilities (What belongs in vDSO)
The vDSO is strictly reserved for lock-free, read-only, or pure state-restoration operations:
- `clock_gettime()`
- `gettimeofday()`
- `time()`
- `getcpu()`
- `__vdso_sigreturn`

### Excluded Capabilities (What does NOT belong)
The vDSO is not a generic syscall wrapper. Operations requiring kernel state changes, locks, or IO are explicitly forbidden:
- `open()`
- `write()`
- `mmap()`
- `fork()`

## 3. Userspace Interaction

- **Discovery**: `Aether` (or `libatlas`) parses `AT_SYSINFO_EHDR` on startup and resolves the memory addresses of the exposed vDSO symbols.
- **Execution**: The `libc` implementation of standard functions (e.g., `clock_gettime`) delegates immediately to the `__vdso_clock_gettime` function pointer. If the vDSO is unavailable, it gracefully falls back to a traditional `sys_clock_gettime` syscall.
