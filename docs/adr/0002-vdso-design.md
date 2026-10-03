# ADR 0002: vDSO Design

## Problem
Certain system queries, such as retrieving the current time (`clock_gettime`), are invoked at extremely high frequencies by userspace. Forcing a full context switch (Ring 3 -> Ring 0 -> Ring 3) for these read-only operations creates severe performance bottlenecks.

## Options Considered
1. **Traditional Syscalls Only**: Force every operation through `int 0x80` or `sysenter`.
2. **Shared Memory Page (Unstructured)**: Map a page of kernel variables directly into userspace.
3. **vDSO (Virtual Dynamically Shared Object)**: Map a read-only page containing both structured data (`vdso_data`) and executable trampolines (`__vdso_clock_gettime`, `__vdso_sigreturn`).

## Decision
We will implement the **vDSO** pattern.
The kernel maps a read-only page into every process at startup. The address is passed via `AT_SYSINFO_EHDR` in the `auxv`. It contains a `vdso_data` struct protected by a seqlock, and executable trampolines.

## Consequences
- **Positive**: `clock_gettime` becomes a lock-free, zero-context-switch userspace function call, drastically improving performance.
- **Positive**: Signal returns (`sigreturn`) can be routed cleanly without forcing userspace to link against explicit stubs.
- **Negative**: Adds complexity to process creation (`execve`) and requires `libc` to dynamically resolve symbols from `auxv` at startup.
