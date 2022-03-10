#include<stdio.h>

extern unsigned int 
add(unsigned int a, unsigned int b);

extern char *
concat(const char *a, const char *b);

extern char **
cons(const char *a, const char *b);

typedef struct {
    int length;
    char *uchars;
} Pstring;

extern Pstring *
ptr_pstring(const char* a);

typedef struct {
    void* next;
    int length;
    char *uchars;
} LinkedPstring;

extern LinkedPstring *
linked_pstrings(const char* a, const char* b, const char* c);

extern int
print_list_int(const int* ints, int nints);

extern int
print_Pstring(const Pstring p);

typedef void* FES;
extern int 
fes_new(FES* handle);


