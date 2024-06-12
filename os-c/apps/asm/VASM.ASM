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
	?debug	S "vasm.c"
	?debug	C E9D6567958067661736D2E63
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
   ;	 start_program ();
   ;	
	call	near ptr MGRP:_start_program
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_main	endp
	?debug	C E9E343535709747970656465662E68
	?debug	C E9E343535708737472696E672E68
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
	jmp	short @5@86
@5@58:
	inc	byte ptr [bp-1]
@5@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @5@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @5@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @5@58
@5@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @5@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @5@254
	mov	al,0
	jmp	short @5@282
@5@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@5@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
	?debug	C E9E3435357056172672E68
   ;	
   ;	char* get_argz (char* line,int count)
   ;	
	assume	cs:MGRP
_get_argz	proc	near
	enter	2,0
	push	si
	mov	cx,word ptr [bp+4]
   ;	
   ;	{
   ;	 unsigned char i ;
   ;	 unsigned char j ;
   ;	 int intern_count=0 ;
   ;	
	xor	si,si
   ;	
   ;	 for (i=0;i<=50;i++)
   ;	
	mov	dl,0
	jmp	short @6@338
@6@58:
   ;	
   ;	 {
   ;	  if ( (line[i]!=32) && (line[i]!=',')) { for (j=i;(line[j]!=32)&&(line[j]!=0)&&(line[j]!=',');j++);line[j]=0;
   ;	
	mov	al,dl
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],32
	je	short @6@310
	mov	al,dl
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],44
	je	short @6@310
	mov	byte ptr [bp-1],dl
	jmp	short @6@170
@6@142:
	inc	byte ptr [bp-1]
@6@170:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],32
	je	short @6@254
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @6@254
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],44
	jne	short @6@142
@6@254:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	byte ptr [bx],0
   ;	
   ;	
   ;	                     intern_count++;
   ;	
	inc	si
   ;	
   ;			     if (intern_count==count) break ;
   ;	
	cmp	si,word ptr [bp+6]
	je	short @6@366
   ;	
   ;			     i=j;}
   ;	
	mov	dl,byte ptr [bp-1]
@6@310:
	inc	dl
@6@338:
	cmp	dl,50
	jbe	short @6@58
@6@366:
   ;	
   ;	 }
   ;	return (line+i);
   ;	
	mov	al,dl
	mov	ah,0
	push	ax
	mov	ax,cx
	pop	dx
	add	ax,dx
   ;	
   ;	}
   ;	
	pop	si
	leave	
	ret	
_get_argz	endp
	?debug	C E9E34353570666696C652E68
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
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_exec	endp
	?debug	C E9E3435357086D656D6F72792E68
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
   ;	 int fgets (char* s,int in,handle h)
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
	jmp	short @19@114
@19@58:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	mov	bx,si
	mov	byte ptr [bx+di],al
	inc	si
@19@114:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	cmp	al,13
	je	short @19@170
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @19@58
@19@170:
   ;	
   ;	  if (peekchar (file_offset+i) == 0) return 0;
   ;	
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @19@226
	xor	ax,ax
	jmp	short @19@254
@19@226:
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
@19@254:
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fgets	endp
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
   ;	void putc (char c)
   ;	
	assume	cs:MGRP
_putc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		mov al,c
   ;	
	mov	 al,[bp+4]
   ;	
   ;		int 0x29
   ;	
	int	 029H
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
_putc	endp
   ;	
   ;	void putn (unsigned long dw)
   ;	
	assume	cs:MGRP
_putn	proc	near
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
	jmp	short @22@198
@22@58:
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
	je	short @22@114
	mov	si,1
@22@114:
   ;	
   ;	 if (flag)  putc (b+48) ;
   ;	
	or	si,si
	je	short @22@170
	mov	al,bl
	add	al,48
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
@22@170:
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@22@198:
	cmp	dword ptr [bp-4],large 0
	jne	short @22@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	si
	leave	
	ret	
_putn	endp
   ;	
   ;	void puts (char* s)
   ;	
	assume	cs:MGRP
_puts	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 for (i=0; s[i] != 0; i++) putc (s[i]);
   ;	
	xor	si,si
	jmp	short @23@114
@23@58:
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
	inc	si
@23@114:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @23@58
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_puts	endp
   ;	
   ;	 addr malloc (unsigned int paragraph)
   ;	
	assume	cs:MGRP
_malloc	proc	near
	push	bp
	mov	bp,sp
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;		push bx
   ;	
	push	 bx
   ;	
   ;	        push cx
   ;	
	push	 cx
   ;	
   ;	        push di
   ;	
	push	 di
   ;	
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        mov ah,0x0012
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
   ;	        mov bx,ax
   ;	
	mov	 bx,ax
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov di,0
   ;	
	mov	 di,0
   ;	
   ;		mov cx,0fff0h
   ;	
	mov	 cx,0fff0h
   ;	
   ;	        mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;		// rep stosb
   ;	        mov ax,bx
   ;	
	mov	 ax,bx
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	        pop di
   ;	
	pop	 di
   ;	
   ;	        pop cx
   ;	
	pop	 cx
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	      }
   ;	}
   ;	
	pop	di
	pop	bp
	ret	
_malloc	endp
_ofs	label	word
	db	0
	db	0
_ligne	label	word
	db	0
	db	0
_label	label	byte
	db	0
	db	19 dup (0)
	db	0
	db	19 dup (0)
	db	960 dup (0)
_wlabel	label	byte
	db	0
	db	19 dup (0)
	db	0
	db	19 dup (0)
	db	960 dup (0)
_lab_ofs	label	word
	db	0
	db	0
	db	98 dup (0)
_wlab_ofs	label	word
	db	0
	db	0
	db	98 dup (0)
_wlab_cod	label	byte
	db	0
	db	49 dup (0)
_op	label	byte
	db	0
_actual_code	label	byte
	db	0
_reg16	label	byte
	db	97
	db	120
	db	6 dup (0)
	db	99
	db	120
	db	6 dup (0)
	db	100
	db	120
	db	6 dup (0)
	db	98
	db	120
	db	6 dup (0)
	db	115
	db	112
	db	6 dup (0)
	db	98
	db	112
	db	6 dup (0)
	db	115
	db	105
	db	6 dup (0)
	db	100
	db	105
	db	6 dup (0)
_reg8	label	byte
	db	97
	db	108
	db	6 dup (0)
	db	99
	db	108
	db	6 dup (0)
	db	100
	db	108
	db	6 dup (0)
	db	98
	db	108
	db	6 dup (0)
	db	97
	db	104
	db	6 dup (0)
	db	99
	db	104
	db	6 dup (0)
	db	100
	db	104
	db	6 dup (0)
	db	98
	db	104
	db	6 dup (0)
_sreg	label	byte
	db	101
	db	115
	db	2 dup (0)
	db	99
	db	115
	db	2 dup (0)
	db	115
	db	115
	db	2 dup (0)
	db	100
	db	115
	db	2 dup (0)
_ofs_bx	label	byte
	db	91
	db	98
	db	120
	db	93
	db	0
_ofs_si	label	byte
	db	91
	db	115
	db	105
	db	93
	db	0
_ofs_di	label	byte
	db	91
	db	100
	db	105
	db	93
	db	0
_jcc	label	word
	dw	MGRP:s@
	dw	MGRP:s@+3
	dw	MGRP:s@+6
	dw	MGRP:s@+9
	dw	MGRP:s@+13
	dw	MGRP:s@+16
	dw	MGRP:s@+20
	dw	MGRP:s@+23
	dw	MGRP:s@+28
	dw	MGRP:s@+31
	dw	MGRP:s@+35
	dw	MGRP:s@+38
	dw	MGRP:s@+42
	dw	MGRP:s@+46
	dw	MGRP:s@+51
	dw	MGRP:s@+55
	dw	MGRP:s@+60
	dw	MGRP:s@+64
	dw	MGRP:s@+68
	dw	MGRP:s@+72
	dw	MGRP:s@+77
	dw	MGRP:s@+81
	dw	MGRP:s@+86
	dw	MGRP:s@+90
	dw	MGRP:s@+94
	dw	MGRP:s@+98
	dw	MGRP:s@+102
	dw	MGRP:s@+105
	dw	MGRP:s@+108
	dw	MGRP:s@+112
	dw	MGRP:s@+116
	dw	MGRP:s@+119
	dw	MGRP:s@+124
	dw	MGRP:s@+130
	dw	MGRP:s@+137
	dw	MGRP:s@+144
_jcc_code	label	byte
	db	116
	db	116
	db	119
	db	115
	db	114
	db	118
	db	114
	db	227
	db	127
	db	125
	db	124
	db	126
	db	118
	db	114
	db	115
	db	119
	db	115
	db	117
	db	126
	db	124
	db	125
	db	127
	db	113
	db	123
	db	121
	db	117
	db	112
	db	122
	db	122
	db	123
	db	120
	db	226
	db	225
	db	224
	db	224
	db	225
_once_opcode	label	word
	db	115
	db	116
	db	111
	db	115
	db	98
	db	1 dup (0)
	db	170
	db	115
	db	116
	db	111
	db	115
	db	119
	db	1 dup (0)
	db	171
	db	115
	db	99
	db	97
	db	115
	db	98
	db	1 dup (0)
	db	174
	db	115
	db	99
	db	97
	db	115
	db	119
	db	1 dup (0)
	db	175
	db	99
	db	108
	db	100
	db	3 dup (0)
	db	252
	db	99
	db	109
	db	99
	db	3 dup (0)
	db	245
	db	99
	db	119
	db	100
	db	3 dup (0)
	db	153
	db	110
	db	111
	db	112
	db	3 dup (0)
	db	144
	db	99
	db	98
	db	119
	db	3 dup (0)
	db	152
	db	115
	db	116
	db	100
	db	3 dup (0)
	db	253
	db	99
	db	108
	db	99
	db	3 dup (0)
	db	248
	db	115
	db	116
	db	99
	db	3 dup (0)
	db	249
	db	51
	db	50
	db	98
	db	3 dup (0)
	db	102
	db	112
	db	117
	db	115
	db	104
	db	102
	db	1 dup (0)
	db	156
	db	112
	db	117
	db	115
	db	104
	db	97
	db	1 dup (0)
	db	96
	db	112
	db	111
	db	112
	db	102
	db	2 dup (0)
	db	157
	db	112
	db	111
	db	112
	db	97
	db	2 dup (0)
	db	97
	db	46
	db	101
	db	115
	db	3 dup (0)
	db	38
	db	97
	db	97
	db	97
	db	3 dup (0)
	db	55
	db	97
	db	97
	db	115
	db	3 dup (0)
	db	63
	db	99
	db	108
	db	105
	db	3 dup (0)
	db	250
	db	115
	db	116
	db	105
	db	3 dup (0)
	db	251
	db	114
	db	101
	db	112
	db	3 dup (0)
	db	243
	db	114
	db	101
	db	112
	db	99
	db	2 dup (0)
	db	101
	db	114
	db	101
	db	112
	db	122
	db	2 dup (0)
	db	243
	db	108
	db	97
	db	104
	db	102
	db	2 dup (0)
	db	159
	db	115
	db	97
	db	104
	db	102
	db	2 dup (0)
	db	158
	db	104
	db	108
	db	116
	db	3 dup (0)
	db	244
	db	114
	db	101
	db	112
	db	101
	db	2 dup (0)
	db	243
	db	114
	db	101
	db	112
	db	110
	db	101
	db	1 dup (0)
	db	242
	db	114
	db	101
	db	112
	db	110
	db	122
	db	1 dup (0)
	db	242
	db	114
	db	101
	db	112
	db	110
	db	99
	db	1 dup (0)
	db	100
	db	99
	db	109
	db	112
	db	115
	db	98
	db	1 dup (0)
	db	166
	db	99
	db	109
	db	112
	db	115
	db	119
	db	1 dup (0)
	db	167
	db	109
	db	111
	db	118
	db	115
	db	98
	db	1 dup (0)
	db	164
	db	109
	db	111
	db	118
	db	115
	db	119
	db	1 dup (0)
	db	165
	db	114
	db	101
	db	116
	db	3 dup (0)
	db	195
	db	114
	db	101
	db	116
	db	102
	db	2 dup (0)
	db	203
	db	105
	db	114
	db	101
	db	116
	db	2 dup (0)
	db	207
	db	46
	db	99
	db	115
	db	3 dup (0)
	db	46
