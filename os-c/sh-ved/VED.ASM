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
	?debug	S "ved.c"
	?debug	C E91256BB58057665642E63
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
   ;	void ProgramEntry (void)
   ;	
	assume	cs:MGRP
_ProgramEntry	proc	near
   ;	
   ;	{
   ;	 ProgramStart ((char*)_ES,(char*)_BX);
   ;	
	push	bx
	push	es
	call	near ptr MGRP:_ProgramStart
	add	sp,4
   ;	
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_ProgramEntry	endp
_isecho	label	word
	db	1
	db	0
	?debug	C E9E34B5357122E5C494E434C5544455C7374646F75742E68
   ;	
   ;	void putc (char c)
   ;	
	assume	cs:MGRP
_putc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        push    ax
   ;	
	push	    ax
   ;	
   ;	        mov     al,c
   ;	
	mov	     al,[bp+4]
   ;	
   ;	        int     0x29
   ;	
	int	     029H
   ;	
   ;	        pop     ax
   ;	
	pop	     ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_putc	endp
   ;	
   ;	void puts (char* s)
   ;	
	assume	cs:MGRP
_puts	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	 if (isecho)
   ;	
	cmp	word ptr MGRP:_isecho,0
	je	short @3@366
   ;	
   ;	 asm {
   ;	        push    ax
   ;	
	push	    ax
   ;	
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
   ;	        mov     si,s
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        mov     ah,0010h
   ;	
	mov	     ah,0010h
   ;	
   ;	        int     44h
   ;	
	int	     44h
   ;	
   ;	        pop     ds
   ;	
	pop	     ds
   ;	
   ;	        pop     si
   ;	
	pop	     si
   ;	
   ;	        pop     ax
   ;	
	pop	     ax
@3@366:
   ;	
   ;	     }
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_puts	endp
	?debug	C E9E34B53570E2E5C494E434C5544455C6D6D2E68
   ;	
   ;	 addr malloc (unsigned int paragraph)
   ;	
	assume	cs:MGRP
_malloc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        mov ah,0x0012
   ;	
	mov	 ah,00012H
   ;	
   ;	        mov bx,paragraph
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        pop bx
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
   ;	 void free (addr adr)
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
   ;	 unsigned long avail (void)
   ;	
	assume	cs:MGRP
_avail	proc	near
   ;	
   ;	 {
   ;	  asm {
   ;	        mov ah,15h
   ;	
	mov	 ah,15h
   ;	
   ;	        int 44h
   ;	
	int	 44h
   ;	
   ;	        mov dx,0
   ;	
	mov	 dx,0
   ;	
   ;	      }
   ;	 }
   ;	
	ret	
_avail	endp
	?debug	C E9E34B5357102E5C494E434C5544455C66696C652E68
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
   ;	 handle fcreate (char* fname)
   ;	
	assume	cs:MGRP
_fcreate	proc	near
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
   ;	        mov     ah,0x0003
   ;	
	mov	     ah,00003H
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
_fcreate	endp
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
   ;	 int fwrite (handle h,long count,void* buffer,unsigned int segm)
   ;	
	assume	cs:MGRP
_fwrite	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	 {
   ;	  asm {
   ;		push    ds
   ;	
	push	    ds
   ;	
   ;		push    si
   ;	
	push	    si
   ;	
   ;		push    ecx
   ;	
	push	    ecx
   ;	
   ;		push    edx
   ;	
	push	    edx
   ;	
   ;		mov     ax,segm
   ;	
	mov	     ax,[bp+14]
   ;	
   ;		mov     ds,ax
   ;	
	mov	     ds,ax
   ;	
   ;		mov     si,buffer
   ;	
	mov	     si,[bp+12]
   ;	
   ;		mov     ecx,count
   ;	
	mov	     ecx,[bp+8]
   ;	
   ;		mov     edx,h
   ;	
	mov	     edx,[bp+4]
   ;	
   ;		mov     ah,0x0005
   ;	
	mov	     ah,00005H
   ;	
   ;		int     0x44
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
   ;	        pop     si
   ;	
	pop	     si
   ;	
   ;	        pop     ds
   ;	
	pop	     ds
   ;	
   ;	      }
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_fwrite	endp
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
   ;	 unsigned char fattr (handle h)
   ;	
	assume	cs:MGRP
_fattr	proc	near
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
   ;	        pop     ecx
   ;	
	pop	     ecx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_fattr	endp
   ;	
   ;	 int    setattr (handle h, char attr)
   ;	
	assume	cs:MGRP
_setattr	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	        push edx
   ;	
	push	 edx
   ;	
   ;	        push cx
   ;	
	push	 cx
   ;	
   ;	        mov ah,0x0017
   ;	
	mov	 ah,00017H
   ;	
   ;	        mov edx,h
   ;	
	mov	 edx,[bp+4]
   ;	
   ;	        mov cl,attr
   ;	
	mov	 cl,[bp+8]
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        pop cx
   ;	
	pop	 cx
   ;	
   ;	        pop edx
   ;	
	pop	 edx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_setattr	endp
   ;	
   ;	 char fremove (handle h)
   ;	
	assume	cs:MGRP
_fremove	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	        push    edx
   ;	
	push	    edx
   ;	
   ;	        mov     ah,0x000d
   ;	
	mov	     ah,0000dH
   ;	
   ;	        mov     edx,h
   ;	
	mov	     edx,[bp+4]
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        pop     edx
   ;	
	pop	     edx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_fremove	endp
   ;	
   ;	 char exec (char* prog,unsigned int segArg,unsigned int ofsArg,char check)
   ;	
	assume	cs:MGRP
_exec	proc	near
	enter	4,0
	push	si
   ;	
   ;	 {
   ;	  unsigned long tm;
   ;	  tm = avail ();
   ;	
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	mov	dword ptr [bp-4],eax
   ;	
   ;	  asm {
   ;	       push     ds
   ;	
	push	     ds
   ;	
   ;	       push     si
   ;	
	push	     si
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
   ;	 if  ( (check) && (avail() != tm) ) puts ("\n\rwarning: memory no released");
   ;	
	cmp	byte ptr [bp+10],0
	je	short @15@478
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	cmp	eax,dword ptr [bp-4]
	je	short @15@478
	push	offset MGRP:s@
	call	near ptr MGRP:_puts
	pop	cx
@15@478:
   ;	
   ;	 }
   ;	
	pop	si
	leave	
	ret	
_exec	endp
	?debug	C E9E34B5357132E5C494E434C5544455C747970656465662E68
	?debug	C E9E34B5357122E5C494E434C5544455C6D656D6F72792E68
   ;	
   ;	void memcpy (uint segc,uint ofsc,uint segs,uint ofss,uint count)
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
   ;	
   ;	void memset (uint segs,uint ofss,uint count,uchar b)
   ;	
	assume	cs:MGRP
_memset	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	{
   ;	asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,segs
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,ofss
   ;	
	mov	 di,[bp+6]
   ;	
   ;		mov cx,count
   ;	
	mov	 cx,[bp+8]
   ;	
   ;		mov al,b
   ;	
	mov	 al,[bp+10]
   ;	
   ;		rep stosb
   ;	
	rep stosb	
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	};
   ;	}
   ;	
	pop	di
	pop	bp
	ret	
_memset	endp
	?debug	C E9E34B5357122E5C494E434C5544455C737472696E672E68
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
	jmp	short @18@114
@18@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@18@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @18@58
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
	jmp	short @19@86
@19@58:
	inc	dl
@19@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @19@58
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
	jmp	short @21@86
@21@58:
	inc	byte ptr [bp-1]
@21@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @21@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @21@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @21@58
@21@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @21@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @21@254
	mov	al,0
	jmp	short @21@282
@21@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@21@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
	?debug	C E9E34B53570F2E5C494E434C5544455C6172672E68
   ;	
   ;	char* get_argz (char* line,int count)
   ;	
	assume	cs:MGRP
_get_argz	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	 unsigned char i ;
   ;	 unsigned char j ;
   ;	 int intern_count=0 ;
   ;	
	xor	di,di
   ;	
   ;	 for (i=0;i<=50;i++)
   ;	
	mov	dl,0
	jmp	short @22@282
@22@58:
   ;	
   ;	 {
   ;	  if (line[i]!=32) { for (j=i;(line[j]!=32)&&(line[j]!=0);j++);line[j]=0;
   ;	
	mov	al,dl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @22@254
	mov	cl,dl
	jmp	short @22@142
@22@114:
	inc	cl
@22@142:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @22@198
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @22@114
@22@198:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	byte ptr [bx+si],0
   ;	
   ;	
   ;	                     intern_count++;
   ;	
	inc	di
   ;	
   ;			     if (intern_count==count) break ;
   ;	
	cmp	di,word ptr [bp+6]
	je	short @22@310
   ;	
   ;			     i=j;}
   ;	
	mov	dl,cl
@22@254:
	inc	dl
@22@282:
	cmp	dl,50
	jbe	short @22@58
@22@310:
   ;	
   ;	 }
   ;	return (line+i);
   ;	
	mov	al,dl
	mov	ah,0
	push	ax
	mov	ax,si
	pop	dx
	add	ax,dx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_get_argz	endp
   ;	
   ;	char ReadChar (void)
   ;	
	assume	cs:MGRP
_ReadChar	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        mov ah,18h
   ;	
	mov	 ah,18h
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;		mov KeyCode,ah
   ;	
	mov	 MGRP:_KeyCode,ah
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_ReadChar	endp
   ;	
   ;	void ClearScreen (ulong back)
   ;	
	assume	cs:MGRP
_ClearScreen	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	{
   ;	 asm {
   ;		push eax
   ;	
	push	 eax
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		push dx
   ;	
	push	 dx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;	       ;mov ax,3
   ;	
	;	mov ax,3
   ;	
   ;	       ;int 0x10
   ;	
	;	int 010H
   ;	
   ;		mov ax,0xb800
   ;	
	mov	 ax,0b800H
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,0
   ;	
	mov	 di,0
   ;	
   ;		mov cx,1000
   ;	
	mov	 cx,1000
   ;	
   ;		mov eax,back
   ;	
	mov	 eax,[bp+4]
   ;	
   ;		rep stosd
   ;	
	rep stosd	
   ;	
   ;		mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;		mov cx,0x2000
   ;	
	mov	 cx,02000H
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;		mov ah,2
   ;	
	mov	 ah,2
   ;	
   ;		xor bh,bh
   ;	
	xor	 bh,bh
   ;	
   ;		xor dx,dx
   ;	
	xor	 dx,dx
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop dx
   ;	
	pop	 dx
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop eax
   ;	
	pop	 eax
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	bp
	ret	
_ClearScreen	endp
_startdisp	label	word
	db	0
	db	0
_dispbuffer	label	word
	db	0
	db	0
_textbuffer	label	word
	db	0
	db	0
_segbuffer	label	word
	db	0
	db	0
_line	label	word
	db	1
	db	0
   ;	
   ;	void InsertChar (char c, addr BufferOfs)
   ;	
	assume	cs:MGRP
_InsertChar	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
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
   ;		mov ax,0xb800
   ;	
	mov	 ax,0b800H
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,BufferOfs
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
	pop	bp
	ret	
_InsertChar	endp
   ;	
   ;	char PeekChar (addr BufferOfs)
   ;	
	assume	cs:MGRP
_PeekChar	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,0xb800
   ;	
	mov	 ax,0b800H
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,BufferOfs
   ;	
	mov	 di,[bp+4]
   ;	
   ;		mov al,es:[di]
   ;	
	mov	 al,es:[di]
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	bp
	ret	
_PeekChar	endp
   ;	
   ;	void TextPut (char c, addr TextOfs)
   ;	
	assume	cs:MGRP
_TextPut	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
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
   ;		mov ax,segbuffer
   ;	
	mov	 ax,MGRP:_segbuffer
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
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
	pop	bp
	ret	
_TextPut	endp
   ;	
   ;	char TextGet (addr TextOfs)
   ;	
	assume	cs:MGRP
_TextGet	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,segbuffer
   ;	
	mov	 ax,MGRP:_segbuffer
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,TextOfs
   ;	
	mov	 di,[bp+4]
   ;	
   ;		mov al,es:[di]
   ;	
	mov	 al,es:[di]
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	pop	di
	pop	bp
	ret	
_TextGet	endp
   ;	
   ;	void DispText (addr DispOfs, addr TextOfs)
   ;	
	assume	cs:MGRP
_DispText	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 addr i;
   ;	 char cget;
   ;	 for (i=DispOfs; i <= (8000-DispOfs); i += 2)
   ;	
	mov	si,word ptr [bp+4]
	jmp	short @29@254
@29@58:
   ;	
   ;	 {
   ;	  cget = TextGet (TextOfs);
   ;	
	push	di
	call	near ptr MGRP:_TextGet
	pop	cx
	mov	dl,al
   ;	
   ;	  if (cget==13) { do {InsertChar (0,i); i += 2;} while ( ((i+2)%160) );
   ;	
	cmp	dl,13
	jne	short @29@170
@29@86:
	push	si
	push	0
	call	near ptr MGRP:_InsertChar
	add	sp,4
	add	si,2
	mov	ax,si
	add	ax,2
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne	short @29@86
   ;	
   ;			  TextOfs++;}
   ;	
	inc	di
	jmp	short @29@198
@29@170:
   ;	
   ;	  else InsertChar (cget,i);
   ;	
	push	si
	push	dx
	call	near ptr MGRP:_InsertChar
	add	sp,4
@29@198:
   ;	
   ;	  TextOfs++;
   ;	
	inc	di
	add	si,2
@29@254:
	mov	ax,8000
	sub	ax,word ptr [bp+4]
	cmp	ax,si
	jae	short @29@58
   ;	
   ;	 }
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_DispText	endp
   ;	
   ;	void ClearText (addr SegText)
   ;	
	assume	cs:MGRP
_ClearText	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
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
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		mov ax,SegText
   ;	
	mov	 ax,[bp+4]
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,0
   ;	
	mov	 di,0
   ;	
   ;		mov cx,0xfff0
   ;	
	mov	 cx,0fff0H
   ;	
   ;		mov al,0
   ;	
	mov	 al,0
   ;	
   ;		rep stosb
   ;	
	rep stosb	
   ;	
   ;		pop cx
   ;	
	pop	 cx
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
	pop	bp
	ret	
_ClearText	endp
   ;	
   ;	void DelText (addr TextOfs)
   ;	
	assume	cs:MGRP
_DelText	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
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
	mov	 ax,MGRP:_segbuffer
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
   ;		mov cx,0xfff0
   ;	
	mov	 cx,0fff0H
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
   ;	void InsText (char c, addr TextOfs)
   ;	
	assume	cs:MGRP
_InsText	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
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
	mov	 ax,MGRP:_segbuffer
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;	        mov si,0xffef -1
   ;	
	mov	 si,0ffefH -1
   ;	
   ;	        mov di,0xfff0 -1
   ;	
	mov	 di,0fff0H -1
   ;	
   ;	        mov cx,0xffef -1
   ;	
	mov	 cx,0ffefH -1
   ;	
   ;		mov ax,TextOfs
   ;	
	mov	 ax,[bp+6]
   ;	
   ;		sub cx,ax
   ;	
	sub	 cx,ax
   ;	
   ;	        inc cx
   ;	
	inc	 cx
   ;	
   ;	        std
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
   ;	void BackgroundChar (addr BufferOfs, char color)
   ;	
	assume	cs:MGRP
_BackgroundChar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 InsertChar (color,BufferOfs+1);
   ;	
	mov	ax,word ptr [bp+4]
	inc	ax
	push	ax
	mov	al,byte ptr [bp+6]
	push	ax
	call	near ptr MGRP:_InsertChar
	add	sp,4
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_BackgroundChar	endp
   ;	
   ;	unsigned int LengthLine (addr l)
   ;	
	assume	cs:MGRP
_LengthLine	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;	{
   ;	 unsigned int temp,counter,length=0;
   ;	
	xor	si,si
   ;	
   ;	
   ;	 for (temp=0;counter != l; temp++)
   ;	
	xor	di,di
	jmp	short @34@170
@34@58:
   ;	
   ;	 {
   ;	  if (TextGet (temp) == 13) { length = 0; counter++; }
   ;	
	push	di
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,13
	jne	short @34@114
	xor	si,si
	inc	word ptr [bp-2]
	jmp	short @34@142
@34@114:
   ;	
   ;	  else length++;
   ;	
	inc	si
@34@142:
	inc	di
@34@170:
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr [bp+4]
	jne	short @34@58
   ;	
   ;	 }
   ;	
   ;	 return length;
   ;	
	mov	ax,si
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_LengthLine	endp
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
   ;	         push ax
   ;	
	push	 ax
   ;	
   ;	         push cx
   ;	
	push	 cx
   ;	
   ;	         mov ah,5
   ;	
	mov	 ah,5
   ;	
   ;	         mov ch,scode
   ;	
	mov	 ch,[bp+6]
   ;	
   ;	         mov cl,sc
   ;	
	mov	 cl,[bp+4]
   ;	
   ;	         int 0x16
   ;	
	int	 016H
   ;	
   ;	         pop cx
   ;	
	pop	 cx
   ;	
   ;	         pop ax
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
   ;	void Characters (char c,char keycode)
   ;	
	assume	cs:MGRP
_Characters	proc	near
	enter	2,0
	push	si
	push	di
   ;	
   ;	{
   ;	 addr x,i;
   ;	
   ;	 switch (keycode)
   ;	
	mov	al,byte ptr [bp+6]
	cbw	
	mov	word ptr [bp-2],ax
	mov	cx,7
	mov	bx,offset @36@C50
@36@86:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-2]
	je	short @36@170
	add	bx,2
	loop	short @36@86
	jmp	@36@2326
@36@170:
	jmp	word ptr cs:[bx+14]
@36@198:
   ;	
   ;	 {
   ;	
   ;	  case 72:      if ( (!startdisp) && (dispbuffer < 160)) break;
   ;	
	cmp	word ptr MGRP:_startdisp,0
	jne	short @36@254
	cmp	word ptr MGRP:_dispbuffer,160
	jae short	@@0
	jmp	@36@2802
@@0:
@36@254:
   ;	
   ;			if ( (dispbuffer < 160) && (startdisp) )
   ;	
	cmp	word ptr MGRP:_dispbuffer,160
	jb short	@@1
	jmp	@36@674
@@1:
	cmp	word ptr MGRP:_startdisp,0
	jne short	@@2
	jmp	@36@674
@@2:
   ;	
   ;			{
   ;			 i=0;
   ;	
	xor	di,di
   ;	
   ;			 for (x=0;TextGet (textbuffer-x) !=10; x++) i++;
   ;	
	xor	si,si
	jmp	short @36@394
@36@338:
	inc	di
	inc	si
@36@394:
	mov	ax,word ptr MGRP:_textbuffer
	sub	ax,si
	push	ax
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,10
	jne	short @36@338
   ;	
   ;			 x++;
   ;	
	jmp	short @36@450
@36@450:
   ;	
   ;	
   ;	
   ;			 for ( ; (TextGet (textbuffer-x) != 10) && (textbuffer-x+1); x++) ;
   ;	
	inc	si
	mov	ax,word ptr MGRP:_textbuffer
	sub	ax,si
	push	ax
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,10
	je	short @36@534
	mov	ax,word ptr MGRP:_textbuffer
	sub	ax,si
	inc	ax
	or	ax,ax
	jne	short @36@450
@36@534:
   ;	
   ;	
   ;			 DispText (0,startdisp-x+i);
   ;	
	mov	ax,word ptr MGRP:_startdisp
	sub	ax,si
	add	ax,di
	push	ax
	push	0
	call	near ptr MGRP:_DispText
	add	sp,4
   ;	
   ;			 if ( (PeekChar (dispbuffer) == 0) && (dispbuffer%160))
   ;	
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@646
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	je	short @36@646
   ;	
   ;			  {
   ;			   DispText (0,startdisp);
   ;	
	push	word ptr MGRP:_startdisp
	push	0
@36@618:
	call	near ptr MGRP:_DispText
	jmp	@36@2774
@36@646:
   ;	
   ;			   break;
   ;			  }
   ;			 dispbuffer+=160;
   ;	
	add	word ptr MGRP:_dispbuffer,160
   ;	
   ;			 startdisp = startdisp - x+i;
   ;	
	mov	ax,word ptr MGRP:_startdisp
	sub	ax,si
	add	ax,di
	mov	word ptr MGRP:_startdisp,ax
@36@674:
   ;	
   ;			}
   ;			x=0;
   ;	
	xor	si,si
   ;	
   ;			if ( !(dispbuffer%160) );
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	je	short @36@730
   ;	
   ;			else if (PeekChar (dispbuffer - 160) == 0) break;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	sub	ax,160
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne short	@@3
	jmp	@36@2802
@@3:
@36@730:
   ;	
   ;			for ( i=0; i <= 160 ; i+=2)
   ;	
	xor	di,di
	jmp	short @36@842
@36@758:
   ;	
   ;			 if (PeekChar (dispbuffer-i) != 0) x++;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	sub	ax,di
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	je	short @36@814
	inc	si
@36@814:
	add	di,2
@36@842:
	cmp	di,160
	jbe	short @36@758
   ;	
   ;	                BackgroundChar (dispbuffer,FORE_COLOR);
   ;	
	push	2
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;			if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer-160)==0) ) ;//textbuffer -= 2;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne	short @36@926
	mov	ax,word ptr MGRP:_dispbuffer
	sub	ax,160
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
@36@926:
   ;	
   ;			if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer)==0) ) textbuffer--;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne	short @36@1010
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@1010
	dec	word ptr MGRP:_textbuffer
