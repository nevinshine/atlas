CC = gcc
CFLAGS = -m32 -Wall -Wextra -g -I../../runtime/libc/include -I../../runtime/libatlas/include -ffreestanding -nostdinc -fno-builtin -fPIE -fno-stack-protector
LDFLAGS = -nostartfiles -nodefaultlibs -pie -Wl,--dynamic-linker=/lib/aether

CRT0_O = ../../runtime/crt/crt0.o
SYSCALL_O = ../../runtime/crt/syscall.o
LIBC_A = ../../runtime/libc/libc.a
LIBATLAS_A = ../../runtime/libatlas/libatlas.a
LIBS = $(CRT0_O) $(SYSCALL_O) -Wl,--start-group $(LIBC_A) $(LIBATLAS_A) -Wl,--end-group

all: init cat echo wc test memtest memfault tlstest threadtest pthreadtest pipetest fdtest pipetest2 blocktest socktest

init: init.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) init.c -o init $(LDFLAGS) $(LIBS)

socktest: socktest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) socktest.c -o socktest $(LDFLAGS) $(LIBS)

cat: cat.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) cat.c -o cat $(LDFLAGS) $(LIBS)

echo: echo.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) echo.c -o echo $(LDFLAGS) $(LIBS)

wc: wc.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) wc.c -o wc $(LDFLAGS) $(LIBS)

test: test.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) test.c -o test $(LDFLAGS) $(LIBS)

memtest: memtest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) memtest.c -o memtest $(LDFLAGS) $(LIBS)

memfault: memfault.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) memfault.c -o memfault $(LDFLAGS) $(LIBS)

tlstest: tlstest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) tlstest.c -o tlstest $(LDFLAGS) $(LIBS)

threadtest: threadtest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) threadtest.c -o threadtest $(LDFLAGS) $(LIBS)

pthreadtest: pthreadtest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) pthreadtest.c -o pthreadtest $(LDFLAGS) $(LIBS)

pipetest: pipetest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) pipetest.c -o pipetest $(LDFLAGS) $(LIBS)

fdtest: fdtest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) fdtest.c -o fdtest $(LDFLAGS) $(LIBS)

pipetest2: pipetest2.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) pipetest2.c -o pipetest2 $(LDFLAGS) $(LIBS)

blocktest: blocktest.c $(LIBC_A) $(LIBATLAS_A) $(CRT0_O) $(SYSCALL_O)
	$(CC) $(CFLAGS) blocktest.c -o blocktest $(LDFLAGS) $(LIBS)

clean:
	rm -f init cat echo wc test memtest memfault tlstest threadtest pthreadtest pipetest fdtest pipetest2 blocktest
