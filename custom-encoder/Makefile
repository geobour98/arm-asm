# ASM Makefile

.PHONY: all clean

all: clean shellcode

exec-sh: exec-sh.s
	@echo "[+] Assembling and linking shell..."
	as -o exec-sh.o exec-sh.s
	ld -o exec-sh exec-sh.o

exec-sh.bin: exec-sh
	@echo "\n[+] Creating shell's raw bytes..."
	objcopy -O binary -j .text exec-sh exec-sh.bin
	xxd -p exec-sh.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g'; echo

shellcode.inc: exec-sh.bin xor-encoder.py
	@echo "\n[+] Encoding shellcode..."
	python3 xor-encoder.py exec-sh.bin > shellcode.inc
	cat shellcode.inc

decoder: xor-decoder.s shellcode.inc
	@echo "\n[+] Assembling and linking decoder..."
	as -o xor-decoder.o xor-decoder.s
	ld -N -o xor-decoder xor-decoder.o

decoder.bin: decoder
	@echo "\n[+] Creating decoder's raw bytes..."
	objcopy -O binary -j .text xor-decoder xor-decoder.bin
	xxd -p xor-decoder.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g'; echo

payload.h: decoder.bin
	@echo "[+] Generating payload.h..."
	@{ \
	  printf 'unsigned char code[] __attribute__((aligned(16))) =\n'; \
	  printf '    "%s";\n' "$$(xxd -p xor-decoder.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g')"; \
	} > payload.h

shellcode: payload.h shellcode.c
	@echo "\n[+] Compiling loader..."
	gcc -no-pie -o shellcode shellcode.c

clean:
	@echo "[-] Cleaning..."
	rm -f exec-sh.o exec-sh exec-sh.bin shellcode.inc xor-decoder.o xor-decoder xor-decoder.bin payload.h shellcode
