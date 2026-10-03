# Atlas TLS ABI (Thread Local Storage)

This document defines the storage mechanism for thread-local variables.

## 1. Variant II Architecture

Atlas enforces the **Variant II** TLS layout to align seamlessly with LLVM/GCC and standard x86 ELF environments. This ensures compatibility with standard compilers without requiring heavy modifications to code generation targets.

```text
TLS Block Structure
────────────────────────
| Thread Local Variables |  (Size: derived from PT_TLS headers)
────────────────────────
| Thread Control Block   |  <- %gs (or %fs) points here
────────────────────────
```

- The Thread Control Block (TCB) is positioned immediately *after* the Thread Local Variables in memory.
- The base pointer for the segment register (`%gs` in 32-bit, `%fs` in 64-bit) points directly to the TCB.
- Local variables are accessed using *negative offsets* from the segment register.

## 2. Structural Requirements

1. **Self-Pointer**: `TCB[0]` must contain the linear virtual address of the TCB itself. This enables userspace threads to fetch their own TCB address trivially via `mov %gs:0, %eax`.
2. **Initialization**: The main thread's TLS block is allocated and initialized by `Aether` or `libatlas_init()` during startup. Subsequent thread TLS blocks are allocated and initialized by `atlas_thread_create()`.
