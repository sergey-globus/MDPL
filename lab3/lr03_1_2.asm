public sum

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
sum proc near
	mov ah, 1
	int 21h
	mov bl, al
	mov ah, 1
	int 21h

	mov ah, 1
	int 21h
	mov cl, al
	mov ah, 1
	int 21h
	ret
	sum endp
CSEG ENDS
END