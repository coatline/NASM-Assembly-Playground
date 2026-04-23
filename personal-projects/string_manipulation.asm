SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT    equ 1
STDIN     equ 0
NL        equ 10

section .data
    prompt db "Enter a string: "
    prompt_len equ $-prompt

    choose_prompt db "Choose one:", NL, "1) capitalize", NL, "2) get length", NL, "3) append", NL, "Choice: "
    choose_prompt_len equ $-choose_prompt

    type_append_prompt db "Type string to append: "
    type_append_prompt_len equ $-type_append_prompt

    retry db "Enter 1, 2, or 3: "
    retry_len equ $-retry

section .bss
    string_buffer resb 16
    string2_buffer resb 16
    appended_buffer resb 32
    choice_buffer resb 10
    result resb 16

section .text
    global _start

_start:
    ; print prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; read string
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, string_buffer
    mov edx, 16
    int 0x80

    ; null terminate input
    mov byte [string_buffer + eax], 0

    ; print menu
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, choose_prompt
    mov edx, choose_prompt_len
    int 0x80

.choice_input:
    ; read choice
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, choice_buffer
    mov edx, 2
    int 0x80

    ; null terminate (eax contains the length of our input)
    mov byte [choice_buffer + eax], 0

    cmp byte [choice_buffer], '1'
    je .capitalize

    cmp byte [choice_buffer], '2'
    je .get_length

    cmp byte [choice_buffer], '3'
    je .append

    ; invalid input
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, retry
    mov edx, retry_len
    int 0x80

    jmp .choice_input

.capitalize:
    mov esi, string_buffer

.capitalize_loop:
    mov al, [esi]

    cmp al, 0
    je .print_result

    cmp al, 'a'
    jb .next
    cmp al, 'z'
    ja .next

    sub al, 32
    mov [esi], al

.next:
    inc esi
    jmp .capitalize_loop

.get_length:
    jmp .print_result

.append:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, type_append_prompt
    mov edx, type_append_prompt_len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, string2_buffer
    mov edx, 16
    int 0x80

    ; null terminate (eax contains the length of our input)
    mov byte [string2_buffer + eax], 0

    mov esi, string_buffer
    mov edi, appended_buffer
    cld

.copy1:
    lodsb
    stosb
    cmp al, 0
    jne .copy1

    mov esi, string2_buffer

.copy2:
    lodsb
    stosb
    cmp al, 0
    jne .copy2

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, appended_buffer
    mov edx, 32
    int 0x80

    jmp .exit

.print_result:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, string_buffer
    mov edx, 16
    int 0x80

.exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80