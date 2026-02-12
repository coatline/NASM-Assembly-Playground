SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT    equ 1
STDIN     equ 0
NL        equ 10

section .data
    title_string db "The Dividing Program", NL
    title_string_length equ $-title_string
    
    prompt1 db "Please enter a single digit number: "
    prompt1_length equ $-prompt1

    quotient_text db "The quotient is: "
    quotient_text_length equ $-quotient_text
    
    remainder_text db "The remainder is: "
    remainder_text_length equ $-remainder_text

section .bss
    input_buffer1 resb 2
    input_buffer2 resb 2
    quotient  resb 2
    remainder resb 2

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

    ; divide the two numbers
    xor ax, ax
    mov al, [input_buffer1]
    sub al, '0'
    sub byte [input_buffer2], '0'
    idiv byte [input_buffer2]

    mov [quotient], al
    mov [remainder], ah

    ; convert result to ASCII for printing
    add byte [quotient], '0'
    add byte [remainder], '0'
    mov byte [quotient + 1], NL
    mov byte [remainder + 1], NL

    ; print quotient prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, quotient_text
    mov edx, quotient_text_length
    int 0x80

    ; print quotient
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, quotient
    mov edx, 2
    int 0x80

    ; print remainder prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, remainder_text
    mov edx, remainder_text_length
    int 0x80

    ; print remainder
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, remainder
    mov edx, 2
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80