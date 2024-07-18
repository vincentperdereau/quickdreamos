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
	?debug	S "sh.c"
	?debug	C E9F27DEF580473682E63
	?debug	C E9E34B5357132E5C494E434C5544455C737461727475702E68
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
   ;	startup    (void)
   ;	
	assume	cs:MGRP
_startup	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        mov     ax,cs
   ;	
	mov	     ax,cs
   ;	
   ;	        mov     ds,ax
   ;	
	mov	     ds,ax
   ;	
   ;	        mov     es,ax
   ;	
	mov	     es,ax
   ;	
   ;	     }
   ;	        main ();
   ;	
	call	near ptr MGRP:_main
   ;	
   ;	 asm { retf }
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_startup	endp
_isecho	label	word
	db	1
	db	0
   ;	
   ;	 char is_xsh (void)
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
	je	short @4@366
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
@4@366:
   ;	
   ;	     }
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_puts	endp
	?debug	C E9E34B5357112E5C494E434C5544455C737464696E2E68
   ;	
   ;	char getch (void)
   ;	
	assume	cs:MGRP
_getch	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        xor ax,ax
   ;	
	xor	 ax,ax
   ;	
   ;	        int 0x16
   ;	
	int	 016H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_getch	endp
   ;	
   ;	void gets (char* s,unsigned int c)
   ;	
	assume	cs:MGRP
_gets	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        push ax
   ;	
	push	 ax
   ;	
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        push cx
   ;	
	push	 cx
   ;	
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov bx,s
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        mov cx,c
   ;	
	mov	 cx,[bp+6]
   ;	
   ;	        mov ah,0x0011
   ;	
	mov	 ah,00011H
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	        pop cx
   ;	
	pop	 cx
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_gets	endp
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
	?debug	C E9F278E458102E5C494E434C5544455C66696C652E68
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
   ;	
   ;	   asm {
   ;	       mov      ax,0x0600
   ;	
	mov	      ax,00600H
   ;	
   ;	       int      0x46
   ;	
	int	      046H
   ;	
   ;	      }
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
   ;	      
   ;	 if  ( (!is_xsh()) && (check) && (avail() != tm) ) puts ("\n\rwarning: memory no released");
   ;	
	call	near ptr MGRP:_is_xsh
	cbw	
	or	ax,ax
	jne	short @18@562
	cmp	byte ptr [bp+10],0
	je	short @18@562
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	cmp	eax,dword ptr [bp-4]
	je	short @18@562
	push	offset MGRP:s@
	call	near ptr MGRP:_puts
	pop	cx
@18@562:
   ;	
   ;	 
   ;	 }
   ;	
	pop	si
	leave	
	ret	
_exec	endp
	?debug	C E9E34B53570F2E5C494E434C5544455C6469722E68
   ;	
   ;	 char mkdir (char* dir)
   ;	
	assume	cs:MGRP
_mkdir	proc	near
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
   ;	        mov     si,dir
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        mov     ah,8
   ;	
	mov	     ah,8
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        mov     ah,0
   ;	
	mov	     ah,0
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
_mkdir	endp
   ;	
   ;	 char rmdir (char* dir)
   ;	
	assume	cs:MGRP
_rmdir	proc	near
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
   ;	        mov     si,dir
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        mov     ah,0xe
   ;	
	mov	     ah,0eH
   ;	
   ;	        int     0x44
   ;	
	int	     044H
   ;	
   ;	        mov     ah,0
   ;	
	mov	     ah,0
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
_rmdir	endp
   ;	
   ;	 unsigned long chdir (char* dir)
   ;	
	assume	cs:MGRP
_chdir	proc	near
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
   ;	        mov     si,dir
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        mov     ah,07h
   ;	
	mov	     ah,07h
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
   ;	       }
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_chdir	endp
   ;	
   ;	 unsigned long acdir (void)
   ;	
	assume	cs:MGRP
_acdir	proc	near
   ;	
   ;	 {
   ;	  asm {
   ;	        mov ah,0xf
   ;	
	mov	 ah,0fH
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        mov edx,eax
   ;	
	mov	 edx,eax
   ;	
   ;	        shr edx,16
   ;	
	shr	 edx,16
   ;	
   ;	      }
   ;	 }
   ;	
	ret	
_acdir	endp
	?debug	C E9E34B5357132E5C494E434C5544455C747970656465662E68
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
	jmp	short @23@114
@23@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@23@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @23@58
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
	jmp	short @24@86
@24@58:
	inc	dl
@24@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @24@58
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
	jmp	short @26@86
@26@58:
	inc	byte ptr [bp-1]
@26@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @26@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @26@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @26@58
@26@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @26@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @26@254
	mov	al,0
	jmp	short @26@282
@26@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@26@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
	?debug	C E9E34B5357102E5C494E434C5544455C6469736B2E68
   ;	
   ;	void get_disk_state (struct disk_state* diskstate)
   ;	
	assume	cs:MGRP
_get_disk_state	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
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
   ;	        mov     si,diskstate
   ;	
	mov	     si,[bp+4]
   ;	
   ;	        mov     ah,0xa
   ;	
	mov	     ah,0aH
   ;	
   ;	        int      0x44
   ;	
	int	      044H
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
   ;	
   ;	     }
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_get_disk_state	endp
   ;	
   ;	unsigned char change_disk (unsigned char dr)
   ;	
	assume	cs:MGRP
_change_disk	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        push ax
   ;	
	push	 ax
   ;	
   ;	        mov ah,6
   ;	
	mov	 ah,6
   ;	
   ;	        mov al,dr
   ;	
	mov	 al,[bp+4]
   ;	
   ;	        int 44h
   ;	
	int	 44h
   ;	
   ;	        pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_change_disk	endp
	?debug	C E9E34B53570E2E5C494E434C5544455C6C732E68
_lastf	label	word
	db	0
	db	0
	db	0
	db	0
_cluster_buffer	label	word
	db	0
	db	11 dup (0)
	db	20 dup (0)
	db	480 dup (0)
   ;	
   ;	 ulong get_fcb_count (void)
   ;	
	assume	cs:MGRP
_get_fcb_count	proc	near
   ;	
   ;	 {
   ;	  asm {
   ;	        mov ah,0x000b
   ;	
	mov	 ah,0000bH
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        mov edx,eax
   ;	
	mov	 edx,eax
   ;	
   ;	        shr edx,16
   ;	
	shr	 edx,16
   ;	
   ;	      }
   ;	 }
   ;	
	ret	
_get_fcb_count	endp
   ;	
   ;	 int fcb_dir (unsigned long cluster,void* buffer)
   ;	
	assume	cs:MGRP
_fcb_dir	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        push di
   ;	
	push	 di
   ;	
   ;	        push edx
   ;	
	push	 edx
   ;	
   ;	        mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov di,buffer
   ;	
	mov	 di,[bp+8]
   ;	
   ;	        mov edx,cluster
   ;	
	mov	 edx,[bp+4]
   ;	
   ;	        mov ah,0x9
   ;	
	mov	 ah,09H
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        mov ah,0
   ;	
	mov	 ah,0
   ;	
   ;	        pop edx
   ;	
	pop	 edx
   ;	
   ;	        pop di
   ;	
	pop	 di
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	      }
   ;	 }
   ;	
	pop	di
	pop	bp
	ret	
_fcb_dir	endp
	?debug	C E9E34B5357112E5C494E434C5544455C6469736B322E68
   ;	
   ;	  bool reset_disk (uchar d)
   ;	
	assume	cs:MGRP
_reset_disk	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	  {
   ;	   asm {
   ;	        push dx
   ;	
	push	 dx
   ;	
   ;	        mov ah,0
   ;	
	mov	 ah,0
   ;	
   ;	        mov dl,d
   ;	
	mov	 dl,[bp+4]
   ;	
   ;	        int 0x13
   ;	
	int	 013H
   ;	
   ;	        mov al,ah
   ;	
	mov	 al,ah
   ;	
   ;	        pop dx
   ;	
	pop	 dx
   ;	
   ;	       }
   ;	  }
   ;	
	pop	bp
	ret	
_reset_disk	endp
   ;	
   ;	  ulong get_cyl (uchar d)
   ;	
	assume	cs:MGRP
_get_cyl	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	  {
   ;	   asm {
   ;		push bx
   ;	
	push	 bx
   ;	
   ;	        push cx
   ;	
	push	 cx
   ;	
   ;	        push si
   ;	
	push	 si
   ;	
   ;	        push di
   ;	
	push	 di
   ;	
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        mov dl,d
   ;	
	mov	 dl,[bp+4]
   ;	
   ;	        mov ah,8
   ;	
	mov	 ah,8
   ;	
   ;	        int 0x13
   ;	
	int	 013H
   ;	
   ;	        mov al,ch
   ;	
	mov	 al,ch
   ;	
   ;	        shr cl,6
   ;	
	shr	 cl,6
   ;	
   ;	        mov ah,cl
   ;	
	mov	 ah,cl
   ;	
   ;	        xor dx,dx
   ;	
	xor	 dx,dx
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	        pop di
   ;	
	pop	 di
   ;	
   ;	        pop si
   ;	
	pop	 si
   ;	
   ;	        pop cx
   ;	
	pop	 cx
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	       }
   ;	  }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_get_cyl	endp
   ;	
   ;	  ulong get_head (uchar d)
   ;	
	assume	cs:MGRP
_get_head	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	  {
   ;	   asm {
   ;	        push cx
   ;	
	push	 cx
   ;	
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;	        push si
   ;	
	push	 si
   ;	
   ;	        mov dl,d
   ;	
	mov	 dl,[bp+4]
   ;	
   ;	        mov ah,8
   ;	
	mov	 ah,8
   ;	
   ;		int 0x13
   ;	
	int	 013H
   ;	
   ;	        mov ah,0
   ;	
	mov	 ah,0
   ;	
   ;	        mov al,dh
   ;	
	mov	 al,dh
   ;	
   ;	        xor dx,dx
   ;	
	xor	 dx,dx
   ;	
   ;	        pop si
   ;	
	pop	 si
   ;	
   ;	        pop di
   ;	
	pop	 di
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop cx
   ;	
	pop	 cx
   ;	
   ;	       }
   ;	  }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_get_head	endp
   ;	
   ;	 ulong get_sector (uchar d)
   ;	
	assume	cs:MGRP
