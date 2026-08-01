#ifndef ATLAS_EXEC_H
#define ATLAS_EXEC_H

#include "kernel/scheduler/process.h"

int exec_load(const char *path, exec_image_t *out_image);

#endif
