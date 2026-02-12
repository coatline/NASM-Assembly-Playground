# x86 NASM Assembly Playground (32-bit Linux)

This repository contains small programs written in **x86 assembly (NASM syntax)** targeting **32-bit Linux**.
All programs are written without the C standard library and interact directly with the Linux kernel via syscalls.

The goal is to demonstrate low-level concepts including:
- Registers
- Memory access
- Arithmetic
- Linux syscalls
- User input handling
- ASCII conversion

---

# Environment Requirements

- OS: Linux (Ubuntu recommended) or WSL on Windows
- Assembler: NASM
- Linker: GNU `ld`
- Architecture: 32-bit (ELF)

---

# 1. Install Required Tools

On Ubuntu / WSL:

```bash
sudo apt update
sudo apt install nasm gcc-multilib libc6-dev-i386
```
Verify installation:
```bash
nasm -v
ld -v
```

This project builds 32-bit binaries. On a 64-bit system, ensure 32-bit libraries are installed:
`sudo apt install libc6-dev-i386`

## Building a Program

### Manually:

Assume the file is named p1.asm.

Assemble:
`nasm -f elf32 [FILE].asm -o [OUTPUT].o`

Link:
`ld -m elf_i386 [FILE].o -o p1`

Run:
`./p1`

Verify architecture:
`file p1`
The expected output should include:
`ELF 32-bit LSB executable, Intel 80386`

### Bash Script:

```bash
# Convert Windows line endings to Unix (if needed)
sudo apt install dos2unix       # install dos2unix if not already installed
dos2unix build.sh               # convert line endings

# Make script executable
chmod +x build.sh

# Run the script on your assembly file
./build.sh [FILE].asm
```

## Using Windows

Recommended method: WSL (Windows Subsystem for Linux)
`wsl --install` (if you don't already have it installed)
`wsl --install -d Debian`

## Debugging (Optional)

To debug with gdb:

Install gdb:
```
sudo apt install gdb
gdb ./p1
```

Inside gdb:
```
break _start
run
info registers
```

This allows inspection of register values and execution flow.

### Concepts Covered

- Register manipulation
- Memory addressing
- Stack basics
- Linux syscalls (`int 0x80`)
- ASCII ↔ integer conversion
- Basic control flow (loops, conditionals)