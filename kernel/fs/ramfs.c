#include "kernel/fs/ramfs.h"
#include "kernel/heap.h"
#include "lib/string.h"
#include "lib/memory.h"
#include "kernel/log.h"

typedef struct ramfs_file {
    void *data;
} ramfs_file_t;

typedef struct ramfs_dir {
    vfs_node_t **children;
    uint32_t num_children;
    uint32_t max_children;
} ramfs_dir_t;

static vfs_ops_t ramfs_file_ops;
static vfs_ops_t ramfs_dir_ops;
static filesystem_t ramfs_fs;
static vfs_node_t *ramfs_root_node = NULL;
static uint32_t next_inode = 1;

static int ramfs_read(file_t *file, void *buffer, size_t size, uint32_t offset) {
    if (!file || !file->node || file->node->flags != FS_FILE) return -1;
    if (offset >= file->node->size) return 0;
    
    size_t to_read = size;
    if (offset + to_read > file->node->size) {
        to_read = file->node->size - offset;
    }
    
    ramfs_file_t *rf = (ramfs_file_t *)file->node->device;
    if (!rf || !rf->data) return -1;
    
    memcpy(buffer, (uint8_t*)rf->data + offset, to_read);
    return to_read;
}

static vfs_node_t *ramfs_finddir(vfs_node_t *node, const char *name) {
    if (!node || node->flags != FS_DIRECTORY) return NULL;
    
    ramfs_dir_t *dir = (ramfs_dir_t *)node->device;
    if (!dir) return NULL;
    
    for (uint32_t i = 0; i < dir->num_children; i++) {
        if (strcmp(dir->children[i]->name, name) == 0) {
            return dir->children[i];
        }
    }
    return NULL;
}

static vfs_node_t *ramfs_mount_cb(const char *device) {
    (void)device;
    if (!ramfs_root_node) {
        ramfs_root_node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), 0);
        memset(ramfs_root_node, 0, sizeof(vfs_node_t));
        strcpy(ramfs_root_node->name, "/");
        ramfs_root_node->flags = FS_DIRECTORY;
        ramfs_root_node->inode = next_inode++;
        ramfs_root_node->ops = &ramfs_dir_ops;
        
        ramfs_dir_t *dir = (ramfs_dir_t *)kmalloc(sizeof(ramfs_dir_t), 0);
        dir->children = (vfs_node_t **)kmalloc(sizeof(vfs_node_t *) * 16, 0);
        dir->num_children = 0;
        dir->max_children = 16;
        ramfs_root_node->device = dir;
    }
    return ramfs_root_node;
}

void ramfs_init(void) {
    memset(&ramfs_file_ops, 0, sizeof(vfs_ops_t));
    ramfs_file_ops.read = ramfs_read;
    
    memset(&ramfs_dir_ops, 0, sizeof(vfs_ops_t));
    ramfs_dir_ops.finddir = ramfs_finddir;
    
    strcpy(ramfs_fs.name, "ramfs");
    ramfs_fs.mount = ramfs_mount_cb;
    
    vfs_register_fs(&ramfs_fs);
}

// Simple absolute path addition for boot injection (does not create intermediate dirs yet)
int ramfs_add_file(const char *path, const void *data, size_t size) {
    if (!ramfs_root_node) return -1;
    
    // For simplicity, we just extract the last component and assume it's in the root,
    // OR we properly traverse if we have directories.
    // Let's implement a simple traverse to the parent dir.
    
    const char *rem = path;
    while (*rem == '/') rem++;
    
    vfs_node_t *current = ramfs_root_node;
    char name_buf[128];
    
    while (*rem) {
        const char *next_slash = rem;
        while (*next_slash && *next_slash != '/') next_slash++;
        
        size_t len = next_slash - rem;
        if (len >= sizeof(name_buf)) return -1;
        
        memcpy(name_buf, rem, len);
        name_buf[len] = '\0';
        
        if (*next_slash == '\0') {
            // We are at the file to create
            break;
        }
        
        // Find next dir
        current = ramfs_finddir(current, name_buf);
        if (!current) return -1; // Parent dir not found
        
        rem = next_slash;
        while (*rem == '/') rem++;
    }
    
    if (ramfs_finddir(current, name_buf)) return -1; // Already exists
    
    ramfs_dir_t *parent_dir = (ramfs_dir_t *)current->device;
    if (parent_dir->num_children >= parent_dir->max_children) return -1; // Max children reached for simplicity
    
    vfs_node_t *new_node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), 0);
    memset(new_node, 0, sizeof(vfs_node_t));
    strcpy(new_node->name, name_buf);
    new_node->flags = FS_FILE;
    new_node->inode = next_inode++;
    new_node->size = size;
    new_node->ops = &ramfs_file_ops;
    
    ramfs_file_t *rf = (ramfs_file_t *)kmalloc(sizeof(ramfs_file_t), 0);
    rf->data = kmalloc(size, 0);
    memcpy(rf->data, data, size);
    new_node->device = rf;
    
    parent_dir->children[parent_dir->num_children++] = new_node;
    return 0;
}

int ramfs_add_dir(const char *path) {
    if (!ramfs_root_node) return -1;
    
    const char *rem = path;
    while (*rem == '/') rem++;
    
    vfs_node_t *current = ramfs_root_node;
    char name_buf[128];
    
    while (*rem) {
        const char *next_slash = rem;
        while (*next_slash && *next_slash != '/') next_slash++;
        
        size_t len = next_slash - rem;
        if (len >= sizeof(name_buf)) return -1;
        
        memcpy(name_buf, rem, len);
        name_buf[len] = '\0';
        
        if (*next_slash == '\0') {
            break; // We are at the dir to create
        }
        
        current = ramfs_finddir(current, name_buf);
        if (!current) return -1; 
        
        rem = next_slash;
        while (*rem == '/') rem++;
    }
    
    if (ramfs_finddir(current, name_buf)) return -1; // Already exists
    
    ramfs_dir_t *parent_dir = (ramfs_dir_t *)current->device;
    if (parent_dir->num_children >= parent_dir->max_children) return -1;
    
    vfs_node_t *new_node = (vfs_node_t *)kmalloc(sizeof(vfs_node_t), 0);
    memset(new_node, 0, sizeof(vfs_node_t));
    strcpy(new_node->name, name_buf);
    new_node->flags = FS_DIRECTORY;
    new_node->inode = next_inode++;
    new_node->ops = &ramfs_dir_ops;
    
    ramfs_dir_t *dir = (ramfs_dir_t *)kmalloc(sizeof(ramfs_dir_t), 0);
    dir->children = (vfs_node_t **)kmalloc(sizeof(vfs_node_t *) * 16, 0);
    dir->num_children = 0;
    dir->max_children = 16;
    new_node->device = dir;
    
    parent_dir->children[parent_dir->num_children++] = new_node;
    return 0;
}
