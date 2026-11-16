# ASM Makefile

.PHONY: all clean

all: clean bind-shell-original bind-shell-poly

bind-shell-original: bind-shell-original.s
	@echo "\n[+] Assembling and linking original bind shell..."
	as -o bind-shell-original.o bind-shell-original.s
	ld -o bind-shell-original bind-shell-original.o

bind-shell-poly: bind-shell-poly.s
	@echo "\n[+] Assembling and linking polymorphic bind shell..."
	as -o bind-shell-poly.o bind-shell-poly.s
	ld -o bind-shell-poly bind-shell-poly.o

clean:
	@echo "[-] Cleaning..."
	rm -f bind-shell-original.o bind-shell-original bind-shell-poly.o bind-shell-poly
