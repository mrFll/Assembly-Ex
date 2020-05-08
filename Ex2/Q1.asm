; 2) Convert lower case alphabet immediately after '.' to upper case
; from memory location 0300 to 0400
CODESEG SEGMENT PARA 'code'
	ASSUME cs:codeseg, ds:codeseg, ss:codeseg, es:codeseg
	ORG 100H
begin: jmp main
	txt DT ".a.b.D.e"
	main PROC NEAR
				mov AL, offset txt
		start:	cmp [BX],'.' ; ASCII code of '.'
				jne next
				call change ; check the character in position [BX+1] to see if it lower case
		next:	inc BX
				cmp BX,400
				jbe start
				
		change:	mov AL,[BX+1]	; Read the character from memory location immediately after '.'
				cmp AL,61H ; 'a'
				jb finish
				cmp AL,7AH ; 'z'
				ja finish
				and AL,11011111b ; or sub al,20h to convert it to upper case
				mov [BX+1], AL ; Store the converted character back to the memory
				inc BX ; We are sure next character is not '.' so let's pass over it
		finish:	mov AX, 4C00H
				int 21H
	main ENDP

CODESEG ENDS

END begin