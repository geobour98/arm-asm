#include <stdio.h>
#include <string.h>
#include "payload-enc.h"
#include "aes.h"
#define CBC 1

int main()
{
	size_t shellcodeSize = sizeof(code) -1;

	unsigned char key[] = "0123456789abcdef0123456789abcdef";
	unsigned char iv[] = "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10";

	struct AES_ctx ctx;
	AES_init_ctx_iv(&ctx, key, iv);
	AES_CBC_encrypt_buffer(&ctx, code, shellcodeSize);

	for (int i = 0; i < shellcodeSize; i++) {
		printf("\\x%02x", code[i]);
	}

	printf("\n");
}

