; p1.asm - Add two single-digit numbers
; 32-bit Linux NASM

SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1

section .data
    prompt1 db "Please enter a single digit number: ", 0
    prompt1_len equ $-prompt1

    prompt2 db "Please enter a single digit number: ", 0
    prompt2_len equ $-prompt2

    answer_text db "The answer is: ", 0
    answer_text_len equ $-answer_text

    newline db 10

section .bss
    buffer1 resb 16   ; store first input line
    buffer2 resb 16   ; store second input line
    result  resb 16   ; store result character

section .text
    global _start

_start:
    ; Prompt first number
    mov eax, SYS_WRITE
    mov ebx, 1           ; stdout
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    ; Read first line
    mov eax, SYS_READ
    mov ebx, 0           ; stdin
    mov ecx, buffer1
    mov edx, 16          ; max 16 bytes
    int 0x80

    ; Convert first character to number
    mov al, [buffer1]    ; first char
    sub al, '0'
    mov bl, al           ; save in BL

    ; Prompt second number
    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    ; Read second line
    mov eax, SYS_READ
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 16
    int 0x80

    ; Convert first character to number
    mov al, [buffer2]
    sub al, '0'

    ; Add numbers
    add al, bl           ; AL = first + second
    add al, '0'          ; convert to ASCII
    mov [result], al

    ; Print answer text
    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, answer_text
    mov edx, answer_text_len
    int 0x80

    ; Print result
    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Print newline
    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80