_bin_opcode	label	word
	db	115
	db	104
	db	114
	db	1 dup (0)
	db	232
	db	115
	db	104
	db	108
	db	1 dup (0)
	db	224
	db	114
	db	99
	db	108
	db	1 dup (0)
	db	208
	db	114
	db	99
	db	114
	db	1 dup (0)
	db	216
	db	114
	db	111
	db	108
	db	1 dup (0)
	db	192
	db	114
	db	111
	db	114
	db	1 dup (0)
	db	200
	db	115
	db	97
	db	108
	db	1 dup (0)
	db	224
	db	115
	db	97
	db	114
	db	1 dup (0)
	db	248
_l1_opcode	label	word
	db	97
	db	100
	db	99
	db	2 dup (0)
	db	2
	db	16
	db	128
	db	17
	db	18
	db	131
	db	97
	db	100
	db	100
	db	2 dup (0)
	db	2
	db	0
	db	128
	db	1
	db	2
	db	131
	db	97
	db	110
	db	100
	db	2 dup (0)
	db	2
	db	32
	db	128
	db	33
	db	34
	db	131
	db	99
	db	109
	db	112
	db	2 dup (0)
	db	2
	db	56
	db	128
	db	57
	db	58
	db	131
	db	111
	db	114
	db	3 dup (0)
	db	2
	db	8
	db	128
	db	9
	db	10
	db	131
	db	115
	db	98
	db	98
	db	2 dup (0)
	db	2
	db	24
	db	128
	db	25
	db	26
	db	131
	db	115
	db	117
	db	98
	db	2 dup (0)
	db	2
	db	40
	db	128
	db	41
	db	42
	db	131
	db	120
	db	111
	db	114
	db	2 dup (0)
	db	2
	db	48
	db	128
	db	49
	db	50
	db	131
	db	120
	db	99
	db	104
	db	103
	db	1 dup (0)
	db	2
	db	134
	db	0
	db	135
	db	134
	db	0
	db	100
	db	101
	db	99
	db	2 dup (0)
	db	1
	db	8
	db	254
	db	0
	db	0
	db	0
	db	100
	db	105
	db	118
	db	2 dup (0)
	db	1
	db	48
	db	246
	db	0
	db	0
	db	0
	db	105
	db	100
	db	105
	db	118
	db	1 dup (0)
	db	1
	db	56
	db	246
	db	0
	db	0
	db	0
	db	105
	db	109
	db	117
	db	108
	db	1 dup (0)
	db	1
	db	40
	db	246
	db	0
	db	0
	db	0
	db	109
	db	117
	db	108
	db	2 dup (0)
	db	1
	db	32
	db	246
	db	0
	db	0
	db	0
	db	110
	db	101
	db	103
	db	2 dup (0)
	db	1
	db	24
	db	246
	db	0
	db	0
	db	0
	db	110
	db	111
	db	116
	db	2 dup (0)
	db	1
	db	16
	db	246
	db	0
	db	0
	db	0
	db	105
	db	110
	db	99
	db	2 dup (0)
	db	1
	db	0
	db	254
	db	0
	db	0
	db	0
_i_label	label	word
	db	0
	db	0
   ;	
   ;	void error (char* e)
   ;	
	assume	cs:MGRP
_error	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	puts ("\n\r**error** ("); putn (ligne); puts (") "); puts (e);
   ;	
	push	offset MGRP:s@+150
	call	near ptr MGRP:_puts
	pop	cx
	movsx	eax,word ptr MGRP:_ligne
	push	eax
	call	near ptr MGRP:_putn
	add	sp,4
	push	offset MGRP:s@+164
	call	near ptr MGRP:_puts
	pop	cx
	push	word ptr [bp+4]
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_error	endp
   ;	
   ;	unsigned long s2c_dec (char* st)
   ;	
	assume	cs:MGRP
_s2c_dec	proc	near
	enter	6,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 int base = 10;
   ;	
	mov	di,10
   ;	
   ;	 unsigned long num=0;
   ;	
	mov	dword ptr [bp-4],large 0
   ;	
   ;	 int n;
   ;	 i = 0;
   ;	
	xor	cx,cx
   ;	
   ;	 if (st[0] == '$') { base = 16 ; i++; }
   ;	
	cmp	byte ptr [si],36
	jne	short @26@86
	mov	di,16
	inc	cx
@26@86:
   ;	
   ;	 if (st[0] == '%') { base = 10 ; i++; }
   ;	
	cmp	byte ptr [si],37
	jne	short @26@142
	mov	di,10
	inc	cx
@26@142:
   ;	
   ;	 if (st[0] == '#') { base = 2 ; i++; }
   ;	
	cmp	byte ptr [si],35
	jne	short @26@198
	mov	di,2
	inc	cx
@26@198:
   ;	
   ;	 if (st[0] == '\'') return st[1];
   ;	
	cmp	byte ptr [si],39
	jne	short @26@534
	movsx	eax,byte ptr [si+1]
	jmp	short @26@590
@26@254:
   ;	
   ;	
   ;	 for (; st[i] != 0; i++) {
   ;				       if (base == 10)
   ;	
	cmp	di,10
	jne	short @26@366
   ;	
   ;					if ( (st[i]<48) || (st[i]>(48+9)) )
   ;	
	mov	bx,cx
	cmp	byte ptr [bx+si],48
	jl	short @26@338
	cmp	byte ptr [bx+si],57
	jle	short @26@366
@26@338:
   ;	
   ;					 { error ("invalid number notation"); return 0; }
   ;	
	push	offset MGRP:s@+167
	call	near ptr MGRP:_error
	pop	cx
	xor	eax,eax
	jmp	short @26@590
@26@366:
   ;	
   ;					n = st[i]-48;
   ;	
	mov	bx,cx
	mov	al,byte ptr [bx+si]
	cbw	
	add	ax,-48
	mov	word ptr [bp-6],ax
   ;	
   ;					if ( (base == 16) && (st[i] >= 'a') && ( st[i] <= 'f')) n = st[i]-'a'+10;
   ;	
	cmp	di,16
	jne	short @26@478
	cmp	byte ptr [bx+si],97
	jl	short @26@478
	cmp	byte ptr [bx+si],102
	jg	short @26@478
	mov	al,byte ptr [bx+si]
	cbw	
	add	ax,-87
	mov	word ptr [bp-6],ax
@26@478:
   ;	
   ;	
   ;	
   ;					num = (num * base) + n;
   ;	
	movsx	eax,di
	mov	edx,dword ptr [bp-4]
	imul	edx,eax
	movsx	eax,word ptr [bp-6]
	add	edx,eax
	mov	dword ptr [bp-4],edx
	inc	cx
@26@534:
	mov	bx,cx
	cmp	byte ptr [bx+si],0
	jne	short @26@254
   ;	
   ;				 }
   ;	 return num;
   ;	
	mov	eax,dword ptr [bp-4]
@26@590:
	shld	edx,eax,16
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_s2c_dec	endp
   ;	
   ;	void lower_case (char* str)
   ;	
	assume	cs:MGRP
_lower_case	proc	near
	push	bp
	mov	bp,sp
	mov	cx,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 for (i=0; str[i] != 0; i++)
   ;	
	xor	dx,dx
	jmp	short @27@226
