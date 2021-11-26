// Idea general sacada de https://www.tutorialspoint.com/data_structures_algorithms/linked_list_program_in_c.htm
// Se eliminaron funcionalidades que no se creyeron necesarias para la implementacion de este trabajo

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"

struct node *head = NULL;
struct node *current = NULL;

// insert link at the first location
void insertFirst(char *key, bool is_char)
{
    // create a link
    struct node *link = (struct node *)malloc(sizeof(struct node));

    int key_length = strlen(key);
    link->name_var = (char *)malloc(sizeof(char) * key_length + 1);
    strcpy((char *)link->name_var, (char *)key);
    link->is_char = is_char;

    // point it to old first node
    link->next = head;

    // point first to new first node
    head = link;
}

// is list empty
bool isEmpty()
{
    return head == NULL;
}

int length()
{
    int length = 0;
    struct node *current;

    for (current = head; current != NULL; current = current->next)
    {
        length++;
    }

    return length;
}

// find a link with given key
struct node *find(char *name_var)
{
    // start from the first link
    struct node *current = head;

    // if list is empty
    if (head == NULL)
    {
        return NULL;
    }

    // navigate through list
    while (strcmp(current->name_var, name_var) != 0)
    {
        // if it is last node
        if (current->next == NULL)
        {
            return NULL;
        }
        else
        {
            // go to next link
            current = current->next;
        }
    }
    // if data found, return the current Link
    return current;
}