_get_sector	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	 {
   ;	  asm {
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
   ;	       push di
   ;	
	push	 di
   ;	
   ;	       push si
   ;	
	push	 si
   ;	
   ;	       mov dl,d
   ;	
	mov	 dl,[bp+4]
   ;	
   ;	       mov ah,8
   ;	
	mov	 ah,8
   ;	
   ;	       int 0x13
   ;	
	int	 013H
   ;	
   ;	       xor ah,ah
   ;	
	xor	 ah,ah
   ;	
   ;	       xor dx,dx
   ;	
	xor	 dx,dx
   ;	
   ;	       and cl,63
   ;	
	and	 cl,63
   ;	
   ;	       mov al,cl
   ;	
	mov	 al,cl
   ;	
   ;	       pop si
   ;	
	pop	 si
   ;	
   ;	       pop di
   ;	
	pop	 di
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
   ;	      }
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_get_sector	endp
   ;	
   ;	 bool disk_access (uchar d,
   ;	
	assume	cs:MGRP
_disk_access	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	                   int h,
   ;	                   int c,
   ;	                   int s,
   ;	                   int count,
   ;			   void* ofs,
   ;			   uint segm,
   ;			   int op)
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
_disk_access	endp
   ;	
   ;	 bool absolute_disk_access (uchar d,
   ;	
	assume	cs:MGRP
_absolute_disk_access	proc	near
	enter	12,0
	push	si
	push	di
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
   ;	
   ;	                            int op,
   ;	                            int count,
   ;	                            ulong addr,
   ;	                            uint seg,
   ;	                            uint ofs)
   ;	 {
   ;	  ulong c,h,s;
   ;	  bool stat;
   ;	  s = 1 + (addr % (ulong)get_sector(d) );
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	push	eax
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	pop	ebx
	div	ebx
	inc	edx
	mov	dword ptr [bp-12],edx
   ;	
   ;	  h = (addr / (ulong)get_sector(d)) % (ulong)get_head(d);
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	push	eax
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	pop	ebx
	div	ebx
	push	eax
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	xor	edx,edx
	mov	ebx,eax
	pop	eax
	div	ebx
	mov	dword ptr [bp-8],edx
   ;	
   ;	  c = addr / ((ulong)get_sector(d) * (ulong)get_head(d));
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	push	eax
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	ebx
	imul	ebx,eax
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	push	si
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	di
	push	word ptr [bp-12]
	push	word ptr [bp-4]
	push	word ptr [bp-8]
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_disk_access
	add	sp,16
	mov	dl,al
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	cmp	dl,6
	jne	short @36@86
	push	si
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	di
	push	word ptr [bp-12]
	push	word ptr [bp-4]
	push	word ptr [bp-8]
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_disk_access
	add	sp,16
	mov	dl,al
@36@86:
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	cmp	dl,6
	jne	short @36@142
	push	si
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	di
	push	word ptr [bp-12]
	push	word ptr [bp-4]
	push	word ptr [bp-8]
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_disk_access
	add	sp,16
	mov	dl,al
@36@142:
   ;	
   ;	  return stat;
   ;	
	mov	al,dl
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	leave	
	ret	
_absolute_disk_access	endp
	?debug	C E9E34B5357112E5C494E434C5544455C6C6F67696E2E68
   ;	
   ;	void login (unsigned int segl, unsigned int ofs)
   ;	
	assume	cs:MGRP
_login	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	{
   ;	 asm {
   ;	      push ax
   ;	
	push	 ax
   ;	
   ;	      push cx
   ;	
	push	 cx
   ;	
   ;	      push es
   ;	
	push	 es
   ;	
   ;	      push di
   ;	
	push	 di
   ;	
   ;	      push ds
   ;	
	push	 ds
   ;	
   ;	      push si
   ;	
	push	 si
   ;	
   ;	      mov ah,16h
   ;	
	mov	 ah,16h
   ;	
   ;	      int 44h
   ;	
	int	 44h
   ;	
   ;	      mov cx,15
   ;	
	mov	 cx,15
   ;	
   ;	      mov ax,segl
   ;	
	mov	 ax,[bp+4]
   ;	
   ;	      mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	      mov di,ofs
   ;	
	mov	 di,[bp+6]
   ;	
   ;	      rep movsb
   ;	
	rep movsb	
   ;	
   ;	      pop si
   ;	
	pop	 si
   ;	
   ;	      pop ds
   ;	
	pop	 ds
   ;	
   ;	      pop di
   ;	
	pop	 di
   ;	
   ;	      pop es
   ;	
	pop	 es
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
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_login	endp
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
	jmp	short @40@282
@40@58:
   ;	
   ;	 {
   ;	  if (line[i]!=32) { for (j=i;(line[j]!=32)&&(line[j]!=0);j++);line[j]=0;
   ;	
	mov	al,dl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @40@254
	mov	cl,dl
	jmp	short @40@142
@40@114:
	inc	cl
@40@142:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @40@198
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @40@114
@40@198:
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
	je	short @40@310
   ;	
   ;			     i=j;}
   ;	
	mov	dl,cl
@40@254:
	inc	dl
@40@282:
	cmp	dl,50
	jbe	short @40@58
@40@310:
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
	?debug	C E9AD79BE580F2E5C494E434C5544455C7069632E68
   ;	
   ;	void mode13 (void)
   ;	
	assume	cs:MGRP
_mode13	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ax,0x13
   ;	
	mov	 ax,013H
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_mode13	endp
   ;	
   ;	void mode3(void)
   ;	
	assume	cs:MGRP
_mode3	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;		int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_mode3	endp
   ;	
   ;	void putpixel (int x,int y,char color)
   ;	
	assume	cs:MGRP
_putpixel	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		mov ax,0xa000
   ;	
	mov	 ax,0a000H
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ax,320
   ;	
	mov	 ax,320
   ;	
   ;		mul y
   ;	
	mul	 [bp+6]
   ;	
   ;		add ax,x
   ;	
	add	 ax,[bp+4]
   ;	
   ;		mov bx,ax
   ;	
	mov	 bx,ax
   ;	
   ;		mov al,color
   ;	
	mov	 al,[bp+8]
   ;	
   ;		mov es:[bx],al
   ;	
	mov	 es:[bx],al
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop ax
   ;	
	pop	 ax
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	 }
   ;	}
   ;	
	pop	bp
	ret	
_putpixel	endp
   ;	
   ;	char peek (unsigned int ofs)
   ;	
	assume	cs:MGRP
_peek	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        mov ax,9000h
   ;	
	mov	 ax,9000h
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov bx,ofs
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        mov al,es:[bx]
   ;	
	mov	 al,es:[bx]
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_peek	endp
   ;	
   ;	void pic (char* picname, char p)
   ;	
	assume	cs:MGRP
_pic	proc	near
	enter	18,0
	push	si
	push	di
   ;	
   ;	{
   ;	
   ;	handle stream;
   ;	
   ;	unsigned int pici=0;
   ;	
   ;	
   ;	unsigned int picx=0,picy=200;
   ;	
	xor	si,si
	mov	di,200
   ;	
   ;	signed char picj=0;
   ;	
	mov	byte ptr [bp-7],0
   ;	
   ;	unsigned char pixel;
   ;	unsigned int colors = 1;
   ;	
	mov	word ptr [bp-10],1
   ;	
   ;	unsigned int sizeBuffer = 8000;
   ;	
	mov	word ptr [bp-12],8000
   ;	
   ;	unsigned int sizeHeader = 62;
   ;	
	mov	word ptr [bp-14],62
   ;	
   ;	unsigned char red, green, blue;
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
	jae short	@@0
	jmp	@45@1654
@@0:
   ;	
   ;	 if (fsize(stream) > (sizeBuffer + sizeHeader)) {
   ;	
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fsize
	push	dx
	push	ax
	pop	eax
	add	sp,4
	mov	dx,word ptr [bp-12]
	add	dx,word ptr [bp-14]
	movzx	edx,dx
	cmp	eax,edx
	jbe	short @45@114
   ;	
   ;	    colors = 16;
   ;	
	mov	word ptr [bp-10],16
   ;	
   ;	    sizeBuffer = 32000;
   ;	
	mov	word ptr [bp-12],32000
   ;	
   ;	    sizeHeader = 118;
   ;	
	mov	word ptr [bp-14],118
@45@114:
   ;	
   ;	 }   
   ;	 if (fsize(stream) > (sizeBuffer + sizeHeader)) {
   ;	
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fsize
	push	dx
	push	ax
	pop	eax
	add	sp,4
	mov	dx,word ptr [bp-12]
	add	dx,word ptr [bp-14]
	movzx	edx,dx
	cmp	eax,edx
	jbe	short @45@170
   ;	
   ;	    colors = 256;
   ;	
	mov	word ptr [bp-10],256
   ;	
   ;	    sizeBuffer = 48000;
   ;	
	mov	word ptr [bp-12],00000BB80h
   ;	
   ;	    sizeHeader = 1078;
   ;	
	mov	word ptr [bp-14],1078
   ;	
   ;	    picy = 160;
   ;	
	mov	di,160
@45@170:
   ;	
   ;	 } 
   ;	     
   ;	 fread (stream,sizeBuffer + sizeHeader,0,0x9000);
   ;	
	push	large 090000000h
	mov	ax,word ptr [bp-12]
	add	ax,word ptr [bp-14]
	movzx	eax,ax
	push	eax
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	
   ;	 mode13();
   ;	
	call	near ptr MGRP:_mode13
   ;	
   ;	 for (pici=0;pici<=sizeBuffer;pici++)
   ;	
	mov	word ptr [bp-6],0
	jmp	@45@1542
@45@198:
   ;	
   ;	 {
   ;	  if (colors == 1)
   ;	
	cmp	word ptr [bp-10],1
	jne	short @45@422
   ;	
   ;	  {
   ;	      for (picj=0;picj<=7;picj++)
   ;	
	mov	byte ptr [bp-7],0
	jmp	short @45@394
@45@254:
   ;	
   ;	       {
   ;	        pixel = (peek(pici+62) & (128>>picj));
   ;	
	mov	ax,word ptr [bp-6]
	add	ax,62
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	mov	dx,128
	mov	cl,byte ptr [bp-7]
	sar	dx,cl
	and	al,dl
	mov	byte ptr [bp-8],al
   ;	
   ;	        if (pixel) pixel = 7;
   ;	
	cmp	byte ptr [bp-8],0
	je	short @45@310
	mov	byte ptr [bp-8],7
@45@310:
   ;	
   ;	        putpixel (picx,picy,pixel );
   ;	
	mov	al,byte ptr [bp-8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_putpixel
	add	sp,6
   ;	
   ;	        picx++;
   ;	
	inc	si
   ;	
   ;	        if (picx==320) { picy--;picx=0;}
   ;	
	cmp	si,320
	jne	short @45@366
	dec	di
	xor	si,si
@45@366:
	inc	byte ptr [bp-7]
@45@394:
	cmp	byte ptr [bp-7],7
	jle	short @45@254
@45@422:
   ;	
   ;	       }
   ;	   }
   ;	   if (colors == 16)
   ;	
	cmp	word ptr [bp-10],16
	je short	@@1
	jmp	@45@1122
@@1:
   ;	
   ;	  {
   ;	        
   ;	        pixel = (peek(pici+sizeHeader) & 0xf0) >> 4 ;
   ;	
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-14]
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	and	ax,240
	sar	ax,4
	mov	byte ptr [bp-8],al
   ;	
   ;	        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
   ;	
	mov	ah,0
	shl	ax,2
	add	ax,56
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-15],al
   ;	
   ;	        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,55
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-16],al
   ;	
   ;	        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,54
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-17],al
   ;	
   ;	        asm {
   ;	            // Set entry 4
   ;	mov dx, 0x3c8
   ;	
	mov	 dx, 03c8H
   ;	
   ;	mov al, pixel
   ;	
	mov	 al, [bp-8]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	
   ;	inc dx
   ;	
	inc	 dx
   ;	
   ;	mov al, red 
   ;	
	mov	 al, [bp-15] 
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, green
   ;	
	mov	 al, [bp-16]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, blue
   ;	
	mov	 al, [bp-17]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        }
   ;	        
   ;	        putpixel (picx,picy,pixel );
   ;	
	mov	al,byte ptr [bp-8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_putpixel
	add	sp,6
   ;	
   ;	        picx++;
   ;	
	inc	si
   ;	
   ;	        
   ;	        pixel = (peek(pici+sizeHeader) & 0x0f);
   ;	
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-14]
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	and	al,15
	mov	byte ptr [bp-8],al
   ;	
   ;	        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
   ;	
	mov	ah,0
	shl	ax,2
	add	ax,56
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-15],al
   ;	
   ;	        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,55
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-16],al
   ;	
   ;	        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,54
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-17],al
   ;	
   ;	        asm {
   ;	            // Set entry 4
   ;	mov dx, 0x3c8
   ;	
	mov	 dx, 03c8H
   ;	
   ;	mov al, pixel
   ;	
	mov	 al, [bp-8]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	
   ;	inc dx
   ;	
	inc	 dx
   ;	
   ;	mov al, red 
   ;	
	mov	 al, [bp-15] 
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, green
   ;	
	mov	 al, [bp-16]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, blue
   ;	
	mov	 al, [bp-17]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        }
   ;	        putpixel (picx,picy,pixel );
   ;	
	mov	al,byte ptr [bp-8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_putpixel
	add	sp,6
   ;	
   ;	        picx++;
   ;	
	inc	si
   ;	
   ;	        
   ;	        if (picx==320) { picy--;picx=0;}
   ;	
	cmp	si,320
	jne	short @45@1122
	dec	di
	xor	si,si
@45@1122:
   ;	
   ;	  }
   ;	  
   ;	  if (colors == 256)
   ;	
	cmp	word ptr [bp-10],256
	je short	@@2
	jmp	@45@1514
