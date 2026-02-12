section .text
    global _start

_start:
    mov eax, 5
    mov ebx, 3
    add eax, ebx

    mov eax, 1
    mov ebx, 0
    int 0x80