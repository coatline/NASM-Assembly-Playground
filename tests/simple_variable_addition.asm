STDOUT equ 1
SYS_WRITE equ 4
SYS_READ equ 3
SYS_EXIT equ 1

section .data
    number1 db 3
    number2 db 4

section .bss
    dynamic_num resb 2

section .text
    global _start

_start:
    ; add 2 numbers
    mov eax, [number1]
    mov ebx, [number2]
    add eax, ebx
    mov [dynamic_num], al

    ; convert to ASCII, and add newline character
    add byte [dynamic_num], '0'
    mov byte [dynamic_num + 1], 10

    ; print
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, dynamic_num
    mov edx, 2
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80