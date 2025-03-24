.MODEL TINY
.DOSSEG
.DATA
	MSG DB "Hello, World!", 0Dh, 0Ah, '$'  ; 13 - to start of line, 10 - to new line
.CODE
.STARTUP
	MOV AH, 09h
	MOV DX, OFFSET MSG
	INT 21h
	MOV AH, 4Ch
	INT 21h
END