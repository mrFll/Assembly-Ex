;2) Write a procedure to convert the 10 digits String 
;   to a 32 bit binary number and call that procedure to 
;   convert the number to binary. Note that you need to 
;   use the 32 bits multiplication procedure you wrote in 
;   step 1. See the sample code for ASCII to binary conversion 
;   in the sample lecture codes and modify it with 32 bits 
;   multiplication
strLen EQU 10

.MODEL SMALL
.STACK 64
.DATA
    str DT "1138491823"     ; Input String
    res DB 5 DUP(0)         ; Store binary result
    DG DB 4 DUP(0)          ; Strote dahgan

    ; -------------- Mul pointers --------------
    Y0 DW 0,0

    Z0 DW 0
    Z1 DW 0

    RA DW 0
    RB DW 0
    RC DW 0
    RD DW 0

.CODE
    main PROC NEAR
                mov AX,@DATA
                mov DS,AX

                xor CX,CX
                mov BX,strLen           

        lbl:    
        
                mov byte ptr CX,[offset str+BX]  ; get the first lsb string
                AND CX,FH                        ; remove asccii code 30H from string
                mov Y0,CX                        ; move bcd to memory for mul
                mov dword ptr Z0, DG             ; load 10^x from DG to Z0 for Mul
                call multp                       ; Mul existed number with 10^x
                add res, dword ptr RC

                ; Here we should multiply DG with 10 to increase the value of DG (increase x at 10^x)

                
                mov AX,DG
                dec BX
                cmp BX,0
                jae lbl

                mov AX,4C00H
                int 21H
    main ENDP

    multp PROC NEAR
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

        ret
    mltp ENDP

END main