#include <string.h>
#include <stdlib.h>

#include "czoo.h"

unsigned int 
add(unsigned int a, unsigned int b) {
    printf("C: add(%d, %d)\n", a, b);
    fflush(stdout);
    return (a+b);
}

char *
concat(const char *a, const char *b) {
    printf("C: concat(%s, %s)\n", a, b);

    char *text = (char*)calloc(strlen(a) + strlen(b) + 1, 1);
    strcpy(text, a);
    strcpy(text + strlen(a), b);
    fflush(stdout);
    return text;
}

char **
cons(const char *a, const char *b) {
    printf("C: cons(%s, %s)\n", a, b);

    char **list = (char**)calloc(sizeof(char*), 2);
    list[0] = calloc(strlen(a)+1, 1);
    list[1] = calloc(strlen(b)+1, 1);
    strcpy(list[0], a);
    strcpy(list[1], b);
    fflush(stdout);
    return list;
}

Pstring
pstring(const char* a) {
    printf("C: pstring(%s)\n", a);
    Pstring ps;
    ps.length = strlen(a);
    ps.uchars = (char *)calloc(strlen(a)+1, 1);
    strcpy(ps.uchars, a);
    fflush(stdout);
    return ps;
}

Pstring *
ptr_pstring(const char* a) {
    printf("C: ptr_pstring(%s)\n", a);
    Pstring *ps = malloc(sizeof(Pstring));
    ps->length = strlen(a);
    ps->uchars = (char *)calloc(strlen(a)+1, 1);
    strcpy(ps->uchars, a);
    fflush(stdout);
    return ps;
}

LinkedPstring *
linked_pstrings(const char* a, const char* b, const char* c) {
    printf("C: linked_pstrings(%s, %s, %s)\n", a, b, c);

    LinkedPstring *ps1 = malloc(sizeof(LinkedPstring));
    LinkedPstring *ps2 = malloc(sizeof(LinkedPstring));
    LinkedPstring *ps3 = malloc(sizeof(LinkedPstring));

    ps1->next = (void*)ps2;
    ps1->length = strlen(a);
    ps1->uchars = (char *)calloc(strlen(a)+1, 1);
    strcpy(ps1->uchars, a);

    ps2->next = (void*)ps3;
    ps2->length = strlen(b);
    ps2->uchars = (char *)calloc(strlen(b)+1, 1);
    strcpy(ps2->uchars, b);

    ps3->next = NULL;
    ps3->length = strlen(c);
    ps3->uchars = (char *)calloc(strlen(c)+1, 1);
    strcpy(ps3->uchars, c);
    fflush(stdout);

    return ps1;
}

int
print_list_int(const int* ints, int nints) {
    printf("C: print_list_int nints=%d\n", nints);
    int k = 0;
    for (int i = 0; i < nints; i++) {
        k += printf("\t%d => %d\n", i, ints[i]);
    }
    fflush(stdout);
    return k;
}

int
print_Pstring(const Pstring p) {
    int i;
    printf("C: print_Pstring\n");
    i = printf("C: \tlength: %d\nC:\tstrlen: %ld\nC:\tuchars \"%s\"\n", p.length, strlen(p.uchars), p.uchars);
    fflush(stdout);
    return i;
}

int
fes_new(FES* handle) {
    int i;
    printf("C: fes_new\n");

    *handle = (FES *)calloc(1, 1);

}


/*

void
call_arity0_julia_func(void *jfun_ptr) {
    printf("C: call_arity0_julia_func() no return\n");
    fflush(stdout);
    (*jfun_ptr)();
}


void
call_airity1_julia_func(void *jfun_ptr(int)) {
    printf("C: call_airity1_julia_func(int) no return\n", jfun_ptr);
    fflush(stdout);
    (*jfun_ptr)(17);
}

int
call_airity2_julia_func(void (*fun_ptr)(int, int)) {
    printf("C: call_airity2_julia_func(int, int) return int\n", jfun_ptr);

    int i = fun_ptr(17, 19);
    
    printf("C: called with (17, 19) returning %d\n", i);
    fflush(stdout);
    return i;
};

*/


