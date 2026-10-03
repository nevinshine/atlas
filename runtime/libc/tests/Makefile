CC = gcc
CFLAGS = -Wall -Wextra -g -I../include -I../../ -fno-builtin
LIBC = ../libc.a

TESTS = memory/test_memcpy memory/test_memmove memory/test_memset memory/test_memcmp memory/test_memchr string/test_string ctype/test_ctype stdlib/test_stdlib malloc/test_malloc stdio/test_stdio format/test_format env/test_env

all: $(TESTS)

memory/%: memory/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

string/%: string/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

ctype/%: ctype/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

stdlib/%: stdlib/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

malloc/%: malloc/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

stdio/%: stdio/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

format/%: format/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

env/%: env/%.c $(LIBC)
	$(CC) $(CFLAGS) $< $(LIBC) -o $@

run: $(TESTS)
	@for test in $(TESTS); do \
		echo "Running $$test..."; \
		./$$test || exit 1; \
	done
	@echo "All tests passed!"

clean:
	rm -f $(TESTS)
