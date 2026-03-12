SYS_WRITE equ 4
SYS_READ equ 3
SYS_EXIT equ 1
STDOUT equ 1
STDIN equ 0
NL equ 10

section .data
    prompt db "Please enter a string:", NL
    prompt_len equ $ - prompt
    msg_is_pal db "It is a palindrome", NL
    msg_is_pal_len equ $ - msg_is_pal
    msg_not_pal db "It is NOT a palindrome", NL
    msg_not_pal_len equ $ - msg_not_pal

section .bss
    buffer resb 1024

section .text
    global _start

_start:
.main_loop:
    ; Print the prompt
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read the input
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; does the value of buffer equal a new line? if so, exit_program
    cmp byte [buffer], NL
    je .exit_program

    mov esi, eax    ; save the read length in esi
    dec esi         ; subtract 1 to ignore the new line at the end

    push esi        ; push 2nd argument length of buffer
    push buffer     ; push 1st argument buffer address

    call is_palindrome

    ; esp is a special register that always points to the top of the stack.

.print_false:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg_not_pal
    mov edx, msg_not_pal_len
    int 0x80
    jmp .main_loop

.exit_program:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

is_palindrome:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; [ebp + 8]  is the first argument (buffer address)
    ; [ebp + 12] is the second argument (length)
    mov esi, [ebp + 8]  
    mov ecx, [ebp + 12] 

    ; We will build this part next! 
    ; For now, we "hardcode" a success return value.
    mov eax, 1          

    pop edi             ; Restore registers in reverse order
    pop esi
    pop ebx
    mov esp, ebp        ; Reset stack pointer to base pointer
    pop ebp             ; Restore caller's base pointer
    ret                 ; Return to caller