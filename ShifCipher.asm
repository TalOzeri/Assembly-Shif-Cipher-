IDEAL
MODEL small
STACK 100h
DATASEG


tryMsg db "caaaatzz$"






CODESEG


; First task:

; These are params for the first proc (Encrypt)
msgParam equ [bp + 4]
ShiftCounter equ [bp + 6]
currentArgument equ [byte ptr bx]
; End Of Params

proc Encrypt
			;prolog
	push bp
	mov bp, sp
	
	push bx
	push cx
	
	xor bx, bx
	mov bx, msgParam
	mov cl, ShiftCounter
	
ShiftIt:
	cmp currentArgument, '$' 
	je return
	cmp currentArgument, ' '
	je toInc
	add currentArgument, cl
	cmp currentArgument, 'z'
	jle toInc
	sub currentArgument, 26 ; Makes cycle

toInc:
	inc bx
	jmp ShiftIt
	
return:
	pop cx
    pop bx
	pop bp
	ret 4
		
endp Encrypt


; Third task:

; These are params for the first proc (CountCharInMsg)
msgParam equ [bp + 4]  ;The Same As The First Proc
charToCheck equ [byte ptr bp + 6]
currentArgument equ [byte ptr bx]
; End Of Params

; Using The AX to return value

proc CountCharInMsg
		;prolog
	push bp
	mov bp, sp
	
	push bx
	push cx
	mov bx, msgParam
	mov cl, charToCheck
	
	xor ax, ax
	
LoopOverTheMsg:
	cmp currentArgument, '$' 
	je return2
	cmp currentArgument, cl
	jne continueAndDontInc
incCounter:
	inc ax
continueAndDontInc:
	inc bx
	jmp LoopOverTheMsg
		

return2:
    pop cx
	pop bx
	pop bp
	ret 4
endp CountCharInMsg







proc PrintText
			;prolog
	push bp
	mov bp, sp
	
	push dx
	push ax
	
	mov dx, [bp + 4]
	
	mov ah, 9h
	int 21h
	
	pop ax
	pop dx
	pop bp
	ret 2

endp PrintText




start:
	mov ax, @data
	mov ds, ax
	
	;push 3
	push "a"
	push offset tryMsg
	call CountCharInMsg
	
	mov dx, ax
	
	mov ah, 9h
	int 21h
	
	


exit:
	mov ax, 4c00h
	int 21h
END start