@@2:
   ;	
   ;	  {
   ;	        
   ;	        pixel = peek(pici+sizeHeader);
   ;	
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-14]
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	mov	byte ptr [bp-8],al
   ;	
   ;	        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
   ;	
	mov	ah,0
	shl	ax,2
	add	ax,56
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-15],al
   ;	
   ;	        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,55
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-16],al
   ;	
   ;	        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
   ;	
	mov	al,byte ptr [bp-8]
	mov	ah,0
	shl	ax,2
	add	ax,54
	push	ax
	call	near ptr MGRP:_peek
	pop	cx
	cbw	
	sar	ax,2
	mov	byte ptr [bp-17],al
   ;	
   ;	        asm {
   ;	            // Set entry 4
   ;	mov dx, 0x3c8
   ;	
	mov	 dx, 03c8H
   ;	
   ;	mov al, pixel
   ;	
	mov	 al, [bp-8]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	
   ;	inc dx
   ;	
	inc	 dx
   ;	
   ;	mov al, red 
   ;	
	mov	 al, [bp-15] 
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, green
   ;	
	mov	 al, [bp-16]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	mov al, blue
   ;	
	mov	 al, [bp-17]
   ;	
   ;	out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        }
   ;	        
   ;	        putpixel (picx,picy,pixel );
   ;	
	mov	al,byte ptr [bp-8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_putpixel
	add	sp,6
   ;	
   ;	        picx++;
   ;	
	inc	si
   ;	
   ;	        
   ;	        if (picx==300) { picy--;picx=0;}
   ;	
	cmp	si,300
	jne	short @45@1514
	dec	di
	xor	si,si
@45@1514:
	inc	word ptr [bp-6]
@45@1542:
	mov	ax,word ptr [bp-6]
	cmp	ax,word ptr [bp-12]
	ja short	@@3
	jmp	@45@198
@@3:
   ;	
   ;	  }
   ;	   
   ;	 }
   ;	 if (p=='p') getch ();
   ;	
	cmp	byte ptr [bp+6],112
	jne	short @45@1626
	call	near ptr MGRP:_getch
@45@1626:
   ;	
   ;	 mode3();
   ;	
	call	near ptr MGRP:_mode3
@45@1654:
   ;	
   ;	} 
   ;	
	pop	di
	pop	si
	leave	
	ret	
_pic	endp
_path	label	byte
	db	47
	db	98
	db	105
	db	110
	db	47
	db	32
	db	94 dup (0)
_path_count	label	word
	db	1
	db	0
nl	label	byte
	db	13
	db	10
	db	0
ERROR	label	byte
	db	10
	db	13
	db	115
	db	104
	db	62
	db	32
	db	101
	db	114
	db	114
	db	111
	db	114
	db	0
success	label	byte
	db	115
	db	104
	db	62
	db	32
	db	111
	db	107
	db	0
bad_opcode	label	byte
	db	10
	db	13
	db	115
	db	104
	db	62
	db	32
	db	117
	db	110
	db	107
	db	110
	db	111
	db	119
	db	110
	db	32
	db	99
	db	111
	db	109
	db	109
	db	97
	db	110
	db	100
	db	10
	db	0
_quit	label	word
	db	0
	db	0
_gui	label	word
	db	0
	db	0
iscolor	label	byte
	db	0
_sector	label	byte
	db	0
	db	511 dup (0)
   ;	
   ;	unsigned char get_boot_drive (void)
   ;	
	assume	cs:MGRP
_get_boot_drive	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	       push es
   ;	
	push	 es
   ;	
   ;	       mov ax,07c0h
   ;	
	mov	 ax,07c0h
   ;	
   ;	       mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	       mov al,es:[509]
   ;	
	mov	 al,es:[509]
   ;	
   ;	       pop es
   ;	
	pop	 es
   ;	
   ;	      }
   ;	}
   ;	
	ret	
_get_boot_drive	endp
   ;	
   ;	void writedword (unsigned long dw)
   ;	
	assume	cs:MGRP