@36@1010:
   ;	
   ;			if ( TextGet (textbuffer)== 13)  x++;
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,13
	jne	short @36@1066
	inc	si
@36@1066:
   ;	
   ;			textbuffer -= x+1;
   ;	
	mov	ax,si
	inc	ax
	sub	word ptr MGRP:_textbuffer,ax
   ;	
   ;			dispbuffer -= 160;
   ;	
	sub	word ptr MGRP:_dispbuffer,160
	jmp	@36@2746
@36@1094:
   ;	
   ;	                BackgroundChar (dispbuffer,BACK_COLOR);
   ;			break;
   ;	
   ;	  case 80:      i=0;
   ;	
	xor	di,di
   ;	
   ;			for (x=0; x <= 158; x += 2) if (PeekChar (dispbuffer+x) == 26) { i=1;break;}
   ;	
	xor	si,si
	jmp	short @36@1206
@36@1122:
	mov	ax,word ptr MGRP:_dispbuffer
	add	ax,si
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	cmp	al,26
	jne	short @36@1178
	mov	di,1
	jmp	short @36@1234
@36@1178:
	add	si,2
@36@1206:
	cmp	si,158
	jbe	short @36@1122
@36@1234:
   ;	
   ;			if (i) break;
   ;	
	or	di,di
	je short	@@4
	jmp	@36@2802