@27@58:
   ;	
   ;	 {
   ;	 if ( str[i] == '\'') i += 2;
   ;	
	mov	bx,cx
	add	bx,dx
	cmp	byte ptr [bx],39
	jne	short @27@114
	add	dx,2
@27@114:
   ;	
   ;	 if ( (str[i] > 64) && (str[i] < 91)) str[i] += 'a' - 'A';
   ;	
	mov	bx,cx
	add	bx,dx
	cmp	byte ptr [bx],64
	jle	short @27@198
	mov	bx,cx
	add	bx,dx
	cmp	byte ptr [bx],91
	jge	short @27@198
	mov	bx,cx
	add	bx,dx
	mov	al,byte ptr [bx]
	add	al,32
	mov	bx,cx
	add	bx,dx
	mov	byte ptr [bx],al
@27@198:
	inc	dx
@27@226:
	mov	bx,cx
	add	bx,dx
	cmp	byte ptr [bx],0
	jne	short @27@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	bp
	ret	
_lower_case	endp
   ;	
   ;	uint get_ofs_label (char* lab)
   ;	
	assume	cs:MGRP
_get_ofs_label	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	 int i;
   ;	 for (i=0; i <= 49 ; i++)
   ;	
	xor	si,si
	jmp	short @28@170
@28@58:
   ;	
   ;	  if ( label [i][0] != 0)
   ;	
	mov	bx,si
	imul	bx,bx,20
	cmp	byte ptr MGRP:_label[bx],0
	je	short @28@142
   ;	
   ;	   if (!strcmp (lab,label[i])) return lab_ofs[i];
   ;	
	mov	ax,si
	imul	ax,ax,20
	add	ax,offset MGRP:_label
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @28@142
	mov	bx,si
	shl	bx,1
	mov	ax,word ptr MGRP:_lab_ofs[bx]
	jmp	short @28@226
@28@142:
	inc	si
@28@170:
	cmp	si,49
	jle	short @28@58
   ;	
   ;	return 0;
   ;	
	xor	ax,ax
@28@226:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_get_ofs_label	endp
   ;	
   ;	int is_label (char* lab)
   ;	
	assume	cs:MGRP
_is_label	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	 int i;
   ;	
   ;	 for (i=0; i <= 30 ; i++)
   ;	
	xor	si,si
	jmp	short @29@170
@29@58:
   ;	
   ;	  if ( label [i][0] != 0)
   ;	
	mov	bx,si
	imul	bx,bx,20
	cmp	byte ptr MGRP:_label[bx],0
	je	short @29@142
   ;	
   ;	    if (!strcmp (lab,label[i])) return 1;
   ;	
	mov	ax,si
	imul	ax,ax,20
	add	ax,offset MGRP:_label
	push	ax
	push	word ptr [bp+4]
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @29@142
	mov	ax,1
	jmp	short @29@226
@29@142:
	inc	si
@29@170:
	cmp	si,30
	jle	short @29@58
   ;	
   ;	return 0;
   ;	
	xor	ax,ax
@29@226:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_is_label	endp
   ;	
   ;	void record_label (char* lab)
   ;	
	assume	cs:MGRP
_record_label	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 if (strlen (lab) > 20) { error ("too much caracters label");return;}
   ;	
	push	di
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,20
	jbe	short @30@86
	push	offset MGRP:s@+191
	jmp	short @30@310
@30@86:
   ;	
   ;	 if (is_label (lab)==1) { error ("label already used"); return; }
   ;	
	push	di
	call	near ptr MGRP:_is_label
	pop	cx
	cmp	ax,1
	jne	short @30@142
	push	offset MGRP:s@+216
	jmp	short @30@310
@30@142:
   ;	
   ;	 for (i=0;i <= 50; i++)
   ;	
	xor	si,si
	jmp	short @30@254
@30@170:
   ;	
   ;	  if ( label[i][0] == 0) { strcpy (label[i],lab);
   ;	
	mov	bx,si
	imul	bx,bx,20
	cmp	byte ptr MGRP:_label[bx],0
	jne	short @30@226
	push	di
	mov	ax,si
	imul	ax,ax,20
	add	ax,offset MGRP:_label
	push	ax
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;				   lab_ofs [i] = ofs;
   ;	
	mov	bx,si
	shl	bx,1
	mov	ax,word ptr MGRP:_ofs
	mov	word ptr MGRP:_lab_ofs[bx],ax
   ;	
   ;				   return ;}
   ;	
	jmp	short @30@338
@30@226:
	inc	si
@30@254:
	cmp	si,50
	jle	short @30@170
   ;	
   ;	 error ("label overflow ( > 50 )");
   ;	
	push	offset MGRP:s@+235
@30@310:
	call	near ptr MGRP:_error
	pop	cx
@30@338:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_record_label	endp
   ;	
   ;	void waiting_label (char* lab, uchar cod)
   ;	
	assume	cs:MGRP
_waiting_label	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;	 int i;
   ;	 for (i=0; i <= 50 ; i++)
   ;	
	xor	si,si
	jmp	short @31@254
@31@58:
   ;	
   ;	  if ( wlabel[i][0] == 0) {
   ;	
	mov	bx,si
	imul	bx,bx,20
	cmp	byte ptr MGRP:_wlabel[bx],0
	jne	short @31@226
   ;	
   ;		for (x=0;x<=19;x++) wlabel[i][x] = 0;
   ;	
	mov	word ptr MGRP:_x,0
	jmp	short @31@170
@31@114:
	mov	bx,si
	imul	bx,bx,20
	add	bx,word ptr MGRP:_x
	mov	byte ptr MGRP:_wlabel[bx],0
	inc	word ptr MGRP:_x
@31@170:
	cmp	word ptr MGRP:_x,19
	jle	short @31@114
   ;	
   ;		strcpy (wlabel[i],lab); wlab_ofs[i] = ofs;
   ;	
	push	word ptr [bp+4]
	mov	ax,si
	imul	ax,ax,20
	add	ax,offset MGRP:_wlabel
	push	ax
	call	near ptr MGRP:_strcpy
	add	sp,4
	mov	bx,si
	shl	bx,1
	mov	ax,word ptr MGRP:_ofs
	mov	word ptr MGRP:_wlab_ofs[bx],ax
   ;	
   ;		wlab_cod [i] = cod;
   ;	
	mov	al,byte ptr [bp+6]
	mov	byte ptr MGRP:_wlab_cod[si],al
   ;	
   ;		return;
   ;	
	jmp	short @31@310
@31@226:
	inc	si
@31@254:
	cmp	si,50
	jle	short @31@58
   ;	
   ;	  }
   ;	 error ("too many label");
   ;	
	push	offset MGRP:s@+259
	call	near ptr MGRP:_error
	pop	cx
@31@310:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_waiting_label	endp
_ac_size	label	word
	db	0
	db	0
   ;	
   ;	int assemble (char*    line)
   ;	
	assume	cs:MGRP
_assemble	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 argc = strlen ( get_argz (line,1) )-1;
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	dec	ax
	mov	word ptr MGRP:_argc,ax
   ;	
   ;	 old_ofs = ofs;
   ;	
	mov	ax,word ptr MGRP:_ofs
	mov	word ptr MGRP:_old_ofs,ax
   ;	
   ;	
   ;	
   ;	  if (!strcmp ((string)get_argz (line,1),".string")) {
   ;	
	push	offset MGRP:s@+274
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@0
	jmp	@32@366
@@0:
   ;	
   ;							     for (x=1;(get_argz(line,2))[x]!='\"';x++)
   ;	
	mov	word ptr MGRP:_x,1
	jmp	short @32@310
@32@86:
   ;	
   ;							      if ((char)(get_argz(line,2)[x] == 0)) binary [ofs++] = 32;
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,word ptr MGRP:_x
	mov	bx,ax
	cmp	byte ptr [bx],0
	jne	short @32@142
	mov	ax,1
	jmp	short @32@170
@32@142:
	xor	ax,ax
@32@170:
	or	al,al
	je	short @32@226
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],32
	jmp	short @32@254
@32@226:
   ;	
   ;							      else binary [ofs++] = (char)(get_argz(line,2)[x]);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,word ptr MGRP:_x
	mov	bx,ax
	mov	al,byte ptr [bx]
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
@32@254:
	inc	word ptr MGRP:_ofs
	inc	word ptr MGRP:_x
@32@310:
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,word ptr MGRP:_x
	mov	bx,ax
	cmp	byte ptr [bx],34
	jne	short @32@86
   ;	
   ;							      old_ofs=!ofs;
   ;	
	mov	ax,word ptr MGRP:_ofs
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr MGRP:_old_ofs,ax
@32@366:
   ;	
   ;							     }
   ;	 get_argz (line,1)[strlen(get_argz (line,1))] = 32;
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	pop	bx
	add	bx,ax
	mov	byte ptr [bx],32
   ;	
   ;	 lower_case (line);
   ;	
	push	di
	call	near ptr MGRP:_lower_case
	pop	cx
   ;	
   ;	
   ;	 if ( get_argz(line,1) [argc] == ':')
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,word ptr MGRP:_argc
	mov	bx,ax
	cmp	byte ptr [bx],58
	je short	@@1
	jmp	@32@674
@@1:
   ;	
   ;	 {
   ;	  old_ofs = !ofs;
   ;	
	mov	ax,word ptr MGRP:_ofs
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr MGRP:_old_ofs,ax
   ;	
   ;	  get_argz(line,1) [argc] = 0;
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	add	ax,word ptr MGRP:_argc
	mov	bx,ax
	mov	byte ptr [bx],0
   ;	
   ;	  record_label (get_argz(line,1));
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_record_label
	pop	cx
   ;	
   ;	  for (argc=0; argc <= 49; argc++)
   ;	
	mov	word ptr MGRP:_argc,0
	jmp	@32@646
@32@422:
   ;	
   ;	   if ( wlabel[argc][0] != 0 )
   ;	
	mov	bx,word ptr MGRP:_argc
	imul	bx,bx,20
	cmp	byte ptr MGRP:_wlabel[bx],0
	jne short	@@2
	jmp	@32@618
@@2:
   ;	
   ;	    if ( !strcmp (wlabel[argc],get_argz(line,1)))
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	mov	ax,word ptr MGRP:_argc
	imul	ax,ax,20
	add	ax,offset MGRP:_wlabel
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@3
	jmp	@32@618
@@3:
   ;	
   ;	    {
   ;	     wlabel [argc][0] = 0;
   ;	
	mov	bx,word ptr MGRP:_argc
	imul	bx,bx,20
	mov	byte ptr MGRP:_wlabel[bx],0
   ;	
   ;	     binary [wlab_ofs[argc]] = wlab_cod[argc];
   ;	
	mov	bx,word ptr MGRP:_argc
	shl	bx,1
	les	ax,dword ptr MGRP:_binary
	add	ax,word ptr MGRP:_wlab_ofs[bx]
	mov	bx,word ptr MGRP:_argc
	mov	dl,byte ptr MGRP:_wlab_cod[bx]
	mov	bx,ax
	mov	byte ptr es:[bx],dl
   ;	
   ;	     if (  (wlab_cod [argc] == 0xE9)
   ;	
   ;	
   ;		 ||(wlab_cod [argc] == 0xE8) )
   ;	
	mov	bx,word ptr MGRP:_argc
	cmp	byte ptr MGRP:_wlab_cod[bx],233
	je	short @32@534
	cmp	byte ptr MGRP:_wlab_cod[bx],232
	jne	short @32@562
@32@534:
   ;	
   ;		   {
   ;		    binary [wlab_ofs[argc]+1] = (char)(( ofs-(wlab_ofs[argc])) & 0x00ff )-3;
   ;	
	mov	bx,word ptr MGRP:_argc
	shl	bx,1
	mov	ax,word ptr MGRP:_wlab_ofs[bx]
	inc	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_argc
	shl	si,1
	mov	al,byte ptr MGRP:_ofs
	sub	al,byte ptr MGRP:_wlab_ofs[si]
	and	al,255
	add	al,253
	mov	byte ptr es:[bx],al
   ;	
   ;		    binary [wlab_ofs[argc]+2] = (char)(( ofs-(wlab_ofs[argc])) >> 8 );
   ;	
	mov	bx,word ptr MGRP:_argc
	shl	bx,1
	mov	ax,word ptr MGRP:_ofs
	sub	ax,word ptr MGRP:_wlab_ofs[bx]
	shr	ax,8
	mov	bx,word ptr MGRP:_argc
	shl	bx,1
	mov	dx,word ptr MGRP:_wlab_ofs[bx]
	add	dx,2
	mov	bx,word ptr MGRP:_binary
	add	bx,dx
	jmp	short @32@590
@32@562:
   ;	
   ;		   }
   ;	    else binary [wlab_ofs[argc]+1] = (char)( ofs-(wlab_ofs[argc]))-2;
   ;	
	mov	bx,word ptr MGRP:_argc
	shl	bx,1
	mov	ax,word ptr MGRP:_wlab_ofs[bx]
	inc	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_argc
	shl	si,1
	mov	al,byte ptr MGRP:_ofs
	sub	al,byte ptr MGRP:_wlab_ofs[si]
	add	al,254
@32@590:
	mov	byte ptr es:[bx],al
@32@618:
	inc	word ptr MGRP:_argc
@32@646:
	cmp	word ptr MGRP:_argc,49
	jg short	@@4
	jmp	@32@422
@@4:
@32@674:
   ;	
   ;	    }
   ;	
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"\n")) old_ofs = !ofs;
   ;	
	push	offset MGRP:s@+282
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@730
	mov	ax,word ptr MGRP:_ofs
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr MGRP:_old_ofs,ax
@32@730:
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"")) old_ofs = !ofs;
   ;	
	push	offset MGRP:s@+284
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@786
	mov	ax,word ptr MGRP:_ofs
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr MGRP:_old_ofs,ax
@32@786:
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"jmp"))
   ;	
	push	offset MGRP:s@+285
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@5
	jmp	@32@982
@@5:
   ;	
   ;	 {
   ;	  if (is_label (get_argz (line,2)))
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	jne short	@@6
	jmp	@32@954
@@6:
   ;	
   ;	   {
   ;	    if ( (ofs-get_ofs_label (get_argz (line,2))) > 255)
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	mov	dx,word ptr MGRP:_ofs
	sub	dx,ax
	cmp	dx,255
	jbe	short @32@926
   ;	
   ;	    {
   ;	     binary [ofs++] = 0xE9;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],233
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = (char)((get_ofs_label (get_argz (line,2))-ofs-2) & 0x00ff);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	al,byte ptr MGRP:_ofs
	add	al,254
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = (char)((get_ofs_label (get_argz (line,2))-ofs-3) >> 8);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	ax,word ptr MGRP:_ofs
	sub	ax,3
	shr	ax,8
@32@898:
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	    }
   ;	
	jmp	short @32@982
@32@926:
   ;	
   ;	    else
   ;	    {
   ;	     binary [ofs++] = 0xEB;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],235
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = ((char)(get_ofs_label (get_argz (line,2))-ofs)-1);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	al,byte ptr MGRP:_ofs
	add	al,255
	jmp	short @32@898
@32@954:
   ;	
   ;	    }
   ;	   }
   ;	  else { waiting_label (get_argz(line,2),0xE9); ofs += 3;}
   ;	
	push	233
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_waiting_label
	add	sp,4
	add	word ptr MGRP:_ofs,3
