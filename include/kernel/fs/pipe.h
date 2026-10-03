#ifndef ATLAS_PIPE_H
#define ATLAS_PIPE_H

#include <stdint.h>
#include "kernel/fs/vfs.h"
#include "kernel/sync/waitqueue.h"
#include "kernel/sync/spinlock.h"

#define PIPE_BUF_SIZE 4096

typedef struct pipe {
    uint8_t buffer[PIPE_BUF_SIZE];
    uint32_t head; // Write index
    uint32_t tail; // Read index
    
    uint32_t readers;
    uint32_t writers;
    
    wait_queue_t read_queue;
    wait_queue_t write_queue;
    spinlock_t lock;
} pipe_t;

int pipe_create(file_t **read_file, file_t **write_file);

#endif /* ATLAS_PIPE_H */
