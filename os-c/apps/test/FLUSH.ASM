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
	?debug	S "flush.c"
	?debug	C E9D288032907666C7573682E63
	?debug	C E929739C27092E5C737464696F2E68
	?debug	C E917A2D528092E5C68696D656D2E68
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
DGROUP	group	_DATA,VP
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public use16 'VP'
d@	label	byte
d@w	label	word
_DATA	ends
VP	segment word public use16 'BSS'
b@	label	byte
b@w	label	word
VP	ends
_TEXT	segment byte public use16 'CODE'
   ;	
   ;	void himem_write (unsigned int segs,unsigned int ofss,
   ;	
	assume	cs:_TEXT
_himem_write	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;			 unsigned long c,unsigned long count)
   ;	{
   ;	asm {
   ;		push si
   ;	
	push	 si
   ;	
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push ecx
   ;	
	push	 ecx
   ;	
   ;		push ebx
   ;	
	push	 ebx
   ;	
   ;		mov ax,segs
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,ofss
   ;	
	mov	 si,[bp+6]
   ;	
   ;		mov ebx,c
   ;	
	mov	 ebx,[bp+8]
   ;	
   ;		mov ecx,count
   ;	
	mov	 ecx,[bp+12]
   ;	
   ;		himem_loop:
   ;	
	himem_loop	:
   ;	
   ;		mov al,ds:[si]
   ;	
	mov	 al,ds:[si]
   ;	
   ;		mov fs:[ebx],al
   ;	
	mov	 fs:[ebx],al
   ;	
   ;		inc si
   ;	
	inc	 si
   ;	
   ;		inc ebx
   ;	
	inc	 ebx
   ;	
   ;		loopd himem_loop
   ;	
	loopd	 himem_loop
   ;	
   ;		pop ebx
   ;	
	pop	 ebx
   ;	
   ;		pop ecx
   ;	
	pop	 ecx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;	};
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_himem_write	endp
   ;	
   ;	void himem_read (unsigned long c,unsigned int segc,
   ;	
	assume	cs:_TEXT
_himem_read	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;			 unsigned int ofsc,unsigned long count)
   ;	{
   ;	asm {
   ;		push si
   ;	
	push	 si
   ;	
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push ecx
   ;	
	push	 ecx
   ;	
   ;		push ebx
   ;	
	push	 ebx
   ;	
   ;		mov ax,segc
   ;	
	mov	 ax,[bp+8]
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,ofsc
   ;	
	mov	 si,[bp+10]
   ;	
   ;		mov ebx,c
   ;	
	mov	 ebx,[bp+4]
   ;	
   ;		mov ecx,count
   ;	
	mov	 ecx,[bp+12]
   ;	
   ;		himem_loop2:
   ;	
	himem_loop2	:
   ;	
   ;		mov al,fs:[ebx]
   ;	
	mov	 al,fs:[ebx]
   ;	
   ;		mov ds:[si],al
   ;	
	mov	 ds:[si],al
   ;	
   ;		inc si
   ;	
	inc	 si
   ;	
   ;		inc ebx
   ;	
	inc	 ebx
   ;	
   ;		loopd himem_loop2
   ;	
	loopd	 himem_loop2
   ;	
   ;		pop ebx
   ;	
	pop	 ebx
   ;	
   ;		pop ecx
   ;	
	pop	 ecx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;	};
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_himem_read	endp
   ;	
   ;	unsigned int get_size_himem (void)
   ;	
	assume	cs:_TEXT
_get_size_himem	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		push dx
   ;	
	push	 dx
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		mov dx,70h
   ;	
	mov	 dx,70h
   ;	
   ;		mov al,17h
   ;	
	mov	 al,17h
   ;	
   ;		out dx,al
   ;	
	out	 dx,al
   ;	
   ;		mov dx,71h
   ;	
	mov	 dx,71h
   ;	
   ;		in al,dx
   ;	
	in	 al,dx
   ;	
   ;		mov bl,al
   ;	
	mov	 bl,al
   ;	
   ;		mov dx,70h
   ;	
	mov	 dx,70h
   ;	
   ;		mov al,18h
   ;	
	mov	 al,18h
   ;	
   ;		out dx,al
   ;	
	out	 dx,al
   ;	
   ;		mov dx,71h
   ;	
	mov	 dx,71h
   ;	
   ;		in al,dx
   ;	
	in	 al,dx
   ;	
   ;		mov bh,al
   ;	
	mov	 bh,al
   ;	
   ;		mov ax,bx
   ;	
	mov	 ax,bx
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop dx
   ;	
	pop	 dx
   ;	
   ;	     };
   ;	}
   ;	
	ret	
