.model tiny
.386

.code

        mov ax,cs
        mov es,ax

        mov bx,offset intr
        mov ax,00001
        int 33h

        xor ax,ax
        int 16h

        mov ax,2
        int 33h

        retf


        

intr:
        sti
        push ax
        push es
        mov ax,0b800h
        mov es,ax
        mov byte ptr es:[0],"P"
        pop es
        pop ax
        retf



end
