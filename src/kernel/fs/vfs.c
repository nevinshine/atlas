#include "kernel/fs/vfs.h"
#include "kernel/heap.h"
#include "lib/string.h"
#include "lib/memory.h"
#include "kernel/log.h"

// Global mount points list and registered filesystems
static mount_t *mount_list = NULL;
static filesystem_t *registered_fs[16];
static int num_registered_fs = 0;

void vfs_init(void) {
    mount_list = NULL;
    num_registered_fs = 0;
    log_info("VFS initialized.");
}

void vfs_register_fs(filesystem_t *fs) {
    if (num_registered_fs < 16) {
        registered_fs[num_registered_fs++] = fs;
        log_info("Registered filesystem: %s", fs->name);
    }
}

static filesystem_t *vfs_find_fs(const char *name) {
    for (int i = 0; i < num_registered_fs; i++) {
        if (strcmp(registered_fs[i]->name, name) == 0) {
            return registered_fs[i];
        }
    }
    return NULL;
}

int vfs_mount(const char *path, const char *fs_name, const char *device) {
    filesystem_t *fs = vfs_find_fs(fs_name);
    if (!fs) {
        log_error("Filesystem %s not found", fs_name);
        return -1;
    }
    
    vfs_node_t *root_node = fs->mount(device);
    if (!root_node) {
        log_error("Failed to mount %s on %s", fs_name, path);
        return -1;
    }
    
    mount_t *m = (mount_t *)kmalloc(sizeof(mount_t), 0);
    strncpy(m->path, path, sizeof(m->path) - 1);
    m->path[sizeof(m->path) - 1] = '\0';
    m->root = root_node;
    
    // Add to front of mount list
    m->next = mount_list;
    mount_list = m;
    
    log_info("Mounted %s at %s", fs_name, path);
    return 0;
}

static mount_t *vfs_find_mount(const char *path, const char **remaining_path) {
    mount_t *best_match = NULL;
    size_t best_match_len = 0;
    
    // Find longest prefix match
    for (mount_t *m = mount_list; m; m = m->next) {
        size_t len = strlen(m->path);
        
        // Root mount ("/") always matches, len 1
        if (strcmp(m->path, "/") == 0) {
            if (len > best_match_len) {
                best_match = m;
                best_match_len = len;
                *remaining_path = path + 1;
            }
        } else {
            // Check if path starts with m->path
            // e.g., m->path is "/dev", path is "/dev/console"
            if (strncmp(path, m->path, len) == 0 && (path[len] == '/' || path[len] == '\0')) {
                if (len > best_match_len) {
                    best_match = m;
                    best_match_len = len;
                    
                    if (path[len] == '/') {
                        *remaining_path = path + len + 1;
                    } else {
                        *remaining_path = path + len;
                    }
                }
            }
        }
    }
    
    return best_match;
}

vfs_node_t *vfs_lookup(const char *path) {
    // Strip leading slashes
    while (*path == '/') path++;
    
    // Check if we need to search from root mount or if there are other mounts
    const char *rem_path = path;
    
    // If path is empty, return the root mount's root node
    if (*path == '\0') {
        for (mount_t *m = mount_list; m; m = m->next) {
            if (strcmp(m->path, "/") == 0) return m->root;
        }
        return NULL;
    }
    
    // Restore the leading slash for mount matching
    char full_path[256];
    full_path[0] = '/';
    strncpy(full_path + 1, path, 254);
    full_path[255] = '\0';
    
    mount_t *m = vfs_find_mount(full_path, &rem_path);
    if (!m) return NULL;
    
    vfs_node_t *current = m->root;
    
    char name_buf[128];
    while (*rem_path) {
        // Find next part
        const char *next_slash = rem_path;
        while (*next_slash && *next_slash != '/') next_slash++;
        
        size_t len = next_slash - rem_path;
        if (len >= sizeof(name_buf)) return NULL; // Name too long
        
        memcpy(name_buf, rem_path, len);
        name_buf[len] = '\0';
        
        if (current->ops && current->ops->finddir) {
            current = current->ops->finddir(current, name_buf);
            if (!current) return NULL;
        } else {
            return NULL; // Not a directory or doesn't support finddir
        }
        
        rem_path = next_slash;
        while (*rem_path == '/') rem_path++;
    }
    
    return current;
}

file_t *vfs_open(const char *path, uint32_t flags) {
    vfs_node_t *node = vfs_lookup(path);
    if (!node) return NULL;
    
    file_t *f = (file_t *)kmalloc(sizeof(file_t), 0);
    if (!f) return NULL;
    
    f->node = node;
    f->offset = 0;
    f->flags = flags;
    f->refcount = 1;
    
    if (node->ops && node->ops->open) {
        if (node->ops->open(node, f) != 0) {
            kfree(f);
            return NULL;
        }
    }
    
    return f;
}

int vfs_read(file_t *file, void *buffer, size_t size) {
    if (file && file->node && file->node->ops && file->node->ops->read) {
        int bytes = file->node->ops->read(file, buffer, size, file->offset);
        if (bytes > 0) file->offset += bytes;
        return bytes;
    }
    return -1;
}

int vfs_write(file_t *file, const void *buffer, size_t size) {
    if (file && file->node && file->node->ops && file->node->ops->write) {
        int bytes = file->node->ops->write(file, buffer, size, file->offset);
        if (bytes > 0) file->offset += bytes;
        return bytes;
    }
    return -1;
}

void vfs_close(file_t *file) {
    if (file) {
        file->refcount--;
        if (file->refcount == 0) {
            if (file->node && file->node->ops && file->node->ops->close) {
                file->node->ops->close(file);
            }
            kfree(file);
        }
    }
}

int vfs_ioctl(file_t *file, uint32_t request, void *arg) {
    if (file && file->node && file->node->ops && file->node->ops->ioctl) {
        return file->node->ops->ioctl(file->node, request, arg);
    }
    return -1; // ENOTSUP equivalent
}
