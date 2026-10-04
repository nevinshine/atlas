# Atlas — Major Update Plan (Milestones 19-24)

This roadmap defines the next major campaign for Atlas (Milestone 2). It outlines the transition from a collection of experimental networking/storage subsystems into a coherent operating-system substrate.

## Milestone 2: From Experimental Stack → Actual OS Substrate

At the completion of Milestone 1 (up to Phase 18G), Atlas features:
- Kernel Core & Memory Management
- Processes, Ring 3, Syscalls, IPC
- VFS, Block Device, EXT2 (read/write/create/mkdir)
- Layered Networking (Ethernet, ARP, IPv4, ICMP, UDP)
- Userspace Sockets (socket, bind, sendto, recvfrom)

The next major campaign focuses on solidifying these abstractions, removing QEMU-only testing crutches, completing core semantics, and establishing a genuine userspace environment.

---

### 19 — Networking Hardware & Core Completion

**19A — Loopback Interface**
Implement a real `lo0` loopback network device before touching physical hardware. This creates a permanent regression environment for the network stack that doesn't depend on emulator injection. Tests will verify `10.0.0.1 → 10.0.0.1` routing via UDP and ICMP over the loopback interface.

**19B — Routing Table**
Introduce a true routing table with `destination`, `netmask`, `gateway`, `device`, and `metric`. IPv4 transmissions will perform a routing lookup to determine the correct network device and next-hop address. This removes the assumption that IPv4 is hardcoded to a single interface.

**19C — Real NIC Driver**
Implement a driver for a real hardware NIC (preferably the Intel e1000). This involves PCI discovery, BAR MMIO, TX/RX rings, hardware interrupts, and MAC initialization, transforming `dummy0` from the sole network backend into just a testing stub.

---

### 20 — Complete the Writable Filesystem

**20A — unlink()**
Finish regular-file deletion, involving directory entry removal, inode link count decrementation, direct/indirect block reclamation, and final inode deallocation.

**20B — rmdir()**
Add directory removal with necessary protections (must be empty, cannot remove `.` or `..`).

**20C — rename()**
Implement atomic namespace operations across directory boundaries, properly handling source/dest linkage and existing target eviction.

**20D — EXT2 Double/Triple Indirection**
Extend the existing block mapper abstraction to correctly traverse double and triple indirect blocks for large files, completing the EXT2 data layout support.

---

### 21 — Kernel Networking: TCP

**21A — TCP Core**
Introduce `tcp_socket_t`, `tcp_segment_t`, and the core TCP state machine (LISTEN, SYN-SENT, ESTABLISHED, TIME-WAIT, etc.).

**21B — Connection Establishment**
Implement the standard 3-way handshake (SYN → SYN-ACK → ACK) with correct sequence numbers.

**21C — Reliable Data Transfer**
Implement basic transmission, acknowledgements, duplicate detection, receiving windows, and retransmission. Leave complex congestion control for later.

**21D — TCP Socket API**
Expose `listen()`, `accept()`, `connect()`, `send()`, and `recv()` to userspace.

---

### 22 — Userspace Foundation

**22A — Shell**
Build `atlas-sh` implementing basic builtins (`ls`, `cat`, `echo`, `cd`, `pwd`, `mkdir`, `rm`) and pipeline parsing (`cat file | something`), exercising the existing VFS, TTY, and Pipe abstractions.

**22B — Core Utilities**
Migrate from kernel-embedded test apps to standalone core utilities (`init`, `sh`, `ls`, `cp`, `mv`, `mount`).

**22C — Networking Utilities**
Port `ping`, `udp-send`, and add `ifconfig`/`ip` to interact with the new routing tables and hardware interfaces.

---

### 23 — Kernel Infrastructure Upgrade

**23A — Memory Management**
Harden the kernel heap, improve page allocation efficiency, introduce a slab/object allocator, and build memory debugging tools.

**23B — Buffer / Cache Layer**
Introduce a generic buffer cache and block cache with dirty-tracking and writeback daemons. Move EXT2 away from synchronous device blocking to on-demand buffering.

**23C — Kernel Diagnostics**
Standardize `panic()`, `assert()`, stack tracing, memory poisoning, and structured subsystem logging before dealing with the inevitable concurrency bugs of TCP and hardware interrupts.

---

### 24 — Real Hardware / Boot Environment

**24A — Hardware Discovery**
Begin decoupling Atlas from QEMU-specific expectations. Introduce ACPI basics, real PCI enumeration, ATA/AHCI exploration, and interrupt controller refinement (APIC).

---

## The Destination Architecture

At the end of Milestone 2, Atlas will represent a complete, modular, research operating system:

```text
                         USERSPACE
                             │
                  ┌──────────┴──────────┐
                  │                     │
               Shell               Applications
                  │                     │
                  └──────────┬──────────┘
                             │
                        System Calls
                             │
             ┌───────────────┼───────────────┐
             │               │               │
            VFS           Sockets           IPC
             │               │
          EXT2/RAMFS        TCP
             │               UDP
        Buffer Cache        IPv4
             │            ┌──┴──┐
       Block Devices     ARP  Routing
             │             │
          Storage       Ethernet
                           │
                    Network Device
                      ┌────┴────┐
                     lo0      e1000
```
