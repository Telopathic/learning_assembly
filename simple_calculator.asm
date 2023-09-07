section .data
    result db 0
    operand1 db 0
    operand2 db 0
    operator db 0

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, operand1
    mov edx, 10
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, operator
    mov edx, 2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, operand2
    mov edx, 10
    int 0x80

    mov eax, 0
    mov esi, operand1
    call ascii_to_int

    mov eax, 0
    mov esi, operand2
    call ascii_to_int

    mov al, [operator]
    cmp al, '+'
    je add_numbers
    cmp al, '-'
    je subtract_numbers
    cmp al, '*'
    je multiply_numbers
    cmp al, '/'
    je divide_numbers

    jmp invalid_operator

add_numbers:
    add eax, ebx
    jmp calculate_done

subtract_numbers:
    sub eax, ebx
    jmp calculate_done

multiply_numbers:
    imul eax, ebx
    jmp calculate_done

divide_numbers:
    cdq
    idiv ebx
    jmp calculate_done

invalid_operator:
    ; Handle invalid operator
    ; You can customize the error message here
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 0x80

calculate_done:
    mov esi, eax
    mov eax, 0
    call int_to_ascii

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

ascii_to_int:
    xor ebx, ebx
ascii_to_int_loop:
    movzx edx, byte [esi]
    cmp edx, 10
    je ascii_to_int_done
    imul ebx, ebx, 10
    sub edx, '0'
    add ebx, edx
    inc esi
    jmp ascii_to_int_loop

ascii_to_int_done:
    mov eax, ebx
    ret

int_to_ascii:
    add esi, 10
    mov byte [esi], 0
int_to_ascii_loop:
    dec esi
    xor edx, edx
    div byte 10
    add dl, '0'
    mov [esi], dl
    test eax, eax
    jnz int_to_ascii_loop
    ret

section .bss
    error_msg resb 13
    error_len equ $ - error_msg
