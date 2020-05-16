;3) Modify the keyboard1.asm to print the content of the keyboard buffer from location 1 to location 16. 
;   Then change the head to the beginning of the buffer and the tail to the end of the buffer. 
;   Run your code and explain the output.
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
            mov DS,bx

        get_char:
            mov bx, head
        next: 
            mov DL,[BX]     ; we don't care for scan code	
            mov AH,02H      ; the OS service to dispaly one char in DL
            int 21H         ; print the char in the buffer

            inc BX
            inc BX

            cmp BX,Tail     ; scan the buffer till tail
            je exit         ; jump if equal

            cmp BX, offset buffer_end ; circular buffer
            jbe next        ; jump if below or equal

            mov BX,offset buffer
            jmp next	    

        exit:
            int 20h
    Reader endp
end Reader