_writedword	proc	near
	enter	4,0
	push	si
   ;	
   ;	{
   ;	 unsigned long i ; unsigned char b ;
   ;	 int flag=0;
   ;	
	xor	si,si
   ;	
   ;	 for (i=1000000000;i!=0;i/=10)
   ;	
	mov	dword ptr [bp-4],large 03B9ACA00h
	jmp	short @47@226
@47@58:
   ;	
   ;	 {
   ;	 b = dw / i ; dw = dw - (b*i) ;
   ;	
	mov	eax,dword ptr [bp+4]
	xor	edx,edx
	div	dword ptr [bp-4]
	mov	bl,al
	mov	ah,0
	movsx	eax,ax
	imul	eax,dword ptr [bp-4]
	mov	edx,dword ptr [bp+4]
	sub	edx,eax
	mov	dword ptr [bp+4],edx
   ;	
   ;	 if (b) flag = 1;
   ;	
	or	bl,bl
	je	short @47@114
	mov	si,1
@47@114:
   ;	
   ;	 if ( flag  && isecho)  putc (b+48) ;
   ;	
	or	si,si
	je	short @47@198
	cmp	word ptr MGRP:_isecho,0
	je	short @47@198
	mov	al,bl
	add	al,48
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
@47@198:
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@47@226:
	cmp	dword ptr [bp-4],large 0
	jne	short @47@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	si
	leave	
	ret	
_writedword	endp
   ;	
   ;	void cputc (char c, char color)
   ;	
	assume	cs:MGRP
_cputc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 if ( (iscolor) && ( !is_xsh () ) )
   ;	
	cmp	byte ptr MGRP:iscolor,0
	je	short @48@422
	call	near ptr MGRP:_is_xsh
	cbw	
	or	ax,ax
	jne	short @48@422
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
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		mov ah,9
   ;	
	mov	 ah,9
   ;	
   ;		mov bh,0
   ;	
	mov	 bh,0
   ;	
   ;		mov cx,1
   ;	
	mov	 cx,1
   ;	
   ;		mov al,c
   ;	
	mov	 al,[bp+4]
   ;	
   ;		mov bl,color
   ;	
	mov	 bl,[bp+6]
   ;	
   ;		int 10h
   ;	
	int	 10h
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop ax
   ;	
	pop	 ax
@48@422:
   ;	
   ;	     };
   ;	 putc (c);
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_cputc	endp
   ;	
   ;	void cputs (string s,char color)
   ;	
	assume	cs:MGRP
_cputs	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 if (isecho) for (i=0; s[i] != 0; i++) cputc (s[i],color);
   ;	
	cmp	word ptr MGRP:_isecho,0
	je	short @49@170
	xor	si,si
	jmp	short @49@142
@49@86:
	mov	al,byte ptr [bp+6]
	push	ax
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_cputc
	add	sp,4
	inc	si
@49@142:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @49@86
@49@170:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_cputs	endp
   ;	
   ;	void dir (int show)
   ;	
	assume	cs:MGRP
_dir	proc	near
	enter	20,0
	push	si
   ;	
   ;	 {
   ;	  ulong i;
   ;	  ulong j;
   ;	  ulong _dir;
   ;	  ulong fcb_count;
   ;	  ulong counter=0;
   ;	
	mov	dword ptr [bp-20],large 0
   ;	
   ;	  int stat=0;
   ;	
	xor	si,si
   ;	
   ;	
   ;	   _dir = acdir ();
   ;	
	call	near ptr MGRP:_acdir
	push	dx
	push	ax
	pop	eax
	mov	dword ptr [bp-12],eax
   ;	
   ;	   j = 1;
   ;	
	mov	dword ptr [bp-8],large 1
   ;	
   ;	   fcb_count = get_fcb_count ();
   ;	
	call	near ptr MGRP:_get_fcb_count
	push	dx
	push	ax
	pop	eax
	mov	dword ptr [bp-16],eax
   ;	
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
   ;	
	mov	dword ptr [bp-4],large 18
	jmp	@50@646
@50@58:
   ;	
   ;	   {
   ;	    fcb_dir (i,&cluster_buffer);
   ;	
	push	offset MGRP:_cluster_buffer
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fcb_dir
	add	sp,6
	jmp	@50@562
@50@86:
   ;	
   ;	    for (;j <= (FCB_PER_SECTOR-1); j++)
   ;	    {
   ;	     if ( (counter+1) == fcb_count) { stat=1;break; }
   ;	
	mov	eax,dword ptr [bp-20]
	inc	eax
	cmp	eax,dword ptr [bp-16]
	jne	short @50@142
	mov	si,1
	jmp	@50@590
@50@142:
   ;	
   ;	     if (cluster_buffer[j].f_name[0]!=0)
   ;	
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx],0
	jne short	@@4
	jmp	@50@534
@@4:
   ;	
   ;	     {
   ;	      counter++;
   ;	
	inc	dword ptr [bp-20]
   ;	
   ;	      if (cluster_buffer[j].f_dir_father==_dir) {
   ;	
	mov	bx,word ptr [bp-8]
	shl	bx,5
	mov	eax,dword ptr MGRP:_cluster_buffer[bx+16]
	cmp	eax,dword ptr [bp-12]
	je short	@@5
	jmp	@50@534
@@5:
   ;	
   ;							  {
   ;							   if (cluster_buffer[j].f_attr==0xa)
   ;	
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],10
	jne	short @50@254
   ;	
   ;							    { cputs (cluster_buffer[j].f_name,9);putc ('/');}
   ;	
	push	9
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_cputs
	add	sp,4
	push	47
	jmp	short @50@394
@50@254:
   ;	
   ;							   else if (cluster_buffer[j].f_attr==0xc)
   ;	
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],12
	jne	short @50@310
   ;	
   ;							    { cputs (cluster_buffer[j].f_name,2);putc ('*');}
   ;	
	push	2
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_cputs
	add	sp,4
	push	42
	jmp	short @50@394
@50@310:
   ;	
   ;							   else if (cluster_buffer[j].f_attr==0xd)
   ;	
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],13
	jne	short @50@366
   ;	
   ;							    { cputs (cluster_buffer[j].f_name,3);putc ('&');}
   ;	
	push	3
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_cputs
	add	sp,4
	push	38
	jmp	short @50@394
@50@366:
   ;	
   ;							   else { cputs (cluster_buffer[j].f_name,7); putc (' ');}
   ;	
	push	7
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_cputs
	add	sp,4
	push	32
@50@394:
	call	near ptr MGRP:_putc
	pop	cx
   ;	
   ;							   for (x=0;strlen(cluster_buffer[j].f_name)+x<=14;x++) putc(32);
   ;	
	mov	word ptr MGRP:_x,0
	jmp	short @50@506
@50@450:
	push	32
	call	near ptr MGRP:_putc
	pop	cx
	inc	word ptr MGRP:_x
@50@506:
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	add	ax,word ptr MGRP:_x
	cmp	ax,14
	jle	short @50@450
@50@534:
	inc	dword ptr [bp-8]
@50@562:
	cmp	dword ptr [bp-8],large 15
	ja short	@@6
	jmp	@50@86
@@6:
@50@590:
   ;	
   ;							  }
   ;							}
   ;	     }
   ;	    }
   ;	   j = 0;
   ;	
	mov	dword ptr [bp-8],large 0
   ;	
   ;	   if (stat) break;
   ;	
	or	si,si
	jne	short @50@674
	inc	dword ptr [bp-4]
@50@646:
	cmp	dword ptr [bp-4],large 218
	ja short	@@7
	jmp	@50@58
@@7:
@50@674:
   ;	
   ;	   }
   ;	
   ;	 }
   ;	
	pop	si
	leave	
	ret	
_dir	endp
   ;	
   ;	 void format_disk (unsigned char dr)
   ;	
	assume	cs:MGRP
_format_disk	proc	near
	enter	8,0
   ;	
   ;	 {
   ;	  ulong bitmap_size;
   ;	  ulong ix;
   ;	
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  bitmap_size = (((get_cyl(dr)+1) * (get_head (dr)+1) * get_sector (dr) -1) >> 3)+1;
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	pop	edx
	imul	edx,eax
	push	edx
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	dec	edx
	shr	edx,3
	inc	edx
	mov	dword ptr [bp-4],edx
   ;	
   ;	  writedword (bitmap_size);
   ;	
	push	edx
	call	near ptr MGRP:_writedword
	add	sp,4
   ;	
   ;	  reset_disk (dr);
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_reset_disk
	pop	cx
   ;	
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  writedword (220+(bitmap_size>>9)+1);
   ;	
	mov	eax,dword ptr [bp-4]
	shr	eax,9
	add	eax,large 221
	push	eax
	call	near ptr MGRP:_writedword
	add	sp,4
   ;	
   ;	  for (ix=0;ix <= (220+(bitmap_size>>9)+1); ix++)
   ;	
	mov	dword ptr [bp-8],large 0
	jmp	short @51@114
@51@58:
   ;	
   ;	   {
   ;	   if (absolute_disk_access (dr,DISK_WRITE,1,ix,_CS,(uint)&sector)) return;
   ;	
	push	offset MGRP:_sector
	push	cs
	push	dword ptr [bp-8]
	push	large 000010003h
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_absolute_disk_access
	add	sp,14
	or	al,al
	jne	short @51@170
	inc	dword ptr [bp-8]
@51@114:
	mov	eax,dword ptr [bp-4]
	shr	eax,9
	add	eax,large 221
	cmp	eax,dword ptr [bp-8]
	jae	short @51@58
   ;	
   ;	   }
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  puts (success);
   ;	
	push	offset MGRP:success
	call	near ptr MGRP:_puts
	pop	cx
@51@170:
   ;	
   ;	
   ;	 }
   ;	
	leave	
	ret	
_format_disk	endp
   ;	
   ;	 void syst (unsigned char dr)
   ;	
	assume	cs:MGRP
_syst	proc	near
	enter	6,0
   ;	
   ;	 {
   ;	  ulong i;
   ;	  unsigned char odr;
   ;	
   ;	  if (dr==0x00) odr = 0x80;
   ;	
	cmp	byte ptr [bp+4],0
	jne	short @52@86
	mov	byte ptr [bp-5],128
@52@86:
   ;	
   ;	  if (dr==0x80) odr = 0x00;
   ;	
	cmp	byte ptr [bp+4],128
	jne	short @52@142
	mov	byte ptr [bp-5],0
@52@142:
   ;	
   ;	
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  puts ("writing boot sector ...");
   ;	
	push	offset MGRP:s@+30
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  if (absolute_disk_access (odr,DISK_READ,1,0,_CS,(uint)&sector)) return;
   ;	
	push	offset MGRP:_sector
	push	cs
	push	large 0
	push	large 000010002h
	mov	al,byte ptr [bp-5]
	push	ax
	call	near ptr MGRP:_absolute_disk_access
	add	sp,14
	or	al,al
	je short	@@8
	jmp	@52@422
@@8:
   ;	
   ;	  sector [509] = dr;
   ;	
	mov	al,byte ptr [bp+4]
	mov	byte ptr MGRP:_sector+509,al
   ;	
   ;	  reset_disk (dr);
   ;	
	push	ax
	call	near ptr MGRP:_reset_disk
	pop	cx
   ;	
   ;	  if (absolute_disk_access (dr,DISK_WRITE,1,0,_CS,(uint)&sector)) { puts (ERROR);return;}
   ;	
	push	offset MGRP:_sector
	push	cs
	push	large 0
	push	large 000010003h
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_absolute_disk_access
	add	sp,14
	or	al,al
	je	short @52@226
	push	offset MGRP:ERROR
	jmp	short @52@394
@52@226:
   ;	
   ;	
   ;	  puts ("\n\rwriting kernel sectors ...");
   ;	
	push	offset MGRP:s@+54
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	
   ;	  for (i=1;i<=17;i++)
   ;	
	mov	dword ptr [bp-4],large 1
	jmp	short @52@338
@52@254:
   ;	
   ;	   {
   ;	   writedword (i);
   ;	
	push	dword ptr [bp-4]
	call	near ptr MGRP:_writedword
	add	sp,4
   ;	
   ;	  if (absolute_disk_access (odr,DISK_READ,1,i,_CS,(uint)&sector)) return;
   ;	
	push	offset MGRP:_sector
	push	cs
	push	dword ptr [bp-4]
	push	large 000010002h
	mov	al,byte ptr [bp-5]
	push	ax
	call	near ptr MGRP:_absolute_disk_access
	add	sp,14
	or	al,al
	jne	short @52@422
   ;	
   ;	  if (absolute_disk_access (dr,DISK_WRITE,1,i,_CS,(uint)&sector)) return;
   ;	
	push	offset MGRP:_sector
	push	cs
	push	dword ptr [bp-4]
	push	large 000010003h
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr MGRP:_absolute_disk_access
	add	sp,14
	or	al,al
	jne	short @52@422
	inc	dword ptr [bp-4]
@52@338:
	cmp	dword ptr [bp-4],large 17
	jbe	short @52@254
   ;	
   ;	
   ;	   }
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	  puts (success);
   ;	
	push	offset MGRP:success
@52@394:
	call	near ptr MGRP:_puts
	pop	cx
@52@422:
   ;	
   ;	 }
   ;	
	leave	
	ret	
_syst	endp
   ;	
   ;	void up (char* prompt)
   ;	
	assume	cs:MGRP
_up	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	 char i;
   ;	 i = strlen (prompt)-2;
   ;	
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	add	al,254
	mov	dl,al
	jmp	short @53@142
@53@58:
   ;	
   ;	 for (; (i>=0) && (prompt[i] != ':') ; i--)
   ;	  if (prompt [i] == '/') { prompt [i+1] = 0; break; }
   ;	
	mov	al,dl
	cbw	
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jne	short @53@114
	mov	al,dl
	cbw	
	add	ax,si
	mov	bx,ax
	mov	byte ptr [bx+1],0
	jmp	short @53@198
@53@114:
	dec	dl
