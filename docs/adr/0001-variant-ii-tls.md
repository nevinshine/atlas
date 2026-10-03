# ADR 0001: Variant II TLS Layout

## Problem
Thread Local Storage (TLS) requires a structured memory layout to allow compilers to generate efficient, lock-free access to thread-local variables. We must decide on a TLS layout ABI for Atlas.

## Options Considered
1. **Variant I**: TCB is placed *before* the TLS variables in memory. This is used by some non-x86 architectures.
2. **Variant II**: TCB is placed *after* the TLS variables in memory. This is the standard for x86/x86_64 ELF systems (Linux, glibc, musl).
3. **Custom Layout**: Inventing a new layout specifically for Atlas.

## Decision
We will use **Variant II**.
- The `%gs` (32-bit) or `%fs` (64-bit) segment register will point directly to the TCB.
- TLS variables will be accessed using negative offsets from the segment base.
- `TCB[0]` will contain a self-pointer to the linear address of the TCB.

## Consequences
- **Positive**: Absolute compatibility with standard LLVM/GCC x86 targets. No need to write custom compiler backends or heavily modify code generation passes.
- **Positive**: Aligns with mature `libc` implementations (musl, glibc), making future integration or C++ `thread_local` support trivial.
- **Negative**: Slightly more complex allocation math when initializing the TLS block compared to a simplistic custom layout, but the trade-off is mathematically sound.
