# ASM Makefile

.PHONY: all clean

all: clean decrypt

exec-sh: exec-sh.s
	@echo "\n[+] Assembling and linking execve /bin/sh..."
	as -o exec-sh.o exec-sh.s
	ld -o exec-sh exec-sh.o

exec-sh.bin: exec-sh
	@echo "\n[+] Creating execve's raw bytes..."
	objcopy -O binary -j .text exec-sh exec-sh.bin
	xxd -p exec-sh.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g'; echo

payload-enc.h: exec-sh.bin
	@echo "\n[+] Generating padded payload.h..."
	@{ \
	LEN=$$(wc -c < exec-sh.bin); \
	PAD=$$((16 - (LEN % 16))); \
	PAD_HEX=$$(printf '%02x' $$PAD); \
	PADDING=$$(printf "$${PAD_HEX}%.0s" $$(seq 1 $$PAD)); \
	HEX=$$(xxd -p exec-sh.bin | tr -d '\n')$$PADDING; \
	ESC=$$(echo "$$HEX" | sed 's/\(..\)/\\x\1/g'); \
	printf 'unsigned char code[] __attribute__((aligned(16))) =\n'; \
	printf '    "%s";\n' "$$ESC"; \
	} > payload-enc.h

encrypt: payload-enc.h aesencrypt.c
	@echo "\n[+] Compiling encrypter..."
	gcc -o aesencrypt aesencrypt.c aes.c
	@printf 'unsigned char code[] __attribute__((aligned(16))) =\n    "' > payload-dec.h
	@./aesencrypt | tr -d '\n' >> payload-dec.h
	@printf '";\n' >> payload-dec.h

decrypt: encrypt aesdecrypt.c
	@echo "\n[+] Compiling decrypter..."
	gcc -o aesdecrypt aesdecrypt.c aes.c

clean:
	@echo "[-] Cleaning..."
	rm -f exec-sh.o exec-sh exec-sh.bin aesencrypt payload-enc.h aesdecrypt payload-dec.h
