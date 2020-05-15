; read all characters in the buffer from last character to the recent one head to tail
.model small
ROM_BIOS_DATA segment at 40H
	org 1AH
	Head dw ?
	Tail dw ?
	buffer dw 16 dup (?)
	buffer_end  label word
ROM_BIOS_DATA ends

	.code
	org 100h
Reader proc near
	assume ds:ROM_BIOS_DATA
	mov bx,ROM_BIOS_DATA ; also can write mov BX,40H
	mov ds,bx
get_char:
	mov bx, head
next: 
	mov DL,[BX]; we don't care for scan code	
	mov AH,02H ; the OS service to dispaly one char in DL
	int 21H ; print the char in the buffer
	inc BX
	inc BX
	cmp BX,Tail ; scan the buffer till tail
	je exit
	cmp BX, offset buffer_end ; circular buffer
	jbe next
	mov BX,offset buffer
	jmp next	
exit:
	int 20h
Reader endp
	end Reader