# ADR 0003: Aether Loader Boundary

## Problem
Process initialization involves many steps (memory mapping, relocations, runtime bootstrapping, `main` execution). Without strict boundaries, the kernel, the dynamic linker, and `libc` often bleed into each other's responsibilities, creating unmaintainable "spaghetti" code.

## Options Considered
1. **Kernel-Heavy**: The kernel parses ELF headers, loads all shared libraries, and resolves symbols before jumping to userspace.
2. **libc-Heavy**: `libc` itself acts as the interpreter, bootstrapping the process and loading libraries.
3. **Strict Separation (Aether)**: The kernel maps *only* the interpreter (`Aether`) and the executable. Aether handles all ELF resolution and relocation, then hands off to `libatlas/libc` for runtime initialization.

## Decision
We will enforce **Strict Separation** with explicit boundaries.
- **Kernel**: Address space mapping and `auxv` creation.
- **Aether**: ELF validation, Relocations, Symbol Resolution, TLS image sizing, and Constructors.
- **libatlas**: Environment, Heap, Thread runtime, and IO.
- **Application**: `main()`.

## Consequences
- **Positive**: The kernel remains small, unaware of complex userspace shared library mechanics.
- **Positive**: `libc` does not need to understand ELF headers.
- **Negative**: Tracing process startup bugs requires debugging across three distinct boundaries (Kernel -> Aether -> libatlas).
