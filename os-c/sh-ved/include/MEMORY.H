
/*
 * include/sys/i386/mm/memory.h
 *
 * created: 08/17/99
 * modifed: 08/17/99
 *
 */

 #define INCLUDE_SYS_I386_MM_MEMORY_H   1

void memcpy (uint segc,uint ofsc,uint segs,uint ofss,uint count)
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

void memset (uint segs,uint ofss,uint count,uchar b)
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


