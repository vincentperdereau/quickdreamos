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
	?debug	S "ser.c"
	?debug	C E94C547B27057365722E63
	?debug	C E9208A742706706F72742E68
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
   ;	void main ()
   ;	
	assume	cs:MGRP
_main	proc	near
   ;	
   ;	{
   ;	 init ();
   ;	
	call	near ptr MGRP:_init
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_main	endp
   ;	
   ;	void outb (int port, unsigned char b)
   ;	
	assume	cs:MGRP
_outb	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm { push dx ; push ax ; mov dx,port ;
   ;	
 	push	 dx 
 	push	 ax 
 	mov	 dx,[bp+4] 
   ;	
   ;	       mov al,b ;
   ;	
	mov	 al,[bp+6] 
   ;	
   ;	       out dx,al ; pop ax ; pop dx } ;
   ;	
	out	 dx,al 
 	pop	 ax 
 	pop	 dx 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_outb	endp
   ;	
   ;	unsigned char inb (int port)
   ;	
	assume	cs:MGRP
_inb	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm { push dx ; mov dx,port ; in al,dx ; pop dx }
   ;	
 	push	 dx 
 	mov	 dx,[bp+4] 
 	in	 al,dx 
 	pop	 dx 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_inb	endp
bytepos	label	word
	db	0
	db	0
activated	label	byte
	db	0
   ;	
   ;	interrupt serial_driver ()
   ;	
	assume	cs:MGRP
_serial_driver	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,cs:DGROUP@
	mov	ds,bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	{
   ;		unsigned int mbyte;
   ;	
   ;		asm { mov ax,cs ; mov ds,ax };
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	
   ;	if (activated)
   ;	
	cmp	byte ptr MGRP:activated,0
	jne short	@@0
	jmp	@4@898
@@0:
   ;	
   ;	 {
   ;		mbyte=inb(port_com1);
   ;	
	push	1016
	call	near ptr MGRP:_inb
	pop	cx
	mov	ah,0
	mov	word ptr [bp-2],ax
   ;	
   ;		// Synchronize
   ;		if((mbyte&64)==64) { bytepos=0; };
   ;	
	and	ax,64
	cmp	ax,64
	jne	short @4@170
	mov	word ptr MGRP:bytepos,0
@4@170:
   ;	
   ;	
   ;		mpacket[bytepos]=mbyte;
   ;	
	mov	bx,word ptr MGRP:bytepos
	mov	al,byte ptr [bp-2]
	mov	byte ptr MGRP:mpacket[bx],al
   ;	
   ;		bytepos++;
   ;	
	inc	word ptr MGRP:bytepos
   ;	
   ;	
   ;		// Process packet
   ;		if (bytepos==3) {
   ;	
	cmp	word ptr MGRP:bytepos,3
	je short	@@1
	jmp	@4@618
@@1:
   ;	
   ;			// Retrieve change in x and y from packet
   ;			int change_x=((mpacket[0] & 3) << 6) + mpacket[1];
   ;	
	mov	al,byte ptr MGRP:mpacket
	mov	ah,0
	and	ax,3
	shl	ax,6
	mov	dl,byte ptr MGRP:mpacket+1
	mov	dh,0
	add	ax,dx
	mov	si,ax
   ;	
   ;			int change_y=((mpacket[0] & 12) << 4) + mpacket[2];
   ;	
	mov	al,byte ptr MGRP:mpacket
	mov	ah,0
	and	ax,12
	shl	ax,4
	mov	dl,byte ptr MGRP:mpacket+2
	mov	dh,0
	add	ax,dx
	mov	di,ax
   ;	
   ;	
   ;			// Some mice need this
   ;			if(coordinate==1) {
   ;	
	cmp	word ptr MGRP:coordinate,1
	jne	short @4@254
   ;	
   ;			  change_x-=128;
   ;	
	sub	si,128
   ;	
   ;			  change_y-=128;
   ;	
	sub	di,128
@4@254:
   ;	
   ;			};
   ;	
   ;			// Change to signed
   ;			if(change_x>=128) { change_x=change_x-256; };
   ;	
	cmp	si,128
	jl	short @4@310
	add	si,-256
@4@310:
   ;	
   ;			if(change_y>=128) { change_y=change_y-256; };
   ;	
	cmp	di,128
	jl	short @4@366
	add	di,-256
@4@366:
   ;	
   ;	
   ;			// Adjust mouse position according to sensitivity
   ;			mouse_x+=change_x/horiz_sensitivity;
   ;	
	mov	ax,si
	cwd	
	idiv	word ptr MGRP:horiz_sensitivity
	add	word ptr MGRP:mouse_x,ax
   ;	
   ;			mouse_y+=change_y/vert_sensitivity;
   ;	
	mov	ax,di
	cwd	
	idiv	word ptr MGRP:vert_sensitivity
	add	word ptr MGRP:mouse_y,ax
   ;	
   ;	
   ;			// Check that mouse is still in screen
   ;			if(mouse_x<0) { mouse_x=0; };
   ;	
	cmp	word ptr MGRP:mouse_x,0
	jge	short @4@422
	mov	word ptr MGRP:mouse_x,0
@4@422:
   ;	
   ;			if(mouse_x>max_screen_x) { mouse_x=max_screen_x; };
   ;	
	mov	ax,word ptr MGRP:mouse_x
	cmp	ax,word ptr MGRP:_max_screen_x
	jle	short @4@478
	mov	ax,word ptr MGRP:_max_screen_x
	mov	word ptr MGRP:mouse_x,ax
@4@478:
   ;	
   ;			if(mouse_y<0) { mouse_y=0; };
   ;	
	cmp	word ptr MGRP:mouse_y,0
	jge	short @4@534
	mov	word ptr MGRP:mouse_y,0
@4@534:
   ;	
   ;			if(mouse_y>max_screen_y) { mouse_y=max_screen_y; };
   ;	
	mov	ax,word ptr MGRP:mouse_y
	cmp	ax,word ptr MGRP:_max_screen_y
	jle	short @4@590
	mov	ax,word ptr MGRP:_max_screen_y
	mov	word ptr MGRP:mouse_y,ax
@4@590:
   ;	
   ;	
   ;			// Retrieve mouse button status from packet
   ;			mouse_button1=mpacket[0] & 32;
   ;	
	mov	al,byte ptr MGRP:mpacket
	and	al,32
	mov	byte ptr MGRP:mouse_button1,al
   ;	
   ;			mouse_button2=mpacket[0] & 16;
   ;	
	mov	al,byte ptr MGRP:mpacket
	and	al,16
	mov	byte ptr MGRP:mouse_button2,al
   ;	
   ;	
   ;			bytepos=0;
   ;	
	mov	word ptr MGRP:bytepos,0
@4@618:
   ;	
   ;		};
   ;	
   ;	 asm {
   ;		mov ax,word ptr MGRP:_mouse_button2
   ;	
	mov	 ax,word ptr MGRP:_mouse_button2
   ;	
   ;		shl ax,1
   ;	
	shl	 ax,1
   ;	
   ;		add ax,word ptr MGRP:_mouse_button1
   ;	
	add	 ax,word ptr MGRP:_mouse_button1
   ;	
   ;		mov cx,word ptr MGRP:_mouse_x
   ;	
	mov	 cx,word ptr MGRP:_mouse_x
   ;	
   ;		mov dx,word ptr MGRP:_mouse_y
   ;	
	mov	 dx,word ptr MGRP:_mouse_y
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		mov al,0x20
   ;	
	mov	 al,020H
   ;	
   ;		out 0x20,al
   ;	
	out	 020H,al
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;		int 0x34
   ;	
	int	 034H
@4@898:
   ;	
   ;	     }
   ;	
   ;	 //outb (0x20,0x20);
   ;	 }
   ;	
   ;	};
   ;	
	leave	
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
_serial_driver	endp
   ;	
   ;	interrupt driver_interface ()
   ;	
	assume	cs:MGRP
_driver_interface	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,cs:DGROUP@
	mov	ds,bp
   ;	
   ;	{
   ;	
   ;	  asm { mov dx,cs ; mov ds,dx };
   ;	
 	mov	 dx,cs 
 	mov	 ds,dx 
   ;	
   ;	  rax = _AX;
   ;	
	mov	word ptr MGRP:rax,ax
   ;	
   ;	  rbx = _BX;
   ;	
	mov	word ptr MGRP:rbx,bx
   ;	
   ;	  rcx = _CX;
   ;	
	mov	word ptr MGRP:rcx,cx
   ;	
   ;	  switch (rax)
   ;	
	mov	ax,word ptr MGRP:rax
	cmp	ax,1
	je	short @5@254
	cmp	ax,2
	je	short @5@282
	cmp	ax,3
	je	short @5@310
	jmp	short @5@366
@5@254:
   ;	
   ;	  {
   ;	   case 0x0001: max_screen_x = rbx;
   ;	
	mov	ax,word ptr MGRP:rbx
	mov	word ptr MGRP:_max_screen_x,ax
   ;	
   ;			max_screen_y = rcx;
   ;	
	mov	ax,word ptr MGRP:rcx
	mov	word ptr MGRP:_max_screen_y,ax
   ;	
   ;			mouse_x = ((max_screen_x-1) >> 1) + 1;
   ;	
	mov	ax,word ptr MGRP:_max_screen_x
	dec	ax
	sar	ax,1
	inc	ax
	mov	word ptr MGRP:mouse_x,ax
   ;	
   ;			mouse_y = ((max_screen_y-1) >> 1) + 1;
   ;	
	mov	ax,word ptr MGRP:_max_screen_y
	dec	ax
	sar	ax,1
	inc	ax
	mov	word ptr MGRP:mouse_y,ax
   ;	
   ;			break;
   ;	
	jmp	short @5@366
@5@282:
   ;	
   ;	   case 0x0002: activated = 1;
   ;	
	mov	byte ptr MGRP:activated,1
	jmp	short @5@338
@5@310:
   ;	
   ;			outb (port_pic_master, inb (port_pic_master) ^ IRQ_mask);
   ;			break;
   ;	   case 0x0003: activated = 0;
   ;	
	mov	byte ptr MGRP:activated,0
@5@338:
   ;	
   ;			outb (port_pic_master, inb (port_pic_master) ^ IRQ_mask);
   ;	
	push	33
	call	near ptr MGRP:_inb
	pop	cx
	xor	al,16
	push	ax
	push	33
	call	near ptr MGRP:_outb
	add	sp,4
@5@366:
   ;	
   ;	   default: 	break;
   ;	  }
   ;	}
   ;	
	pop	bp
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
_driver_interface	endp
   ;	
   ;	void set_vector (void* handle, int intr)
   ;	
	assume	cs:MGRP
_set_vector	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		cli
   ;	
	cli	
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov bx,intr
   ;	
	mov	 bx,[bp+6]
   ;	
   ;		shl bx,2
   ;	
	shl	 bx,2
   ;	
   ;		mov ax,handle
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		mov es:[bx],ax
   ;	
	mov	 es:[bx],ax
   ;	
   ;		mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;		mov es:[bx+2],ax
   ;	
	mov	 es:[bx+2],ax
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;		sti
   ;	
	sti	
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_set_vector	endp
   ;	
   ;	void init_mouse (void)
   ;	
	assume	cs:MGRP
_init_mouse	proc	near
   ;	
   ;	{
   ;	 outb (port_com1 + 3,0x0080);
   ;	
	push	128
	push	1019
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 0,0x0060);
   ;	
	push	96
	push	1016
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 1,0x0000);
   ;	
	push	0
	push	1017
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 3,0x0002);
   ;	
	push	2
	push	1019
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 1,0x0000);
   ;	
	push	0
	push	1017
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 4,0x0001);
   ;	
	push	1
	push	1020
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 inb  (port_com1 + 5);
   ;	
	push	1021
	call	near ptr MGRP:_inb
	pop	cx
   ;	
   ;	 outb (port_com1 + 1,0x0001);
   ;	
	push	1
	push	1017
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	 outb (port_com1 + 4,0x000b);
   ;	
	push	11
	push	1020
	call	near ptr MGRP:_outb
	add	sp,4
   ;	
   ;	}
   ;	
	ret	