@@4:
   ;	
   ;			if (!(dispbuffer%160) );
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	je	short @36@1318
   ;	
   ;			else if (PeekChar (dispbuffer + 160) == 0) break;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	add	ax,160
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne short	@@5
	jmp	@36@2802
@@5:
@36@1318:
   ;	
   ;			if (dispbuffer >= (160*24))
   ;	
	cmp	word ptr MGRP:_dispbuffer,3840
	jb	short @36@1458
   ;	
   ;			{
   ;	
   ;			 for (x=0;PeekChar (x) !=0; x+=2);
   ;	
	xor	si,si
	jmp	short @36@1402
@36@1374:
	add	si,2
@36@1402:
	push	si
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@1374
   ;	
   ;			 //x++;
   ;			 x = x>>1;
   ;	
	shr	si,1
   ;	
   ;			 x = x +2;
   ;	
	add	si,2
   ;	
   ;	
   ;			 DispText (0,startdisp+x);
   ;	
	mov	ax,word ptr MGRP:_startdisp
	add	ax,si
	push	ax
	push	0
	call	near ptr MGRP:_DispText
	add	sp,4
   ;	
   ;			 dispbuffer-=160;
   ;	
	sub	word ptr MGRP:_dispbuffer,160
   ;	
   ;			 startdisp = startdisp + x;
   ;	
	mov	ax,word ptr MGRP:_startdisp
	add	ax,si
	mov	word ptr MGRP:_startdisp,ax
@36@1458:
   ;	
   ;			}
   ;			x=0;
   ;	
	xor	si,si
   ;	
   ;			for ( i=0; i <= 160 ; i+=2)
   ;	
	xor	di,di
	jmp	short @36@1570