@53@142:
	or	dl,dl
	jl	short @53@198
	mov	al,dl
	cbw	
	mov	bx,ax
	cmp	byte ptr [bx+si],58
	jne	short @53@58
@53@198:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_up	endp
   ;	
   ;	void process (char* prompt, char* dir)
   ;	
	assume	cs:MGRP
_process	proc	near
	enter	2,0
	push	si
	push	di
	mov	di,word ptr [bp+4]
	mov	si,word ptr [bp+6]
   ;	
   ;	{
   ;	 char i,j;
   ;	
   ;	 j =0; i =0;
   ;	
	mov	byte ptr [bp-2],0
	mov	byte ptr [bp-1],0
   ;	
   ;	
   ;	 temp [j] = 0;
   ;	
	mov	al,byte ptr [bp-2]
	cbw	
	mov	bx,ax
	mov	byte ptr MGRP:_temp[bx],0
   ;	
   ;	 if (dir[0] == '/') { prompt[0] = '/'; prompt [1] = 0; i++;};
   ;	
	cmp	byte ptr [si],47
	je short	@@9
	jmp	@54@422
@@9:
	mov	byte ptr [di],47
	mov	byte ptr [di+1],0
	jmp	@54@394
@54@86:
   ;	
   ;	
   ;	 for (; i<=strlen (dir) ; i++)
   ;	 {
   ;	  if ( (dir [i] == '.') && (dir [i+1] == '/')) { i = i+1; }
   ;	
	mov	al,byte ptr [bp-1]
	cbw	
	mov	bx,ax
	cmp	byte ptr [bx+si],46
	jne	short @54@198
	mov	al,byte ptr [bp-1]
	cbw	
	add	ax,si
	mov	bx,ax
	cmp	byte ptr [bx+1],47
	jne	short @54@198
	mov	al,byte ptr [bp-1]
	inc	al
@54@170:
	mov	byte ptr [bp-1],al
	jmp	@54@394
@54@198:
   ;	
   ;	  else if ( (dir [i] == '.') && (dir [i+1] == '.') && (dir [i+2] == '/'))
   ;	
	mov	al,byte ptr [bp-1]
	cbw	
	mov	bx,ax
	cmp	byte ptr [bx+si],46
	jne	short @54@310
	mov	al,byte ptr [bp-1]
	cbw	
	add	ax,si
	mov	bx,ax
	cmp	byte ptr [bx+1],46
	jne	short @54@310
	mov	al,byte ptr [bp-1]
	cbw	
	add	ax,si
	mov	bx,ax
	cmp	byte ptr [bx+2],47
	jne	short @54@310
   ;	
   ;	   {
   ;	    up (prompt);
   ;	
	push	di
	call	near ptr MGRP:_up
	pop	cx
   ;	
   ;	    i = i+2;
   ;	
	mov	al,byte ptr [bp-1]
	add	al,2
	jmp	short @54@170
@54@310:
   ;	
   ;	   }
   ;	  else if ( dir [i] == '/')
   ;	
	mov	al,byte ptr [bp-1]
	cbw	
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jne	short @54@366
   ;	
   ;	  {
   ;	   temp [j] = '/';
   ;	
	mov	al,byte ptr [bp-2]
	cbw	
	mov	bx,ax
	mov	byte ptr MGRP:_temp[bx],47
   ;	
   ;	   temp [j+1] = 0;
   ;	
	mov	al,byte ptr [bp-2]
	cbw	
	mov	bx,ax
	mov	byte ptr MGRP:_temp[bx+1],0
   ;	
   ;	   strcat (prompt,temp);
   ;	
	push	offset MGRP:_temp
	push	di
	call	near ptr MGRP:_strcat
	add	sp,4
   ;	
   ;	   j =0; temp [j] = 0;
   ;	
	mov	byte ptr [bp-2],0
	mov	al,byte ptr [bp-2]
	cbw	
	mov	bx,ax
	mov	byte ptr MGRP:_temp[bx],0
   ;	
   ;	  }
   ;	
	jmp	short @54@394
@54@366:
   ;	
   ;	  else temp [j++] = dir [i];
   ;	
	mov	al,byte ptr [bp-1]
	cbw	
	mov	bx,ax
	mov	al,byte ptr [bx+si]
	push	ax
	mov	al,byte ptr [bp-2]
	cbw	
	mov	bx,ax
	pop	ax
	mov	byte ptr MGRP:_temp[bx],al
	inc	byte ptr [bp-2]
@54@394:
	inc	byte ptr [bp-1]
@54@422:
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jb short	@@10
	jmp	@54@86
@@10:
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_process	endp
   ;	
   ;	 void change_directory (char* new_dir)
   ;	
	assume	cs:MGRP
_change_directory	proc	near
	enter	4,0
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	 {
   ;	  int x1=0;
   ;	
   ;	
   ;	  int dummy=0;
   ;	
   ;	
   ;	  unsigned long tempDIR;
   ;	  x1 = strlen (new_dir);
   ;	
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	mov	dx,ax
   ;	
   ;	
   ;	  if ( new_dir [x1-1] == '/') { new_dir [x1] = '.';
   ;	
	mov	bx,dx
	add	bx,si
	cmp	byte ptr [bx-1],47
	jne	short @55@86
	mov	bx,dx
	mov	byte ptr [bx+si],46
   ;	
   ;						      new_dir [x1+1] = 0;
   ;	
	add	bx,si
	mov	byte ptr [bx+1],0
   ;	
   ;						    }
   ;	
	jmp	short @55@114
@55@86:
   ;	
   ;	  else { new_dir [x1] = '/';
   ;	
	mov	bx,dx
	mov	byte ptr [bx+si],47
   ;	
   ;		 new_dir [x1+1] = '.';
   ;	
	add	bx,si
	mov	byte ptr [bx+1],46
   ;	
   ;		 new_dir [x1+2] = 0;
   ;	
	mov	bx,dx
	add	bx,si
	mov	byte ptr [bx+2],0
@55@114:
   ;	
   ;	       }
   ;	
   ;	  tempDIR = chdir (new_dir);
   ;	
	push	si
	call	near ptr MGRP:_chdir
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (tempDIR == 0xffffffff) { puts (ERROR);
   ;	
	cmp	dword ptr [bp-4],large -1
	jne	short @55@170
	push	offset MGRP:ERROR
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;					       return ;
   ;	
	jmp	short @55@198
@55@170:
   ;	
   ;					     }
   ;	   process (prompt,new_dir);
   ;	
	push	si
	push	offset MGRP:_prompt
	call	near ptr MGRP:_process
	add	sp,4
@55@198:
   ;	
   ;	   }
   ;	
	pop	si
	leave	
	ret	
_change_directory	endp
   ;	
   ;	void doCmd (char* cmd)
   ;	
	assume	cs:MGRP
_doCmd	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	    if (!strcmp ((string)get_argz(cmd,1),"ls")) dir(0);
   ;	
	push	offset MGRP:s@+83
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@86
@56@58:
	push	0
	call	near ptr MGRP:_dir
	jmp	@56@3054
@56@86:
   ;	
   ;	    else if (!strcmp ((string)get_argz(cmd,1),"dir")) dir(0);
   ;	
	push	offset MGRP:s@+86
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je	short @56@58
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"ds")) {	   puts (nl);
   ;	
	push	offset MGRP:s@+90
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@226
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;							 puts ("max_addr: ");writedword (DISK_STATE.max_addr);
   ;	
	push	offset MGRP:s@+93
	call	near ptr MGRP:_puts
	pop	cx
	push	dword ptr MGRP:_DISK_STATE+4
	call	near ptr MGRP:_writedword
	add	sp,4
   ;	
   ;							 puts (" bitmap:   ");writedword (DISK_STATE.bitmap_size);
   ;	
	push	offset MGRP:s@+104
	call	near ptr MGRP:_puts
	pop	cx
	push	dword ptr MGRP:_DISK_STATE+8
@56@170:
	call	near ptr MGRP:_writedword
@56@198:
	add	sp,4
   ;	
   ;						       }
   ;	
	jmp	@56@3082
@56@226:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"mkdir")) {
   ;	
	push	offset MGRP:s@+116
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@310
   ;	
   ;								  if (!mkdir (get_argz(cmd,2))) puts (ERROR); }
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_mkdir
	pop	cx
	cbw	
	or	ax,ax
	je short	@@11
	jmp	@56@3082
@@11:
@56@282:
	push	offset MGRP:ERROR
	jmp	@56@3026
@56@310:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"rmdir")) {
   ;	
	push	offset MGRP:s@+122
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@394
   ;	
   ;								if (!rmdir (get_argz(cmd,2))) puts (ERROR); }
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_rmdir
	pop	cx
	cbw	
	or	ax,ax
	je short	@@12
	jmp	@56@3082
@@12:
	jmp	short @56@282
@56@394:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"cd")) change_directory (get_argz(cmd,2));
   ;	
	push	offset MGRP:s@+128
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@450
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_change_directory
	jmp	@56@3054
@56@450:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"mem")) { puts (nl);
   ;	
	push	offset MGRP:s@+131
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@506
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                                                      puts ("Memory usage:"); puts (nl);
   ;	
	push	offset MGRP:s@+135
	call	near ptr MGRP:_puts
	pop	cx
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                                                      puts (" used blocks: ");writedword (avail()); puts (nl);
   ;	
	push	offset MGRP:s@+149
	call	near ptr MGRP:_puts
	pop	cx
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	call	near ptr MGRP:_writedword
	add	sp,4
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                                                      puts (" used memory: ");writedword (avail()<<4); puts (nl);
   ;	
	push	offset MGRP:s@+164
	call	near ptr MGRP:_puts
	pop	cx
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	shl	eax,4
	push	eax
	call	near ptr MGRP:_writedword
	add	sp,4
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                                                      puts (" free memory: ");writedword ( 458752 - (avail()<<4) );
   ;	
	push	offset MGRP:s@+179
	call	near ptr MGRP:_puts
	pop	cx
	call	near ptr MGRP:_avail
	push	dx
	push	ax
	pop	eax
	shl	eax,4
	mov	edx,large 000070000h
	sub	edx,eax
	push	edx
	jmp	@56@170
@56@506:
   ;	
   ;	
   ;	                                                }
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"rem")) ;
   ;	
	push	offset MGRP:s@+194
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne short	@@13
	jmp	@56@3082
@@13:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"#"));
   ;	
	push	offset MGRP:s@+198
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne short	@@14
	jmp	@56@3082
