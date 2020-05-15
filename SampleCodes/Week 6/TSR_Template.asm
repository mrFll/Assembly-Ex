
; a template for TSR / Device Driver code in assembly

	.model small
	interrupt_number	equ	9 ; any int number that you want to handle
	
	.code
		org 100H
first:	jmp load_prog ; first time jump to initialaize the routine by changing the int address and allocate memory
		old_interrupt label word
		old_interrupt_address	dd	? ; location of the old interrupt
	
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
	
	
	load_prog proc near ; this procedure changes the interrupt vector and ask os for memory allocation
	
		mov AH,35H ; use OS service to get the interrupt vector entry for the given interrupt
		mov AL,interrupt_number ; see the equ at the beginning
		int 21H ; it returns the current address in ES:BX
		
		;instead of using int 21 OS services you can do it this was also ( direct access to interrupt vector)
		; xor AX,AX
		; push DS ; backup current DS
		; mov DS,AX ; go to interrupt vector segment
		; DS: ; the default segment in .code is CS . We need t ochange it
		; mov BX, interrupt_number*4 ; read offset from interrupt vector
		; DS:
		; mov ES,interrupt_number*4+2
		; pop DS ; restore DS
		
		mov old_interrupt,BX
		mov old_interrupt[2],ES
		
		mov AH,25H	; set the new interrupt vectore to this program by using OS service
		lea DX, prog
		int 21H
		
		;instead of using int 21 OS services you can do it this was also ( direct access to interrupt vector)
		; CLI ; disable interrupt flag to avoid occuring int in the middle of changing
		; xor AX,AX
		; push DS ; backup current DS
		; mov DS,AX ; go to interrupt vector segment
		; DS: ; the default segment in .code is CS . We need t ochange it
		; mov word ptr interrupt_number*4,offset load_prog  ; set  interrupt vector with our program offset
		; mov AX,CS; current code segment
		; DS:
		; mov word ptr interrupt_number*4+2, AX ; set  interrupt vector with our program segment
		; pop DS ; restore DS
		
	exit2: mov dx,offset load_prog ; memory allocation up to the beginning of program loader
		int 27H ; OS service for memory allocation
	
	load_prog endp
	
	end first