@36@1486:
   ;	
   ;			 {
   ;			 if (PeekChar (dispbuffer+i) != 0) x++;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	add	ax,di
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	je	short @36@1542
	inc	si
@36@1542:
	add	di,2
@36@1570:
	cmp	di,160
	jbe	short @36@1486
   ;	
   ;	
   ;			 }
   ;	                BackgroundChar (dispbuffer,FORE_COLOR);
   ;	
	push	2
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;			if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer+160)==0)
   ;	
   ;	
   ;			      && (PeekChar(dispbuffer)!=0)) textbuffer++;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne	short @36@1710
	mov	ax,word ptr MGRP:_dispbuffer
	add	ax,160
	push	ax
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@1710
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	je	short @36@1710
	inc	word ptr MGRP:_textbuffer
@36@1710:
   ;	
   ;			if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer)==0) ) textbuffer+=2;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne	short @36@1794
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@1794
	add	word ptr MGRP:_textbuffer,2
	jmp	short @36@1822
@36@1794:
   ;	
   ;			else textbuffer += x+1; // modifs
   ;	
	mov	ax,si
	inc	ax
	add	word ptr MGRP:_textbuffer,ax
@36@1822:
   ;	
   ;			dispbuffer += 160;
   ;	
	add	word ptr MGRP:_dispbuffer,160
	jmp	@36@2746
