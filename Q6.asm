
.MODEL SMALL
.CODE
	ORG 100H
begin: jmp main
	numb DW 1001101101101011b
	main PROC NEAR
				mov AX, numb
				mov BX, 0
				mov CX, 1
				clc
		lbl:	ROL AX, 1
				ADC BX, 0
				INC CX
				cmp CX, 16
				JBE lbl
				mov AX, 4C00H
				int 21H
	main ENDP

END begin
