#!/usr/bin/python3
import sys

with open(sys.argv[1], "rb") as f:
    shellcode = f.read()

encoded = ".byte "
key = 0xAA
sub_value = 1

for x in bytearray(shellcode):
	# XOR encoding
	y = ((x ^ key) - sub_value) & 0xFF
	encoded += '0x%02x,' % y

print(encoded[:-1])
