SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT    equ 1
STDIN     equ 0
NL        equ 10

section .data
    title_string db "The Swapping Program", NL
    title_string_length equ $-title_string
    
    prompt1 db "Please enter a two character string: "
    prompt1_length equ $-prompt1

    answer_text db "The answer is: "
    answer_text_length equ $-answer_text

section .bss
    two_char_string resb 3  ; added an extra character to put a newline into when printing 

section .text
    global _start

_start:
    ; print the title string
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, title_string
    mov edx, title_string_length
    int 0x80

    ; print first prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt1
    mov edx, prompt1_length
    int 0x80

    ; read input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, two_char_string
    mov edx, 2
    int 0x80

    ; swap the two characters
    mov al, [two_char_string]
    mov bl, [two_char_string + 1]

    mov byte [two_char_string], bl
    mov byte [two_char_string + 1], al
    mov byte [two_char_string + 2], NL

    ; print result prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, answer_text
    mov edx, answer_text_length
    int 0x80

    ; print result
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, two_char_string
    mov edx, 3
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80