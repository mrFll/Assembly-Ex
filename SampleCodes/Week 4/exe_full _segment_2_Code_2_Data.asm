;Assume that given string A(100 characters) and B(20 characters) are stored in memory. Find the first occurrence 
;of string B in A and put its location in a variable in memory ( SUBSTRING) . If  String B can not be found in A, put -1 in that variable
; 1 stack segment 2 data segment 2 code segments
ALen    EQU     100 ;    String A length as constant
BLen    EQU     20      ; ;      String B length as constant

STACKSEG SEGMENT PARA STACK 'stack'
	DW 32 DUP(?)
STACKSEG ENDS

DATASEG1 SEGMENT PARA 'data'
	strA DB 100 DUP(?)      ;string A 
	found DW ? ; or WORD to store the index of found substring
DATASEG1 ENDS

DATASEG2 SEGMENT PARA 'data'
	strB DB 20 DUP(?)       ;string B
DATASEG2 ENDS

CODESEG1 SEGMENT PARA 'code'
	main PROC FAR        ; note that proc is defined as far
					ASSUME CS:CODESEG1,DS:DATASEG1,SS:STACKSEG
					; We don't following lines here but you may need them in your code. 
					; We don't need it here as we don't read from the segment just use the offset of strA and strB 
					; mov AX, DATASEG1 ; starts with the first data segment
					; mov DS, AX ; set DS with DATASEG1
					
					mov SI, offset strA ; also we can write lea SI,strA which is not good in term of instruction timing
		countinue:  push SI         ; we need SI to keep its value
					mov CX,BLen ; length of strings to be compared
					ASSUME DS:DATASEG2 ; set the segment to DATASEG2 to read the second variable
					; again we don't need it here as we don't read from memory but you may need it
					;mov AX, DATASEG2 ; starts with the second data segment
					;mov DS, AX ; set DS with DATASEG2
					mov DI,offset strB ; reset the second string for search
					call compare ; this proc compare two strings in DI and SI
					ASSUME cs:codeseg1 ; tell assembler to make addresses based on CODESEG1. It is not mandatory here but a good practise
					POP SI ; restore the index of first String to the index before comparision
					jc is_found; carry is set from compare proc
					inc SI
					ASSUME DS:DATASEG1
					; We need following 2 lines here as we are saving in memory (variable found)
					mov AX, DATASEG1 ; starts with the first data segment
					mov DS, AX ; set DS with DATASEG1
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
		next:       ASSUME DS:DATASEG1
					mov AX, DATASEG1 ; set DS to the first data segment to read strA
					mov DS, AX ; set DS with DATASEG1
					mov BL,[SI] ; one character from string A
					ASSUME DS:DATASEG2
					mov AX, DATASEG2 ; set DS to the second data segment to read strB
					mov DS, AX ; set DS with DATASEG1
					cmp BL,[DI]     ; one character from string B
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
