; 2) Convert lower case alphabet immediately after '.' to upper case
;    from memory location 0300 to 0400

		
change:	mov AL,[BX+1]	; Read the character from memory location immediately after '.'
		cmp AL,61H ; 'a'
		jb finish
		cmp AL,7AH ; 'z'
		ja finish
		sub AL,20 ; or sub al,20h to convert it to upper case
		mov [BX+1], AL ; Store the converted character back to the memory
		inc BX ; We are sure next character is not '.' so let's pass over it
finish:	ret

		mov BX,300
start:	mov al,2e ; ASCII code of '.'
        cmp [bx],al 
		jne next
		call change ; check the character in position [BX+1] to see if it lower case
next:	inc BX
		cmp BX,400
		jbe start