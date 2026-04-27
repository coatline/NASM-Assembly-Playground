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

    length_prompt db "Length: "
    length_prompt_len equ $-length_prompt

    retry db "Enter 1, 2, or 3: "
    retry_len equ $-retry

    newline_char db 10

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

    ; replace newline with null character (eax contains the length of our input)
    mov byte [string_buffer + eax - 1], 0

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

    ; replace newline with null character (eax contains the length of our input)
    mov byte [choice_buffer + eax - 1], 0

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
    je .print_capital

    cmp al, 'a'
    jb .next
    cmp al, 'z'
    ja .next

    sub al, 32
    mov [esi], al

.next:
    inc esi
    jmp .capitalize_loop

.print_capital:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, string_buffer
    mov edx, 16
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newline_char
    mov edx, 1
    int 0x80

    jmp .exit

.get_length:
    mov edi, string_buffer
    mov ecx, -1 ; run until the condition is met
    mov al, 0 ; set our target to the null character
    cld ; move forwards

    repne scasb ; repeat while it's not equal to the null character

    not ecx ; ecx started at -1 and decreased every iteration of repne, so we can flip it to get the positive number
    dec ecx ; add 1 to account for starting at -1

    add cl, '0'
    mov [string2_buffer], cl
    mov byte [string2_buffer + 1], 10

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, length_prompt
    mov edx, length_prompt_len
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, string2_buffer
    mov edx, 16
    int 0x80

    jmp .exit

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

    ; replace newline with null character (eax contains the length of our input)
    mov byte [string2_buffer + eax - 1], 0

    mov esi, string_buffer
    mov edi, appended_buffer
    cld

.copy1:
    lodsb
    cmp al, 0
    je .copy2_start
    stosb
    jmp .copy1

.copy2_start:
    mov esi, string2_buffer

.copy2:
    lodsb
    cmp al, 0
    je .done
    stosb
    jmp .copy2

.done:
    mov byte [edi], 0
    mov byte [edi + 1], 10

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, appended_buffer
    mov edx, 32
    int 0x80

    jmp .exit

.flush_stdin:
    push eax
    push ebx
    push ecx
    push edx
    sub esp, 4 ; Create a 1-byte local buffer on stack

.flush_loop:
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, esp ; Read into the stack space
    mov edx, 1
    int 0x80

    cmp eax, 0 ; EOF or Error
    jle .flush_done
    cmp byte [esp], NL ; Did we hit the newline?
    jne .flush_loop

.flush_done:
    add esp, 4 ; Clean up stack
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

.exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80