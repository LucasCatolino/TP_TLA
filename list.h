#ifndef LIST_H
#define LIST_H

#include <stdbool.h>

struct node *find(char *name_var);
int length();
bool isEmpty();
void insertFirst(char *name_var, bool is_char);

struct node
{
    char *name_var;
    bool is_char;
    struct node *next;
};

#endif