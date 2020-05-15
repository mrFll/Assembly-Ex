; access keyboard buffer directly. hardware level programming. Reads characters from keyboard buffer
; and dispaly them using int 10H ( BIOS service to display)
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
	mov bx, Head ;bx points to current head also can write mov bx,[1AH]
	cmp bx,Tail
	je	get_char ; equal to tail means no character in the buffer
	mov dx,[bx]; if head and tail are not equal there is a character in the buffer so read it
	mov tail,bx; empty the buffer by replacing the tail with head
	;  char in DX now
	cmp dl,"Q" ; if it is Q then exit the loop
	je Bye
	cmp dl,"q"
	je Bye
	mov ah,2
	int 21H
	jmp get_char
Bye:
	int 20h
Reader endp
	end Reader