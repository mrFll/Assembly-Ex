		mov BX,100
		mov AL,[200+BX]	; Read the character from memory to AL
check:	cmp AL,61H ; 'a'
		jb next
		cmp AL,7AH ; 'z'
		ja next
		and AL,11011111b ; or sub al,20h to convert it to upper case
		mov [100+BX], AL ; Store the converted character back to the memory
next:	dec BX
		jns	check