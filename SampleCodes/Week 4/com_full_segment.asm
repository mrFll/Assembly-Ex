; Assume that X is stored as a byte in memory. Calculate 3x^2+5x-7 ans store it in memory
; .com with full segment definition

CODESEG SEGMENT PARA 'code'
	ASSUME cs:codeseg, ds:codeseg, ss:codeseg, es:codeseg
	ORG 100H
begin: 	jmp main
	x DB 12 ; both DB abd BYTE work
	result WORD ?	; both DW and WORD work
	main PROC NEAR
		mov AL,x	
		xor AH,AH	; AX <= x
		mov BX,AX	; BX <= x
		shl BX,1	; BX <= 2x
		shl	BX,1	; BX <= 4x
		add	BX,AX	; BX <= 5x
		mul	AL		; AX <= x^2
		mov CX,AX	; CX <= x^2
		shl AX,1	; AX <= 2x^2
		add AX,CX	; AX <= 3x^2
		add AX,BX	; AX <= 3x^2+5x
		sub AX,7	; AX <= 3x^2+5x-7
		mov result,AX
		mov AX, 4C00H
		int 21H
	main ENDP
	
CODESEG ENDS

END begin