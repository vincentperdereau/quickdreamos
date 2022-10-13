void putc (char c)
{
 asm {
        push    ax
        mov     al,c
        int     0x29
        pop     ax
     }
}

void puts (char* s)
{
 if (isecho)
 asm {
        push    ax
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     si,s
        mov     ah,0010h
        int     44h
        pop     ds
        pop     si
        pop     ax
     }
}
