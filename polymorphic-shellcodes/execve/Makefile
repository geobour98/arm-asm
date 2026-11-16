# ASM Makefile

.PHONY: all clean

all: clean exec-sh-original exec-sh-poly

exec-sh-original: exec-sh-original.s
	@echo "\n[+] Assembling and linking original execve /bin/sh..."
	as -o exec-sh-original.o exec-sh-original.s
	ld -o exec-sh-original exec-sh-original.o

exec-sh-poly: exec-sh-poly.s
	@echo "\n[+] Assembling and linking polymorphic execve /bin/sh..."
	as -o exec-sh-poly.o exec-sh-poly.s
	ld -o exec-sh-poly exec-sh-poly.o

clean:
	@echo "[-] Cleaning..."
	rm -f exec-sh-original.o exec-sh-original exec-sh-poly.o exec-sh-poly
