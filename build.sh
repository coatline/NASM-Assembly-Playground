#!/bin/bash
# Usage: ./build.sh p1.asm

FILE=$1
BASE=${FILE%.*}

nasm -g -f elf -F dwarf -o $BASE.o $FILE || exit 1
ld $BASE.o -m elf_i386 -o $BASE || exit 1
./$BASE