@@14:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"ver")) { puts (nl); puts (nl); puts ("QuickDreamOS Version 0.5"); puts (nl); puts 
   ;	
	push	offset MGRP:s@+200
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@618
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
	push	offset MGRP:s@+204
	call	near ptr MGRP:_puts
	pop	cx
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
	push	offset MGRP:nl
	jmp	@56@3026
@56@618:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"color"))
   ;	
	push	offset MGRP:s@+229
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@758
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz(cmd,2),"on")) iscolor =1;
   ;	
	push	offset MGRP:s@+235
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@702
	mov	byte ptr MGRP:iscolor,1
@56@702:
   ;	
   ;	    if (!strcmp ((string)get_argz(cmd,2),"off")) iscolor =0;
   ;	
	push	offset MGRP:s@+238
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@15
	jmp	@56@3082
@@15:
	mov	byte ptr MGRP:iscolor,0
	jmp	@56@3082
@56@758:
   ;	
   ;	   }
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"setpath")) {
   ;	
	push	offset MGRP:s@+242
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@814
   ;	
   ;							       strcpy ((string)get_argz(path,path_count)+strlen((string)get_argz(path,path_count))+1
   ;	
   ;	
   ;							       ,(string)get_argz(cmd,2));
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	push	word ptr MGRP:_path_count
	push	offset MGRP:_path
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	push	word ptr MGRP:_path_count
	push	offset MGRP:_path
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	pop	dx
	add	dx,ax
	inc	dx
	push	dx
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;							       path_count++;
   ;	
	inc	word ptr MGRP:_path_count
   ;	
   ;							      }
   ;	
	jmp	@56@3082
@56@814:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"size")) {
   ;	
	push	offset MGRP:s@+250
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@898
   ;	
   ;							       puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;							       file1 = fopen (get_argz(cmd,2));
   ;	
	push	2
	push	si
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
   ;							       if (file1 <2) return;
   ;	
	cmp	dword ptr MGRP:_file1,large 2
	jae short	@@16
	jmp	@56@3082
@@16:
   ;	
   ;							       else writedword (fsize(file1));
   ;	
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	jmp	@56@170
@56@898:
   ;	
   ;							      }
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"pic")) { if (!is_xsh ()) pic ((string)get_argz(cmd,2),get_argz(cmd,3)[0] ); }
   ;	
	push	offset MGRP:s@+255
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@982
	call	near ptr MGRP:_is_xsh
	cbw	
	or	ax,ax
	je short	@@17
	jmp	@56@3082
@@17:
	push	3
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	push	ax
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_pic
	jmp	@56@198
@56@982:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"device")) exec (get_argz(cmd,2),_CS,(unsigned int)buf,0);
   ;	
	push	offset MGRP:s@+259
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1066
	push	0
	push	offset MGRP:_buf
	push	cs
	push	2
@56@1038:
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	jmp	@56@2802
@56@1066:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"pwd")) puts (prompt);
   ;	
	push	offset MGRP:s@+266
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1122
	push	offset MGRP:_prompt
	jmp	@56@3026
@56@1122:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"chmod")) {
   ;	
	push	offset MGRP:s@+270
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@18
	jmp	@56@1346
@@18:
   ;	
   ;								//puts (nl);
   ;								file1 = fopen (get_argz(cmd,3));
   ;	
	push	3
	push	si
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
   ;								if (file1 <2) return;
   ;	
	cmp	dword ptr MGRP:_file1,large 2
	jae short	@@19
	jmp	@56@3082
@@19:
   ;	
   ;								if ( (string)get_argz(cmd,2)[0] == 'x') setattr (file1,0xc);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	cbw	
	cmp	ax,120
	jne	short @56@1234
	push	12
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_setattr
	add	sp,6
@56@1234:
   ;	
   ;								if ( (string)get_argz(cmd,2)[0] == 'a') setattr (file1,0xb);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	cbw	
	cmp	ax,97
	jne	short @56@1290
	push	11
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_setattr
	add	sp,6
@56@1290:
   ;	
   ;								if ( (string)get_argz(cmd,2)[0] == 's') setattr (file1,0xd);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	cbw	
	cmp	ax,115
	je short	@@20
	jmp	@56@3082
@@20:
	push	13
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_setattr
	add	sp,6
	jmp	@56@3082
@56@1346:
   ;	
   ;							       }
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"rm")) {
   ;	
	push	offset MGRP:s@+276
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1458
   ;	
   ;							  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;							  file1 = fopen (get_argz(cmd,2));
   ;	
	push	2
	push	si
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
   ;	                                                  if (file1 <2) { puts (ERROR); return;}
   ;	
	cmp	dword ptr MGRP:_file1,large 2
	jae short	@@21
	jmp	@56@282
@@21:
   ;	
   ;							  if (!fremove(file1)) puts (success);
   ;	
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fremove
	add	sp,4
	cbw	
	or	ax,ax
	je short	@@22
	jmp	@56@3082
@@22:
	jmp	@56@2550
@56@1458:
   ;	
   ;							}
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"clear")) { if (!is_xsh()) asm { mov ax,3 ; int 0x10 ; } }
   ;	
	push	offset MGRP:s@+279
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1598
	call	near ptr MGRP:_is_xsh
	cbw	
	or	ax,ax
	je short	@@23
	jmp	@56@3082
@@23:
 	mov	 ax,3 
 	int	 010H 
	jmp	@56@3082
@56@1598:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"halt"))  { batch ("/etc/shut.rc");quit=1;}
   ;	
	push	offset MGRP:s@+285
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1654
	push	offset MGRP:s@+290
	call	near ptr MGRP:_batch
	pop	cx
	jmp	short @56@1682
@56@1654:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"exit"))  quit=1;
   ;	
	push	offset MGRP:s@+303
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1710
@56@1682:
	mov	word ptr MGRP:_quit,1
	jmp	@56@3082
@56@1710:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"gui"))  gui=1;
   ;	
	push	offset MGRP:s@+308
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1766
	mov	word ptr MGRP:_gui,1
	jmp	@56@3082
@56@1766:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"off")) isecho = 0;
   ;	
	push	offset MGRP:s@+312
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1822
	mov	word ptr MGRP:_isecho,0
	jmp	@56@3082
@56@1822:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"on")) isecho = 1;
   ;	
	push	offset MGRP:s@+316
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1878
	mov	word ptr MGRP:_isecho,1
	jmp	@56@3082
@56@1878:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"echo")) {  x = isecho; isecho=1;puts (nl); puts ((string)get_argz(cmd,1)+5);isecho
   ;	
	push	offset MGRP:s@+319
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@1934
	mov	ax,word ptr MGRP:_isecho
	mov	word ptr MGRP:_x,ax
	mov	word ptr MGRP:_isecho,1
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,5
	push	ax
	call	near ptr MGRP:_puts
	pop	cx
	mov	ax,word ptr MGRP:_x
	mov	word ptr MGRP:_isecho,ax
	jmp	@56@3082
@56@1934:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"mkfs")) {
   ;	
	push	offset MGRP:s@+324
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@2074
   ;	
   ;								 if (get_argz(cmd,2)[0] == 'a') format_disk (0x00);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],97
	jne	short @56@2018
	push	0
	call	near ptr MGRP:_format_disk
	pop	cx
@56@2018:
   ;	
   ;								 if (get_argz(cmd,2)[0] == 'c') format_disk (0x80);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],99
	je short	@@24
	jmp	@56@3082
@@24:
	push	128
	call	near ptr MGRP:_format_disk
	jmp	@56@3054
@56@2074:
   ;	
   ;								}
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"sethostname")) ;//strcat (prompt,(string)get_argz(cmd,2));
   ;	
	push	offset MGRP:s@+329
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne short	@@25
	jmp	@56@3082
@@25:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"c:")) {
   ;	
	push	offset MGRP:s@+341
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@2158
   ;	
   ;							      chdir ("c:/.");
   ;	
	push	offset MGRP:s@+344
	call	near ptr MGRP:_chdir
	pop	cx
   ;	
   ;	                                                      change_disk (0x80);
   ;	
	push	128
	call	near ptr MGRP:_change_disk
	pop	cx
   ;	
   ;							      usedrive = 'c';
   ;	
	mov	byte ptr MGRP:_usedrive,99
   ;	
   ;							    }
   ;	
	jmp	@56@3082
@56@2158:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"a:")) {
   ;	
	push	offset MGRP:s@+349
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@2214
   ;	
   ;							      chdir ("a:/.");
   ;	
	push	offset MGRP:s@+352
	call	near ptr MGRP:_chdir
	pop	cx
   ;	
   ;							      change_disk (0x00);
   ;	
	push	0
	call	near ptr MGRP:_change_disk
	pop	cx
   ;	
   ;							      usedrive = 'a';
   ;	
	mov	byte ptr MGRP:_usedrive,97
   ;	
   ;							    }
   ;	
	jmp	@56@3082
@56@2214:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"pause")) getch();
   ;	
	push	offset MGRP:s@+357
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@2270
	call	near ptr MGRP:_getch
	jmp	@56@3082
@56@2270:
   ;	
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"sys")) {
   ;	
	push	offset MGRP:s@+363
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @56@2410
   ;	
   ;								 if (get_argz(cmd,2)[0] == 'a') syst (0x00);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],97
	jne	short @56@2354
	push	0
	call	near ptr MGRP:_syst
	pop	cx
@56@2354:
   ;	
   ;								 if (get_argz(cmd,2)[0] == 'c') syst (0x80);
   ;	
	push	2
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],99
	je short	@@26
	jmp	@56@3082
@@26:
	push	128
	call	near ptr MGRP:_syst
	jmp	@56@3054
@56@2410:
   ;	
   ;							     }
   ;	   else if (!strcmp ((string)get_argz(cmd,1),"cp")) {
   ;	
	push	offset MGRP:s@+367
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@27
	jmp	@56@2578
@@27:
   ;	
   ;	
   ;							  file1 = fopen (get_argz(cmd,2));
   ;	
	push	2
	push	si
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
   ;							  puts ("\n\rread,");
   ;	
	push	offset MGRP:s@+370
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;							  if (file1 <2) { puts (ERROR);
   ;	
	cmp	dword ptr MGRP:_file1,large 2
	jae short	@@28
	jmp	@56@282
@@28:
   ;	
   ;									  return;
   ;	
   ;									}
   ;							  file2 = fcreate (get_argz(cmd,3));
   ;	
	push	3
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_fcreate
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file2,eax
   ;	
   ;							  puts ("write\n\r");
   ;	
	push	offset MGRP:s@+378
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;							  if (file2 <2) { puts (ERROR);
   ;	
	cmp	dword ptr MGRP:_file2,large 2
	jae short	@@29
	jmp	@56@282
@@29:
   ;	
   ;									  return;
   ;									}
   ;							  if (!fread (file1,fsize(file1),0,0x9000)) {puts (ERROR); return;}
   ;	
	push	large 090000000h
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fread
	add	sp,12
	or	ax,ax
	jne short	@@30
	jmp	@56@282
@@30:
   ;	
   ;							  if (!fwrite (file2,fsize(file1),0,0x9000)) {puts (ERROR); return;}
   ;	
	push	large 090000000h
	push	dword ptr MGRP:_file1
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_file2
	call	near ptr MGRP:_fwrite
	add	sp,12
	or	ax,ax
	jne short	@@31
	jmp	@56@282
@@31:
@56@2550:
	push	offset MGRP:success
	jmp	@56@3026
@56@2578:
   ;	
   ;	
   ;							  puts (success);
   ;							 }
   ;	  else if (!strcmp ((string)get_argz(cmd,1),""));
   ;	
	push	offset MGRP:s@+386
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne short	@@32
	jmp	@56@3082
