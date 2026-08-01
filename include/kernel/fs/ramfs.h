#ifndef ATLAS_RAMFS_H
#define ATLAS_RAMFS_H

#include "kernel/fs/vfs.h"

void ramfs_init(void);
int ramfs_add_file(const char *path, const void *data, size_t size);
int ramfs_add_dir(const char *path);

#endif