@32@982:
   ;	
   ;	 }
   ;	
   ;	  if ( (get_argz (line,1)[0] == 'j') || (get_argz (line,1)[0] == 'l'))
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],106
	je	short @32@1038
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],108
	je short	@@7
	jmp	@32@1234
@@7:
@32@1038:
   ;	
   ;	  {
   ;	   for (x=0;x<jcc_n;x++)
   ;	
	mov	word ptr MGRP:_x,0
	jmp	@32@1206
@32@1066:
   ;	
   ;	    if (!strcmp (jcc[x],get_argz(line,1)))
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	mov	bx,word ptr MGRP:_x
	shl	bx,1
	push	word ptr MGRP:_jcc[bx]
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1178
   ;	
   ;	    {
   ;	     if (is_label (get_argz (line,2)))
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	je	short @32@1150
   ;	
   ;	     {
   ;	      binary [ofs++] = jcc_code [x];
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_x
	mov	al,byte ptr MGRP:_jcc_code[si]
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	      binary [ofs++] = (char)((get_ofs_label (get_argz (line,2))-ofs-1));
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	al,byte ptr MGRP:_ofs
	add	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	     }
   ;	
	jmp	short @32@1178
@32@1150:
   ;	
   ;	     else { waiting_label (get_argz(line,2),jcc_code[x]); ofs += 2;}
   ;	
	mov	bx,word ptr MGRP:_x
	mov	al,byte ptr MGRP:_jcc_code[bx]
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_waiting_label
	add	sp,4
	add	word ptr MGRP:_ofs,2
@32@1178:
	inc	word ptr MGRP:_x
@32@1206:
	cmp	word ptr MGRP:_x,36
	jge short	@@8
	jmp	@32@1066
@@8:
@32@1234:
   ;	
   ;	    }
   ;	  }
   ;	
   ;	  if (!strcmp ((string)get_argz (line,1),"call"))
   ;	
	push	offset MGRP:s@+289
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@9
	jmp	@32@1346
@@9:
   ;	
   ;	 {
   ;	  if (is_label (get_argz (line,2)))
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	je	short @32@1318
   ;	
   ;	   {
   ;	     binary [ofs++] = 0xE8;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],232
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = (char)((get_ofs_label (get_argz (line,2))-ofs-2) & 0x00ff);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	al,byte ptr MGRP:_ofs
	add	al,254
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = (char)((get_ofs_label (get_argz (line,2))-ofs-3) >> 8);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	sub	ax,word ptr MGRP:_ofs
	sub	ax,3
	shr	ax,8
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	   }
   ;	
	jmp	short @32@1346
@32@1318:
   ;	
   ;	  else { waiting_label (get_argz(line,2),0xE8); ofs += 3;}
   ;	
	push	232
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_waiting_label
	add	sp,4
	add	word ptr MGRP:_ofs,3
@32@1346:
   ;	
   ;	 }
   ;	
   ;	 for (xx=0;xx<=once_opcode_n;xx++)
   ;	
	mov	word ptr MGRP:_xx,0
	jmp	short @32@1486
@32@1374:
   ;	
   ;	 {
   ;	  if (  (!strcmp ((string)get_argz (line,1),once_opcode[xx].name))
   ;	
   ;	
   ;	      ||(!strcmp ((string)get_argz (line,2),once_opcode[xx].name)) )
   ;	
	mov	ax,word ptr MGRP:_xx
	imul	ax,ax,7
	add	ax,offset MGRP:_once_opcode
	push	ax
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je	short @32@1430
	mov	ax,word ptr MGRP:_xx
	imul	ax,ax,7
	add	ax,offset MGRP:_once_opcode
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1458
@32@1430:
   ;	
   ;	  binary [ofs++] = once_opcode[xx].code;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,7
	mov	al,byte ptr MGRP:_once_opcode[si+6]
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@1458:
	inc	word ptr MGRP:_xx
@32@1486:
	cmp	word ptr MGRP:_xx,39
	jle	short @32@1374
   ;	
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"aad")) { binary [ofs++] = 0xD5; binary [ofs++] = 0x0A; }
   ;	
	push	offset MGRP:s@+294
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1570
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],213
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],10
	inc	word ptr MGRP:_ofs
@32@1570:
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"aam")) { binary [ofs++] = 0xD4; binary [ofs++] = 0x0A; }
   ;	
	push	offset MGRP:s@+298
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1626
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],212
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],10
	inc	word ptr MGRP:_ofs
@32@1626:
   ;	
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"pop"))
   ;	
	push	offset MGRP:s@+302
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@10
	jmp	@32@2074
@@10:
   ;	
   ;	 {
   ;	
   ;	  for (gi=0;gi<=3;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@1766
@32@1682:
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz (line,2),sreg[gi])) binary [ofs++] = 0x07 + (gi*8);
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,2
	add	ax,offset MGRP:_sreg
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1738
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_gi
	shl	al,3
	add	al,7
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@1738:
	inc	word ptr MGRP:_gi
@32@1766:
	cmp	word ptr MGRP:_gi,3
	jle	short @32@1682
   ;	
   ;	  }
   ;	
   ;	  if (ofs==old_ofs) binary [ofs++] = 0x8f;
   ;	
	mov	ax,word ptr MGRP:_ofs
	cmp	ax,word ptr MGRP:_old_ofs
	jne	short @32@1850
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],143
	inc	word ptr MGRP:_ofs
@32@1850:
   ;	
   ;	
   ;	  for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@1962
@32@1878:
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz(line,2),reg16[gi])) binary [ofs++] = 0xC0 + gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg16
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@1934
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_gi
	add	al,192
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@1934:
	inc	word ptr MGRP:_gi
@32@1962:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@1878
   ;	
   ;	  }
   ;	
   ;	  if (binary [ofs-1] == 0x8f) { error ("incorrect 'pop' usage"); return 1;}
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],143
	jne	short @32@2074
	push	offset MGRP:s@+306
@32@2046:
	call	near ptr MGRP:_error
	pop	cx
	mov	ax,1
	jmp	@32@9914
@32@2074:
   ;	
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"push"))
   ;	
	push	offset MGRP:s@+328
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@11
	jmp	@32@2494
@@11:
   ;	
   ;	 {
   ;	  for (gi=0;gi<=3;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@2214
@32@2130:
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz (line,2),sreg[gi])) binary [ofs++] = 0x06 + (gi*8);
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,2
	add	ax,offset MGRP:_sreg
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2186
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_gi
	shl	al,3
	add	al,6
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@2186:
	inc	word ptr MGRP:_gi
@32@2214:
	cmp	word ptr MGRP:_gi,3
	jle	short @32@2130
   ;	
   ;	  }
   ;	
   ;	  if (ofs==old_ofs) binary [ofs++] = 0xff;
   ;	
	mov	ax,word ptr MGRP:_ofs
	cmp	ax,word ptr MGRP:_old_ofs
	jne	short @32@2298
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],255
	inc	word ptr MGRP:_ofs
@32@2298:
   ;	
   ;	
   ;	  for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@2410
@32@2326:
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz (line,2),reg16[gi])) binary [ofs++] = 0xF0 + gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg16
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2382
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_gi
	add	al,240
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@2382:
	inc	word ptr MGRP:_gi
@32@2410:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@2326
   ;	
   ;	  }
   ;	
   ;	  if (binary [ofs-1] == 0xff) { error ("incorrect 'push' usage"); return 1;}
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],255
	jne	short @32@2494
	push	offset MGRP:s@+333
	jmp	@32@2046
@32@2494:
   ;	
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"out"))
   ;	
	push	offset MGRP:s@+356
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@12
	jmp	@32@2914
@@12:
   ;	
   ;	 {
   ;	  if (!strcmp ((string)get_argz(line,3),reg8[0]))
   ;	
	push	offset MGRP:_reg8
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2718
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz(line,2),reg16[2])) binary [ofs++] = 0xEE;
   ;	
	push	offset MGRP:_reg16+16
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2606
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],238
	jmp	short @32@2690
@32@2606:
   ;	
   ;	    else {
   ;		  binary [ofs++] =0xE6;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],230
	inc	word ptr MGRP:_ofs
   ;	
   ;		  if (s2c_dec(get_argz(line,2)) > 255) {error ("must 8-bits value"); return 1;}
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@2662
	push	offset MGRP:s@+360
	jmp	@32@2046
@32@2662:
   ;	
   ;		  binary [ofs++] = (uchar)s2c_dec(get_argz(line,2));
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
@32@2690:
	inc	word ptr MGRP:_ofs
@32@2718:
   ;	
   ;		 }
   ;	  }
   ;	  if (!strcmp ((string)get_argz(line,3),reg16[0]))
   ;	
	push	offset MGRP:_reg16
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2914
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz(line,2),reg16[2])) binary [ofs++] = 0xEF;
   ;	
	push	offset MGRP:_reg16+16
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@2802
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],239
	jmp	short @32@2886
@32@2802:
   ;	
   ;	    else  {
   ;		   binary [ofs++] =0xE7;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],231
	inc	word ptr MGRP:_ofs
   ;	
   ;		   if (s2c_dec(get_argz(line,2)) > 255) {error ("must 8-bits value"); return 1;}
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@2858
	push	offset MGRP:s@+378
	jmp	@32@2046
@32@2858:
   ;	
   ;		   binary [ofs++] = (uchar)(s2c_dec(get_argz(line,2)));
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
@32@2886:
	inc	word ptr MGRP:_ofs
@32@2914:
   ;	
   ;		  }
   ;	  }
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"in"))
   ;	
	push	offset MGRP:s@+396
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@13
	jmp	@32@3334
@@13:
   ;	
   ;	 {
   ;	  if (!strcmp ((string)get_argz(line,2),reg8[0]))
   ;	
	push	offset MGRP:_reg8
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3138
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz(line,3),reg16[2])) binary [ofs++] = 0xEC;
   ;	
	push	offset MGRP:_reg16+16
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3026
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],236
	jmp	short @32@3110
@32@3026:
   ;	
   ;	    else {
   ;		  binary [ofs++] =0xE4;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],228
	inc	word ptr MGRP:_ofs
   ;	
   ;		  if (s2c_dec(get_argz(line,3)) > 255) {error ("must 8-bits value"); return 1;}
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@3082
	push	offset MGRP:s@+399
	jmp	@32@2046
@32@3082:
   ;	
   ;		  binary [ofs++] = (uchar)s2c_dec(get_argz(line,3));
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
@32@3110:
	inc	word ptr MGRP:_ofs
@32@3138:
   ;	
   ;		 }
   ;	  }
   ;	  if (!strcmp ((string)get_argz(line,2),reg16[0]))
   ;	
	push	offset MGRP:_reg16
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3334
   ;	
   ;	  {
   ;	   if (!strcmp ((string)get_argz(line,3),reg16[2])) binary [ofs++] = 0xED;
   ;	
	push	offset MGRP:_reg16+16
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3222
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],237
	jmp	short @32@3306
@32@3222:
   ;	
   ;	    else  {
   ;		   binary [ofs++] =0xE5;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],229
	inc	word ptr MGRP:_ofs
   ;	
   ;		   if (s2c_dec(get_argz(line,3)) > 255) {error ("must 8-bits value"); return 1;}
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@3278
	push	offset MGRP:s@+417
	jmp	@32@2046
@32@3278:
   ;	
   ;		   binary [ofs++] = (uchar)(s2c_dec(get_argz(line,3)));
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
@32@3306:
	inc	word ptr MGRP:_ofs
