; get a tring from user and print it in the middle of screen
.MODEL SMALL
.CODE
	ORG 100H
begin:  jmp main
	str1 label byte
		max_lenght      db 20
		actual_length   db ? ; you can write it in java convention actualLenght but it is better to keep c convention here
		content db 21 dup(?) ; one more character to be able to insert "$" to print it
	prompt db " please enter your name: ",0AH,0DH,"$" ; or '$'
	prompt2 db 'Welcome to our system $' ; you can use " or ' . Also you can put $ inside ot outside the string
	
main  PROC NEAR

	call clear_screen
	
	;print the prompt to get the name
	mov AH,09H ; print string OS service in DOS
	mov DX,offset prompt ; DX point to the string ending by $
	int 21H ; call the software interrupt which is the OS low level service in DOS
	
	;get the name from the user
	mov AH,0AH ; call get input string service from OS services
	mov DX,offset str1; or lea dx,str1
	int 21H
	
	call clear_screen
	
	; move the cursor to the middle of the screen
	mov AH,02H ; change the curser position BIOS service
	mov BH, 00 ; active page which can be different from visual page
	mov DH,13 ; row 13 out of 25
	mov DL, 30 ; column 30 out 0f 80
	int 10H ; low level BIOS Service
	
	; displaying the welcome prompt
	mov AH,09H
	mov DX,offset prompt2;
	int 21H
	
	; adding $ at the end of str1 to be able to print it
	mov BL,actual_length
	xor BH,BH
	mov content[BX],'$'; also you can write [content+BX]also "$"
	
	;dispalying the name
	mov AH,09H
	mov DX,offset content ; the string content from user
	int 21H
	

beep: mov DL,07 ; the ASCII code for beep
	mov AH,02H ; the OS service to dispaly one char in DL
	int 21H
	mov AH,00 ; read one character without waiting and no echo
	int 16H;  BIOS low level service : keyboard services
	cmp AL,00 ; the pressed key ASCII code goes to AL and Scan code goes to AH
	jz beep ; beep till user enters any character
	
	int 20H ; end the program in .com

main ENDP

clear_screen proc near
	mov AX,0600H ; AH=06: scroll the screen AL=0: The whole screen
	mov BH,30H       ;background and forground color
	mov CX,0000H ; from ROW:COL 0:0
	mov DX,184FH ; to ROW:COL 18:4F HEX or 24:79
	int 10H ; BIOS low level service : screen scroll
	ret
clear_screen endp

	END begin
