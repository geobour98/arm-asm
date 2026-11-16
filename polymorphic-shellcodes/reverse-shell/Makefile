# ASM Makefile

.PHONY: all clean

all: clean reverse-shell-original reverse-shell-poly

reverse-shell-original: reverse-shell-original.s
	@echo "\n[+] Assembling and linking original reverse shell..."
	as -o reverse-shell-original.o reverse-shell-original.s
	ld -o reverse-shell-original reverse-shell-original.o

reverse-shell-poly: reverse-shell-poly.s
	@echo "\n[+] Assembling and linking polymorphic reverse shell..."
	as -o reverse-shell-poly.o reverse-shell-poly.s
	ld -o reverse-shell-poly reverse-shell-poly.o

clean:
	@echo "[-] Cleaning..."
	rm -f reverse-shell-original.o reverse-shell-original reverse-shell-poly.o reverse-shell-poly