@32@3334:
   ;	
   ;		  }
   ;	  }
   ;	 }
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),".org")) {
   ;	
	push	offset MGRP:s@+435
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3390
   ;	
   ;							  ofs = s2c_dec (get_argz (line,2)) ;
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	mov	word ptr MGRP:_ofs,ax
@32@3390:
   ;	
   ;							 }
   ;	 if (!strcmp ((string)get_argz (line,1),".byte")) binary [ofs++] = (uchar)s2c_dec (get_argz (line,2)) ;
   ;	
	push	offset MGRP:s@+440
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3446
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@3446:
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),".word")) {
   ;	
	push	offset MGRP:s@+446
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3502
   ;	
   ;								binary [ofs++] = (uchar) (s2c_dec ((get_argz (line,2))) & 0x00ff);
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;								binary [ofs++] = (uchar) (s2c_dec ((get_argz (line,2))) >> 8) ;
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	shr	eax,8
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@3502:
   ;	
   ;							  }
   ;	 if (!strcmp ((string)get_argz (line,1),".array")) {
   ;	
	push	offset MGRP:s@+452
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3642
   ;	
   ;							     x = s2c_dec (get_argz(line,2));
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	mov	word ptr MGRP:_x,ax
   ;	
   ;							     ac_ea = s2c_dec (get_argz(line,3));
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	mov	word ptr MGRP:_ac_ea,ax
	jmp	short @32@3614
@32@3558:
   ;	
   ;							     for (;x!=0;x--) binary[ofs++] = ac_ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
	dec	word ptr MGRP:_x
@32@3614:
	cmp	word ptr MGRP:_x,0
	jne	short @32@3558
@32@3642:
   ;	
   ;							  }
   ;	
   ;	
   ;	 if ( get_argz (line,1)[0] == ';') old_ofs = !ofs;
   ;	
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],59
	jne	short @32@3698
	mov	ax,word ptr MGRP:_ofs
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr MGRP:_old_ofs,ax
@32@3698:
   ;	
   ;	
   ;	 if (!strcmp ((string)get_argz (line,1),"int"))
   ;	
	push	offset MGRP:s@+459
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3754
   ;	
   ;	 {
   ;	  binary [ofs++] = 0xCD;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],205
	inc	word ptr MGRP:_ofs
   ;	
   ;	  binary [ofs++] = (uchar)s2c_dec (get_argz (line,2)) ;
   ;	
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@3754:
   ;	
   ;	 }
   ;	
   ;	
   ;	 for (xx=0;xx<=bin_n;xx++)
   ;	
	mov	word ptr MGRP:_xx,0
	jmp	@32@4622
@32@3782:
   ;	
   ;	 {
   ;	  if (!strcmp ((string)get_argz (line,1),bin_opcode[xx].name))
   ;	
	mov	ax,word ptr MGRP:_xx
	imul	ax,ax,5
	add	ax,offset MGRP:_bin_opcode
	push	ax
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@14
	jmp	@32@4594
@@14:
   ;	
   ;	  {
   ;	   ea = 8; op_size = 8;
   ;	
	mov	byte ptr MGRP:_ea,8
	mov	word ptr MGRP:_op_size,8
   ;	
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@3922
@32@3838:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,2),reg8[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg8
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@3894
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@3894:
	inc	word ptr MGRP:_gi
@32@3922:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@3838
   ;	
   ;	   }
   ;	   if (ea==8) op_size =16;
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@4006
	mov	word ptr MGRP:_op_size,16
@32@4006:
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@4118
@32@4034:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,2),reg16[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg16
	push	ax
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@4090
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@4090:
	inc	word ptr MGRP:_gi
@32@4118:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@4034
   ;	
   ;	   }
   ;	
   ;	   if (ea==8) { error ("incorrect right operand"); return 1;}
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@4202
	push	offset MGRP:s@+463
	jmp	@32@2046
@32@4202:
   ;	
   ;	   if (!strcmp ((string)get_argz (line,3),"cl"))
   ;	
	push	offset MGRP:s@+487
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@4370
   ;	
   ;	   {
   ;	    if (op_size==8) binary [ofs++] = 0xD2;
   ;	
	cmp	word ptr MGRP:_op_size,8
	jne	short @32@4286
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],210
	jmp	short @32@4314
@32@4286:
   ;	
   ;	    else binary [ofs++] = 0xD3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],211
@32@4314:
	inc	word ptr MGRP:_ofs
   ;	
   ;	    binary [ofs++] = bin_opcode[xx].code + ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,5
	mov	al,byte ptr MGRP:_bin_opcode[si+4]
	add	al,byte ptr MGRP:_ea
	jmp	@32@4566
@32@4370:
   ;	
   ;	   }
   ;	   else
   ;	   {
   ;	     if (s2c_dec (get_argz(line,3)) > 255)
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@4426
   ;	
   ;	     { error ("must be 8-bit value"); return 1; }
   ;	
	push	offset MGRP:s@+490
	jmp	@32@2046
@32@4426:
   ;	
   ;	    if (op_size==8) binary [ofs++] = 0xC0;
   ;	
	cmp	word ptr MGRP:_op_size,8
	jne	short @32@4482
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],192
	inc	word ptr MGRP:_ofs
@32@4482:
   ;	
   ;	    if (op_size==16) binary [ofs++] = 0xC1;
   ;	
	cmp	word ptr MGRP:_op_size,16
	jne	short @32@4538
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],193
	inc	word ptr MGRP:_ofs
@32@4538:
   ;	
   ;	    binary [ofs++] = bin_opcode [xx].code + ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,5
	mov	al,byte ptr MGRP:_bin_opcode[si+4]
	add	al,byte ptr MGRP:_ea
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	    binary [ofs++] = s2c_dec (get_argz(line,3));
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
@32@4566:
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@4594:
	inc	word ptr MGRP:_xx
@32@4622:
	cmp	word ptr MGRP:_xx,7
	jg short	@@15
	jmp	@32@3782
@@15:
   ;	
   ;	   }
   ;	  }
   ;	 }
   ;	
   ;	 for (xx=0;xx<=l1_n;xx++)
   ;	
	mov	word ptr MGRP:_xx,0
	jmp	@32@9802
@32@4678:
   ;	
   ;	{
   ;	 if (   (!strcmp ((string)get_argz (line,1),"mov"))
   ;	
   ;	
   ;	     || (!strcmp ((string)get_argz (line,1),l1_opcode[xx].name)) )
   ;	
	push	offset MGRP:s@+510
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je	short @32@4734
	mov	ax,word ptr MGRP:_xx
	imul	ax,ax,11
	add	ax,offset MGRP:_l1_opcode
	push	ax
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@16
	jmp	@32@9774
@@16:
@32@4734:
   ;	
   ;	  {
   ;	   op = 0;
   ;	
	mov	byte ptr MGRP:_op,0
   ;	
   ;	
   ;	   if (strcmp ((string)get_argz (line,1),"mov")) op = 1;
   ;	
	push	offset MGRP:s@+514
	push	1
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	or	al,al
	je	short @32@4790
	mov	byte ptr MGRP:_op,1
@32@4790:
   ;	
   ;	
   ;	   binary [ofs] = 0xb0; op_size = 8; ea = 8 ; argc = 2;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],176
	mov	word ptr MGRP:_op_size,8
	mov	byte ptr MGRP:_ea,8
	mov	word ptr MGRP:_argc,2
   ;	
   ;	
   ;	   if (!strcmp ((string)get_argz (line,2),"byte"))
   ;	
	push	offset MGRP:s@+518
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@17
	jmp	@32@5350
@@17:
   ;	
   ;	    {
   ;	     if (strcmp ((string)get_argz (line,3),"ptr")) { error ("missing 'ptr'"); return 1;}
   ;	
	push	offset MGRP:s@+523
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	or	al,al
	je	short @32@4874
	push	offset MGRP:s@+527
	jmp	@32@2046
@32@4874:
   ;	
   ;	     binary [ofs++] = 0xC6; argc = 3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],198
	inc	word ptr MGRP:_ofs
	mov	word ptr MGRP:_argc,3
   ;	
   ;	
   ;	     if (op) {
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@4930
   ;	
   ;		       binary [ofs-1] = l1_opcode[xx].op1;
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	mov	byte ptr es:[bx],al
   ;	
   ;		       actual_code = l1_opcode[xx].actual_code;
   ;	
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	mov	al,byte ptr MGRP:_l1_opcode[bx+6]
	mov	byte ptr MGRP:_actual_code,al
   ;	
   ;		     }
   ;	
	jmp	short @32@4958
@32@4930:
   ;	
   ;	     else actual_code = 0;
   ;	
	mov	byte ptr MGRP:_actual_code,0
@32@4958:
   ;	
   ;	
   ;	     if      (!strcmp ((string)get_argz (line,4),ofs_bx)) binary [ofs++] = 7 + actual_code;
   ;	
	push	offset MGRP:_ofs_bx
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5042
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,7
@32@5014:
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
	jmp	@32@5238
@32@5042:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,4),ofs_si)) binary [ofs++] = 4 + actual_code;
   ;	
	push	offset MGRP:_ofs_si
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5098
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,4
	jmp	short @32@5014
@32@5098:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,4),ofs_di)) binary [ofs++] = 5 + actual_code;
   ;	
	push	offset MGRP:_ofs_di
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5154
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,5
	jmp	short @32@5014
@32@5154:
   ;	
   ;	     else if (is_label (get_argz (line,4)) != 0)
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	je	short @32@5210
   ;	
   ;		    {
   ;		     binary [ofs++] = 6 + actual_code;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,6
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) & 0x00ff;
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) >> 8;
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	shr	ax,8
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	jmp	@32@5014
@32@5210:
   ;	
   ;		    }
   ;	     else { error ("incorrect effective address"); return 1 ; }
   ;	
	push	offset MGRP:s@+541
	jmp	@32@2046
@32@5238:
   ;	
   ;	     if ( (op) && (l1_opcode[xx].noperand == 1)) ;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@5294
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	cmp	byte ptr MGRP:_l1_opcode[bx+5],1
	jne short	@@18
	jmp	@32@9886
@@18:
@32@5294:
   ;	
   ;	     else binary [ofs++] = (uchar)s2c_dec (get_argz (line,5)) ;
   ;	
	push	5
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
	jmp	@32@9886
   ;	
   ;	     return 0;
   ;	
	jmp	@32@9886
@32@5350:
   ;	
   ;	    }
   ;	
   ;	    if (!strcmp ((string)get_argz (line,2),"word"))
   ;	
	push	offset MGRP:s@+569
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@19
	jmp	@32@5910
@@19:
   ;	
   ;	    {
   ;	     if (strcmp ((string)get_argz (line,3),"ptr")) { error ("missing 'ptr'"); return 1;}
   ;	
	push	offset MGRP:s@+574
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	or	al,al
	je	short @32@5434
	push	offset MGRP:s@+578
	jmp	@32@2046
@32@5434:
   ;	
   ;	     binary [ofs++] = 0xC7; argc = 3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],199
	inc	word ptr MGRP:_ofs
	mov	word ptr MGRP:_argc,3
   ;	
   ;	     if (op) {
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@5490
   ;	
   ;			binary [ofs-1] = l1_opcode[xx].op1+1;
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	inc	al
	mov	byte ptr es:[bx],al
   ;	
   ;			actual_code = l1_opcode[xx].actual_code;
   ;	
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	mov	al,byte ptr MGRP:_l1_opcode[bx+6]
	mov	byte ptr MGRP:_actual_code,al
   ;	
   ;		     }
   ;	
	jmp	short @32@5518
@32@5490:
   ;	
   ;	     else actual_code = 0;
   ;	
	mov	byte ptr MGRP:_actual_code,0
@32@5518:
   ;	
   ;	
   ;	     if      (!strcmp ((string)get_argz (line,4),ofs_bx)) binary [ofs++] = 7 + actual_code;
   ;	
	push	offset MGRP:_ofs_bx
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5602
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,7
@32@5574:
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
	jmp	@32@5798
