;1) By using the provided sample codes write generalized 
;   routines/procedures to calculate 32 bits multiplication 
;   and 64 bit division



.MODEL SMALL
.STACK 64
.DATA
    num1 DD 100     ; 32 bit input
    num2 DD 20      ; 32 bit input
    carry DW ?      ; storeing carry
    res DQ 0        ; 64 bit result
.CODE
    main PROC NEAR
                mov bx,98       ; working with word
                mov si,98

        lbl:    mov ax,[num1+bx]
                mul word ptr[num2+si]
                
                add [res+bx+si+2],ax
                adc [res+bx+si],dx
                adc word ptr[res+bx+si-2],0
                dec si
                dec si
                jnz lbl
                mov si,98
                dec bx
                dec bx
                jnz lbl

                mov AX,4C00H
                int 21H
    main ENDP

END main



