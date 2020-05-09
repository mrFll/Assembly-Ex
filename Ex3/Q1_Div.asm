;1) By using the provided sample codes write generalized 
;   routines/procedures to calculate 64 bit division
;
; ----------------------------------------------------------
;    A : B : C : D  /  Z1 : Z0
; ----------------------------------------------------------

.MODEL SMALL
.STACK 64
.DATA
    RA DW 0     ; MSB, number is 40,000
    RB DW 0
    RC DW 0
    RD DW 9C40H

    Z1 DW 0     ; MSB number is 40
    Z0 DW 28H   

    COUNT DB 64 ; number of iterations
.CODE
    main PROC NEAR
		mov AX,@DATA
		mov DS,AX

		xor AX,AX       ; clear registers
		xor DX,DX

		mov BX,Z1
		mov CX,Z0
	SHIF:
		call SHLA       ; SHL DX:AX:RA:RB:RC:RD by 1 place
		cmp DX,BX
		jb NOYT
		ja HIT
		cmp AX,CX       
		jb NOYT
	HIT:    sub AX,CX
		sbb DX,BX
		ADD RD,1
	NOYT:   
		dec COUNT
		cmp COUNT,0
		jne SHIF
		
		mov AX,4C00H
		int 21H
    main ENDP
    SHLA PROC NEAR              ; Shifts 96 bits of DX:AX:RA:RB:RC:RD left by 1
		push BX
		push CX
		mov BX,0
		mov CX,0

		shl RD,1        ; shifting proc will start from 
		adc BX,0

		shl RC,1
		adc CX,0
		add RC,BX
		mov BX,0

		shl RB,1
		adc BX,0
		add RB,CX
		mov CX,0

		shl RA,1
		adc CX,0
		add RA,BX
		mov BX,0

		shl AX,1
		adc BX,0
		add AX,CX

		shl DX,1
		add DX,BX

		pop CX
		pop BX
		ret

    SHLA ENDP

END main