_get_size_himem	endp
   ;	
   ;	BOOL disk_access (UCHAR d,               // lecteur
   ;	
	assume	cs:_TEXT
_disk_access	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
	mov	si,word ptr [bp+12]
	mov	di,word ptr [bp+14]
   ;	
   ;	                   int h,                 // tˆte
   ;	                   int c,                 // cylindre
   ;	                   int s,                 // secteur
   ;	                   int count,             // nombre de secteur(s) … ‚crire
   ;	                   void* ofs,             // 'offset' du buffer
   ;	                   UINT segm,             // 'segm' du buffer
   ;	                   int op)                // op‚ration … effecteur 
   ;	 {
   ;	
   ;	  ULONG adr;
   ;	
   ;	  adr = ( h * 80 * 18 ) + ( c * 18 ) + s;
   ;	
	mov	ax,word ptr [bp+6]
	mov	dx,1440
	imul	dx
	push	ax
	mov	ax,word ptr [bp+8]
	mov	dx,18
	imul	dx
	pop	dx
	add	dx,ax
	add	dx,word ptr [bp+10]
	movsx	eax,dx
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	  if (op == 2) himem_read ( (adr * 512) + 0x200000 , (UINT)segm, (UINT)ofs, count * 512);
   ;	
	cmp	word ptr [bp+18],2
	jne	short @4@86
	mov	ax,si
	shl	ax,9
	movsx	eax,ax
	push	eax
	push	di
	push	word ptr [bp+16]
	mov	eax,dword ptr [bp-4]
	shl	eax,9
	add	eax,large 000200000h
	push	eax
	call	near ptr _himem_read
	add	sp,12
@4@86:
   ;	
   ;	  if (op == 3) himem_write ((UINT)segm, (UINT)ofs, (adr * 512) + 0x200000, count * 512);
   ;	
	cmp	word ptr [bp+18],3
	jne	short @4@142
	mov	ax,si
	shl	ax,9
	movsx	eax,ax
	push	eax
	mov	eax,dword ptr [bp-4]
	shl	eax,9
	add	eax,large 000200000h
	push	eax
	push	di
	push	word ptr [bp+16]
	call	near ptr _himem_write
	add	sp,12
@4@142:
   ;	
   ;	  return 0;
   ;	
	mov	al,0
   ;	
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	leave	
	ret	
_disk_access	endp
   ;	
   ;	 BOOL r_disk_access (UCHAR d,               // lecteur
   ;	
	assume	cs:_TEXT
_r_disk_access	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	                   int h,                 // tˆte
   ;	                   int c,                 // cylindre
   ;	                   int s,                 // secteur
   ;	                   int count,             // nombre de secteur(s) … ‚crire
   ;	                   void* ofs,             // 'offset' du buffer
   ;	                   UINT segm,             // 'segm' du buffer
   ;	                   int op)                // op‚ration … effecteur 
   ;	 {
   ;	  asm {
   ;	       push dx
   ;	
	push	 dx
   ;	
   ;	       push cx
   ;	
	push	 cx
   ;	
   ;	       push bx
   ;	
	push	 bx
   ;	
   ;	       push es
   ;	
	push	 es
   ;	
   ;	       mov dl,d
   ;	
	mov	 dl,[bp+4]
   ;	
   ;	       mov ax,h
   ;	
	mov	 ax,[bp+6]
   ;	
   ;	       mov dh,al
   ;	
	mov	 dh,al
   ;	
   ;	       mov cx,c
   ;	
	mov	 cx,[bp+8]
   ;	
   ;	       xchg ch,cl
   ;	
	xchg	 ch,cl
   ;	
   ;	       shl cl,6
   ;	
	shl	 cl,6
   ;	
   ;	       mov ax,s
   ;	
	mov	 ax,[bp+10]
   ;	
   ;	       or cl,al
   ;	
	or	 cl,al
   ;	
   ;	       mov ax,segm
   ;	
	mov	 ax,[bp+16]
   ;	
   ;	       mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	       mov ax,count
   ;	
	mov	 ax,[bp+12]
   ;	
   ;	       mov bx,op
   ;	
	mov	 bx,[bp+18]
   ;	
   ;	       mov ah,bl
   ;	
	mov	 ah,bl
   ;	
   ;	       mov bx,ofs
   ;	
	mov	 bx,[bp+14]
   ;	
   ;	       int 0x13
   ;	
	int	 013H
   ;	
   ;	       shr ax,8
   ;	
	shr	 ax,8
   ;	
   ;	       pop es
   ;	
	pop	 es
   ;	
   ;	       pop bx
   ;	
	pop	 bx
   ;	
   ;	       pop cx
   ;	
	pop	 cx
   ;	
   ;	       pop dx
   ;	
	pop	 dx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_r_disk_access	endp
   ;	
   ;	void main ()
   ;	
	assume	cs:_TEXT
_main	proc	near
   ;	
   ;	{
   ;	 printf ("\nplease wait while flushing buffer");
   ;	
	push	offset DGROUP:s@
	call	near ptr _printf
	add	sp,2
   ;	
   ;	 for ( head = 0 ; head <= 1 ; head++)
   ;	
	mov	word ptr DGROUP:_head,0
	jmp	short @6@282
@6@30:
   ;	
   ;	   for ( cyl = 0 ; cyl <= 79 ; cyl++)
   ;	
	mov	word ptr DGROUP:_cyl,0
	jmp	short @6@226
@6@58:
   ;	
   ;	   {
   ;	    disk_access (0,head,cyl,1,18,0,0x6000,2);
   ;	
	push	large 000026000h
	push	large 18
	push	1
	push	word ptr DGROUP:_cyl
	push	word ptr DGROUP:_head
	push	0
	call	near ptr _disk_access
	add	sp,16
   ;	
   ;	    r_disk_access (0,head,cyl,1,18,0,0x6000,3);
   ;	
	push	large 000036000h
	push	large 18
	push	1
	push	word ptr DGROUP:_cyl
	push	word ptr DGROUP:_head
	push	0
	call	near ptr _r_disk_access
	add	sp,16
   ;	
   ;	    asm {
   ;	          push ax
   ;	
	push	 ax
   ;	
   ;	          mov al,'.'
   ;	
	mov	 al,'.'
   ;	
   ;	          int 29h
   ;	
	int	 29h
   ;	
   ;	          pop ax
   ;	
	pop	 ax
	inc	word ptr DGROUP:_cyl
@6@226:
	cmp	word ptr DGROUP:_cyl,79
	jle	short @6@58
	inc	word ptr DGROUP:_head
@6@282:
	cmp	word ptr DGROUP:_head,1
	jle	short @6@30
   ;	
   ;	        }
   ;	   }
   ;	
   ;	}
   ;	
	ret	
_main	endp
_TEXT	ends
VP	segment word public use16 'BSS'
_sector	label	word
	db	2 dup (?)
_cyl	label	word
	db	2 dup (?)
_head	label	word
	db	2 dup (?)
	?debug	C E9
	?debug	C FA10000000
VP	ends
_DATA	segment word public use16 'VP'
s@	label	byte
	db	10
	db	'please wait while flushing buffer'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	public	_main
	public	_sector
	public	_cyl
	public	_head
	public	_r_disk_access
	public	_disk_access
	public	_get_size_himem
	public	_himem_read
	public	_himem_write
	extrn	_printf:near
_s@	equ	s@
	end
