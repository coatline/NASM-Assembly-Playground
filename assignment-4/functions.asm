global addstr
global is_palindromeASM
global factstr
global palindrome_check

extern atoi
extern fact
extern is_palindromeC
extern printf
extern scanf

section .data
    prompt db "Enter a string for ASM->C check: ", 0
    format_s db "%s", 0
    res_true db "It is a palindrome! (checked by C)", 10, 0
    res_false db "Not a palindrome! (checked by C)", 10, 0

section .text

; addstr(char *a, char *b)
addstr:
    push ebp ; store the caller's base pointer
    mov ebp, esp ; set the base pointer to the bottom of our stack
    push ebx ; store caller's ebx so that we can use it in this function
    
    ; convert a to int
    push dword [ebp+8] ; esp moves down pointing to 'a'
    call atoi ; looks at esp to pass 'a' as a parameter
    add esp, 4 ; move esp back up, reclaiming the spot used for 'a'
    mov ebx, eax ; move the result to ebx
    
    ; convert b to int
    push dword [ebp+12] ; esp moves down pointing to 'b'
    call atoi ; looks at esp to pass 'b' as a parameter
    add esp, 4 ; move esp back up, reclaiming the spot used for 'b'
    
    add eax, ebx ; add them, storing the result in eax
    
    pop ebx ; restore ebx to it's caller's value
    mov esp, ebp ; set esp to our base pointer
    pop ebp ; restore our initial base pointer
    ret ; now esp is pointing to our return address, so we return to the caller

; is_palindromeASM(char *s)
is_palindromeASM:
    push ebp ; store the caller's base pointer
    mov ebp, esp ; set the base pointer to the bottom of our stack
    ; store these registers so we can modify them
    push esi
    push edi
    push ebx

    mov esi, [ebp + 8] ; set our source index to the start of our string
    
    mov edi, esi ; set our destination index to the start too
    xor ecx, ecx ; ecx = 0
.len_loop:
    cmp byte [edi], 0 ; is the character that the destination index is pointing to a null byte (0) (C strings are null-terminated)?
    je .len_done ; if so, we found the end.
    inc edi ; move our destination index forward
    inc ecx ; ecx++ increment our counter
    jmp .len_loop
.len_done:
    dec edi ; move our edi back to the ending character instead of the null byte 

    mov eax, ecx ; store length in eax
    xor edx, edx ; clear edx
    mov ebx, 2 ; move 2 into ebx
    div ebx ; divide edx:eax by ebx (length / 2) (result is stored in eax, remainder in edx)
    mov ecx, eax ; store (length / 2) into ecx

.compare_loop:
    test ecx, ecx ; is our counter 0?
    jz .true_exit ; if yes, it's a palindrome since we checked everything

    mov al, [esi] ; get the letter from the front pointer
    mov dl, [edi] ; get the letter from the back pointer
    cmp al, dl ; if they are not equal, return false
    jne .false_exit

    inc esi ; increase our starting index
    dec edi ; decrease our starting index
    dec ecx ; decrease our counter
    jmp .compare_loop

.false_exit:
    mov eax, 0 ; return 0 (false)
    jmp .finish
.true_exit:
    mov eax, 1 ; return 1 (true)
.finish:
    ; restore our registers
    pop ebx
    pop edi
    pop esi
    mov esp, ebp ; move our stack pointer back to the base
    pop ebp ; restore ebp to what our base pointer was before
    ret ; return the remaining return address

; factstr(char *s)
factstr:
    push ebp
    mov ebp, esp
    
    push dword [ebp + 8] ; push the value of our string to the stack as a parameter
    call atoi ; convert s to int
    add esp, 4 ; clean up our stack
    
    push eax ; add eax as a parameter
    call fact ; call our C function
    add esp, 4 ; clean up our stack
    
    mov esp, ebp
    pop ebp
    ret

; palindrome_check()
palindrome_check:
    push ebp
    mov ebp, esp
    sub esp, 100 ; create a buffer for our input

    push prompt ; print our "Enter a string for ASM->C check:"
    call printf
    add esp, 4

    mov eax, ebp
    sub eax, 100
    push eax ; push our buffer
    push format_s ; push '%s'
    call scanf ; call essentially scanf("%s", ebp - 100)
    add esp, 8 ; account for the parameters we pushed

    mov eax, ebp
    sub eax, 100
    push eax
    call is_palindromeC
    add esp, 4

    test eax, eax ; check if eax is false
    jz .false_label
    push res_true
    jmp .print_done
.false_label:
    push res_false
.print_done:
    call printf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret