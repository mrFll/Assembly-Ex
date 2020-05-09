;1) By using the provided sample codes write generalized 
;   routines/procedures to calculate 32 bits multiplication 
;   and 64 bit division
;
; ----------------------------------------------------------
;       Y1 : Y0
;    *  Z1 : Z0
;   ______________
;    A : B : C : D
; ----------------------------------------------------------

.MODEL SMALL
.STACK 64
.DATA
        Y0 DW 11
        Y1 DW 0

        Z0 DW 0
        Z1 DW 11

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

        MOV AX , Z0
        MUL Y0      ; Z0 * Y0
        MOV RD , AX 
        MOV RC , DX

        MOV AX , Z0
        MUL Y1      ; Z0 * Y1 
        ADD RC , AX
        ADC RB , DX
        ADC RA , 0

        MOV AX , Z1
        MUL Y0      ; Z1 * Y0
        ADD RC , AX
        ADC RB , DX
        ADC RA , 0

        MOV AX , Z1
        MUL Y1      ; Z1 * Y1
        ADD RB , AX
        ADC RA , DX

        mov AX,4C00H
        int 21H

    main ENDP

END main
