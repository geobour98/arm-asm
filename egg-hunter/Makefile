# ASM Makefile

.PHONY: all clean

all: clean shellcode

egg-hunter: egg-hunter.s
	@echo "[+] Assembling and linking egg-hunter..."
	as -o egg-hunter.o egg-hunter.s
	ld -o egg-hunter egg-hunter.o

reverse: reverse.s
	@echo "[+] Assembling and linking reverse shell..."
	as -o reverse.o reverse.s
	ld -o reverse reverse.o

reverse.bin: reverse
	@echo "\n[+] Creating reverse shell's raw bytes..."
	objcopy -O binary -j .text reverse reverse.bin
	xxd -p reverse.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g'; echo

egg-hunter.bin: egg-hunter
	@echo "\n[+] Creating egg hunter's raw bytes..."
	objcopy -O binary -j .text egg-hunter egg-hunter.bin
	xxd -p egg-hunter.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g'; echo

payload.h: reverse.bin egg-hunter.bin
	@echo "[+] Generating payload.h..."
	@{ \
	  printf 'unsigned char code[] __attribute__((aligned(16))) =\n'; \
	  printf '    "\\x90\\x50\\x90\\x50\\x90\\x50\\x90\\x50"\n'; \
	  printf '    "%s";\n\n' "$$(xxd -p reverse.bin    | tr -d '\n' | sed 's/\(..\)/\\x\1/g')"; \
	  printf 'unsigned char egghunter[] __attribute__((aligned(16))) =\n'; \
	  printf '    "%s";\n'   "$$(xxd -p egg-hunter.bin | tr -d '\n' | sed 's/\(..\)/\\x\1/g')"; \
	} > payload.h

shellcode: payload.h shellcode.c
	@echo "[+] Compiling loader..."
	gcc -no-pie -o shellcode shellcode.c

clean:
	@echo "[-] Cleaning..."
	rm -f egg-hunter.o egg-hunter egg-hunter.bin reverse.o reverse reverse.bin payload.h shellcode
