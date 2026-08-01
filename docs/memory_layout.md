# Atlas Memory Layout

```text
Virtual Memory

FFFFFFFF -----------------
          Recursive PD (Page Directory mapped to itself)

FFC00000 -----------------
          Page Tables (Access to all PTs via recursive mapping)

E0000000 -----------------
          vmalloc (Future contiguous virtual allocation)

D0000000 -----------------
          Kernel Heap Max

C0400000 -----------------
          Kernel Heap Start (Dynamic Free-list Allocator)

C0100000 -----------------
          Kernel Image (Code, Data, BSS)

C0000000 -----------------
          Physical Memory Window (VGA buffer at C00B8000)

00000000 -----------------
          User Space (Future)
```
