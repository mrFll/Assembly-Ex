; part 1) Write all the lecture codes in Debug and run them. Test them with at least one test case and make screenshots of the code, input, and output to demonstrate that your code is working and you understand it.
; part 2) Modify code 4 to generalize subtraction to 10 bytes . Include your code and screenshots
; part ^3) By using the procedure in code 6 (checking if a number is prime) 
;			write a code to find all the prime numbers less than 
;			n ( n in bx) and store them in memory from 200 onward
; part ^4) Modify the code 7 for x stored in AX rather than AL ( 16 bit vs 8 bits)
; part 5) Generalize the 1 bit shift for 64 bit DX:CX:BX:AX

; 1) Convert lower case alphabets to upper case from memory location 0200 to 0300 

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
		
-----------------------------------------------------------------------------------
; 2) Convert lower case alphabet immediately after '.' to upper case
; from memory location 0300 to 0400

		mov BX,300
start:	cmp [BX],2E ; ASCII code of '.'
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
finish:	ret

-----------------------------------------------------------------------------------

; 3) Calculate the product/multiplication of n terms of Fibonacci sequence
; number of terms n is in AL and the product of terms should be stored in DX:AX

		mov CL,AL
		xor CH,CH;	; store n in CX to be sued for loop
		mov SI,1	; term n-1
		mov BX,2	; term n
		mov AX,1	; the initial product
lbl:	mul BX		; multiply n'th term to the product. We assume that the product is small and DX=0
		mov DI,SI	; store term n-1 in a temp var (DI)
		mov SI,BX	; old term n becomes new term n-1
		add BX,DI	; calculate new n'th term by adding two preceding ones
		loop lbl
		
-------------------------------------------------------------------------------------

; 4) Generalize the add to add to 80 bits numbers stored in memory location 200-207 and 210-217

		mov bx,6
		clc		;clear carry flag to be able to use adc for the first time
		pushf	;push the flags for the first time to make the popf working
lbl:	popf
		mov AX,[BX+200]
		ADC	AX,[BX+210]
		mov [BX+200],AX
		pushf	; store the carry flag
		dec BX	;instead of sub bx,2
		dec BX
		jns	lbl
		
----------------------------------------------------------------------------------------

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
		
---------------------------------------------------------------------------------------

; 6) Check to see if the number in BX is prime or not. Set the carry flag if it is a prime number
; clear it if it is not a prime number

check:	mov CX,BX
		shr CX,1 	; a number is prime if not divisible by numbers less than n/2
loop1:	mov AX,BX
		xor DX,DX	; put the number in DX:AD to be able to divide it by CX
		div CX		; check to see if BX is divisible by CX
		test DX,FF	; or cmp DX,00 which checks if remainder is 0
		jz end
		cmp CX,2	;end of the loop to see if number is prime
		jae	loop1
		stc			; set the carry flag to send the return value to caller that BX is prime
		ret
end:	clc			; the number is not prime
		ret

-----------------------------------------------------------------------------------------

; 7) calculate 3x^2+5x-7	by assuming AL=x and put the result in AX
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
		
----------------------------------------------------------------------------------------


		
		
		
		
		
		
		



