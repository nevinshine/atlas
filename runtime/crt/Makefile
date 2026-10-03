CC = gcc
AS = as
CFLAGS = -m32 -Wall -Wextra -g -I../../include -ffreestanding -nostdinc -fno-builtin -fPIE -fno-stack-protector
ASFLAGS = -m32

SRCS_C =
SRCS_S = crt0.S syscall.s

OBJS = crt0.o syscall.o

all: $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
%.s:
%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@
