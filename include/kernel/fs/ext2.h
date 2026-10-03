#ifndef ATLAS_EXT2_H
#define ATLAS_EXT2_H

#include <stdint.h>
#include "kernel/block.h"

#define EXT2_SUPER_MAGIC 0xEF53

// Superblock
typedef struct {
    uint32_t inodes_count;
    uint32_t blocks_count;
    uint32_t r_blocks_count;
    uint32_t free_blocks_count;
    uint32_t free_inodes_count;
    uint32_t first_data_block;
    uint32_t log_block_size;
    uint32_t log_frag_size;
    uint32_t blocks_per_group;
    uint32_t frags_per_group;
    uint32_t inodes_per_group;
    uint32_t mtime;
    uint32_t wtime;
    uint16_t mnt_count;
    uint16_t max_mnt_count;
    uint16_t magic;
    uint16_t state;
    uint16_t errors;
    uint16_t minor_rev_level;
    uint32_t lastcheck;
    uint32_t checkinterval;
    uint32_t creator_os;
    uint32_t rev_level;
    uint16_t def_resuid;
    uint16_t def_resgid;
    
    // Extended fields (only valid if rev_level >= 1)
    uint32_t first_ino;
    uint16_t inode_size;
    uint16_t block_group_nr;
    uint32_t feature_compat;
    uint32_t feature_incompat;
    uint32_t feature_ro_compat;
    uint8_t  uuid[16];
    char     volume_name[16];
    char     last_mounted[64];
    uint32_t algo_bitmap;
} __attribute__((packed)) ext2_superblock_t;

// Block Group Descriptor
typedef struct {
    uint32_t block_bitmap;
    uint32_t inode_bitmap;
    uint32_t inode_table;
    uint16_t free_blocks_count;
    uint16_t free_inodes_count;
    uint16_t used_dirs_count;
    uint16_t pad;
    uint32_t reserved[3];
} __attribute__((packed)) ext2_block_group_desc_t;

// Inode
#define EXT2_S_IFMT  0xF000
#define EXT2_S_IFSOCK 0xC000
#define EXT2_S_IFLNK  0xA000
#define EXT2_S_IFREG  0x8000
#define EXT2_S_IFBLK  0x6000
#define EXT2_S_IFDIR  0x4000
#define EXT2_S_IFCHR  0x2000
#define EXT2_S_IFIFO  0x1000

#define EXT2_ROOT_INO 2

typedef struct {
    uint16_t mode;
    uint16_t uid;
    uint32_t size;
    uint32_t atime;
    uint32_t ctime;
    uint32_t mtime;
    uint32_t dtime;
    uint16_t gid;
    uint16_t links_count;
    uint32_t blocks;
    uint32_t flags;
    uint32_t osd1;
    uint32_t block[15]; // 0-11 Direct, 12 Singly, 13 Doubly, 14 Triply
    uint32_t generation;
    uint32_t file_acl;
    uint32_t dir_acl;
    uint32_t faddr;
    uint32_t osd2[3];
} __attribute__((packed)) ext2_inode_t;

// Directory Entry
#define EXT2_FT_UNKNOWN  0
#define EXT2_FT_REG_FILE 1
#define EXT2_FT_DIR      2
#define EXT2_FT_CHRDEV   3
#define EXT2_FT_BLKDEV   4
#define EXT2_FT_FIFO     5
#define EXT2_FT_SOCK     6
#define EXT2_FT_SYMLINK  7

typedef struct {
    uint32_t inode;
    uint16_t rec_len;
    uint8_t  name_len;
    uint8_t  file_type;
    char     name[];
} __attribute__((packed)) ext2_dir_entry_t;

// Mount State
typedef struct ext2_mount {
    block_device_t *bdev;
    
    ext2_superblock_t super;
    ext2_block_group_desc_t *groups;
    
    uint32_t block_size;
    uint32_t inode_size;
    uint32_t group_count;
} ext2_mount_t;

void ext2_init(void);
int ext2_alloc_block(ext2_mount_t *mnt, uint32_t *block_out);
int ext2_free_block(ext2_mount_t *mnt, uint32_t block);
int ext2_alloc_inode(ext2_mount_t *mnt, uint32_t *inode_out);
int ext2_free_inode(ext2_mount_t *mnt, uint32_t inode);
int ext2_sync_metadata(ext2_mount_t *mnt);
int ext2_sync_inode(ext2_mount_t *mnt, uint32_t ino, ext2_inode_t *inode);

#endif