@@32:
   ;	
   ;	  else   {
   ;	
   ;		  if ( ((string)get_argz(cmd,1)[0] == '/'))
   ;	
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	cbw	
	cmp	ax,47
	jne	short @56@2690
   ;	
   ;		  {
   ;		   file2 = fopen (get_argz(cmd,1));
   ;	
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file2,eax
   ;	
   ;		   if (file2 <2) { puts (bad_opcode);
   ;	
	cmp	dword ptr MGRP:_file2,large 2
	jae short	@@33
	jmp	@56@2998
@@33:
   ;	
   ;				}
   ;		   else exec (get_argz(cmd,1),_CS,(unsigned int)buf,1);
   ;	
	push	1
	push	offset MGRP:_buf
	push	cs
	push	1
	jmp	@56@1038
@56@2690:
   ;	
   ;		  }
   ;		  else
   ;		  if ( ((string)get_argz(cmd,1)[0] == '.') && ((string)get_argz(cmd,1)[1] == '/'))
   ;	
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx]
	cbw	
	cmp	ax,46
	jne	short @56@2830
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	mov	al,byte ptr [bx+1]
	cbw	
	cmp	ax,47
	jne	short @56@2830
   ;	
   ;		  {
   ;		   file2 = fopen (get_argz(cmd,1)+2);
   ;	
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,2
	push	ax
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file2,eax
   ;	
   ;		   if (file2 <2) { puts (bad_opcode);
   ;	
	cmp	dword ptr MGRP:_file2,large 2
	jae short	@@34
	jmp	@56@2998
@@34:
   ;	
   ;				}
   ;		   else exec (get_argz(cmd,1)+2,_CS,(unsigned int)buf,1);
   ;	
	push	1
	push	offset MGRP:_buf
	push	cs
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,2
@56@2802:
	push	ax
	call	near ptr MGRP:_exec
	add	sp,8
	jmp	@56@3082
@56@2830:
   ;	
   ;		  }
   ;		  else
   ;		  {
   ;		   for (x=1; x<=path_count; x++)
   ;	
	mov	word ptr MGRP:_x,1
	jmp	short @56@2942
@56@2858:
   ;	
   ;		   {
   ;		    memset ( _CS,(uint)temp,100,0 );
   ;	
	push	0
	push	100
	push	offset MGRP:_temp
	push	cs
	call	near ptr MGRP:_memset
	add	sp,8
   ;	
   ;		    strcpy ( temp,(string)get_argz(path,x));
   ;	
	push	word ptr MGRP:_x
	push	offset MGRP:_path
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	push	offset MGRP:_temp
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;		    strcat ( temp,(string)get_argz(cmd,1));
   ;	
	push	1
	push	si
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	push	offset MGRP:_temp
	call	near ptr MGRP:_strcat
	add	sp,4
   ;	
   ;		    file2 = fopen (temp);
   ;	
	push	offset MGRP:_temp
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_file2,eax
   ;	
   ;		    if (file2 <2);
   ;	
	cmp	dword ptr MGRP:_file2,large 2
	jb	short @56@2914
   ;	
   ;		    else { exec (temp,_CS,(unsigned int)buf,1); break; }
   ;	
	push	1
	push	offset MGRP:_buf
	push	cs
	push	offset MGRP:_temp
	call	near ptr MGRP:_exec
	add	sp,8
	jmp	short @56@2970
@56@2914:
	inc	word ptr MGRP:_x
@56@2942:
	mov	ax,word ptr MGRP:_x
	cmp	ax,word ptr MGRP:_path_count
	jle	short @56@2858
@56@2970:
   ;	
   ;		   }
   ;		  if (file2 <2)
   ;	
	cmp	dword ptr MGRP:_file2,large 2
	jae	short @56@3082
@56@2998:
   ;	
   ;		  puts (bad_opcode);
   ;	
	push	offset MGRP:bad_opcode
@56@3026:
	call	near ptr MGRP:_puts
@56@3054:
	pop	cx
@56@3082:
   ;	
   ;		  }
   ;		 }
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_doCmd	endp
   ;	
   ;	 void clearBufferSegment (void)
   ;	
	assume	cs:MGRP
_clearBufferSegment	proc	near
	push	di
   ;	
   ;	 {
   ;	  asm {
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
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,bufferbatch
   ;	
	mov	 ax,MGRP:_bufferbatch
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,0
   ;	
	mov	 di,0
   ;	
   ;	        mov cx,0xfff0
   ;	
	mov	 cx,0fff0H
   ;	
   ;		mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;		rep stosb
   ;	
	rep stosb	
   ;	
   ;		pop di
   ;	
	pop	 di
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
   ;	      }
   ;	 }
   ;	
	pop	di
	ret	
_clearBufferSegment	endp
   ;	
   ;	 char peekchar (uint ofs)
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
	mov	 ax,MGRP:_bufferbatch
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
	jmp	short @59@114
@59@58:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	mov	bx,si
	mov	byte ptr [bx+di],al
	inc	si
@59@114:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	cmp	al,13
	je	short @59@170
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @59@58
@59@170:
   ;	
   ;	  if (peekchar (file_offset+i) == 0) return 0;
   ;	
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @59@226
	xor	ax,ax
	jmp	short @59@254
@59@226:
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
@59@254:
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fgets	endp
   ;	
   ;	 void batch (char* batchfile)
   ;	
	assume	cs:MGRP
_batch	proc	near
	enter	4,0
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	 {
   ;	  handle bfile;
   ;	
   ;	  bufferbatch = malloc (0xfff);
   ;	
	push	4095
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_bufferbatch,ax
   ;	
   ;	
   ;	  if (!bufferbatch) return;
   ;	
	cmp	word ptr MGRP:_bufferbatch,0
	jne short	@@35
	jmp	@60@254
@@35:
   ;	
   ;	  clearBufferSegment ();
   ;	
	call	near ptr MGRP:_clearBufferSegment
   ;	
   ;	
   ;	  bfile = fopen (batchfile);
   ;	
	push	si
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (bfile < 2) {      puts ("\n\rscript> file '");
   ;	
	cmp	dword ptr [bp-4],large 2
	jae	short @60@114
	push	offset MGRP:s@+387
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;				puts (batchfile);
   ;	
	push	si
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;				puts ("' can't be found.");
   ;	
	push	offset MGRP:s@+404
	call	near ptr MGRP:_puts
	jmp	short @60@226
@60@114:
   ;	
   ;				return; }
   ;	  fread (bfile,fsize (bfile),0,bufferbatch);
   ;	
	push	word ptr MGRP:_bufferbatch
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
	jmp	short @60@170
@60@142:
   ;	
   ;	  while ( fgets (cmdsh) )
   ;	  {
   ;	   memset (_CS,(uint)buf,100,0);
   ;	
	push	0
	push	100
	push	offset MGRP:_buf
	push	cs
	call	near ptr MGRP:_memset
	add	sp,8
   ;	
   ;	   strcpy (buf,cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	push	offset MGRP:_buf
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	   doCmd (cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_doCmd
	pop	cx
   ;	
   ;	   memset (_CS,(uint)cmdsh,100,0);
   ;	
	push	0
	push	100
	push	offset MGRP:_cmdsh
	push	cs
	call	near ptr MGRP:_memset
	add	sp,8
@60@170:
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_fgets
	pop	cx
	or	ax,ax
	jne	short @60@142
   ;	
   ;	  }
   ;	  free (bufferbatch);
   ;	
	push	word ptr MGRP:_bufferbatch
	call	near ptr MGRP:_free
@60@226:
	pop	cx
@60@254:
   ;	
   ;	 }
   ;	
	pop	si
	leave	
	ret	
_batch	endp
   ;	
   ;	 int far shell (char first)
   ;	
	assume	cs:MGRP
_shell	proc	far
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
@61@58:
   ;	
   ;	
   ;	  while (1)
   ;	  {
   ;	   
   ;	   memset (_CS,(uint)cmdsh,100,0);
   ;	
	push	0
	push	100
	push	offset MGRP:_cmdsh
	push	cs
	call	near ptr MGRP:_memset
	add	sp,8
   ;	
   ;	   
   ;	   if (first > (char)2)
   ;	
	cmp	byte ptr [bp+6],2
	jle	short @61@114
   ;	
   ;	   {
   ;	             cputc(first, 7);
   ;	
	push	7
	mov	al,byte ptr [bp+6]
	push	ax
	call	near ptr MGRP:_cputc
	add	sp,4
   ;	
   ;	             cmdsh[0] = first;  
   ;	
	mov	al,byte ptr [bp+6]
	mov	byte ptr MGRP:_cmdsh,al
	jmp	short @61@170
@61@114:
   ;	
   ;	             gets (cmdsh, 100);
   ;	   } 
   ;	   else
   ;	   {
   ;	       puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	       cputc (usedrive,7); cputc (':',7);cputs (prompt,7); cputc ('>',7);
   ;	
	push	7
	mov	al,byte ptr MGRP:_usedrive
	push	ax
	call	near ptr MGRP:_cputc
	add	sp,4
	push	7
	push	58
	call	near ptr MGRP:_cputc
	add	sp,4
	push	7
	push	offset MGRP:_prompt
	call	near ptr MGRP:_cputs
	add	sp,4
	push	7
	push	62
	call	near ptr MGRP:_cputc
	add	sp,4
   ;	
   ;	       if (first == (char)2) return 0;
   ;	
	cmp	byte ptr [bp+6],2
	jne	short @61@170
@61@142:
	xor	ax,ax
	jmp	@61@646
@61@170:
   ;	
   ;	       gets (cmdsh,100);
   ;	
	push	100
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_gets
	add	sp,4
   ;	
   ;	   }
   ;	   
   ;	   memset (_CS,(uint)buf,100,0);
   ;	
	push	0
	push	100
	push	offset MGRP:_buf
	push	cs
	call	near ptr MGRP:_memset
	add	sp,8
   ;	
   ;	   strcpy (buf,cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	push	offset MGRP:_buf
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	
   ;	   if ( !strcmp ((string)get_argz(cmdsh,1),"make")) batch ("Makefile");
   ;	
	push	offset MGRP:s@+422
	push	1
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @61@282
	push	offset MGRP:s@+427
@61@254:
	call	near ptr MGRP:_batch
	pop	cx
	jmp	short @61@422
@61@282:
   ;	
   ;	   else if ( ((string)get_argz(cmdsh,1))[0] == '$') batch ( (string)get_argz(cmdsh,1)+1);
   ;	
	push	1
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],36
	jne	short @61@338
	push	1
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_get_argz
	add	sp,4
	inc	ax
	push	ax
	jmp	short @61@254
@61@338:
   ;	
   ;	   else if ( ((string)get_argz(cmdsh,1))[0] == '@')
   ;	
	push	1
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],64
	jne	short @61@394
   ;	
   ;	   {
   ;	    doCmd (cmdsh+1);
   ;	
	push	offset MGRP:_cmdsh+1
	call	near ptr MGRP:_doCmd
	pop	cx
   ;	
   ;	    quit = 1;
   ;	
	mov	word ptr MGRP:_quit,1
   ;	
   ;	   }
   ;	
	jmp	short @61@422
@61@394:
   ;	
   ;	   else {
   ;		   doCmd (cmdsh);
   ;	
	push	offset MGRP:_cmdsh
	call	near ptr MGRP:_doCmd
	pop	cx
   ;	
   ;	           _DS = _CS;
   ;	
	mov	ax,cs
	mov	ds,ax
@61@422:
   ;	
   ;	        }
   ;	
   ;	   if (is_xsh()) 
   ;	
	call	near ptr MGRP:_is_xsh
	or	al,al
	je	short @61@590
   ;	
   ;	   {
   ;	      if (quit) 
   ;	
	cmp	word ptr MGRP:_quit,0
	jne short	@@36
	jmp	@61@142
@@36:
   ;	
   ;	      {
   ;	         asm {
   ;	            mov al,1
   ;	
	mov	 al,1
   ;	
   ;	            int 0x29
   ;	
	int	 029H
   ;	
   ;	         }
   ;	         quit = 0;
   ;	
	mov	word ptr MGRP:_quit,0
   ;	
   ;	         return 0;  
   ;	
	jmp	@61@142
	jmp	@61@142
@61@590:
   ;	
   ;	      }                     
   ;	      //puts (nl);
   ;	      //cputc (usedrive,7); cputc (':',7);cputs (prompt,7); cputc ('>',7);
   ;	      return 0;
   ;	      //break;
   ;	   }
   ;	      
   ;	   if (quit) break;
   ;	
	cmp	word ptr MGRP:_quit,0
	jne short	@@37
	jmp	@61@58
@@37:
   ;	
   ;	   
   ;	  }
   ;	 quit = 0;
   ;	
	mov	word ptr MGRP:_quit,0
@61@646:
   ;	
   ;	 }
   ;	
	pop	bp
	ret	
