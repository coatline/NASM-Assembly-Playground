#!/bin/bash

# NASM Build Script
# Usage: ./build.sh file.asm

# Check for input file
if [ -z "$1" ]; then
    echo "Usage: ./build.sh file.asm"
    exit 1
fi

file="$1"
base=$(basename "$file" .asm)

# Create build folder if it doesn't exist
mkdir -p builds

# Ensure the file has Unix line endings (avoid issues on Windows)
dos2unix "$file" >/dev/null 2>&1

# Assemble the .asm file into the build folder
nasm -f elf32 "$file" -o "builds/$base.o" || exit 1

# Link the .o file into the build folder
ld -m elf_i386 "builds/$base.o" -o "builds/$base" || exit 1

# Run the program
"./builds/$base"
