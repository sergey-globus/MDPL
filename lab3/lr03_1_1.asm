extrn sum: near

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
main:
	call sum
	mov ax, bx
	add cx, ax
	mov ax, cx
	sub al, '0'
	mov dx, ax
	mov ah, 2
	int 21h

	mov ah, 4ch
	int 21h

CSEG ENDS

STK_2 SEGMENT PARA STACK 'STACK'
	db 300 dup(0)
STK_2 ENDS
end main