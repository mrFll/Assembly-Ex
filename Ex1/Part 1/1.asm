; 1) Convert lower case alphabets to upper case from memory location 0200 to 0300 
        
        mov BX,10
check:  mov AL,[200+BX]
        cmp AL,61
        jb next ; if below
        cmp AL,7A
        ja next ; if above
        sub AL,20
        mov [200+BX],AL
next:   dec BX
        jns check