@32@5602:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,4),ofs_si)) binary [ofs++] = 4 + actual_code;
   ;	
	push	offset MGRP:_ofs_si
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5658
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,4
	jmp	short @32@5574
@32@5658:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,4),ofs_di)) binary [ofs++] = 5 + actual_code;
   ;	
	push	offset MGRP:_ofs_di
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5714
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,5
	jmp	short @32@5574
@32@5714:
   ;	
   ;	     else if (is_label (get_argz (line,4)) != 0)
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	je	short @32@5770
   ;	
   ;		    {
   ;		     binary [ofs++] = 6 + actual_code;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_actual_code
	add	al,6
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) & 0x00ff;
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) >> 8;
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	shr	ax,8
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	jmp	@32@5574
@32@5770:
   ;	
   ;		    }
   ;	     else { error ("incorrect effective address"); return 1 ; }
   ;	
	push	offset MGRP:s@+592
	jmp	@32@2046
@32@5798:
   ;	
   ;	     if ( (op) && (l1_opcode[xx].noperand == 1)) ;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@5854
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	cmp	byte ptr MGRP:_l1_opcode[bx+5],1
	jne short	@@20
	jmp	@32@9886
@@20:
@32@5854:
   ;	
   ;	     else {
   ;		    binary [ofs++] = (uchar) (s2c_dec (get_argz (line,5)) & 0x00ff);
   ;	
	push	5
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		    binary [ofs++] = (uchar) (s2c_dec (get_argz (line,5)) >> 8);
   ;	
	push	5
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	shr	eax,8
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
	jmp	@32@9886
   ;	
   ;		  }
   ;	     return 0;
   ;	
	jmp	@32@9886
@32@5910:
   ;	
   ;	    }
   ;	
   ;	   if (!strcmp ((string)get_argz (line,2),ofs_bx))
   ;	
	push	offset MGRP:_ofs_bx
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@5994
   ;	
   ;	   {
   ;	    binary[ofs++] = 0x89; binary [ofs] = 7; argc =3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],137
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],7
	mov	word ptr MGRP:_argc,3
   ;	
   ;	    if (op) binary [ofs-1] = l1_opcode[xx].op2;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@5994
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+8]
	mov	byte ptr es:[bx],al
@32@5994:
   ;	
   ;	   }
   ;	   if (!strcmp ((string)get_argz (line,2),ofs_si))
   ;	
	push	offset MGRP:_ofs_si
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6078
   ;	
   ;	   {
   ;	    binary[ofs++] = 0x89; binary [ofs] = 4; argc =3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],137
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],4
	mov	word ptr MGRP:_argc,3
   ;	
   ;	    if (op) binary [ofs-1] = l1_opcode[xx].op2;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@6078
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+8]
	mov	byte ptr es:[bx],al
@32@6078:
   ;	
   ;	   }
   ;	   if (!strcmp ((string)get_argz (line,2),ofs_di))
   ;	
	push	offset MGRP:_ofs_di
	push	2
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6162
   ;	
   ;	   {
   ;	    binary[ofs++] = 0x89; binary [ofs] = 5; argc =3;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],137
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],5
	mov	word ptr MGRP:_argc,3
   ;	
   ;	    if (op) binary [ofs-1] = l1_opcode[xx].op2;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@6162
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+8]
	mov	byte ptr es:[bx],al
@32@6162:
   ;	
   ;	   }
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@6274
@32@6190:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,argc),reg8[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg8
	push	ax
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6246
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@6246:
	inc	word ptr MGRP:_gi
@32@6274:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@6190
   ;	
   ;	   }
   ;	
   ;	   if (binary[ofs-1] != 0x89)
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],137
	je	short @32@6414
   ;	
   ;	    if (binary[ofs-1] != 0x39)
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],57
	je	short @32@6414
   ;	
   ;	     if (ea == 8 ) { binary [ofs] = 0xb8; op_size = 16; }
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@6414
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],184
	mov	word ptr MGRP:_op_size,16
@32@6414:
   ;	
   ;	   if (ea==8) op_size = 16;
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@6470
	mov	word ptr MGRP:_op_size,16
@32@6470:
   ;	
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@6582
@32@6498:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,argc),reg16[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg16
	push	ax
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6554
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@6554:
	inc	word ptr MGRP:_gi
@32@6582:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@6498
   ;	
   ;	   }
   ;	
   ;	   if (!strcmp ((string)get_argz (line,argc),"ds")) { ea = !ea;binary[ofs++] = 0x8E; binary [ofs] = 0xD8;}
   ;	
	push	offset MGRP:s@+620
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6666
	mov	al,byte ptr MGRP:_ea
	mov	ah,0
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	byte ptr MGRP:_ea,al
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],142
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],216
@32@6666:
   ;	
   ;	   if (!strcmp ((string)get_argz (line,argc),"es")) { ea = !ea;binary[ofs++] = 0x8E; binary [ofs] = 0xC0;}
   ;	
	push	offset MGRP:s@+623
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@6722
	mov	al,byte ptr MGRP:_ea
	mov	ah,0
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	byte ptr MGRP:_ea,al
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],142
	inc	word ptr MGRP:_ofs
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],192
@32@6722:
   ;	
   ;	   ac_ea = ea;
   ;	
	mov	al,byte ptr MGRP:_ea
	mov	ah,0
	mov	word ptr MGRP:_ac_ea,ax
   ;	
   ;	
   ;	   if (ea == 8) { error ("incorrect left-operand."); return 1; }
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@6778
	push	offset MGRP:s@+626
	jmp	@32@2046
@32@6778:
   ;	
   ;	
   ;	   if (binary[ofs-1] == 0x89) { if (op_size==8) binary [ofs-1]--;binary [ofs++] += (ea*8); return 0;}
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],137
	jne	short @32@6890
	cmp	word ptr MGRP:_op_size,8
	jne	short @32@6862
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	dec	byte ptr es:[bx]
@32@6862:
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr es:[bx]
	mov	dl,byte ptr MGRP:_ea
	shl	dl,3
	add	al,dl
	jmp	@32@8234
@32@6890:
   ;	
   ;	   if (binary[ofs-1] == 0x39) { if (op_size==8) binary [ofs-1]--;binary [ofs++] += (ea*8); return 0;}
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],57
	jne	short @32@7002
	cmp	word ptr MGRP:_op_size,8
	jne	short @32@6862
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	dec	byte ptr es:[bx]
	jmp	short @32@6862
	jmp	short @32@6862
@32@7002:
   ;	
   ;	   argc = 3;
   ;	
	mov	word ptr MGRP:_argc,3
   ;	
   ;	   ac_size = op_size; ea = 8;
   ;	
	mov	ax,word ptr MGRP:_op_size
	mov	word ptr MGRP:_ac_size,ax
	mov	byte ptr MGRP:_ea,8
   ;	
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@7114
@32@7030:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,argc),reg8[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg8
	push	ax
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@7086
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@7086:
	inc	word ptr MGRP:_gi
@32@7114:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@7030
   ;	
   ;	   }
   ;	
   ;	   if (ea == 8 ) op_size = 16;
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne	short @32@7198
	mov	word ptr MGRP:_op_size,16
@32@7198:
   ;	
   ;	
   ;	   for (gi=0;gi<=7;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@7310
@32@7226:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,argc),reg16[gi])) ea = gi;
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,3
	add	ax,offset MGRP:_reg16
	push	ax
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@7282
	mov	al,byte ptr MGRP:_gi
	mov	byte ptr MGRP:_ea,al
@32@7282:
	inc	word ptr MGRP:_gi
@32@7310:
	cmp	word ptr MGRP:_gi,7
	jle	short @32@7226
   ;	
   ;	   }
   ;	
   ;	   for (gi=0;gi<=3;gi++)
   ;	
	mov	word ptr MGRP:_gi,0
	jmp	short @32@7450
@32@7366:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)get_argz (line,argc),sreg[gi]))
   ;	
	mov	ax,word ptr MGRP:_gi
	shl	ax,2
	add	ax,offset MGRP:_sreg
	push	ax
	push	word ptr MGRP:_argc
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@7422
   ;	
   ;	    {
   ;	     binary [ofs++] = 0x8c;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],140
	inc	word ptr MGRP:_ofs
   ;	
   ;	     binary [ofs++] = ac_ea + (0xC0 + (8*gi));
   ;	
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_gi
	shl	al,3
	add	al,byte ptr MGRP:_ac_ea
	add	al,192
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	     if (argc == 3) return 0;
   ;	
	cmp	word ptr MGRP:_argc,3
	jne short	@@21
	jmp	@32@9886
@@21:
@32@7422:
	inc	word ptr MGRP:_gi
@32@7450:
	cmp	word ptr MGRP:_gi,3
	jle	short @32@7366
   ;	
   ;	    }
   ;	   }
   ;	
   ;	   if (binary[ofs-1] == 0x8E) { binary [ofs++] += ea; return 0;};
   ;	
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	cmp	byte ptr es:[bx],142
	jne	short @32@7534
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ea
	add	byte ptr es:[bx],al
	jmp	@32@8290
@32@7534:
   ;	
   ;	
   ;	   if ( (op) && (l1_opcode[xx].noperand ==1) )
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@7730
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	cmp	byte ptr MGRP:_l1_opcode[bx+5],1
	jne	short @32@7730
   ;	
   ;	   {
   ;	    if (ac_size==8) binary[ofs++] = l1_opcode[xx].op1;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@7646
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@7646:
   ;	
   ;	    if (ac_size==16) binary[ofs++] = l1_opcode[xx].op1+1;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@7702
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	inc	al
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@7702:
   ;	
   ;	    binary[ofs++] = 0xc0+l1_opcode[xx].actual_code+ac_ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+6]
	add	al,byte ptr MGRP:_ac_ea
	jmp	@32@8766
@32@7730:
   ;	
   ;	    return 0;
   ;	   }
   ;	
   ;	   if (   ( (get_argz (line,3) [0] > 47) && (get_argz (line,3) [0] < (48+10)) )
   ;	
   ;	
   ;	       || (get_argz (line,3) [0] == '\'')
   ;	       || (get_argz (line,3) [0] == '$')
   ;	       || (get_argz (line,3) [0] == '%')
   ;	       || (get_argz (line,3) [0] == '#') )
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],47
	jle	short @32@7786
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],58
	jl	short @32@7898
@32@7786:
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],39
	je	short @32@7898
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],36
	je	short @32@7898
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],37
	je	short @32@7898
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],35
	je short	@@22
	jmp	@32@8318
@@22:
@32@7898:
   ;	
   ;	    {
   ;	     binary [ofs++] += ac_ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr es:[bx]
	add	al,byte ptr MGRP:_ac_ea
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;	     if ((op) && (ac_size ==8)) {binary [ofs-1] = l1_opcode[xx].op1; binary [ofs++] = l1_opcode[xx].actual_code+0xc0 + ac_ea; }
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@7982
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@7982
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	mov	bx,word ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	mov	byte ptr es:[bx],al
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+6]
	add	al,byte ptr MGRP:_ac_ea
	add	al,192
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@7982:
   ;	
   ;	     if ((op) && (ac_size ==16)) {binary [ofs-1] = l1_opcode[xx].op1+1; binary [ofs++] = l1_opcode[xx].actual_code+0xc0 + ac_ea;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@8066
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@8066
	mov	ax,word ptr MGRP:_ofs
	dec	ax
	les	bx,dword ptr MGRP:_binary
	add	bx,ax
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+7]
	inc	al
	mov	byte ptr es:[bx],al
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+6]
	add	al,byte ptr MGRP:_ac_ea
	add	al,192
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@8066:
   ;	
   ;	
   ;	
   ;	     if ( ac_size == 8 )
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@8178
   ;	
   ;	      if (s2c_dec (get_argz(line,3)) > 255) { error ("must be 8-bits value"); return 1;}
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	cmp	eax,large 255
	jbe	short @32@8150
	push	offset MGRP:s@+650
	jmp	@32@2046
