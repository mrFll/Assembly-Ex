;3) Calculate x^2 by using your 32 bit multiplication and 
;   store your number in a 64 bit binary number

.MODEL SMALL
.STACK 64
.DATA
    N0 DW 4
    N1 DW 0

    RA DW 0
    RB DW 0
    RC DW 0
    RD DW 0

.CODE
    main PROC NEAR
                mov AX,@DATA
                mov DS,AX

                MOV RB , 0
                MOV RA , 0

                MOV AX , N0
                MUL N0      
                MOV RD , AX 
                MOV RC , DX

                MOV AX , N0
                MUL N1       
                ADD RC , AX
                ADC RB , DX
                ADC RA , 0

                MOV AX , N1
                MUL N0      
                ADD RC , AX
                ADC RB , DX
                ADC RA , 0

                MOV AX , N1
                MUL N1      
                ADD RB , AX
                ADC RA , DX

                mov AX,4C00H
                int 21H
    main ENDP

END main