; part 3) By using the procedure in code 6 (checking if a number is prime) 
;			write a code to find all the prime numbers less than 
;			n ( n in bx) and store them in memory from 200 onward

check:	mov CX,BX
		shr CX,1 	; a number is prime if not divisible by numbers less than n/2
loop1:	mov AX,BX   ; put the number in DX:AX to be able to divide it by CX
		xor DX,DX	; Clear DX
		div CX		; check to see if BX is divisible by CX
		test DX,FF	; DX & FF
		jz end      ; jump to end if DX & FF result is zero (ZF=1)
        dec CX
		cmp CX,2	; end of the loop to see if number is prime
		jae	loop1   ; jump to loop1 if CX >= 2
		stc			; set the carry flag to send the return value to caller that BX is prime
		ret
end:	clc			; the number is not prime
		ret

; --> 11b
        mov BX,14   ; our number
        mov CX,0    ; set counter to 0
clp:    push CX     ; push counter to stack
        call check  ; call prime function 
        POP CX      ; get counter from stack
        jnc loop    ; if BX is not prime, jump to loop
        mov DX,BX   
        mov BX,CX
        mov [200+BX], DX    ; store number in memory
        mov BX,DX
        inc CX      ; increase counter
loop:   dec BX      ; decrease number
        cmp BX,2    
        jae clp     ; if number >= 2 jump to clp