_shell	endp
   ;	
   ;	 void main ()
   ;	
	assume	cs:MGRP
_main	proc	near
	push	si
	push	di
   ;	
   ;	 {
   ;	
   ;	  get_disk_state (&DISK_STATE);
   ;	
	push	offset MGRP:_DISK_STATE
	call	near ptr MGRP:_get_disk_state
	pop	cx
   ;	
   ;	
   ;	 // prompt [0] = '[';
   ;	 // login (_CS,(uint)prompt+1);
   ;	
   ;	  prompt [0] = '/';
   ;	
	mov	byte ptr MGRP:_prompt,47
   ;	
   ;	  prompt [1] = 0;
   ;	
	mov	byte ptr MGRP:_prompt+1,0
   ;	
   ;	
   ;	  usedrive = (get_boot_drive () == 0x80) ? 'c' : 'a';
   ;	
	call	near ptr MGRP:_get_boot_drive
	cmp	al,128
	jne	short @62@86
	mov	al,99
	jmp	short @62@114
@62@86:
	mov	al,97
@62@114:
	mov	byte ptr MGRP:_usedrive,al
   ;	
   ;	
   ;	  batch ("/etc/init.rc");
   ;	
	push	offset MGRP:s@+436
	call	near ptr MGRP:_batch
	pop	cx
   ;	
   ;	
   ;	  asm {
   ;	        push si
   ;	
	push	 si
   ;	
   ;	        push di
   ;	
	push	 di
   ;	
   ;		push ax
   ;	
	push	 ax
   ;	
   ;	        mov si,ds
   ;	
	mov	 si,ds
   ;	
   ;	        mov di,offset shell
   ;	
	mov	 di,offset _shell
   ;	
   ;	        mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;	        int 0x46
   ;	
	int	 046H
   ;	
   ;	        pop ax
   ;	
	pop	 ax
   ;	
   ;	        pop di
   ;	
	pop	 di
   ;	
   ;	        pop si
   ;	
	pop	 si
   ;	
   ;	      };
   ;	
   ;	
   ;	//  strcat (prompt," ");
   ;	  puts (nl);
   ;	
	push	offset MGRP:nl
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	
   ;	  if (gui) exec ("/bin/xsh",0,0,1);
   ;	
	cmp	word ptr MGRP:_gui,0
	je	short @62@478
	push	1
	push	large 0
	push	offset MGRP:s@+449
	call	near ptr MGRP:_exec
	add	sp,8
@62@478:
   ;	
   ;	
   ;	  shell ((char)0);
   ;	
	push	0
	push	cs
	call	near ptr MGRP:_shell
	pop	cx
   ;	
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	ret	
_main	endp
_file_offset	label	word
	db	2 dup (0)
_i	label	word
	db	2 dup (0)
_file2	label	word
	db	4 dup (0)
_file1	label	word
	db	4 dup (0)
_bufferbatch	label	word
	db	2 dup (0)
_x	label	word
	db	2 dup (0)
_usedrive	label	byte
	db	1 dup (0)
_diskl	label	byte
	db	1 dup (0)
_buf	label	byte
	db	100 dup (0)
_temp	label	byte
	db	100 dup (0)
_cmdsh	label	byte
	db	100 dup (0)
_prompt	label	byte
	db	100 dup (0)
_DISK_STATE	label	word
	db	13 dup (0)
_DRIVE	label	byte
	db	1 dup (0)
	?debug	C E9
	?debug	C FA10010000
s@	label	byte
	db	10
	db	13
	db	'warning: memory no released'
	db	0
	db	'writing boot sector ...'
	db	0
	db	10
	db	13
	db	'writing kernel sectors ...'
	db	0
	db	'ls'
	db	0
	db	'dir'
	db	0
	db	'ds'
	db	0
	db	'max_addr: '
	db	0
	db	' bitmap:   '
	db	0
	db	'mkdir'
	db	0
	db	'rmdir'
	db	0
	db	'cd'
	db	0
	db	'mem'
	db	0
	db	'Memory usage:'
	db	0
	db	' used blocks: '
	db	0
	db	' used memory: '
	db	0
	db	' free memory: '
	db	0
	db	'rem'
	db	0
	db	'#'
	db	0
	db	'ver'
	db	0
	db	'QuickDreamOS Version 0.5'
	db	0
	db	'color'
	db	0
	db	'on'
	db	0
	db	'off'
	db	0
	db	'setpath'
	db	0
	db	'size'
	db	0
	db	'pic'
	db	0
	db	'device'
	db	0
	db	'pwd'
	db	0
	db	'chmod'
	db	0
	db	'rm'
	db	0
	db	'clear'
	db	0
	db	'halt'
	db	0
	db	'/etc/shut.rc'
	db	0
	db	'exit'
	db	0
	db	'gui'
	db	0
	db	'off'
	db	0
	db	'on'
	db	0
	db	'echo'
	db	0
	db	'mkfs'
	db	0
	db	'sethostname'
	db	0
	db	'c:'
	db	0
	db	'c:/.'
	db	0
	db	'a:'
	db	0
	db	'a:/.'
	db	0
	db	'pause'
	db	0
	db	'sys'
	db	0
	db	'cp'
	db	0
	db	10
	db	13
	db	'read,'
	db	0
	db	'write'
	db	10
	db	13
	db	0
	db	0
	db	10
	db	13
	db	'script> file '
	db	39
	db	0
	db	39
	db	' can'
	db	39
	db	't be found.'
	db	0
	db	'make'
	db	0
	db	'Makefile'
	db	0
	db	'/etc/init.rc'
	db	0
	db	'/bin/xsh'
	db	0
VPSEG	ends
	public	_shell
	public	_fgets
	public	_file_offset
	public	_peekchar
	public	_clearBufferSegment
	public	_doCmd
	public	_change_directory
	public	_process
	public	_up
	public	_syst
	public	_format_disk
	public	_i
	public	_dir
	public	_cputs
	public	_cputc
	public	_writedword
	public	_get_boot_drive
	public	_batch
	public	_file2
	public	_file1
	public	_sector
	public	_bufferbatch
_iscolor	equ	iscolor
	public	_gui
	public	_quit
_bad_opcode	equ	bad_opcode
_success	equ	success
_ERROR	equ	ERROR
_nl	equ	nl
	public	_path_count
	public	_x
	public	_usedrive
	public	_diskl
	public	_buf
	public	_temp
	public	_path
	public	_cmdsh
	public	_prompt
	public	_pic
	public	_peek
	public	_putpixel
	public	_mode3
	public	_mode13
	public	_get_argz
	public	_memset
	public	_memcpy
	public	_login
	public	_absolute_disk_access
	public	_disk_access
	public	_get_sector
	public	_get_head
	public	_get_cyl
	public	_reset_disk
	public	_DISK_STATE
	public	_DRIVE
	public	_fcb_dir
	public	_get_fcb_count
	public	_cluster_buffer
	public	_lastf
	public	_change_disk
	public	_get_disk_state
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
	public	_acdir
	public	_chdir
	public	_rmdir
	public	_mkdir
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
	public	_gets
	public	_getch
	public	_puts
	public	_putc
	public	_is_xsh
	public	_isecho
	public	_startup
	public	_main
_s@	equ	s@
	end
