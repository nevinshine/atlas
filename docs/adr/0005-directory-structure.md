# ADR 0005: Directory Structure and Architecture Separation

## Problem
As Atlas evolved from a monolithic kernel project into a comprehensive operating systems research platform, the flat `src/` directory became overloaded. Kernel code, architecture ports, userspace applications, and the dynamic linker were all intermingled, making it difficult to enforce architectural boundaries (e.g., preventing kernel code from inadvertently `#include`-ing userspace headers).

## Options Considered
1. **Maintain flat `src/`**: Keep `src/kernel`, `src/user`, `src/lib`, etc. (Status Quo).
2. **Top-Level Domain Separation**: Split the root directory into domains: `kernel/`, `runtime/`, `include/`, `tests/`, and `tools/`.
3. **Monorepo Subprojects**: Completely separate CMake/Make projects for Kernel and Userspace in distinct repositories.

## Decision
We will use **Top-Level Domain Separation** (Option 2).
- **`kernel/`**: Contains all Ring-0 code (`arch`, `drivers`, `lib`, and core subsystems).
- **`runtime/`**: Contains all userspace ecosystem code (`crt`, `libatlas`, `libc`, `ld`).
- **`include/`**: Contains shared headers (e.g., syscall numbers, ABI structs) that cross the kernel-userspace boundary.
- **`tests/`**: Contains isolated test suites and userspace test programs.
- **`tools/`**: Contains host-side utilities, scripts, and build orchestrators.

## Consequences
- **Positive**: Physically enforces the "Kernel vs Runtime" architectural boundary. 
- **Positive**: Makes the repository structure immediately recognizable to systems engineers familiar with mature BSD/Linux trees.
- **Negative**: Requires a complete rewrite of the `Makefile` and invalidates any existing patches or scripts hardcoded to `src/`.
