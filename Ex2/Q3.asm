; 5) Reverse the String in memmory stored from 300 to 400

		mov SI,300	; SI points to the beginning of the string
		mov DI,400	; DI points to the end of the string
next:	mov AL,[SI]
		mov AH,[DI]
		mov[DI],AL
		mov [SI],AH
		inc SI
		dec DI
		cmp SI,DI
		jb next