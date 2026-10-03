#include "stdio_internal.h"
#include <stdlib.h>
#include <string.h>

stdio_manager_t __stdio_manager;

static FILE _stdin_struct;
static FILE _stdout_struct;
static FILE _stderr_struct;

FILE *stdin = &_stdin_struct;
FILE *stdout = &_stdout_struct;
FILE *stderr = &_stderr_struct;

static int stdio_initialized = 0;

void __stdio_init(void) {
    if (stdio_initialized) return;

    // Initialize stdin
    _stdin_struct.fd = 0;
    _stdin_struct.buffer = malloc(BUF_SIZE);
    _stdin_struct.buf_size = BUF_SIZE;
    _stdin_struct.pos = 0;
    _stdin_struct.valid = 0;
    _stdin_struct.flags = FILE_FLAG_READ | FILE_FLAG_LINE;
    _stdin_struct.eof = 0;
    _stdin_struct.error = 0;

    // Initialize stdout
    _stdout_struct.fd = 1;
    _stdout_struct.buffer = malloc(BUF_SIZE);
    _stdout_struct.buf_size = BUF_SIZE;
    _stdout_struct.pos = 0;
    _stdout_struct.valid = 0;
    _stdout_struct.flags = FILE_FLAG_WRITE | FILE_FLAG_LINE;
    _stdout_struct.eof = 0;
    _stdout_struct.error = 0;

    // Initialize stderr
    _stderr_struct.fd = 2;
    _stderr_struct.buffer = NULL; // stderr is typically unbuffered
    _stderr_struct.buf_size = 0;
    _stderr_struct.pos = 0;
    _stderr_struct.valid = 0;
    _stderr_struct.flags = FILE_FLAG_WRITE;
    _stderr_struct.eof = 0;
    _stderr_struct.error = 0;

    __stdio_manager.stdin = stdin;
    __stdio_manager.stdout = stdout;
    __stdio_manager.stderr = stderr;

    __stdio_manager.open_capacity = 16;
    __stdio_manager.open_files = malloc(sizeof(FILE *) * __stdio_manager.open_capacity);
    __stdio_manager.open_count = 3;
    __stdio_manager.open_files[0] = stdin;
    __stdio_manager.open_files[1] = stdout;
    __stdio_manager.open_files[2] = stderr;

    stdio_initialized = 1;
}
