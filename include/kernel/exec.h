#ifndef ATLAS_EXEC_H
#define ATLAS_EXEC_H

#include "kernel/scheduler/process.h"

int exec_load(const char *path, exec_image_t *out_image, int argc, const char *argv[], int envc, const char *envp[]);

#endif