@36@1850:
   ;	
   ;	                BackgroundChar (dispbuffer,BACK_COLOR);
   ;			break;
   ;	
   ;	
   ;	  case 75:      if (!dispbuffer) break;
   ;	
	cmp	word ptr MGRP:_dispbuffer,0
	jne short	@@6
	jmp	@36@2802
@@6:
   ;	
   ;			if (!(dispbuffer%160)) break;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	or	dx,dx
	jne short	@@7
	jmp	@36@2802
@@7:
   ;	
   ;	                BackgroundChar (dispbuffer,FORE_COLOR);
   ;	
	push	2
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;			textbuffer--;
   ;	
	dec	word ptr MGRP:_textbuffer
   ;	
   ;			dispbuffer -= 2;
   ;	
	sub	word ptr MGRP:_dispbuffer,2
	jmp	@36@2746
@36@1934:
   ;	
   ;	                BackgroundChar (dispbuffer,BACK_COLOR);
   ;			break;
   ;	
   ;	  case 77:      if (TextGet (textbuffer) == 26) break;
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,26
	jne short	@@8
	jmp	@36@2802
@@8:
   ;	
   ;			if (TextGet (textbuffer) == 13) break;
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,13
	jne short	@@9
	jmp	@36@2802
@@9:
   ;	
   ;			if ( (dispbuffer%160)==79) break;
   ;	
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	cmp	dx,79
	jne short	@@10
	jmp	@36@2802
@@10:
   ;	
   ;	                BackgroundChar (dispbuffer,FORE_COLOR);
   ;	
	push	2
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;			textbuffer++;
   ;	
	inc	word ptr MGRP:_textbuffer
	jmp	@36@2718
