; Code flow:
; Prompt the user to choose an operation
; Read input
; If the input is a valid
; Prompt the user to enter the first number
; Read input
; Prompt the user to enter the second number
; Read input
; Perform the chosen operation
; Print the result

section .data
    prompt db "Enter an operation (+, -, *, /) or 'q' to quit: ", 0
    prompt_len equ $ - prompt

    num_prompt db "Enter a number: ", 0
    num_prompt_len equ $ - num_prompt

    msg_result db "The result is: ", 0
    msg_result_len equ $ - msg_result

    msg_invalid_op db "Enter a valid operand.", 10
    msg_invalid_op_len equ $ - msg_invalid_op

    leave_msg db "Bye!", 10
    leave_msg_len equ $ - leave_msg

    cannot_divide_by_zero db "Can't divide by zero!", 10
    div_by_zero_len equ $ - cannot_divide_by_zero

    remainder_msg db "Remainder: ", 0
    remainder_msg_len equ $ - remainder_msg

    new_line db 10

section .bss
    operation resb 1
    num1 resb 1
    num2 resb 1
    result resb 1
    trash resb 1

section .text
    global _start

_start:

.get_operation_while:
    ; Ask for operation
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read first inputed character
    mov eax, 3
    mov ebx, 0
    mov ecx, operation
    mov edx, 1
    int 0x80

    mov al, [operation]
    cmp al, 'q'
    je .exit_program
    cmp al, '+'
    je .enter_numbers
    cmp al, '-'
    je .enter_numbers
    cmp al, '*'
    je .enter_numbers
    cmp al, '/'
    je .enter_numbers

    jmp .input_error

.input_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalid_op
    mov edx, msg_invalid_op_len
    int 0x80

    ; Drain the input buffer (for the newline after the operator)
    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    jmp .get_operation_while

.enter_numbers:
    ; Drain the input buffer (for the newline after the operator)
    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, num_prompt
    mov edx, num_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 1
    int 0x80

    ; Drain the input buffer (for the newline)
    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, num_prompt
    mov edx, num_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 1
    int 0x80

    ; Drain the input buffer (for the newline)
    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    jmp .operate

.operate:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result
    mov edx, msg_result_len
    int 0x80

    mov al, [operation]
    cmp al, '+'
    je .add_numbers
    cmp al, '-'
    je .sub_numbers
    cmp al, '*'
    je .mul_numbers
    cmp al, '/'
    je .div_numbers

    jmp .exit_program

.add_numbers:
    mov al, [num1]
    sub al, '0'

    mov bl, [num2]
    sub bl, '0'

    add al, bl
    add al, '0'

    mov [result], al

    jmp .print_result

.sub_numbers:
    mov al, [num1]
    sub al, '0'

    mov bl, [num2]
    sub bl, '0'

    sub al, bl
    add al, '0'

    mov [result], al

    jmp .print_result

.mul_numbers:
    mov al, [num1]
    sub al, '0'

    mov bl, [num2]
    sub bl, '0'

    mul bl  ; result is in ax

    add al, '0'
    mov [result], al
    jmp .print_result

.div_numbers:
    mov al, [num1]
    sub al, '0'

    ; Clear AH so AX is just the value in AL
    xor ah, ah

    mov bl, [num2]
    sub bl, '0'

    ; check for division by zero
    test bl, bl
    jz .tried_dividing_by_zero

    ; Quotient goes to AL, remainder to AH
    div bl  ; (AX / BL)

    add al, '0'
    mov [result], al

    add ah, '0'
    mov [trash], ah

    ; print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

    ; print the remainder message
    mov eax, 4
    mov ebx, 1
    mov ecx, remainder_msg
    mov edx, remainder_msg_len
    int 0x80

    ; print the remainder
    mov eax, 4
    mov ebx, 1
    mov ecx, trash
    mov edx, 1
    int 0x80

    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

    jmp .get_operation_while

.tried_dividing_by_zero:
    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, cannot_divide_by_zero
    mov edx, div_by_zero_len
    int 0x80

    jmp .get_operation_while

.print_result:
    ; print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

    jmp .get_operation_while

.exit_program:
    mov eax, 4
    mov ebx, 1
    mov ecx, leave_msg
    mov edx, leave_msg_len
    int 0x80

    ; Drain the input buffer (for the newline after the operator)
    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx ; Clear exit flag (0 in ebx is success)
    int 0x80