@32@8150:
   ;	
   ;	      else binary [ofs++] = (uchar)s2c_dec (get_argz (line,3)) ;
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@8178:
   ;	
   ;	     if ( ac_size == 16) { binary [ofs++] = (uchar) (s2c_dec (get_argz (line,3)) & 0x00ff);
   ;	
	cmp	word ptr MGRP:_ac_size,16
	je short	@@23
	jmp	@32@9886
@@23:
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;				   binary [ofs++] = (uchar) (s2c_dec (get_argz (line,3)) >> 8);
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_s2c_dec
	push	dx
	push	ax
	pop	eax
	pop	cx
	shr	eax,8
@32@8234:
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
@32@8262:
	mov	byte ptr es:[bx],al
@32@8290:
	inc	word ptr MGRP:_ofs
	jmp	@32@9886
@32@8318:
   ;	
   ;				 }
   ;	    }
   ;	
   ;	   else if  (ea != 8) {
   ;	
	cmp	byte ptr MGRP:_ea,8
	jne short	@@24
	jmp	@32@8794
@@24:
   ;	
   ;	                 if ( (ac_size == 8) && (op==0)) binary [ofs++] = 0x8a;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@8430
	cmp	byte ptr MGRP:_op,0
	jne	short @32@8430
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],138
	inc	word ptr MGRP:_ofs
@32@8430:
   ;	
   ;	                 if ( (ac_size ==16) && (op==0)) binary [ofs++] = 0x8b;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@8514
	cmp	byte ptr MGRP:_op,0
	jne	short @32@8514
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],139
	inc	word ptr MGRP:_ofs
@32@8514:
   ;	
   ;	                 if ( (ac_size == 8) && (op)) binary [ofs++] = l1_opcode[xx].op3;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@8598
	cmp	byte ptr MGRP:_op,0
	je	short @32@8598
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+9]
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@8598:
   ;	
   ;	                 if ( (ac_size ==16) && (op)) binary [ofs++] = l1_opcode[xx].op3+1;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@8682
	cmp	byte ptr MGRP:_op,0
	je	short @32@8682
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+9]
	inc	al
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@8682:
   ;	
   ;			 if (ac_size != op_size) { error ("different size registers"); return 1;}
   ;	
	mov	ax,word ptr MGRP:_ac_size
	cmp	ax,word ptr MGRP:_op_size
	je	short @32@8738
	push	offset MGRP:s@+671
	jmp	@32@2046
@32@8738:
   ;	
   ;			 //if (op_size == 8) binary [ofs]--;
   ;			 binary [ofs++] =  (0xC0) + (ac_ea * 8) + ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	shl	al,3
	add	al,byte ptr MGRP:_ea
@32@8766:
	add	al,192
	jmp	@32@8262
@32@8794:
   ;	
   ;			}
   ;	
   ;	   else if ( get_argz (line,3) [0] == '[' )
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	mov	bx,ax
	cmp	byte ptr [bx],91
	je short	@@25
	jmp	@32@9354
@@25:
   ;	
   ;	    {
   ;	
   ;	     if ((ac_size == 8) && (op==0)) binary [ofs++] = 0x8a;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@8906
	cmp	byte ptr MGRP:_op,0
	jne	short @32@8906
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],138
	inc	word ptr MGRP:_ofs
@32@8906:
   ;	
   ;	     if ((ac_size == 16)&& (op==0)) binary [ofs++] = 0x8b;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@8990
	cmp	byte ptr MGRP:_op,0
	jne	short @32@8990
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],139
	inc	word ptr MGRP:_ofs
@32@8990:
   ;	
   ;	
   ;	     if ((ac_size == 8) && (op) ) binary [ofs++] = l1_opcode[xx].op3;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@9074
	cmp	byte ptr MGRP:_op,0
	je	short @32@9074
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+9]
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@9074:
   ;	
   ;	     if ((ac_size ==16) && (op) ) binary [ofs++] = l1_opcode[xx].op3+1;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@9158
	cmp	byte ptr MGRP:_op,0
	je	short @32@9158
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	si,word ptr MGRP:_xx
	imul	si,si,11
	mov	al,byte ptr MGRP:_l1_opcode[si+9]
	inc	al
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
@32@9158:
   ;	
   ;	
   ;	
   ;	     if       (!strcmp ((string)get_argz (line,3),ofs_bx)) binary [ofs++] = 7 + (ac_ea*8);
   ;	
	push	offset MGRP:_ofs_bx
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@9214
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	shl	al,3
	add	al,7
	jmp	@32@8262
@32@9214:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,3),ofs_si)) binary [ofs++] = 4 + (ac_ea*8);
   ;	
	push	offset MGRP:_ofs_si
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@9270
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	shl	al,3
	add	al,4
	jmp	@32@8262
@32@9270:
   ;	
   ;	     else if (!strcmp ((string)get_argz (line,3),ofs_di)) binary [ofs++] = 5 + (ac_ea*8);
   ;	
	push	offset MGRP:_ofs_di
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@9326
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	shl	al,3
	add	al,5
	jmp	@32@8262
@32@9326:
   ;	
   ;	     else { error ("effective address incorrect"); return 1; }
   ;	
	push	offset MGRP:s@+696
	jmp	@32@2046
@32@9354:
   ;	
   ;	    }
   ;	   else if (!strcmp ((string)get_argz (line,3),"offset"))
   ;	
	push	offset MGRP:s@+724
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@9466
   ;	
   ;	     {
   ;		     binary [ofs++] += ac_ea;
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr es:[bx]
	add	al,byte ptr MGRP:_ac_ea
	mov	bx,word ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     if (!is_label (get_argz(line,4))) { error ("unknown variable"); return 1;};
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	jne	short @32@9438
	push	offset MGRP:s@+731
	jmp	@32@2046
@32@9438:
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) & 0x00ff;
   ;	
	push	4
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,4)) >> 8;
   ;	
	push	4
	jmp	short @32@9634
@32@9466:
   ;	
   ;	     }
   ;	   else if (is_label (get_argz (line,3)) != 0)
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_is_label
	pop	cx
	or	ax,ax
	je	short @32@9662
   ;	
   ;		    {
   ;	             if (ac_size == 8) binary [ofs++] = 0x8a;
   ;	
	cmp	word ptr MGRP:_ac_size,8
	jne	short @32@9550
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],138
	inc	word ptr MGRP:_ofs
@32@9550:
   ;	
   ;	             if (ac_size == 16) binary [ofs++] = 0x8b;
   ;	
	cmp	word ptr MGRP:_ac_size,16
	jne	short @32@9606
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],139
	inc	word ptr MGRP:_ofs
@32@9606:
   ;	
   ;		     binary [ofs++] = 6 + (ac_ea*8);
   ;	
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	al,byte ptr MGRP:_ac_ea
	shl	al,3
	add	al,6
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,3)) & 0x00ff;
   ;	
	push	3
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	and	al,255
	les	bx,dword ptr MGRP:_binary
	add	bx,word ptr MGRP:_ofs
	mov	byte ptr es:[bx],al
	inc	word ptr MGRP:_ofs
   ;	
   ;		     binary [ofs++] = get_ofs_label (get_argz (line,3)) >> 8;
   ;	
	push	3
@32@9634:
	push	di
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_get_ofs_label
	pop	cx
	shr	ax,8
	jmp	@32@8234
@32@9662:
   ;	
   ;		    }
   ;	   else if ( (op) && (l1_opcode[xx].noperand == 1)) ;
   ;	
	cmp	byte ptr MGRP:_op,0
	je	short @32@9718
	mov	bx,word ptr MGRP:_xx
	imul	bx,bx,11
	cmp	byte ptr MGRP:_l1_opcode[bx+5],1
	je	short @32@9886
@32@9718:
   ;	
   ;	   else { error ("incorrect right-operand."); return 1;}
   ;	
	push	offset MGRP:s@+748
	jmp	@32@2046
	jmp	short @32@9886
@32@9774:
	inc	word ptr MGRP:_xx
@32@9802:
	cmp	word ptr MGRP:_xx,16
	jg short	@@26
	jmp	@32@4678
@@26:
   ;	
   ;	  return 0;
   ;	  }
   ;	}
   ;	 if (old_ofs == ofs) { error ("Illegal instruction");return 1; }
   ;	
	mov	ax,word ptr MGRP:_old_ofs
	cmp	ax,word ptr MGRP:_ofs
	jne	short @32@9886
	push	offset MGRP:s@+773
	jmp	@32@2046
@32@9886:
	xor	ax,ax
@32@9914:
   ;	
   ;	 return 0;
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_assemble	endp
   ;	
   ;	char* prog_name (char* s)
   ;	
	assume	cs:MGRP
