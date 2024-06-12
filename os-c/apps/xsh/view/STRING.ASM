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
	?debug	S "string.c"
	?debug	C E9E34B535708737472696E672E63
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
   ;	   register unsigned char i;
   ;	   for (i=0;s[i]!=0;i++) c[i]=s[i];
   ;	
	mov	cl,0
	jmp	short @1@114
@1@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@1@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @1@58
   ;	
   ;	   c[++i]=0;
   ;	
	mov	al,cl
	inc	al
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
   ;	  unsigned char strlen (string s)
   ;	
	assume	cs:MGRP
_strlen	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	  {
   ;	   register unsigned char i;
   ;	   for (i=0;s[i]!=0;i++);
   ;	
	mov	dl,0
	jmp	short @2@86
@2@58:
	inc	dl
@2@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @2@58
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
   ;	  int strcmp (string a, string b)
   ;	
	assume	cs:MGRP
_strcmp	proc	near
	enter	2,0
	push	si
	mov	cx,word ptr [bp+4]
	mov	si,word ptr [bp+6]
   ;	
   ;	  {
   ;	   register unsigned char i;
   ;	   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   ;	
	mov	byte ptr [bp-1],0
	jmp	short @4@86
@4@58:
	inc	byte ptr [bp-1]
@4@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @4@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @4@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @4@58
@4@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @4@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @4@254
	xor	ax,ax
	jmp	short @4@282
@4@254:
   ;	
   ;	   else return 1;
   ;	
	mov	ax,1
@4@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
	?debug	C E9
	?debug	C FA10010000
s@	label	byte
VPSEG	ends
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
_s@	equ	s@
	end
