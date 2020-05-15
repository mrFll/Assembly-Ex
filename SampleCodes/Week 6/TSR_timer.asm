; This program clears and changes the color of the screen every two seconds (Interval) by using int 8

	.model small
	interrupt_number	equ	8 ; time interrupt that will be called 18.2 times per second
	
	.code
		org 100H
first:	jmp load_prog ; first time jump to initialaize the routine by changing the int address and allocate memory
		old_interrupt label word
		old_interrupt_address	dd	? ; location of the old interrupt
		counter DW 0 ; counting to 36 = 2 seconds
		status DB 0; which color
	
	prog proc near
		push AX ; as int can happen any time we should push and pop anything that we use in the program
		push BX
		Push CX
		push DX
		push DI
		push SI
		push DS
		push ES ; only push registers that you are using in your prog
		pushf ; the int instrcution is different from call as it also keeps the flags in stack. We push flags to mimic this in our call
		call old_interrupt_address
		
	
		; program /device driver / TSR comes here
		inc word ptr counter
		cmp counter,36
		jb exit ; less than 2 seconds
		mov counter,0 ; reset the counter
		cmp status,0
		je color2
color1:
		mov status , 0 ; next time color2
		
		mov AX,0600H ; AH=06: scroll the screen AL=0: The whole screen
		mov BH,35H       ;background and forground color
		mov CX,0000H ; from ROW:COL 0:0
		mov DX,184FH ; to ROW:COL 18:4F HEX or 24:79
		int 10H
		jmp exit
		
color2:
		mov status , 1 ; next time color1
		
		mov AX,0600H ; AH=06: scroll the screen AL=0: The whole screen
		mov BH,47H       ;background and forground color
		mov CX,0000H ; from ROW:COL 0:0
		mov DX,184FH ; to ROW:COL 18:4F HEX or 24:79
		int 10H
		
	exit: pop ES
		  pop DS
		  pop SI
		  pop DI
		  pop DX
		  pop CX
		  pop BX
		  pop AX
		  iret ; we return by iret as the program is not an interrupt routine
	prog endp
	
	
	load_prog proc near ; this procedure changes the interrupot vector and ask os for memory allocation
	
		mov AH,35H ; use OS service to get the interrupt vector entry for the given interrupt
		mov AL,interrupt_number ; see the equ at the beginning
		int 21H ; it returns the current address in ES:BX
		
		mov old_interrupt,BX
		mov old_interrupt[2],ES
		
		mov AH,25H	; set the new interrupt vectore to this program by using OS service
		lea DX, prog
		int 21H
		
	exit2: mov dx,offset load_prog ; memory allocation up to the beginning of program loader
		int 27H ; OS service for memory allocation
	
	load_prog endp
	
	end first