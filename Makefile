CC = gcc
AS = as
LD = gcc

CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -Iinclude
ASFLAGS = --32
LDFLAGS = -m32 -ffreestanding -O2 -nostdlib -T linker.ld -Wl,-build-id=none

KERNEL_OBJS = kernel/boot.o \
       kernel/arch/x86/gdt_flush.o \
       kernel/arch/x86/interrupt.o \
       kernel/arch/x86/switch.o \
       kernel/arch/x86/gdt.o \
       kernel/arch/x86/idt.o \
       kernel/arch/x86/pic.o \
       kernel/drivers/console.o \
       kernel/drivers/serial.o \
       kernel/drivers/timer.o \
       kernel/lib/string.o \
       kernel/lib/memory.o \
       kernel/lib/printf.o \
       kernel/lib/list.o \
       kernel/interrupts.o \
       kernel/log.o \
       kernel/futex.o \
       kernel/pmm.o \
       kernel/vmm.o \
       kernel/heap.o \
       kernel/sync/spinlock.o \
       kernel/sync/mutex.o \
       kernel/sync/waitqueue.o \
       kernel/syscall.o \
       kernel/uaccess.o \
       kernel/fs/vfs.o \
       kernel/fs/pipe.o \
       kernel/fs/ramfs.o \
       kernel/fs/devfs.o \
       kernel/fs/block.o \
       kernel/fs/ext2.o \
       kernel/drivers/ramdisk.o \
       kernel/exec.o \
       kernel/device.o \
       kernel/scheduler/process.o \
       kernel/scheduler/thread.o \
       kernel/scheduler/scheduler.o \
       kernel/scheduler/sleep.o \
       kernel/scheduler/kthread.o \
       kernel/net/net.o \
       kernel/net/dummy_nic.o \
       kernel/net/ethernet.o \
       kernel/net/arp.o \
       kernel/net/checksum.o \
       kernel/net/ipv4.o \
       kernel/net/icmp.o \
       kernel/net/udp.o \
       kernel/net/socket.o \
       kernel/kernel.o

all: atlas.iso

kernel/aether_blob.h:
	$(MAKE) -C runtime/ld clean PLATFORM=atlas ARCH=i386
	$(MAKE) -C runtime/ld PLATFORM=atlas ARCH=i386 aether
	cp runtime/ld/aether aether_bin
	xxd -i aether_bin > kernel/aether_blob.h

runtime/crt/crt0.o:
	$(MAKE) -C runtime/crt

runtime/libatlas/libatlas.a:
	$(MAKE) -C runtime/libatlas

runtime/libc/libc.a:
	$(MAKE) -C runtime/libc

tests/userspace/init_blob.h tests/userspace/cat_blob.h tests/userspace/echo_blob.h tests/userspace/wc_blob.h tests/userspace/test_blob.h tests/userspace/memtest_blob.h tests/userspace/memfault_blob.h tests/userspace/tlstest_blob.h tests/userspace/threadtest_blob.h tests/userspace/pthreadtest_blob.h tests/userspace/pipetest_blob.h tests/userspace/fdtest_blob.h tests/userspace/pipetest2_blob.h tests/userspace/blocktest_blob.h tests/userspace/socktest_blob.h: runtime/crt/crt0.o runtime/libatlas/libatlas.a runtime/libc/libc.a
	$(MAKE) -C tests/userspace_apps clean
	$(MAKE) -C tests/userspace_apps
	mkdir -p tests/userspace
	xxd -i tests/userspace_apps/init > tests/userspace/init_blob.h
	xxd -i tests/userspace_apps/cat > tests/userspace/cat_blob.h
	xxd -i tests/userspace_apps/echo > tests/userspace/echo_blob.h
	xxd -i tests/userspace_apps/wc > tests/userspace/wc_blob.h
	xxd -i tests/userspace_apps/test > tests/userspace/test_blob.h
	xxd -i tests/userspace_apps/memtest > tests/userspace/memtest_blob.h
	xxd -i tests/userspace_apps/memfault > tests/userspace/memfault_blob.h
	xxd -i tests/userspace_apps/tlstest > tests/userspace/tlstest_blob.h
	xxd -i tests/userspace_apps/threadtest > tests/userspace/threadtest_blob.h
	xxd -i tests/userspace_apps/pthreadtest > tests/userspace/pthreadtest_blob.h
	xxd -i tests/userspace_apps/pipetest > tests/userspace/pipetest_blob.h
	xxd -i tests/userspace_apps/fdtest > tests/userspace/fdtest_blob.h
	xxd -i tests/userspace_apps/pipetest2 > tests/userspace/pipetest2_blob.h
	xxd -i tests/userspace_apps/blocktest > tests/userspace/blocktest_blob.h
	xxd -i tests/userspace_apps/socktest > tests/userspace/socktest_blob.h

tests/userspace/ext2_blob.h:
	./scripts/build_ext2.sh

# Explicit dependencies for kernel objects that include blobs
kernel/kernel.o: kernel/aether_blob.h tests/userspace/init_blob.h tests/userspace/cat_blob.h tests/userspace/echo_blob.h tests/userspace/wc_blob.h tests/userspace/test_blob.h tests/userspace/memtest_blob.h tests/userspace/memfault_blob.h tests/userspace/tlstest_blob.h tests/userspace/threadtest_blob.h tests/userspace/pthreadtest_blob.h tests/userspace/pipetest_blob.h tests/userspace/fdtest_blob.h tests/userspace/pipetest2_blob.h tests/userspace/blocktest_blob.h tests/userspace/ext2_blob.h
kernel/exec.o: kernel/aether_blob.h
kernel/drivers/ramdisk.o: tests/userspace/ext2_blob.h

atlas.bin: $(KERNEL_OBJS)
	$(LD) $(LDFLAGS) -o atlas.bin $(KERNEL_OBJS)

atlas.iso: atlas.bin
	mkdir -p iso/boot/grub
	cp atlas.bin iso/boot/atlas.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub2-mkrescue -o atlas.iso iso

qemu: atlas.iso
	qemu-system-i386 -cdrom atlas.iso -serial stdio

clean:
	rm -f $(KERNEL_OBJS) atlas.bin atlas.iso
	rm -rf iso/boot/grub
	rm -f iso/boot/atlas.bin
	rm -f runtime/crt/*.o
	rm -f kernel/aether_blob.h aether_bin
	rm -f tests/userspace/cat_blob.h tests/userspace/echo_blob.h tests/userspace/wc_blob.h tests/userspace/init_blob.h
