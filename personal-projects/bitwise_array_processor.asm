SYS_WRITE equ 4

section .data
    values db 10, -5, 8, 3, 12
    value_count equ 5

    msg_even db "Found an even number", 10
    msg_even_len equ $ - msg_even

    msg_odd db "Found an odd number", 10
    msg_odd_len equ $ - msg_odd

    msg_neg db "Found a negative number", 10
    msg_neg_len equ $ - msg_neg

section .bss
    result resd 1
    write_buffer resb 16
    write_buffer_len resb 1

section .text
    global _start

_start:
    mov ecx, value_count
    mov esi, 0

.process_array:
    push ecx
    mov al, [values + esi]

    cmp al, 0
    jl .is_negative

    ; Use test to check if the number is even (bit 0 is 0)
    test al, 1
    jnz .is_odd

    mov ecx, msg_even
    mov edx, msg_even_len
    call print_string
    jmp .next_item

.is_odd:
    mov ecx, msg_odd
    mov edx, msg_odd_len
    call print_string
    jmp .next_item

.is_negative:
    mov ecx, msg_neg
    mov edx, msg_neg_len
    call print_string
    jmp .next_item

.next_item:
    inc esi
    pop ecx
    loop .process_array

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

;---------------------------------------
;   ecx = pointer to string
;   edx = length of string
;---------------------------------------
print_string:
    push eax
    push ebx

    mov eax, 4 
    mov ebx, 1
    int 0x80

    pop ebx
    pop eax
    ret