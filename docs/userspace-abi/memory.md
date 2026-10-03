# Atlas Userspace Memory ABI

This document specifies the exact memory layout and allocation responsibilities within the Atlas runtime.

## 1. Address Space Map

```text
FFFFFFFFFFFFFFFF  (64-bit) / FFFFFFFF (32-bit)
────────────────────
[ Kernel Reserved ]

[ vDSO ]

[ Thread Stack ]
[ Guard Page ]
[ Thread TLS ]

[ Shared Libraries ]

[ Heap ]

[ BSS ]
[ Data ]
[ Text ]

[ NULL ]
────────────────────
0000000000000000
```

## 2. Subsystem Ownership

- **`sys_brk`**: Exclusively owned by `libc` (via the `malloc` heap manager). Neither `libatlas` nor `Aether` should invoke `brk`.
- **`sys_mmap`**: 
  - Utilized by `libc` for allocations exceeding a configurable threshold (e.g., > 128KB).
  - Utilized by `Aether` to load PIE executables and shared libraries dynamically.
  - Utilized by `libatlas` to allocate Thread Stacks, Thread TLS, and Guard Pages when spawning new threads.
- **Guard Pages**: Ownership belongs to `libatlas`. Every thread stack allocated must contain an unmapped protection page (`PROT_NONE`) at the boundary.
