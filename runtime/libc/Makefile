CC = gcc
CFLAGS = -m32 -Wall -Wextra -g -Iinclude -I../libatlas/include -I../../include -I../ -ffreestanding -fno-builtin -fPIE -fno-stack-protector
AR = ar
ARFLAGS = rcs

SRC_MEMORY = src/memory/memcpy.c src/memory/memmove.c src/memory/memset.c src/memory/memcmp.c src/memory/memchr.c
SRC_STRING = src/string/strlen.c src/string/strcmp.c src/string/strncmp.c src/string/strcpy.c src/string/strncpy.c src/string/strchr.c src/string/strrchr.c
SRC_CTYPE = src/ctype/ctype.c
SRC_STDLIB = src/stdlib/abs.c src/stdlib/atoi.c src/stdlib/strtol.c src/stdlib/abort.c src/stdlib/atexit.c src/stdlib/exit.c
SRC_ENV = src/env/env.c
SRC_STDIO = src/stdio/stdio_manager.c src/stdio/fopen.c src/stdio/fclose.c src/stdio/fread.c src/stdio/fwrite.c src/stdio/fflush.c src/stdio/fputs.c src/stdio/fgets.c src/stdio/fputc.c src/stdio/ferror.c
SRC_FORMAT = src/format/vformat.c src/format/printf.c src/format/fprintf.c src/format/snprintf.c src/format/vprintf.c src/format/vfprintf.c src/format/vsnprintf.c
SRC_THREAD = src/thread/thread.c
SRC_PTHREAD = src/pthread/pthread.c src/pthread/mutex.c src/pthread/cond.c
SRC_MALLOC = src/malloc/malloc.c

OBJ = $(SRC_MEMORY:.c=.o) $(SRC_STRING:.c=.o) $(SRC_CTYPE:.c=.o) $(SRC_STDLIB:.c=.o) $(SRC_ENV:.c=.o) $(SRC_MALLOC:.c=.o) $(SRC_STDIO:.c=.o) $(SRC_FORMAT:.c=.o) $(SRC_THREAD:.c=.o) $(SRC_PTHREAD:.c=.o) libc_init.o

all: libc.a

libc.a: $(OBJ)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) libc.a
