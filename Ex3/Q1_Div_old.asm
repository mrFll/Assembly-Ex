;1) By using the provided sample codes write generalized 
;   routines/procedures to calculate 64 bit division
;
; ----------------------------------------------------------
;   ______________ _________________     ___________
;  |      r       |       s/m       |   |     d     |
; ----------------------------------------------------------

.MODEL SMALL
.STACK 64
.DATA
    R1 DB 3 DUP(0)  ; 16bit + 8bit r
    S1 DQ 50        ; 32bit s
    D1 DW 10        ; 16bit d
.CODE
    main PROC NEAR
                mov cx,32   ; store number of s bits for iteration
        slbl:   
        
                mov AX,4C00H
                int 21H
    main ENDP

END main