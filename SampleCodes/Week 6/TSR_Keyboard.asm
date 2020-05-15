; this TSR is using int 9 to check for alt_s pressing by the user to do the task 	
	; uses alt^s to toggle between screens (Graphics <-->Monochrome)
	.model small
	interrupt_number	equ	9 ; keyboard interrupt

ROM_BIOS_DATA segment at 40H ; BIOS keyboard status held here and then the keyboard buffer
	org 1AH
	head dw ?
	tail dw ?
	buffer dw 16 dup(?)
	buffer_end label word
ROM_BIOS_DATA ends ; this segment is just for addressing and not reserving the space as it is a com file
	.code
		org 100H
first:	jmp load_prog ; first time jump to initialaize the routine by changing the int address and allocate memory
		old_key_interrupt label word
		old_keyboard_interrupt_address	dd	? ; location of the old interrupt
	
	prog proc near   ; the keyboard interrupt will now come here
		push AX ; as int can happen any time we should push and pop anything that we use in the program
		push BX
		Push CX
		push DX
		push DI
		push SI
		push DS
		push ES ; only push registers that you are using in your prog
		pushf ; the int instrcution is different from call as it also keeps the flags in stack. We push flags to mimic this in our call
		call old_keyboard_interrupt_address
		
		assume DS:ROM_BIOS_DATA
		mov BX,ROM_BIOS_DATA ; also can write mov BX,40H
		mov DS,BX
		
		mov BX,tail ; also can write mov BX,[1CH] points to the current tail
		cmp BX,head ; also can write cmp BX,[1AH] compare it with the current head if equal there is no character in the buffer maybe only a control key is pressed
		je exit
		sub BX,2	; last character in the buffer which is just pressed and read by int 9H
		cmp BX,offset buffer ; did we undershoot the buffer?
		jae no_wrap ; no and we didn't need to circulate
		mov bx,offset buffer_end ; we should circulate the buffer and get the one from end of the buffer
		sub bx,2
	no_wrap: mov dx,[bx] ; char is in DX now both scan and ASCII code
		cmp DX,1F00H ; The scan code of alt^s is 1F and the ASCII code is 00
		jne exit ; not alt^s so IRET
		mov tail,BX ; yes it is alt^s so remove it from the buffer
		
		; now change/toggle the current mode
		mov BX,10H ; 40:10 is the status of the current graphic mode
		mov ax,[BX]; read the current status
		mov CX,AX ; put a copy in CX
		and AX,00010000B
		cmp AX,0
		je to_monochrome ; yes
	to_graphics: 
		and CX,11101111B ;setup the equipment byte
		mov [BX],CX ;reinstall the graphic status byte
		mov AX,0002 ; set up a CGA screen mode
		int 10H ; call BIOS low level graphic service to change the screen graphic mode
		jmp exit
	to_monochrome:
		or cx,00010000B ; set up the status byte
		mov [BX],CX ; reinstall it
		mov AX,0007 ; setup monochrome video mode
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
		
		mov old_key_interrupt,BX
		mov old_key_interrupt[2],ES
		
		mov AH,25H	; set the new interrupt vectore to this program by using OS service
		lea DX, prog
		int 21H
		
	exit2: mov dx,offset load_prog ; memory allocation up to the beginning of program loader
		int 27h ; OS service for memory allocation
	
	load_prog endp
	
	end first