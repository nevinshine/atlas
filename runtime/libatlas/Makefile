CC = gcc
CFLAGS = -m32 -Wall -Wextra -g -Iinclude -I../../include -I../libc/include -ffreestanding -nostdinc -fno-builtin -fPIE -fno-stack-protector
AR = ar

SRC_PROCESS = src/process/getpid.c src/process/waitpid.c src/process/fork.c src/process/execve.c src/process/kill.c src/process/exit.c
SRC_MEMORY = src/memory/mmap.c src/memory/munmap.c src/memory/mprotect.c src/memory/brk.c src/memory/alloc.c
SRC_FS = src/fs/open.c src/fs/close.c src/fs/read.c src/fs/write.c src/fs/lseek.c src/fs/errno.c
SRC_INIT = src/init/libatlas_start.c src/init/getauxval.c
SRC_THREAD = src/thread/tls.c src/thread/thread.c
SRC_NET = src/net/socket.c

OBJ = $(SRC_PROCESS:.c=.o) $(SRC_MEMORY:.c=.o) $(SRC_FS:.c=.o) $(SRC_INIT:.c=.o) $(SRC_THREAD:.c=.o) $(SRC_NET:.c=.o)

all: libatlas.a

libatlas.a: $(OBJ)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) libatlas.a
