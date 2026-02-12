SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDIN equ 0
STDOUT equ 1

section .data
    prompt1 db "Type something: ", 0
    prompt1_length equ $ - prompt1

    prompt2 db "You typed: ", 0
    prompt2_length equ $ - prompt2

section .bss
    input_buffer1 resb 64

section .text
    global _start

SYS_WRITE equ 4

_start:
    ; print prompt 1
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt1
    mov edx, prompt1_length
    int 0x80

    ; get input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input_buffer1
    mov edx, 16
    int 0x80

    ; store the size of the received input
    mov esi, eax

    ; print prompt 2
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt2
    mov edx, prompt2_length
    int 0x80

    ; print what the user typed
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, input_buffer1
    mov edx, esi
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80