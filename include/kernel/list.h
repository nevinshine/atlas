#ifndef KERNEL_LIST_H
#define KERNEL_LIST_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

typedef struct list_node {
    struct list_node *prev;
    struct list_node *next;
    void *value;
} list_node_t;

typedef struct {
    list_node_t *head;
    list_node_t *tail;
    uint32_t count;
} list_t;

/* Initialize an empty list */
void list_init(list_t *list);

/* Add a new node to the back of the list */
void list_push_back(list_t *list, void *value);

/* Remove and return the front of the list */
void *list_pop_front(list_t *list);

/* Remove a specific node from the list */
void list_remove(list_t *list, list_node_t *node);

/* Find a node by its value */
list_node_t *list_find(list_t *list, void *value);

/* Insert in a sorted manner, using a provided comparison function.
   compare(a, b) should return true if a should precede b. */
typedef bool (*list_compare_func_t)(void *a, void *b);
void list_insert_sorted(list_t *list, void *value, list_compare_func_t comp);

#endif /* KERNEL_LIST_H */
