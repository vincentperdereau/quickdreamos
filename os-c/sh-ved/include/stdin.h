char getch (void)
{
 asm {
        xor ax,ax
        int 0x16
     }
}

void gets (char* s,unsigned int c)
{
 asm {
        push ax
        push bx
        push cx
        push es
        mov ax,cs
        mov es,ax
        mov bx,s
        mov cx,c
        mov ah,0x0011
        int 0x44
        pop es
        pop cx
        pop bx
        pop ax
     }
}
