#ifndef ATLAS_VFS_H
#define ATLAS_VFS_H

#include <stdint.h>
#include <stddef.h>
#include "kernel/list.h"

// VFS Node types
#define FS_FILE        0x01
#define FS_DIRECTORY   0x02
#define FS_CHARDEVICE  0x03
#define FS_BLOCKDEVICE 0x04
#define FS_PIPE        0x05
#define FS_SYMLINK     0x06
#define FS_SOCKET      0x07
#define FS_MOUNTPOINT  0x08 // Indicates the directory is a mountpoint

// Forward declarations
struct vfs_node;
struct file;
struct dirent;

// File open flags
#define O_RDONLY 0x00
#define O_WRONLY 0x01
#define O_RDWR   0x02
#define O_CREAT  0x0200
#define O_EXCL   0x0800

// File operations
typedef int (*read_type_t)(struct file *file, void *buffer, size_t size, uint32_t offset);
typedef int (*write_type_t)(struct file *file, const void *buffer, size_t size, uint32_t offset);
typedef int (*open_type_t)(struct vfs_node *node, struct file *file);
typedef void (*close_type_t)(struct file *file);

// Directory operations
typedef struct dirent * (*readdir_type_t)(struct vfs_node *node, uint32_t index);
typedef struct vfs_node * (*finddir_type_t)(struct vfs_node *node, const char *name);
typedef int (*create_type_t)(struct vfs_node *parent, const char *name, uint16_t mode);
typedef int (*mkdir_type_t)(struct vfs_node *parent, const char *name, uint16_t mode);
typedef int (*unlink_type_t)(struct vfs_node *parent, const char *name);

typedef struct vfs_ops {
    read_type_t read;
    write_type_t write;
    open_type_t open;
    close_type_t close;
    readdir_type_t readdir;
    finddir_type_t finddir;
    create_type_t create;
    mkdir_type_t mkdir;
    unlink_type_t unlink;
    int (*ioctl)(struct vfs_node *node, uint32_t request, void *arg);
} vfs_ops_t;

typedef struct vfs_node {
    char name[128];
    uint32_t mask;        // Permissions
    uint32_t uid;         // Owning user
    uint32_t gid;         // Owning group
    uint32_t flags;       // Node type (FS_FILE, FS_DIRECTORY, etc.)
    uint32_t inode;       // Inode number
    uint32_t size;        // Size of the file in bytes
    void *device;         // Device-specific data
    vfs_ops_t *ops;       // File operations
} vfs_node_t;

// An open file description
typedef struct file {
    vfs_node_t *node;     // The underlying VFS node
    uint32_t offset;      // Current read/write offset
    uint32_t flags;       // Open flags (e.g., read, write)
    uint32_t refcount;    // Number of file descriptors pointing to this
} file_t;

// A filesystem driver
typedef struct filesystem {
    char name[32];
    vfs_node_t *(*mount)(const char *device);
    int (*unmount)(vfs_node_t *root_node);
} filesystem_t;

// A mounted filesystem instance
typedef struct mount {
    char path[128];       // The mount point path (e.g., "/" or "/dev")
    vfs_node_t *root;     // The root node of this mounted filesystem
    filesystem_t *fs;     // The filesystem driver
    struct mount *next;
} mount_t;

// Directory entry
typedef struct dirent {
    char name[128];       // Filename
    uint32_t ino;         // Inode number
} dirent_t;

// Core VFS functions
void vfs_init(void);
void vfs_register_fs(filesystem_t *fs);
int vfs_mount(const char *path, const char *fs_name, const char *device);
int vfs_unmount(const char *path);

file_t *vfs_open(const char *path, uint32_t flags);
int vfs_read(file_t *file, void *buffer, size_t size);
int vfs_write(file_t *file, const void *buffer, size_t size);
int vfs_ioctl(file_t *file, uint32_t request, void *arg);
void vfs_close(file_t *file);

vfs_node_t *vfs_lookup(const char *path);
int vfs_mkdir(const char *path, uint16_t mode);
int vfs_unlink(const char *path);

#endif