@36@2046:
   ;	
   ;			dispbuffer += 2;
   ;	                BackgroundChar (dispbuffer,BACK_COLOR);
   ;			break;
   ;	
   ;	  case 15:      for (x=0;x<=7;x++) send_char (32,57);
   ;	
	xor	si,si
	jmp	short @36@2130
@36@2074:
	push	57
	push	32
	call	near ptr MGRP:_send_char
	add	sp,4
	inc	si
@36@2130:
	cmp	si,7
	jbe	short @36@2074
   ;	
   ;			break;
   ;	
	jmp	@36@2802
@36@2186:
   ;	
   ;	        
   ;	  case 14:      send_char (0,75); send_char (8,83);
   ;	
	push	75
	push	0
	call	near ptr MGRP:_send_char
	add	sp,4
	push	83
	push	8
	call	near ptr MGRP:_send_char
	jmp	@36@2774
@36@2214:
   ;	
   ;	                break;
   ;	
   ;	  case 83:      if (TextGet (textbuffer) == 26) break;
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,26
	jne short	@@11
	jmp	@36@2802
@@11:
   ;	
   ;			if (TextGet (textbuffer) == 13) DelText (textbuffer);
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,13
	jne	short @36@2298
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_DelText
	pop	cx
@36@2298:
   ;	
   ;			DelText (textbuffer);
   ;	
	push	word ptr MGRP:_textbuffer
	call	near ptr MGRP:_DelText
	pop	cx
   ;	
   ;			DispText (dispbuffer,textbuffer);
   ;	
	push	word ptr MGRP:_textbuffer
	push	word ptr MGRP:_dispbuffer
	jmp	@36@618
@36@2326:
   ;	
   ;	
   ;			break;
   ;	
   ;	  default:      InsText (c,textbuffer);
   ;	
	push	word ptr MGRP:_textbuffer
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_InsText
	add	sp,4
   ;	
   ;			if (keycode==28) InsText (10,textbuffer+1);
   ;	
	cmp	byte ptr [bp+6],28
	jne	short @36@2382
	mov	ax,word ptr MGRP:_textbuffer
	inc	ax
	push	ax
	push	10
	call	near ptr MGRP:_InsText
	add	sp,4
@36@2382:
   ;	
   ;			if ( (keycode==28) && (dispbuffer >= (160*24)) )
   ;	
	cmp	byte ptr [bp+6],28
	jne	short @36@2550
	cmp	word ptr MGRP:_dispbuffer,3840
	jb	short @36@2550
   ;	
   ;			{
   ;	
   ;			 for (x=0;PeekChar (x) !=0; x+=2);
   ;	
	xor	si,si
	jmp	short @36@2494
@36@2466:
	add	si,2
@36@2494:
	push	si
	call	near ptr MGRP:_PeekChar
	pop	cx
	or	al,al
	jne	short @36@2466
   ;	
   ;			 //x++;
   ;			 x = x>>1;
   ;	
	shr	si,1
   ;	
   ;			 x = x +2;
   ;	
	add	si,2
   ;	
   ;	
   ;			 DispText (0,startdisp+x);
   ;	
	mov	ax,word ptr MGRP:_startdisp
	add	ax,si
	push	ax
	push	0
	call	near ptr MGRP:_DispText
	add	sp,4
   ;	
   ;			 //dispbuffer = 160*24;
   ;			 startdisp = startdisp + x;
   ;	
	mov	ax,word ptr MGRP:_startdisp
	add	ax,si
	mov	word ptr MGRP:_startdisp,ax
   ;	
   ;	
   ;			}
   ;	
	jmp	short @36@2578
@36@2550:
   ;	
   ;			else
   ;			DispText (dispbuffer,textbuffer);
   ;	
	push	word ptr MGRP:_textbuffer
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_DispText
	add	sp,4
@36@2578:
   ;	
   ;	                BackgroundChar (dispbuffer,FORE_COLOR);
   ;	
	push	2
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;			textbuffer++;
   ;	
	inc	word ptr MGRP:_textbuffer
   ;	
   ;			if (keycode==28) textbuffer++;
   ;	
	cmp	byte ptr [bp+6],28
	jne	short @36@2634
	inc	word ptr MGRP:_textbuffer
@36@2634:
   ;	
   ;	
   ;			if ( (keycode==28) && !(dispbuffer >= (160*24)) )dispbuffer = dispbuffer + (160-(dispbuffer%160));
   ;	
	cmp	byte ptr [bp+6],28
	jne	short @36@2718
	cmp	word ptr MGRP:_dispbuffer,3840
	jae	short @36@2718
	mov	ax,word ptr MGRP:_dispbuffer
	mov	bx,160
	xor	dx,dx
	div	bx
	mov	ax,160
	sub	ax,dx
	mov	dx,word ptr MGRP:_dispbuffer
	add	dx,ax
	mov	word ptr MGRP:_dispbuffer,dx
	jmp	short @36@2746
@36@2718:
   ;	
   ;			else dispbuffer += 2;
   ;	
	add	word ptr MGRP:_dispbuffer,2
@36@2746:
   ;	
   ;	                BackgroundChar (dispbuffer,BACK_COLOR);
   ;	
	push	66
	push	word ptr MGRP:_dispbuffer
	call	near ptr MGRP:_BackgroundChar
@36@2774:
	add	sp,4
   ;	
   ;			break;
   ;	
@36@2802:
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_Characters	endp
@36@C50	label	word
	db	14
	db	0
	db	15
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
	dw	@36@2186
	dw	@36@2046
	dw	@36@198
	dw	@36@1850
	dw	@36@1934
	dw	@36@1094
	dw	@36@2214
