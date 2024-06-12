	.386p
	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	V 300h
	?debug	S "memory.c"
	?debug	C E9E34B5357086D656D6F72792E63
VPSEG	segment byte public use16 
VPSEG	ends
MGRP	group	VPSEG
	assume	cs:MGRP,ds:MGRP
VPSEG	segment byte public use16 
d@	label	byte
d@w	label	word
b@	label	byte
b@w	label	word
   ;	
   ;	 unsigned int malloc (unsigned int paragraph)
   ;	
	assume	cs:MGRP
_malloc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		mov ah,0x0012
   ;	
	mov	 ah,00012H
   ;	
   ;		mov bx,paragraph
   ;	
	mov	 bx,[bp+4]
   ;	
   ;		int 0x44
   ;	
	int	 044H
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_malloc	endp
   ;	
   ;	 void free (unsigned int adr)
   ;	
	assume	cs:MGRP
_free	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	       push bx
   ;	
	push	 bx
   ;	
   ;	       mov ah,0x0013
   ;	
	mov	 ah,00013H
   ;	
   ;	       mov bx,adr
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	       int 0x44
   ;	
	int	 044H
   ;	
   ;	       pop bx
   ;	
	pop	 bx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_free	endp
   ;	
   ;	void memcpy (unsigned int segc,unsigned int ofsc,
   ;	
	assume	cs:MGRP
_memcpy	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	             unsigned int segs,unsigned int ofss,
   ;	             unsigned int count)
   ;	{
   ;	asm {
   ;		push si
   ;	
	push	 si
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		mov ax,segs
   ;	
	mov	 ax,[bp+8]
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov ax,segc
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov si,ofss
   ;	
	mov	 si,[bp+10]
   ;	
   ;		mov di,ofsc
   ;	
	mov	 di,[bp+6]
   ;	
   ;		mov cx,count
   ;	
	mov	 cx,[bp+12]
   ;	
   ;		rep movsb
   ;	
	rep movsb	
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;	};
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_memcpy	endp
	?debug	C E9
	?debug	C FA00000000
s@	label	byte
VPSEG	ends
	public	_memcpy
	public	_free
	public	_malloc
_s@	equ	s@
	end
