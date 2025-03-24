.386 
 
public count_pow 
 
extrn number: word 
extrn newline: near
 
DATASEG SEGMENT PARA PUBLIC USE16 'DATA' 
    out_msg db 'Power of 2: $' 
    pow db 0
DATASEG ENDS 
 
 
CODESEG SEGMENT PARA PUBLIC USE16 'CODE' 
    assume CS:CODESEG, DS:DATASEG 
 
get_pow:
    mov pow, 0
    mov ax, 1
    mov cx, 2

    pow_pow_pow:
        cmp ax, number
        jg pow_end
        mul cx
        inc pow
        jmp pow_pow_pow



    ;bsf ax, number ; копировать число number в ax 
    ;mov pow, ax

    pow_end:
        ret 
 
print_pow: 
    mov ah, 2 
 
    xor bx, bx 
    mov bl, pow
 
    cmp bl, 10 
    jb no_dozen 
 
    mov dl, '1' 
    int 21h 
 
    sub bl, 10 
 
    no_dozen: 
        mov dl, bl 
        add dl, '0' 
        int 21h 
 
    ret 
 
count_pow proc near 
    mov dx, OFFSET out_msg 
    mov ah, 9 
    int 21h 
 
    call get_pow 
    call print_pow
    call newline
     
    ret 
count_pow endp 
 
CODESEG ENDS 
END
