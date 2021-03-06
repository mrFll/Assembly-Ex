;Assume that given string A(100 characters) and B(20 characters) are stored in memory. Find the first occurrence 
;of string B in A and put its location in a variable in memory ( SUBSTRING) . If  String B can not be found in A, put -1 in that variable
; 1 stack segment 1 data segment 2 code segments
ALen    EQU     100 ;    String A length as constant
BLen    EQU     20      ; ;      String B length as constant

STACKSEG SEGMENT PARA STACK 'stack'
	DW 32 DUP(?)
STACKSEG ENDS

DATASEG SEGMENT PARA 'data'
	strA DB 100 DUP(?)      ;string A 
	strB DB 20 DUP(?)       ;string B
	found WORD ? ; or DB tos tore the index of found substring
DATASEG ENDS

CODESEG1 SEGMENT PARA 'code'
	main PROC FAR        ; note that proc is defined as far
					ASSUME CS:CODESEG1, DS:DATASEG, SS:STACKSEG
					mov AX, DATASEG 
					mov DS, AX ; set DS with DATASEG					
					mov SI, offset strA ; also we can write lea SI,strA which is not good in term of instruction timing
		countinue:  push SI         ; we need SI to keep its value
					mov CX,BLen ; length of strings to be compared
					mov DI,offset strB ; reset the second string for search
					call compare ; this proc compare two strings in DI and SI
					ASSUME CS:CODESEG1 ; tell assembler to make addresses based on CODESEG1. It is not mandatory here but a good practise
					POP SI ; restore the index of first String to the index before comparision
					jc is_found ; carry from compare proc
					inc SI
					cmp SI, offset strA+ALen-Blen ; is it end of the string A - string B ( the last lcoation for search)
					jbe countinue
					mov found, -1 ; not found
					jmp finish
		is_found:   sub SI,offset strA ;    the index of found substring
					mov found,SI            
		finish:     mov AX, 4C00H
					int 21H
	main ENDP
	
CODESEG1 ENDS

; second code segmnent
CODESEG2 SEGMENT PARA 'code'    
	compare PROC FAR
					ASSUME CS:CODESEG2;     tell assembler to generate addresses based on CODESEG2. It is mandatory here
		next:       mov AL,[SI] ; one character from string A
					cmp AL,[DI]     ; one character from string B
					jne not_equal
					inc SI ; next character
					inc DI
					loop next ; CX has the lenght and the counter for comparision
					stc     ; Strings are equal
					ret
		not_equal:  clc ; strings are not equal
					ret
	compare ENDP
	
CODESEG2 ENDS

END main
