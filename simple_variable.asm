section .data
    number db 3

section .bss
    dynamic_num resb 5

section .text
    global _start

SYS_WRITE equ 4
SYS_READ equ 3
SYS_EXIT equ 1

_start:
    mov eax, 3
    mov ebx, 4
    add eax, ebx

    mov al, [number]
    mov [dynamic_num], al

    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, dynamic_num + '0'
    mov edx, 1
    int 0x80