_init_mouse	endp
   ;	
   ;	void init ()
   ;	
	assume	cs:MGRP
_init	proc	near
   ;	
   ;	{
   ;	 init_mouse ();
   ;	
	call	near ptr MGRP:_init_mouse
   ;	
   ;	 horiz_sensitivity = 2;
   ;	
	mov	word ptr MGRP:horiz_sensitivity,2
   ;	
   ;	 vert_sensitivity = 3;
   ;	
	mov	word ptr MGRP:vert_sensitivity,3
   ;	
   ;	 set_vector (serial_driver,intIRQ);
   ;	
	push	12
	push	offset MGRP:_serial_driver
	call	near ptr MGRP:_set_vector
	add	sp,4
   ;	
   ;	 set_vector (driver_interface,0x33);
   ;	
	push	51
	push	offset MGRP:_driver_interface
	call	near ptr MGRP:_set_vector
	add	sp,4
   ;	
   ;	 max_screen_x = 639;
   ;	
	mov	word ptr MGRP:_max_screen_x,639
   ;	
   ;	 max_screen_y = 479;
   ;	
	mov	word ptr MGRP:_max_screen_y,479
   ;	
   ;	 mouse_x = (max_screen_x / 2) + 1;
   ;	
	mov	ax,word ptr MGRP:_max_screen_x
	cwd	
	sub	ax,dx
	sar	ax,1
	inc	ax
	mov	word ptr MGRP:mouse_x,ax
   ;	
   ;	 mouse_y = (max_screen_y / 2) + 1;
   ;	
	mov	ax,word ptr MGRP:_max_screen_y
	cwd	
	sub	ax,dx
	sar	ax,1
	inc	ax
	mov	word ptr MGRP:mouse_y,ax
   ;	
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		mov ah,0x12
   ;	
	mov	 ah,012H
   ;	
   ;		mov bx,50
   ;	
	mov	 bx,50
   ;	
   ;		int 0x44
   ;	
	int	 044H
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_init	endp
rdx	label	word
	db	2 dup (0)
rcx	label	word
	db	2 dup (0)
rbx	label	word
	db	2 dup (0)
rax	label	word
	db	2 dup (0)
vert_sensitivity	label	word
	db	2 dup (0)
horiz_sensitivity	label	word
	db	2 dup (0)
mouse_button2	label	byte
	db	1 dup (0)
mouse_button1	label	byte
	db	1 dup (0)
mouse_y	label	word
	db	2 dup (0)
mouse_x	label	word
	db	2 dup (0)
mpacket	label	byte
	db	3 dup (0)
coordinate	label	word
	db	2 dup (0)
_max_screen_y	label	word
	db	2 dup (0)
_max_screen_x	label	word
	db	2 dup (0)
	?debug	C E9
	?debug	C FA10000000
s@	label	byte
	extrn	DGROUP@:word
VPSEG	ends
	public	_init_mouse
	public	_set_vector
	public	_driver_interface
	public	_serial_driver
_rdx	equ	rdx
_rcx	equ	rcx
_rbx	equ	rbx
_rax	equ	rax
_activated	equ	activated
_vert_sensitivity	equ	vert_sensitivity
_horiz_sensitivity	equ	horiz_sensitivity
_mouse_button2	equ	mouse_button2
_mouse_button1	equ	mouse_button1
_mouse_y	equ	mouse_y
_mouse_x	equ	mouse_x
_mpacket	equ	mpacket
_coordinate	equ	coordinate
_bytepos	equ	bytepos
	public	_max_screen_y
	public	_max_screen_x
	public	_inb
	public	_outb
	public	_main
	public	_init
_s@	equ	s@
	end