_prog_name	proc	near
	push	bp
	mov	bp,sp
	mov	dx,word ptr [bp+4]
   ;	
   ;	{
   ;	int i;
   ;	for (i=0; (s[i]!=0) && (s[i]!='.');i++);
   ;	
	xor	ax,ax
	jmp	short @33@86
@33@58:
	inc	ax
@33@86:
	mov	bx,dx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @33@142
	mov	bx,dx
	add	bx,ax
	cmp	byte ptr [bx],46
	jne	short @33@58
@33@142:
   ;	
   ;	s[i] = 0;
   ;	
	mov	bx,dx
	add	bx,ax
	mov	byte ptr [bx],0
   ;	
   ;	return s;
   ;	
	mov	ax,dx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_prog_name	endp
_err	label	word
	db	0
	db	0
   ;	
   ;	void start_program ()
   ;	
	assume	cs:MGRP
_start_program	proc	near
   ;	
   ;	{
   ;	
   ;	 memcpy ((uint)_CS,(uint)argv,_ES,_BX,19);
   ;	
	push	19
	push	bx
	push	es
	push	offset MGRP:_argv
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	 puts ("\n\r");
   ;	
	push	offset MGRP:s@+793
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	 puts (get_argz(argv,2));putc (':');
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_puts
	pop	cx
	push	58
	call	near ptr MGRP:_putc
	pop	cx
   ;	
   ;	 puts ("malloc ...\n\r");
   ;	
	push	offset MGRP:s@+796
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	 binary = (addr)(malloc (40000>>4));
   ;	
	push	2500
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_binary+2,0
	mov	word ptr MGRP:_binary,ax
   ;	
   ;	 asm {	shl dword ptr binary,16 }
   ;	
		shl	 dword ptr MGRP:_binary,16 
   ;	
   ;	 puts (get_argz(argv,2));
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	 input = fopen (get_argz(argv,2));
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
	mov	dword ptr MGRP:_input,eax
   ;	
   ;	 if (input < 2) { puts ("input file incorrect.");
   ;	
	cmp	dword ptr MGRP:_input,large 2
	jae	short @34@170
	push	offset MGRP:s@+809
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                  asm {  shr dword ptr binary,16 };
   ;	
  	shr	 dword ptr MGRP:_binary,16 
   ;	
   ;			  free ((addr)binary); return ; }
   ;	
	push	word ptr MGRP:_binary
	jmp	@34@982
@34@170:
   ;	
   ;	 bufferbatch = malloc (8000 >> 4);
   ;	
	push	500
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_bufferbatch,ax
   ;	
   ;	 fread (input,fsize(input),0,bufferbatch);
   ;	
	push	ax
	push	0
	push	dword ptr MGRP:_input
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_input
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 output = fcreate (prog_name(get_argz(argv,2)));
   ;	
	push	2
	push	offset MGRP:_argv
	call	near ptr MGRP:_get_argz
	add	sp,4
	push	ax
	call	near ptr MGRP:_prog_name
	pop	cx
	push	ax
	call	near ptr MGRP:_fcreate
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_output,eax
   ;	
   ;	 if (output < 2) { puts ("can't create output");
   ;	
	cmp	dword ptr MGRP:_output,large 2
	jae	short @34@282
	push	offset MGRP:s@+831
	call	near ptr MGRP:_puts
	pop	cx
   ;	
   ;	                   asm {  shr dword ptr binary,16 }
   ;	
  	shr	 dword ptr MGRP:_binary,16 
	jmp	@34@954
@34@282:
   ;	
   ;	                   free ((addr)binary);free((addr)bufferbatch) ; return ; }
   ;	 setattr (output,0xc);
   ;	
	push	12
	push	dword ptr MGRP:_output
	call	near ptr MGRP:_setattr
	add	sp,6
   ;	
   ;	 #endif
   ;	
   ;	 #ifndef FOR_DREAMOS
   ;	void start_program (char* arg1,char* arg2)
   ;	{
   ;	
   ;	 input = fopen (arg1,"rb");
   ;	 output = fopen (arg2,"wb");
   ;	 binary = (unsigned char*)malloc (40000);
   ;	 #endif
   ;	
   ;	
   ;	 for (argc=0; argc <= 49 ; argc++)
   ;	
	mov	word ptr MGRP:_argc,0
	jmp	short @34@450
@34@310:
   ;	
   ;	  for (err=0; err <= 19 ; err++)
   ;	
	mov	word ptr MGRP:_err,0
	jmp	short @34@394
@34@338:
   ;	
   ;	   label[err][argc] = 0;
   ;	
	mov	bx,word ptr MGRP:_err
	imul	bx,bx,20
	add	bx,word ptr MGRP:_argc
	mov	byte ptr MGRP:_label[bx],0
	inc	word ptr MGRP:_err
@34@394:
	cmp	word ptr MGRP:_err,19
	jle	short @34@338
	inc	word ptr MGRP:_argc
@34@450:
	cmp	word ptr MGRP:_argc,49
	jle	short @34@310
   ;	
   ;	
   ;	 err = 0;
   ;	
	mov	word ptr MGRP:_err,0
	jmp	short @34@590
@34@506:
   ;	
   ;	 while ( fgets (s,100,input) != NULL )
   ;	 {
   ;	  #ifndef FOR_DREAMOS
   ;	   s[strlen (s)-2]  = 0;
   ;	  #endif
   ;	  ligne++;
   ;	
	inc	word ptr MGRP:_ligne
   ;	
   ;	  if (s[0] == 0) continue;
   ;	
	cmp	byte ptr MGRP:_s,0
	je	short @34@590
   ;	
   ;	
   ;	
   ;	  if (assemble (s)) { err = 1 ; break; }
   ;	
	push	offset MGRP:_s
	call	near ptr MGRP:_assemble
	pop	cx
	or	ax,ax
	je	short @34@590
	mov	word ptr MGRP:_err,1
	jmp	short @34@618
@34@590:
	push	dword ptr MGRP:_input
	push	100
	push	offset MGRP:_s
	call	near ptr MGRP:_fgets
	add	sp,8
	or	ax,ax
	jne	short @34@506
@34@618:
   ;	
   ;	 }
   ;	
   ;	 for (x=0;x<=49;x++)
   ;	
	mov	word ptr MGRP:_x,0
	jmp	short @34@730
@34@646:
   ;	
   ;	  if ( wlabel[x][0] != 0) { error ("no label found for "); puts (wlabel[x]);}
   ;	
	mov	bx,word ptr MGRP:_x
	imul	bx,bx,20
	cmp	byte ptr MGRP:_wlabel[bx],0
	je	short @34@702
	push	offset MGRP:s@+851
	call	near ptr MGRP:_error
	pop	cx
	mov	ax,word ptr MGRP:_x
	imul	ax,ax,20
	add	ax,offset MGRP:_wlabel
	push	ax
	call	near ptr MGRP:_puts
	pop	cx
@34@702:
	inc	word ptr MGRP:_x
@34@730:
	cmp	word ptr MGRP:_x,49
	jle	short @34@646
   ;	
   ;	
   ;	 if (!err) puts (" completed.");
   ;	
	cmp	word ptr MGRP:_err,0
	jne	short @34@814
	push	offset MGRP:s@+871
	call	near ptr MGRP:_puts
	pop	cx
@34@814:
   ;	
   ;	
   ;	 #ifdef FOR_DREAMOS
   ;	 asm {	shr dword ptr binary,16 }
   ;	
		shr	 dword ptr MGRP:_binary,16 
   ;	
   ;	 if (!err) fwrite (output,ofs,0,(uint)binary);
   ;	
	cmp	word ptr MGRP:_err,0
	jne	short @34@898
	push	word ptr MGRP:_binary
	push	0
	movzx	eax,word ptr MGRP:_ofs
	push	eax
	push	dword ptr MGRP:_output
	call	near ptr MGRP:_fwrite
	add	sp,12
@34@898:
   ;	
   ;	 if (err) fremove (output);
   ;	
	cmp	word ptr MGRP:_err,0
	je	short @34@954
	push	dword ptr MGRP:_output
	call	near ptr MGRP:_fremove
	add	sp,4
@34@954:
   ;	
   ;	 #endif
   ;	
   ;	 #ifndef FOR_DREAMOS
   ;	 if (!err) fwrite (binary,ofs,1,output);
   ;	  fclose (input);
   ;	  fclose (output);
   ;	 #endif
   ;	
   ;	 #ifdef FOR_DREAMOS
   ;	// asm {  shr dword ptr binary,16 }
   ;	 free ((addr)binary);
   ;	
	push	word ptr MGRP:_binary
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 free ((addr)bufferbatch);
   ;	
	push	word ptr MGRP:_bufferbatch
@34@982:
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 #endif
   ;	 #ifndef FOR_DREAMOS
   ;	 free (binary);
   ;	 #endif
   ;	
   ;	}
   ;	
	ret	
_start_program	endp
_argv	label	byte
	db	20 dup (0)
_output	label	word
	db	4 dup (0)
_input	label	word
	db	4 dup (0)
_gi	label	word
	db	2 dup (0)
_s	label	byte
	db	100 dup (0)
_ac_ea	label	word
	db	2 dup (0)
_old_ofs	label	word
	db	2 dup (0)
_argc	label	word
	db	2 dup (0)
_x	label	word
	db	2 dup (0)
_xx	label	word
	db	2 dup (0)
_op_size	label	word
	db	2 dup (0)
_ea	label	byte
	db	1 dup (0)
_binary	label	dword
	db	4 dup (0)
_file_offset	label	word
	db	2 dup (0)
_bufferbatch	label	word
	db	2 dup (0)
	?debug	C E9
	?debug	C FA10000000
s@	label	byte
	db	'je'
	db	0
	db	'jz'
	db	0
	db	'ja'
	db	0
	db	'jae'
	db	0
	db	'jb'
	db	0
	db	'jbe'
	db	0
	db	'jc'
	db	0
	db	'jcxz'
	db	0
	db	'jg'
	db	0
	db	'jge'
	db	0
	db	'jl'
	db	0
	db	'jle'
	db	0
	db	'jna'
	db	0
	db	'jnae'
	db	0
	db	'jnb'
	db	0
	db	'jnbe'
	db	0
	db	'jnc'
	db	0
	db	'jne'
	db	0
	db	'jng'
	db	0
	db	'jnge'
	db	0
	db	'jnl'
	db	0
	db	'jnle'
	db	0
	db	'jno'
	db	0
	db	'jnp'
	db	0
	db	'jns'
	db	0
	db	'jnz'
	db	0
	db	'jo'
	db	0
	db	'jp'
	db	0
	db	'jpe'
	db	0
	db	'jpo'
	db	0
	db	'js'
	db	0
	db	'loop'
	db	0
	db	'loope'
	db	0
	db	'loopne'
	db	0
	db	'loopnz'
	db	0
	db	'loopz'
	db	0
	db	10
	db	13
	db	'**error** ('
	db	0
	db	') '
	db	0
	db	'invalid number notation'
	db	0
	db	'too much caracters label'
	db	0
	db	'label already used'
	db	0
	db	'label overflow ( > 50 )'
	db	0
	db	'too many label'
	db	0
	db	'.string'
	db	0
	db	10
	db	0
	db	0
	db	'jmp'
	db	0
	db	'call'
	db	0
	db	'aad'
	db	0
	db	'aam'
	db	0
	db	'pop'
	db	0
	db	'incorrect '
	db	39
	db	'pop'
	db	39
	db	' usage'
	db	0
	db	'push'
	db	0
	db	'incorrect '
	db	39
	db	'push'
	db	39
	db	' usage'
	db	0
	db	'out'
	db	0
	db	'must 8-bits value'
	db	0
	db	'must 8-bits value'
	db	0
	db	'in'
	db	0
	db	'must 8-bits value'
	db	0
	db	'must 8-bits value'
	db	0
	db	'.org'
	db	0
	db	'.byte'
	db	0
	db	'.word'
	db	0
	db	'.array'
	db	0
	db	'int'
	db	0
	db	'incorrect right operand'
	db	0
	db	'cl'
	db	0
	db	'must be 8-bit value'
	db	0
	db	'mov'
	db	0
	db	'mov'
	db	0
	db	'byte'
	db	0
	db	'ptr'
	db	0
	db	'missing '
	db	39
	db	'ptr'
	db	39
	db	0
	db	'incorrect effective address'
	db	0
	db	'word'
	db	0
	db	'ptr'
	db	0
	db	'missing '
	db	39
	db	'ptr'
	db	39
	db	0
	db	'incorrect effective address'
	db	0
	db	'ds'
	db	0
	db	'es'
	db	0
	db	'incorrect left-operand.'
	db	0
	db	'must be 8-bits value'
	db	0
	db	'different size registers'
	db	0
	db	'effective address incorrect'
	db	0
	db	'offset'
	db	0
	db	'unknown variable'
	db	0
	db	'incorrect right-operand.'
	db	0
	db	'Illegal instruction'
	db	0
	db	10
	db	13
	db	0
	db	'malloc ...'
	db	10
	db	13
	db	0
	db	'input file incorrect.'
	db	0
	db	'can'
	db	39
	db	't create output'
	db	0
	db	'no label found for '
	db	0
	db	' completed.'
	db	0
VPSEG	ends
	public	_argv
	public	_err
	public	_output
	public	_input
	public	_prog_name
	public	_assemble
	public	_gi
	public	_s
	public	_ac_ea
	public	_ac_size
	public	_old_ofs
	public	_argc
	public	_waiting_label
	public	_x
	public	_record_label
	public	_is_label
	public	_get_ofs_label
	public	_lower_case
	public	_s2c_dec
	public	_error
	public	_i_label
	public	_l1_opcode
	public	_bin_opcode
	public	_once_opcode
	public	_jcc_code
	public	_jcc
	public	_ofs_di
	public	_ofs_si
	public	_ofs_bx
	public	_sreg
	public	_reg8
	public	_reg16
	public	_actual_code
	public	_op
	public	_wlab_cod
	public	_wlab_ofs
	public	_lab_ofs
	public	_wlabel
	public	_label
	public	_xx
	public	_ligne
	public	_op_size
	public	_ea
	public	_ofs
	public	_binary
	public	_malloc
	public	_puts
	public	_putn
	public	_putc
	public	_free
	public	_fgets
	public	_file_offset
	public	_peekchar
	public	_bufferbatch
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
	public	_get_argz
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
	public	_main
	public	_start_program
_s@	equ	s@
	end
