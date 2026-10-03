#include "kernel/list.h"
#include "kernel/heap.h"

void list_init(list_t *list) {
    if (!list) return;
    list->head = NULL;
    list->tail = NULL;
    list->count = 0;
}

void list_push_back(list_t *list, void *value) {
    if (!list) return;
    list_node_t *node = (list_node_t *)kmalloc(sizeof(list_node_t), 0);
    if (!node) return;
    
    node->value = value;
    node->next = NULL;
    node->prev = list->tail;
    
    if (list->tail) {
        list->tail->next = node;
    } else {
        list->head = node;
    }
    list->tail = node;
    list->count++;
}

void *list_pop_front(list_t *list) {
    if (!list || !list->head) return NULL;
    
    list_node_t *node = list->head;
    void *value = node->value;
    
    list->head = node->next;
    if (list->head) {
        list->head->prev = NULL;
    } else {
        list->tail = NULL;
    }
    list->count--;
    
    kfree(node);
    return value;
}

void list_remove(list_t *list, list_node_t *node) {
    if (!list || !node) return;
    
    if (node->prev) {
        node->prev->next = node->next;
    } else {
        list->head = node->next;
    }
    
    if (node->next) {
        node->next->prev = node->prev;
    } else {
        list->tail = node->prev;
    }
    
    list->count--;
    kfree(node);
}

list_node_t *list_find(list_t *list, void *value) {
    if (!list) return NULL;
    list_node_t *curr = list->head;
    while (curr) {
        if (curr->value == value) {
            return curr;
        }
        curr = curr->next;
    }
    return NULL;
}

void list_insert_sorted(list_t *list, void *value, list_compare_func_t comp) {
    if (!list) return;
    
    list_node_t *node = (list_node_t *)kmalloc(sizeof(list_node_t), 0);
    if (!node) return;
    
    node->value = value;
    
    list_node_t *curr = list->head;
    while (curr && !comp(value, curr->value)) {
        curr = curr->next;
    }
    
    if (curr) {
        // Insert before curr
        node->next = curr;
        node->prev = curr->prev;
        
        if (curr->prev) {
            curr->prev->next = node;
        } else {
            list->head = node;
        }
        curr->prev = node;
    } else {
        // Insert at the end
        node->next = NULL;
        node->prev = list->tail;
        
        if (list->tail) {
            list->tail->next = node;
        } else {
            list->head = node;
        }
        list->tail = node;
    }
    list->count++;
}
