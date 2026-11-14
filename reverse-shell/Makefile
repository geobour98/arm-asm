# ASM Makefile

.PHONY: all clean

all: clean
	@echo "[+] Assembling..."
	as -o reverse.o reverse.s
	@echo "[+] Linking..."
	ld -o reverse reverse.o

clean:
	@echo "[-] Cleaning..."
	rm -f reverse.o reverse
