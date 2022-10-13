void login (unsigned int segl, unsigned int ofs)
{
 asm {
      push ax
      push cx
      push es
      push di
      push ds
      push si
      mov ah,16h
      int 44h
      mov cx,15
      mov ax,segl
      mov es,ax
      mov di,ofs
      rep movsb
      pop si
      pop ds
      pop di
      pop es
      pop cx
      pop ax
     }
}
