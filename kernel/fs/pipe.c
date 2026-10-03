#include "kernel/fs/pipe.h"
#include "kernel/heap.h"
#include "lib/string.h"
#include "kernel/log.h"

static int pipe_vfs_read(file_t *file, void *buffer, size_t size, uint32_t offset) {
    (void)offset;
    pipe_t *p = (pipe_t *)file->node->device;
    if (!p || size == 0) return 0;
    
    uint32_t flags;
    spin_lock_irqsave(&p->lock, &flags);
    
    while (p->head == p->tail) {
        if (p->writers == 0) {
            spin_unlock_irqrestore(&p->lock, flags);
            return 0; // EOF
        }
        
        waitqueue_sleep(&p->read_queue, &p->lock);
        spin_lock_irqsave(&p->lock, &flags);
    }
    
    size_t available = p->head - p->tail;
    size_t to_read = (size < available) ? size : available;
    size_t read_count = 0;
    
    while (read_count < to_read) {
        uint32_t index = p->tail % PIPE_BUF_SIZE;
        ((uint8_t *)buffer)[read_count++] = p->buffer[index];
        p->tail++;
    }
    
    waitqueue_wake_one(&p->write_queue);
    
    spin_unlock_irqrestore(&p->lock, flags);
    return read_count;
}

static int pipe_vfs_write(file_t *file, const void *buffer, size_t size, uint32_t offset) {
    (void)offset;
    pipe_t *p = (pipe_t *)file->node->device;
    if (!p) {
        log_error("pipe_vfs_write: p is NULL!");
        return 0;
    }
    if (size == 0) return 0;
    
    uint32_t flags;
    spin_lock_irqsave(&p->lock, &flags);
    
    size_t written_count = 0;
    
    while (written_count < size) {
        if (p->readers == 0) {
            spin_unlock_irqrestore(&p->lock, flags);
            return written_count > 0 ? written_count : -32; // -EPIPE
        }
        
        while ((p->head - p->tail) == PIPE_BUF_SIZE) { // Full
            waitqueue_sleep(&p->write_queue, &p->lock);
            spin_lock_irqsave(&p->lock, &flags);
            
            if (p->readers == 0) {
                spin_unlock_irqrestore(&p->lock, flags);
                return written_count > 0 ? written_count : -32;
            }
        }
        
        if (p->readers == 0) {
            spin_unlock_irqrestore(&p->lock, flags);
            return -32; // -EPIPE
        }
        
        size_t space = PIPE_BUF_SIZE - (p->head - p->tail);
        size_t to_write_now = size - written_count;
        if (to_write_now > space) to_write_now = space;
        
        for (size_t i = 0; i < to_write_now; i++) {
            uint32_t index = p->head % PIPE_BUF_SIZE;
            p->buffer[index] = ((const uint8_t *)buffer)[written_count++];
            p->head++;
        }
        
        waitqueue_wake_one(&p->read_queue);
    }
    
    spin_unlock_irqrestore(&p->lock, flags);
    return written_count;
}

static void pipe_vfs_close(file_t *file) {
    pipe_t *p = (pipe_t *)file->node->device;
    if (!p) return;
    
    uint32_t flags;
    spin_lock_irqsave(&p->lock, &flags);
    
    // We use file->flags to determine if this is the read or write end
    // O_RDONLY = 0, O_WRONLY = 1
    if (file->flags == 1) { // Writer
        p->writers--;
        if (p->writers == 0) {
            waitqueue_wake_all(&p->read_queue);
        }
    } else if (file->flags == 0) { // Reader
        p->readers--;
        if (p->readers == 0) {
            waitqueue_wake_all(&p->write_queue);
        }
    }
    
    if (p->readers == 0 && p->writers == 0) {
        spin_unlock_irqrestore(&p->lock, flags);
        kfree(file->node);
        kfree(p);
        return;
    }
    
    spin_unlock_irqrestore(&p->lock, flags);
}

static vfs_ops_t pipe_vfs_ops = {
    .read = pipe_vfs_read,
    .write = pipe_vfs_write,
    .open = NULL,
    .close = pipe_vfs_close,
    .readdir = NULL,
    .finddir = NULL,
    .ioctl = NULL
};

int pipe_create(file_t **read_file, file_t **write_file) {
    if (!read_file || !write_file) return -1;
    
    pipe_t *p = (pipe_t *)kmalloc(sizeof(pipe_t), KMALLOC_ZERO);
    if (!p) return -1;
    
    p->lock.lock = 0;
    waitqueue_init(&p->read_queue);
    waitqueue_init(&p->write_queue);
    p->readers = 1;
    p->writers = 1;
    
    vfs_node_t *node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), KMALLOC_ZERO);
    if (!node) {
        kfree(p);
        return -1;
    }
    strcpy(node->name, "pipe");
    node->flags = FS_PIPE;
    node->ops = &pipe_vfs_ops;
    node->device = p;
    
    file_t *rf = (file_t *)kmalloc(sizeof(file_t), KMALLOC_ZERO);
    if (!rf) {
        kfree(node);
        kfree(p);
        return -1;
    }
    rf->node = node;
    rf->flags = 0; // O_RDONLY
    rf->refcount = 1;
    
    file_t *wf = (file_t *)kmalloc(sizeof(file_t), KMALLOC_ZERO);
    if (!wf) {
        kfree(rf);
        kfree(node);
        kfree(p);
        return -1;
    }
    wf->node = node;
    wf->flags = 1; // O_WRONLY
    wf->refcount = 1;
    
    *read_file = rf;
    *write_file = wf;
    
    return 0;
}
