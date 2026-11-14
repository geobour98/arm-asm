#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>
#include "payload.h"

static void make_rwx(void *p, size_t n) {
    long pg = sysconf(_SC_PAGESIZE);
    uintptr_t start = (uintptr_t)p & ~(pg - 1);
    uintptr_t end   = ((uintptr_t)p + n + pg - 1) & ~(pg - 1);
    if (mprotect((void *)start, end - start, PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
        perror("mprotect"); _exit(1);
    }
    __builtin___clear_cache((char *)p, (char *)p + n);
}

int main(void) {
    printf("Shellcode bytes:  %zu\n", sizeof(code) - 1);
    printf("Egg hunter bytes: %zu\n", sizeof(egghunter) - 1);

    make_rwx(code, sizeof(code));
    make_rwx(egghunter, sizeof(egghunter));
    
    void (*run)(void) = (void (*)(void))egghunter;
    run();
    
    return 0;
}
