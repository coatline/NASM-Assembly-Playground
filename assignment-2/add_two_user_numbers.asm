SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT    equ 1
STDIN     equ 0
NL        equ 10

section .data
    title_string db "The Adding Program", NL
    title_string_length equ $-title_string
    
    prompt1 db "Please enter a single digit number: "
    prompt1_length equ $-prompt1

    answer_text db "The answer is: "
    answer_text_length equ $-answer_text

section .bss
    input_buffer1 resb 2
    input_buffer2 resb 2
    result  resb 2

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
    mov ecx, input_buffer1
    mov edx, 2
    int 0x80

    ; print second prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt1
    mov edx, prompt1_length
    int 0x80

    ; read input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input_buffer2
    mov edx, 2
    int 0x80

    ; add the two numbers
    mov al, [input_buffer1]
    sub al, '0'
    mov bl, [input_buffer2]
    sub bl, '0'
    add al, bl
    mov [result], al
    add byte [result], '0'
    mov byte [result + 1], NL

    ; print answer prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, answer_text
    mov edx, answer_text_length
    int 0x80

    ; print result
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, result
    mov edx, 2
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80