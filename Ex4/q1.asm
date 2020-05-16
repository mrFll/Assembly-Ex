;1) Write a program to prompt user to enter String1 and then String2, then read strings from user. 
;   Use CMPS instruction to compare these strings. Display proper messages to prompt user whether 
;   strings are equal or not equal. The program sample output is as below:
;   Please Enter String 1: Hooman
;   Please Enter String 2: Hooman1
;   Hooman in not equal to Hooman1

input_len EQU 20

.MODEL SMALL
.STACK 64
.DATA
    str1 label byte
		max_lenght1 db input_len
		actual_length1 db ?
		content1 db 21 dup(0)
    str2 label byte
		max_lenght2 db input_len
		actual_length2 db ?
		content2 db 21 dup(0)
    general_promt db "Please enter input:"
    input_number db "?: $"
    not_equal_message db "is not equal$"
    equal_message db "is equal$"
.CODE
    main PROC NEAR
            mov AX,@DATA
            mov DS,AX

            ; show promt for first input  
            mov input_number, '1'  ; Add string at the end of promt message
            mov AH,09H
            mov DX, offset general_promt
            int 21H

            ; read first input
            mov AH, 0AH
            mov DX, offset str1
            int 21H

            ; show prompt for second input
            mov input_number, '2'  ; Add string at the end of promt message
            mov AH,09H
            mov DX, offset general_promt
            int 21H

            ; read second input
            mov AH, 0AH
            mov DX, offset str2
            int 21H

            ; This code copied from http://vitaly_filatov.tripod.com/ng/asm/asm_000.16.html
            mov 
            cld                         ;Scan in the forward direction
            mov     cx, input_len-1       ;Scanning 100 bytes (CX is used by REPE)
            lea     si, content1        ;Starting address of first buffer
            lea     di, content2        ;Starting address of second buffer
    repe    cmps    content1,content2   ;...and compare it.
            jne     neq                 ;The Zero Flag will be cleared if there

            ; show message according to compare

            ; equal message
            mov AH,09H
            mov DX, offset equal_message
            int 21H
            jmp fin

    neq:    ; not equal
            mov AH,09H
            mov DX, offset not_equal_message
            int 21H


    fin:    mov AX,4C00H
            int 21H
    main ENDP

END main