ved	label	byte
	db	86
	db	105
	db	115
	db	117
	db	97
	db	108
	db	32
	db	69
	db	100
	db	105
	db	116
	db	111
	db	114
	db	32
	db	48
	db	46
	db	49
	db	0
MemoryError	label	byte
	db	69
	db	110
	db	111
	db	117
	db	103
	db	104
	db	32
	db	109
	db	101
	db	109
	db	111
	db	114
	db	121
	db	46
	db	0
_opened	label	word
	db	0
	db	0
   ;	
   ;	ulong textsize (void)
   ;	
	assume	cs:MGRP
_textsize	proc	near
	enter	4,0
   ;	
   ;	{
   ;	 ulong i;
   ;	 for (i=0;(TextGet (i) != 26);i++);
   ;	
	mov	dword ptr [bp-4],large 0
	jmp	short @37@86
@37@58:
	inc	dword ptr [bp-4]
@37@86:
	push	word ptr [bp-4]
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,26
	jne	short @37@58
   ;	
   ;	 return i;
   ;	
	mov	eax,dword ptr [bp-4]
	shld	edx,eax,16
   ;	
   ;	}
   ;	
	leave	
	ret	
_textsize	endp
   ;	
   ;	void initprint (void)
   ;	
	assume	cs:MGRP
_initprint	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push dx
   ;	
	push	 dx
   ;	
   ;		mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;		mov dx,0
   ;	
	mov	 dx,0
   ;	
   ;		int 0x17
   ;	
	int	 017H
   ;	
   ;		pop dx
   ;	
	pop	 dx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_initprint	endp
   ;	
   ;	void printchar (char c)
   ;	
	assume	cs:MGRP
_printchar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push dx
   ;	
	push	 dx
   ;	
   ;		mov ah,0
   ;	
	mov	 ah,0
   ;	
   ;		mov al,c
   ;	
	mov	 al,[bp+4]
   ;	
   ;		mov dx,0
   ;	
	mov	 dx,0
   ;	
   ;		int 0x17
   ;	
	int	 017H
   ;	
   ;		pop dx
   ;	
	pop	 dx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_printchar	endp
   ;	
   ;	void printit (void)
   ;	
	assume	cs:MGRP
_printit	proc	near
	push	si
   ;	
   ;	{
   ;	 addr i;
   ;	 for (i=0; (TextGet (i) != 26); i++) printchar (TextGet(i));
   ;	
	xor	si,si
	jmp	short @40@114
@40@58:
	push	si
	call	near ptr MGRP:_TextGet
	pop	cx
	push	ax
	call	near ptr MGRP:_printchar
	pop	cx
	inc	si
@40@114:
	push	si
	call	near ptr MGRP:_TextGet
	pop	cx
	cmp	al,26
	jne	short @40@58
   ;	
   ;	}
   ;	
	pop	si
	ret	
_printit	endp
   ;	
   ;	char is_xsh (void)
   ;	
	assume	cs:MGRP
_is_xsh	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        mov ah,4
   ;	
	mov	 ah,4
   ;	
   ;	        int 0x46
   ;	
	int	 046H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_is_xsh	endp
   ;	
   ;	void ProgramStart (char* s, char* o)
   ;	
	assume	cs:MGRP
_ProgramStart	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 if (is_xsh()) { puts ("\r\nwarning: can't run under xsh"); 
   ;	
	call	near ptr MGRP:_is_xsh
	or	al,al
	je	short @42@86
	push	offset MGRP:s@+30
	call	near ptr MGRP:_puts
	jmp	@42@814
@42@86:
   ;	
   ;	                 return ;
   ;	               }
   ;	 memcpy ((uint)_CS,(uint)argv,(uint)s,(uint)o,50);
   ;	
	push	50
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	push	offset MGRP:_argv
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	
   ;	  ClearScreen (ALL_COLOR);
   ;	
	push	large 002000200h
	call	near ptr MGRP:_ClearScreen
	add	sp,4
   ;	
   ;	
   ;	 segbuffer=malloc (aSegment);
   ;	
	push	4095
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_segbuffer,ax
   ;	
   ;	 if (!segbuffer) puts (MemoryError);
   ;	
	cmp	word ptr MGRP:_segbuffer,0
	jne	short @42@142
	push	offset MGRP:MemoryError
	call	near ptr MGRP:_puts
	pop	cx
@42@142:
   ;	
   ;	 ClearText (segbuffer);
   ;	
	push	word ptr MGRP:_segbuffer
	call	near ptr MGRP:_ClearText
	pop	cx
   ;	
   ;	 BackgroundChar (0,BACK_COLOR);
   ;	
	push	66
	push	0
	call	near ptr MGRP:_BackgroundChar
	add	sp,4
   ;	
   ;	
   ;	
   ;	 if ( strcmp ((string)get_argz(argv,2),""))
   ;	
	push	offset MGRP:s@+61
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	or	al,al
	jne short	@@12
	jmp	@42@254
@@12:
   ;	
   ;	 {
   ;	  file1 = fopen ((string)get_argz(argv,2));
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file1,eax
   ;	
   ;	  if (file1 < 2) {TextPut (26,0);InsertChar (26,0);}
   ;	
	cmp	dword ptr MGRP:_file1,large 2
	jae	short @42@226
	push	0
	push	26
	call	near ptr MGRP:_TextPut
	add	sp,4
	push	0
	push	26
	call	near ptr MGRP:_InsertChar
	jmp	short @42@282
@42@226:
   ;	
   ;	  else
   ;	  {
   ;	   fread (file1,fsize (file1), 0,segbuffer);
   ;	
	push	word ptr MGRP:_segbuffer
	push	0
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	   TextPut (26,fsize (file1));
   ;	
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fsize
	add	sp,4
	push	ax
	push	26
	call	near ptr MGRP:_TextPut
	add	sp,4
   ;	
   ;	   DispText (0,0);
   ;	
	push	large 0
	call	near ptr MGRP:_DispText
	add	sp,4
	jmp	@42@450
@42@254:
   ;	
   ;	   opened =1;
   ;	  }
   ;	
   ;	 }
   ;	 else { InsertChar (26,0);TextPut (26,0);}
   ;	
	push	0
	push	26
	call	near ptr MGRP:_InsertChar
	add	sp,4
	push	0
	push	26
	call	near ptr MGRP:_TextPut
