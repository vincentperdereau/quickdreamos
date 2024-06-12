 unsigned int malloc (unsigned int paragraph)
 {
  asm {
	push bx
	mov ah,0x0012
	mov bx,paragraph
	int 0x44
	pop bx
      }
 }

 void free (unsigned int adr)
 {
  asm {
       push bx
       mov ah,0x0013
       mov bx,adr
       int 0x44
       pop bx
      }
 }

void memcpy (unsigned int segc,unsigned int ofsc,
             unsigned int segs,unsigned int ofss,
             unsigned int count)
{
asm {
	push si
	push di
	push es
	push ds
	push cx
	push ax
	mov ax,segs
	mov ds,ax
	mov ax,segc
	mov es,ax
	mov si,ofss
	mov di,ofsc
	mov cx,count
	rep movsb
	pop ax
	pop cx
	pop ds
	pop es
	pop di
	pop si
};
}
