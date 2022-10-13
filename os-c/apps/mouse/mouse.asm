
 .model tiny
 .386


 .code


       ; mov ah,00
       ; mov al,10010010b
       ; mov dx,0
       ; int 14h

        mov dx,3f8h + 3
        mov al,080h
        out dx,al
        mov dx,3f8h + 0
        mov al,060h
        out dx,al
        mov dx,3f8h + 1 
        mov al,0
        out dx,al
        mov dx,3f8h + 3
        mov al,2
        out dx,al
        mov dx,3f8h + 1
        mov al,0
        out dx,al
        mov dx,3f8h + 4
        mov al,1
        out dx,al
        mov dx,3f8h + 5
        in al,dx
        mov dx,3f8h + 1
        mov al,1
        out dx,al
        mov dx,3f8h + 4
        mov al,0bh
        out dx,al

        mov dx,0021h
        in al,dx
        xor al,00010000b
        out dx,al

        cli
        mov ax,0
        mov es,ax
        mov bx,0Ch*4
        mov word ptr es:[bx],offset intC
        mov ax,cs
        mov es:[bx+2],ax
        sti
        int 0ch

 @looping:

        mov dx,03f8h
        in al,dx
        mov ah,0eh
        ;int 10h
        in al,60h
        cmp al,1
        jne @looping

        retf

 intC:

        push ax
        mov al,"m"
        int 29h
        mov al,20h
        out 20h,al
        pop ax

        iret



 end