@42@282:
	add	sp,4
@42@310:
   ;	
   ;	
   ;	 while (1)
   ;	 {
   ;	  C = ReadChar ();
   ;	
	call	near ptr MGRP:_ReadChar
	mov	byte ptr MGRP:_C,al
   ;	
   ;	  if (KeyCode==1) break;
   ;	
	cmp	byte ptr MGRP:_KeyCode,1
	jne short	@@13
	jmp	@42@562
@@13:
   ;	
   ;	  if (C==0x13) {
   ;	
	cmp	byte ptr MGRP:_C,19
	je short	@@14
	jmp	@42@478
@@14:
   ;	
   ;			    if (opened) { fremove (file1) ;
   ;	
	cmp	word ptr MGRP:_opened,0
	je	short @42@422
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fremove
	add	sp,4
   ;	
   ;					  file1 = fcreate ((string)get_argz(argv,2));
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_fcreate
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file1,eax
   ;	
   ;					  fwrite (file1,textsize(),0,segbuffer);
   ;	
	push	word ptr MGRP:_segbuffer
	push	0
	call	near ptr MGRP:_textsize
	push	dx
	push	ax
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fwrite
	add	sp,12
   ;	
   ;					}
   ;	
	jmp	short @42@310
@42@422:
   ;	
   ;			    else {
   ;				  file1 = fcreate ((string)get_argz(argv,2));
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_fcreate
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file1,eax
   ;	
   ;				  fwrite (file1,textsize(),0,segbuffer);
   ;	
	push	word ptr MGRP:_segbuffer
	push	0
	call	near ptr MGRP:_textsize
	push	dx
	push	ax
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fwrite
	add	sp,12
@42@450:
   ;	
   ;				  opened = 1;
   ;	
	mov	word ptr MGRP:_opened,1
	jmp	@42@310
@42@478:
   ;	
   ;				 }
   ;			    continue;
   ;			   }
   ;	
   ;	  if (KeyCode==62) { initprint (); printit (); }
   ;	
	cmp	byte ptr MGRP:_KeyCode,62
	jne	short @42@534
	call	near ptr MGRP:_initprint
	call	near ptr MGRP:_printit
	jmp	@42@310
@42@534:
   ;	
   ;	  else Characters (C,KeyCode);
   ;	
	mov	al,byte ptr MGRP:_KeyCode
	push	ax
	mov	al,byte ptr MGRP:_C
	push	ax
	call	near ptr MGRP:_Characters
	jmp	@42@282
@42@562:
   ;	
   ;	 }
   ;	 ClearScreen (0x07000700);
   ;	
	push	large 007000700h
	call	near ptr MGRP:_ClearScreen
	add	sp,4
   ;	
   ;	 asm {
   ;	      push ax
   ;	
	push	 ax
   ;	
   ;	      push cx
   ;	
	push	 cx
   ;	
   ;	      mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;	      mov cx,0x0C0D
   ;	
	mov	 cx,00C0DH
   ;	
   ;	      int 0x10
   ;	
	int	 010H
   ;	
   ;	      pop cx
   ;	
	pop	 cx
   ;	
   ;	      pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	 free (segbuffer);
   ;	
	push	word ptr MGRP:_segbuffer
	call	near ptr MGRP:_free
@42@814:
	pop	cx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_ProgramStart	endp
_argv	label	byte
	db	50 dup (0)
_file2	label	word
	db	4 dup (0)
_file1	label	word
	db	4 dup (0)
_C	label	byte
	db	1 dup (0)
_KeyCode	label	byte
	db	1 dup (0)
	?debug	C E9
	?debug	C FA10000000
s@	label	byte
	db	10
	db	13
	db	'warning: memory no released'
	db	0
	db	13
	db	10
	db	'warning: can'
	db	39
	db	't run under xsh'
	db	0
	db	0
VPSEG	ends
	public	_argv
	public	_is_xsh
	public	_printit
	public	_printchar
	public	_initprint
	public	_textsize
	public	_file2
	public	_file1
	public	_opened
	public	_C
_MemoryError	equ	MemoryError
_ved	equ	ved
	public	_Characters
	public	_send_char
	public	_LengthLine
	public	_BackgroundChar
	public	_InsText
	public	_DelText
	public	_ClearText
	public	_DispText
	public	_TextGet
	public	_TextPut
	public	_PeekChar
	public	_InsertChar
	public	_line
	public	_segbuffer
	public	_textbuffer
	public	_dispbuffer
	public	_startdisp
	public	_ClearScreen
	public	_ReadChar
	public	_KeyCode
	public	_get_argz
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
	public	_memset
	public	_memcpy
	public	_exec
	public	_fremove
	public	_setattr
	public	_fattr
	public	_fsize
	public	_fwrite
	public	_fread
	public	_fcreate
	public	_fopen
	public	_avail
	public	_free
	public	_malloc
	public	_puts
	public	_putc
	public	_isecho
	public	_ProgramEntry
	public	_ProgramStart
_s@	equ	s@
	end
