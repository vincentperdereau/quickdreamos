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
	?debug	S "xsh.c"
	?debug	C E9845DF158057873682E63
	?debug	C E9E34B535709737461727475702E68
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
   ;	 StartProgram ();
   ;	
	call	near ptr MGRP:_StartProgram
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_main	endp
	?debug	C E9E34B535708737472696E672E68
   ;	
   ;	  void strcpy (string c, string s)
   ;	
	assume	cs:MGRP
_strcpy	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;s[i]!=0;i++) c[i]=s[i];
   ;	
	mov	cl,0
	jmp	short @2@114
@2@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@2@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @2@58
   ;	
   ;	   c[i]=0;
   ;	
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	byte ptr [bx+si],0
   ;	
   ;	  }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_strcpy	endp
   ;	
   ;	  uchar strlen (string s)
   ;	
	assume	cs:MGRP
_strlen	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;s[i]!=0;i++);
   ;	
	mov	dl,0
	jmp	short @3@86
@3@58:
	inc	dl
@3@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @3@58
   ;	
   ;	   return i;
   ;	
	mov	al,dl
   ;	
   ;	  }
   ;	
	pop	bp
	ret	
_strlen	endp
   ;	
   ;	  uchar Xstrlen (char far* s)
   ;	
	assume	cs:MGRP
_Xstrlen	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;s[i]!=0;i++);
   ;	
	mov	dl,0
	jmp	short @4@86
@4@58:
	inc	dl
@4@86:
	mov	al,dl
	mov	ah,0
	les	bx,dword ptr [bp+4]
	add	bx,ax
	cmp	byte ptr es:[bx],0
	jne	short @4@58
   ;	
   ;	   return i;
   ;	
	mov	al,dl
   ;	
   ;	  }
   ;	
	pop	bp
	ret	
_Xstrlen	endp
   ;	
   ;	  void strcat (string c, string s)
   ;	
	assume	cs:MGRP
_strcat	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	  {
   ;	   strcpy ( (string)&(c[strlen(c)]),s);
   ;	
	push	word ptr [bp+6]
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	  }
   ;	
	pop	si
	pop	bp
	ret	
_strcat	endp
   ;	
   ;	  bool strcmp (string a, string b)
   ;	
	assume	cs:MGRP
_strcmp	proc	near
	enter	2,0
	push	si
	mov	cx,word ptr [bp+4]
	mov	si,word ptr [bp+6]
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   ;	
	mov	byte ptr [bp-1],0
	jmp	short @6@86
@6@58:
	inc	byte ptr [bp-1]
@6@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @6@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @6@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @6@58
@6@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @6@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @6@254
	mov	al,0
	jmp	short @6@282
@6@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@6@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
_isFont	label	word
	db	0
	db	0
_gmode	label	byte
	db	1
	?debug	C E9E34B53570666696C652E68
   ;	
   ;	 handle fopen (char* fname)
   ;	
	assume	cs:MGRP
_fopen	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	 {
   ;	  asm {
   ;	        push    si
   ;	
	push	    si
   ;	
   ;	        push    ds
   ;	
	push	    ds
   ;	
   ;	        mov     ax,cs
   ;	
	mov	     ax,cs
   ;	
   ;	        mov     ds,ax
   ;	
	mov	     ds,ax
   ;	
   ;	        mov     ah,0x0002
   ;	
	mov	     ah,00002H
   ;	
   ;	        mov     si,fname
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        mov     edx,eax
   ;	
	mov	     edx,eax
   ;	
   ;	        shr     edx,16
   ;	
	shr	     edx,16
   ;	
   ;	        pop     ds
   ;	
	pop	     ds
   ;	
   ;	        pop     si
   ;	
	pop	     si
   ;	
   ;	      }
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_fopen	endp
   ;	
   ;	 int fread (handle h,long count,void* buffer,unsigned int segm)
   ;	
	assume	cs:MGRP
_fread	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;	        push    es
   ;	
	push	    es
   ;	
   ;	        push    di
   ;	
	push	    di
   ;	
   ;	        push    ecx
   ;	
	push	    ecx
   ;	
   ;	        push    edx
   ;	
	push	    edx
   ;	
   ;	        mov     ax,segm
   ;	
	mov	     ax,[bp+14]
   ;	
   ;	        mov     es,ax
   ;	
	mov	     es,ax
   ;	
   ;	        mov     di,buffer
   ;	
	mov	     di,[bp+12]
   ;	
   ;	        mov     ecx,count
   ;	
	mov	     ecx,[bp+8]
   ;	
   ;	        mov     edx,h
   ;	
	mov	     edx,[bp+4]
   ;	
   ;	        mov     ah,0x0004
   ;	
	mov	     ah,00004H
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        pop     edx
   ;	
	pop	     edx
   ;	
   ;	        pop     ecx
   ;	
	pop	     ecx
   ;	
   ;	        pop     di
   ;	
	pop	     di
   ;	
   ;	        pop     es
   ;	
	pop	     es
   ;	
   ;	      }
   ;	 }
   ;	
	pop	di
	pop	bp
	ret	
_fread	endp
   ;	
   ;	 unsigned long fsize (handle h)
   ;	
	assume	cs:MGRP
_fsize	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	        push    ecx
   ;	
	push	    ecx
   ;	
   ;	        mov     ah,0x000c
   ;	
	mov	     ah,0000cH
   ;	
   ;	        mov     edx,h
   ;	
	mov	     edx,[bp+4]
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        mov     eax,ecx
   ;	
	mov	     eax,ecx
   ;	
   ;	        mov     edx,eax
   ;	
	mov	     edx,eax
   ;	
   ;	        shr     edx,16
   ;	
	shr	     edx,16
   ;	
   ;	        pop     ecx
   ;	
	pop	     ecx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_fsize	endp
   ;	
   ;	 char exec (char* prog,unsigned int segArg,unsigned int ofsArg)
   ;	
	assume	cs:MGRP
_exec	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	 {
   ;	  asm {
   ;	       push     ds
   ;	
	push	     ds
   ;	
   ;	       push     si
   ;	
	push	     si
   ;	
   ;	       mov      ax,0x0601
   ;	
	mov	      ax,00601H
   ;	
   ;	       int      0x46
   ;	
	int	      046H
   ;	
   ;	       mov      ax,cs
   ;	
	mov	      ax,cs
   ;	
   ;	       mov      ds,ax
   ;	
	mov	      ds,ax
   ;	
   ;	       mov      ax,segArg
   ;	
	mov	      ax,[bp+6]
   ;	
   ;	       mov      es,ax
   ;	
	mov	      es,ax
   ;	
   ;	       mov      bx,ofsArg
   ;	
	mov	      bx,[bp+8]
   ;	
   ;	       mov      ah,0x0014
   ;	
	mov	      ah,00014H
   ;	
   ;	       mov      si,prog
   ;	
	mov	      si,[bp+4]
   ;	
   ;	       int      0x44
   ;	
	int	      044H
   ;	
   ;	       pop      si
   ;	
	pop	      si
   ;	
   ;	       pop      ds
   ;	
	pop	      ds
   ;	
   ;	      }
   ;	  }
   ;	
	pop	si
	pop	bp
	ret	
_exec	endp
	?debug	C E9EE90F0580767726170682E68
_COLOR	label	word
	db	15
	db	0
   ;	
   ;	void setpix (int x, int y, unsigned char couleur)
   ;	
	assume	cs:MGRP
_setpix	proc	near
	push	bp
	mov	bp,sp
	mov	dx,word ptr [bp+4]
	mov	bx,word ptr [bp+6]
	mov	cl,byte ptr [bp+8]
   ;	
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @11@86
   ;	
   ;	  setpix1 (x,y,couleur);
   ;	
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_setpix1
	jmp	short @11@114
@11@86:
   ;	
   ;	 else
   ;	  setpix2 (x,y,couleur);
   ;	
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_setpix2
@11@114:
	add	sp,6
   ;	
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_setpix	endp
   ;	
   ;	unsigned char getpix (int x, int y)
   ;	
	assume	cs:MGRP
_getpix	proc	near
	push	bp
	mov	bp,sp
	mov	ax,word ptr [bp+4]
	mov	dx,word ptr [bp+6]
   ;	
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @12@86
   ;	
   ;	  return getpix1 (x,y);
   ;	
	push	dx
	push	ax
	call	near ptr MGRP:_getpix1
	jmp	short @12@114
@12@86:
   ;	
   ;	 else
   ;	  return getpix2 (x,y);
   ;	
	push	dx
	push	ax
	call	near ptr MGRP:_getpix2
@12@114:
	add	sp,4
   ;	
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_getpix	endp
   ;	
   ;	void SetRGB (unsigned char Nr, unsigned char R, unsigned char G,
   ;	
	assume	cs:MGRP
_SetRGB	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;		       unsigned char B)
   ;	{
   ;	 asm {
   ;	       mov al,Nr
   ;	
	mov	 al,[bp+4]
   ;	
   ;	       mov dx,0x3c8
   ;	
	mov	 dx,03c8H
   ;	
   ;	       out dx,al
   ;	
	out	 dx,al
   ;	
   ;	       mov dx,0x3c9
   ;	
	mov	 dx,03c9H
   ;	
   ;	       mov al,R
   ;	
	mov	 al,[bp+6]
   ;	
   ;	       out dx,al
   ;	
	out	 dx,al
   ;	
   ;	       mov al,G
   ;	
	mov	 al,[bp+8]
   ;	
   ;	       out dx,al
   ;	
	out	 dx,al
   ;	
   ;	       mov al,B
   ;	
	mov	 al,[bp+10]
   ;	
   ;	       out dx,al
   ;	
	out	 dx,al
   ;	
   ;	 }
   ;	}
   ;	
	pop	bp
	ret	
_SetRGB	endp
   ;	
   ;	void scroll_down2 (unsigned int x, unsigned int y, unsigned int l,
   ;	
	assume	cs:MGRP
_scroll_down2	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;			  unsigned int h, unsigned char speed)
   ;	{
   ;	 asm {
   ;	    push  ds
   ;	
	push	  ds
   ;	
   ;	
   ;	    mov   dx, 0x3CE
   ;	
	mov	   dx, 03CEH
   ;	
   ;	    mov   ax, 0x0105
   ;	
	mov	   ax, 00105H
   ;	
   ;	    out   dx, ax
   ;	
	out	   dx, ax
   ;	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	
   ;	    mov   cx, h
   ;	
	mov	   cx, [bp+10]
   ;	
   ;	    mov   ax, cx
   ;	
	mov	   ax, cx
   ;	
   ;	    mov   si, cx
   ;	
	mov	   si, cx
   ;	
   ;	    shl   ax, 5
   ;	
	shl	   ax, 5
   ;	
   ;	    shl   cx, 6
   ;	
	shl	   cx, 6
   ;	
   ;	    shl   si, 2
   ;	
	shl	   si, 2
   ;	
   ;	    add   cx,si
   ;	
	add	   cx,si
   ;	
   ;	    add   cx, ax
   ;	
	add	   cx, ax
   ;	
   ;	
   ;	    mov   bx, y
   ;	
	mov	   bx, [bp+6]
   ;	
   ;	    mov   si, bx
   ;	
	mov	   si, bx
   ;	
   ;	    mov   ax, bx
   ;	
	mov	   ax, bx
   ;	
   ;	    shl   ax, 5
   ;	
	shl	   ax, 5
   ;	
   ;	    shl   bx, 6
   ;	
	shl	   bx, 6
   ;	
   ;	    shl   si,2
   ;	
	shl	   si,2
   ;	
   ;	    add   bx, ax
   ;	
	add	   bx, ax
   ;	
   ;	    add   bx,si
   ;	
	add	   bx,si
   ;	
   ;	
   ;	    mov   ax, x
   ;	
	mov	   ax, [bp+4]
   ;	
   ;	    shr   ax, 3
   ;	
	shr	   ax, 3
   ;	
   ;	    add   bx, ax
   ;	
	add	   bx, ax
   ;	
   ;	
   ;	    xor   dh, dh
   ;	
	xor	   dh, dh
   ;	
   ;	    mov   dl, speed
   ;	
	mov	   dl, [bp+12]
   ;	
   ;	    mov   ax, dx
   ;	
	mov	   ax, dx
   ;	
   ;	    mov   di, dx
   ;	
	mov	   di, dx
   ;	
   ;	    shl   ax, 5
   ;	
	shl	   ax, 5
   ;	
   ;	    shl   dx, 6
   ;	
	shl	   dx, 6
   ;	
   ;	    shl   di, 2
   ;	
	shl	   di, 2
   ;	
   ;	    add   dx, ax
   ;	
	add	   dx, ax
   ;	
   ;	    add   dx, di
   ;	
	add	   dx, di
   ;	
   ;	
   ;	    mov   ax, cx
   ;	
	mov	   ax, cx
   ;	
   ;	
   ;	    mov   si, 0xA000
   ;	
	mov	   si, 0A000H
   ;	
   ;	    mov   ds, si
   ;	
	mov	   ds, si
   ;	
   ;	    mov   es, si
   ;	
	mov	   es, si
@14@1066:
   ;	
   ;	}
   ;	
   ;	yop8086:
   ;	
   ;	asm {
   ;	
   ;	    mov   si, bx
   ;	
	mov	   si, bx
   ;	
   ;	    add   si, ax
   ;	
	add	   si, ax
   ;	
   ;	    mov   di, si
   ;	
	mov	   di, si
   ;	
   ;	    add   di, dx
   ;	
	add	   di, dx
   ;	
   ;	
   ;	    mov   cx, l
   ;	
	mov	   cx, [bp+8]
   ;	
   ;	    shr   cx, 3
   ;	
	shr	   cx, 3
   ;	
   ;	    rep   movsb
   ;	
	rep   movsb	
   ;	
   ;	
   ;	    sub   ax, 100
   ;	
	sub	   ax, 100
   ;	
   ;	    cmp   ax, 0
   ;	
	cmp	   ax, 0
   ;	
   ;	    ja    yop8086
   ;	
	ja	short @14@1066
   ;	
   ;	
   ;	    pop   ds
   ;	
	pop	   ds
   ;	
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_scroll_down2	endp
   ;	
   ;	void scroll_down1 (unsigned int x, unsigned int y, unsigned int l,
   ;	
	assume	cs:MGRP
_scroll_down1	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;			  unsigned int h, unsigned char speed)
   ;	{
   ;	 asm {
   ;	    push  ds
   ;	
	push	  ds
   ;	
   ;	
   ;	    mov   dx, 0x3CE
   ;	
	mov	   dx, 03CEH
   ;	
   ;	    mov   ax, 0x0105
   ;	
	mov	   ax, 00105H
   ;	
   ;	    out   dx, ax
   ;	
	out	   dx, ax
   ;	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	
   ;	    mov   cx, h
   ;	
	mov	   cx, [bp+10]
   ;	
   ;	    mov   ax, cx
   ;	
	mov	   ax, cx
   ;	
   ;	    shl   ax, 4
   ;	
	shl	   ax, 4
   ;	
   ;	    shl   cx, 6
   ;	
	shl	   cx, 6
   ;	
   ;	    add   cx, ax
   ;	
	add	   cx, ax
   ;	
   ;	
   ;	    mov   bx, y
   ;	
	mov	   bx, [bp+6]
   ;	
   ;	    mov   ax, bx
   ;	
	mov	   ax, bx
   ;	
   ;	    shl   ax, 4
   ;	
	shl	   ax, 4
   ;	
   ;	    shl   bx, 6
   ;	
	shl	   bx, 6
   ;	
   ;	    add   bx, ax
   ;	
	add	   bx, ax
   ;	
   ;	    mov   ax, x
   ;	
	mov	   ax, [bp+4]
   ;	
   ;	    shr   ax, 3
   ;	
	shr	   ax, 3
   ;	
   ;	    add   bx, ax
   ;	
	add	   bx, ax
   ;	
   ;	
   ;	    xor   dh, dh
   ;	
	xor	   dh, dh
   ;	
   ;	    mov   dl, speed
   ;	
	mov	   dl, [bp+12]
   ;	
   ;	    mov   ax, dx
   ;	
	mov	   ax, dx
   ;	
   ;	    shl   ax, 4
   ;	
	shl	   ax, 4
   ;	
   ;	    shl   dx, 6
   ;	
	shl	   dx, 6
   ;	
   ;	    add   dx, ax    
   ;	
	add	   dx, ax    
   ;	
   ;	
   ;	    mov   ax, cx    
   ;	
	mov	   ax, cx    
   ;	
   ;	
   ;	    mov   si, 0xA000
   ;	
	mov	   si, 0A000H
   ;	
   ;	    mov   ds, si
   ;	
	mov	   ds, si
   ;	
   ;	    mov   es, si 
   ;	
	mov	   es, si 
@15@814:
   ;	
   ;	}
   ;	
   ;	yop8086:               
   ;	
   ;	asm {
   ;	
   ;	    mov   si, bx
   ;	
	mov	   si, bx
   ;	
   ;	    add   si, ax
   ;	
	add	   si, ax
   ;	
   ;	    mov   di, si
   ;	
	mov	   di, si
   ;	
   ;	    add   di, dx 
   ;	
	add	   di, dx 
   ;	
   ;	
   ;	    mov   cx, l  
   ;	
	mov	   cx, [bp+8]  
   ;	
   ;	    shr   cx, 3
   ;	
	shr	   cx, 3
   ;	
   ;	    rep   movsb  
   ;	
	rep   movsb	  
   ;	
   ;	
   ;	    sub   ax, 80 
   ;	
	sub	   ax, 80 
   ;	
   ;	    cmp   ax, 0
   ;	
	cmp	   ax, 0
   ;	
   ;	    ja    yop8086
   ;	
	ja	short @15@814
   ;	
   ;	
   ;	    pop   ds
   ;	
	pop	   ds
   ;	
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_scroll_down1	endp
   ;	
   ;	void scroll_down (unsigned int x, unsigned int y, unsigned int l,
   ;	
	assume	cs:MGRP
_scroll_down	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	dx,word ptr [bp+4]
	mov	bx,word ptr [bp+6]
	mov	cx,word ptr [bp+8]
	mov	si,word ptr [bp+10]
   ;	
   ;			  unsigned int h, unsigned char speed)
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @16@86
   ;	
   ;	  scroll_down1 (x,y,l,h,speed);
   ;	
	mov	al,byte ptr [bp+12]
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_scroll_down1
	jmp	short @16@114
@16@86:
   ;	
   ;	 else 
   ;	  scroll_down2 (x,y,l,h,speed);
   ;	
	mov	al,byte ptr [bp+12]
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_scroll_down2
@16@114:
	add	sp,10
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_scroll_down	endp
   ;	
   ;	void SetVideo (char stat)
   ;	
	assume	cs:MGRP
_SetVideo	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		mov ah,0x12
   ;	
	mov	 ah,012H
   ;	
   ;		mov bl,0x36
   ;	
	mov	 bl,036H
   ;	
   ;		mov al,stat
   ;	
	mov	 al,[bp+4]
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_SetVideo	endp
_fptr	label	dword
	db	0
	db	0
	db	0
	db	0
   ;	
   ;	void PrintChar( char caractere, int x, int y, BYTE cc, BYTE cf , BYTE m)
   ;	
	assume	cs:MGRP
_PrintChar	proc	near
	enter	4,0
	push	si
	push	di
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
   ;	
   ;	{
   ;	
   ;	 BYTE         i, k, j,                         /* Compteur d'it‚rations */
   ;	       masque;           /* Masque binaire pour dessiner le caractŠre */
   ;	
   ;	 if ( fptr == (CARPTR) 0 )     /* A-t-on d‚j… d‚termin‚ ce pointeur ? */
   ;	
	cmp	dword ptr MGRP:_fptr,large 0
	jne	short @18@86
   ;	
   ;	  fptr = getfontptr();    /* d‚termine avec la fonction en assembleur */
   ;	
	call	near ptr MGRP:_getfontptr
	mov	word ptr MGRP:_fptr+2,dx
	mov	word ptr MGRP:_fptr,ax
@18@86:
   ;	
   ;	
   ;	
   ;	  /*- Dessine le caractŠre pixel par pixel ---------------------------*/
   ;	
   ;	 if ( cf == 255 )                          /* CaractŠre transparent ? */
   ;	
	cmp	byte ptr [bp+12],255
	je short	@@0
	jmp	@18@366
@@0:
   ;	
   ;	  for ( i = 0, j = 0; i < (16<<m); i += (m+1),++j ) /* dessine que les pixels du premier plan */
   ;	
	mov	byte ptr [bp-1],0
	mov	byte ptr [bp-3],0
	jmp	@18@310
@18@142:
   ;	
   ;	   {
   ;	    masque = (*fptr)[caractere][j];         /* Lit le motif bin/ligne */
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	shl	ax,4
	les	bx,dword ptr MGRP:_fptr
	add	bx,ax
	mov	al,byte ptr [bp-3]
	mov	ah,0
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-4],al
   ;	
   ;	    for ( k = 0; k < (8<<m); k += (m+1), masque <<= 1 )  /* Parcourt les colonnes */
   ;	
	mov	byte ptr [bp-2],0
	jmp	short @18@254
@18@170:
   ;	
   ;	     {
   ;	     if ( masque & 128 )                        /* Pixel … dessiner ? */
   ;	
	test	byte ptr [bp-4],128
	je	short @18@226
   ;	
   ;	      {
   ;	       setpix( x+k, y+i, cc );                                  /* Oui */
   ;	
	mov	al,byte ptr [bp+10]
	push	ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,di
	add	dx,ax
	push	dx
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@18@226:
	mov	al,byte ptr [bp+14]
	add	al,byte ptr [bp-2]
	inc	al
	mov	byte ptr [bp-2],al
	shl	byte ptr [bp-4],1
@18@254:
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,8
	mov	cl,byte ptr [bp+14]
	shl	dx,cl
	cmp	ax,dx
	jl	short @18@170
	mov	al,byte ptr [bp+14]
	add	al,byte ptr [bp-1]
	inc	al
	mov	byte ptr [bp-1],al
	mov	al,byte ptr [bp-3]
	inc	al
	mov	byte ptr [bp-3],al
@18@310:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,16
	mov	cl,byte ptr [bp+14]
	shl	dx,cl
	cmp	ax,dx
	jge short	@@1
	jmp	@18@142
@@1:
   ;	
   ;	      }
   ;	    }
   ;	   }
   ;	
	jmp	short @18@646
@18@366:
   ;	
   ;	 else                                     /* Non dessine chaque pixel */
   ;	  for ( i = 0; i < 8; ++i )                    /* Parcourt les lignes */
   ;	
	mov	byte ptr [bp-1],0
	jmp	short @18@618
@18@394:
   ;	
   ;	  {
   ;	   masque = (*fptr)[caractere][i];          /* Lit le motif bin/ligne */
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	shl	ax,4
	les	bx,dword ptr MGRP:_fptr
	add	bx,ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-4],al
   ;	
   ;	   for ( k = 0; k < 8; ++k, masque <<= 1 )   /* Parcourt les colonnes */
   ;	
	mov	byte ptr [bp-2],0
	jmp	short @18@562
@18@422:
   ;	
   ;	    setpix( x+k, y+i, (BYTE) (( masque & 128 ) ? cc : cf) );
   ;	
	test	byte ptr [bp-4],128
	je	short @18@478
	mov	al,byte ptr [bp+10]
	jmp	short @18@506
@18@478:
	mov	al,byte ptr [bp+12]
@18@506:
	push	ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,di
	add	dx,ax
	push	dx
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
	mov	al,byte ptr [bp-2]
	inc	al
	mov	byte ptr [bp-2],al
	shl	byte ptr [bp-4],1
@18@562:
	cmp	byte ptr [bp-2],8
	jb	short @18@422
	mov	al,byte ptr [bp-1]
	inc	al
	mov	byte ptr [bp-1],al
@18@618:
	cmp	byte ptr [bp-1],8
	jb	short @18@394
@18@646:
   ;	
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_PrintChar	endp
   ;	
   ;	unsigned long getOfs (int i)
   ;	
	assume	cs:MGRP
_getOfs	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		mov dx,font_mem
   ;	
	mov	 dx,MGRP:_font_mem
   ;	
   ;		mov ax,i
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		shl ax,12
   ;	
	shl	 ax,12
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_getOfs	endp
   ;	
   ;	void setFont (int i)
   ;	
	assume	cs:MGRP
_setFont	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 fptr = (CARPTR)(getOfs (i));
   ;	
	push	word ptr [bp+4]
	call	near ptr MGRP:_getOfs
	push	dx
	push	ax
	pop	eax
	pop	cx
	shld	edx,eax,16
	mov	word ptr MGRP:_fptr+2,dx
	mov	word ptr MGRP:_fptr,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_setFont	endp
   ;	
   ;	int abs (int n)
   ;	
	assume	cs:MGRP
_abs	proc	near
	push	bp
	mov	bp,sp
	mov	dx,word ptr [bp+4]
   ;	
   ;	{
   ;	 if (n >= 0) return n;
   ;	
	or	dx,dx
	jl	short @21@86
	mov	ax,dx
	jmp	short @21@114
@21@86:
   ;	
   ;	 else return (-n);
   ;	
	mov	ax,dx
	neg	ax
@21@114:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_abs	endp
   ;	
   ;	void writenum (int x, int y, unsigned long dw,char size)
   ;	
	assume	cs:MGRP
_writenum	proc	near
	enter	4,0
	push	si
	push	di
	mov	al,byte ptr [bp+12]
   ;	
   ;	{
   ;	 unsigned long i ; unsigned char b ;
   ;	 int flag=0;
   ;	
	xor	di,di
   ;	
   ;	 int j = 0;
   ;	
	xor	si,si
   ;	
   ;	
   ;	 if (size==8) i = 100;
   ;	
	cmp	al,8
	jne	short @22@86
	mov	dword ptr [bp-4],large 100
@22@86:
   ;	
   ;	 if (size==16) i = 10000;
   ;	
	cmp	al,16
	jne	short @22@142
	mov	dword ptr [bp-4],large 10000
@22@142:
   ;	
   ;	 if (size==32) i = 1000000000;
   ;	
	cmp	al,32
	je short	@@2
	jmp	@22@450
@@2:
	mov	dword ptr [bp-4],large 03B9ACA00h
	jmp	@22@450
@22@198:
   ;	
   ;	
   ;	 for (;i!=0;i/=10)
   ;	 {
   ;	 b = dw / i ; dw = dw - (b*i) ;
   ;	
	mov	eax,dword ptr [bp+8]
	xor	edx,edx
	div	dword ptr [bp-4]
	mov	bl,al
	mov	ah,0
	movsx	eax,ax
	imul	eax,dword ptr [bp-4]
	mov	edx,dword ptr [bp+8]
	sub	edx,eax
	mov	dword ptr [bp+8],edx
   ;	
   ;	 if (b) flag = 1;
   ;	
	or	bl,bl
	je	short @22@254
	mov	di,1
@22@254:
   ;	
   ;	 if (flag) PrintChar (b+48,x+(j<<3) ,y + deltaw,0,255,0);
   ;	
	or	di,di
	je	short @22@310
	push	0
	push	255
	push	0
	mov	ax,word ptr [bp+6]
	add	ax,word ptr MGRP:_deltaw
	push	ax
	mov	ax,si
	shl	ax,3
	mov	dx,word ptr [bp+4]
	add	dx,ax
	push	dx
	mov	al,bl
	add	al,48
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
@22@310:
   ;	
   ;	 if ( (!i) && (!flag)) PrintChar (48,x+(j<<3) ,y + deltaw,0,255,0);
   ;	
	cmp	dword ptr [bp-4],large 0
	jne	short @22@394
	or	di,di
	jne	short @22@394
	push	0
	push	255
	push	0
	mov	ax,word ptr [bp+6]
	add	ax,word ptr MGRP:_deltaw
	push	ax
	mov	ax,si
	shl	ax,3
	mov	dx,word ptr [bp+4]
	add	dx,ax
	push	dx
	push	48
	call	near ptr MGRP:_PrintChar
	add	sp,12
@22@394:
   ;	
   ;	 j = j + 1;
   ;	
	inc	si
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@22@450:
	cmp	dword ptr [bp-4],large 0
	je short	@@3
	jmp	@22@198
@@3:
   ;	
   ;	 }
   ;	 deltaw = deltaw + 8;
   ;	
	mov	ax,word ptr MGRP:_deltaw
	add	ax,8
	mov	word ptr MGRP:_deltaw,ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_writenum	endp
   ;	
   ;	unsigned int imagesize(unsigned int x,unsigned int y,
   ;	
	assume	cs:MGRP
_imagesize	proc	near
	enter	8,0
   ;	
   ;			       unsigned int x0,unsigned int y0)
   ;	{
   ;	unsigned long dummy;
   ;	unsigned int sx,sy;
   ;	
   ;	  sx = (abs(x0-x) / 8)+1;
   ;	
	mov	ax,word ptr [bp+8]
	sub	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	mov	bx,8
	cwd	
	idiv	bx
	inc	ax
	mov	word ptr [bp-6],ax
   ;	
   ;	  sy = (abs(y0-y))+1;
   ;	
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	inc	ax
	mov	word ptr [bp-8],ax
   ;	
   ;	  dummy = (unsigned long)sx*(unsigned long)sy*4+10;   
   ;	
	movzx	eax,word ptr [bp-6]
	movzx	edx,word ptr [bp-8]
	imul	eax,edx
	shl	eax,2
	add	eax,large 10
	mov	dword ptr [bp-4],eax
   ;	
   ;	  
   ;	  //writenum (10,400,sx,16);
   ;	  //writenum (110,400-8,sy,16);
   ;	  //writenum (210,400-16,dummy,32);
   ;	   
   ;	  if (dummy<65520) 
   ;	
	cmp	dword ptr [bp-4],large 00000FFF0h
	jae	short @23@86
   ;	
   ;	    return dummy;
   ;	
	mov	ax,word ptr [bp-4]
	jmp	short @23@114
@23@86:
   ;	
   ;	  else
   ;	    {
   ;	     halt();
   ;	
	call	near ptr MGRP:_halt
   ;	
   ;	     return 0;
   ;	
	xor	ax,ax
@23@114:
   ;	
   ;	    }
   ;	}
   ;	
	leave	
	ret	
_imagesize	endp
   ;	
   ;	void getimage2(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_getimage2	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;			unsigned int x0, unsigned int y0,
   ;			unsigned int adr)
   ;	{
   ;	unsigned int m;
   ;	asm {
   ;	    sti
   ;	
	sti	
   ;	
   ;	    push es
   ;	
	push	 es
   ;	
   ;	    push ds
   ;	
	push	 ds
   ;	
   ;	    pusha
   ;	
	pusha	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	    mov ax,adr
   ;	
	mov	 ax,[bp+12]
   ;	
   ;	    mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	    xor di,di
   ;	
	xor	 di,di
   ;	
   ;	
   ;	    mov ax,x0
   ;	
	mov	 ax,[bp+8]
   ;	
   ;	    sub ax,x
   ;	
	sub	 ax,[bp+4]
   ;	
   ;	    shr ax,3
   ;	
	shr	 ax,3
   ;	
   ;	    mov x0,ax
   ;	
	mov	 [bp+8],ax
   ;	
   ;	    mov es:[di],ax
   ;	
	mov	 es:[di],ax
   ;	
   ;	    inc x0
   ;	
	inc	 [bp+8]
   ;	
   ;	    mov ax,y0
   ;	
	mov	 ax,[bp+10]
   ;	
   ;	    sub ax,y
   ;	
	sub	 ax,[bp+6]
   ;	
   ;	    mov y0,ax
   ;	
	mov	 [bp+10],ax
   ;	
   ;	    mov es:[di+2],ax
   ;	
	mov	 es:[di+2],ax
   ;	
   ;	    inc y0
   ;	
	inc	 [bp+10]
   ;	
   ;	    add di,4
   ;	
	add	 di,4
   ;	
   ;	    shr x,3
   ;	
	shr	 [bp+4],3
   ;	
   ;	    mov bx,y
   ;	
	mov	 bx,[bp+6]
   ;	
   ;	    mov cx,bx
   ;	
	mov	 cx,bx
   ;	
   ;	    mov si,bx
   ;	
	mov	 si,bx
   ;	
   ;	    shl bx,5
   ;	
	shl	 bx,5
   ;	
   ;	    shl cx,6
   ;	
	shl	 cx,6
   ;	
   ;	    shl si,2
   ;	
	shl	 si,2
   ;	
   ;	    add bx,si
   ;	
	add	 bx,si
   ;	
   ;	    add bx,cx
   ;	
	add	 bx,cx
   ;	
   ;	    add bx,x
   ;	
	add	 bx,[bp+4]
   ;	
   ;	    mov m,bx
   ;	
	mov	 [bp-2],bx
   ;	
   ;	    mov ax,0a000h
   ;	
	mov	 ax,0a000h
   ;	
   ;	    mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	    mov bx,y0
   ;	
	mov	 bx,[bp+10]
   ;	
   ;	    mov dx,03ceh
   ;	
	mov	 dx,03ceh
   ;	
   ;	    mov al,4
   ;	
	mov	 al,4
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
@24@1094:
   ;	
   ;	}
   ;	label1:
   ;	asm {
   ;	    mov ah,4
   ;	
	mov	 ah,4
@24@1122:
   ;	
   ;	    }
   ;	label2:
   ;	asm {
   ;	    mov al,ah
   ;	
	mov	 al,ah
   ;	
   ;	    dec al
   ;	
	dec	 al
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    mov si,m
   ;	
	mov	 si,[bp-2]
   ;	
   ;	    mov cx,x0
   ;	
	mov	 cx,[bp+8]
   ;	
   ;	    rep movsb
   ;	
	rep movsb	
   ;	
   ;	    dec ah
   ;	
	dec	 ah
   ;	
   ;	    jnz label2
   ;	
	jne	short @24@1122
   ;	
   ;	    add m,100      ;
   ;	
	add	 [bp-2],100      
   ;	
   ;	    dec bx
   ;	
	dec	 bx
   ;	
   ;	    jnz label1
   ;	
	jne	short @24@1094
   ;	
   ;	    dec dx
   ;	
	dec	 dx
   ;	
   ;	    mov al,3
   ;	
	mov	 al,3
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
   ;	
   ;	    xor al,al
   ;	
	xor	 al,al
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    popa
   ;	
	popa	
   ;	
   ;	    pop ds
   ;	
	pop	 ds
   ;	
   ;	    pop es
   ;	
	pop	 es
   ;	
   ;	    cli
   ;	
	cli	
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_getimage2	endp
   ;	
   ;	void putimage2(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_putimage2	proc	near
	enter	6,0
	push	si
	push	di
   ;	
   ;		      unsigned int adr)
   ;	{
   ;	unsigned int sx,sy,m;
   ;	asm {
   ;	    sti
   ;	
	sti	
   ;	
   ;	    push es
   ;	
	push	 es
   ;	
   ;	    push ds
   ;	
	push	 ds
   ;	
   ;	    pusha
   ;	
	pusha	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	    shr x,3
   ;	
	shr	 [bp+4],3
   ;	
   ;	    mov bx,y
   ;	
	mov	 bx,[bp+6]
   ;	
   ;	    mov cx,bx
   ;	
	mov	 cx,bx
   ;	
   ;	    mov si,bx
   ;	
	mov	 si,bx
   ;	
   ;	    shl bx,5
   ;	
	shl	 bx,5
   ;	
   ;	    shl cx,6
   ;	
	shl	 cx,6
   ;	
   ;	    shl si,2
   ;	
	shl	 si,2
   ;	
   ;	    add bx,cx
   ;	
	add	 bx,cx
   ;	
   ;	    add bx,si
   ;	
	add	 bx,si
   ;	
   ;	    add bx,x
   ;	
	add	 bx,[bp+4]
   ;	
   ;	    mov m,bx
   ;	
	mov	 [bp-6],bx
   ;	
   ;	
   ;	    mov ax,adr
   ;	
	mov	 ax,[bp+8]
   ;	
   ;	    mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	    xor si,si
   ;	
	xor	 si,si
   ;	
   ;	
   ;	    mov ax,word ptr ds:[si]
   ;	
	mov	 ax,word ptr ds:[si]
   ;	
   ;	    inc ax
   ;	
	inc	 ax
   ;	
   ;	    mov sx,ax
   ;	
	mov	 [bp-2],ax
   ;	
   ;	    mov ax,word ptr ds:[si+2]
   ;	
	mov	 ax,word ptr ds:[si+2]
   ;	
   ;	    inc ax
   ;	
	inc	 ax
   ;	
   ;	    mov sy,ax
   ;	
	mov	 [bp-4],ax
   ;	
   ;	    add si,4
   ;	
	add	 si,4
   ;	
   ;	    mov ax,0a000h
   ;	
	mov	 ax,0a000h
   ;	
   ;	    mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	    mov bx,sy
   ;	
	mov	 bx,[bp-4]
   ;	
   ;	    mov dx,03c4h
   ;	
	mov	 dx,03c4h
   ;	
   ;	    mov al,2
   ;	
	mov	 al,2
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
@25@954:
   ;	
   ;	}
   ;	olabel1:
   ;	asm {
   ;	    mov al,8
   ;	
	mov	 al,8
@25@982:
   ;	
   ;	}
   ;	olabel2:
   ;	asm {
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    mov di,m
   ;	
	mov	 di,[bp-6]
   ;	
   ;	    mov cx,sx
   ;	
	mov	 cx,[bp-2]
   ;	
   ;	    rep movsb
   ;	
	rep movsb	
   ;	
   ;	    shr al,1
   ;	
	shr	 al,1
   ;	
   ;	    jnz olabel2
   ;	
	jne	short @25@982
   ;	
   ;	    add m,100 ;
   ;	
	add	 [bp-6],100 
   ;	
   ;	    dec bx
   ;	
	dec	 bx
   ;	
   ;	    jnz olabel1
   ;	
	jne	short @25@954
   ;	
   ;	    dec dx
   ;	
	dec	 dx
   ;	
   ;	    mov al,2
   ;	
	mov	 al,2
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
   ;	
   ;	    mov al,15
   ;	
	mov	 al,15
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    popa
   ;	
	popa	
   ;	
   ;	    pop ds
   ;	
	pop	 ds
   ;	
   ;	    pop es
   ;	
	pop	 es
   ;	
   ;	    cli
   ;	
	cli	
   ;	
   ;	}
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_putimage2	endp
   ;	
   ;	void fastbar2(int x, int y, int x2, int y2)
   ;	
	assume	cs:MGRP
_fastbar2	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;	
   ;	{
   ;	char color = COLOR;
   ;	
	mov	al,byte ptr MGRP:_COLOR
	mov	byte ptr [bp-1],al
   ;	
   ;	
   ;	x--; x2--;
   ;	
	dec	word ptr [bp+4]
	dec	word ptr [bp+8]
   ;	
   ;	asm {
   ;	  push ax
   ;	
	push	 ax
   ;	
   ;	  push bx
   ;	
	push	 bx
   ;	
   ;	  push cx
   ;	
	push	 cx
   ;	
   ;	  push dx
   ;	
	push	 dx
   ;	
   ;	  push si
   ;	
	push	 si
   ;	
   ;	  push di
   ;	
	push	 di
   ;	
   ;	  push es
   ;	
	push	 es
   ;	
   ;	
   ;	  mov dx,0x3ce
   ;	
	mov	 dx,03ceH
   ;	
   ;	  mov ax,517
   ;	
	mov	 ax,517
   ;	
   ;	  out dx,ax
   ;	
	out	 dx,ax
   ;	
   ;	  mov ax,0xa000
   ;	
	mov	 ax,0a000H
   ;	
   ;	  mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	  mov si,y
   ;	
	mov	 si,[bp+6]
   ;	
   ;	  mov cx,y2
   ;	
	mov	 cx,[bp+10]
   ;	
   ;	  dec si
   ;	
	dec	 si
   ;	
   ;	  mov ah,128
   ;	
	mov	 ah,128
@26@506:
   ;	
   ;	}
   ;	boucle3:
   ;	asm {
   ;	
   ;	 mov al,0
   ;	
	mov	 al,0
   ;	
   ;	 mov dx,0x3ce
   ;	
	mov	 dx,03ceH
   ;	
   ;	 out dx,ax
   ;	
	out	 dx,ax
   ;	
   ;	 shr ah,1
   ;	
	shr	 ah,1
   ;	
   ;	 mov si,y
   ;	
	mov	 si,[bp+6]
   ;	
   ;	 dec si
   ;	
	dec	 si
@26@674:
   ;	
   ;	}
   ;	boucle2:
   ;	asm {
   ;	  inc si
   ;	
	inc	 si
   ;	
   ;	
   ;	  mov bx,si
   ;	
	mov	 bx,si
   ;	
   ;	
   ;	  shl bx,2
   ;	
	shl	 bx,2
   ;	
   ;	  mov di,bx
   ;	
	mov	 di,bx
   ;	
   ;	  shl bx,3
   ;	
	shl	 bx,3
   ;	
   ;	  add di,bx
   ;	
	add	 di,bx
   ;	
   ;	  shl bx,1
   ;	
	shl	 bx,1
   ;	
   ;	  add di,bx
   ;	
	add	 di,bx
   ;	
   ;	
   ;	
   ;	  mov dx,di
   ;	
	mov	 dx,di
   ;	
   ;	
   ;	
   ;	
   ;	  mov bx,x2
   ;	
	mov	 bx,[bp+8]
   ;	
   ;	  shr bx,3
   ;	
	shr	 bx,3
   ;	
   ;	  add dx,bx
   ;	
	add	 dx,bx
   ;	
   ;	  mov bx,x
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	  shr bx,3
   ;	
	shr	 bx,3
   ;	
   ;	  add di,bx
   ;	
	add	 di,bx
   ;	
   ;	  inc dx
   ;	
	inc	 dx
   ;	
   ;	  inc di
   ;	
	inc	 di
@26@1150:
   ;	
   ;	//  dec di
   ;	}
   ;	boucle1:
   ;	asm {
   ;	  mov al,es:[di]
   ;	
	mov	 al,es:[di]
   ;	
   ;	  mov al,color
   ;	
	mov	 al,[bp-1]
   ;	
   ;	  mov es:[di],al
   ;	
	mov	 es:[di],al
   ;	
   ;	  inc di
   ;	
	inc	 di
   ;	
   ;	  cmp di,dx
   ;	
	cmp	 di,dx
   ;	
   ;	  jnge boucle1
   ;	
	jl	short @26@1150
   ;	
   ;	
   ;	  cmp si,cx
   ;	
	cmp	 si,cx
   ;	
   ;	  jnge boucle2
   ;	
	jl	short @26@674
   ;	
   ;	
   ;	  cmp ah,0
   ;	
	cmp	 ah,0
   ;	
   ;	  jne boucle3
   ;	
	jne	short @26@506
   ;	
   ;	
   ;	       mov   dx,3ceh
   ;	
	mov	   dx,3ceh
   ;	
   ;	       mov   ax,(0FFh shl 8 ) + 8
   ;	
	mov	   ax,(0FFh shl 8 ) + 8
   ;	
   ;	       out   dx,ax
   ;	
	out	   dx,ax
   ;	
   ;	
   ;	       mov   ax,(00h shl 8) + 5
   ;	
	mov	   ax,(00h shl 8) + 5
   ;	
   ;	       out   dx,ax
   ;	
	out	   dx,ax
   ;	
   ;	
   ;	
   ;	  pop es
   ;	
	pop	 es
   ;	
   ;	  pop di
   ;	
	pop	 di
   ;	
   ;	  pop si
   ;	
	pop	 si
   ;	
   ;	  pop dx
   ;	
	pop	 dx
   ;	
   ;	  pop cx
   ;	
	pop	 cx
   ;	
   ;	  pop bx
   ;	
	pop	 bx
   ;	
   ;	  pop ax
   ;	
	pop	 ax
   ;	
   ;	}
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_fastbar2	endp
   ;	
   ;	void getimage1(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_getimage1	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;			unsigned int x0, unsigned int y0,
   ;			unsigned int adr)
   ;	{
   ;	unsigned int m;
   ;	asm {
   ;	    sti
   ;	
	sti	
   ;	
   ;	    push es
   ;	
	push	 es
   ;	
   ;	    push ds
   ;	
	push	 ds
   ;	
   ;	    pusha
   ;	
	pusha	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	    mov ax,adr
   ;	
	mov	 ax,[bp+12]
   ;	
   ;	    mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	    xor di,di
   ;	
	xor	 di,di
   ;	
   ;	
   ;	    mov ax,x0
   ;	
	mov	 ax,[bp+8]
   ;	
   ;	    sub ax,x
   ;	
	sub	 ax,[bp+4]
   ;	
   ;	    shr ax,3
   ;	
	shr	 ax,3
   ;	
   ;	    mov x0,ax
   ;	
	mov	 [bp+8],ax
   ;	
   ;	    mov es:[di],ax
   ;	
	mov	 es:[di],ax
   ;	
   ;	    inc x0
   ;	
	inc	 [bp+8]
   ;	
   ;	    mov ax,y0
   ;	
	mov	 ax,[bp+10]
   ;	
   ;	    sub ax,y
   ;	
	sub	 ax,[bp+6]
   ;	
   ;	    mov y0,ax
   ;	
	mov	 [bp+10],ax
   ;	
   ;	    mov es:[di+2],ax
   ;	
	mov	 es:[di+2],ax
   ;	
   ;	    inc y0
   ;	
	inc	 [bp+10]
   ;	
   ;	    add di,4
   ;	
	add	 di,4
   ;	
   ;	    shr x,3
   ;	
	shr	 [bp+4],3
   ;	
   ;	    mov bx,y
   ;	
	mov	 bx,[bp+6]
   ;	
   ;	    mov cx,bx
   ;	
	mov	 cx,bx
   ;	
   ;	    shl bx,4
   ;	
	shl	 bx,4
   ;	
   ;	    shl cx,6
   ;	
	shl	 cx,6
   ;	
   ;	    add bx,cx
   ;	
	add	 bx,cx
   ;	
   ;	    add bx,x
   ;	
	add	 bx,[bp+4]
   ;	
   ;	    mov m,bx
   ;	
	mov	 [bp-2],bx
   ;	
   ;	    mov ax,0a000h
   ;	
	mov	 ax,0a000h
   ;	
   ;	    mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	    mov bx,y0
   ;	
	mov	 bx,[bp+10]
   ;	
   ;	    mov dx,03ceh
   ;	
	mov	 dx,03ceh
   ;	
   ;	    mov al,4
   ;	
	mov	 al,4
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
@27@1010:
   ;	
   ;	}
   ;	label1:
   ;	asm {
   ;	    mov ah,4
   ;	
	mov	 ah,4
@27@1038:
   ;	
   ;	    }
   ;	label2:
   ;	asm {
   ;	    mov al,ah
   ;	
	mov	 al,ah
   ;	
   ;	    dec al
   ;	
	dec	 al
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    mov si,m
   ;	
	mov	 si,[bp-2]
   ;	
   ;	    mov cx,x0
   ;	
	mov	 cx,[bp+8]
   ;	
   ;	    rep movsb
   ;	
	rep movsb	
   ;	
   ;	    dec ah
   ;	
	dec	 ah
   ;	
   ;	    jnz label2
   ;	
	jne	short @27@1038
   ;	
   ;	    add m,80
   ;	
	add	 [bp-2],80
   ;	
   ;	    dec bx
   ;	
	dec	 bx
   ;	
   ;	    jnz label1
   ;	
	jne	short @27@1010
   ;	
   ;	    dec dx
   ;	
	dec	 dx
   ;	
   ;	    mov al,3
   ;	
	mov	 al,3
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
   ;	
   ;	    xor al,al
   ;	
	xor	 al,al
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    popa
   ;	
	popa	
   ;	
   ;	    pop ds
   ;	
	pop	 ds
   ;	
   ;	    pop es
   ;	
	pop	 es
   ;	
   ;	    cli
   ;	
	cli	
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_getimage1	endp
   ;	
   ;	void putimage1(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_putimage1	proc	near
	enter	6,0
	push	si
	push	di
   ;	
   ;		      unsigned int adr)
   ;	{
   ;	unsigned int sx,sy,m;
   ;	asm {
   ;	    sti
   ;	
	sti	
   ;	
   ;	    push es
   ;	
	push	 es
   ;	
   ;	    push ds
   ;	
	push	 ds
   ;	
   ;	    pusha
   ;	
	pusha	
   ;	
   ;	    cld
   ;	
	cld	
   ;	
   ;	    shr x,3
   ;	
	shr	 [bp+4],3
   ;	
   ;	    mov bx,y
   ;	
	mov	 bx,[bp+6]
   ;	
   ;	    mov cx,bx
   ;	
	mov	 cx,bx
   ;	
   ;	    shl bx,4
   ;	
	shl	 bx,4
   ;	
   ;	    shl cx,6
   ;	
	shl	 cx,6
   ;	
   ;	    add bx,cx
   ;	
	add	 bx,cx
   ;	
   ;	    add bx,x
   ;	
	add	 bx,[bp+4]
   ;	
   ;	    mov m,bx
   ;	
	mov	 [bp-6],bx
   ;	
   ;	
   ;	    mov ax,adr
   ;	
	mov	 ax,[bp+8]
   ;	
   ;	    mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	    xor si,si
   ;	
	xor	 si,si
   ;	
   ;	
   ;	    mov ax,word ptr ds:[si]
   ;	
	mov	 ax,word ptr ds:[si]
   ;	
   ;	    inc ax
   ;	
	inc	 ax
   ;	
   ;	    mov sx,ax
   ;	
	mov	 [bp-2],ax
   ;	
   ;	    mov ax,word ptr ds:[si+2]
   ;	
	mov	 ax,word ptr ds:[si+2]
   ;	
   ;	    inc ax
   ;	
	inc	 ax
   ;	
   ;	    mov sy,ax
   ;	
	mov	 [bp-4],ax
   ;	
   ;	    add si,4
   ;	
	add	 si,4
   ;	
   ;	    mov ax,0a000h
   ;	
	mov	 ax,0a000h
   ;	
   ;	    mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	    mov bx,sy
   ;	
	mov	 bx,[bp-4]
   ;	
   ;	    mov dx,03c4h
   ;	
	mov	 dx,03c4h
   ;	
   ;	    mov al,2
   ;	
	mov	 al,2
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
@28@870:
   ;	
   ;	}
   ;	olabel1:
   ;	asm {
   ;	    mov al,8
   ;	
	mov	 al,8
@28@898:
   ;	
   ;	}
   ;	olabel2:
   ;	asm {
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    mov di,m
   ;	
	mov	 di,[bp-6]
   ;	
   ;	    mov cx,sx
   ;	
	mov	 cx,[bp-2]
   ;	
   ;	    rep movsb
   ;	
	rep movsb	
   ;	
   ;	    shr al,1
   ;	
	shr	 al,1
   ;	
   ;	    jnz olabel2
   ;	
	jne	short @28@898
   ;	
   ;	    add m,80
   ;	
	add	 [bp-6],80
   ;	
   ;	    dec bx
   ;	
	dec	 bx
   ;	
   ;	    jnz olabel1
   ;	
	jne	short @28@870
   ;	
   ;	    dec dx
   ;	
	dec	 dx
   ;	
   ;	    mov al,2
   ;	
	mov	 al,2
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    inc dx
   ;	
	inc	 dx
   ;	
   ;	    mov al,15
   ;	
	mov	 al,15
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	    popa
   ;	
	popa	
   ;	
   ;	    pop ds
   ;	
	pop	 ds
   ;	
   ;	    pop es
   ;	
	pop	 es
   ;	
   ;	    cli
   ;	
	cli	
   ;	
   ;	}
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_putimage1	endp
   ;	
   ;	void fastbar1(int x, int y, int x2, int y2)
   ;	
	assume	cs:MGRP
_fastbar1	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;	
   ;	{
   ;	char color = COLOR;
   ;	
	mov	al,byte ptr MGRP:_COLOR
	mov	byte ptr [bp-1],al
   ;	
   ;	x--; x2--;
   ;	
	dec	word ptr [bp+4]
	dec	word ptr [bp+8]
   ;	
   ;	asm {
   ;	  push ax
   ;	
	push	 ax
   ;	
   ;	  push bx
   ;	
	push	 bx
   ;	
   ;	  push cx
   ;	
	push	 cx
   ;	
   ;	  push dx
   ;	
	push	 dx
   ;	
   ;	  push si
   ;	
	push	 si
   ;	
   ;	  push di
   ;	
	push	 di
   ;	
   ;	  push es
   ;	
	push	 es
   ;	
   ;	
   ;	  mov dx,0x3ce
   ;	
	mov	 dx,03ceH
   ;	
   ;	  mov ax,517
   ;	
	mov	 ax,517
   ;	
   ;	  out dx,ax
   ;	
	out	 dx,ax
   ;	
   ;	  mov ax,0xa000
   ;	
	mov	 ax,0a000H
   ;	
   ;	  mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	  mov si,y
   ;	
	mov	 si,[bp+6]
   ;	
   ;	  mov cx,y2
   ;	
	mov	 cx,[bp+10]
   ;	
   ;	  dec si
   ;	
	dec	 si
   ;	
   ;	  mov ah,128
   ;	
	mov	 ah,128
@29@506:
   ;	
   ;	}
   ;	boucle3:
   ;	asm {
   ;	
   ;	 mov al,0
   ;	
	mov	 al,0
   ;	
   ;	 mov dx,0x3ce
   ;	
	mov	 dx,03ceH
   ;	
   ;	 out dx,ax
   ;	
	out	 dx,ax
   ;	
   ;	 shr ah,1
   ;	
	shr	 ah,1
   ;	
   ;	 mov si,y
   ;	
	mov	 si,[bp+6]
   ;	
   ;	 dec si
   ;	
	dec	 si
@29@674:
   ;	
   ;	}
   ;	boucle2:
   ;	asm {
   ;	  inc si
   ;	
	inc	 si
   ;	
   ;	
   ;	  mov bx,si
   ;	
	mov	 bx,si
   ;	
   ;	  shl bx,4
   ;	
	shl	 bx,4
   ;	
   ;	  mov di,bx
   ;	
	mov	 di,bx
   ;	
   ;	  shl bx,2
   ;	
	shl	 bx,2
   ;	
   ;	  add di,bx
   ;	
	add	 di,bx
   ;	
   ;	  mov dx,di
   ;	
	mov	 dx,di
   ;	
   ;	
   ;	  mov bx,x2
   ;	
	mov	 bx,[bp+8]
   ;	
   ;	  shr bx,3
   ;	
	shr	 bx,3
   ;	
   ;	  add dx,bx
   ;	
	add	 dx,bx
   ;	
   ;	  mov bx,x
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	  shr bx,3
   ;	
	shr	 bx,3
   ;	
   ;	  add di,bx
   ;	
	add	 di,bx
   ;	
   ;	  inc dx
   ;	
	inc	 dx
   ;	
   ;	  inc di
   ;	
	inc	 di
@29@1094:
   ;	
   ;	//  dec di
   ;	}
   ;	boucle1:
   ;	asm {
   ;	  mov al,es:[di]
   ;	
	mov	 al,es:[di]
   ;	
   ;	  mov al,color
   ;	
	mov	 al,[bp-1]
   ;	
   ;	  mov es:[di],al
   ;	
	mov	 es:[di],al
   ;	
   ;	  inc di
   ;	
	inc	 di
   ;	
   ;	  cmp di,dx
   ;	
	cmp	 di,dx
   ;	
   ;	  jnge boucle1
   ;	
	jl	short @29@1094
   ;	
   ;	
   ;	  cmp si,cx
   ;	
	cmp	 si,cx
   ;	
   ;	  jnge boucle2
   ;	
	jl	short @29@674
   ;	
   ;	
   ;	  cmp ah,0
   ;	
	cmp	 ah,0
   ;	
   ;	  jne boucle3
   ;	
	jne	short @29@506
   ;	
   ;	
   ;	       mov   dx,3ceh
   ;	
	mov	   dx,3ceh
   ;	
   ;	       mov   ax,(0FFh shl 8 ) + 8
   ;	
	mov	   ax,(0FFh shl 8 ) + 8
   ;	
   ;	       out   dx,ax
   ;	
	out	   dx,ax
   ;	
   ;	
   ;	       mov   ax,(00h shl 8) + 5
   ;	
	mov	   ax,(00h shl 8) + 5
   ;	
   ;	       out   dx,ax
   ;	
	out	   dx,ax
   ;	
   ;	
   ;	
   ;	  pop es
   ;	
	pop	 es
   ;	
   ;	  pop di
   ;	
	pop	 di
   ;	
   ;	  pop si
   ;	
	pop	 si
   ;	
   ;	  pop dx
   ;	
	pop	 dx
   ;	
   ;	  pop cx
   ;	
	pop	 cx
   ;	
   ;	  pop bx
   ;	
	pop	 bx
   ;	
   ;	  pop ax
   ;	
	pop	 ax
   ;	
   ;	}
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_fastbar1	endp
   ;	
   ;	void fastbar(int x, int y, int x2, int y2)
   ;	
	assume	cs:MGRP
_fastbar	proc	near
	push	bp
	mov	bp,sp
	mov	ax,word ptr [bp+4]
	mov	dx,word ptr [bp+6]
	mov	bx,word ptr [bp+8]
	mov	cx,word ptr [bp+10]
   ;	
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @30@86
   ;	
   ;	  fastbar1 (x,y,x2,y2);
   ;	
	push	cx
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_fastbar1
	jmp	short @30@114
@30@86:
   ;	
   ;	 else
   ;	  fastbar2 (x,y,x2,y2);
   ;	
	push	cx
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_fastbar2
@30@114:
	add	sp,8
   ;	
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fastbar	endp
   ;	
   ;	void SwapInt( int *i1, int *i2 )
   ;	
	assume	cs:MGRP
_SwapInt	proc	near
	enter	2,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 int dummy;
   ;	
   ;	 dummy = *i2;
   ;	
	mov	ax,word ptr [di]
	mov	word ptr [bp-2],ax
   ;	
   ;	 *i2   = *i1;
   ;	
	mov	ax,word ptr [si]
	mov	word ptr [di],ax
   ;	
   ;	 *i1   = dummy;
   ;	
	mov	ax,word ptr [bp-2]
	mov	word ptr [si],ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_SwapInt	endp
   ;	
   ;	void Line( int x1, int y1, int x2, int y2)
   ;	
	assume	cs:MGRP
_Line	proc	near
	enter	12,0
	push	si
	push	di
   ;	
   ;	{
   ;	 int d, dx, dy,
   ;	     aincr, bincr,
   ;	     xincr, yincr,
   ;	     x, y;
   ;	
   ;	 if ( abs(x2-x1) < abs(y2-y1) )            /* Parcours : axe X ou Y ? */
   ;	
	mov	ax,word ptr [bp+8]
	sub	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	push	ax
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	pop	dx
	cmp	dx,ax
	jl short	@@4
	jmp	@32@422
@@4:
   ;	
   ;	  {                                                          /* Par Y */
   ;	   if ( y1 > y2 )                            /* y1 plus grand que y2? */
   ;	
	mov	ax,word ptr [bp+6]
	cmp	ax,word ptr [bp+10]
	jle	short @32@114
   ;	
   ;	    {
   ;	     SwapInt( &x1, &x2 );                    /* Oui ‚change X1 et X2, */
   ;	
	lea	ax,word ptr [bp+8]
	push	ax
	lea	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
   ;	
   ;	     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
   ;	
	lea	ax,word ptr [bp+10]
	push	ax
	lea	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
@32@114:
   ;	
   ;	    }
   ;	
   ;	   xincr = ( x2 > x1 ) ?  1 : -1;           /* Fixe le pas horizontal */
   ;	
	mov	ax,word ptr [bp+8]
	cmp	ax,word ptr [bp+4]
	jle	short @32@170
	mov	ax,1
	jmp	short @32@198
@32@170:
	mov	ax,-1
@32@198:
	mov	word ptr [bp-8],ax
   ;	
   ;	
   ;	   dy = y2 - y1;
   ;	
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	mov	word ptr [bp-2],ax
   ;	
   ;	   dx = abs( x2-x1 );
   ;	
	mov	ax,word ptr [bp+8]
	sub	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	mov	di,ax
   ;	
   ;	   d  = 2 * dx - dy;
   ;	
	mov	si,di
	shl	si,1
	sub	si,word ptr [bp-2]
   ;	
   ;	   aincr = 2 * (dx - dy);
   ;	
	sub	ax,word ptr [bp-2]
	shl	ax,1
	mov	word ptr [bp-4],ax
   ;	
   ;	   bincr = 2 * dx;
   ;	
	mov	ax,di
	shl	ax,1
	mov	word ptr [bp-6],ax
   ;	
   ;	   x = x1;
   ;	
	mov	di,word ptr [bp+4]
   ;	
   ;	   y = y1;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr [bp-12],ax
   ;	
   ;	
   ;	   setpix( x, y, COLOR );               /* dessine le premier pixel */
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	   for (y=y1+1; y<= y2; ++y )                 /* Parcourt l'axe des Y */
   ;	
	mov	ax,word ptr [bp+6]
	inc	ax
	mov	word ptr [bp-12],ax
	jmp	short @32@366
@32@226:
   ;	
   ;	    {
   ;	     if ( d >= 0 )
   ;	
	or	si,si
	jl	short @32@282
   ;	
   ;	      {
   ;	       x += xincr;
   ;	
	add	di,word ptr [bp-8]
   ;	
   ;	       d += aincr;
   ;	
	add	si,word ptr [bp-4]
   ;	
   ;	      }
   ;	
	jmp	short @32@310
@32@282:
   ;	
   ;	     else
   ;	      d += bincr;
   ;	
	add	si,word ptr [bp-6]
@32@310:
   ;	
   ;	     setpix( x, y, COLOR );
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr [bp-12]
@32@366:
	mov	ax,word ptr [bp-12]
	cmp	ax,word ptr [bp+10]
	jle	short @32@226
   ;	
   ;	    }
   ;	  }
   ;	
	jmp	@32@758
@32@422:
   ;	
   ;	 else                                                        /* par X */
   ;	  {
   ;	   if ( x1 > x2 )                            /* x1 plus grand que x2? */
   ;	
	mov	ax,word ptr [bp+4]
	cmp	ax,word ptr [bp+8]
	jle	short @32@478
   ;	
   ;	    {
   ;	     SwapInt( &x1, &x2 );                     /* Oui, ‚change X1 et X2*/
   ;	
	lea	ax,word ptr [bp+8]
	push	ax
	lea	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
   ;	
   ;	     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
   ;	
	lea	ax,word ptr [bp+10]
	push	ax
	lea	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
@32@478:
   ;	
   ;	    }
   ;	
   ;	   yincr = ( y2 > y1 ) ? 1 : -1;              /* Fixe le pas vertical */
   ;	
	mov	ax,word ptr [bp+10]
	cmp	ax,word ptr [bp+6]
	jle	short @32@534
	mov	ax,1
	jmp	short @32@562
@32@534:
	mov	ax,-1
@32@562:
	mov	word ptr [bp-10],ax
   ;	
   ;	
   ;	   dx = x2 - x1;
   ;	
	mov	di,word ptr [bp+8]
	sub	di,word ptr [bp+4]
   ;	
   ;	   dy = abs( y2-y1 );
   ;	
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;	   d  = 2 * dy - dx;
   ;	
	mov	si,word ptr [bp-2]
	shl	si,1
	sub	si,di
   ;	
   ;	   aincr = 2 * (dy - dx);
   ;	
	sub	ax,di
	shl	ax,1
	mov	word ptr [bp-4],ax
   ;	
   ;	   bincr = 2 * dy;
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,1
	mov	word ptr [bp-6],ax
   ;	
   ;	   x = x1;
   ;	
	mov	di,word ptr [bp+4]
   ;	
   ;	   y = y1;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr [bp-12],ax
   ;	
   ;	
   ;	/*   SetPixel*/
   ;	   setpix( x, y, COLOR );               /* Dessine le premier pixel */
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	   for (x=x1+1; x<=x2; ++x )                  /* Parcourt l'axe des X */
   ;	
	mov	di,word ptr [bp+4]
	inc	di
	jmp	short @32@730
@32@590:
   ;	
   ;	    {
   ;	     if ( d >= 0 )
   ;	
	or	si,si
	jl	short @32@646
   ;	
   ;	      {
   ;	       y += yincr;
   ;	
	mov	ax,word ptr [bp-10]
	add	word ptr [bp-12],ax
   ;	
   ;	       d += aincr;
   ;	
	add	si,word ptr [bp-4]
   ;	
   ;	      }
   ;	
	jmp	short @32@674
@32@646:
   ;	
   ;	     else
   ;	      d += bincr;
   ;	
	add	si,word ptr [bp-6]
@32@674:
   ;	
   ;	     setpix( x, y, COLOR );
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	di
@32@730:
	cmp	di,word ptr [bp+8]
	jle	short @32@590
@32@758:
   ;	
   ;	    }
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_Line	endp
   ;	
   ;	void Bar (int x, int y, int w, int h)
   ;	
	assume	cs:MGRP
_Bar	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	dx,word ptr [bp+4]
	mov	bx,word ptr [bp+6]
	mov	cx,word ptr [bp+8]
	mov	si,word ptr [bp+10]
   ;	
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @33@86
   ;	
   ;	  barasm1 (x,y,w,h,COLOR);
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_barasm1
	jmp	short @33@114
@33@86:
   ;	
   ;	 else
   ;	  barasm2 (x,y,w,h,COLOR);
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_barasm2
@33@114:
	add	sp,10
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_Bar	endp
   ;	
   ;	void SetColor (int color)
   ;	
	assume	cs:MGRP
_SetColor	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 COLOR = color;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr MGRP:_COLOR,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_SetColor	endp
   ;	
   ;	void Rectangle (int x, int y, int x2, int y2)
   ;	
	assume	cs:MGRP
_Rectangle	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 Line (x,y,x2,y);
   ;	
	push	di
	push	word ptr [bp+8]
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x,y,x,y2);
   ;	
	push	word ptr [bp+10]
	push	si
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x2,y,x2,y2);
   ;	
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	di
	push	word ptr [bp+8]
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x,y2,x2,y2);
   ;	
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+10]
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_Rectangle	endp
   ;	
   ;	void XORRectangle (unsigned int x, unsigned int y, unsigned int x2,
   ;	
	assume	cs:MGRP
_XORRectangle	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;			   unsigned int y2)
   ;	{
   ;	 unsigned int i;
   ;	 for (i=x;i<=x2;i++)
   ;	
	mov	si,di
	jmp	short @36@114
@36@58:
   ;	
   ;	  {
   ;	  setpix (i,y,getpix (i,y) ^ 1);
   ;	
	push	word ptr [bp+6]
	push	si
	call	near ptr MGRP:_getpix
	add	sp,4
	xor	al,1
	push	ax
	push	word ptr [bp+6]
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	  setpix (i,y2,getpix (i,y2) ^ 1);
   ;	
	push	word ptr [bp+10]
	push	si
	call	near ptr MGRP:_getpix
	add	sp,4
	xor	al,1
	push	ax
	push	word ptr [bp+10]
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	si
@36@114:
	cmp	si,word ptr [bp+8]
	jbe	short @36@58
   ;	
   ;	  }
   ;	 for (i=y;i<=y2;i++)
   ;	
	mov	si,word ptr [bp+6]
	jmp	short @36@226
@36@170:
   ;	
   ;	 {
   ;	  setpix (x,i,getpix (x,i) ^ 1);
   ;	
	push	si
	push	di
	call	near ptr MGRP:_getpix
	add	sp,4
	xor	al,1
	push	ax
	push	si
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	  setpix (x2,i,getpix (x2,i) ^ 1);
   ;	
	push	si
	push	word ptr [bp+8]
	call	near ptr MGRP:_getpix
	add	sp,4
	xor	al,1
	push	ax
	push	si
	push	word ptr [bp+8]
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	si
@36@226:
	cmp	si,word ptr [bp+10]
	jbe	short @36@170
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_XORRectangle	endp
   ;	
   ;	void OutTextXY (int X, int Y,char* s)
   ;	
	assume	cs:MGRP
_OutTextXY	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+8]
   ;	
   ;	{
   ;	 register int i;
   ;	 for (i=0; s[i] != 0; i++) PrintChar (s[i],X+(i<<3) ,Y,COLOR,255,0);
   ;	
	xor	si,si
	jmp	short @37@114
@37@58:
	push	0
	push	255
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp+6]
	mov	ax,si
	shl	ax,3
	mov	dx,word ptr [bp+4]
	add	dx,ax
	push	dx
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	inc	si
@37@114:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @37@58
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_OutTextXY	endp
   ;	
   ;	void FarOutTextXY (int X, int Y,char far* s)
   ;	
	assume	cs:MGRP
_FarOutTextXY	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	 int i;
   ;	 for (i=0; s[i] != 0; i++) PrintChar (s[i],X+(i<<3) ,Y,COLOR,255,0);
   ;	
	xor	si,si
	jmp	short @38@114
@38@58:
	push	0
	push	255
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp+6]
	mov	ax,si
	shl	ax,3
	mov	dx,word ptr [bp+4]
	add	dx,ax
	push	dx
	les	bx,dword ptr [bp+8]
	add	bx,si
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	inc	si
@38@114:
	les	bx,dword ptr [bp+8]
	add	bx,si
	cmp	byte ptr es:[bx],0
	jne	short @38@58
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_FarOutTextXY	endp
BGWindow	label	byte
	db	7
   ;	
   ;	void Window1 (int X, int Y, int w, int h,int Color, char* title)
   ;	
	assume	cs:MGRP
_Window1	proc	near
	enter	2,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	unsigned int u;
   ;	/*
   ;	 SetColor (Color);
   ;	 Bar (X,Y,X+Long,Y+Larg);
   ;	 SetColor (0);
   ;	 Rectangle (X-2,Y-2,X+Long+2,Y+Larg+2);
   ;	 Line (X+Long+1,Y-1,X+Long+1,Y+Larg+1);
   ;	 Line (X-1,Y+Larg+1,X+Long+1,Y+Larg+1);
   ;	 SetColor (15);
   ;	 Line (X-1,Y-1,X+Long+1,Y-1);
   ;	 Line (X-1,Y-1,X-1,Y+Larg+1);
   ;	 SetColor (0);
   ;	 Rectangle (X+3,Y+18,X+Long-3,Y+Larg-3);
   ;	 SetColor (15);
   ;	 Line (X+Long-2,Y+18,X+Long-2,Y+Larg-2);
   ;	 Line (X+3,Y+Larg-2,X+Long-2,Y+Larg-2);
   ;	 Line (X+3,Y+3,X+Long-3,Y+3);
   ;	 Line (X+3,Y+5,X+Long-3,Y+5);
   ;	 Line (X+3,Y+7,X+Long-3,Y+7);
   ;	 Line (X+3,Y+9,X+Long-3,Y+9);
   ;	 Line (X+3,Y+11,X+Long-3,Y+11);
   ;	 Line (X+3,Y+13,X+Long-3,Y+13);
   ;	 Line (X+4,Y+19,X+4,Y+Larg-4);
   ;	 Line (X+4,Y+19,X+Long-4,Y+19);
   ;	 SetColor (8);
   ;	 Line (X+3,Y+4,X+Long-3,Y+4);
   ;	 Line (X+3,Y+6,X+Long-3,Y+6);
   ;	 Line (X+3,Y+8,X+Long-3,Y+8);
   ;	 Line (X+3,Y+10,X+Long-3,Y+10);
   ;	 Line (X+3,Y+12,X+Long-3,Y+12);
   ;	 Line (X+3,Y+14,X+Long-3,Y+14);
   ;	 SetColor (Color);
   ;	 Bar ( X+(Long>>1) - (strlen (title)<<2)-6 ,Y+3,
   ;	       X+(Long>>1) + (strlen (title)<<2)+6 ,Y+14);
   ;	 SetColor (9);
   ;	 OutTextXY (X+(Long>>1) - (strlen (title)<<2)+1,Y+3,title);
   ;	 SetColor (8);
   ;	 OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+2,title);
   ;	*/
   ;	 w--;
   ;	
	dec	word ptr [bp+8]
   ;	
   ;	 w--;
   ;	
	dec	word ptr [bp+8]
   ;	
   ;	 SetColor (BGWindow);
   ;	
	mov	al,byte ptr MGRP:BGWindow
	mov	ah,0
	push	ax
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 BGWindow = 7;
   ;	
	mov	byte ptr MGRP:BGWindow,7
   ;	
   ;	 fastbar (X,Y,X+w,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_fastbar
	add	sp,8
   ;	
   ;	 SetColor (Color);
   ;	
	push	word ptr [bp+12]
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle (X+1,Y+15,X+w,Y+h-1);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Rectangle (X+2,Y+15,X+w-1,Y+h-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,2
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Bar (X,Y,X+w,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X,Y,X+w,Y);
   ;	
	push	di
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X,Y,X,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	push	si
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+15,Y,X+15,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,15
	push	ax
	push	di
	mov	ax,si
	add	ax,15
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3,Y+h-3,X+w-3,Y+h-3);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	
   ;	 Line (X+w-2,Y+15,X+w-2,Y+h-3);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+14,Y+1,X+14,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,14
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	add	ax,14
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+1,Y+15,X+w-2,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3,Y+15,X+3,Y+h-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+1,Y+h,X+w,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	
   ;	/*
   ;	 SetColor (8);
   ;	 Line (X+11,Y+5,X+11,Y+11);
   ;	 Line (X+5,Y+11,X+11,Y+11);
   ;	 SetColor (7);
   ;	 Line (X+4,Y+4,X+10,Y+4);
   ;	 Line (X+4,Y+4,X+4,Y+10);
   ;	*/
   ;	
   ;	// SetColor (15);
   ;	// Rectangle (X+4,Y+4,X+12,Y+12);
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	// Rectangle (X+3,Y+3,X+11,Y+11);
   ;	
   ;	 for (u = 0; u <= 6; u++)
   ;	
	mov	word ptr [bp-2],0
	jmp	short @39@114
@39@58:
   ;	
   ;	 {
   ;	  setpix (X+4+u-1+1,Y+5+u,15);
   ;	
	push	15
	mov	ax,di
	add	ax,5
	add	ax,word ptr [bp-2]
	push	ax
	mov	ax,si
	add	ax,4
	add	ax,word ptr [bp-2]
	dec	ax
	inc	ax
	push	ax
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	  setpix (X+10-u+1,Y+5+u,0);
   ;	
	push	0
	mov	ax,di
	add	ax,5
	add	ax,word ptr [bp-2]
	push	ax
	mov	ax,si
	add	ax,10
	sub	ax,word ptr [bp-2]
	inc	ax
	push	ax
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	  setpix (X+4+u+1,Y+5+u,0);
   ;	
	push	0
	mov	ax,di
	add	ax,5
	add	ax,word ptr [bp-2]
	push	ax
	mov	ax,si
	add	ax,4
	add	ax,word ptr [bp-2]
	inc	ax
	push	ax
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	  setpix (X+10-u-1+1,Y+5+u,15);
   ;	
	push	15
	mov	ax,di
	add	ax,5
	add	ax,word ptr [bp-2]
	push	ax
	mov	ax,si
	add	ax,10
	sub	ax,word ptr [bp-2]
	dec	ax
	inc	ax
	push	ax
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr [bp-2]
@39@114:
	cmp	word ptr [bp-2],6
	jbe	short @39@58
   ;	
   ;	 }
   ;	
   ;	
   ;	 Line (X+w+1,Y,X+w+1,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	push	di
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 if (isFont) setFont (2);
   ;	
	cmp	word ptr MGRP:_isFont,0
	je	short @39@198
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
@39@198:
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 OutTextXY (X+20,Y+1,title);
   ;	
	push	word ptr [bp+14]
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	add	ax,20
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_Window1	endp
   ;	
   ;	void Window2 (int X, int Y, int Long, int Larg,int Color, char* title)
   ;	
	assume	cs:MGRP
_Window2	proc	near
	enter	2,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	unsigned int u;
   ;	unsigned int lshift = 12;
   ;	
	mov	word ptr [bp-2],12
   ;	
   ;	
   ;	 X = X + 2;
   ;	
	add	si,2
   ;	
   ;	 Y = Y + 2;
   ;	
	add	di,2
   ;	
   ;	 Long = Long - 5;
   ;	
	mov	ax,word ptr [bp+8]
	add	ax,-5
	mov	word ptr [bp+8],ax
   ;	
   ;	 Larg = Larg - 4;
   ;	
	mov	ax,word ptr [bp+10]
	add	ax,-4
	mov	word ptr [bp+10],ax
   ;	
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (X,Y,X+Long,Y+Larg);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle (X-2,Y-2,X+Long+2,Y+Larg+2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,2
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,2
	push	ax
	mov	ax,di
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,-2
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Line (X+Long+1,Y-1,X+Long+1,Y+Larg+1);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	inc	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	mov	ax,di
	dec	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X-1,Y+Larg+1,X+Long+1,Y+Larg+1);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	inc	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	inc	ax
	push	ax
	mov	ax,si
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X-1,Y-1,X+Long+1,Y-1);
   ;	
	mov	ax,di
	dec	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	mov	ax,di
	dec	ax
	push	ax
	mov	ax,si
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X-1,Y-1,X-1,Y+Larg+1);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	inc	ax
	push	ax
	mov	ax,si
	dec	ax
	push	ax
	mov	ax,di
	dec	ax
	push	ax
	mov	ax,si
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle (X+3,Y+18,X+Long-3,Y+Larg-3);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,18
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+Long-2,Y+18,X+Long-2,Y+Larg-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,18
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3,Y+Larg-2,X+Long-2,Y+Larg-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 
   ;	 Line (X+3+lshift,Y+3,X+Long-3,Y+3);
   ;	
	mov	ax,di
	add	ax,3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,3
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+5,X+Long-3,Y+5);
   ;	
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+7,X+Long-3,Y+7);
   ;	
	mov	ax,di
	add	ax,7
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,7
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+9,X+Long-3,Y+9);
   ;	
	mov	ax,di
	add	ax,9
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,9
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+11,X+Long-3,Y+11);
   ;	
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+13,X+Long-3,Y+13);
   ;	
	mov	ax,di
	add	ax,13
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,13
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 
   ;	 Line (X+4,Y+19,X+4,Y+Larg-4);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-4
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	mov	ax,di
	add	ax,19
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+4,Y+19,X+Long-4,Y+19);
   ;	
	mov	ax,di
	add	ax,19
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-4
	push	ax
	mov	ax,di
	add	ax,19
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 
   ;	 if (BGWindow != 7)
   ;	
	cmp	byte ptr MGRP:BGWindow,7
	je	short @40@86
   ;	
   ;	 {
   ;	       SetColor (BGWindow);
   ;	
	mov	al,byte ptr MGRP:BGWindow
	mov	ah,0
	push	ax
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	       Bar (X+5,Y+19+1,X+Long-5,Y+Larg-5);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-5
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-5
	push	ax
	mov	ax,di
	add	ax,20
	push	ax
	mov	ax,si
	add	ax,5
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
@40@86:
   ;	
   ;	 }
   ;	
   ;	 
   ;	 SetColor (8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+3+lshift,Y+4,X+Long-3,Y+4);
   ;	
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+6,X+Long-3,Y+6);
   ;	
	mov	ax,di
	add	ax,6
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,6
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+8,X+Long-3,Y+8);
   ;	
	mov	ax,di
	add	ax,8
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,8
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+10,X+Long-3,Y+10);
   ;	
	mov	ax,di
	add	ax,10
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,10
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+12,X+Long-3,Y+12);
   ;	
	mov	ax,di
	add	ax,12
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,12
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3+lshift,Y+14,X+Long-3,Y+14);
   ;	
	mov	ax,di
	add	ax,14
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,14
	push	ax
	mov	ax,si
	add	ax,3
	add	ax,word ptr [bp-2]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar ( X+(Long>>1) - (strlen (title)<<2)-6 ,Y+3,
   ;	
   ;	
   ;	       X+(Long>>1) + (strlen (title)<<2)+6 ,Y+14);
   ;	
	mov	ax,di
	add	ax,14
	push	ax
	push	word ptr [bp+14]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,2
	mov	dx,word ptr [bp+8]
	sar	dx,1
	mov	bx,si
	add	bx,dx
	add	bx,ax
	add	bx,6
	push	bx
	mov	ax,di
	add	ax,3
	push	ax
	push	word ptr [bp+14]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,2
	mov	dx,word ptr [bp+8]
	sar	dx,1
	mov	bx,si
	add	bx,dx
	sub	bx,ax
	add	bx,-6
	push	bx
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 if (isFont) setFont (1);
   ;	
	cmp	word ptr MGRP:_isFont,0
	je	short @40@142
	push	1
	call	near ptr MGRP:_setFont
	pop	cx
@40@142:
   ;	
   ;	 OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+1,title);
   ;	
	push	word ptr [bp+14]
	mov	ax,di
	inc	ax
	push	ax
	push	word ptr [bp+14]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,2
	mov	dx,word ptr [bp+8]
	sar	dx,1
	mov	bx,si
	add	bx,dx
	sub	bx,ax
	push	bx
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 //SetColor (8);
   ;	 //OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+2,title);
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+11,Y+5,X+11,Y+11);
   ;	
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+5,Y+11,X+11,Y+11);
   ;	
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,5
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+4,Y+4,X+10,Y+4);
   ;	
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,10
	push	ax
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+4,Y+4,X+4,Y+10);
   ;	
	mov	ax,di
	add	ax,10
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	/*
   ;	 Line (X+w+1,Y,X+w+1,Y+h);
   ;	 if (isFont) setFont (2);
   ;	 SetColor (15);
   ;	 OutTextXY (X+20,Y+1,title);
   ;	*/ 
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 BGWindow = 7;
   ;	
	mov	byte ptr MGRP:BGWindow,7
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_Window2	endp
   ;	
   ;	void Window (int X, int Y, int w, int h,int Color, char* title)
   ;	
	assume	cs:MGRP
_Window	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	     Window2(X, Y, w, h, Color, title);
   ;	
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr MGRP:_Window2
	add	sp,12
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_Window	endp
   ;	
   ;	void Button (int Xbut, int Ybut, int Xbut2, int Ybut2,char* caption)
   ;	
	assume	cs:MGRP
_Button	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	/*
   ;	SetColor(0);
   ;	Rectangle(Xbut,Ybut,Xbut2,Ybut2);
   ;	*/
   ;	SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	Line (Xbut+1,Ybut,Xbut2-1,Ybut);
   ;	
	push	di
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	push	di
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line (Xbut+1,Ybut2,Xbut2-1,Ybut2);
   ;	
	push	word ptr [bp+10]
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	push	word ptr [bp+10]
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line (Xbut,Ybut+1,Xbut,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	push	si
	mov	ax,di
	inc	ax
	push	ax
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line (Xbut2,Ybut+1,Xbut2,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	push	word ptr [bp+8]
	mov	ax,di
	inc	ax
	push	ax
	push	word ptr [bp+8]
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	// SetColor (7);
   ;	// Bar(Xbut+1,Ybut+1,Xbut2-1,Ybut2-1);
   ;	
   ;	SetColor(15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	Line(Xbut+1,Ybut+1,Xbut2-1,Ybut+1);
   ;	
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line(Xbut+1,Ybut+1,Xbut+1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	SetColor(8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	Line(Xbut+1,Ybut2-1,Xbut2-1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line(Xbut2-1,Ybut+1,Xbut2-1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	setFont (2);
   ;	
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	OutTextXY(Xbut+2+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-6,caption);
   ;	
	push	word ptr [bp+12]
	mov	ax,di
	add	ax,word ptr [bp+10]
	sar	ax,1
	add	ax,-6
	push	ax
	push	word ptr [bp+12]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	mov	dx,word ptr [bp+8]
	sub	dx,si
	sub	dx,ax
	sar	dx,1
	mov	ax,si
	add	ax,dx
	add	ax,2
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	SetColor(0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	OutTextXY(Xbut+1+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-7,caption);
   ;	
	push	word ptr [bp+12]
	mov	ax,di
	add	ax,word ptr [bp+10]
	sar	ax,1
	add	ax,-7
	push	ax
	push	word ptr [bp+12]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	mov	dx,word ptr [bp+8]
	sub	dx,si
	sub	dx,ax
	sar	dx,1
	mov	ax,si
	add	ax,dx
	inc	ax
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_Button	endp
   ;	
   ;	void pButton (int Xbut, int Ybut, int Xbut2, int Ybut2,char* caption)
   ;	
	assume	cs:MGRP
_pButton	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	/*
   ;	SetColor(0);
   ;	Rectangle(Xbut,Ybut,Xbut2,Ybut2);
   ;	*/
   ;	
   ;	// SetColor (7);
   ;	// Bar(Xbut+1,Ybut+1,Xbut2-1,Ybut2-1);
   ;	SetColor(8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	Line(Xbut+1,Ybut+1,Xbut2-1,Ybut+1);
   ;	
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line(Xbut+1,Ybut+1,Xbut+1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	SetColor(15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	Line(Xbut+1,Ybut2-1,Xbut2-1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	Line(Xbut2-1,Ybut+1,Xbut2-1,Ybut2-1);
   ;	
	mov	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,word ptr [bp+8]
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	
   ;	setFont (2);
   ;	
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	// OutTextXY(Xbut+1+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-7,caption);
   ;	SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	OutTextXY(Xbut+2+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-6,caption);
   ;	
	push	word ptr [bp+12]
	mov	ax,di
	add	ax,word ptr [bp+10]
	sar	ax,1
	add	ax,-6
	push	ax
	push	word ptr [bp+12]
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	mov	dx,word ptr [bp+8]
	sub	dx,si
	sub	dx,ax
	sar	dx,1
	mov	ax,si
	add	ax,dx
	add	ax,2
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_pButton	endp
   ;	
   ;	void Background (char color)
   ;	
	assume	cs:MGRP
_Background	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 SetColor (color);
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	push	ax
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 if (gmode ==1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @44@86
   ;	
   ;	 Bar (0,0,639,479);
   ;	
	push	large 001DF027Fh
	jmp	short @44@114
@44@86:
   ;	
   ;	 else
   ;	 Bar (0,0,799,599);
   ;	
	push	large 00257031Fh
@44@114:
	push	large 0
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 SetVideo (ON);
   ;	
	push	0
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 backc = color;
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	mov	word ptr MGRP:_backc,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_Background	endp
   ;	
   ;	void getimage(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_getimage	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	ax,word ptr [bp+4]
	mov	dx,word ptr [bp+6]
	mov	bx,word ptr [bp+8]
	mov	cx,word ptr [bp+10]
	mov	si,word ptr [bp+12]
   ;	
   ;			unsigned int x0, unsigned int y0,
   ;			unsigned int adr)
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @45@86
   ;	
   ;	  getimage1 (x,y,x0,y0,adr);
   ;	
	push	si
	push	cx
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_getimage1
	jmp	short @45@114
@45@86:
   ;	
   ;	 else 
   ;	  getimage2 (x,y,x0,y0,adr);
   ;	
	push	si
	push	cx
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_getimage2
@45@114:
	add	sp,10
   ;	
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_getimage	endp
   ;	
   ;	void putimage(unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_putimage	proc	near
	push	bp
	mov	bp,sp
	mov	ax,word ptr [bp+4]
	mov	dx,word ptr [bp+6]
	mov	bx,word ptr [bp+8]
   ;	
   ;		      unsigned int adr)
   ;	{
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @46@86
   ;	
   ;	  putimage1 (x,y,adr);
   ;	
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_putimage1
	jmp	short @46@114
@46@86:
   ;	
   ;	 else 
   ;	  putimage2 (x,y,adr);
   ;	
	push	bx
	push	dx
	push	ax
	call	near ptr MGRP:_putimage2
@46@114:
	add	sp,6
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_putimage	endp
   ;	
   ;	void shut (void)
   ;	
	assume	cs:MGRP
_shut	proc	near
	push	si
	push	di
   ;	
   ;	{
   ;	 int i,j;
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @47@282
   ;	
   ;	 for (i=0;i<=480;i += 2)
   ;	
	xor	si,si
	jmp	short @47@226
@47@86:
   ;	
   ;	  for (j=0;j<=640;j += 2)
   ;	
	xor	di,di
	jmp	short @47@170
@47@114:
   ;	
   ;	   setpix (j,i,0);
   ;	
	push	0
	push	si
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	add	di,2
@47@170:
	cmp	di,640
	jle	short @47@114
	add	si,2
@47@226:
	cmp	si,480
	jle	short @47@86
	jmp	short @47@478
@47@282:
   ;	
   ;	 else
   ;	 for (i=0;i<=600;i += 2)
   ;	
	xor	si,si
	jmp	short @47@450
@47@310:
   ;	
   ;	  for (j=0;j<=800;j += 2)
   ;	
	xor	di,di
	jmp	short @47@394
@47@338:
   ;	
   ;	   setpix (j,i,0);
   ;	
	push	0
	push	si
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	add	di,2
@47@394:
	cmp	di,800
	jle	short @47@338
	add	si,2
@47@450:
	cmp	si,600
	jle	short @47@310
@47@478:
   ;	
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	ret	
_shut	endp
	?debug	C E9E34B53570768696D656D2E68
   ;	
   ;	void himem_write (unsigned int segs,unsigned int ofss,
   ;	
	assume	cs:MGRP
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
	assume	cs:MGRP
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
   ;	        mov ebx,c
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
	?debug	C E9E34B5357087363726F6C6C2E68
   ;	
   ;	void scroll_up (int x, int y, int l, int h, char speed)
   ;	
	assume	cs:MGRP
_scroll_up	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	dx,word ptr [bp+4]
	mov	bx,word ptr [bp+6]
	mov	cx,word ptr [bp+8]
	mov	si,word ptr [bp+10]
   ;	
   ;	{
   ;	if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @50@86
   ;	
   ;	 scroll_up1 (x,y,l,h,speed);
   ;	
	mov	al,byte ptr [bp+12]
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_scroll_up1
	jmp	short @50@114
@50@86:
   ;	
   ;	else
   ;	 scroll_up2 (x,y,l,h,speed);
   ;	
	mov	al,byte ptr [bp+12]
	push	ax
	push	si
	push	cx
	push	bx
	push	dx
	call	near ptr MGRP:_scroll_up2
@50@114:
	add	sp,10
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_scroll_up	endp
	?debug	C E9E34B5357086D656D6F72792E68
   ;	
   ;	void memcpy (unsigned int segc,unsigned int ofsc,unsigned int segs,unsigned int ofss,unsigned int count)
   ;	
	assume	cs:MGRP
_memcpy	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
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
	?debug	C E91B5EB05806786D656D2E68
   ;	
   ;	unsigned int HiMemoryAvailable (void)
   ;	
	assume	cs:MGRP
_HiMemoryAvailable	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	  mov     al,17h
   ;	
	mov	     al,17h
   ;	
   ;	  out     70h,al      
   ;	
	out	     70h,al      
   ;	
   ;	  in      al,71h      
   ;	
	in	      al,71h      
   ;	
   ;	  mov     bl,al        
   ;	
	mov	     bl,al        
   ;	
   ;	  mov     al,18h       
   ;	
	mov	     al,18h       
   ;	
   ;	  out     70h,al       
   ;	
	out	     70h,al       
   ;	
   ;	  in      al,71h       
   ;	
	in	      al,71h       
   ;	
   ;	  mov     bh,al        
   ;	
	mov	     bh,al        
   ;	
   ;	  mov     ax,bx        
   ;	
	mov	     ax,bx        
   ;	
   ;	 }
   ;	}
   ;	
	ret	
_HiMemoryAvailable	endp
   ;	
   ;	unsigned int GetHiMemoryAvail (void)
   ;	
	assume	cs:MGRP
_GetHiMemoryAvail	proc	near
   ;	
   ;	{
   ;	 return (HiMemoryAvailable()-HiMemoryUsed+4);
   ;	
	call	near ptr MGRP:_HiMemoryAvailable
	sub	ax,word ptr MGRP:HiMemoryUsed
	add	ax,4
   ;	
   ;	}
   ;	
	ret	
_GetHiMemoryAvail	endp
   ;	
   ;	unsigned long HiMemoryAlloc (unsigned long size)
   ;	
	assume	cs:MGRP
_HiMemoryAlloc	proc	near
	enter	8,0
   ;	
   ;	{
   ;	 unsigned long dummy;
   ;	 unsigned long HiMemoryEnd;
   ;	
   ;	 dummy = HiMemoryStart;
   ;	
	mov	dword ptr [bp-4],large 000400000h
   ;	
   ;	 HiMemoryEnd = ((unsigned long)(HiMemoryAvailable ())) << 10 ;
   ;	
	call	near ptr MGRP:_HiMemoryAvailable
	movzx	eax,ax
	shl	eax,10
	mov	dword ptr [bp-8],eax
	jmp	@54@282
@54@58:
   ;	
   ;	
   ;	 while ( dummy < HiMemoryEnd )
   ;	 {
   ;	  himem_read (dummy,_CS,(unsigned int)&Xflag,1); himem_read (dummy+1,_CS,(unsigned int)&BlockSize,4);
   ;	
	push	large 1
	push	offset MGRP:Xflag
	push	cs
	push	dword ptr [bp-4]
	call	near ptr MGRP:_himem_read
	add	sp,12
	push	large 4
	push	offset MGRP:BlockSize
	push	cs
	mov	eax,dword ptr [bp-4]
	inc	eax
	push	eax
	call	near ptr MGRP:_himem_read
	add	sp,12
   ;	
   ;	
   ;	  if (Xflag == HiMemoryBlockFree)
   ;	
	cmp	byte ptr MGRP:Xflag,90
	je short	@@5
	jmp	@54@198
@@5:
   ;	
   ;	  {
   ;	   if (BlockSize >= size)
   ;	
	mov	eax,dword ptr MGRP:BlockSize
	cmp	eax,dword ptr [bp+4]
	jae short	@@6
	jmp	@54@170
@@6:
   ;	
   ;	   {
   ;	    Xflag = HiMemoryBlockUsed;
   ;	
	mov	byte ptr MGRP:Xflag,86
   ;	
   ;	    himem_write (_CS,(unsigned int)&Xflag,dummy,1);
   ;	
	push	large 1
	push	dword ptr [bp-4]
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	    TempSize = size;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr MGRP:TempSize,eax
   ;	
   ;	    himem_write (_CS,(unsigned int)&TempSize,dummy+1,4);
   ;	
	push	large 4
	mov	eax,dword ptr [bp-4]
	inc	eax
	push	eax
	push	offset MGRP:TempSize
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	    if (size != BlockSize)
   ;	
	mov	eax,dword ptr [bp+4]
	cmp	eax,dword ptr MGRP:BlockSize
	je	short @54@170
   ;	
   ;	    {
   ;	     TempSize = BlockSize - size; Xflag = HiMemoryBlockFree;
   ;	
	mov	eax,dword ptr MGRP:BlockSize
	sub	eax,dword ptr [bp+4]
	mov	dword ptr MGRP:TempSize,eax
	mov	byte ptr MGRP:Xflag,90
   ;	
   ;	     himem_write (_CS,(unsigned int)&Xflag,dummy+size+5,1);
   ;	
	push	large 1
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr [bp+4]
	add	eax,large 5
	push	eax
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	     himem_write (_CS,(unsigned int)&TempSize,dummy+size+5+1,4);
   ;	
	push	large 4
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr [bp+4]
	add	eax,large 6
	push	eax
	push	offset MGRP:TempSize
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
@54@170:
   ;	
   ;	    }
   ;	   }
   ;	   return (dummy+5);
   ;	
	mov	eax,dword ptr [bp-4]
	add	eax,large 5
	jmp	@54@338
@54@198:
   ;	
   ;	  }
   ;	  if (Xflag == HiMemoryBlockLast)
   ;	
	cmp	byte ptr MGRP:Xflag,80
	jne	short @54@254
   ;	
   ;	  {
   ;	   Xflag = HiMemoryBlockUsed;
   ;	
	mov	byte ptr MGRP:Xflag,86
   ;	
   ;	   himem_write (_CS,(unsigned int)&Xflag,dummy,1);
   ;	
	push	large 1
	push	dword ptr [bp-4]
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	   Xflag = HiMemoryBlockLast;
   ;	
	mov	byte ptr MGRP:Xflag,80
   ;	
   ;	   himem_write (_CS,(unsigned int)&Xflag,dummy+BlockSize+5,1);
   ;	
	push	large 1
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr MGRP:BlockSize
	add	eax,large 5
	push	eax
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	   TempSize = size;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr MGRP:TempSize,eax
   ;	
   ;	   himem_write (_CS,(unsigned int)&TempSize,dummy+BlockSize+1+5,4);
   ;	
	push	large 4
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr MGRP:BlockSize
	add	eax,large 6
	push	eax
	push	offset MGRP:TempSize
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	   return (dummy+BlockSize+5+5);
   ;	
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr MGRP:BlockSize
	add	eax,large 10
	jmp	short @54@338
@54@254:
   ;	
   ;	  }
   ;	  dummy = dummy + BlockSize + 5;
   ;	
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr MGRP:BlockSize
	add	eax,large 5
	mov	dword ptr [bp-4],eax
@54@282:
	mov	eax,dword ptr [bp-4]
	cmp	eax,dword ptr [bp-8]
	jae short	@@7
	jmp	@54@58
@@7:
   ;	
   ;	 }
   ;	 OutTextXY (10,450,"ERROR HIMEM");
   ;	
	push	offset MGRP:s@
	push	large 001C2000Ah
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 return 0;
   ;	
	xor	eax,eax
@54@338:
	shld	edx,eax,16
   ;	
   ;	}
   ;	
	leave	
	ret	
_HiMemoryAlloc	endp
   ;	
   ;	void HiMemoryFree (unsigned long para)
   ;	
	assume	cs:MGRP
_HiMemoryFree	proc	near
	enter	12,0
   ;	
   ;	{
   ;	 unsigned long dummy;
   ;	 unsigned long HiMemoryEnd;
   ;	 unsigned long lastused;
   ;	
   ;	 para = para - 5;
   ;	
	mov	eax,dword ptr [bp+4]
	sub	eax,large 5
	mov	dword ptr [bp+4],eax
   ;	
   ;	
   ;	 dummy = HiMemoryStart;
   ;	
	mov	dword ptr [bp-4],large 000400000h
   ;	
   ;	 HiMemoryEnd = ( (unsigned long)(HiMemoryAvailable ()) << 10) ;
   ;	
	call	near ptr MGRP:_HiMemoryAvailable
	movzx	eax,ax
	shl	eax,10
	mov	dword ptr [bp-8],eax
   ;	
   ;	
   ;	 himem_read (para,_CS,(unsigned int)&Xflag,1);
   ;	
	push	large 1
	push	offset MGRP:Xflag
	push	cs
	push	dword ptr [bp+4]
	call	near ptr MGRP:_himem_read
	add	sp,12
   ;	
   ;	 if (Xflag == HiMemoryBlockUsed)
   ;	
	cmp	byte ptr MGRP:Xflag,86
	jne short	@@8
	jmp	@55@282
@@8:
   ;	
   ;	 {
   ;	  Xflag = HiMemoryBlockFree;
   ;	  himem_write (_CS,(unsigned int)&Xflag,para,1);
   ;	  return;
   ;	 }
   ;	
   ;	 if (Xflag == HiMemoryBlockLast)
   ;	
	cmp	byte ptr MGRP:Xflag,80
	je short	@@9
	jmp	@55@310
@@9:
	jmp	short @55@226
@55@114:
   ;	
   ;	 {
   ;	  while ( dummy < HiMemoryEnd )
   ;	  {
   ;	   himem_read (dummy,_CS,(unsigned int)&Xflag,1); himem_read (dummy+1,_CS,(unsigned int)&BlockSize,4);
   ;	
	push	large 1
	push	offset MGRP:Xflag
	push	cs
	push	dword ptr [bp-4]
	call	near ptr MGRP:_himem_read
	add	sp,12
	push	large 4
	push	offset MGRP:BlockSize
	push	cs
	mov	eax,dword ptr [bp-4]
	inc	eax
	push	eax
	call	near ptr MGRP:_himem_read
	add	sp,12
   ;	
   ;	   if (Xflag == HiMemoryBlockUsed)
   ;	
	cmp	byte ptr MGRP:Xflag,86
	jne	short @55@170
   ;	
   ;	   {
   ;	    lastused = dummy;
   ;	
	mov	eax,dword ptr [bp-4]
	mov	dword ptr [bp-12],eax
@55@170:
   ;	
   ;	   }
   ;	   if (Xflag == HiMemoryBlockLast)
   ;	
	cmp	byte ptr MGRP:Xflag,80
	je	short @55@254
   ;	
   ;	   {
   ;	    break;
   ;	   }
   ;	   dummy = dummy + BlockSize + 5;
   ;	
	mov	eax,dword ptr [bp-4]
	add	eax,dword ptr MGRP:BlockSize
	add	eax,large 5
	mov	dword ptr [bp-4],eax
@55@226:
	mov	eax,dword ptr [bp-4]
	cmp	eax,dword ptr [bp-8]
	jb	short @55@114
@55@254:
   ;	
   ;	  }
   ;	 Xflag = HiMemoryBlockLast;
   ;	
	mov	byte ptr MGRP:Xflag,80
   ;	
   ;	 himem_write (_CS,(unsigned int)&Xflag,lastused,1);
   ;	
	push	large 1
	push	dword ptr [bp-12]
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	 Xflag = HiMemoryBlockFree;
   ;	
@55@282:
	mov	byte ptr MGRP:Xflag,90
   ;	
   ;	 himem_write (_CS,(unsigned int)&Xflag,para,1);
   ;	
	push	large 1
	push	dword ptr [bp+4]
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	 return;
   ;	
@55@310:
   ;	
   ;	 }
   ;	}
   ;	
	leave	
	ret	
_HiMemoryFree	endp
   ;	
   ;	void HiMemoryInit (void)
   ;	
	assume	cs:MGRP
_HiMemoryInit	proc	near
   ;	
   ;	{
   ;	 Xflag = HiMemoryBlockLast;
   ;	
	mov	byte ptr MGRP:Xflag,80
   ;	
   ;	 TempSize = 1;
   ;	
	mov	dword ptr MGRP:TempSize,large 1
   ;	
   ;	 himem_write (_CS,(unsigned int)&Xflag,HiMemoryStart,1);
   ;	
	push	large 1
	push	large 000400000h
	push	offset MGRP:Xflag
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	 himem_write (_CS,(unsigned int)&TempSize,HiMemoryStart+1,4);
   ;	
	push	large 4
	push	large 000400001h
	push	offset MGRP:TempSize
	push	cs
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	}
   ;	
	ret	
_HiMemoryInit	endp
   ;	
   ;	unsigned int malloc (int pg)
   ;	
	assume	cs:MGRP
_malloc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	       mov ah,0x12
   ;	
	mov	 ah,012H
   ;	
   ;	       mov bx,pg
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	       int 0x44
   ;	
	int	 044H
   ;	
   ;	     } 
   ;	}
   ;	
	pop	bp
	ret	
_malloc	endp
   ;	
   ;	void free (unsigned int segm)
   ;	
	assume	cs:MGRP
_free	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;		mov ah,0x13
   ;	
	mov	 ah,013H
   ;	
   ;		mov bx,segm
   ;	
	mov	 bx,[bp+4]
   ;	
   ;		int 0x44
   ;	
	int	 044H
   ;	
   ;	      }
   ;	}
   ;	
	pop	bp
	ret	
_free	endp
   ;	
   ;	unsigned long avail (void)
   ;	
	assume	cs:MGRP
_avail	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	       mov ah,0x15
   ;	
	mov	 ah,015H
   ;	
   ;	       int 0x44
   ;	
	int	 044H
   ;	
   ;	       mov dx,0
   ;	
	mov	 dx,0
   ;	
   ;	      } 
   ;	}
   ;	
	ret	
_avail	endp
   ;	
   ;	char is_alt (void)
   ;	
	assume	cs:MGRP
_is_alt	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ah,2
   ;	
	mov	 ah,2
   ;	
   ;		int 0x16
   ;	
	int	 016H
   ;	
   ;		and al,8
   ;	
	and	 al,8
   ;	
   ;		shr al,3
   ;	
	shr	 al,3
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_is_alt	endp
   ;	
   ;	unsigned char is_key (void)
   ;	
	assume	cs:MGRP
_is_key	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;		xor bl,bl
   ;	
	xor	 bl,bl
   ;	
   ;		int 0x16
   ;	
	int	 016H
   ;	
   ;		setz bl
   ;	
	setz	 bl
   ;	
   ;		mov al,bl
   ;	
	mov	 al,bl
   ;	
   ;		xor al,1
   ;	
	xor	 al,1
   ;	
   ;	      }
   ;	}
   ;	
	ret	
_is_key	endp
   ;	
   ;	char getch (void)
   ;	
	assume	cs:MGRP
_getch	proc	near
   ;	
   ;	{
   ;	  asm {
   ;	       mov ah,0x0
   ;	
	mov	 ah,00H
   ;	
   ;	       int 0x16
   ;	
	int	 016H
   ;	
   ;	       mov al,ah
   ;	
	mov	 al,ah
   ;	
   ;	     };
   ;	}
   ;	
	ret	
_getch	endp
   ;	
   ;	unsigned int Xgetch (void)
   ;	
	assume	cs:MGRP
_Xgetch	proc	near
   ;	
   ;	{
   ;	  asm {
   ;	       mov ah,18h
   ;	
	mov	 ah,18h
   ;	
   ;	       int 44h
   ;	
	int	 44h
   ;	
   ;	
   ;	     };
   ;	}
   ;	
	ret	
_Xgetch	endp
   ;	
   ;	unsigned int PosString (char far* parser, unsigned int pos)
   ;	
	assume	cs:MGRP
_PosString	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 unsigned int j,k;
   ;	
   ;	 j = 0; k = 0;
   ;	
	xor	dx,dx
	xor	cx,cx
	jmp	short @64@114
@64@58:
   ;	
   ;	 while ( j != pos)
   ;	 {
   ;	  if (parser [k++] == 0) j++;
   ;	
	mov	ax,cx
	inc	cx
	les	bx,dword ptr [bp+4]
	add	bx,ax
	cmp	byte ptr es:[bx],0
	jne	short @64@114
	inc	dx
@64@114:
	cmp	dx,word ptr [bp+8]
	jne	short @64@58
   ;	
   ;	 }
   ;	 return k;
   ;	
	mov	ax,cx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_PosString	endp
oldx	label	word
	db	64
	db	1
oldy	label	word
	db	240
	db	0
cursor	label	byte
	db	0
	db	0
	db	0
	db	0
	db	1
	db	0
	db	1
	db	1
	db	0
	db	0
	db	2
	db	0
	db	1
	db	2
	db	15
	db	2
	db	2
	db	0
	db	0
	db	3
	db	0
	db	1
	db	3
	db	15
	db	2
	db	3
	db	15
	db	3
	db	3
	db	0
	db	0
	db	4
	db	0
	db	1
	db	4
	db	15
	db	2
	db	4
	db	15
	db	3
	db	4
	db	15
	db	4
	db	4
	db	0
	db	0
	db	5
	db	0
	db	1
	db	5
	db	15
	db	2
	db	5
	db	15
	db	3
	db	5
	db	15
	db	4
	db	5
	db	15
	db	5
	db	5
	db	0
	db	0
	db	6
	db	0
	db	1
	db	6
	db	0
	db	2
	db	6
	db	0
	db	3
	db	6
	db	0
	db	4
	db	6
	db	0
	db	5
	db	6
	db	0
	db	6
	db	6
	db	0
flag	label	word
	db	0
	db	0
mouse_status	label	word
	db	0
	db	0
topWnd	label	dword
	db	0
	db	0
	db	0
	db	0
protectedWnd	label	dword
	db	0
	db	0
	db	0
	db	0
	?debug	C E9C07EEF58077368656C6C2E68
   ;	
   ;	void far *get_shell (void)
   ;	
	assume	cs:MGRP
_get_shell	proc	near
	push	si
	push	di
   ;	
   ;	{
   ;	 asm {
   ;		push si
   ;	
	push	 si
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ah,2
   ;	
	mov	 ah,2
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;		mov dx,si
   ;	
	mov	 dx,si
   ;	
   ;		mov ax,di
   ;	
	mov	 ax,di
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	si
	ret	
_get_shell	endp
_shX	label	word
	db	25
	db	0
_shY	label	word
	db	30
	db	0
_ix	label	word
	db	25
	db	0
_iy	label	word
	db	30
	db	0
_wx	label	word
	db	8
	db	0
_wy	label	word
	db	10
	db	0
_exiting	label	word
	db	0
	db	0
   ;	
   ;	void interrupt int29 (void)
   ;	
	assume	cs:MGRP
_int29	proc	far
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
   ;	 _BL = _AL;
   ;	
	mov	bl,al
   ;	
   ;	 _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
   ;	
   ;	 shc = _BL;
   ;	
	mov	byte ptr MGRP:_shc,bl
   ;	
   ;	
   ;	 if (shc == ((char)1)) 
   ;	
	cmp	byte ptr MGRP:_shc,1
	jne	short @66@86
   ;	
   ;	 {
   ;	    DestroyWindow(hWndSh);
   ;	
	push	dword ptr MGRP:_hWndSh
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
   ;	
   ;	    exiting = 1;
   ;	
	mov	word ptr MGRP:_exiting,1
   ;	
   ;	    return;
   ;	
	jmp	@66@450
@66@86:
   ;	
   ;	 }
   ;	
   ;	 if (shX < ((64*8)+ix-8)) PrintChar ('_',shX,shY,0,255,0);
   ;	
	mov	ax,word ptr MGRP:_ix
	add	ax,504
	cmp	ax,word ptr MGRP:_shX
	jle	short @66@142
	push	0
	push	255
	push	0
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
@66@142:
   ;	
   ;	 switch (shc)
   ;	
	mov	al,byte ptr MGRP:_shc
	cbw	
	cmp	ax,8
	je	short @66@338
	cmp	ax,10
	je	short @66@282
	cmp	ax,13
	je short	@@10
	jmp	@66@422
@@10:
   ;	
   ;	 {
   ;	  case 13: shX = ix;
   ;	
	mov	ax,word ptr MGRP:_ix
	mov	word ptr MGRP:_shX,ax
   ;	
   ;		   break;
   ;	
	jmp	@66@450
@66@282:
   ;	
   ;	  case 10: if (shY == (iy+ 12 *16)) break;
   ;	
	mov	ax,word ptr MGRP:_iy
	add	ax,192
	cmp	ax,word ptr MGRP:_shY
	jne short	@@11
	jmp	@66@450
@@11:
   ;	
   ;		   shY += 16;
   ;	
	add	word ptr MGRP:_shY,16
   ;	
   ;		   break;
   ;	
	jmp	@66@450
@66@338:
   ;	
   ;	  case 8:  if (shX == ix) {SetColor (3);Bar (shX,shY,shX+8,shY+16); break; };
   ;	
	mov	ax,word ptr MGRP:_shX
	cmp	ax,word ptr MGRP:_ix
	jne	short @66@394
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
	mov	ax,word ptr MGRP:_shY
	add	ax,16
	push	ax
	mov	ax,word ptr MGRP:_shX
	add	ax,8
	push	ax
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	call	near ptr MGRP:_Bar
	add	sp,8
	jmp	short @66@450
@66@394:
   ;	
   ;		   shX = shX - 8;
   ;	
	mov	ax,word ptr MGRP:_shX
	add	ax,-8
	mov	word ptr MGRP:_shX,ax
   ;	
   ;		   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;		   Bar (shX,shY,shX+8,shY+16);
   ;	
	mov	ax,word ptr MGRP:_shY
	add	ax,16
	push	ax
	mov	ax,word ptr MGRP:_shX
	add	ax,8
	push	ax
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;		   PrintChar ('_',shX,shY,7,255,0);
   ;	
	push	0
	push	255
	push	7
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;		   break;
   ;	
	jmp	short @66@450
@66@422:
   ;	
   ;	  default:
   ;	       displayChar(shc);
   ;	
	mov	al,byte ptr MGRP:_shc
	push	ax
	call	near ptr MGRP:_displayChar
	pop	cx
@66@450:
   ;	
   ;	 }
   ;	 
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
_int29	endp
   ;	
   ;	void displayChar(char sch) 
   ;	
	assume	cs:MGRP
_displayChar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	    if (shY >= (iy+ 11 *16))
   ;	
	mov	ax,word ptr MGRP:_iy
	add	ax,176
	cmp	ax,word ptr MGRP:_shY
	jg	short @67@86
   ;	
   ;	    {
   ;	     scroll_up (ix-2,iy+16,65*8+8, 12*16-2 , 16);
   ;	
	push	16
	push	large 000BE0210h
	mov	ax,word ptr MGRP:_iy
	add	ax,16
	push	ax
	mov	ax,word ptr MGRP:_ix
	add	ax,-2
	push	ax
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	     shY -= 16;
   ;	
	sub	word ptr MGRP:_shY,16
@67@86:
   ;	
   ;	    }
   ;	    if (shX == ((64*8)+ix)) { shX = ix; shY += 16; };
   ;	
	mov	ax,word ptr MGRP:_ix
	add	ax,512
	cmp	ax,word ptr MGRP:_shX
	jne	short @67@142
	mov	ax,word ptr MGRP:_ix
	mov	word ptr MGRP:_shX,ax
	add	word ptr MGRP:_shY,16
@67@142:
   ;	
   ;	    PrintChar (shc,shX,shY,7,255,0);
   ;	
	push	0
	push	255
	push	7
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	mov	al,byte ptr MGRP:_shc
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	    shX = shX + 8;
   ;	
	mov	ax,word ptr MGRP:_shX
	add	ax,8
	mov	word ptr MGRP:_shX,ax
   ;	
   ;	    if (shX < ((64*8)+ix-8)) PrintChar ('_',shX,shY,7,255,0);
   ;	
	mov	ax,word ptr MGRP:_ix
	add	ax,504
	cmp	ax,word ptr MGRP:_shX
	jle	short @67@198
	push	0
	push	255
	push	7
	push	word ptr MGRP:_shY
	push	word ptr MGRP:_shX
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
@67@198:
   ;	
   ;	}  
   ;	
	pop	bp
	ret	
_displayChar	endp
   ;	
   ;	void set_int_29 (void)
   ;	
	assume	cs:MGRP
_set_int_29	proc	near
   ;	
   ;	{
   ;	 asm {
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
   ;		mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;		mov bx,offset int29
   ;	
	mov	 bx,offset _int29
   ;	
   ;		mov es:[0x29 * 4],bx
   ;	
	mov	 es:[029H * 4],bx
   ;	
   ;		mov es:[0x29 * 4 +2],ax
   ;	
	mov	 es:[029H * 4 +2],ax
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
   ;	     }
   ;	}
   ;	
	ret	
_set_int_29	endp
   ;	
   ;	void far WinMainSh (void)
   ;	
	assume	cs:MGRP
_WinMainSh	proc	far
   ;	
   ;	{
   ;	 FuncEntry
   ;	
 	cli	 
 	pusha	 
	mov	ax,ds
	mov	bx,cs
	mov	ds,bx
	mov	word ptr MGRP:DataSegmentSh,ax
   ;	
   ;	
   ;	  if (WM_MESSAGE == WINDOW_DESTROY)
   ;	
	cmp	byte ptr MGRP:_SysBuf+1,176
	jne	short @69@170
   ;	
   ;	  {
   ;	     shX = 25; shY = 30;
   ;	
	mov	word ptr MGRP:_shX,25
	mov	word ptr MGRP:_shY,30
   ;	
   ;	     ix = 25;  iy = 30;
   ;	
	mov	word ptr MGRP:_ix,25
	mov	word ptr MGRP:_iy,30
   ;	
   ;	     wx = 8;  wy = 10;
   ;	
	mov	word ptr MGRP:_wx,8
	mov	word ptr MGRP:_wy,10
   ;	
   ;	     
   ;	     asm {
   ;	       mov ah,5
   ;	
	mov	 ah,5
   ;	
   ;	       int 0x46
   ;	
	int	 046H
@69@170:
   ;	
   ;	     }
   ;	  }
   ;	  
   ;	  if (WM_MESSAGE == KEYB_CLICK)
   ;	
	cmp	byte ptr MGRP:_SysBuf+1,161
	je short	@@12
	jmp	@69@366
@@12:
   ;	
   ;	  {
   ;	   _DS = _CS;              
   ;	
	mov	ax,cs
	mov	ds,ax
   ;	
   ;	   keysh = SysBuf.word1;
   ;	
	mov	ax,word ptr MGRP:_SysBuf+3
	mov	word ptr MGRP:_keysh,ax
   ;	
   ;	   
   ;	   if ((char)keysh != 8)
   ;	
	cmp	byte ptr MGRP:_keysh,8
	jne short	@@13
	jmp	@69@366
@@13:
   ;	
   ;	   {
   ;	       ix = ix + (hWndSh->x - wx) - delta;
   ;	
	les	bx,dword ptr MGRP:_hWndSh
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	dx,word ptr MGRP:_ix
	add	dx,ax
	sub	dx,word ptr MGRP:_delta
	mov	word ptr MGRP:_ix,dx
   ;	
   ;	       iy = iy + (hWndSh->y - wy);
   ;	
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr MGRP:_wy
	mov	dx,word ptr MGRP:_iy
	add	dx,ax
	mov	word ptr MGRP:_iy,dx
   ;	
   ;	       shX = shX + (hWndSh->x - wx) - delta;
   ;	
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	dx,word ptr MGRP:_shX
	add	dx,ax
	sub	dx,word ptr MGRP:_delta
	mov	word ptr MGRP:_shX,dx
   ;	
   ;	       shY = shY + (hWndSh->y - wy);
   ;	
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr MGRP:_wy
	mov	dx,word ptr MGRP:_shY
	add	dx,ax
	mov	word ptr MGRP:_shY,dx
   ;	
   ;	       
   ;	       wx = hWndSh->x;
   ;	
	mov	ax,word ptr es:[bx]
	mov	word ptr MGRP:_wx,ax
   ;	
   ;	       wy = hWndSh->y;
   ;	
	mov	ax,word ptr es:[bx+2]
	mov	word ptr MGRP:_wy,ax
   ;	
   ;	       delta = (hWndSh->x - wx);
   ;	
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	word ptr MGRP:_delta,ax
   ;	
   ;	       
   ;	       exiting = 0;
   ;	
	mov	word ptr MGRP:_exiting,0
   ;	
   ;	       shell ((char)keysh);
   ;	
	mov	al,byte ptr MGRP:_keysh
	push	ax
	call	dword ptr MGRP:_shell
	pop	cx
   ;	
   ;	        _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
   ;	
   ;	
   ;	       if ( (hWndSh != topWnd) && (!exiting) )
   ;	
	mov	eax,dword ptr MGRP:_hWndSh
	cmp	eax,dword ptr MGRP:topWnd
	je	short @69@310
	cmp	word ptr MGRP:_exiting,0
	jne	short @69@310
   ;	
   ;	       {
   ;	          SwitchWindow(hWndSh);
   ;	
	push	dword ptr MGRP:_hWndSh
	call	near ptr MGRP:_SwitchWindow
	add	sp,4
@69@310:
   ;	
   ;	       }   
   ;	       if (!exiting)
   ;	
	cmp	word ptr MGRP:_exiting,0
	jne	short @69@366
   ;	
   ;	       {
   ;	          shell ((char)2);
   ;	
	push	2
	call	dword ptr MGRP:_shell
	pop	cx
   ;	
   ;	          _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
@69@366:
   ;	
   ;	       }
   ;	    }
   ;	  }
   ;	
   ;	
   ;	 FuncEnd
   ;	
	mov	ax,word ptr MGRP:DataSegmentSh
	mov	ds,ax
 	popa	 
 	sti	 
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_WinMainSh	endp
   ;	
   ;	void console (void)
   ;	
	assume	cs:MGRP
_console	proc	near
   ;	
   ;	{
   ;	 unsigned long mbuf;
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 //mbuf = save_area (8,8,66*8,15*16+3);
   ;	 shX = 15;
   ;	
	mov	word ptr MGRP:_shX,15
   ;	
   ;	 shY = 30;
   ;	
	mov	word ptr MGRP:_shY,30
   ;	
   ;	 BGWindow = 0;
   ;	
	mov	byte ptr MGRP:BGWindow,0
   ;	
   ;	 //Window (8,10,65*8,15*16-1,3,"shell");
   ;	 hWndSh = CreateWindow (wx,wy,65*8,15*16-1,3,"Shell");
   ;	
	push	offset MGRP:s@+12
	push	3
	push	large 000EF0208h
	push	word ptr MGRP:_wy
	push	word ptr MGRP:_wx
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_hWndSh+2,dx
	mov	word ptr MGRP:_hWndSh,ax
   ;	
   ;	 delta = (hWndSh->x - wx);
   ;	
	les	bx,dword ptr MGRP:_hWndSh
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	word ptr MGRP:_delta,ax
   ;	
   ;	
   ;	 ix = ix + (hWndSh->x - wx) - delta;
   ;	
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	dx,word ptr MGRP:_ix
	add	dx,ax
	sub	dx,word ptr MGRP:_delta
	mov	word ptr MGRP:_ix,dx
   ;	
   ;	 iy = iy + (hWndSh->y - wy);
   ;	
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr MGRP:_wy
	mov	dx,word ptr MGRP:_iy
	add	dx,ax
	mov	word ptr MGRP:_iy,dx
   ;	
   ;	 shX = shX + (hWndSh->x - wx);
   ;	
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr MGRP:_wx
	mov	dx,word ptr MGRP:_shX
	add	dx,ax
	mov	word ptr MGRP:_shX,dx
   ;	
   ;	 shY = shY + (hWndSh->y - wy);
   ;	
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr MGRP:_wy
	mov	dx,word ptr MGRP:_shY
	add	dx,ax
	mov	word ptr MGRP:_shY,dx
   ;	
   ;	
   ;	 hWndSh->WinMain = (void far*) (_CS * 65536 + (unsigned int)&WinMainSh);
   ;	
	mov	ax,cs
	movzx	eax,ax
	shl	eax,16
	mov	dx,offset MGRP:_WinMainSh
	movzx	edx,dx
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr es:[bx+18],dx
	mov	word ptr es:[bx+16],ax
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 //fastbar (16,27,65*8,15*16+5);
   ;	 set_int_29 ();
   ;	
	call	near ptr MGRP:_set_int_29
   ;	
   ;	 shell = get_shell();
   ;	
	call	near ptr MGRP:_get_shell
	mov	word ptr MGRP:_shell+2,dx
	mov	word ptr MGRP:_shell,ax
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 exiting = 0;
   ;	
	mov	word ptr MGRP:_exiting,0
   ;	
   ;	 shell ((char)2);
   ;	
	push	2
	call	dword ptr MGRP:_shell
	pop	cx
   ;	
   ;	  _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	/*
   ;	 restore_area (8,8,66*8,15*16+3,mbuf,1);
   ;	*/
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	}
   ;	
	ret	
_console	endp
   ;	
   ;	unsigned long save_area (int x, int y, int w, int h)
   ;	
	assume	cs:MGRP
_save_area	proc	near
	enter	8,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 unsigned int ret;
   ;	 unsigned long xadr;
   ;	 unsigned int size;
   ;	
   ;	 size = imagesize (x,y,x+w,y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_imagesize
	add	sp,8
	mov	word ptr [bp-8],ax
   ;	
   ;	
   ;	 ret = malloc ( (size >> 4) + 1 );
   ;	
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;	 getimage (x,y,x+w,y+h,ret);
   ;	
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_getimage
	add	sp,10
   ;	
   ;	
   ;	 xadr = HiMemoryAlloc ( imagesize (x,y,x+w,y+h) );
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_imagesize
	add	sp,8
	movzx	eax,ax
	push	eax
	call	near ptr MGRP:_HiMemoryAlloc
	push	dx
	push	ax
	pop	eax
	add	sp,4
	mov	dword ptr [bp-6],eax
   ;	
   ;	
   ;	 himem_write (ret,0,xadr,imagesize (x,y,x+w,y+h) );
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_imagesize
	add	sp,8
	movzx	eax,ax
	push	eax
	push	dword ptr [bp-6]
	push	0
	push	word ptr [bp-2]
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	 free (ret);
   ;	
	push	word ptr [bp-2]
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 //ret = xadr;
   ;	
   ;	 return xadr;
   ;	
	mov	eax,dword ptr [bp-6]
	shld	edx,eax,16
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_save_area	endp
   ;	
   ;	void restore_area (int x, int y, int w,int h,unsigned long ret,char rel)
   ;	
	assume	cs:MGRP
_restore_area	proc	near
	enter	2,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 unsigned int basemem;
   ;	
   ;	 basemem = malloc ( (imagesize (x,y,x+w,y+h) >> 4) + 1 );
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_imagesize
	add	sp,8
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;	 himem_read (ret,basemem,0,imagesize (x,y,x+w,y+h));
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_imagesize
	add	sp,8
	movzx	eax,ax
	push	eax
	push	0
	push	word ptr [bp-2]
	push	dword ptr [bp+12]
	call	near ptr MGRP:_himem_read
	add	sp,12
   ;	
   ;	 putimage (x,y,basemem);
   ;	
	push	word ptr [bp-2]
	push	di
	push	si
	call	near ptr MGRP:_putimage
	add	sp,6
   ;	
   ;	 free (basemem);
   ;	
	push	word ptr [bp-2]
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 if (rel) HiMemoryFree (ret);
   ;	
	cmp	byte ptr [bp+16],0
	je	short @72@86
	push	dword ptr [bp+12]
	call	near ptr MGRP:_HiMemoryFree
	add	sp,4
@72@86:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_restore_area	endp
   ;	
   ;	void InitFullApp (void)
   ;	
	assume	cs:MGRP
_InitFullApp	proc	near
   ;	
   ;	{
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	je short	@@14
	jmp	@73@58
@@14:
   ;	
   ;	 {
   ;	  screen_seg1 = save_area (0,0  ,640,96);
   ;	
	push	large 000600280h
	push	large 0
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg1,eax
   ;	
   ;	  screen_seg2 = save_area (0,96 ,640,96);
   ;	
	push	large 000600280h
	push	large 000600000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg2,eax
   ;	
   ;	  screen_seg3 = save_area (0,192,640,96);
   ;	
	push	large 000600280h
	push	large 000C00000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg3,eax
   ;	
   ;	  screen_seg4 = save_area (0,288,640,96);
   ;	
	push	large 000600280h
	push	large 001200000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg4,eax
   ;	
   ;	  screen_seg5 = save_area (0,384,640,96);
   ;	
	push	large 000600280h
	push	384
	jmp	short @73@86
@73@58:
   ;	
   ;	 }
   ;	 else
   ;	 {
   ;	  screen_seg1 = save_area (0,0  ,800,120);
   ;	
	push	large 000780320h
	push	large 0
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg1,eax
   ;	
   ;	  screen_seg2 = save_area (0,120,800,120);
   ;	
	push	large 000780320h
	push	large 000780000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg2,eax
   ;	
   ;	  screen_seg3 = save_area (0,240,800,120);
   ;	
	push	large 000780320h
	push	large 000F00000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg3,eax
   ;	
   ;	  screen_seg4 = save_area (0,360,800,120);
   ;	
	push	large 000780320h
	push	large 001680000h
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg4,eax
   ;	
   ;	  screen_seg5 = save_area (0,480,800,120);
   ;	
	push	large 000780320h
	push	480
@73@86:
	push	0
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr MGRP:_screen_seg5,eax
   ;	
   ;	 
   ;	 }
   ;	 
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	 is_full_app = 1;
   ;	
	mov	byte ptr MGRP:is_full_app,1
   ;	
   ;	}
   ;	
	ret	
_InitFullApp	endp
   ;	
   ;	void CloseFullApp (void)
   ;	
	assume	cs:MGRP
_CloseFullApp	proc	near
   ;	
   ;	{
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	je short	@@15
	jmp	@74@58
@@15:
   ;	
   ;	 {
   ;	 restore_area (0,0  ,640,96,screen_seg1,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg1
	push	large 000600280h
	push	large 0
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,96 ,640,96,screen_seg2,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg2
	push	large 000600280h
	push	large 000600000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,192,640,96,screen_seg3,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg3
	push	large 000600280h
	push	large 000C00000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,288,640,96,screen_seg4,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg4
	push	large 000600280h
	push	large 001200000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,384,640,96,screen_seg5,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg5
	push	large 000600280h
	push	384
	jmp	@74@86
@74@58:
   ;	
   ;	 }
   ;	 else
   ;	 {
   ;	 restore_area (0,0  ,800,120,screen_seg1,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg1
	push	large 000780320h
	push	large 0
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,120,800,120,screen_seg2,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg2
	push	large 000780320h
	push	large 000780000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,240,800,120,screen_seg3,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg3
	push	large 000780320h
	push	large 000F00000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,360,800,120,screen_seg4,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg4
	push	large 000780320h
	push	large 001680000h
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 restore_area (0,480,800,120,screen_seg5,1);
   ;	
	push	1
	push	dword ptr MGRP:_screen_seg5
	push	large 000780320h
	push	480
@74@86:
	push	0
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	}
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	 is_full_app = 0;
   ;	
	mov	byte ptr MGRP:is_full_app,0
   ;	
   ;	}
   ;	
	ret	
_CloseFullApp	endp
TempString2	label	byte
	db	0
	db	49 dup (0)
   ;	
   ;	HWND CreateWindow (int x, int y, int w, int h, char color, char* title)
   ;	
	assume	cs:MGRP
_CreateWindow	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
	mov	si,word ptr [bp+8]
   ;	
   ;	{
   ;	 // CONTROL LastEditBox;
   ;	 
   ;	 if (( ((((unsigned long)w) / 8) + 1) * (unsigned long)h * 4) > 65520)
   ;	
	movsx	eax,si
	shr	eax,3
	inc	eax
	movsx	edx,word ptr [bp+10]
	imul	eax,edx
	shl	eax,2
	cmp	eax,large 00000FFF0h
	jbe	short @75@86
   ;	
   ;	 {
   ;	    MessageBox ("Window too big"); 
   ;	
	push	offset MGRP:s@+18
	call	near ptr MGRP:_MessageBox
	pop	cx
   ;	
   ;	    Xgetch();     
   ;	
	call	near ptr MGRP:_Xgetch
   ;	
   ;	    return 0;   
   ;	
	xor	dx,dx
	xor	ax,ax
	jmp	@75@310
@75@86:
   ;	
   ;	 }
   ;	 
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	
   ;	 // LastEditBox = activeEditBox; //FindLastEditBox (topWnd);
   ;	  if (activeEditBox != (CONTROL)0 )
   ;	
	cmp	dword ptr MGRP:_activeEditBox,large 0
	je	short @75@142
   ;	
   ;	  {
   ;	   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString2,activeEditBox->StrSegment,activeEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:_activeEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString2
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   Line (activeEditBox->x+(Xstrlen(TempString2)*8)+5,
   ;	
   ;	
   ;		activeEditBox->y+5,
   ;		activeEditBox->x+(Xstrlen(TempString2)*8)+5,
   ;		activeEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:_activeEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString2
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString2
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@75@142:
   ;	
   ;	  }
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	 x = (( (x >> 3) + 1) << 3);
   ;	
	sar	di,3
	inc	di
	shl	di,3
   ;	
   ;	 w = (( (w >> 3) + 1) << 3);
   ;	
	sar	si,3
	inc	si
	shl	si,3
   ;	
   ;	
   ;	 if ( is_full_app == 0 )
   ;	
	cmp	byte ptr MGRP:is_full_app,0
	jne	short @75@226
   ;	
   ;	 {
   ;	  if ( topWnd != 0 )
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	je	short @75@226
   ;	
   ;	   topWnd->form = save_area (topWnd->x,topWnd->y,topWnd->w-8,topWnd->h);
   ;	
	les	bx,dword ptr MGRP:topWnd
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr es:[bx+8],eax
@75@226:
   ;	
   ;	 }
   ;	
   ;	  dumWnd = (unsigned long) malloc (2);
   ;	
	push	2
	call	near ptr MGRP:_malloc
	pop	cx
	movzx	eax,ax
	shld	edx,eax,16
	mov	word ptr MGRP:dumWnd+2,dx
	mov	word ptr MGRP:dumWnd,ax
   ;	
   ;	  asm { shl dword ptr dumWnd,16 };
   ;	
 	shl	 dword ptr dumWnd,16 
   ;	
   ;	 
   ;	 dumWnd->x = x;
   ;	
	les	bx,dword ptr MGRP:dumWnd
	mov	word ptr es:[bx],di
   ;	
   ;	 dumWnd->y = y;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr es:[bx+2],ax
   ;	
   ;	 dumWnd->w = w;
   ;	
	mov	word ptr es:[bx+4],si
   ;	
   ;	 dumWnd->h = h;
   ;	
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx+6],ax
   ;	
   ;	 dumWnd->form = 0;
   ;	
	mov	dword ptr es:[bx+8],large 0
   ;	
   ;	 dumWnd->WinMain = 0;
   ;	
	mov	dword ptr es:[bx+16],large 0
   ;	
   ;	 Window (x,y,w,h,color,title);
   ;	
	push	word ptr [bp+14]
	mov	al,byte ptr [bp+12]
	cbw	
	push	ax
	push	word ptr [bp+10]
	push	si
	push	word ptr [bp+6]
	push	di
	call	near ptr MGRP:_Window
	add	sp,12
   ;	
   ;	 dumWnd->prev = (void far*)topWnd;
   ;	
	les	bx,dword ptr MGRP:dumWnd
	mov	eax,dword ptr MGRP:topWnd
	mov	dword ptr es:[bx+12],eax
   ;	
   ;	 dumWnd->FirstControl = (void far*)0;
   ;	
	mov	dword ptr es:[bx+20],large 0
   ;	
   ;	 dumWnd->ActiveControl = (void far*)0;
   ;	
	mov	dword ptr es:[bx+28],large 0
   ;	
   ;	 topWnd = dumWnd;
   ;	
	mov	eax,dword ptr MGRP:dumWnd
	mov	dword ptr MGRP:topWnd,eax
   ;	
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	
   ;	 activeButton = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeButton,large 0
   ;	
   ;	 activeEditBox = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeEditBox,large 0
   ;	
   ;	
   ;	 return dumWnd;
   ;	
	mov	dx,word ptr MGRP:dumWnd+2
	mov	ax,word ptr MGRP:dumWnd
@75@310:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_CreateWindow	endp
   ;	
   ;	HWND NextWindow (HWND Wnd)
   ;	
	assume	cs:MGRP
_NextWindow	proc	near
	enter	4,0
   ;	
   ;	{
   ;	 HWND tempWnd;
   ;	
   ;	 if (Wnd == topWnd) return topWnd;
   ;	
	mov	eax,dword ptr [bp+4]
	cmp	eax,dword ptr MGRP:topWnd
	jne	short @76@86
	mov	dx,word ptr MGRP:topWnd+2
	mov	ax,word ptr MGRP:topWnd
	jmp	short @76@226
@76@86:
   ;	
   ;	
   ;	 tempWnd = topWnd;
   ;	
	mov	eax,dword ptr MGRP:topWnd
	jmp	short @76@142
@76@114:
   ;	
   ;	
   ;	 while (tempWnd->prev != Wnd)
   ;	 {
   ;	  tempWnd = tempWnd->prev;
   ;	
	les	bx,dword ptr [bp-4]
	mov	eax,dword ptr es:[bx+12]
@76@142:
	mov	dword ptr [bp-4],eax
	les	bx,dword ptr [bp-4]
	mov	eax,dword ptr es:[bx+12]
	cmp	eax,dword ptr [bp+4]
	jne	short @76@114
   ;	
   ;	//  if (tempWnd = (HWND)0) return (HWND)0;
   ;	 }
   ;	 return tempWnd;
   ;	
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
@76@226:
   ;	
   ;	}
   ;	
	leave	
	ret	
_NextWindow	endp
   ;	
   ;	void DestroyControl (HWND dmWnd)
   ;	
	assume	cs:MGRP
_DestroyControl	proc	near
	enter	2,0
   ;	
   ;	{
   ;	 unsigned int dc;
   ;	
   ;	 dumControl = dmWnd->LastControl;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+24]
@77@58:
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	 while (1)
   ;	 {
   ;	  tempControl = dumControl->prev;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	eax,dword ptr es:[bx+14]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	
   ;	  dc = (unsigned int) ( (unsigned long)(dumControl) >> 16 );
   ;	
	mov	eax,dword ptr MGRP:dumControl
	shr	eax,16
	mov	word ptr [bp-2],ax
   ;	
   ;	  free (dc);
   ;	
	push	ax
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	
   ;	  if (dumControl == dmWnd->FirstControl) break;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+20]
	cmp	eax,dword ptr MGRP:dumControl
	je	short @77@142
   ;	
   ;	  dumControl = tempControl;
   ;	
	mov	eax,dword ptr MGRP:tempControl
	jmp	short @77@58
@77@142:
   ;	
   ;	 }
   ;	}
   ;	
	leave	
	ret	
_DestroyControl	endp
   ;	
   ;	void DestroyWindow (HWND dmWnd)
   ;	
	assume	cs:MGRP
_DestroyWindow	proc	near
	enter	6,0
   ;	
   ;	{
   ;	 HWND tempWnd;
   ;	// CONTROL tempControl;
   ;	 unsigned int dm;
   ;	
   ;	 if (dmWnd != topWnd) return;
   ;	
	mov	eax,dword ptr [bp+4]
	cmp	eax,dword ptr MGRP:topWnd
	je short	@@16
	jmp	@78@646
@@16:
   ;	
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 SetColor (backc);
   ;	
	push	word ptr MGRP:_backc
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 waitretrace ();
   ;	
	call	near ptr MGRP:_waitretrace
   ;	
   ;	 if ( is_full_app == 0 )
   ;	
	cmp	byte ptr MGRP:is_full_app,0
	jne	short @78@198
   ;	
   ;	 {
   ;	 
   ;	  fastbar (dmWnd->x,dmWnd->y,dmWnd->w+dmWnd->x,dmWnd->h+dmWnd->y);
   ;	
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr es:[bx+6]
	add	ax,word ptr es:[bx+2]
	push	ax
	mov	ax,word ptr es:[bx+4]
	add	ax,word ptr es:[bx]
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_fastbar
	add	sp,8
   ;	
   ;	  tempWnd = NextWindow ((HWND)0);
   ;	
	push	large 0
	jmp	short @78@142
@78@114:
   ;	
   ;	
   ;	  while (tempWnd != dmWnd)
   ;	  {
   ;	   waitretrace ();
   ;	
	call	near ptr MGRP:_waitretrace
   ;	
   ;	//   putimage (tempWnd->x,tempWnd->y,tempWnd->form);
   ;	   restore_area (tempWnd->x,tempWnd->y,tempWnd->w-8,tempWnd->h,tempWnd->form,0);
   ;	
	push	0
	les	bx,dword ptr [bp-4]
	push	dword ptr es:[bx+8]
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 
   ;	   tempWnd = NextWindow (tempWnd);
   ;	
	push	dword ptr [bp-4]
@78@142:
	call	near ptr MGRP:_NextWindow
	add	sp,4
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
	mov	eax,dword ptr [bp-4]
	cmp	eax,dword ptr [bp+4]
	jne	short @78@114
@78@198:
   ;	
   ;	  }
   ;	 
   ;	 }
   ;	 
   ;	 DestroyControl (dmWnd);
   ;	
	push	dword ptr [bp+4]
	call	near ptr MGRP:_DestroyControl
	add	sp,4
   ;	
   ;	
   ;	 topWnd = dmWnd->prev;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+12]
	mov	dword ptr MGRP:topWnd,eax
   ;	
   ;	
   ;	 if (is_full_app == 1) CloseFullApp ();
   ;	
	cmp	byte ptr MGRP:is_full_app,1
	jne	short @78@254
	call	near ptr MGRP:_CloseFullApp
@78@254:
   ;	
   ;	
   ;	 SysBuf.byte1 = WINDOW_DESTROY;
   ;	
	mov	byte ptr MGRP:_SysBuf+1,176
   ;	
   ;	 if (dmWnd->WinMain != 0) (dmWnd->WinMain) ();
   ;	
	les	bx,dword ptr [bp+4]
	cmp	dword ptr es:[bx+16],large 0
	je	short @78@310
	call	dword ptr es:[bx+16]
@78@310:
   ;	
   ;	
   ;	 if (dmWnd->form != 0) HiMemoryFree (dmWnd->form);
   ;	
	les	bx,dword ptr [bp+4]
	cmp	dword ptr es:[bx+8],large 0
	je	short @78@366
	push	dword ptr es:[bx+8]
	call	near ptr MGRP:_HiMemoryFree
	add	sp,4
@78@366:
   ;	
   ;	 
   ;	 dm = (unsigned int) ( (unsigned long)(dmWnd) >> 16 );
   ;	
	mov	eax,dword ptr [bp+4]
	shr	eax,16
	mov	word ptr [bp-6],ax
   ;	
   ;	 free (dm);
   ;	
	push	ax
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	
   ;	
   ;	 if ( topWnd == (HWND)0 )
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	jne	short @78@422
   ;	
   ;	 {
   ;	  activeButton = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeButton,large 0
   ;	
   ;	  activeEditBox = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeEditBox,large 0
   ;	
   ;	  return;
   ;	
	jmp	@78@646
@78@422:
   ;	
   ;	 }
   ;	
   ;	 tempControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	
   ;	 if ( tempControl->ControlType == CONTROL_TYPE_EDITBOX)
   ;	
	les	bx,dword ptr MGRP:tempControl
	cmp	byte ptr es:[bx+8],2
	jne	short @78@478
   ;	
   ;	  activeEditBox = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr MGRP:_activeEditBox,eax
	jmp	short @78@506
@78@478:
   ;	
   ;	 else
   ;	  activeEditBox = FindLastEditBox (topWnd);
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_FindLastEditBox
	add	sp,4
	mov	word ptr MGRP:_activeEditBox+2,dx
	mov	word ptr MGRP:_activeEditBox,ax
@78@506:
   ;	
   ;	
   ;	 if ( tempControl->ControlType == CONTROL_TYPE_BUTTON)
   ;	
	les	bx,dword ptr MGRP:tempControl
	cmp	byte ptr es:[bx+8],1
	jne	short @78@562
   ;	
   ;	  activeButton = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:_activeButton,eax
	jmp	short @78@590
@78@562:
   ;	
   ;	 else
   ;	  activeButton = FindLastButton (topWnd);
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_FindLastButton
	add	sp,4
	mov	word ptr MGRP:_activeButton+2,dx
	mov	word ptr MGRP:_activeButton,ax
@78@590:
   ;	
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	 if (activeEditBox != (CONTROL)0)
   ;	
	cmp	dword ptr MGRP:_activeEditBox,large 0
	je	short @78@646
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,activeEditBox->StrSegment,activeEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:_activeEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  Line (activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		activeEditBox->y+5,
   ;		activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		activeEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:_activeEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@78@646:
   ;	
   ;	 }
   ;	
   ;	
   ;	// tempControl = topWnd->ActiveControl;
   ;	}
   ;	
	leave	
	ret	
_DestroyWindow	endp
   ;	
   ;	void DestroyAllWindows (void)
   ;	
	assume	cs:MGRP
_DestroyAllWindows	proc	near
	jmp	short @79@86
@79@30:
   ;	
   ;	{
   ;	
   ;	 while ( topWnd != (HWND)0 )
   ;	 {
   ;	  if (topWnd == protectedWnd) return;
   ;	
	mov	eax,dword ptr MGRP:topWnd
	cmp	eax,dword ptr MGRP:protectedWnd
	je	short @79@114
   ;	
   ;	  DestroyWindow (topWnd);
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
@79@86:
	cmp	dword ptr MGRP:topWnd,large 0
	jne	short @79@30
@79@114:
   ;	
   ;	 }
   ;	 
   ;	
   ;	}
   ;	
	ret	
_DestroyAllWindows	endp
   ;	
   ;	void SwitchWindow (HWND vhWnd)
   ;	
	assume	cs:MGRP
_SwitchWindow	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	{
   ;	 //CONTROL LastEditBox;
   ;	 unsigned int mret;
   ;	
   ;	 if (is_full_app == 1) return;
   ;	
	cmp	byte ptr MGRP:is_full_app,1
	jne short	@@17
	jmp	@80@478
@@17:
   ;	
   ;	
   ;	 if (vhWnd == topWnd) return;
   ;	
	mov	eax,dword ptr [bp+4]
	cmp	eax,dword ptr MGRP:topWnd
	jne short	@@18
	jmp	@80@478
@@18:
   ;	
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 if (topWnd->form == 0)
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+8],large 0
	jne	short @80@142
   ;	
   ;	  topWnd->form = save_area (topWnd->x,topWnd->y,topWnd->w-8,topWnd->h);
   ;	
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr es:[bx+8],eax
	jmp	@80@170
@80@142:
   ;	
   ;	 else
   ;	 {
   ;	  mret = malloc ( (imagesize (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h) >> 4) + 1 );
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_imagesize
	add	sp,8
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	di,ax
   ;	
   ;	  getimage (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h,mret);
   ;	
	push	ax
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_getimage
	add	sp,10
   ;	
   ;	  himem_write (mret,0,topWnd->form,imagesize (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h) );
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_imagesize
	add	sp,8
	movzx	eax,ax
	push	eax
	les	bx,dword ptr MGRP:topWnd
	push	dword ptr es:[bx+8]
	push	0
	push	di
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	  free (mret);
   ;	
	push	di
	call	near ptr MGRP:_free
	pop	cx
@80@170:
   ;	
   ;	 }
   ;	
   ;	  if (activeEditBox != (CONTROL)0 )
   ;	
	cmp	dword ptr MGRP:_activeEditBox,large 0
	je	short @80@226
   ;	
   ;	  {
   ;	   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString,activeEditBox->StrSegment,activeEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:_activeEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   Line (activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		activeEditBox->y+5,
   ;		activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		activeEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:_activeEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@80@226:
   ;	
   ;	  }
   ;	
   ;	 restore_area (vhWnd->x,vhWnd->y,vhWnd->w-8,vhWnd->h,vhWnd->form,0);
   ;	
	push	0
	les	bx,dword ptr [bp+4]
	push	dword ptr es:[bx+8]
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	
   ;	 (NextWindow (vhWnd))->prev = vhWnd->prev;
   ;	
	push	dword ptr [bp+4]
	call	near ptr MGRP:_NextWindow
	add	sp,4
	les	bx,dword ptr [bp+4]
	mov	cx,word ptr es:[bx+14]
	mov	bx,word ptr es:[bx+12]
	mov	si,ax
	mov	es,dx
	mov	word ptr es:[si+14],cx
	mov	word ptr es:[si+12],bx
   ;	
   ;	
   ;	 vhWnd->prev = topWnd;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr MGRP:topWnd
	mov	dword ptr es:[bx+12],eax
   ;	
   ;	 topWnd = vhWnd;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr MGRP:topWnd,eax
   ;	
   ;	
   ;	  //LastEditBox = activeEditBox; //FindLastEditBox (topWnd);
   ;	
   ;	 tempControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	 if ( tempControl->ControlType == CONTROL_TYPE_EDITBOX)
   ;	
	les	bx,dword ptr MGRP:tempControl
	cmp	byte ptr es:[bx+8],2
	jne	short @80@282
   ;	
   ;	  activeEditBox = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr MGRP:_activeEditBox,eax
	jmp	short @80@310
@80@282:
   ;	
   ;	 else
   ;	  activeEditBox = FindLastEditBox (topWnd);
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_FindLastEditBox
	add	sp,4
	mov	word ptr MGRP:_activeEditBox+2,dx
	mov	word ptr MGRP:_activeEditBox,ax
@80@310:
   ;	
   ;	
   ;	 tempControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	 if ( tempControl->ControlType == CONTROL_TYPE_BUTTON)
   ;	
	les	bx,dword ptr MGRP:tempControl
	cmp	byte ptr es:[bx+8],1
	jne	short @80@366
   ;	
   ;	  activeButton = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr MGRP:_activeButton,eax
	jmp	short @80@394
@80@366:
   ;	
   ;	 else
   ;	  activeButton = FindLastButton (topWnd);
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_FindLastButton
	add	sp,4
	mov	word ptr MGRP:_activeButton+2,dx
	mov	word ptr MGRP:_activeButton,ax
@80@394:
   ;	
   ;	
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	 if (activeEditBox != (CONTROL)0)
   ;	
	cmp	dword ptr MGRP:_activeEditBox,large 0
	je	short @80@450
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,activeEditBox->StrSegment,activeEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:_activeEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  Line (activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		activeEditBox->y+5,
   ;		activeEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		activeEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:_activeEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:_activeEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@80@450:
   ;	
   ;	 }
   ;	
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@80@478:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_SwitchWindow	endp
   ;	
   ;	void TurnWindow (void)
   ;	
	assume	cs:MGRP
_TurnWindow	proc	near
   ;	
   ;	{
   ;	 if (topWnd == (HWND)0) return;
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	je	short @81@114
   ;	
   ;	 if (topWnd->prev == (HWND)0) return;
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+12],large 0
	je	short @81@114
   ;	
   ;	 if (is_full_app) return;
   ;	
	cmp	byte ptr MGRP:is_full_app,0
	jne	short @81@114
   ;	
   ;	 SwitchWindow ( NextWindow ( (HWND)0 ) );
   ;	
	push	large 0
	call	near ptr MGRP:_NextWindow
	add	sp,4
	push	dx
	push	ax
	call	near ptr MGRP:_SwitchWindow
	add	sp,4
@81@114:
   ;	
   ;	}
   ;	
	ret	
_TurnWindow	endp
   ;	
   ;	void MoveWindow (void)
   ;	
	assume	cs:MGRP
_MoveWindow	proc	near
	enter	12,0
	push	si
	push	di
   ;	
   ;	{
   ;	 unsigned int mret;
   ;	 unsigned int Wx,Wy;
   ;	 unsigned int deltax,deltay;
   ;	 unsigned int oldWx,oldWy;
   ;	
   ;	 Wx = topWnd->x; oldWx = Wx;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	di,word ptr es:[bx]
	mov	word ptr [bp-10],di
   ;	
   ;	 Wy = topWnd->y; oldWy = Wy;
   ;	
	mov	ax,word ptr es:[bx+2]
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-12],ax
   ;	
   ;	 MouseX = mx; MouseY = my;
   ;	
	mov	ax,word ptr MGRP:mx
	mov	word ptr MGRP:MouseX,ax
	mov	ax,word ptr MGRP:my
	mov	word ptr MGRP:MouseY,ax
   ;	
   ;	 deltax = MouseX - Wx;
   ;	
	mov	ax,word ptr MGRP:MouseX
	sub	ax,di
	mov	word ptr [bp-6],ax
   ;	
   ;	 deltay = MouseY - Wy;
   ;	
	mov	ax,word ptr MGRP:MouseY
	sub	ax,word ptr [bp-4]
	mov	word ptr [bp-8],ax
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 MouseB = 1;
   ;	
	mov	word ptr MGRP:MouseB,1
	jmp	@82@674
@82@58:
   ;	
   ;	 while ( MouseB == 1 )
   ;	 {
   ;	  if ( (oldWx != Wx) || (oldWy != Wy) )
   ;	
	cmp	word ptr [bp-10],di
	jne	short @82@114
	mov	ax,word ptr [bp-12]
	cmp	ax,word ptr [bp-4]
	je	short @82@142
@82@114:
   ;	
   ;	  {
   ;	   XORRectangle (oldWx,oldWy,oldWx+topWnd->w,oldWy+topWnd->h);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr [bp-12]
	add	ax,word ptr es:[bx+6]
	push	ax
	mov	ax,word ptr [bp-10]
	add	ax,word ptr es:[bx+4]
	push	ax
	push	word ptr [bp-12]
	push	word ptr [bp-10]
	call	near ptr MGRP:_XORRectangle
	add	sp,8
   ;	
   ;	   XORRectangle (Wx,Wy,Wx+topWnd->w,Wy+topWnd->h);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr [bp-4]
	add	ax,word ptr es:[bx+6]
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx+4]
	push	ax
	push	word ptr [bp-4]
	push	di
	call	near ptr MGRP:_XORRectangle
	add	sp,8
@82@142:
   ;	
   ;	  }
   ;	  oldWx = Wx; oldWy = Wy;
   ;	
	mov	word ptr [bp-10],di
	mov	ax,word ptr [bp-4]
	mov	word ptr [bp-12],ax
   ;	
   ;	  asm {
   ;	       push ax
   ;	
	push	 ax
   ;	
   ;	       push bx
   ;	
	push	 bx
   ;	
   ;	       push cx
   ;	
	push	 cx
   ;	
   ;	       push dx
   ;	
	push	 dx
   ;	
   ;	       mov cx,0
   ;	
	mov	 cx,0
   ;	
   ;	       mov dx,0x3d09
   ;	
	mov	 dx,03d09H
   ;	
   ;	       mov ah,0x86
   ;	
	mov	 ah,086H
   ;	
   ;	       int 0x15
   ;	
	int	 015H
   ;	
   ;	       mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;	       int 0x33
   ;	
	int	 033H
   ;	
   ;	       mov cs:MouseX,cx
   ;	
	mov	 cs:MouseX,cx
   ;	
   ;	       mov cs:MouseY,dx
   ;	
	mov	 cs:MouseY,dx
   ;	
   ;	       mov cs:MouseB,bx
   ;	
	mov	 cs:MouseB,bx
   ;	
   ;	       pop dx
   ;	
	pop	 dx
   ;	
   ;	       pop cx
   ;	
	pop	 cx
   ;	
   ;	       pop bx
   ;	
	pop	 bx
   ;	
   ;	       pop ax
   ;	
	pop	 ax
   ;	
   ;	      }
   ;	  Wx = MouseX - deltax; Wy = MouseY - deltay;
   ;	
	mov	di,word ptr MGRP:MouseX
	sub	di,word ptr [bp-6]
	mov	ax,word ptr MGRP:MouseY
	sub	ax,word ptr [bp-8]
	mov	word ptr [bp-4],ax
@82@674:
	cmp	word ptr MGRP:MouseB,1
	jne short	@@19
	jmp	@82@58
@@19:
   ;	
   ;	 }
   ;	   XORRectangle (topWnd->x,topWnd->y,topWnd->x+topWnd->w,topWnd->y+topWnd->h);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_XORRectangle
	add	sp,8
   ;	
   ;	   XORRectangle (oldWx,oldWy,oldWx+topWnd->w,oldWy+topWnd->h);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr [bp-12]
	add	ax,word ptr es:[bx+6]
	push	ax
	mov	ax,word ptr [bp-10]
	add	ax,word ptr es:[bx+4]
	push	ax
	push	word ptr [bp-12]
	push	word ptr [bp-10]
	call	near ptr MGRP:_XORRectangle
	add	sp,8
   ;	
   ;	 
   ;	 if (topWnd->form == 0)
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+8],large 0
	jne	short @82@758
   ;	
   ;	  topWnd->form = save_area (topWnd->x,topWnd->y,topWnd->w-8,topWnd->h);
   ;	
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	les	bx,dword ptr MGRP:topWnd
	mov	dword ptr es:[bx+8],eax
	jmp	@82@786
@82@758:
   ;	
   ;	 else
   ;	 { 
   ;	  mret = malloc ( (imagesize (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h) >> 4) + 1 );
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_imagesize
	add	sp,8
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;	  getimage (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h,mret);
   ;	
	push	ax
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_getimage
	add	sp,10
   ;	
   ;	  himem_write (mret,0,topWnd->form,imagesize (topWnd->x,topWnd->y,topWnd->x+topWnd->w-8,topWnd->y+topWnd->h) );
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	mov	es,word ptr MGRP:topWnd+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_imagesize
	add	sp,8
	movzx	eax,ax
	push	eax
	les	bx,dword ptr MGRP:topWnd
	push	dword ptr es:[bx+8]
	push	0
	push	word ptr [bp-2]
	call	near ptr MGRP:_himem_write
	add	sp,12
   ;	
   ;	  free (mret);
   ;	
	push	word ptr [bp-2]
	call	near ptr MGRP:_free
	pop	cx
@82@786:
   ;	
   ;	 }
   ;	
   ;	
   ;	
   ;	 SetColor (backc);
   ;	
	push	word ptr MGRP:_backc
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 waitretrace ();
   ;	
	call	near ptr MGRP:_waitretrace
   ;	
   ;	 fastbar (topWnd->x,topWnd->y,topWnd->w+topWnd->x,topWnd->h+topWnd->y);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+6]
	add	ax,word ptr es:[bx+2]
	push	ax
	mov	ax,word ptr es:[bx+4]
	add	ax,word ptr es:[bx]
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_fastbar
	add	sp,8
   ;	
   ;	 dumWnd = NextWindow ((HWND)0);
   ;	
	push	large 0
	jmp	short @82@842
@82@814:
   ;	
   ;	
   ;	 while (dumWnd != topWnd)
   ;	 {
   ;	  waitretrace ();
   ;	
	call	near ptr MGRP:_waitretrace
   ;	
   ;	  restore_area (dumWnd->x,dumWnd->y,dumWnd->w-8,dumWnd->h,dumWnd->form,0);
   ;	
	push	0
	les	bx,dword ptr MGRP:dumWnd
	push	dword ptr es:[bx+8]
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	  dumWnd = NextWindow (dumWnd);
   ;	
	push	dword ptr MGRP:dumWnd
@82@842:
	call	near ptr MGRP:_NextWindow
	add	sp,4
	mov	word ptr MGRP:dumWnd+2,dx
	mov	word ptr MGRP:dumWnd,ax
	mov	eax,dword ptr MGRP:dumWnd
	cmp	eax,dword ptr MGRP:topWnd
	jne	short @82@814
   ;	
   ;	 }
   ;	 Wx = (( (Wx >> 3) + 1) << 3);
   ;	
	shr	di,3
	inc	di
	shl	di,3
   ;	
   ;	 dumControl = topWnd->LastControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+24]
@82@926:
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	 while (1)
   ;	 {
   ;	  tempControl = dumControl->prev;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	eax,dword ptr es:[bx+14]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	  dumControl->x = (dumControl->x - topWnd->x) + Wx;
   ;	
	mov	ax,word ptr es:[bx]
	les	bx,dword ptr MGRP:topWnd
	sub	ax,word ptr es:[bx]
	add	ax,di
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx],ax
   ;	
   ;	  dumControl->y = (dumControl->y - topWnd->y) + Wy;
   ;	
	mov	ax,word ptr es:[bx+2]
	les	bx,dword ptr MGRP:topWnd
	sub	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp-4]
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+2],ax
   ;	
   ;	
   ;	  if (dumControl == topWnd->FirstControl) break;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+20]
	cmp	eax,dword ptr MGRP:dumControl
	je	short @82@1010
   ;	
   ;	  dumControl = tempControl;
   ;	
	mov	eax,dword ptr MGRP:tempControl
	jmp	short @82@926
@82@1010:
   ;	
   ;	 }
   ;	 topWnd->x = Wx; topWnd->y = Wy;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	word ptr es:[bx],di
	mov	ax,word ptr [bp-4]
	mov	word ptr es:[bx+2],ax
   ;	
   ;	 restore_area (Wx,Wy,topWnd->w-8,topWnd->h,topWnd->form,0);
   ;	
	push	0
	push	dword ptr es:[bx+8]
	push	word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	sub	ax,8
	push	ax
	push	word ptr [bp-4]
	push	di
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_MoveWindow	endp
   ;	
   ;	void MessageBox (char* Msg)
   ;	
	assume	cs:MGRP
_MessageBox	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	 unsigned int Lg;
   ;	 Lg = ( (strlen (Msg) * 8) / 2 );
   ;	
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	cwd	
	sub	ax,dx
	mov	di,ax
	sar	di,1
   ;	
   ;	 CreateWindow (320-Lg-15,200,(Lg*2)+20,50,3,Msg);
   ;	
	push	si
	push	3
	push	50
	mov	ax,di
	shl	ax,1
	add	ax,20
	push	ax
	push	200
	mov	ax,320
	sub	ax,di
	sub	ax,15
	push	ax
	call	near ptr MGRP:_CreateWindow
	add	sp,12
   ;	
   ;	 OutTextXY ( 320 - Lg,220,Msg);
   ;	
	push	si
	push	220
	mov	ax,320
	sub	ax,di
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_MessageBox	endp
   ;	
   ;	void mouse_handler ()
   ;	
	assume	cs:MGRP
_mouse_handler	proc	near
   ;	
   ;	{
   ;	 asm cli
   ;	
 	cli	
   ;	
   ;	 asm { push ax bx cx dx ds };
   ;	
 	push	 ax bx cx dx ds 
   ;	
   ;	 asm { mov ax,cs
   ;	
 	mov	 ax,cs
   ;	
   ;	       mov ds,ax }
   ;	
	mov	 ds,ax 
   ;	
   ;	
   ;	 if (mouse_status)
   ;	
	cmp	word ptr MGRP:mouse_status,0
	jne short	@@20
	jmp	@84@422
@@20:
   ;	
   ;	 {
   ;	
   ;	 mx = _CX;
   ;	
	mov	word ptr MGRP:mx,cx
   ;	
   ;	 my = _DX;
   ;	
	mov	word ptr MGRP:my,dx
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	mov	word ptr MGRP:i,0
	jmp	short @84@254
@84@170:
   ;	
   ;	  {
   ;	    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @84@226
	mov	bx,word ptr MGRP:i
	mov	al,byte ptr MGRP:swap[bx]
	push	ax
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:oldy
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:oldx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@84@226:
	inc	word ptr MGRP:i
@84@254:
	cmp	word ptr MGRP:i,27
	jle	short @84@170
   ;	
   ;	  }
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	mov	word ptr MGRP:i,0
	jmp	short @84@366
@84@310:
   ;	
   ;	  {
   ;	     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
   ;	
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_getpix
	add	sp,4
	mov	bx,word ptr MGRP:i
	mov	byte ptr MGRP:swap[bx],al
   ;	
   ;	     setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
   ;	
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+2]
	push	ax
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr MGRP:i
@84@366:
	cmp	word ptr MGRP:i,27
	jle	short @84@310
   ;	
   ;	  }
   ;	
   ;	  flag = 1;
   ;	
	mov	word ptr MGRP:flag,1
   ;	
   ;	  oldx = mx;
   ;	
	mov	ax,word ptr MGRP:mx
	mov	word ptr MGRP:oldx,ax
   ;	
   ;	  oldy = my;
   ;	
	mov	ax,word ptr MGRP:my
	mov	word ptr MGRP:oldy,ax
@84@422:
   ;	
   ;	 }
   ;	 asm { pop ds dx cx bx ax };
   ;	
 	pop	 ds dx cx bx ax 
   ;	
   ;	 asm sti
   ;	
 	sti	
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_mouse_handler	endp
   ;	
   ;	unsigned int ismouse (void)
   ;	
	assume	cs:MGRP
_ismouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	       mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;	       int 0x33
   ;	
	int	 033H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_ismouse	endp
   ;	
   ;	void showmouse ()
   ;	
	assume	cs:MGRP
_showmouse	proc	near
	push	si
   ;	
   ;	{
   ;	 register int i;
   ;	
   ;	 if ( ismouse()  != 0xffff) return;
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	je short	@@21
	jmp	@86@226
@@21:
   ;	
   ;	
   ;	 mx = oldx; my = oldy;
   ;	
	mov	ax,word ptr MGRP:oldx
	mov	word ptr MGRP:mx,ax
	mov	ax,word ptr MGRP:oldy
	mov	word ptr MGRP:my,ax
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	xor	si,si
	jmp	short @86@170
@86@86:
   ;	
   ;	  {
   ;	     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
   ;	
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_getpix
	add	sp,4
	mov	byte ptr MGRP:swap[si],al
   ;	
   ;	     if (flag) setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @86@142
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+2]
	push	ax
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@86@142:
	inc	si
@86@170:
	cmp	si,27
	jle	short @86@86
   ;	
   ;	  }
   ;	
   ;	 mouse_status = 1;
   ;	
	mov	word ptr MGRP:mouse_status,1
@86@226:
   ;	
   ;	// show_mouse = 1;
   ;	}
   ;	
	pop	si
	ret	
_showmouse	endp
   ;	
   ;	void hidemouse ()
   ;	
	assume	cs:MGRP
_hidemouse	proc	near
	push	si
   ;	
   ;	{
   ;	 register int i;
   ;	
   ;	 if ( ismouse()  != 0xffff) return;
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @87@226
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	xor	si,si
	jmp	short @87@170
@87@86:
   ;	
   ;	  {
   ;	    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @87@142
	mov	al,byte ptr MGRP:swap[si]
	push	ax
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:oldy
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:oldx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@87@142:
	inc	si
@87@170:
	cmp	si,27
	jle	short @87@86
   ;	
   ;	  }
   ;	 mouse_status = 0;
   ;	
	mov	word ptr MGRP:mouse_status,0
   ;	
   ;	 flag = 0;
   ;	
	mov	word ptr MGRP:flag,0
@87@226:
   ;	
   ;	// show_mouse = 0;
   ;	}
   ;	
	pop	si
	ret	
_hidemouse	endp
   ;	
   ;	void init_mouse (unsigned int x,unsigned int y)
   ;	
	assume	cs:MGRP
_init_mouse	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push ax bx cx es
   ;	
	push	 ax bx cx es
   ;	
   ;		mov ax,4
   ;	
	mov	 ax,4
   ;	
   ;		mov bx,x
   ;	
	mov	 bx,[bp+4]
   ;	
   ;		mov cx,y
   ;	
	mov	 cx,[bp+6]
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		mov ax,5
   ;	
	mov	 ax,5
   ;	
   ;		mov bx,1
   ;	
	mov	 bx,1
   ;	
   ;		mov cx,1
   ;	
	mov	 cx,1
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ax,1
   ;	
	mov	 ax,1
   ;	
   ;		mov bx,offset MGRP:_mouse_handler
   ;	
	mov	 bx,offset MGRP:_mouse_handler
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		mov ax,6
   ;	
	mov	 ax,6
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		pop es cx bx ax
   ;	
	pop	 es cx bx ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_init_mouse	endp
   ;	
   ;	void shut_mouse (void)
   ;	
	assume	cs:MGRP
_shut_mouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ax,2
   ;	
	mov	 ax,2
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		mov ax,7
   ;	
	mov	 ax,7
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_shut_mouse	endp
   ;	
   ;	char scankey (void)
   ;	
	assume	cs:MGRP
_scankey	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		in al,0x60
   ;	
	in	 al,060H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_scankey	endp
   ;	
   ;	unsigned int bmouse (void)
   ;	
	assume	cs:MGRP
_bmouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	    mov cx,0
   ;	
	mov	 cx,0
   ;	
   ;	    mov dx,0x3d09
   ;	
	mov	 dx,03d09H
   ;	
   ;	    mov ah,0x86
   ;	
	mov	 ah,086H
   ;	
   ;	    int 0x15
   ;	
	int	 015H
   ;	
   ;		mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;		int 0x33
   ;	
	int	 033H
   ;	
   ;		mov ax,bx
   ;	
	mov	 ax,bx
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_bmouse	endp
_gs	label	byte
	db	0
	db	4
	db	2
	db	6
	db	1
	db	5
	db	3
	db	8
	db	7
	db	12
	db	10
	db	14
	db	9
	db	13
	db	11
	db	15
   ;	
   ;	char IsMask (unsigned int pos)
   ;	
	assume	cs:MGRP
_IsMask	proc	near
	push	bp
	mov	bp,sp
	mov	dx,word ptr [bp+4]
   ;	
   ;	{
   ;	 return ( (*IcoPix) [512+126+(pos / 8)] & ( 128 >> (pos % 8) ) );
   ;	
	mov	ax,dx
	shr	ax,3
	add	ax,638
	les	bx,dword ptr MGRP:_IcoPix
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	cl,dl
	and	cl,7
	mov	dx,128
	sar	dx,cl
	and	al,dl
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_IsMask	endp
   ;	
   ;	void ShowIcon (unsigned int x, unsigned int y, char* icofile)
   ;	
	assume	cs:MGRP
_ShowIcon	proc	near
	enter	8,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 unsigned int i,j;
   ;	 unsigned char IcoColor;
   ;	 unsigned char shift;
   ;	 unsigned int pos;
   ;	
   ;	 IcoMem = malloc ( (1024 / 16) );
   ;	
	push	64
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_IcoMem,ax
   ;	
   ;	 icoFile = fopen (icofile);
   ;	
	push	word ptr [bp+8]
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_icoFile,eax
   ;	
   ;	 fread (icoFile,1024,0,IcoMem);
   ;	
	push	word ptr MGRP:_IcoMem
	push	0
	push	large 1024
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 IcoPix [0] = (unsigned char far*) (IcoMem * 65536);
   ;	
	movzx	eax,word ptr MGRP:_IcoMem
	shl	eax,16
	shld	edx,eax,16
	mov	word ptr MGRP:_IcoPix+2,dx
	mov	word ptr MGRP:_IcoPix,ax
   ;	
   ;	 y += 32;
   ;	
	add	di,32
   ;	
   ;	 j = x;
   ;	
	mov	word ptr [bp-4],si
   ;	
   ;	 pos = 0;
   ;	
	mov	word ptr [bp-8],0
   ;	
   ;	
   ;	 for (i=0; i<=511; i++)
   ;	
	mov	word ptr [bp-2],0
	jmp	short @93@254
@93@58:
   ;	
   ;	 {
   ;	   IcoColor = (*IcoPix) [126+i];
   ;	
	mov	ax,word ptr [bp-2]
	add	ax,126
	les	bx,dword ptr MGRP:_IcoPix
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-5],al
   ;	
   ;	
   ;	
   ;	   if (!IsMask (pos++)) setpix (x,y,gs[(IcoColor >> 4)]);
   ;	
	mov	ax,word ptr [bp-8]
	inc	word ptr [bp-8]
	push	ax
	call	near ptr MGRP:_IsMask
	pop	cx
	cbw	
	or	ax,ax
	jne	short @93@114
	mov	al,byte ptr [bp-5]
	mov	ah,0
	sar	ax,4
	mov	bx,ax
	mov	al,byte ptr MGRP:_gs[bx]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
@93@114:
   ;	
   ;	   x++;
   ;	
	inc	si
   ;	
   ;	   if (!IsMask (pos++)) setpix (x,y,gs[(IcoColor & 0x0f)]);
   ;	
	mov	ax,word ptr [bp-8]
	inc	word ptr [bp-8]
	push	ax
	call	near ptr MGRP:_IsMask
	pop	cx
	cbw	
	or	ax,ax
	jne	short @93@170
	mov	al,byte ptr [bp-5]
	mov	ah,0
	and	ax,15
	mov	bx,ax
	mov	al,byte ptr MGRP:_gs[bx]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
@93@170:
   ;	
   ;	   x++;
   ;	
	inc	si
   ;	
   ;	
   ;	   if (x==(j+32))
   ;	
	mov	ax,word ptr [bp-4]
	add	ax,32
	cmp	ax,si
	jne	short @93@226
   ;	
   ;	   {
   ;	    y--;
   ;	
	dec	di
   ;	
   ;	    x = j;
   ;	
	mov	si,word ptr [bp-4]
@93@226:
	inc	word ptr [bp-2]
@93@254:
	cmp	word ptr [bp-2],511
	jbe	short @93@58
   ;	
   ;	   }
   ;	 }
   ;	 free (IcoMem);
   ;	
	push	word ptr MGRP:_IcoMem
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_ShowIcon	endp
   ;	
   ;	char pic_peek (unsigned int ofs)
   ;	
	assume	cs:MGRP
_pic_peek	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		mov ax,mpic
   ;	
	mov	 ax,mpic
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov bx,ofs
   ;	
	mov	 bx,[bp+4]
   ;	
   ;		mov al,es:[bx]
   ;	
	mov	 al,es:[bx]
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_pic_peek	endp
   ;	
   ;	void pic (char* picname, int h)
   ;	
	assume	cs:MGRP
_pic	proc	near
	enter	8,0
	push	si
	push	di
   ;	
   ;	{
   ;	handle stream;
   ;	
   ;	unsigned int pici=0;
   ;	
   ;	
   ;	unsigned int picx,picy;
   ;	signed char picj=0;
   ;	
   ;	
   ;	unsigned char pixel;
   ;	
   ;	 
   ;	 if (gmode == 1) picx = 160;
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @95@86
	mov	si,160
	jmp	short @95@114
@95@86:
   ;	
   ;	 else picx = 240 ;
   ;	
	mov	si,240
@95@114:
   ;	
   ;	 picy = h+200;   
   ;	
	mov	di,word ptr [bp+6]
	add	di,200
   ;	
   ;	 mpic = malloc (504);
   ;	
	push	504
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:mpic,ax
   ;	
   ;	 stream = fopen (picname);
   ;	
	push	word ptr [bp+4]
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	 if (stream < 2) return;
   ;	
	cmp	dword ptr [bp-4],large 2
	jae short	@@22
	jmp	@95@534
@@22:
   ;	
   ;	 fread (stream,8062,0,mpic);
   ;	
	push	word ptr MGRP:mpic
	push	0
	push	large 8062
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 for (pici=0;pici<=(8000-1);pici++)
   ;	
	mov	word ptr [bp-6],0
	jmp	short @95@478
@95@170:
   ;	
   ;	 {
   ;	  for (picj=0;picj<=7;picj++)
   ;	
	mov	byte ptr [bp-7],0
	jmp	short @95@422
@95@198:
   ;	
   ;	   {
   ;	    pixel = (pic_peek(pici+62) & (128>>picj));
   ;	
	mov	ax,word ptr [bp-6]
	add	ax,62
	push	ax
	call	near ptr MGRP:_pic_peek
	pop	cx
	mov	dx,128
	mov	cl,byte ptr [bp-7]
	sar	dx,cl
	and	al,dl
	mov	byte ptr [bp-8],al
   ;	
   ;	    if (!pixel) setpix (picx,picy, 7);
   ;	
	mov	ah,0
	or	ax,ax
	jne	short @95@254
	push	7
	push	di
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
@95@254:
   ;	
   ;	    picx++;
   ;	
	inc	si
   ;	
   ;	    if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @95@338
   ;	
   ;	    {
   ;	     if (picx==480) { picy--;picx=160;}
   ;	
	cmp	si,480
	jne	short @95@394
	dec	di
	mov	si,160
	jmp	short @95@394
@95@338:
   ;	
   ;	    }
   ;	    else if (picx == 560) { picy--;picx=240; }
   ;	
	cmp	si,560
	jne	short @95@394
	dec	di
	mov	si,240
@95@394:
	inc	byte ptr [bp-7]
@95@422:
	cmp	byte ptr [bp-7],7
	jle	short @95@198
	inc	word ptr [bp-6]
@95@478:
	cmp	word ptr [bp-6],7999
	jbe	short @95@170
   ;	
   ;	   }
   ;	  }
   ;	 free (mpic);
   ;	
	push	word ptr MGRP:mpic
	call	near ptr MGRP:_free
	pop	cx
@95@534:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_pic	endp
   ;	
   ;	void ShowMem (void)
   ;	
	assume	cs:MGRP
_ShowMem	proc	near
   ;	
   ;	{
   ;	 CreateWindow (120,120,290,105,3,"Memory Usage");
   ;	
	push	offset MGRP:s@+33
	push	3
	push	large 000690122h
	push	large 000780078h
	call	near ptr MGRP:_CreateWindow
	add	sp,12
   ;	
   ;	/*
   ;	 SetColor (7);
   ;	 Bar (145,150,405,165);
   ;	 Bar (145,180,405,195);
   ;	*/
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 OutTextXY (145,147+2-2,"Real Memory");
   ;	
	push	offset MGRP:s@+46
	push	large 000930091h
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 OutTextXY (145,181+2-2,"High Memory");
   ;	
	push	offset MGRP:s@+58
	push	large 000B50091h
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 Rectangle (145,160,405,175);
   ;	
	push	large 000AF0195h
	push	large 000A00091h
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Rectangle (145,195,405,210);
   ;	
	push	large 000D20195h
	push	large 000C30091h
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (145,175,405,175);
   ;	
	push	large 000AF0195h
	push	large 000AF0091h
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (405,160,405,175);
   ;	
	push	large 000AF0195h
	push	large 000A00195h
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (145,210,405,210);
   ;	
	push	large 000D20195h
	push	large 000D20091h
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (405,195,405,210);
   ;	
	push	large 000D20195h
	push	large 000C30195h
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (9);
   ;	
	push	9
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (146,161,146+ ( (260 * (avail()<<4)) / 0x70000 ),174);
   ;	
	push	174
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	shl	eax,4
	imul	eax,large 260
	mov	ebx,large 000070000h
	xor	edx,edx
	div	ebx
	add	ax,146
	push	ax
	push	large 000A10092h
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 Bar (146,196,146+ ( (260 * GetHiMemoryAvail ()) / HiMemoryAvailable () ),209);
   ;	
	push	209
	call	near ptr MGRP:_GetHiMemoryAvail
	imul	ax,ax,260
	push	ax
	call	near ptr MGRP:_HiMemoryAvailable
	xor	dx,dx
	mov	bx,ax
	pop	ax
	div	bx
	add	ax,146
	push	ax
	push	large 000C40092h
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	}
   ;	
	ret	
_ShowMem	endp
   ;	
   ;	int popup (int argc, char far* argv [], int x, int y, int w)
   ;	
	assume	cs:MGRP
_popup	proc	near
	enter	10,0
	push	si
	push	di
	mov	si,word ptr [bp+8]
	mov	di,word ptr [bp+10]
   ;	
   ;	{                        
   ;	 int i,j;
   ;	 char k;
   ;	 unsigned long mbuf;
   ;	
   ;	 x = (( (x >> 3) + 1) << 3);
   ;	
	sar	si,3
	inc	si
	shl	si,3
   ;	
   ;	 w = (( (w >> 3) + 1) << 3);
   ;	
	mov	ax,word ptr [bp+12]
	sar	ax,3
	inc	ax
	shl	ax,3
	mov	word ptr [bp+12],ax
   ;	
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 setFont (1);
   ;	
	push	1
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 mbuf = save_area (x,y,w,(argc*16)+2);
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,4
	add	ax,2
	push	ax
	push	word ptr [bp+12]
	push	di
	push	si
	call	near ptr MGRP:_save_area
	push	dx
	push	ax
	pop	eax
	add	sp,8
	mov	dword ptr [bp-10],eax
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (x,y,w+x,y+(argc*16)+2);
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,word ptr [bp+12]
	add	ax,si
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (x,y,w+x,y);
   ;	
	push	di
	mov	ax,word ptr [bp+12]
	add	ax,si
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x,y,x,y+(argc*16)+2);
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	push	si
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (x,y+(argc*16)+2,w+x,y+(argc*16)+2);
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,word ptr [bp+12]
	add	ax,si
	push	ax
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x+w,y,x+w,y+(argc*16)+2);
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	push	ax
	push	di
	mov	ax,si
	add	ax,word ptr [bp+12]
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	 for (i=0; i< (argc-1); i++)
   ;	
	mov	word ptr [bp-2],0
	jmp	short @97@114
@97@58:
   ;	
   ;	 {
   ;	  Line (x+1,y+17+(i*16),x+w-1,y+17+(i*16));
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,17
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,17
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+1,y+18+(i*16),x+w-1,y+18+(i*16));
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,18
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,18
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
	inc	word ptr [bp-2]
@97@114:
	mov	ax,word ptr [bp+4]
	dec	ax
	cmp	ax,word ptr [bp-2]
	jg	short @97@58
   ;	
   ;	 }
   ;	
   ;	 for (i=0; i<argc; i++)
   ;	
	mov	word ptr [bp-2],0
	jmp	@97@366
@97@170:
   ;	
   ;	  if (argv[i][0] == '#') { SetColor (8);
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne	short @97@254
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;				   FarOutTextXY (x+4,y+2+(i*16),argv[i]+1);
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx]
	inc	ax
	push	word ptr [bx+2]
	push	ax
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
@97@226:
	add	sp,8
   ;	
   ;				   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;				 }
   ;	
	jmp	@97@338
@97@254:
   ;	
   ;	  else if (argv[i][0] == '-' ) {
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],45
	jne	short @97@310
   ;	
   ;				    SetColor (8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;				    Line (x,y+8+(i*16),x+w-1,y+8+(i*16));
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,8
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,8
	push	dx
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;				    SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;				    Line (x,y+9+(i*16),x+w-1,y+9+(i*16));
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,9
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,9
	push	dx
	push	si
	call	near ptr MGRP:_Line
	jmp	@97@226
@97@310:
   ;	
   ;				    SetColor (0);
   ;				  }
   ;	  else FarOutTextXY (x+4,y+2+(i*16),argv[i]);
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	push	dword ptr [bx]
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
@97@338:
	inc	word ptr [bp-2]
@97@366:
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr [bp+4]
	jge short	@@23
	jmp	@97@170
@@23:
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (x+1,y+3,x+w-1,y+16);
   ;	
	mov	ax,di
	add	ax,16
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,di
	add	ax,3
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	// SetColor (15);
   ;	// Line (x+1,y+2,x+w-1,y+2);
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (x+1,y+16,x+w-1,y+16);
   ;	
	mov	ax,di
	add	ax,16
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,di
	add	ax,16
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 FarOutTextXY (x+4,y+2,argv[0]);
   ;	
	mov	bx,word ptr [bp+6]
	push	dword ptr [bx]
	mov	ax,di
	add	ax,2
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
   ;	
   ;	 j = 0; k = 72;
   ;	
	mov	word ptr [bp-4],0
	mov	byte ptr [bp-5],72
	jmp	@97@1710
@97@422:
   ;	
   ;	 showmouse ();
   ;	 while ( (k == 72) || (k==80) )
   ;	 {
   ;	   if ( (bmouse () == 1) && (mouse_status) )
   ;	
	call	near ptr MGRP:_bmouse
	cmp	ax,1
	je short	@@24
	jmp	@97@1066
@@24:
	cmp	word ptr MGRP:mouse_status,0
	jne short	@@25
	jmp	@97@1066
@@25:
   ;	
   ;	   {
   ;	     if ( (mx > x) && (my > y) && (mx < x+w) && (my < (y+(argc*16)+2) ) )
   ;	
	cmp	word ptr MGRP:mx,si
	jg short	@@26
	jmp	@97@1794
@@26:
	cmp	word ptr MGRP:my,di
	jg short	@@27
	jmp	@97@1794
@@27:
	mov	ax,si
	add	ax,word ptr [bp+12]
	cmp	ax,word ptr MGRP:mx
	jg short	@@28
	jmp	@97@1794
@@28:
	mov	ax,word ptr [bp+4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	cmp	dx,word ptr MGRP:my
	jg short	@@29
	jmp	@97@1794
@@29:
   ;	
   ;	     {
   ;	      for (i=0; i<argc; i++)
   ;	
	mov	word ptr [bp-2],0
	jmp	@97@1038
@97@618:
   ;	
   ;	      if (  (my > (y+(i*16)+1)) && (my < (y+(i*16)+16) ) )
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	inc	dx
	cmp	dx,word ptr MGRP:my
	jl short	@@30
	jmp	@97@1010
@@30:
	mov	ax,word ptr [bp-2]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	cmp	dx,word ptr MGRP:my
	jg short	@@31
	jmp	@97@1010
@@31:
   ;	
   ;	      {
   ;	       if ( (argv[i][0] != '#') && (argv[i][0] != '-') )
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne short	@@32
	jmp	@97@1010
@@32:
	mov	ax,word ptr [bp-2]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	bx,word ptr [bx]
	cmp	byte ptr es:[bx],45
	jne short	@@33
	jmp	@97@1010
@@33:
   ;	
   ;	       {
   ;		k = 28;
   ;	
	mov	byte ptr [bp-5],28
   ;	
   ;			   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;			   SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   Bar (x+1,y+3+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,3
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;			   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   if (argv[j][0] == '#') { SetColor (8);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne	short @97@786
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;						    FarOutTextXY (x+4,y+2+(j*16),argv[j]+1); }
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx]
	inc	ax
	push	word ptr [bx+2]
	push	ax
	jmp	short @97@814
@97@786:
   ;	
   ;			   else FarOutTextXY (x+4,y+2+(j*16),argv[j]);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	push	dword ptr [bx]
@97@814:
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
   ;	
   ;			   j = i;
   ;	
	mov	ax,word ptr [bp-2]
	mov	word ptr [bp-4],ax
   ;	
   ;			   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   Bar (x+1,y+3+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,3
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;			// SetColor (15);
   ;			// Line (x+1,y+2+(j*16),x+w-1,y+2+(j*16));
   ;			 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			 Line (x+1,y+16+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;			   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   if (argv[j][0] == '#') { SetColor (8);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne	short @97@926
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;						    FarOutTextXY (x+4,y+2+(j*16),argv[j]+1); }
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx]
	inc	ax
	push	word ptr [bx+2]
	push	ax
@97@898:
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
	jmp	short @97@954
@97@926:
   ;	
   ;			   else FarOutTextXY (x+4,y+2+(j*16),argv[j]);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	push	dword ptr [bx]
	jmp	short @97@898
@97@954:
   ;	
   ;		 while ( bmouse () == 1);
   ;	
	call	near ptr MGRP:_bmouse
	cmp	ax,1
	je	short @97@954
   ;	
   ;			   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;			   showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@97@1010:
	inc	word ptr [bp-2]
@97@1038:
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr [bp+4]
	jge short	@@34
	jmp	@97@618
@@34:
@97@1066:
   ;	
   ;	       }
   ;	      }
   ;	     } else break; //k = 0;
   ;	
   ;	
   ;	   }
   ;	
   ;	   if ( is_key () )
   ;	
	call	near ptr MGRP:_is_key
	or	al,al
	jne short	@@35
	jmp	@97@1738
@@35:
   ;	
   ;	   {
   ;	    k = getch ();
   ;	
	call	near ptr MGRP:_getch
	mov	byte ptr [bp-5],al
   ;	
   ;	    if ( (k==72) || (k==80) )
   ;	
	cmp	byte ptr [bp-5],72
	je	short @97@1150
	cmp	byte ptr [bp-5],80
	je short	@@36
	jmp	@97@1738
@@36:
@97@1150:
   ;	
   ;	    {
   ;			   SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;			   Bar (x+1,y+3+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,3
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;			   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   if (argv[j][0] == '#') { SetColor (8);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne	short @97@1206
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;						    FarOutTextXY (x+4,y+2+(j*16),argv[j]+1); }
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx]
	inc	ax
	push	word ptr [bx+2]
	push	ax
	jmp	short @97@1234
@97@1206:
   ;	
   ;			   else FarOutTextXY (x+4,y+2+(j*16),argv[j]);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	push	dword ptr [bx]
@97@1234:
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
   ;	
   ;	     if ( k == 72 ) {
   ;	
	cmp	byte ptr [bp-5],72
	jne	short @97@1430
   ;	
   ;			    if (!j) j = (argc - 1);
   ;	
	cmp	word ptr [bp-4],0
	jne	short @97@1346
	mov	ax,word ptr [bp+4]
	dec	ax
	mov	word ptr [bp-4],ax
	jmp	short @97@1374
@97@1346:
   ;	
   ;			    else j--;
   ;	
	dec	word ptr [bp-4]
@97@1374:
   ;	
   ;			    if (argv[j][0] == '-') j--;
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],45
	jne	short @97@1430
	dec	word ptr [bp-4]
@97@1430:
   ;	
   ;			  }
   ;	     if ( k == 80 ) {
   ;	
	cmp	byte ptr [bp-5],80
	jne	short @97@1598
   ;	
   ;			   if (j == (argc-1) ) j = 0;
   ;	
	mov	ax,word ptr [bp+4]
	dec	ax
	cmp	ax,word ptr [bp-4]
	jne	short @97@1514
	mov	word ptr [bp-4],0
	jmp	short @97@1542
@97@1514:
   ;	
   ;			   else j++;
   ;	
	inc	word ptr [bp-4]
@97@1542:
   ;	
   ;			    if (argv[j][0] == '-') j++;
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],45
	jne	short @97@1598
	inc	word ptr [bp-4]
@97@1598:
   ;	
   ;			  }
   ;			   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   Bar (x+1,y+3+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,3
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;			 //SetColor (15);
   ;			 //Line (x+1,y+2+(j*16),x+w-1,y+2+(j*16));
   ;			 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			 Line (x+1,y+16+(j*16),x+w-1,y+16+(j*16));
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	add	ax,word ptr [bp+12]
	dec	ax
	push	ax
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,16
	push	dx
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;			   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;			   if (argv[j][0] == '#') { SetColor (8);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	les	bx,dword ptr [bx]
	cmp	byte ptr es:[bx],35
	jne	short @97@1654
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;						    FarOutTextXY (x+4,y+2+(j*16),argv[j]+1); }
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	mov	ax,word ptr [bx]
	inc	ax
	push	word ptr [bx+2]
	push	ax
	jmp	short @97@1682
@97@1654:
   ;	
   ;			   else FarOutTextXY (x+4,y+2+(j*16),argv[j]);
   ;	
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	bx,word ptr [bp+6]
	add	bx,ax
	push	dword ptr [bx]
@97@1682:
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,di
	add	dx,ax
	add	dx,2
	push	dx
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
@97@1710:
   ;	
   ;			   showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@97@1738:
	cmp	byte ptr [bp-5],72
	jne short	@@37
	jmp	@97@422
@@37:
	cmp	byte ptr [bp-5],80
	jne short	@@38
	jmp	@97@422
@@38:
@97@1794:
   ;	
   ;	    }
   ;	   }
   ;	  }
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	
   ;	 restore_area (x,y,w,(argc*16)+2,mbuf,1);
   ;	
	push	1
	push	dword ptr [bp-10]
	mov	ax,word ptr [bp+4]
	shl	ax,4
	add	ax,2
	push	ax
	push	word ptr [bp+12]
	push	di
	push	si
	call	near ptr MGRP:_restore_area
	add	sp,14
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	 if (k == 28) return (j+1);
   ;	
	cmp	byte ptr [bp-5],28
	jne	short @97@1850
	mov	ax,word ptr [bp-4]
	inc	ax
	jmp	short @97@1878
@97@1850:
   ;	
   ;	 else return 0;
   ;	
	xor	ax,ax
@97@1878:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_popup	endp
   ;	
   ;	char ReadKey (void)
   ;	
	assume	cs:MGRP
_ReadKey	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	  mov ah,18h
   ;	
	mov	 ah,18h
   ;	
   ;	  int 44h
   ;	
	int	 44h
   ;	
   ;	  mov keycode,ah
   ;	
	mov	 keycode,ah
   ;	
   ;	 }
   ;	}
   ;	
	ret	
_ReadKey	endp
   ;	
   ;	void DispText (unsigned int ofs, unsigned int x, unsigned int y,
   ;	
	assume	cs:MGRP
_DispText	proc	near
	enter	4,0
	push	si
	push	di
	mov	di,word ptr [bp+16]
	mov	si,word ptr [bp+18]
   ;	
   ;		       unsigned int w, unsigned int h,unsigned int SizeB,
   ;		       unsigned int X, unsigned int Y, char update, char cr)
   ;	{
   ;	 unsigned int i,oldY,oldX;
   ;	
   ;	// X = x+5; Y = y+5;
   ;	 oldY = Y; oldX = X;
   ;	
	mov	word ptr [bp-4],si
   ;	
   ;	
   ;	 for (i = ofs; i <= SizeB; i++)
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr [bp-2],ax
	jmp	@99@786
@99@58:
   ;	
   ;	 {
   ;	
   ;	  if ( FarTABuffer [i] == 13)
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-2]
	cmp	byte ptr es:[bx],13
	je short	@@39
	jmp	@99@478
@@39:
   ;	
   ;	  {
   ;	   if ( (update == 2) )
   ;	
	cmp	byte ptr [bp+20],2
	jne	short @99@198
   ;	
   ;	   {
   ;	    SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	    Bar (X,Y,X+8,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,di
	add	ax,8
	push	ax
	push	si
	push	di
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	    if ( (oldY == Y) && (!cr) && (X < (x+w-9-8)) )
   ;	
	cmp	word ptr [bp-4],si
	jne	short @99@198
	mov	al,byte ptr [bp+22]
	cbw	
	or	ax,ax
	jne	short @99@198
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,9
	sub	ax,8
	cmp	ax,di
	jbe short	@@40
	jmp	@99@814
@@40:
@99@198:
   ;	
   ;	    {
   ;	     break;
   ;	    }
   ;	   }
   ;	
   ;	   if ( (update==1) && (oldY == Y) ) break;
   ;	
	cmp	byte ptr [bp+20],1
	jne	short @99@254
	cmp	word ptr [bp-4],si
	jne short	@@41
	jmp	@99@814
@@41:
@99@254:
   ;	
   ;	   else if ( (update==1)  && (X != x+5)) break;
   ;	
	cmp	byte ptr [bp+20],1
	jne	short @99@310
	mov	ax,word ptr [bp+6]
	add	ax,5
	cmp	ax,di
	je short	@@42
	jmp	@99@814
@@42:
@99@310:
   ;	
   ;	   else if ( (update ==1) && (X==x+5) )
   ;	
	cmp	byte ptr [bp+20],1
	jne	short @99@394
	mov	ax,word ptr [bp+6]
	add	ax,5
	cmp	ax,di
	jne	short @99@394
   ;	
   ;	   {
   ;	    scroll_down (x,Y,w,h-(Y-y)-18,16);
   ;	
	push	16
	mov	ax,si
	sub	ax,word ptr [bp+8]
	mov	dx,word ptr [bp+12]
	sub	dx,ax
	sub	dx,18
	push	dx
	push	word ptr [bp+10]
	push	si
	push	word ptr [bp+6]
	call	near ptr MGRP:_scroll_down
	add	sp,10
   ;	
   ;	    SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	    Bar (x+1,Y,x+w-3,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,3
	push	ax
	push	si
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	    break;
   ;	
	jmp	@99@814
@99@394:
   ;	
   ;	   }
   ;	   else
   ;	   {
   ;	    if (update)
   ;	
	cmp	byte ptr [bp+20],0
	je	short @99@450
   ;	
   ;	    {
   ;	     SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	     Bar (X,Y,x+w-3,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,3
	push	ax
	push	si
	push	di
	call	near ptr MGRP:_Bar
	add	sp,8
@99@450:
   ;	
   ;	    }
   ;	    X = x+5;
   ;	
	mov	di,word ptr [bp+6]
	add	di,5
	jmp	@99@674
@99@478:
   ;	
   ;	   }
   ;	  }
   ;	  else if (FarTABuffer [i] == 10)
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-2]
	cmp	byte ptr es:[bx],10
	jne	short @99@534
   ;	
   ;	  {
   ;	   Y = Y + 16;
   ;	
	add	si,16
   ;	
   ;	  }
   ;	
	jmp	short @99@674
@99@534:
   ;	
   ;	  else if (FarTABuffer [i] == 0)
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-2]
	cmp	byte ptr es:[bx],0
	jne	short @99@590
   ;	
   ;	  {
   ;	   //if (X == x+5)
   ;	    Bar (X,Y,x+w-3,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,3
	push	ax
	push	si
	push	di
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	   //else
   ;	   // Bar (X,Y,X+8,Y+16);
   ;	
   ;	   Y += 16;
   ;	
	add	si,16
   ;	
   ;	   break;
   ;	
	jmp	short @99@814
@99@590:
   ;	
   ;	  }
   ;	  else
   ;	  {
   ;	   if (update)
   ;	
	cmp	byte ptr [bp+20],0
	je	short @99@646
   ;	
   ;	   {
   ;	    SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	    Bar (X,Y,X+8,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,di
	add	ax,8
	push	ax
	push	si
	push	di
	call	near ptr MGRP:_Bar
	add	sp,8
@99@646:
   ;	
   ;	   }
   ;	   PrintChar (FarTABuffer[i],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	si
	push	di
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-2]
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	   X += 8;
   ;	
	add	di,8
@99@674:
   ;	
   ;	  }
   ;	  if ( X >= (x+w-9) )
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,9
	cmp	ax,di
	ja	short @99@730
   ;	
   ;	  {
   ;	   X = x+5;
   ;	
	mov	di,word ptr [bp+6]
	add	di,5
   ;	
   ;	   Y = Y + 16;
   ;	
	add	si,16
@99@730:
   ;	
   ;	  }
   ;	  if ( Y >= (y+5+h-10)) break;
   ;	
	mov	ax,word ptr [bp+8]
	add	ax,word ptr [bp+12]
	add	ax,5
	sub	ax,10
	cmp	ax,si
	jbe	short @99@814
	inc	word ptr [bp-2]
@99@786:
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr [bp+14]
	ja short	@@43
	jmp	@99@58
@@43:
@99@814:
   ;	
   ;	 }
   ;	
   ;	// Y += 16;
   ;	
   ;	
   ;	 if ( (Y < (y+5+h-10)) && (update == 2) && (Y != (oldY) ) )
   ;	
	mov	ax,word ptr [bp+8]
	add	ax,word ptr [bp+12]
	add	ax,5
	sub	ax,10
	cmp	ax,si
	jbe	short @99@926
	cmp	byte ptr [bp+20],2
	jne	short @99@926
	cmp	si,word ptr [bp-4]
	je	short @99@926
   ;	
   ;	 {
   ;	  SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	//  Bar (x+1,Y,x+w-1,y+h-1);
   ;	  Bar (x+1,Y,x+w-3,Y+16);
   ;	
	mov	ax,si
	add	ax,16
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,3
	push	ax
	push	si
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
@99@926:
   ;	
   ;	 }
   ;	
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_DispText	endp
   ;	
   ;	void DelText (unsigned int TextOfs, unsigned int segbuffer,
   ;	
	assume	cs:MGRP
_DelText	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;		      unsigned int sizeB)
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push si
   ;	
	push	 si
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		mov ax,segbuffer
   ;	
	mov	 ax,[bp+6]
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,TextOfs
   ;	
	mov	 si,[bp+4]
   ;	
   ;		mov di,si
   ;	
	mov	 di,si
   ;	
   ;		inc si
   ;	
	inc	 si
   ;	
   ;		mov cx,sizeB
   ;	
	mov	 cx,[bp+8]
   ;	
   ;		sub cx,di
   ;	
	sub	 cx,di
   ;	
   ;		rep movsb
   ;	
	rep movsb	
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_DelText	endp
   ;	
   ;	void InsText (char c, unsigned int TextOfs,unsigned int segbuffer,
   ;	
	assume	cs:MGRP
_InsText	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;		      unsigned int sizeB)
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		push si
   ;	
	push	 si
   ;	
   ;		mov ax,segbuffer
   ;	
	mov	 ax,[bp+8]
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,sizeB
   ;	
	mov	 si,[bp+10]
   ;	
   ;		sub si,2
   ;	
	sub	 si,2
   ;	
   ;		mov di,sizeB
   ;	
	mov	 di,[bp+10]
   ;	
   ;		dec di
   ;	
	dec	 di
   ;	
   ;		mov cx,sizeB
   ;	
	mov	 cx,[bp+10]
   ;	
   ;		sub cx,2
   ;	
	sub	 cx,2
   ;	
   ;		mov ax,TextOfs
   ;	
	mov	 ax,[bp+6]
   ;	
   ;		sub cx,ax
   ;	
	sub	 cx,ax
   ;	
   ;		inc cx
   ;	
	inc	 cx
   ;	
   ;		std
   ;	
	std	
   ;	
   ;		rep movsb
   ;	
	rep movsb	
   ;	
   ;		cld
   ;	
	cld	
   ;	
   ;		mov di,TextOfs
   ;	
	mov	 di,[bp+6]
   ;	
   ;		mov al,c
   ;	
	mov	 al,[bp+4]
   ;	
   ;		mov es:[di],al
   ;	
	mov	 es:[di],al
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_InsText	endp
   ;	
   ;	void send_char (char sc,char scode)
   ;	
	assume	cs:MGRP
_send_char	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		 push ax
   ;	
	push	 ax
   ;	
   ;		 push cx
   ;	
	push	 cx
   ;	
   ;		 mov ah,5
   ;	
	mov	 ah,5
   ;	
   ;		 mov ch,scode
   ;	
	mov	 ch,[bp+6]
   ;	
   ;		 mov cl,sc
   ;	
	mov	 cl,[bp+4]
   ;	
   ;		 int 0x16
   ;	
	int	 016H
   ;	
   ;		 pop cx
   ;	
	pop	 cx
   ;	
   ;		 pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_send_char	endp
   ;	
   ;	unsigned int TextArea (unsigned int x, unsigned int y, unsigned int w,
   ;	
	assume	cs:MGRP
_TextArea	proc	near
	enter	14,0
	push	si
	push	di
	mov	dx,word ptr [bp+14]
   ;	
   ;		       unsigned int h, unsigned int StrSeg, unsigned int StrOfs,
   ;		       unsigned int SizeB)
   ;	
   ;	{
   ;	// unsigned int MemText;
   ;	 unsigned int X, Y;
   ;	 char l;
   ;	 unsigned int i,oldi;
   ;	 unsigned char tad;
   ;	 unsigned int oldX,oldY;
   ;	 char cr;
   ;	
   ;	//w = w - 5;
   ;	
   ;	if (StrOfs == 1234)
   ;	
	cmp	dx,1234
	jne	short @103@86
   ;	
   ;	{
   ;	 SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 fastbar (x,y,x+w-5,y+h);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,5
	push	ax
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr MGRP:_fastbar
	add	sp,8
   ;	
   ;	// FarTABuffer = (StrSeg * 65536) + StrOfs;
   ;	 FarTABuffer [SizeB] = 0;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp+16]
	mov	byte ptr es:[bx],0
   ;	
   ;	 DispText (0,x,y,w,h,SizeB,x+5,y+5,3,0);
   ;	
	push	0
	push	3
	mov	ax,word ptr [bp+6]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,5
	push	ax
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	push	0
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;	 return;
   ;	
	jmp	@103@3054
@103@86:
   ;	
   ;	}
   ;	
   ;	 FarTABuffer = (StrSeg * 65536) + StrOfs;
   ;	
	movzx	eax,word ptr [bp+12]
	shl	eax,16
	movzx	edx,dx
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr MGRP:_FarTABuffer+2,dx
	mov	word ptr MGRP:_FarTABuffer,ax
   ;	
   ;	// X = x+5; Y = y+5;
   ;	
   ;	 i = aci;
   ;	
	mov	di,word ptr MGRP:_aci
   ;	
   ;	 X = acX;
   ;	
	mov	si,word ptr MGRP:_acX
   ;	
   ;	 Y = acY;
   ;	
	mov	ax,word ptr MGRP:_acY
	mov	word ptr [bp-2],ax
   ;	
   ;	
   ;	 PrintChar ('_',X,Y+1,COLOR_U,255,0);
   ;	
	push	0
	push	255
	push	4
	inc	ax
	push	ax
	push	si
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	 l = 0;
   ;	
   ;	
   ;	 keycode = 0;
   ;	
	mov	byte ptr MGRP:keycode,0
	jmp	@103@2998
@103@114:
   ;	
   ;	
   ;	 while ( keycode != 1 )
   ;	 {
   ;	  l = ReadKey ();
   ;	
	call	near ptr MGRP:_ReadKey
	mov	byte ptr [bp-3],al
   ;	
   ;	
   ;	  PrintChar ('_',X,Y+1,COLOR_B,255,0);
   ;	
	push	0
	push	255
	push	15
	mov	ax,word ptr [bp-2]
	inc	ax
	push	ax
	push	si
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	
   ;	  switch (keycode)
   ;	
	mov	al,byte ptr MGRP:keycode
	cbw	
	mov	word ptr [bp-14],ax
	mov	cx,8
	mov	bx,offset @103@C114
@103@198:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-14]
	je	short @103@282
	add	bx,2
	loop	short @103@198
	jmp	@103@2886
@103@282:
	jmp	word ptr cs:[bx+16]
	jmp	@103@2970
@103@310:
   ;	
   ;	  {
   ;	   case 1: break;
   ;	
   ;	   case 75:
   ;	   if (i == 0) break;
   ;	
	or	di,di
	jne short	@@44
	jmp	@103@2970
@@44:
   ;	
   ;	
   ;	    if (X == x+5)
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,5
	cmp	ax,si
	je short	@@45
	jmp	@103@1934
@@45:
   ;	
   ;	    {
   ;	     if ( FarTABuffer [i-1] != 10 )
   ;	
	mov	ax,di
	dec	ax
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	cmp	byte ptr es:[bx],10
	jne short	@@46
	jmp	@103@590
@@46:
   ;	
   ;	     {
   ;	      i--;
   ;	
	dec	di
   ;	
   ;	      Y -= 16;
   ;	
	sub	word ptr [bp-2],16
   ;	
   ;	      X = x + 5 + ( (w/8) - 2) * 8;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	ax,2
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,5
   ;	
   ;	
   ;	      if ( Y == (y+5-16))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,5
	sub	ax,16
	cmp	ax,word ptr [bp-2]
	je short	@@47
	jmp	@103@2970
@@47:
   ;	
   ;	      {
   ;	       scroll_down (x,y+1,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_down
	add	sp,10
   ;	
   ;	       SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	       Bar (x+1,y+5,x+w-3,y+16+5);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	       SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	       Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	       tad = (w/8)-2;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	al,2
	mov	byte ptr [bp-7],al
   ;	
   ;	//       DispText (i-tad,x,y,w,h,i-tad+(w/8),x+5,Y,1,0);
   ;	
   ;	       X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	       for (oldi = i-tad; ((X < (x+w-9)) && (FarTABuffer [oldi] != 13)) ; X += 8)
   ;	
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	mov	word ptr [bp-6],dx
	jmp	short @103@506
@103@450:
   ;	
   ;		PrintChar (FarTABuffer[oldi++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,word ptr [bp-6]
	inc	word ptr [bp-6]
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	add	si,8
@103@506:
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	jbe	short @103@562
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-6]
	cmp	byte ptr es:[bx],13
	jne	short @103@450
@103@562:
   ;	
   ;	       X = x + 5 + ( (w/8) - 2) * 8;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	ax,2
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	jmp	@103@2858
@103@590:
   ;	
   ;	      }
   ;	
   ;	      break;
   ;	     }
   ;	
   ;	     for ( tad = 0;((FarTABuffer [i-3-tad] != 10) && (i-2-tad != 0)); tad++) ;
   ;	
	mov	byte ptr [bp-7],0
	jmp	short @103@646
@103@618:
	inc	byte ptr [bp-7]
@103@646:
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,3
	sub	dx,ax
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,dx
	cmp	byte ptr es:[bx],10
	je	short @103@702
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,2
	sub	dx,ax
	or	dx,dx
	jne	short @103@618
@103@702:
   ;	
   ;	
   ;	     if ( tad > ((w/8)-2) ) tad = (tad % ((w/8)-1) ) ;
   ;	
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,word ptr [bp+8]
	shr	dx,3
	sub	dx,2
	cmp	ax,dx
	jbe	short @103@758
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,word ptr [bp+8]
	shr	dx,3
	dec	dx
	push	ax
	push	dx
	xor	dx,dx
	pop	bx
	pop	ax
	div	bx
	mov	byte ptr [bp-7],dl
@103@758:
   ;	
   ;		       // =
   ;	     X = x+5+(tad * 8);
   ;	
	mov	al,byte ptr [bp-7]
	mov	ah,0
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,5
   ;	
   ;	     Y -= 16;
   ;	
	sub	word ptr [bp-2],16
   ;	
   ;	     i -= 2;
   ;	
	sub	di,2
   ;	
   ;	
   ;	      if ( Y == (y+5-16))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,5
	sub	ax,16
	cmp	ax,word ptr [bp-2]
	je short	@@48
	jmp	@103@2970
@@48:
   ;	
   ;	      {
   ;	      scroll_down (x,y+1,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_down
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+5,x+w-3,y+16+5);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	      DispText (i-tad,x,y,w,h,i-tad+(w/8),x+5,Y,1,0);
   ;	
	push	0
	push	1
	push	word ptr [bp-2]
	mov	ax,word ptr [bp+4]
	add	ax,5
	push	ax
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	mov	ax,word ptr [bp+8]
	shr	ax,3
	add	dx,ax
	push	dx
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	push	dx
	jmp	@103@2634
	jmp	@103@1934
@103@842:
   ;	
   ;	
   ;	      }
   ;	
   ;	
   ;	     break;
   ;	    }
   ;	
   ;	    else
   ;	    {
   ;	     X -= 8;
   ;	     i--;
   ;	     break;
   ;	    }
   ;	   case 77:
   ;	    if ( FarTABuffer [i] == 0) break;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],0
	jne short	@@49
	jmp	@103@2970
@@49:
   ;	
   ;	
   ;	    if ( X >= (x+w-9-8 ) )
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	sub	ax,8
	cmp	ax,si
	jbe short	@@50
	jmp	@103@1066
@@50:
   ;	
   ;	    {
   ;	     X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	     Y = Y + 16;
   ;	
	mov	ax,word ptr [bp-2]
	add	ax,16
	mov	word ptr [bp-2],ax
   ;	
   ;	     i++;
   ;	
	inc	di
   ;	
   ;	
   ;	     oldi = i;
   ;	
	mov	word ptr [bp-6],di
   ;	
   ;	     if ( Y >= (y+5+h-10))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	add	ax,5
	sub	ax,10
	cmp	ax,word ptr [bp-2]
	jbe short	@@51
	jmp	@103@2970
@@51:
   ;	
   ;	     {
   ;	      scroll_up (x,y+18,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,18
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+h-16,x+w-3,y+h-1);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,16
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y = Y - 16;
   ;	
	mov	ax,word ptr [bp-2]
	sub	ax,16
	mov	word ptr [bp-2],ax
@103@954:
   ;	
   ;	      while (1)
   ;	      {
   ;	       if ( X >= (x+w-9) ) break;
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	ja short	@@52
	jmp	@103@1234
@@52:
   ;	
   ;	       if (FarTABuffer [i] == 13) break;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],13
	jne short	@@53
	jmp	@103@1234
@@53:
   ;	
   ;	       PrintChar (FarTABuffer[i++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,di
	inc	di
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	       X = X + 8;
   ;	
	add	si,8
	jmp	short @103@954
	jmp	@103@1234
@103@1066:
   ;	
   ;	      }
   ;	      X = x+5;
   ;	      i = oldi;
   ;	     }
   ;	     break;
   ;	    }
   ;	    if ( FarTABuffer [i] == 13 )
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],13
	je short	@@54
	jmp	@103@1262
@@54:
   ;	
   ;	    {
   ;	     X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	     Y = Y + 16;
   ;	
	mov	ax,word ptr [bp-2]
	add	ax,16
	mov	word ptr [bp-2],ax
   ;	
   ;	     i += 2;
   ;	
	add	di,2
   ;	
   ;	     oldi = i;
   ;	
	mov	word ptr [bp-6],di
   ;	
   ;	     if ( Y >= (y+5+h-10))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	add	ax,5
	sub	ax,10
	cmp	ax,word ptr [bp-2]
	jbe short	@@55
	jmp	@103@2970
@@55:
   ;	
   ;	     {
   ;	      scroll_up (x,y+18,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,18
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+h-16,x+w-3,y+h-1);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,16
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y = Y - 16;
   ;	
	mov	ax,word ptr [bp-2]
	sub	ax,16
	mov	word ptr [bp-2],ax
@103@1150:
   ;	
   ;	      while (1)
   ;	      {
   ;	       if ( X >= (x+w-9) ) break;
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	jbe	short @103@1234
   ;	
   ;	       if (FarTABuffer [i] == 13) break;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],13
	je	short @103@1234
   ;	
   ;	       PrintChar (FarTABuffer[i++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,di
	inc	di
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	       X = X + 8;
   ;	
	add	si,8
	jmp	short @103@1150
@103@1234:
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	      }
   ;	      X = x+5;
   ;	      i = oldi;
   ;	
	mov	di,word ptr [bp-6]
	jmp	@103@2970
@103@1262:
   ;	
   ;	     }
   ;	     break;
   ;	    }
   ;	    else
   ;	    {
   ;	     X += 8;
   ;	
	add	si,8
   ;	
   ;	     i++;
   ;	
	inc	di
   ;	
   ;	     break;
   ;	
	jmp	@103@2970
@103@1290:
   ;	
   ;	    }
   ;	
   ;	
   ;	   case 72:
   ;	    oldX = X; oldY = Y; oldi = 0;
   ;	
	mov	word ptr [bp-10],si
	mov	ax,word ptr [bp-2]
	mov	word ptr [bp-12],ax
	mov	word ptr [bp-6],0
@103@1318:
   ;	
   ;	
   ;	    while (1)
   ;	    {
   ;	
   ;	     if ( i == 0) break;
   ;	
	or	di,di
	jne short	@@56
	jmp	@103@2970
@@56:
   ;	
   ;	
   ;	     if ( (X == oldX) && ( (Y == (oldY-16)) || (oldi) ) ) break;
   ;	
	cmp	si,word ptr [bp-10]
	jne	short @103@1430
	mov	ax,word ptr [bp-12]
	sub	ax,16
	cmp	ax,word ptr [bp-2]
	jne short	@@57
	jmp	@103@2970
@@57:
	cmp	word ptr [bp-6],0
	je short	@@58
	jmp	@103@2970
@@58:
@103@1430:
   ;	
   ;	
   ;	     if ( X == (x+5) )
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,5
	cmp	ax,si
	je short	@@59
	jmp	@103@1962
@@59:
   ;	
   ;	     {
   ;	
   ;	      if ( FarTABuffer [i-1] != 10 )
   ;	
	mov	ax,di
	dec	ax
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	cmp	byte ptr es:[bx],10
	jne short	@@60
	jmp	@103@1682
@@60:
   ;	
   ;	      {
   ;	       i--;
   ;	
	dec	di
   ;	
   ;	       Y -= 16;
   ;	
	sub	word ptr [bp-2],16
   ;	
   ;	       X = x + 5 + ( (w/8) - 2) * 8;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	ax,2
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,5
   ;	
   ;	
   ;	       if ( Y == (y+5-16))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,5
	sub	ax,16
	cmp	ax,word ptr [bp-2]
	je short	@@61
	jmp	@103@1962
@@61:
   ;	
   ;	       {
   ;		scroll_down (x,y+1,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_down
	add	sp,10
   ;	
   ;		SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;		Bar (x+1,y+5,x+w-3,y+16+5);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;		SetColor (COLOR_F);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;		Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;		tad = (w/8)-2;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	al,2
	mov	byte ptr [bp-7],al
   ;	
   ;	//        DispText (i-tad-1,x,y,w,h,i-tad+(w/8),x+5,Y,1,0);
   ;	
   ;		X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;		for (oldi = i-tad; ((X < (x+w-9)) && (FarTABuffer [oldi] != 13)) ; X += 8)
   ;	
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	mov	word ptr [bp-6],dx
	jmp	short @103@1598
@103@1542:
   ;	
   ;		 PrintChar (FarTABuffer[oldi++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,word ptr [bp-6]
	inc	word ptr [bp-6]
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	add	si,8
@103@1598:
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	jbe	short @103@1654
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-6]
	cmp	byte ptr es:[bx],13
	jne	short @103@1542
@103@1654:
   ;	
   ;		X = x + 5 + ( (w/8) - 2) * 8;
   ;	
	mov	ax,word ptr [bp+8]
	shr	ax,3
	sub	ax,2
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,5
   ;	
   ;	
   ;		oldi = 1;
   ;	
	mov	word ptr [bp-6],1
	jmp	@103@1962
@103@1682:
   ;	
   ;	       }
   ;	
   ;	      }
   ;	      else
   ;	      {
   ;	       Y -= 16;
   ;	
	sub	word ptr [bp-2],16
   ;	
   ;	       for ( tad = 0;((FarTABuffer [i-3-tad] != 10) && (i-2-tad != 0)); tad++) ;
   ;	
	mov	byte ptr [bp-7],0
	jmp	short @103@1738
@103@1710:
	inc	byte ptr [bp-7]
@103@1738:
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,3
	sub	dx,ax
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,dx
	cmp	byte ptr es:[bx],10
	je	short @103@1794
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,2
	sub	dx,ax
	or	dx,dx
	jne	short @103@1710
@103@1794:
   ;	
   ;	       if ( tad >= ((w/8)-2) ) tad = (tad % ((w/8)-1) ) ;
   ;	
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,word ptr [bp+8]
	shr	dx,3
	sub	dx,2
	cmp	ax,dx
	jb	short @103@1850
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,word ptr [bp+8]
	shr	dx,3
	dec	dx
	push	ax
	push	dx
	xor	dx,dx
	pop	bx
	pop	ax
	div	bx
	mov	byte ptr [bp-7],dl
@103@1850:
   ;	
   ;	       X = x+5+(tad * 8)+8;
   ;	
	mov	al,byte ptr [bp-7]
	mov	ah,0
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,13
   ;	
   ;	       i-- ;
   ;	
	dec	di
   ;	
   ;	
   ;	       if ( Y == (y+5-16))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,5
	sub	ax,16
	cmp	ax,word ptr [bp-2]
	je short	@@62
	jmp	@103@1906
@@62:
   ;	
   ;	       {
   ;		scroll_down (x,y+1,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	inc	ax
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_down
	add	sp,10
   ;	
   ;		SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;		Bar (x+1,y+5,x+w-3,y+16+5);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;		SetColor (COLOR_F);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;		Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;		DispText (i-tad-1,x,y,w,h,i-tad+(w/8),x+5,Y,1,0);
   ;	
	push	0
	push	1
	push	word ptr [bp-2]
	mov	ax,word ptr [bp+4]
	add	ax,5
	push	ax
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	mov	ax,word ptr [bp+8]
	shr	ax,3
	add	dx,ax
	push	dx
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	mov	al,byte ptr [bp-7]
	mov	ah,0
	mov	dx,di
	sub	dx,ax
	dec	dx
	push	dx
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;		oldi = 1;
   ;	
	mov	word ptr [bp-6],1
@103@1906:
   ;	
   ;	       }
   ;	
   ;	       if ( X < (oldX+8) )
   ;	
	mov	ax,word ptr [bp-10]
	add	ax,8
	cmp	ax,si
	jbe	short @103@1962
@103@1934:
   ;	
   ;	       {
   ;		X -= 8;
   ;	
	sub	si,8
   ;	
   ;		i--;
   ;	
	dec	di
   ;	
   ;		break;
   ;	
	jmp	@103@2970
@103@1962:
   ;	
   ;	       }
   ;	      }
   ;	     }
   ;	     i--;
   ;	
	dec	di
   ;	
   ;	     X -= 8;
   ;	
	sub	si,8
	jmp	@103@1318
@103@1990:
   ;	
   ;	    }
   ;	    break;
   ;	
   ;	
   ;	   case 14:
   ;	    send_char (0,75); send_char (8,83);
   ;	
	push	75
	push	0
	call	near ptr MGRP:_send_char
	add	sp,4
	push	83
	push	8
	call	near ptr MGRP:_send_char
	add	sp,4
   ;	
   ;	    break;
   ;	
	jmp	@103@2970
@103@2018:
   ;	
   ;	
   ;	
   ;	   case 80:
   ;	    oldX = X; oldY = Y;
   ;	
	mov	word ptr [bp-10],si
	mov	ax,word ptr [bp-2]
	mov	word ptr [bp-12],ax
@103@2046:
   ;	
   ;	    while (1)
   ;	    {
   ;	
   ;	     if ( (X == oldX) && (Y == (oldY+16)) ) break;
   ;	
	cmp	si,word ptr [bp-10]
	jne	short @103@2102
	mov	ax,word ptr [bp-12]
	add	ax,16
	cmp	ax,word ptr [bp-2]
	jne short	@@63
	jmp	@103@2970
@@63:
@103@2102:
   ;	
   ;	     if (FarTABuffer [i] == 0) break;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],0
	jne short	@@64
	jmp	@103@2970
@@64:
   ;	
   ;	
   ;	     X += 8;
   ;	
	add	si,8
   ;	
   ;	
   ;	     if ( FarTABuffer [i] == 13)
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],13
	jne	short @103@2242
   ;	
   ;	     {
   ;	      if ( Y != oldY )
   ;	
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr [bp-12]
	je	short @103@2214
   ;	
   ;	      {
   ;	       X -= 8;
   ;	
	sub	si,8
   ;	
   ;	       //i--;
   ;	       break;
   ;	
	jmp	@103@2970
@103@2214:
   ;	
   ;	      }
   ;	      Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	      X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	      i++;
   ;	
	inc	di
@103@2242:
   ;	
   ;	     }
   ;	
   ;	     if ( X >= (x+w-9) )
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	ja	short @103@2298
   ;	
   ;	     {
   ;	      Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	      X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
@103@2298:
   ;	
   ;	     }
   ;	
   ;	     if ( Y >= (y+5+h-10))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	add	ax,5
	sub	ax,10
	cmp	ax,word ptr [bp-2]
	jbe short	@@65
	jmp	@103@2494
@@65:
   ;	
   ;	     {
   ;	      oldX = X;
   ;	
	mov	word ptr [bp-10],si
   ;	
   ;	      scroll_up (x,y+18,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,18
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+h-16,x+w-3,y+h-1);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,16
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y = Y - 16;
   ;	
	mov	ax,word ptr [bp-2]
	sub	ax,16
	mov	word ptr [bp-2],ax
   ;	
   ;	      i++;
   ;	
	inc	di
   ;	
   ;	      for (oldi = i; ((X < (x+w-9)) && (FarTABuffer [oldi] != 13)) ; X += 8)
   ;	
	mov	word ptr [bp-6],di
	jmp	short @103@2410
@103@2354:
   ;	
   ;	       PrintChar (FarTABuffer[oldi++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,word ptr [bp-6]
	inc	word ptr [bp-6]
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	add	si,8
@103@2410:
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	jbe	short @103@2466
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-6]
	cmp	byte ptr es:[bx],13
	jne	short @103@2354
@103@2466:
   ;	
   ;	      X = oldX;
   ;	
	mov	si,word ptr [bp-10]
   ;	
   ;	      break;
   ;	
	jmp	@103@2970
@103@2494:
   ;	
   ;	     }
   ;	
   ;	     i++;
   ;	
	inc	di
	jmp	@103@2046
@103@2522:
   ;	
   ;	    }
   ;	    break;
   ;	
   ;	   case 83:
   ;	    if (FarTABuffer [i] == 0) break;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],0
	jne short	@@66
	jmp	@103@2970
@@66:
   ;	
   ;	
   ;	    DelText (i,StrSeg,SizeB--);
   ;	
	mov	ax,word ptr [bp+16]
	dec	word ptr [bp+16]
	push	ax
	push	word ptr [bp+12]
	push	di
	call	near ptr MGRP:_DelText
	add	sp,6
   ;	
   ;	    cr = 0;
   ;	
	mov	dl,0
   ;	
   ;	    if (FarTABuffer [i] == 10)
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,di
	cmp	byte ptr es:[bx],10
	jne	short @103@2606
   ;	
   ;	    {
   ;	     DelText (i,StrSeg,SizeB--);
   ;	
	mov	ax,word ptr [bp+16]
	dec	word ptr [bp+16]
	push	ax
	push	word ptr [bp+12]
	push	di
	call	near ptr MGRP:_DelText
	add	sp,6
   ;	
   ;	     cr = 1;
   ;	
	mov	dl,1
@103@2606:
   ;	
   ;	    }
   ;	
   ;	    DispText (i,x,y,w,h,SizeB,X,Y,2,cr);
   ;	
	push	dx
	push	2
	push	word ptr [bp-2]
	push	si
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	push	di
@103@2634:
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;	    break;
   ;	
	jmp	@103@2970
@103@2662:
   ;	
   ;	
   ;	   case 28:
   ;	    InsText (13,i,StrSeg,++SizeB);
   ;	
	inc	word ptr [bp+16]
	mov	ax,word ptr [bp+16]
	push	ax
	push	word ptr [bp+12]
	push	di
	push	13
	call	near ptr MGRP:_InsText
	add	sp,8
   ;	
   ;	    InsText (10,i+1,StrSeg,++SizeB);
   ;	
	inc	word ptr [bp+16]
	mov	ax,word ptr [bp+16]
	push	ax
	push	word ptr [bp+12]
	mov	ax,di
	inc	ax
	push	ax
	push	10
	call	near ptr MGRP:_InsText
	add	sp,8
   ;	
   ;	    DispText (i,x,y,w,h,SizeB,X,Y,3,0);
   ;	
	push	0
	push	3
	push	word ptr [bp-2]
	push	si
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	push	di
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;	    i += 2;
   ;	
	add	di,2
   ;	
   ;	    X = x+5;
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	    Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	
   ;	     if ( Y >= (y+5+h-10))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	add	ax,5
	sub	ax,10
	cmp	ax,word ptr [bp-2]
	jbe short	@@67
	jmp	@103@2970
@@67:
   ;	
   ;	     {
   ;	      scroll_up (x,y+18,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,18
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+h-16,x+w-3,y+h-1);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,16
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y = Y - 16;
   ;	
	mov	ax,word ptr [bp-2]
	sub	ax,16
	mov	word ptr [bp-2],ax
   ;	
   ;	      for (oldi = i; ((X < (x+w-9-8)) && (FarTABuffer [oldi] != 13)) ; X += 8)
   ;	
	mov	word ptr [bp-6],di
	jmp	short @103@2774
@103@2718:
   ;	
   ;	       PrintChar (FarTABuffer[oldi++],X,Y,COLOR_F,255,0);
   ;	
	push	0
	push	255
	push	0
	push	word ptr [bp-2]
	push	si
	mov	ax,word ptr [bp-6]
	inc	word ptr [bp-6]
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
	add	si,8
@103@2774:
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	sub	ax,8
	cmp	ax,si
	jbe	short @103@2830
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp-6]
	cmp	byte ptr es:[bx],13
	jne	short @103@2718
@103@2830:
   ;	
   ;	      X = x+5;
   ;	
	mov	si,word ptr [bp+4]
@103@2858:
	add	si,5
	jmp	@103@2970
@103@2886:
   ;	
   ;	     }
   ;	    break;
   ;	
   ;	   default:
   ;	
   ;	    // if ( l == 0 ) break;
   ;	
   ;	    InsText (l,i,StrSeg,++SizeB);
   ;	
	inc	word ptr [bp+16]
	mov	ax,word ptr [bp+16]
	push	ax
	push	word ptr [bp+12]
	push	di
	mov	al,byte ptr [bp-3]
	push	ax
	call	near ptr MGRP:_InsText
	add	sp,8
   ;	
   ;	    DispText (i,x,y,w,h,SizeB,X,Y,1,0);
   ;	
	push	0
	push	1
	push	word ptr [bp-2]
	push	si
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	push	di
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;	    X += 8;
   ;	
	add	si,8
   ;	
   ;	    i++;
   ;	
	inc	di
   ;	
   ;	
   ;	    if ( X >= (x+w-9) )
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,9
	cmp	ax,si
	ja	short @103@2970
   ;	
   ;	    {
   ;	     X = x+5; 
   ;	
	mov	si,word ptr [bp+4]
	add	si,5
   ;	
   ;	     Y += 16;
   ;	
	add	word ptr [bp-2],16
   ;	
   ;	
   ;	     if ( Y >= (y+5+h-10))
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	add	ax,5
	sub	ax,10
	cmp	ax,word ptr [bp-2]
	ja	short @103@2970
   ;	
   ;	     {
   ;	      scroll_up (x,y+18,w,h-18,16);
   ;	
	push	16
	mov	ax,word ptr [bp+10]
	sub	ax,18
	push	ax
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,18
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_scroll_up
	add	sp,10
   ;	
   ;	      SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Bar (x+1,y+h-16,x+w-3,y+h-1);
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+8]
	sub	ax,3
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr [bp+10]
	sub	ax,16
	push	ax
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	      SetColor (3);
   ;	
	push	3
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      Y = Y - 16;
   ;	
	mov	ax,word ptr [bp-2]
	sub	ax,16
	mov	word ptr [bp-2],ax
@103@2970:
   ;	
   ;	     }
   ;	    }
   ;	
   ;	    break;
   ;	  }
   ;	 
   ;	  PrintChar ('_',X,Y+1,COLOR_U,255,0);
   ;	
	push	0
	push	255
	push	4
	mov	ax,word ptr [bp-2]
	inc	ax
	push	ax
	push	si
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
@103@2998:
	cmp	byte ptr MGRP:keycode,1
	je short	@@68
	jmp	@103@114
@@68:
   ;	
   ;	 }
   ;	 PrintChar ('_',X,Y+1,COLOR_B,255,0);
   ;	
	push	0
	push	255
	push	15
	mov	ax,word ptr [bp-2]
	inc	ax
	push	ax
	push	si
	push	95
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	
   ;	 aci = i;
   ;	
	mov	word ptr MGRP:_aci,di
   ;	
   ;	 acX = X;
   ;	
	mov	word ptr MGRP:_acX,si
   ;	
   ;	 acY = Y;
   ;	
	mov	ax,word ptr [bp-2]
	mov	word ptr MGRP:_acY,ax
   ;	
   ;	
   ;	 return SizeB;
   ;	
	mov	ax,word ptr [bp+16]
@103@3054:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_TextArea	endp
@103@C114	label	word
	db	1
	db	0
	db	14
	db	0
	db	28
	db	0
	db	72
	db	0
	db	75
	db	0
	db	77
	db	0
	db	80
	db	0
	db	83
	db	0
	dw	@103@2970
	dw	@103@1990
	dw	@103@2662
	dw	@103@1290
	dw	@103@310
	dw	@103@842
	dw	@103@2018
	dw	@103@2522
   ;	
   ;	void EditBoxReadLn (unsigned int x, unsigned int y, unsigned int w,
   ;	
	assume	cs:MGRP
_EditBoxReadLn	proc	near
	enter	2,0
	push	si
	push	di
	mov	di,word ptr [bp+6]
   ;	
   ;			    unsigned int StrSeg, unsigned int StrOfs, char c,char pwd)
   ;	{
   ;	 char EditKey;
   ;	 unsigned int Xpos;
   ;	 unsigned char Strpos;
   ;	
   ;	 // SetColor (4); Rectangle ( x,y,x+w,y+16+3);
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 FarEditString = (StrSeg * 65536) + StrOfs;
   ;	
	movzx	eax,word ptr [bp+10]
	shl	eax,16
	movzx	edx,word ptr [bp+12]
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr MGRP:_FarEditString+2,dx
	mov	word ptr MGRP:_FarEditString,ax
   ;	
   ;	 Xpos = x + (Xstrlen (FarEditString)*8) + 5;
   ;	
	push	dx
	push	ax
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	mov	si,word ptr [bp+4]
	add	si,ax
	add	si,5
   ;	
   ;	 Strpos = Xstrlen (FarEditString);
   ;	
	push	dword ptr MGRP:_FarEditString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	byte ptr [bp-2],al
   ;	
   ;	 Line (Xpos,y+5,Xpos,y+16);
   ;	
	mov	ax,di
	add	ax,16
	push	ax
	push	si
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
@104@58:
   ;	
   ;	 do
   ;	 {
   ;	  if (c == 0) EditKey = ReadKey ();
   ;	
	cmp	byte ptr [bp+14],0
	jne	short @104@114
	call	near ptr MGRP:_ReadKey
	jmp	short @104@142
@104@114:
   ;	
   ;	  else EditKey = c;
   ;	
	mov	al,byte ptr [bp+14]
@104@142:
	mov	byte ptr [bp-1],al
   ;	
   ;	
   ;	  if ( (EditKey == 13) || (EditKey == 27) );
   ;	
	cmp	byte ptr [bp-1],13
	jne short	@@69
	jmp	@104@478
@@69:
	cmp	byte ptr [bp-1],27
	jne short	@@70
	jmp	@104@478
@@70:
   ;	
   ;	  else if (EditKey == 8)
   ;	
	cmp	byte ptr [bp-1],8
	je short	@@71
	jmp	@104@310
@@71:
   ;	
   ;	  {
   ;	   if (Xpos == (x+5)) continue;
   ;	
	mov	ax,word ptr [bp+4]
	add	ax,5
	cmp	ax,si
	jne short	@@72
	jmp	@104@478
@@72:
   ;	
   ;	   Xpos -= 8;
   ;	
	sub	si,8
   ;	
   ;	   FarEditString [--Strpos] = 0;
   ;	
	mov	al,byte ptr [bp-2]
	add	al,255
	mov	byte ptr [bp-2],al
	mov	ah,0
	les	bx,dword ptr MGRP:_FarEditString
	add	bx,ax
	mov	byte ptr es:[bx],0
   ;	
   ;	   SetColor (15); Bar (Xpos,y+5,Xpos+8,y+17); SetColor (0);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
	mov	ax,di
	add	ax,17
	push	ax
	mov	ax,si
	add	ax,8
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	call	near ptr MGRP:_Bar
	add	sp,8
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   Line (Xpos,y+5,Xpos,y+16);
   ;	
	mov	ax,di
	add	ax,16
	push	ax
	push	si
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	   SetColor (15); Line (Xpos+8,y+5,Xpos+8,y+16); SetColor (0);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
	mov	ax,di
	add	ax,16
	push	ax
	mov	ax,si
	add	ax,8
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,8
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  }
   ;	
	jmp	@104@478
@104@310:
   ;	
   ;	  else
   ;	  {
   ;	   if ( (Xpos+8) > (x+w) ) continue;
   ;	
	mov	ax,si
	add	ax,8
	mov	dx,word ptr [bp+4]
	add	dx,word ptr [bp+8]
	cmp	ax,dx
	jbe short	@@73
	jmp	@104@478
@@73:
   ;	
   ;	   if (pwd) PrintChar ('*',Xpos,y+5,0,255,0);
   ;	
	cmp	byte ptr [bp+16],0
	je	short @104@394
	push	0
	push	255
	push	0
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	push	42
	jmp	short @104@422
@104@394:
   ;	
   ;	   else PrintChar (EditKey,Xpos,y+5,0,255,0);
   ;	
	push	0
	push	255
	push	0
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	mov	al,byte ptr [bp-1]
	push	ax
@104@422:
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	   FarEditString [Strpos] = EditKey;
   ;	
	mov	al,byte ptr [bp-2]
	mov	ah,0
	les	bx,dword ptr MGRP:_FarEditString
	add	bx,ax
	mov	al,byte ptr [bp-1]
	mov	byte ptr es:[bx],al
   ;	
   ;	   FarEditString [++Strpos] = 0;
   ;	
	mov	al,byte ptr [bp-2]
	inc	al
	mov	byte ptr [bp-2],al
	mov	ah,0
	mov	bx,word ptr MGRP:_FarEditString
	add	bx,ax
	mov	byte ptr es:[bx],0
   ;	
   ;	   Line (Xpos+8,y+5,Xpos+8,y+16);
   ;	
	mov	ax,di
	add	ax,16
	push	ax
	mov	ax,si
	add	ax,8
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,8
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	   SetColor (15); Line (Xpos,y+5,Xpos,y+16); SetColor (0);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
	mov	ax,di
	add	ax,16
	push	ax
	push	si
	mov	ax,di
	add	ax,5
	push	ax
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   Xpos += 8;
   ;	
	add	si,8
@104@478:
   ;	
   ;	  }
   ;	 } while ( (EditKey != 13) && (EditKey != 27) && (c==0) );
   ;	
	cmp	byte ptr [bp-1],13
	je	short @104@562
	cmp	byte ptr [bp-1],27
	je	short @104@562
	cmp	byte ptr [bp+14],0
	jne short	@@74
	jmp	@104@58
@@74:
@104@562:
   ;	
   ;	// SetColor (15); Line (Xpos,y+5,Xpos,y+16); SetColor (0);
   ;	// Rectangle ( x,y,x+w,y+16+3); SetColor (0);
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_EditBoxReadLn	endp
   ;	
   ;	CONTROL FindLastEditBox (HWND fhWnd)
   ;	
	assume	cs:MGRP
_FindLastEditBox	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	
   ;	 LastEditBox = fhWnd->ActiveControl;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:LastEditBox,eax
   ;	
   ;	 if (LastEditBox == (CONTROL)0) return (CONTROL)0;
   ;	
	cmp	dword ptr MGRP:LastEditBox,large 0
	je	short @105@254
   ;	
   ;	
   ;	 if (LastEditBox->ControlType == CONTROL_TYPE_EDITBOX)
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	cmp	byte ptr es:[bx+8],2
	jne	short @105@114
@105@86:
   ;	
   ;	  return LastEditBox;
   ;	
	mov	dx,word ptr MGRP:LastEditBox+2
	mov	ax,word ptr MGRP:LastEditBox
	jmp	short @105@282
@105@114:
   ;	
   ;	
   ;	 LastEditBox = fhWnd->LastControl;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+24]
	jmp	short @105@198
@105@142:
   ;	
   ;	
   ;	 while (LastEditBox != (CONTROL)0)
   ;	 {
   ;	  if (LastEditBox->ControlType == CONTROL_TYPE_EDITBOX)
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	cmp	byte ptr es:[bx+8],2
	je	short @105@86
   ;	
   ;	   return LastEditBox;
   ;	  LastEditBox = LastEditBox->prev;
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	mov	eax,dword ptr es:[bx+14]
@105@198:
	mov	dword ptr MGRP:LastEditBox,eax
	cmp	dword ptr MGRP:LastEditBox,large 0
	jne	short @105@142
@105@254:
   ;	
   ;	 }
   ;	
   ;	 return (CONTROL)0;
   ;	
	xor	dx,dx
	xor	ax,ax
@105@282:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_FindLastEditBox	endp
   ;	
   ;	CONTROL FindLastButton (HWND fhWnd)
   ;	
	assume	cs:MGRP
_FindLastButton	proc	near
	enter	4,0
   ;	
   ;	{
   ;	 CONTROL LastButton;
   ;	
   ;	  LastButton = fhWnd->ActiveControl;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	  if (LastButton == (CONTROL)0) return (CONTROL)0;
   ;	
	cmp	dword ptr [bp-4],large 0
	je	short @106@254
   ;	
   ;	 if (LastButton->ControlType == CONTROL_TYPE_BUTTON)
   ;	
	les	bx,dword ptr [bp-4]
	cmp	byte ptr es:[bx+8],1
	jne	short @106@114
@106@86:
   ;	
   ;	  return LastButton;
   ;	
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	jmp	short @106@282
@106@114:
   ;	
   ;	
   ;	 LastButton = fhWnd->LastControl;
   ;	
	les	bx,dword ptr [bp+4]
	mov	eax,dword ptr es:[bx+24]
	jmp	short @106@198
@106@142:
   ;	
   ;	
   ;	 while (LastButton != (CONTROL)0)
   ;	 {
   ;	  if (LastButton->ControlType == CONTROL_TYPE_BUTTON)
   ;	
	les	bx,dword ptr [bp-4]
	cmp	byte ptr es:[bx+8],1
	je	short @106@86
   ;	
   ;	   return LastButton;
   ;	  LastButton = LastButton->prev;
   ;	
	les	bx,dword ptr [bp-4]
	mov	eax,dword ptr es:[bx+14]
@106@198:
	mov	dword ptr [bp-4],eax
	cmp	dword ptr [bp-4],large 0
	jne	short @106@142
@106@254:
   ;	
   ;	 }
   ;	
   ;	 return (CONTROL)0;
   ;	
	xor	dx,dx
	xor	ax,ax
@106@282:
   ;	
   ;	}
   ;	
	leave	
	ret	
_FindLastButton	endp
   ;	
   ;	void WriteKey (char c)
   ;	
	assume	cs:MGRP
_WriteKey	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		mov ah,5
   ;	
	mov	 ah,5
   ;	
   ;		mov cl,c
   ;	
	mov	 cl,[bp+4]
   ;	
   ;		mov ch,0
   ;	
	mov	 ch,0
   ;	
   ;		int 0x16
   ;	
	int	 016H
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_WriteKey	endp
   ;	
   ;	void EditBoxPut (char c)
   ;	
	assume	cs:MGRP
_EditBoxPut	proc	near
	enter	4,0
   ;	
   ;	{
   ;	
   ;	 CONTROL dumControl;
   ;	
   ;	 dumControl = activeEditBox; //FindLastEditBox(topWnd);
   ;	
	mov	eax,dword ptr MGRP:_activeEditBox
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	 if (dumControl == (CONTROL)0) return;
   ;	
	cmp	dword ptr [bp-4],large 0
	je	short @108@86
   ;	
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 EditBoxReadLn (dumControl->x,dumControl->y,dumControl->w,
   ;	
   ;	
   ;			  dumControl->StrSegment,dumControl->StrOffset,c,dumControl->size);
   ;	
	les	bx,dword ptr [bp-4]
	mov	al,byte ptr es:[bx+18]
	push	ax
	mov	al,byte ptr [bp+4]
	push	ax
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+4]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_EditBoxReadLn
	add	sp,14
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@108@86:
   ;	
   ;	}
   ;	
	leave	
	ret	
_EditBoxPut	endp
   ;	
   ;	void TurnControl (void)
   ;	
	assume	cs:MGRP
_TurnControl	proc	near
	push	si
   ;	
   ;	{
   ;	 if (topWnd == (HWND)0) return;
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	jne short	@@75
	jmp	@109@422
@@75:
   ;	
   ;	 if (topWnd->ActiveControl == (CONTROL)0) return;
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+28],large 0
	jne short	@@76
	jmp	@109@422
@@76:
   ;	
   ;	 if (topWnd->FirstControl == topWnd->LastControl) return;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+20]
	cmp	eax,dword ptr es:[bx+24]
	jne short	@@77
	jmp	@109@422
@@77:
   ;	
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 dumControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle ( dumControl->x,dumControl->y,dumControl->x+dumControl->w,
   ;	
   ;	
   ;		     dumControl->y+dumControl->h);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	
   ;	
   ;	 dumControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	 if (dumControl->prev == (CONTROL)0) dumControl = topWnd->LastControl;
   ;	
	les	bx,dword ptr MGRP:dumControl
	cmp	dword ptr es:[bx+14],large 0
	jne	short @109@170
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+24]
	jmp	short @109@198
@109@170:
   ;	
   ;	 else dumControl = dumControl->prev;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	eax,dword ptr es:[bx+14]
@109@198:
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	 SetColor (0);     
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle ( dumControl->x,dumControl->y,dumControl->x+dumControl->w,
   ;	
   ;	
   ;		     dumControl->y+dumControl->h);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	
   ;	 if (dumControl->ControlType == CONTROL_TYPE_EDITBOX )
   ;	
	les	bx,dword ptr MGRP:dumControl
	cmp	byte ptr es:[bx+8],2
	je short	@@78
	jmp	@109@338
@@78:
   ;	
   ;	 {
   ;	  LastEditBox = activeEditBox; //FindLastEditBox (topWnd);
   ;	
	mov	eax,dword ptr MGRP:_activeEditBox
	mov	dword ptr MGRP:LastEditBox,eax
   ;	
   ;	  if (LastEditBox != (CONTROL)0 )
   ;	
	cmp	dword ptr MGRP:LastEditBox,large 0
	je	short @109@310
   ;	
   ;	  {
   ;	   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString,LastEditBox->StrSegment,LastEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:LastEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   Line (LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		LastEditBox->y+5,
   ;		LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		LastEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@109@310:
   ;	
   ;	  }
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  memcpy (_CS,(unsigned int)TempString,dumControl->StrSegment,dumControl->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:dumControl
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  Line (dumControl->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		dumControl->y+5,
   ;		dumControl->x+(Xstrlen(TempString)*8)+5,
   ;		dumControl->y+16);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:dumControl
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:dumControl
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  activeEditBox = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:_activeEditBox,eax
@109@338:
   ;	
   ;	 }
   ;	
   ;	 if (dumControl->ControlType == CONTROL_TYPE_BUTTON)
   ;	
	les	bx,dword ptr MGRP:dumControl
	cmp	byte ptr es:[bx+8],1
	jne	short @109@394
   ;	
   ;	  activeButton = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:_activeButton,eax
@109@394:
   ;	
   ;	
   ;	 topWnd->ActiveControl = dumControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+28],eax
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@109@422:
   ;	
   ;	}
   ;	
	pop	si
	ret	
_TurnControl	endp
   ;	
   ;	void ExecuteControl ()
   ;	
	assume	cs:MGRP
_ExecuteControl	proc	near
	push	si
   ;	
   ;	{
   ;	 unsigned char k;
   ;	 if (topWnd == (HWND)0) return;
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	jne short	@@79
	jmp	@110@646
@@79:
   ;	
   ;	 if (topWnd->FirstControl == (CONTROL)0) return;
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+20],large 0
	jne short	@@80
	jmp	@110@646
@@80:
   ;	
   ;	
   ;	 dumControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	
   ;	 switch (dumControl->ControlType)
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	al,byte ptr es:[bx+8]
	mov	ah,0
	dec	ax
	mov	bx,ax
	cmp	bx,3
	jbe short	@@81
	jmp	@110@590
@@81:
	shl	bx,1
	jmp	word ptr cs:@110@C594[bx]
@110@198:
   ;	
   ;	 {
   ;	  case CONTROL_TYPE_BUTTON:
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString,dumControl->StrSegment,dumControl->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:dumControl
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	   pButton (dumControl->x,dumControl->y,dumControl->x+dumControl->w,
   ;	
   ;	
   ;		    dumControl->y+dumControl->h,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_pButton
	add	sp,10
   ;	
   ;		    
   ;	   /*do
   ;	   {
   ;	    if (is_key()) getch();
   ;	    k = scankey ();
   ;	   } while ( HoldKey == k );*/
   ;	   
   ;	   if (mouse_status) while ( bmouse () == 1 );
   ;	
	cmp	word ptr MGRP:mouse_status,0
	je	short @110@254
@110@226:
	call	near ptr MGRP:_bmouse
	cmp	ax,1
	je	short @110@226
@110@254:
   ;	
   ;	   
   ;	   Button (dumControl->x,dumControl->y,dumControl->x+dumControl->w,
   ;	
   ;	
   ;		   dumControl->y+dumControl->h,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Button
	add	sp,10
   ;	
   ;	   SysBuf.byte2 = dumControl->ControlID;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	al,byte ptr es:[bx+9]
	mov	byte ptr MGRP:_SysBuf+2,al
   ;	
   ;	   SysBuf.byte1 = CONTROL_BUTTON;
   ;	
	mov	byte ptr MGRP:_SysBuf+1,193
   ;	
   ;	   showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	
   ;	 // Trinacria.
   ;	
   ;	   if (Pa == 2) topWnd->ActiveControl = tempControl;
   ;	
	cmp	byte ptr MGRP:_Pa,2
	jne	short @110@310
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr MGRP:tempControl
	mov	dword ptr es:[bx+28],eax
@110@310:
   ;	
   ;	   Pa = 0;
   ;	
	mov	byte ptr MGRP:_Pa,0
   ;	
   ;	   if (topWnd->WinMain != 0) (topWnd->WinMain) ();
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+16],large 0
	jne short	@@82
	jmp	@110@646
@@82:
@110@338:
	les	bx,dword ptr MGRP:topWnd
	call	dword ptr es:[bx+16]
	jmp	@110@646
@110@366:
   ;	
   ;	   break;
   ;	
   ;	  case CONTROL_TYPE_EDITBOX:
   ;	//   hidemouse ();
   ;	//   EditBoxReadLn (dumControl->x,dumControl->y,dumControl->w,
   ;	//                  dumControl->StrSegment,dumControl->StrOffset,0,dumControl->size);
   ;	//   showmouse ();
   ;	
   ;	  if (activeButton != (CONTROL)0)
   ;	
	cmp	dword ptr MGRP:_activeButton,large 0
	jne short	@@83
	jmp	@110@646
@@83:
   ;	
   ;	  {
   ;	   topWnd->ActiveControl = activeButton;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr MGRP:_activeButton
	mov	dword ptr es:[bx+28],eax
   ;	
   ;	
   ;	 // Pa.
   ;	 //
   ;	
   ;	   tempControl = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	   Pa = 2;
   ;	
	mov	byte ptr MGRP:_Pa,2
   ;	
   ;	   if (xmod != 1) ExecuteControl ();
   ;	
	cmp	byte ptr MGRP:_xmod,1
	jne short	@@84
	jmp	@110@646
@@84:
	call	near ptr MGRP:_ExecuteControl
	jmp	@110@646
@110@450:
   ;	
   ;	
   ;	   //topWnd->ActiveControl = dumControl;
   ;	
   ;	  }
   ;	
   ;	   break;
   ;	
   ;	  case CONTROL_TYPE_TXTAREA:
   ;	   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	   aci = dumControl->word1;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+20]
	mov	word ptr MGRP:_aci,ax
   ;	
   ;	   acX = dumControl->word2+ topWnd->x+5;
   ;	
	mov	ax,word ptr es:[bx+22]
	les	bx,dword ptr MGRP:topWnd
	add	ax,word ptr es:[bx]
	add	ax,5
	mov	word ptr MGRP:_acX,ax
   ;	
   ;	   acY = dumControl->word3+ topWnd->y+20;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+24]
	les	bx,dword ptr MGRP:topWnd
	add	ax,word ptr es:[bx+2]
	add	ax,20
	mov	word ptr MGRP:_acY,ax
   ;	
   ;	   dumControl->size =
   ;	
   ;	
   ;	   TextArea (dumControl->x,dumControl->y,dumControl->w,dumControl->h,
   ;		     dumControl->StrSegment,dumControl->StrOffset,
   ;		     dumControl->size);
   ;	
	les	bx,dword ptr MGRP:dumControl
	push	word ptr es:[bx+18]
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_TextArea
	add	sp,14
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+18],ax
   ;	
   ;	   dumControl->word1 = aci;
   ;	
	mov	ax,word ptr MGRP:_aci
	mov	word ptr es:[bx+20],ax
   ;	
   ;	   dumControl->word2 = acX- (topWnd->x+5);
   ;	
	push	es
	les	si,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	add	ax,5
	mov	dx,word ptr MGRP:_acX
	sub	dx,ax
	pop	es
	mov	word ptr es:[bx+22],dx
   ;	
   ;	   dumControl->word3 = acY- (topWnd->y+20);
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx+2]
	add	ax,20
	mov	dx,word ptr MGRP:_acY
	sub	dx,ax
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+24],dx
	jmp	@110@562
@110@478:
   ;	
   ;	   showmouse ();
   ;	   break;
   ;	
   ;	  case CONTROL_TYPE_CYCLER:
   ;	   hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	   dumControl->word1 ++;
   ;	
	les	bx,dword ptr MGRP:dumControl
	inc	word ptr es:[bx+20]
   ;	
   ;	   if (dumControl->word1 == dumControl->word2 )
   ;	
	mov	ax,word ptr es:[bx+20]
	cmp	ax,word ptr es:[bx+22]
	jne	short @110@534
   ;	
   ;	    dumControl->word1 = 0;
   ;	
	mov	word ptr es:[bx+20],0
@110@534:
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString,dumControl->StrSegment,dumControl->StrOffset+PosString ((char far*)(dumControl->StrSegme
   ;	
	push	49
	les	bx,dword ptr MGRP:dumControl
	push	word ptr es:[bx+20]
	movzx	eax,word ptr es:[bx+10]
	shl	eax,16
	movzx	edx,word ptr es:[bx+12]
	add	eax,edx
	shld	edx,eax,16
	push	dx
	push	ax
	call	near ptr MGRP:_PosString
	add	sp,6
	les	bx,dword ptr MGRP:dumControl
	mov	dx,word ptr es:[bx+12]
	add	dx,ax
	push	dx
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   Bar (dumControl->x+31,dumControl->y+2,dumControl->x+dumControl->w-2,dumControl->y+dumControl->h-2);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	sub	ax,2
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	sub	ax,2
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	mov	ax,word ptr es:[bx+2]
	add	ax,2
	push	ax
	mov	ax,word ptr es:[bx]
	add	ax,31
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	   SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	   OutTextXY(dumControl->x+1+25+5,dumControl->y+1+2  +2-2,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	sub	ax,2
	push	ax
	mov	ax,word ptr es:[bx]
	add	ax,31
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
@110@562:
   ;	
   ;	   showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	   break;
   ;	
	jmp	short @110@646
@110@590:
   ;	
   ;	
   ;	  default: // modification
   ;	   SysBuf.byte1 = CONTROL_EXEC;
   ;	
	mov	byte ptr MGRP:_SysBuf+1,192
   ;	
   ;	   if (topWnd->WinMain != 0) (topWnd->WinMain) ();
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+16],large 0
	je	short @110@646
	jmp	@110@338
@110@646:
   ;	
   ;	   break;
   ;	 }
   ;	}
   ;	
	pop	si
	ret	
_ExecuteControl	endp
@110@C594	label	word
	dw	@110@198
	dw	@110@366
	dw	@110@450
	dw	@110@478
   ;	
   ;	CONTROL CreateControl (unsigned int x, unsigned int y, unsigned int w,
   ;	
	assume	cs:MGRP
_CreateControl	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;			      unsigned int h, HWND hWnd, unsigned char ID, unsigned char ControlType,
   ;			      unsigned int CapSegment, unsigned int CapOffset, unsigned int size)
   ;	{
   ;	
   ;	 LastEditBox = FindLastEditBox (hWnd);
   ;	
	push	dword ptr [bp+12]
	call	near ptr MGRP:_FindLastEditBox
	add	sp,4
	mov	word ptr MGRP:LastEditBox+2,dx
	mov	word ptr MGRP:LastEditBox,ax
   ;	
   ;	
   ;	 if (hWnd->ActiveControl != (CONTROL)0)
   ;	
	les	bx,dword ptr [bp+12]
	cmp	dword ptr es:[bx+28],large 0
	je	short @111@86
   ;	
   ;	 {
   ;	  dumControl = hWnd->ActiveControl;
   ;	
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	  SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Rectangle ( dumControl->x,dumControl->y,dumControl->x+dumControl->w,
   ;	
   ;	
   ;		     dumControl->y+dumControl->h);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:dumControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Rectangle
	add	sp,8
@111@86:
   ;	
   ;	 }
   ;	 dumControl = (unsigned long) malloc (2);
   ;	
	push	2
	call	near ptr MGRP:_malloc
	pop	cx
	movzx	eax,ax
	shld	edx,eax,16
	mov	word ptr MGRP:dumControl+2,dx
	mov	word ptr MGRP:dumControl,ax
   ;	
   ;	 asm { shl dword ptr dumControl,16 };
   ;	
 	shl	 dword ptr dumControl,16 
   ;	
   ;	 dumControl->x = x+hWnd->x+5;
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx],ax
   ;	
   ;	 dumControl->y = y+hWnd->y+20;
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+2],ax
   ;	
   ;	 dumControl->w = w;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+4],ax
   ;	
   ;	 dumControl->h = h;
   ;	
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx+6],ax
   ;	
   ;	 dumControl->size = size;
   ;	
	mov	ax,word ptr [bp+24]
	mov	word ptr es:[bx+18],ax
   ;	
   ;	 dumControl->ControlID = ID;
   ;	
	mov	al,byte ptr [bp+16]
	mov	byte ptr es:[bx+9],al
   ;	
   ;	 dumControl->ControlType = ControlType;
   ;	
	mov	al,byte ptr [bp+18]
	mov	byte ptr es:[bx+8],al
   ;	
   ;	 dumControl->StrSegment = CapSegment;
   ;	
	mov	ax,word ptr [bp+20]
	mov	word ptr es:[bx+10],ax
   ;	
   ;	 dumControl->StrOffset = CapOffset;
   ;	
	mov	ax,word ptr [bp+22]
	mov	word ptr es:[bx+12],ax
   ;	
   ;	 dumControl->prev = hWnd->LastControl;
   ;	
	les	bx,dword ptr [bp+12]
	mov	eax,dword ptr es:[bx+24]
	les	bx,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+14],eax
   ;	
   ;	 memcpy (_CS,(unsigned int)TempString,CapSegment,CapOffset,49);
   ;	
	push	49
	push	word ptr [bp+22]
	push	word ptr [bp+20]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	
   ;	 if (hWnd->FirstControl == (CONTROL)0)
   ;	
	les	bx,dword ptr [bp+12]
	cmp	dword ptr es:[bx+20],large 0
	jne	short @111@198
   ;	
   ;	 {
   ;	  hWnd->FirstControl = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+20],eax
   ;	
   ;	  dumControl->prev = (CONTROL)0;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+14],large 0
   ;	
   ;	 }
   ;	
	jmp	short @111@226
@111@198:
   ;	
   ;	 else
   ;	  dumControl->prev = hWnd->ActiveControl;
   ;	
	les	bx,dword ptr [bp+12]
	mov	eax,dword ptr es:[bx+28]
	les	bx,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+14],eax
@111@226:
   ;	
   ;	
   ;	 hWnd->ActiveControl = dumControl;
   ;	
	les	bx,dword ptr [bp+12]
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+28],eax
   ;	
   ;	 hWnd->LastControl = dumControl;
   ;	
	mov	dword ptr es:[bx+24],eax
   ;	
   ;	
   ;	 switch (ControlType)
   ;	
	mov	al,byte ptr [bp+18]
	mov	ah,0
	dec	ax
	mov	bx,ax
	cmp	bx,3
	jbe short	@@85
	jmp	@111@478
@@85:
	shl	bx,1
	jmp	word ptr cs:@111@C354[bx]
@111@338:
   ;	
   ;	 {
   ;	 case CONTROL_TYPE_BUTTON:
   ;	  Button (x+hWnd->x+5,y+hWnd->y+20,x+hWnd->x+5+w,y+hWnd->y+20+h,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_Button
	add	sp,10
   ;	
   ;	  activeButton = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:_activeButton,eax
   ;	
   ;	  break;
   ;	
	jmp	@111@478
@111@366:
   ;	
   ;	 case CONTROL_TYPE_EDITBOX:
   ;	  SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Bar (x+hWnd->x+5,y+hWnd->y+20,x+hWnd->x+5+w,y+hWnd->y+20+h);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	
   ;	//  SetColor (8);
   ;	//  Rectangle (x+hWnd->x+5+1,y+hWnd->y+20+1,x+hWnd->x+5+w-1,y+hWnd->y+20+h-1);
   ;	
   ;	  Line (x+hWnd->x+5,y+hWnd->y+20+h+1,x+hWnd->x+5+w,y+hWnd->y+20+h+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+w-2,y+hWnd->y+20,x+hWnd->x+5+w-2,y+hWnd->y+20+h+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	sub	ax,2
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	sub	ax,2
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+1,y+hWnd->y+20+1,x+hWnd->x+5+1,y+hWnd->y+20+h-1); 
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1,y+hWnd->y+20+1,x+hWnd->x+5+w-2,y+hWnd->y+20+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	sub	ax,2
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	  OutTextXY (x+hWnd->x+5+5,y+hWnd->y+20+5,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,10
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	
   ;	  // COSA NOSTRA
   ;	
   ;	 activeEditBox = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:_activeEditBox,eax
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (x+hWnd->x+5+(Xstrlen(TempString)*8)+5,y+hWnd->y+20+5,x+hWnd->x+5+(Xstrlen(TempString)*8)+5,y+hWnd->y+20+16);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,36
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr [bp+12]
	mov	dx,di
	add	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,10
	push	dx
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr [bp+12]
	mov	dx,di
	add	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,10
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	 if (LastEditBox != (CONTROL)0 )
   ;	
	cmp	dword ptr MGRP:LastEditBox,large 0
	jne short	@@86
	jmp	@111@478
@@86:
   ;	
   ;	 {
   ;	 memcpy (_CS,(unsigned int)TempString,LastEditBox->StrSegment,
   ;	
   ;	
   ;		 LastEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:LastEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		LastEditBox->y+5,
   ;		LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		LastEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
	jmp	@111@478
@111@422:
   ;	
   ;	 }
   ;	
   ;	
   ;	
   ;	  break;
   ;	 case CONTROL_TYPE_TXTAREA:
   ;	  SetColor (COLOR_B);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Bar (x+hWnd->x+5,y+hWnd->y+20,x+hWnd->x+w+2,y+hWnd->y+h+20+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,2
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	//  SetColor (15);
   ;	//  Rectangle (x+hWnd->x+5+1,y+1+hWnd->y+20,x+hWnd->x+w+5-1,y+hWnd->y+h+20-1);
   ;	  FarTABuffer = (CapSegment * 65536) + CapOffset;
   ;	
	movzx	eax,word ptr [bp+20]
	shl	eax,16
	movzx	edx,word ptr [bp+22]
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr MGRP:_FarTABuffer+2,dx
	mov	word ptr MGRP:_FarTABuffer,ax
   ;	
   ;	  FarTABuffer [size] = 0;
   ;	
	les	bx,dword ptr MGRP:_FarTABuffer
	add	bx,word ptr [bp+24]
	mov	byte ptr es:[bx],0
   ;	
   ;	  dumControl->word1 = 0;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+20],0
   ;	
   ;	  dumControl->word2 = x+5;
   ;	
	mov	ax,di
	add	ax,5
	mov	word ptr es:[bx+22],ax
   ;	
   ;	  dumControl->word3 = y+5;
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,5
	mov	word ptr es:[bx+24],ax
   ;	
   ;	  DispText (0,x+hWnd->x+5,y+hWnd->y+20,w,h,size,x+hWnd->x+5+5,y+hWnd->y+5+20,3,0);
   ;	
	push	0
	push	3
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,10
	push	ax
	push	word ptr [bp+24]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	push	0
	call	near ptr MGRP:_DispText
	add	sp,20
   ;	
   ;	  break;
   ;	
	jmp	@111@478
@111@450:
   ;	
   ;	 case CONTROL_TYPE_CYCLER:
   ;	  SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+1,y+hWnd->y+20+1,x+hWnd->x+5+1,y+hWnd->y+20+h-1); 
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1,y+hWnd->y+20+1,x+hWnd->x+5+w-1,y+hWnd->y+20+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	dec	ax
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+w-1,y+hWnd->y+20+1,x+hWnd->x+5+w-1,y+hWnd->y+20+h-1); 
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	dec	ax
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1,y+hWnd->y+20+h-1,x+hWnd->x+5+w-2,y+hWnd->y+20+h-1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	sub	ax,2
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,6
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+1+21,y+hWnd->y+20+1,x+hWnd->x+5+1+21,y+hWnd->y+20+h-1); 
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,27
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,27
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  Line (x+hWnd->x+5+1+20,y+hWnd->y+20+1,x+hWnd->x+5+1+20,y+hWnd->y+20+h-1); 
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,26
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,21
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,26
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	  Line (x+hWnd->x+5+1+4,y+hWnd->y+20+1+4+1,x+hWnd->x+5+1+4,y+hWnd->y+20+h-1-4-1+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	dec	ax
	inc	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,10
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,26
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,10
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1+4+1,y+hWnd->y+20+1+4,x+hWnd->x+5+1+4+1,y+hWnd->y+20+h-1-4+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	inc	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,11
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1+4,y+hWnd->y+20+1+4,x+hWnd->x+5+1+4+12,y+hWnd->y+20+1+4);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,10
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1+4+1,y+hWnd->y+20+1+4-1,x+hWnd->x+5+1+4+12-1,y+hWnd->y+20+1+4-1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	dec	ax
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1+4+1,y+hWnd->y+20+h-1-4+1,x+hWnd->x+5+1+4+12-1,y+hWnd->y+20+h-1-4+1);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	inc	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	dec	ax
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	inc	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+1+4+1,y+hWnd->y+20+h-1-4,x+hWnd->x+5+1+4+12,y+hWnd->y+20+h-1-4);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	  Line (x+hWnd->x+5+4+12,y+hWnd->y+20+1+4+1,x+hWnd->x+5+4+12,y+hWnd->y+20+1+4+1+3);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,29
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,26
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,21
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+4+1+12,y+hWnd->y+20+1+4+1,x+hWnd->x+5+4+1+12,y+hWnd->y+20+1+4+1+3);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,29
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,26
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+4+12,y+hWnd->y+20+h-1-4-1,x+hWnd->x+5+4+12,y+hWnd->y+20+h-1-4);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,21
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,21
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  Line (x+hWnd->x+5+4+1+12,y+hWnd->y+20+h-1-4-1,x+hWnd->x+5+4+1+12,y+hWnd->y+20+h-1-4);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	dec	ax
	sub	ax,4
	dec	ax
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,22
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	
   ;	  Line (x+hWnd->x+5+4+12-1,y+hWnd->y+20+1+4+1+2,x+hWnd->x+5+4+1+12+1,y+hWnd->y+20+1+4+1+2);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,28
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,23
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,28
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,21
	dec	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	  memcpy (_CS,(unsigned int)TempString,CapSegment,CapOffset+PosString ((char far*)(CapSegment * 65536 + CapOffset),0),49) ;
   ;	
	push	large 000310000h
	movzx	eax,word ptr [bp+20]
	shl	eax,16
	movzx	edx,word ptr [bp+22]
	add	eax,edx
	shld	edx,eax,16
	push	dx
	push	ax
	call	near ptr MGRP:_PosString
	add	sp,6
	mov	dx,word ptr [bp+22]
	add	dx,ax
	push	dx
	push	word ptr [bp+20]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  OutTextXY(x+hWnd->x+5+1+25+5,y+hWnd->y+20+1+2   +2-2,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,25
	sub	ax,2
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,36
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	  dumControl->word1 = 0;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	word ptr es:[bx+20],0
   ;	
   ;	  dumControl->word2 = size;
   ;	
	mov	ax,word ptr [bp+24]
	mov	word ptr es:[bx+22],ax
   ;	
   ;	
   ;	  break;
   ;	
@111@478:
   ;	
   ;	
   ;	 }
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle (x+hWnd->x+5,y+hWnd->y+20,x+hWnd->x+5+w,y+hWnd->y+h+20);
   ;	
	les	bx,dword ptr [bp+12]
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,word ptr [bp+10]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,word ptr [bp+8]
	add	ax,5
	push	ax
	mov	ax,word ptr [bp+6]
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,di
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 return dumControl;
   ;	
	mov	dx,word ptr MGRP:dumControl+2
	mov	ax,word ptr MGRP:dumControl
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_CreateControl	endp
@111@C354	label	word
	dw	@111@338
	dw	@111@366
	dw	@111@422
	dw	@111@450
_quit	label	word
	db	0
	db	0
   ;	
   ;	void WindowManager (void)
   ;	
	assume	cs:MGRP
_WindowManager	proc	near
	enter	4,0
	push	si
	jmp	@112@1990
@112@58:
   ;	
   ;	{
   ;	 char is_control;
   ;	 while (!quit)
   ;	 {
   ;	
   ;	  xmod = 0;
   ;	
	mov	byte ptr MGRP:_xmod,0
   ;	
   ;	
   ;	  // ** Mouse-event *******************************************************
   ;	  if ( (bmouse () == 2) && mouse_status)
   ;	
	call	near ptr MGRP:_bmouse
	cmp	ax,2
	jne	short @112@142
	cmp	word ptr MGRP:mouse_status,0
	je	short @112@142
   ;	
   ;	  {
   ;	   TickMenu ();
   ;	
	call	near ptr MGRP:_TickMenu
   ;	
   ;	  }
   ;	
	jmp	@112@1430
@112@142:
   ;	
   ;	  else
   ;	  /*if ( (bmouse () == 3) && mouse_status)
   ;	  {
   ;	   if (  (mx > (topWnd->x+15))&&(my > topWnd->y)
   ;	       &&(mx < (topWnd->x+topWnd->w))&&(my < (topWnd->y+15)) )
   ;	   {
   ;	    MoveWindow ();
   ;	   }
   ;	  }
   ;	  else*/
   ;	  if ( (bmouse () == 1) && mouse_status)
   ;	
	call	near ptr MGRP:_bmouse
	cmp	ax,1
	je short	@@87
	jmp	@112@1430
@@87:
	cmp	word ptr MGRP:mouse_status,0
	jne short	@@88
	jmp	@112@1430
@@88:
   ;	
   ;	  {
   ;	   if (topWnd == (HWND)0) continue;
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	jne short	@@89
	jmp	@112@1990
@@89:
   ;	
   ;	   
   ;	   is_control = 0;
   ;	
	mov	byte ptr [bp-1],0
   ;	
   ;	
   ;	   if (  (mx > topWnd->x)&&(my > topWnd->y)
   ;	
   ;	
   ;	       &&(mx < (topWnd->x+topWnd->w))&&(my < (topWnd->y+topWnd->h)))
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr MGRP:mx
	jb short	@@90
	jmp	@112@1122
@@90:
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr MGRP:my
	jb short	@@91
	jmp	@112@1122
@@91:
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	cmp	ax,word ptr MGRP:mx
	ja short	@@92
	jmp	@112@1122
@@92:
	mov	es,word ptr MGRP:topWnd+2
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	cmp	ax,word ptr MGRP:my
	ja short	@@93
	jmp	@112@1122
@@93:
   ;	
   ;	   {
   ;	    if (  (mx > topWnd->x)&&(my > topWnd->y)
   ;	
   ;	
   ;		&&(mx < (topWnd->x+15))&&(my < (topWnd->y+15)) )
   ;	
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr MGRP:mx
	jae	short @112@478
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr MGRP:my
	jae	short @112@478
	mov	ax,word ptr es:[bx]
	add	ax,15
	cmp	ax,word ptr MGRP:mx
	jbe	short @112@478
	mov	ax,word ptr es:[bx+2]
	add	ax,15
	cmp	ax,word ptr MGRP:my
	jbe	short @112@478
   ;	
   ;	    {
   ;	     DestroyWindow (topWnd);
   ;	
	push	word ptr MGRP:topWnd+2
	push	bx
	call	near ptr MGRP:_DestroyWindow
	jmp	@112@1318
@112@478:
   ;	
   ;	    }
   ;	   else if (  (mx > (topWnd->x+15))&&(my > topWnd->y)
   ;	
   ;	
   ;	       &&(mx < (topWnd->x+topWnd->w))&&(my < (topWnd->y+15)) )
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	ax,word ptr es:[bx]
	add	ax,15
	cmp	ax,word ptr MGRP:mx
	jae	short @112@618
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr MGRP:my
	jae	short @112@618
	push	es
	mov	si,word ptr MGRP:topWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	cmp	ax,word ptr MGRP:mx
	jbe	short @112@618
	mov	es,word ptr MGRP:topWnd+2
	mov	ax,word ptr es:[bx+2]
	add	ax,15
	cmp	ax,word ptr MGRP:my
	jbe	short @112@618
   ;	
   ;	   {
   ;	    MoveWindow ();
   ;	
	call	near ptr MGRP:_MoveWindow
   ;	
   ;	   }
   ;	
	jmp	@112@1430
@112@618:
   ;	
   ;	
   ;	    else
   ;	    {
   ;	     dumControl = topWnd->LastControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+24]
@112@646:
	mov	dword ptr MGRP:dumControl,eax
   ;	
   ;	     do
   ;	     {
   ;	      if (  (mx > dumControl->x)&&(my > dumControl->y)
   ;	
   ;	
   ;	       &&(mx < (dumControl->x+dumControl->w))&&(my < (dumControl->y+dumControl->h)) )
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr MGRP:mx
	jb short	@@94
	jmp	@112@982
@@94:
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr MGRP:my
	jb short	@@95
	jmp	@112@982
@@95:
	push	es
	mov	si,word ptr MGRP:dumControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	cmp	ax,word ptr MGRP:mx
	ja short	@@96
	jmp	@112@982
@@96:
	mov	es,word ptr MGRP:dumControl+2
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	cmp	ax,word ptr MGRP:my
	ja short	@@97
	jmp	@112@982
@@97:
   ;	
   ;	      {
   ;	       is_control = 1;
   ;	
	mov	byte ptr [bp-1],1
   ;	
   ;	
   ;	
   ;	       xmod = 1;
   ;	
	mov	byte ptr MGRP:_xmod,1
   ;	
   ;	
   ;	       hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	       tempControl = topWnd->ActiveControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+28]
	mov	dword ptr MGRP:tempControl,eax
   ;	
   ;	       SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	       Rectangle (tempControl->x,tempControl->y,tempControl->x+tempControl->w,
   ;	
   ;	
   ;			  tempControl->y+tempControl->h);
   ;	
	les	bx,dword ptr MGRP:tempControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	push	es
	mov	si,word ptr MGRP:tempControl
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	push	ax
	mov	es,word ptr MGRP:tempControl+2
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	
   ;	
   ;	 if (dumControl->ControlType == CONTROL_TYPE_EDITBOX )
   ;	
	les	bx,dword ptr MGRP:dumControl
	cmp	byte ptr es:[bx+8],2
	je short	@@98
	jmp	@112@898
@@98:
   ;	
   ;	 {
   ;	  LastEditBox = activeEditBox; //FindLastEditBox (topWnd);
   ;	
	mov	eax,dword ptr MGRP:_activeEditBox
	mov	dword ptr MGRP:LastEditBox,eax
   ;	
   ;	  if (LastEditBox != (CONTROL)0 )
   ;	
	cmp	dword ptr MGRP:LastEditBox,large 0
	je	short @112@870
   ;	
   ;	  {
   ;	   SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	   memcpy (_CS,(unsigned int)TempString,LastEditBox->StrSegment,LastEditBox->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:LastEditBox
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	   Line (LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		LastEditBox->y+5,
   ;		LastEditBox->x+(Xstrlen(TempString)*8)+5,
   ;		LastEditBox->y+16);
   ;	
	les	bx,dword ptr MGRP:LastEditBox
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:LastEditBox
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@112@870:
   ;	
   ;	  }
   ;	  SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	  memcpy (_CS,(unsigned int)TempString,dumControl->StrSegment,dumControl->StrOffset,49);
   ;	
	push	49
	les	bx,dword ptr MGRP:dumControl
	push	word ptr es:[bx+12]
	push	word ptr es:[bx+10]
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  Line (dumControl->x+(Xstrlen(TempString)*8)+5,
   ;	
   ;	
   ;		dumControl->y+5,
   ;		dumControl->x+(Xstrlen(TempString)*8)+5,
   ;		dumControl->y+16);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,16
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:dumControl
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	mov	ax,word ptr es:[bx+2]
	add	ax,5
	push	ax
	push	cs
	push	offset MGRP:TempString
	call	near ptr MGRP:_Xstrlen
	add	sp,4
	mov	ah,0
	shl	ax,3
	les	bx,dword ptr MGRP:dumControl
	mov	dx,word ptr es:[bx]
	add	dx,ax
	add	dx,5
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	  activeEditBox = dumControl;
   ;	
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr MGRP:_activeEditBox,eax
@112@898:
   ;	
   ;	 }
   ;	
   ;	       SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	       Rectangle (dumControl->x,dumControl->y,dumControl->w+dumControl->x,
   ;	
   ;	
   ;			  dumControl->y+dumControl->h);
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	push	ax
	mov	ax,word ptr es:[bx+4]
	add	ax,word ptr es:[bx]
	push	ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	       showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	       topWnd->ActiveControl = dumControl;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr MGRP:dumControl
	mov	dword ptr es:[bx+28],eax
   ;	
   ;	
   ;	       ExecuteControl ();
   ;	
	call	near ptr MGRP:_ExecuteControl
@112@926:
   ;	
   ;	
   ;	       while ( bmouse () == 1 ) ;
   ;	
	call	near ptr MGRP:_bmouse
	cmp	ax,1
	je	short @112@926
   ;	
   ;	
   ;	       break;
   ;	
	jmp	short @112@1038
@112@982:
   ;	
   ;	      }
   ;	      if (dumControl == topWnd->FirstControl) break;
   ;	
	les	bx,dword ptr MGRP:topWnd
	mov	eax,dword ptr es:[bx+20]
	cmp	eax,dword ptr MGRP:dumControl
	je	short @112@1038
   ;	
   ;	      dumControl = dumControl->prev;
   ;	
	les	bx,dword ptr MGRP:dumControl
	mov	eax,dword ptr es:[bx+14]
	jmp	@112@646
@112@1038:
   ;	
   ;	     } while ( 1 );
   ;	
   ;	     SysBuf.byte1 = MOUSE_CLICK;
   ;	
	mov	byte ptr MGRP:_SysBuf+1,160
   ;	
   ;	     SysBuf.word1 = mx; SysBuf.word2 = my;
   ;	
	mov	ax,word ptr MGRP:mx
	mov	word ptr MGRP:_SysBuf+3,ax
	mov	ax,word ptr MGRP:my
	mov	word ptr MGRP:_SysBuf+5,ax
   ;	
   ;	     if ( (topWnd->WinMain != 0) && (!is_control) ) (topWnd->WinMain) ();
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+16],large 0
	je	short @112@1430
	mov	al,byte ptr [bp-1]
	cbw	
	or	ax,ax
	jne	short @112@1430
	call	dword ptr es:[bx+16]
	jmp	short @112@1430
@112@1122:
   ;	
   ;	    }
   ;	   }
   ;	   else if (is_full_app == 0) 
   ;	
	cmp	byte ptr MGRP:is_full_app,0
	jne	short @112@1430
   ;	
   ;	   {
   ;	    dumWnd = topWnd->prev;
   ;	
	les	bx,dword ptr MGRP:topWnd
	jmp	short @112@1374
@112@1178:
   ;	
   ;	    while ( dumWnd != (HWND)0)
   ;	    {
   ;	     if (  (mx > dumWnd->x)&&(my > dumWnd->y)
   ;	
   ;	
   ;		 &&(mx < (dumWnd->x+dumWnd->w))&&(my < (dumWnd->y+dumWnd->h)))
   ;	
	les	bx,dword ptr MGRP:dumWnd
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr MGRP:mx
	jae	short @112@1346
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr MGRP:my
	jae	short @112@1346
	push	es
	mov	si,word ptr MGRP:dumWnd
	mov	ax,word ptr es:[si]
	pop	es
	add	ax,word ptr es:[bx+4]
	cmp	ax,word ptr MGRP:mx
	jbe	short @112@1346
	mov	es,word ptr MGRP:dumWnd+2
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr es:[bx+6]
	cmp	ax,word ptr MGRP:my
	jbe	short @112@1346
   ;	
   ;	     {
   ;	      SwitchWindow (dumWnd);
   ;	
	push	word ptr MGRP:dumWnd+2
	push	bx
	call	near ptr MGRP:_SwitchWindow
@112@1318:
	add	sp,4
   ;	
   ;	      break;
   ;	
	jmp	short @112@1430
@112@1346:
   ;	
   ;	     }
   ;	     dumWnd = dumWnd->prev;
   ;	
	les	bx,dword ptr MGRP:dumWnd
@112@1374:
	mov	eax,dword ptr es:[bx+12]
	mov	dword ptr MGRP:dumWnd,eax
	cmp	dword ptr MGRP:dumWnd,large 0
	jne	short @112@1178
@112@1430:
   ;	
   ;	    }
   ;	   }
   ;	
   ;	   // while ( bmouse () == 1 ) ;
   ;	  }
   ;	
   ;	  // ** KEY-event *********************************************************
   ;	
   ;	  if (is_key ())
   ;	
	call	near ptr MGRP:_is_key
	or	al,al
	jne short	@@99
	jmp	@112@1990
@@99:
   ;	
   ;	  {
   ;	   Xkey = Xgetch ();
   ;	
	call	near ptr MGRP:_Xgetch
	mov	word ptr MGRP:_Xkey,ax
   ;	
   ;	   HoldKey = scankey();
   ;	
	call	near ptr MGRP:_scankey
	mov	byte ptr MGRP:_HoldKey,al
   ;	
   ;	   switch (Xkey)
   ;	
	mov	ax,word ptr MGRP:_Xkey
	mov	word ptr [bp-4],ax
	mov	cx,6
	mov	bx,offset @112@C50
@112@1542:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-4]
	je	short @112@1626
	add	bx,2
	loop	short @112@1542
	jmp	short @112@1878
@112@1626:
	jmp	word ptr cs:[bx+12]
@112@1654:
   ;	
   ;	   {
   ;	    case 27392: if (topWnd != (HWND)0) 
   ;	
	cmp	dword ptr MGRP:topWnd,large 0
	je	short @112@1990
   ;	
   ;			 if (topWnd != protectedWnd)
   ;	
	mov	eax,dword ptr MGRP:topWnd
	cmp	eax,dword ptr MGRP:protectedWnd
	je	short @112@1990
   ;	
   ;			  DestroyWindow (topWnd); break;
   ;	
	push	dword ptr MGRP:topWnd
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
	jmp	short @112@1990
@112@1738:
   ;	
   ;	    case  3711: quit = 1; break;
   ;	
	mov	word ptr MGRP:_quit,1
	jmp	short @112@1990
@112@1766:
   ;	
   ;	    case  3849: TurnControl (); break;
   ;	
	call	near ptr MGRP:_TurnControl
	jmp	short @112@1990
@112@1794:
   ;	
   ;	    case  3840: TurnWindow (); break;
   ;	
	call	near ptr MGRP:_TurnWindow
	jmp	short @112@1990
@112@1822:
   ;	
   ;	    case  7181: ExecuteControl (); break;
   ;	
	call	near ptr MGRP:_ExecuteControl
	jmp	short @112@1990
@112@1850:
   ;	
   ;	    case  7178: TickMenu (); break;
   ;	
	call	near ptr MGRP:_TickMenu
	jmp	short @112@1990
@112@1878:
   ;	
   ;	    default:
   ;	         if (is_control)
   ;	
	cmp	byte ptr [bp-1],0
	je	short @112@1934
   ;	
   ;		        EditBoxPut ( (char) Xkey );
   ;	
	mov	al,byte ptr MGRP:_Xkey
	push	ax
	call	near ptr MGRP:_EditBoxPut
	pop	cx
@112@1934:
   ;	
   ;		     
   ;		     SysBuf.byte1 = KEYB_CLICK;
   ;	
	mov	byte ptr MGRP:_SysBuf+1,161
   ;	
   ;	         SysBuf.word1 = Xkey;
   ;	
	mov	ax,word ptr MGRP:_Xkey
	mov	word ptr MGRP:_SysBuf+3,ax
   ;	
   ;	         //MessageBox("WinMain"); 
   ;	         if ( (topWnd->WinMain != 0) ) (topWnd->WinMain) ();
   ;	
	les	bx,dword ptr MGRP:topWnd
	cmp	dword ptr es:[bx+16],large 0
	je	short @112@1990
	call	dword ptr es:[bx+16]
@112@1990:
	cmp	word ptr MGRP:_quit,0
	jne short	@@100
	jmp	@112@58
@@100:
   ;	
   ;	
   ;		     break;
   ;	   }
   ;	  }
   ;	 }
   ;	}
   ;	
	pop	si
	leave	
	ret	
_WindowManager	endp
@112@C50	label	word
	db	127
	db	14
	db	0
	db	15
	db	9
	db	15
	db	10
	db	28
	db	13
	db	28
	db	0
	db	107
	dw	@112@1738
	dw	@112@1794
	dw	@112@1766
	dw	@112@1850
	dw	@112@1822
	dw	@112@1654
   ;	
   ;	void intr (void* funcptr, char intc)
   ;	
	assume	cs:MGRP
_intr	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
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
   ;		xor ax,ax    
   ;	
	xor	 ax,ax    
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		xor bh,bh
   ;	
	xor	 bh,bh
   ;	
   ;		mov bl,intc
   ;	
	mov	 bl,[bp+6]
   ;	
   ;		shl bx,2             
   ;	
	shl	 bx,2             
   ;	
   ;		mov ax,funcptr
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
   ;		mov word ptr es:[bx+2],ax
   ;	
	mov	 word ptr es:[bx+2],ax
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
   ;	       }
   ;	}
   ;	
	pop	bp
	ret	
_intr	endp
   ;	
   ;	unsigned long MakePtr (unsigned int seg, unsigned int ofs)
   ;	
	assume	cs:MGRP
_MakePtr	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 return (unsigned long)((seg * 65536) + ofs);
   ;	
	movzx	eax,word ptr [bp+4]
	shl	eax,16
	movzx	edx,word ptr [bp+6]
	add	eax,edx
	shld	edx,eax,16
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_MakePtr	endp
   ;	
   ;	void halt (void)
   ;	
	assume	cs:MGRP
_halt	proc	near
   ;	
   ;	{
   ;	  hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	   Background (0);
   ;	
	push	0
	call	near ptr MGRP:_Background
	pop	cx
   ;	
   ;	   SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	   pic ("/lib/shut.bmp",140);
   ;	
	push	140
	push	offset MGRP:s@+70
	call	near ptr MGRP:_pic
	add	sp,4
   ;	
   ;	   SetVideo (ON);
   ;	
	push	0
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	   asm { xor ax,ax ; int 0x16 ; hlt };
   ;	
 	xor	 ax,ax 
 	int	 016H 
 	hlt	 
   ;	
   ;	}
   ;	
	ret	
_halt	endp
   ;	
   ;	void interrupt Int48 (void)
   ;	
	assume	cs:MGRP
_Int48	proc	far
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
   ;	     asm cli
   ;	
 	cli	
   ;	
   ;	     asm pusha
   ;	
 	pusha	
   ;	
   ;	 _AX = _DS;
   ;	
	mov	ax,ds
   ;	
   ;	 _BX = _CS;
   ;	
	mov	bx,cs
   ;	
   ;	 _DS = _BX;
   ;	
	mov	ds,bx
   ;	
   ;	  DataSegment = _AX;
   ;	
	mov	word ptr MGRP:DataSegment,ax
   ;	
   ;	
   ;	 if (SysBuf.function == 0x01)
   ;	
	cmp	byte ptr MGRP:_SysBuf,1
	jne	short @116@142
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,SysBuf.word5,SysBuf.word6,49);
   ;	
	push	49
	push	dword ptr MGRP:_SysBuf+11
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  SysBuf.dword1 = (unsigned long)CreateWindow (SysBuf.word1, SysBuf.word2,
   ;	
   ;	
   ;						       SysBuf.word3, SysBuf.word4,
   ;						       SysBuf.byte1,TempString);
   ;	
	push	offset MGRP:TempString
	mov	al,byte ptr MGRP:_SysBuf+1
	push	ax
	push	dword ptr MGRP:_SysBuf+7
	push	dword ptr MGRP:_SysBuf+3
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_SysBuf+17,dx
	mov	word ptr MGRP:_SysBuf+15,ax
@116@142:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x02)
   ;	
	cmp	byte ptr MGRP:_SysBuf,2
	jne	short @116@198
   ;	
   ;	   ((HWND)(SysBuf.dword1)) -> WinMain = (void far*)MakePtr (SysBuf.word3,SysBuf.word4);
   ;	
	push	dword ptr MGRP:_SysBuf+7
	call	near ptr MGRP:_MakePtr
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shld	edx,eax,16
	les	bx,dword ptr MGRP:_SysBuf+15
	mov	word ptr es:[bx+18],dx
	mov	word ptr es:[bx+16],ax
@116@198:
   ;	
   ;	 if (SysBuf.function == 0x03)
   ;	
	cmp	byte ptr MGRP:_SysBuf,3
	jne	short @116@254
   ;	
   ;	  FarOutTextXY (SysBuf.word1+((HWND)(SysBuf.dword1))->x+5,((HWND)(SysBuf.dword1)) ->y+20+SysBuf.word2,
   ;	
   ;	
   ;	  (char far*)MakePtr (SysBuf.word5,SysBuf.word6) );
   ;	
	push	dword ptr MGRP:_SysBuf+11
	call	near ptr MGRP:_MakePtr
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shld	edx,eax,16
	push	dx
	push	ax
	les	bx,dword ptr MGRP:_SysBuf+15
	mov	ax,word ptr es:[bx+2]
	add	ax,word ptr MGRP:_SysBuf+5
	add	ax,20
	push	ax
	mov	ax,word ptr MGRP:_SysBuf+3
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_FarOutTextXY
	add	sp,8
@116@254:
   ;	
   ;	 if (SysBuf.function == 0x04)
   ;	
	cmp	byte ptr MGRP:_SysBuf,4
	jne	short @116@310
   ;	
   ;	  setFont (SysBuf.byte1);
   ;	
	mov	al,byte ptr MGRP:_SysBuf+1
	mov	ah,0
	push	ax
	call	near ptr MGRP:_setFont
	pop	cx
@116@310:
   ;	
   ;	 if (SysBuf.function == 0x05)
   ;	
	cmp	byte ptr MGRP:_SysBuf,5
	jne	short @116@366
   ;	
   ;	  SetColor (SysBuf.byte1);
   ;	
	mov	al,byte ptr MGRP:_SysBuf+1
	mov	ah,0
	push	ax
	call	near ptr MGRP:_SetColor
	pop	cx
@116@366:
   ;	
   ;	 if (SysBuf.function == 0x06)
   ;	
	cmp	byte ptr MGRP:_SysBuf,6
	jne	short @116@422
   ;	
   ;	  SysBuf.word1 = HiMemoryAvailable ();
   ;	
	call	near ptr MGRP:_HiMemoryAvailable
	mov	word ptr MGRP:_SysBuf+3,ax
@116@422:
   ;	
   ;	 if (SysBuf.function == 0x07)
   ;	
	cmp	byte ptr MGRP:_SysBuf,7
	jne	short @116@478
   ;	
   ;	  SysBuf.dword1 = HiMemoryAlloc (SysBuf.dword1);
   ;	
	push	dword ptr MGRP:_SysBuf+15
	call	near ptr MGRP:_HiMemoryAlloc
	push	dx
	push	ax
	pop	eax
	add	sp,4
	mov	dword ptr MGRP:_SysBuf+15,eax
@116@478:
   ;	
   ;	 if (SysBuf.function == 0x08)
   ;	
	cmp	byte ptr MGRP:_SysBuf,8
	jne	short @116@534
   ;	
   ;	  HiMemoryFree (SysBuf.dword1);
   ;	
	push	dword ptr MGRP:_SysBuf+15
	call	near ptr MGRP:_HiMemoryFree
	add	sp,4
@116@534:
   ;	
   ;	 if (SysBuf.function == 0x09)
   ;	
	cmp	byte ptr MGRP:_SysBuf,9
	jne	short @116@590
   ;	
   ;	  (unsigned long)SysBuf.dword1 = CreateControl (SysBuf.word1,SysBuf.word2,
   ;	
   ;	
   ;							SysBuf.word3,SysBuf.word4,
   ;							(HWND)SysBuf.dword1,
   ;							SysBuf.byte1,SysBuf.byte2,
   ;							SysBuf.word5,SysBuf.word6,
   ;							SysBuf.word7);
   ;	
	push	word ptr MGRP:_SysBuf+19
	push	dword ptr MGRP:_SysBuf+11
	mov	al,byte ptr MGRP:_SysBuf+2
	push	ax
	mov	al,byte ptr MGRP:_SysBuf+1
	push	ax
	push	dword ptr MGRP:_SysBuf+15
	push	dword ptr MGRP:_SysBuf+7
	push	dword ptr MGRP:_SysBuf+3
	call	near ptr MGRP:_CreateControl
	add	sp,22
	mov	word ptr MGRP:_SysBuf+17,dx
	mov	word ptr MGRP:_SysBuf+15,ax
@116@590:
   ;	
   ;	 if (SysBuf.function == 0x10)
   ;	
	cmp	byte ptr MGRP:_SysBuf,16
	jne	short @116@646
   ;	
   ;	  SysBuf.byte1 = popup (SysBuf.byte2,(char far** )MakePtr (SysBuf.word1,SysBuf.word2),
   ;	
   ;	
   ;				SysBuf.word3,SysBuf.word4,SysBuf.word5);
   ;	
	push	dword ptr MGRP:_SysBuf+9
	push	dword ptr MGRP:_SysBuf+5
	push	word ptr MGRP:_SysBuf+3
	call	near ptr MGRP:_MakePtr
	add	sp,4
	push	ax
	mov	al,byte ptr MGRP:_SysBuf+2
	mov	ah,0
	push	ax
	call	near ptr MGRP:_popup
	add	sp,10
	mov	byte ptr MGRP:_SysBuf+1,al
@116@646:
   ;	
   ;	
   ;	 if (SysBuf.function == 0x11)
   ;	
	cmp	byte ptr MGRP:_SysBuf,17
	jne	short @116@702
   ;	
   ;	  quit = 1;
   ;	
	mov	word ptr MGRP:_quit,1
@116@702:
   ;	
   ;	 if (SysBuf.function == 0x12)
   ;	
	cmp	byte ptr MGRP:_SysBuf,18
	jne	short @116@758
   ;	
   ;	  showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
@116@758:
   ;	
   ;	 if (SysBuf.function == 0x13)
   ;	
	cmp	byte ptr MGRP:_SysBuf,19
	jne	short @116@814
   ;	
   ;	  hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
@116@814:
   ;	
   ;	 if (SysBuf.function == 0x14)
   ;	
	cmp	byte ptr MGRP:_SysBuf,20
	jne	short @116@870
   ;	
   ;	  Bar (SysBuf.word1,SysBuf.word2,SysBuf.word3,SysBuf.word4);
   ;	
	push	dword ptr MGRP:_SysBuf+7
	push	dword ptr MGRP:_SysBuf+3
	call	near ptr MGRP:_Bar
	add	sp,8
@116@870:
   ;	
   ;	 if (SysBuf.function == 0x15)
   ;	
	cmp	byte ptr MGRP:_SysBuf,21
	jne	short @116@926
   ;	
   ;	  Rectangle (SysBuf.word1,SysBuf.word2,SysBuf.word3,SysBuf.word4);
   ;	
	push	dword ptr MGRP:_SysBuf+7
	push	dword ptr MGRP:_SysBuf+3
	call	near ptr MGRP:_Rectangle
	add	sp,8
@116@926:
   ;	
   ;	 if (SysBuf.function == 0x16)
   ;	
	cmp	byte ptr MGRP:_SysBuf,22
	jne	short @116@982
   ;	
   ;	  console ();
   ;	
	call	near ptr MGRP:_console
@116@982:
   ;	
   ;	 if (SysBuf.function == 0x17)
   ;	
	cmp	byte ptr MGRP:_SysBuf,23
	jne	short @116@1038
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,SysBuf.word5,SysBuf.word6,49);
   ;	
	push	49
	push	dword ptr MGRP:_SysBuf+11
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  MessageBox (TempString);
   ;	
	push	offset MGRP:TempString
	call	near ptr MGRP:_MessageBox
	pop	cx
@116@1038:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x18)
   ;	
	cmp	byte ptr MGRP:_SysBuf,24
	jne	short @116@1094
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,SysBuf.word5,SysBuf.word6,49);
   ;	
	push	49
	push	dword ptr MGRP:_SysBuf+11
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  CommandTerm (TempString,SysBuf.byte1);
   ;	
	mov	al,byte ptr MGRP:_SysBuf+1
	push	ax
	push	offset MGRP:TempString
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@116@1094:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x19)
   ;	
	cmp	byte ptr MGRP:_SysBuf,25
	jne	short @116@1150
   ;	
   ;	 {
   ;	  memcpy (_CS,(unsigned int)TempString,SysBuf.word5,SysBuf.word6,49);
   ;	
	push	49
	push	dword ptr MGRP:_SysBuf+11
	push	offset MGRP:TempString
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	  ShowIcon (SysBuf.word1+((HWND)(SysBuf.dword1))->x+5,
   ;	
   ;	
   ;		    SysBuf.word2+((HWND)(SysBuf.dword1))->y+20,TempString);
   ;	
	push	offset MGRP:TempString
	les	bx,dword ptr MGRP:_SysBuf+15
	mov	ax,word ptr MGRP:_SysBuf+5
	add	ax,word ptr es:[bx+2]
	add	ax,20
	push	ax
	mov	ax,word ptr MGRP:_SysBuf+3
	add	ax,word ptr es:[bx]
	add	ax,5
	push	ax
	call	near ptr MGRP:_ShowIcon
	add	sp,6
@116@1150:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x20)
   ;	
	cmp	byte ptr MGRP:_SysBuf,32
	jne	short @116@1206
   ;	
   ;	  DestroyWindow ( (HWND)SysBuf.dword1 );
   ;	
	push	dword ptr MGRP:_SysBuf+15
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
@116@1206:
   ;	
   ;	 if (SysBuf.function == 0x21)
   ;	
	cmp	byte ptr MGRP:_SysBuf,33
	jne	short @116@1262
   ;	
   ;	 {
   ;	  ((CONTROL)(SysBuf.dword1))->size = SysBuf.word1;
   ;	
	les	bx,dword ptr MGRP:_SysBuf+15
	mov	ax,word ptr MGRP:_SysBuf+3
	mov	word ptr es:[bx+18],ax
   ;	
   ;	  aci = 0;
   ;	
	mov	word ptr MGRP:_aci,0
   ;	
   ;	  acX = ((CONTROL)(SysBuf.dword1))->x+5;
   ;	
	mov	ax,word ptr es:[bx]
	add	ax,5
	mov	word ptr MGRP:_acX,ax
   ;	
   ;	  acY = ((CONTROL)(SysBuf.dword1))->y+20;
   ;	
	mov	ax,word ptr es:[bx+2]
	add	ax,20
	mov	word ptr MGRP:_acY,ax
   ;	
   ;	  TextArea ( ((CONTROL)(SysBuf.dword1))->x,((CONTROL)(SysBuf.dword1))->y,
   ;	
   ;	
   ;		     ((CONTROL)(SysBuf.dword1))->w,((CONTROL)(SysBuf.dword1))->h,
   ;		     ((CONTROL)(SysBuf.dword1))->StrSegment,1234,SysBuf.word1);
   ;	
	push	word ptr MGRP:_SysBuf+3
	push	1234
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr MGRP:_TextArea
	add	sp,14
@116@1262:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x22)
   ;	
	cmp	byte ptr MGRP:_SysBuf,34
	jne	short @116@1318
   ;	
   ;	 {
   ;	  SysBuf.word1 = ((CONTROL)(SysBuf.dword1))->size;
   ;	
	les	bx,dword ptr MGRP:_SysBuf+15
	mov	ax,word ptr es:[bx+18]
	mov	word ptr MGRP:_SysBuf+3,ax
@116@1318:
   ;	
   ;	 }
   ;	
   ;	 if (SysBuf.function == 0x23)
   ;	
	cmp	byte ptr MGRP:_SysBuf,35
	jne	short @116@1374
   ;	
   ;	 {
   ;	  protectedWnd = (HWND)SysBuf.dword1;
   ;	
	mov	eax,dword ptr MGRP:_SysBuf+15
	mov	dword ptr MGRP:protectedWnd,eax
@116@1374:
   ;	
   ;	 }
   ;	 if (SysBuf.function == 0x24) InitFullApp ();
   ;	
	cmp	byte ptr MGRP:_SysBuf,36
	jne	short @116@1430
	call	near ptr MGRP:_InitFullApp
@116@1430:
   ;	
   ;	 if (SysBuf.function == 0x25) CloseFullApp ();
   ;	
	cmp	byte ptr MGRP:_SysBuf,37
	jne	short @116@1486
	call	near ptr MGRP:_CloseFullApp
@116@1486:
   ;	
   ;	 if (SysBuf.function == 0x26) console ();
   ;	
	cmp	byte ptr MGRP:_SysBuf,38
	jne	short @116@1542
	call	near ptr MGRP:_console
@116@1542:
   ;	
   ;	 if (SysBuf.function == 0x27) About ();
   ;	
	cmp	byte ptr MGRP:_SysBuf,39
	jne	short @116@1598
	call	near ptr MGRP:_About
@116@1598:
   ;	
   ;	 if (SysBuf.function == 0x28) halt();
   ;	
	cmp	byte ptr MGRP:_SysBuf,40
	jne	short @116@1654
	call	near ptr MGRP:_halt
@116@1654:
   ;	
   ;	 if (SysBuf.function == 0x29) ShowMem ();
   ;	
	cmp	byte ptr MGRP:_SysBuf,41
	jne	short @116@1710
	call	near ptr MGRP:_ShowMem
@116@1710:
   ;	
   ;	 if (SysBuf.function == 0x30)
   ;	
	cmp	byte ptr MGRP:_SysBuf,48
	jne	short @116@1766
   ;	
   ;	 {
   ;	  SysBuf.byte1 = gmode ;
   ;	
	mov	al,byte ptr MGRP:_gmode
	mov	byte ptr MGRP:_SysBuf+1,al
@116@1766:
   ;	
   ;	 }
   ;	
   ;	 _AX = DataSegment;
   ;	
	mov	ax,word ptr MGRP:DataSegment
   ;	
   ;	 _DS = _AX;
   ;	
	mov	ds,ax
   ;	
   ;	
   ;	 asm popa
   ;	
 	popa	
   ;	
   ;	 asm sti
   ;	
 	sti	
   ;	
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
_Int48	endp
   ;	
   ;	char GetProc (void)
   ;	
	assume	cs:MGRP
_GetProc	proc	near
	push	si
   ;	
   ;	{
   ;	 asm {
   ;	  push ds
   ;	
	push	 ds
   ;	
   ;	  push si
   ;	
	push	 si
   ;	
   ;	  mov ah,0x19
   ;	
	mov	 ah,019H
   ;	
   ;	  int 0x44
   ;	
	int	 044H
   ;	
   ;	  mov ax,0x2000
   ;	
	mov	 ax,02000H
   ;	
   ;	  mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	  mov al,ds:[si]
   ;	
	mov	 al,ds:[si]
   ;	
   ;	  pop si
   ;	
	pop	 si
   ;	
   ;	  pop ds
   ;	
	pop	 ds
   ;	
   ;	  }
   ;	}
   ;	
	pop	si
	ret	
_GetProc	endp
   ;	
   ;	void About (void)
   ;	
	assume	cs:MGRP
_About	proc	near
	push	si
   ;	
   ;	{
   ;	 int i;
   ;	
   ;	 BGWindow = 0;
   ;	
	mov	byte ptr MGRP:BGWindow,0
   ;	
   ;	 hidemouse ();          
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 i = (gmode == 1) ? 0 : 80;
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @118@86
	xor	ax,ax
	jmp	short @118@114
@118@86:
	mov	ax,80
@118@114:
	mov	si,ax
   ;	
   ;	 CreateWindow (160+i,50,320,220+14,3,"About");
   ;	
	push	offset MGRP:s@+84
	push	3
	push	large 000EA0140h
	push	50
	add	ax,160
	push	ax
	call	near ptr MGRP:_CreateWindow
	add	sp,12
   ;	
   ;	
   ;	 pic ("/qwin/logo.pic",50+10);
   ;	
	push	60
	push	offset MGRP:s@+90
	call	near ptr MGRP:_pic
	add	sp,4
   ;	
   ;	 BGWindow = 7;
   ;	
	mov	byte ptr MGRP:BGWindow,7
   ;	
   ;	// ShowIcon (93,145,"/qwin/eye.ico");
   ;	// setFont (0);
   ;	// SetColor (12);
   ;	// OutTextXY (130,145,"QuickWindows");
   ;	// Line (130,160,234,160);
   ;	 setFont (2);
   ;	
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 OutTextXY (170+8+i,abouty,"CPU:");
   ;	
	push	offset MGRP:s@+105
	push	260
	mov	ax,si
	add	ax,178
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 OutTextXY (170+100+i,abouty,"Kernel:");
   ;	
	push	offset MGRP:s@+110
	push	260
	mov	ax,si
	add	ax,270
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 OutTextXY (170+100+120+8+i,abouty,"Memory:");
   ;	
	push	offset MGRP:s@+118
	push	260
	mov	ax,si
	add	ax,398
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 OutTextXY (170+5*8+i,abouty," 86");
   ;	
	push	offset MGRP:s@+126
	push	260
	mov	ax,si
	add	ax,210
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 OutTextXY (170+100+7*8+8+i,abouty,"R0.5");
   ;	
	push	offset MGRP:s@+130
	push	260
	mov	ax,si
	add	ax,334
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,6
   ;	
   ;	 PrintChar (GetProc (),170+5*8+i,abouty,7,255,0);
   ;	
	push	0
	push	255
	push	7
	push	260
	mov	ax,si
	add	ax,210
	push	ax
	call	near ptr MGRP:_GetProc
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	 PrintChar ( ((HiMemoryAvailable () / 1024) / 10)+48,390+8*7+8+i,abouty,7,255,0);
   ;	
	push	0
	push	255
	push	7
	push	260
	mov	ax,si
	add	ax,454
	push	ax
	call	near ptr MGRP:_HiMemoryAvailable
	shr	ax,10
	mov	bx,10
	xor	dx,dx
	div	bx
	add	al,48
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	 PrintChar ( ((HiMemoryAvailable () / 1024) % 10)+48+1,390+8*7+8+8+i,abouty,7,255,0);
   ;	
	push	0
	push	255
	push	7
	push	260
	mov	ax,si
	add	ax,462
	push	ax
	call	near ptr MGRP:_HiMemoryAvailable
	shr	ax,10
	mov	bx,10
	xor	dx,dx
	div	bx
	add	dl,49
	push	dx
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	 setFont (2);
   ;	
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	 BGWindow = 7;
   ;	
	mov	byte ptr MGRP:BGWindow,7
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	}
   ;	
	pop	si
	ret	
_About	endp
   ;	
   ;	void VideoLock (void)
   ;	
	assume	cs:MGRP
_VideoLock	proc	near
   ;	
   ;	{
   ;	 SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
@119@30:
   ;	
   ;	 while ( !is_key () ) ;
   ;	
	call	near ptr MGRP:_is_key
	mov	ah,0
	or	ax,ax
	je	short @119@30
   ;	
   ;	 SetVideo (ON);
   ;	
	push	0
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	}
   ;	
	ret	
_VideoLock	endp
   ;	
   ;	void CommandTerm (char* tcmd, char scr)
   ;	
	assume	cs:MGRP
_CommandTerm	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 if (scr != 1) WriteKey ('@');
   ;	
	cmp	byte ptr [bp+6],1
	je	short @120@86
	push	64
	call	near ptr MGRP:_WriteKey
	pop	cx
@120@86:
   ;	
   ;	 for (i = 0; tcmd[i] != 0; i++)
   ;	
	xor	si,si
	jmp	short @120@170
@120@114:
   ;	
   ;	  WriteKey (tcmd[i]);
   ;	
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_WriteKey
	pop	cx
	inc	si
@120@170:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @120@114
   ;	
   ;	 WriteKey ('\r');
   ;	
	push	13
	call	near ptr MGRP:_WriteKey
	pop	cx
   ;	
   ;	 console ();
   ;	
	call	near ptr MGRP:_console
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_CommandTerm	endp
   ;	
   ;	 char peekchar (unsigned int ofs)
   ;	
	assume	cs:MGRP
_peekchar	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	 {
   ;	  asm {
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push si
   ;	
	push	 si
   ;	
   ;		mov ax,bufferbatch
   ;	
	mov	 ax,bufferbatch
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,ofs
   ;	
	mov	 si,[bp+4]
   ;	
   ;		lodsb
   ;	
	lodsb	
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;	      }
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_peekchar	endp
   ;	
   ;	 void putchar (unsigned int ofs,char pc)
   ;	
	assume	cs:MGRP
_putchar	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,bufferbatch
   ;	
	mov	 ax,bufferbatch
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,ofs
   ;	
	mov	 di,[bp+4]
   ;	
   ;		mov al,pc
   ;	
	mov	 al,[bp+6]
   ;	
   ;		stosb
   ;	
	stosb	
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	      }
   ;	 }
   ;	
	pop	di
	pop	bp
	ret	
_putchar	endp
   ;	
   ;	 int fgets (char* s)
   ;	
	assume	cs:MGRP
_fgets	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	 {
   ;	  int i;
   ;	  for (i=0; (peekchar (file_offset+i) != 13) && (peekchar (file_offset+i) != 0);i++) s[i] = peekchar (file_offset+i);
   ;	
	xor	si,si
	jmp	short @123@114
@123@58:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	mov	bx,si
	mov	byte ptr [bx+di],al
	inc	si
@123@114:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	cmp	al,13
	je	short @123@170
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @123@58
@123@170:
   ;	
   ;	  if (peekchar (file_offset+i) == 0) return 0;
   ;	
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @123@226
	xor	ax,ax
	jmp	short @123@254
@123@226:
   ;	
   ;	  s[i] = 0;
   ;	
	mov	bx,si
	mov	byte ptr [bx+di],0
   ;	
   ;	  file_offset += i+2;
   ;	
	mov	ax,si
	add	ax,2
	add	word ptr MGRP:_file_offset,ax
   ;	
   ;	  return 1;
   ;	
	mov	ax,1
@123@254:
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fgets	endp
   ;	
   ;	 char* script (char *batchfile)
   ;	
	assume	cs:MGRP
_script	proc	near
	enter	6,0
	push	si
   ;	
   ;	 {
   ;	  handle bfile;
   ;	  char ScanFile;
   ;	  int counter=0;
   ;	
   ;	
   ;	  int result;
   ;	
   ;	  bfile = fopen (batchfile);
   ;	
	push	word ptr [bp+4]
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (bfile < 2) return;
   ;	
	cmp	dword ptr [bp-4],large 2
	jae short	@@101
	jmp	@124@450
@@101:
   ;	
   ;	  bufferbatch = malloc ( (fsize (bfile) / 16) + 1);
   ;	
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fsize
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shr	eax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:bufferbatch,ax
   ;	
   ;	  if (!bufferbatch) return;
   ;	
	cmp	word ptr MGRP:bufferbatch,0
	jne short	@@102
	jmp	@124@450
@@102:
   ;	
   ;	  counter = 0;
   ;	
	xor	si,si
   ;	
   ;	  fread (bfile,fsize (bfile),0,bufferbatch);
   ;	
	push	word ptr MGRP:bufferbatch
	push	0
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	  file_offset = 0;
   ;	
	mov	word ptr MGRP:_file_offset,0
   ;	
   ;	
   ;	  rcCmd [0] = (char far*)MakePtr (bufferbatch,file_offset);
   ;	
	push	word ptr MGRP:_file_offset
	push	word ptr MGRP:bufferbatch
	call	near ptr MGRP:_MakePtr
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shld	edx,eax,16
	mov	word ptr MGRP:_rcCmd+2,dx
	mov	word ptr MGRP:_rcCmd,ax
	jmp	short @124@254
@124@114:
   ;	
   ;	
   ;	  for ( ; ScanFile != '!' ; file_offset++)
   ;	  {
   ;	   ScanFile = peekchar (file_offset);
   ;	
	push	word ptr MGRP:_file_offset
	call	near ptr MGRP:_peekchar
	pop	cx
	mov	byte ptr [bp-5],al
   ;	
   ;	   if (ScanFile == 13) putchar (file_offset,32);
   ;	
	cmp	byte ptr [bp-5],13
	jne	short @124@170
	push	32
	push	word ptr MGRP:_file_offset
	call	near ptr MGRP:_putchar
	add	sp,4
@124@170:
   ;	
   ;	   if (ScanFile == 10)
   ;	
	cmp	byte ptr [bp-5],10
	jne	short @124@226
   ;	
   ;	   {
   ;	    putchar (file_offset,0);
   ;	
	push	0
	push	word ptr MGRP:_file_offset
	call	near ptr MGRP:_putchar
	add	sp,4
   ;	
   ;	    counter++;
   ;	
	inc	si
   ;	
   ;	    rcCmd [counter] = (char far*)MakePtr (bufferbatch,file_offset+1);
   ;	
	mov	ax,word ptr MGRP:_file_offset
	inc	ax
	push	ax
	push	word ptr MGRP:bufferbatch
	call	near ptr MGRP:_MakePtr
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shld	edx,eax,16
	mov	bx,si
	shl	bx,2
	mov	word ptr MGRP:_rcCmd[bx+2],dx
	mov	word ptr MGRP:_rcCmd[bx],ax
@124@226:
	inc	word ptr MGRP:_file_offset
@124@254:
	cmp	byte ptr [bp-5],33
	jne	short @124@114
   ;	
   ;	   }
   ;	  }
   ;	  result = popup (counter,rcCmd, mx, my,100);
   ;	
	push	100
	push	word ptr MGRP:my
	push	word ptr MGRP:mx
	push	offset MGRP:_rcCmd
	push	si
	call	near ptr MGRP:_popup
	add	sp,10
	mov	si,ax
   ;	
   ;	  if (result == 0)
   ;	
	or	si,si
	jne	short @124@338
   ;	
   ;	  {
   ;	   strcpy (cmdsh,"$");
   ;	
	push	offset MGRP:s@+135
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_strcpy
	add	sp,4
	jmp	short @124@422
@124@338:
   ;	
   ;	   free (bufferbatch);
   ;	   return cmdsh;
   ;	  }
   ;	  file_offset += 2;
   ;	
	add	word ptr MGRP:_file_offset,2
	jmp	short @124@394
@124@366:
   ;	
   ;	
   ;	  while ( result != 0)
   ;	  {
   ;	   fgets (cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_fgets
	pop	cx
   ;	
   ;	   result--;
   ;	
	dec	si
@124@394:
	or	si,si
	jne	short @124@366
@124@422:
   ;	
   ;	  }
   ;	
   ;	  free (bufferbatch);
   ;	
	push	word ptr MGRP:bufferbatch
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	  return cmdsh;
   ;	
	mov	ax,offset MGRP:_cmdsh
@124@450:
   ;	
   ;	 }
   ;	
	pop	si
	leave	
	ret	
_script	endp
   ;	
   ;	void FullScreenShell (void)
   ;	
	assume	cs:MGRP
_FullScreenShell	proc	near
   ;	
   ;	{
   ;	 InitFullApp ();
   ;	
	call	near ptr MGRP:_InitFullApp
   ;	
   ;	 asm {
   ;		mov ah,3
   ;	
	mov	 ah,3
   ;	
   ;		mov al,0
   ;	
	mov	 al,0
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;		mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	 shell = get_shell ();
   ;	
	call	near ptr MGRP:_get_shell
	mov	word ptr MGRP:_shell+2,dx
	mov	word ptr MGRP:_shell,ax
   ;	
   ;	 shell ((char)0);
   ;	
	push	0
	call	dword ptr MGRP:_shell
	pop	cx
   ;	
   ;	 _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
   ;	
   ;	 if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @125@226
   ;	
   ;	  init640480 ();
   ;	
	call	near ptr MGRP:_init640480
	jmp	short @125@254
@125@226:
   ;	
   ;	 else
   ;	  init800600 ();
   ;	
	call	near ptr MGRP:_init800600
@125@254:
   ;	
   ;	 SetRGB (1,Pal[0],Pal[1],Pal[2]);
   ;	
	mov	al,byte ptr MGRP:_Pal+2
	push	ax
	mov	al,byte ptr MGRP:_Pal+1
	push	ax
	mov	al,byte ptr MGRP:_Pal
	push	ax
	push	1
	call	near ptr MGRP:_SetRGB
	add	sp,8
   ;	
   ;	 SetRGB (3,Pal[3],Pal[4],Pal[5]);
   ;	
	mov	al,byte ptr MGRP:_Pal+5
	push	ax
	mov	al,byte ptr MGRP:_Pal+4
	push	ax
	mov	al,byte ptr MGRP:_Pal+3
	push	ax
	push	3
	call	near ptr MGRP:_SetRGB
	add	sp,8
   ;	
   ;	  asm {
   ;		mov ah,3
   ;	
	mov	 ah,3
   ;	
   ;		mov al,1
   ;	
	mov	 al,1
   ;	
   ;		mov bx,cs
   ;	
	mov	 bx,cs
   ;	
   ;		mov cx,offset SysBuf
   ;	
	mov	 cx,offset MGRP:_SysBuf
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;	     }
   ;	 CloseFullApp ();
   ;	
	call	near ptr MGRP:_CloseFullApp
   ;	
   ;	
   ;	}
   ;	
	ret	
_FullScreenShell	endp
_reboot	label	dword
	db	0
	db	0
	db	255
	db	255
   ;	
   ;	void TickMenu (void)
   ;	
	assume	cs:MGRP
_TickMenu	proc	near
   ;	
   ;	{ 
   ;	 if (is_full_app) return;
   ;	
	cmp	byte ptr MGRP:is_full_app,0
	je short	@@103
	jmp	@126@870
@@103:
   ;	
   ;	
   ;	 strcpy (fileS,"/etc/qwin.rc");
   ;	
	push	offset MGRP:s@+137
@126@58:
	push	offset MGRP:_fileS
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	 OtherMenu:
   ;	
   ;	 strcpy (resultS,script (fileS));
   ;	
	push	offset MGRP:_fileS
	call	near ptr MGRP:_script
	pop	cx
	push	ax
	push	offset MGRP:_resultS
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	 if (resultS [0] == '$') return;
   ;	
	cmp	byte ptr MGRP:_resultS,36
	jne short	@@104
	jmp	@126@870
@@104:
   ;	
   ;	 if (resultS [0] == '@') exec (resultS+1,0,0);
   ;	
	cmp	byte ptr MGRP:_resultS,64
	jne	short @126@170
	push	large 0
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_exec
	add	sp,6
@126@170:
   ;	
   ;	 if (resultS [0] == '*') CommandTerm (resultS+1,0);
   ;	
	cmp	byte ptr MGRP:_resultS,42
	jne	short @126@226
	push	0
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@126@226:
   ;	
   ;	 if (resultS [0] == '~') CommandTerm (resultS+1,1);
   ;	
	cmp	byte ptr MGRP:_resultS,126
	jne	short @126@282
	push	1
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@126@282:
   ;	
   ;	 if (resultS [0] == '&')
   ;	
	cmp	byte ptr MGRP:_resultS,38
	je short	@@105
	jmp	@126@814
@@105:
   ;	
   ;	 {
   ;	  if (!strcmp (resultS+1,"quit")) quit = 1;
   ;	
	push	offset MGRP:s@+150
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@366
	mov	word ptr MGRP:_quit,1
@126@366:
   ;	
   ;	  if (!strcmp (resultS+1,"clean")) DestroyAllWindows ();
   ;	
	push	offset MGRP:s@+155
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@422
	call	near ptr MGRP:_DestroyAllWindows
@126@422:
   ;	
   ;	  if (!strcmp (resultS+1,"halt"))
   ;	
	push	offset MGRP:s@+161
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@478
   ;	
   ;	  {
   ;	    halt ();
   ;	
	call	near ptr MGRP:_halt
@126@478:
   ;	
   ;	  }
   ;	  if (!strcmp (resultS+1,"term")) console ();
   ;	
	push	offset MGRP:s@+166
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@534
	call	near ptr MGRP:_console
@126@534:
   ;	
   ;	  if (!strcmp (resultS+1,"fterm")) FullScreenShell ();
   ;	
	push	offset MGRP:s@+171
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@590
	call	near ptr MGRP:_FullScreenShell
@126@590:
   ;	
   ;	  if (!strcmp (resultS+1,"vlock")) VideoLock ();
   ;	
	push	offset MGRP:s@+177
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@646
	call	near ptr MGRP:_VideoLock
@126@646:
   ;	
   ;	  if (!strcmp (resultS+1,"reboot")) reboot ();
   ;	
	push	offset MGRP:s@+183
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@702
	call	dword ptr MGRP:_reboot
@126@702:
   ;	
   ;	  if (!strcmp (resultS+1,"about")) About ();
   ;	
	push	offset MGRP:s@+190
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@758
	call	near ptr MGRP:_About
@126@758:
   ;	
   ;	  if (!strcmp (resultS+1,"mem")) ShowMem ();
   ;	
	push	offset MGRP:s@+196
	push	offset MGRP:_resultS+1
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @126@814
	call	near ptr MGRP:_ShowMem
@126@814:
   ;	
   ;	 }
   ;	 if (resultS [0] == '#') { strcpy (fileS,resultS+1); goto OtherMenu; }
   ;	
	cmp	byte ptr MGRP:_resultS,35
	jne	short @126@870
	push	offset MGRP:_resultS+1
	jmp	@126@58
@126@870:
   ;	
   ;	}
   ;	
	ret	
_TickMenu	endp
   ;	
   ;	unsigned char logonok (void)
   ;	
	assume	cs:MGRP
_logonok	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	       push es
   ;	
	push	 es
   ;	
   ;	       mov ax,0x1000
   ;	
	mov	 ax,01000H
   ;	
   ;	       mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	       mov al,es:[0]
   ;	
	mov	 al,es:[0]
   ;	
   ;	       pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_logonok	endp
   ;	
   ;	unsigned char get_mode (void)
   ;	
	assume	cs:MGRP
_get_mode	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	 mov ah,9
   ;	
	mov	 ah,9
   ;	
   ;	 int 46h
   ;	
	int	 46h
   ;	
   ;	 }
   ;	}
   ;	
	ret	
_get_mode	endp
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	
   ;	 asm {
   ;		mov ah,3
   ;	
	mov	 ah,3
   ;	
   ;		mov al,1
   ;	
	mov	 al,1
   ;	
   ;		mov bx,cs
   ;	
	mov	 bx,cs
   ;	
   ;		mov cx,offset SysBuf
   ;	
	mov	 cx,offset MGRP:_SysBuf
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;	     }
   ;	
   ;	 
   ;	 gmode = get_mode ();
   ;	
	call	near ptr MGRP:_get_mode
   ;	
   ;	 gmode = 2;
   ;	
	mov	byte ptr MGRP:_gmode,2
   ;	
   ;	  if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @129@198
   ;	
   ;	   init640480 ();
   ;	
	call	near ptr MGRP:_init640480
	jmp	short @129@226
@129@198:
   ;	
   ;	  else 
   ;	   init800600 ();
   ;	
	call	near ptr MGRP:_init800600
@129@226:
   ;	
   ;	
   ;	// pic ("/qwin/boot.fig",140);
   ;	
   ;	 font_mem = malloc (768);
   ;	
	push	768
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_font_mem,ax
   ;	
   ;	 fntfile = fopen ("/lib/fnt/breeze.fnt");
   ;	
	push	offset MGRP:s@+200
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, 0, font_mem);
   ;	
	push	word ptr MGRP:_font_mem
	push	0
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/modern.fnt");
   ;	
	push	offset MGRP:s@+220
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)4096, font_mem);
   ;	
	push	word ptr MGRP:_font_mem
	push	4096
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/roman.fnt");
   ;	
	push	offset MGRP:s@+240
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)8192, font_mem);
   ;	
	push	word ptr MGRP:_font_mem
	push	8192
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 palfile = fopen ("/qwin/win.pal");
   ;	
	push	offset MGRP:s@+259
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_palfile,eax
   ;	
   ;	 fread (palfile,6,&Pal,_CS);
   ;	
	push	cs
	push	offset MGRP:_Pal
	push	large 6
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	
   ;	 isFont = 1;
   ;	
	mov	word ptr MGRP:_isFont,1
   ;	
   ;	 is_full_app = 0;
   ;	
	mov	byte ptr MGRP:is_full_app,0
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 Pa = 0;
   ;	
	mov	byte ptr MGRP:_Pa,0
   ;	
   ;	
   ;	 SetRGB (1,Pal[0],Pal[1],Pal[2]);
   ;	
	mov	al,byte ptr MGRP:_Pal+2
	push	ax
	mov	al,byte ptr MGRP:_Pal+1
	push	ax
	mov	al,byte ptr MGRP:_Pal
	push	ax
	push	1
	call	near ptr MGRP:_SetRGB
	add	sp,8
   ;	
   ;	
   ;	/*
   ;	 OutTextXY (30,450,"Input device: keyboard");
   ;	 if (ismouse () == 0xffff)
   ;	 {
   ;	  OutTextXY (30+(22*8),450,", mouse");
   ;	 }
   ;	*/
   ;	 //while ( !is_key () && (bmouse () != 1) );
   ;	
   ;	 SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 Background (1);
   ;	
	push	1
	call	near ptr MGRP:_Background
	pop	cx
   ;	
   ;	
   ;	 SetVideo (ON);
   ;	
	push	0
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	
   ;	 intr ((void*)&Int48,0x48);
   ;	
	push	72
	push	offset MGRP:_Int48
	call	near ptr MGRP:_intr
	add	sp,4
   ;	
   ;	 activeButton = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeButton,large 0
   ;	
   ;	 activeEditBox = (CONTROL)0;
   ;	
	mov	dword ptr MGRP:_activeEditBox,large 0
   ;	
   ;	
   ;	 
   ;	 HiMemoryInit ();
   ;	
	call	near ptr MGRP:_HiMemoryInit
   ;	
   ;	 
   ;	 palfile = fopen ("/qwin/qwin.ini");
   ;	
	push	offset MGRP:s@+273
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_palfile,eax
   ;	
   ;	 if (palfile < 2) return;
   ;	
	cmp	dword ptr MGRP:_palfile,large 2
	jae short	@@106
	jmp	@129@842
@@106:
   ;	
   ;	 bufferbatch = malloc ( (fsize (palfile) / 16) + 1);
   ;	
	push	dword ptr MGRP:_palfile
	call	near ptr MGRP:_fsize
	push	dx
	push	ax
	pop	eax
	add	sp,4
	shr	eax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:bufferbatch,ax
   ;	
   ;	 if (!bufferbatch) return;
   ;	
	cmp	word ptr MGRP:bufferbatch,0
	jne short	@@107
	jmp	@129@842
@@107:
   ;	
   ;	 fread (palfile,fsize (palfile),0,bufferbatch);
   ;	
	push	word ptr MGRP:bufferbatch
	push	0
	push	dword ptr MGRP:_palfile
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_palfile
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 file_offset = 0;
   ;	
	mov	word ptr MGRP:_file_offset,0
   ;	
   ;	
   ;	 cmdsh [0] = '\0' ;
   ;	
	mov	byte ptr MGRP:_cmdsh,0
	jmp	short @129@338
@129@310:
   ;	
   ;	
   ;	 while (cmdsh [0] != '>' )
   ;	 {
   ;	  fgets (cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_fgets
	pop	cx
   ;	
   ;	  exec (cmdsh,0,0);
   ;	
	push	large 0
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_exec
	add	sp,6
@129@338:
	cmp	byte ptr MGRP:_cmdsh,62
	jne	short @129@310
   ;	
   ;	 }
   ;	 
   ;	 free (bufferbatch);
   ;	
	push	word ptr MGRP:bufferbatch
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 
   ;	 //exec ("/qwin/dock",0,0);
   ;	
   ;	 mx = 0;
   ;	
	mov	word ptr MGRP:mx,0
   ;	
   ;	 my = 0;
   ;	
	mov	word ptr MGRP:my,0
   ;	
   ;	
   ;	 if (ismouse () == 0xffff)
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @129@506
   ;	
   ;	 {
   ;	  mouse_status = 1;
   ;	
	mov	word ptr MGRP:mouse_status,1
   ;	
   ;	  if (gmode == 1)
   ;	
	cmp	byte ptr MGRP:_gmode,1
	jne	short @129@450
   ;	
   ;	   init_mouse (640,480);
   ;	
	push	large 001E00280h
	jmp	short @129@478
@129@450:
   ;	
   ;	  else
   ;	  init_mouse (800,600);
   ;	
	push	large 002580320h
@129@478:
	call	near ptr MGRP:_init_mouse
	add	sp,4
@129@506:
   ;	
   ;	 }
   ;	
   ;	 SetRGB (3,Pal[3],Pal[4],Pal[5]);
   ;	
	mov	al,byte ptr MGRP:_Pal+5
	push	ax
	mov	al,byte ptr MGRP:_Pal+4
	push	ax
	mov	al,byte ptr MGRP:_Pal+3
	push	ax
	push	3
	call	near ptr MGRP:_SetRGB
	add	sp,8
   ;	
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	
   ;	 WindowManager ();
   ;	
	call	near ptr MGRP:_WindowManager
   ;	
   ;	
   ;	 shut ();
   ;	
	call	near ptr MGRP:_shut
   ;	
   ;	// end session
   ;	
   ;	 if (ismouse () == 0xffff) shut_mouse ();
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @129@562
	call	near ptr MGRP:_shut_mouse
@129@562:
   ;	
   ;	
   ;	 asm {
   ;		mov ah,5
   ;	
	mov	 ah,5
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;	     }
   ;	
   ;	 asm {
   ;		mov ah,3
   ;	
	mov	 ah,3
   ;	
   ;		mov al,0
   ;	
	mov	 al,0
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;		mov ah,7
   ;	
	mov	 ah,7
   ;	
   ;		int 0x46
   ;	
	int	 046H
   ;	
   ;		mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	
   ;	 free (font_mem);
   ;	
	push	word ptr MGRP:_font_mem
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 protectedWnd = (HWND)0;
   ;	
	mov	dword ptr MGRP:protectedWnd,large 0
   ;	
   ;	 DestroyAllWindows ();
   ;	
	call	near ptr MGRP:_DestroyAllWindows
   ;	
   ;	 free (_CS);
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@129@842:
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_palfile	label	word
	db	4 dup (0)
_fntfile	label	word
	db	4 dup (0)
_resultS	label	byte
	db	24 dup (0)
_fileS	label	byte
	db	24 dup (0)
_rcCmd	label	dword
	db	96 dup (0)
_cmdsh	label	byte
	db	30 dup (0)
_file_offset	label	word
	db	2 dup (0)
bufferbatch	label	word
	db	2 dup (0)
DataSegment	label	word
	db	2 dup (0)
_Xkey	label	word
	db	2 dup (0)
_Pa	label	byte
	db	1 dup (0)
_xmod	label	byte
	db	1 dup (0)
_HoldKey	label	byte
	db	1 dup (0)
LastEditBox	label	dword
	db	4 dup (0)
_FarEditString	label	dword
	db	4 dup (0)
_acY	label	word
	db	2 dup (0)
_acX	label	word
	db	2 dup (0)
_aci	label	word
	db	2 dup (0)
_FarTABuffer	label	dword
	db	4 dup (0)
keycode	label	byte
	db	1 dup (0)
mpic	label	word
	db	2 dup (0)
_IcoPix	label	dword
	db	4096 dup (0)
_IcoMem	label	word
	db	2 dup (0)
_icoFile	label	word
	db	4 dup (0)
show_mouse	label	word
	db	2 dup (0)
MouseB	label	word
	db	2 dup (0)
MouseY	label	word
	db	2 dup (0)
MouseX	label	word
	db	2 dup (0)
dumWnd	label	dword
	db	4 dup (0)
_screen_seg5	label	word
	db	4 dup (0)
_screen_seg4	label	word
	db	4 dup (0)
_screen_seg3	label	word
	db	4 dup (0)
_screen_seg2	label	word
	db	4 dup (0)
_screen_seg1	label	word
	db	4 dup (0)
is_full_app	label	byte
	db	1 dup (0)
_keysh	label	word
	db	2 dup (0)
_shell	label	dword
	db	4 dup (0)
DataSegmentSh	label	word
	db	2 dup (0)
_shc	label	byte
	db	1 dup (0)
_delta	label	word
	db	2 dup (0)
_hWndSh	label	dword
	db	4 dup (0)
tempControl	label	dword
	db	4 dup (0)
dumControl	label	dword
	db	4 dup (0)
_activeButton	label	dword
	db	4 dup (0)
_activeEditBox	label	dword
	db	4 dup (0)
_SysBuf	label	word
	db	21 dup (0)
_Pal	label	byte
	db	6 dup (0)
byb	label	byte
	db	1 dup (0)
kb	label	byte
	db	1 dup (0)
by	label	byte
	db	1 dup (0)
k	label	byte
	db	1 dup (0)
i	label	word
	db	2 dup (0)
swap	label	byte
	db	28 dup (0)
mb	label	word
	db	2 dup (0)
my	label	word
	db	2 dup (0)
mx	label	word
	db	2 dup (0)
BlockSize	label	word
	db	4 dup (0)
Xflag	label	byte
	db	1 dup (0)
TempSize	label	word
	db	4 dup (0)
HiMemoryUsed	label	word
	db	4 dup (0)
_deltaw	label	word
	db	2 dup (0)
TempString	label	byte
	db	50 dup (0)
_font_mem	label	word
	db	2 dup (0)
_backc	label	word
	db	2 dup (0)
	?debug	C E9
	?debug	C FA10010000
s@	label	byte
	db	'ERROR HIMEM'
	db	0
	db	'Shell'
	db	0
	db	'Window too big'
	db	0
	db	'Memory Usage'
	db	0
	db	'Real Memory'
	db	0
	db	'High Memory'
	db	0
	db	'/lib/shut.bmp'
	db	0
	db	'About'
	db	0
	db	'/qwin/logo.pic'
	db	0
	db	'CPU:'
	db	0
	db	'Kernel:'
	db	0
	db	'Memory:'
	db	0
	db	' 86'
	db	0
	db	'R0.5'
	db	0
	db	'$'
	db	0
	db	'/etc/qwin.rc'
	db	0
	db	'quit'
	db	0
	db	'clean'
	db	0
	db	'halt'
	db	0
	db	'term'
	db	0
	db	'fterm'
	db	0
	db	'vlock'
	db	0
	db	'reboot'
	db	0
	db	'about'
	db	0
	db	'mem'
	db	0
	db	'/lib/fnt/breeze.fnt'
	db	0
	db	'/lib/fnt/modern.fnt'
	db	0
	db	'/lib/fnt/roman.fnt'
	db	0
	db	'/qwin/win.pal'
	db	0
	db	'/qwin/qwin.ini'
	db	0
	extrn	DGROUP@:word
VPSEG	ends
	public	_get_mode
	public	_logonok
	public	_palfile
	public	_fntfile
	public	_resultS
	public	_fileS
	public	_reboot
	public	_script
	public	_rcCmd
	public	_cmdsh
	public	_fgets
	public	_file_offset
	public	_putchar
	public	_peekchar
_bufferbatch	equ	bufferbatch
	public	_VideoLock
	public	_GetProc
	public	_Int48
_DataSegment	equ	DataSegment
	public	_MakePtr
	public	_intr
	public	_WindowManager
	public	_Xkey
	public	_quit
	public	_CreateControl
	public	_ExecuteControl
	public	_Pa
	public	_xmod
	public	_HoldKey
	public	_TurnControl
	public	_EditBoxPut
	public	_WriteKey
_LastEditBox	equ	LastEditBox
	public	_EditBoxReadLn
	public	_FarEditString
	public	_TextArea
	public	_acY
	public	_acX
	public	_aci
	public	_send_char
	public	_InsText
	public	_DelText
	public	_DispText
	public	_FarTABuffer
	public	_ReadKey
_keycode	equ	keycode
	public	_popup
	public	_ShowMem
	public	_pic
	public	_pic_peek
_mpic	equ	mpic
	public	_ShowIcon
	public	_IsMask
	public	_gs
	public	_IcoPix
	public	_IcoMem
	public	_icoFile
	public	_scankey
	public	_shut_mouse
	public	_init_mouse
	public	_ismouse
	public	_mouse_handler
_show_mouse	equ	show_mouse
	public	_MoveWindow
_MouseB	equ	MouseB
_MouseY	equ	MouseY
_MouseX	equ	MouseX
	public	_TurnWindow
	public	_DestroyAllWindows
	public	_DestroyControl
	public	_NextWindow
_TempString2	equ	TempString2
_dumWnd	equ	dumWnd
	public	_CloseFullApp
	public	_InitFullApp
	public	_screen_seg5
	public	_screen_seg4
	public	_screen_seg3
	public	_screen_seg2
	public	_screen_seg1
_is_full_app	equ	is_full_app
	public	_console
	public	_WinMainSh
	public	_keysh
	public	_shell
_DataSegmentSh	equ	DataSegmentSh
	public	_set_int_29
	public	_int29
	public	_exiting
	public	_shc
	public	_delta
	public	_wy
	public	_wx
	public	_iy
	public	_ix
	public	_shY
	public	_shX
	public	_get_shell
	public	_hWndSh
	public	_SwitchWindow
	public	_DestroyWindow
	public	_CreateWindow
	public	_displayChar
	public	_restore_area
	public	_save_area
_tempControl	equ	tempControl
_dumControl	equ	dumControl
	public	_activeButton
	public	_activeEditBox
	public	_FindLastButton
	public	_FindLastEditBox
_protectedWnd	equ	protectedWnd
_topWnd	equ	topWnd
	public	_SysBuf
	public	_Pal
_mouse_status	equ	mouse_status
_byb	equ	byb
_kb	equ	kb
_by	equ	by
_k	equ	k
_flag	equ	flag
_i	equ	i
_swap	equ	swap
_cursor	equ	cursor
_oldy	equ	oldy
_oldx	equ	oldx
_mb	equ	mb
_my	equ	my
_mx	equ	mx
	public	_PosString
	public	_Xgetch
	public	_getch
	public	_is_key
	public	_is_alt
	public	_avail
	public	_free
	public	_malloc
	public	_HiMemoryInit
	public	_HiMemoryFree
	public	_HiMemoryAlloc
	public	_GetHiMemoryAvail
_BlockSize	equ	BlockSize
_Xflag	equ	Xflag
_TempSize	equ	TempSize
_HiMemoryUsed	equ	HiMemoryUsed
	public	_HiMemoryAvailable
	public	_memcpy
	public	_scroll_up
	extrn	_scroll_up2:near
	extrn	_scroll_up1:near
	public	_himem_read
	public	_himem_write
	public	_shut
	public	_putimage
	public	_getimage
	public	_Background
	public	_pButton
	public	_Button
	public	_Window
	public	_Window2
	public	_Window1
_BGWindow	equ	BGWindow
	public	_FarOutTextXY
	public	_XORRectangle
	public	_Rectangle
	public	_SetColor
	public	_Bar
	public	_Line
	public	_SwapInt
	public	_fastbar
	public	_fastbar1
	public	_putimage1
	public	_getimage1
	public	_fastbar2
	public	_putimage2
	public	_getimage2
	public	_imagesize
	public	_writenum
	public	_deltaw
	public	_abs
	public	_setFont
	public	_getOfs
	public	_PrintChar
	public	_fptr
	public	_SetVideo
	public	_scroll_down
	public	_scroll_down1
	public	_scroll_down2
	public	_SetRGB
	public	_getpix
	public	_setpix
	public	_COLOR
	public	_OutTextXY
	extrn	_waitretrace:near
	extrn	_barasm2:near
	extrn	_barasm1:near
	extrn	_getfontptr:near
	extrn	_getpix2:near
	extrn	_setpix2:near
	extrn	_getpix1:near
	extrn	_setpix1:near
	extrn	_init800600:near
	extrn	_init640480:near
	public	_exec
	public	_fsize
	public	_fread
	public	_fopen
_TempString	equ	TempString
	public	_font_mem
	public	_gmode
	public	_backc
	public	_isFont
	public	_bmouse
	public	_halt
	public	_About
	public	_CommandTerm
	public	_FullScreenShell
	public	_MessageBox
	public	_TickMenu
	public	_hidemouse
	public	_showmouse
	public	_strcmp
	public	_strcat
	public	_Xstrlen
	public	_strlen
	public	_strcpy
	public	_main
	public	_StartProgram
_s@	equ	s@
	end
