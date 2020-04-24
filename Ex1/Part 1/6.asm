; 6) Check to see if the number in BX is prime or not. 
; Set the carry flag if it is a prime number
; clear it if it is not a prime number

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