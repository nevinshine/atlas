#!/bin/bash
set -e

# Creates a 1MB ext2 image and populates it using debugfs
dd if=/dev/zero of=ext2.img bs=1024 count=1024 status=none
mke2fs -q -F -b 1024 -O ^ext_attr,^resize_inode,^dir_index,^filetype,^sparse_super,^large_file -I 128 ext2.img

echo "Hello from EXT2!" > hello.txt
echo "Test file" > test.txt
echo "Nested file contents" > nested.txt

echo -e "write hello.txt hello.txt\nwrite test.txt test.txt\nmkdir dir\ncd dir\nwrite nested.txt nested.txt\nquit" | debugfs -w ext2.img > /dev/null 2>&1

rm -f hello.txt test.txt nested.txt

# Generate the header
mkdir -p tests/userspace
xxd -i ext2.img > tests/userspace/ext2_blob.h
rm -f ext2.img
