; 4) Generalize the add to add to 80 bits numbers 
;    stored in memory location 200-207 and 210-217

strt EQU 6 ; adding length as a constant

STACKSEG SEGMENT PARA STACK 'stack'
	DW 32 DUP(?)
STACKSEG ENDS

DATASEG SEGMENT PARA 'data'
    frst DQ 1000   ; 8 byte
    scnd DQ 1200   ; 8 byte
DATASEG ENDS

CODESEG SEGMENT PARA 'code'
    main    PROC NEAR
		ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG
		mov AX, DATASEG
		mov DS, AX
		mov BX,strt
		clc             ;clear carry flag to be able to use adc for the first time
		pushf   ;push the flags for the first time to make the popf working
	lbl:    popf
		mov AX,[BX + offset frst] ;frst -> AX
		ADC     AX,[BX + offset scnd] ; AX + scnd
		mov [BX + offset frst],AX
		pushf   ; store the carry flag
		dec BX  ;instead of sub bx,2
		dec BX
		jns     lbl
		mov AX, 4C00H
		int 21H
    main ENDP
CODESEG ENDS

END main
