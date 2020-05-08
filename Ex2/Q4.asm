;	8) Find all the prime numbers less than n ( and n in BX) and store them in memory from [200] onward
	; Use the check from 6
	
		mov bx,200
		mov SI,200 ; Also xor SI,SI
loop1:	call check
		jnc next
		mov [SI],BX ; if starts with SI=0 then mov [200+SI],BX which is slower as ins lenght is more
		inc SI
		inc SI
next:	dec BX
		cmp BX,1
		ja	loop1