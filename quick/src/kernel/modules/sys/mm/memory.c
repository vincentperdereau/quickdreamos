/*
 * quick/src/kernel/modules/sys/mm/memory.h
 *
 * utilisation de la m‚moire conventionnelle
 * ne repr‚sente pas la *GESTION* de la m‚moire par notre OS
 */

#include <typedef.h>

PROC memcpy (UINT segc,UINT ofsc,UINT segs,UINT ofss,UINT count)
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

PROC memset (UINT segs,UINT ofss,UINT count,UCHAR b)
{
asm {
	push ax
	push es
	push cx
	push di
	mov ax,segs
	mov es,ax
	mov di,ofss
	mov cx,count
	mov al,b
	rep stosb
	pop di
	pop cx
	pop es
	pop ax
};
}


