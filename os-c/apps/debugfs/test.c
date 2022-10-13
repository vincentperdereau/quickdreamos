#include <stdio.h>

void set_mode (int mode)
{
 asm {
      mov ax,mode
      int 0x10
     }
}

void putpixel (unsigned int adr,unsigned char color)
{
 asm {
	push es
        mov ax,0xa000
        mov es,ax
        mov bx,adr
        mov al,color
        mov es:[bx],al
	pop es
 }
}

void main (void)
{
 set_mode (0x13);
 putpixel (0,4);
 asm { xor ax,ax ; int 0x16 };
 set_mode (0x03);

}
