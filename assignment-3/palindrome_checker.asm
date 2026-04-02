SYS_WRITE equ 4
SYS_READ equ 3
SYS_EXIT equ 1
STDOUT equ 1
STDIN equ 0
NL equ 10

section .data
    prompt db "Please enter a string:", 10
    prompt_len equ $ - prompt
    is_pal_msg db "It is a palindrome", 10
    is_pal_len equ $ - is_pal_msg
    not_pal_msg db "It is NOT a palindrome", 10
    not_pal_len equ $ - not_pal_msg

section .bss
    buffer resb 1024

section .text
    global _start

_start:

main_loop:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; If the input size is 1, it's just a new line, so we can quit
    cmp eax, 1
    jbe exit_program
    
    dec eax ; exclude the newline
    push eax ; length
    push buffer ; buffer
    call is_palindrome
    add esp, 8 ; clean up stack (2 args * 4 bytes)

    ; Check what we returned
    cmp eax, 1
    je print_is_pal

print_not_pal:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, not_pal_msg
    mov edx, not_pal_len
    int 0x80
    jmp main_loop

print_is_pal:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, is_pal_msg
    mov edx, is_pal_len
    int 0x80
    jmp main_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; int is_palindrome(char* buffer, int len)
is_palindrome:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    mov esi, [ebp + 8] ; esi is the starting letter address
    mov ecx, [ebp + 12] ; input length
    
    ; Make edi the ending letter address
    mov edi, esi
    add edi, ecx
    dec edi

    ; Set number of loops to input length / 2
    mov eax, ecx
    mov edx, 0
    mov ebx, 2
    div ebx
    mov ecx, eax

.compare_loop:
    test ecx, ecx
    jz .true_exit

    mov al, [esi] ; Starting letter
    mov dl, [edi] ; Ending letter
    cmp al, dl
    jne .false_exit

    inc esi ; Starting index++
    dec edi ; Ending index--
    dec ecx ; i--
    jmp .compare_loop

.false_exit:
    mov eax, 0
    jmp .finish

.true_exit:
    mov eax, 1

.finish:
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret