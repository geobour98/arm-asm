# ASM Makefile

.PHONY: all clean

all: clean
	@echo "[+] Assembling..."
	as -o bind.o bind.s
	@echo "[+] Linking..."
	ld -o bind bind.o

clean:
	@echo "[-] Cleaning..."
	rm -f bind.o bind
