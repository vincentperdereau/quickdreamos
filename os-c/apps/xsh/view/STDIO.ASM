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
	?debug	S "stdio.c"
	?debug	C E9E34B535707737464696F2E63
	?debug	C E9E34B5357075F646566732E68
	?debug	C E9E34B5357087374646172672E68
	?debug	C E9E34B5357086D656D6F72792E68
VPSEG	segment byte public use16 
VPSEG	ends
MGRP	group	VPSEG
	assume	cs:MGRP,ds:MGRP
VPSEG	segment byte public use16 
d@	label	byte
d@w	label	word
b@	label	byte
b@w	label	word
_f_stat	label	byte
	db	0
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
   ;	        push ax
   ;	
	push	 ax
   ;	
   ;	        mov al,c
   ;	
	mov	 al,[bp+4]
   ;	
   ;	        int 0x29
   ;	
	int	 029H
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
_putc	endp
   ;	
   ;	void writenum (unsigned long dw,char size)
   ;	
	assume	cs:MGRP
_writenum	proc	near
	enter	4,0
	push	si
	mov	al,byte ptr [bp+8]
   ;	
   ;	{
   ;	 unsigned long i ; unsigned char b ;
   ;	 int flag=0;
   ;	
	xor	si,si
   ;	
   ;	
   ;	 if (size==8) i = 100;
   ;	
	cmp	al,8
	jne	short @3@86
	mov	dword ptr [bp-4],large 100
@3@86:
   ;	
   ;	 if (size==16) i = 10000;
   ;	
	cmp	al,16
	jne	short @3@142
	mov	dword ptr [bp-4],large 10000
@3@142:
   ;	
   ;	 if (size==32) i = 1000000000;
   ;	
	cmp	al,32
	jne	short @3@422
	mov	dword ptr [bp-4],large 03B9ACA00h
	jmp	short @3@422
@3@198:
   ;	
   ;	
   ;	 for (;i!=0;i/=10)
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
	je	short @3@254
	mov	si,1
@3@254:
   ;	
   ;	 if (flag)  putc (b+48) ;
   ;	
	or	si,si
	je	short @3@310
	mov	al,bl
	add	al,48
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
@3@310:
   ;	
   ;	 if ( (!i) && (!flag)) putc (48);
   ;	
	cmp	dword ptr [bp-4],large 0
	jne	short @3@394
	or	si,si
	jne	short @3@394
	push	48
	call	near ptr MGRP:_putc
	pop	cx
@3@394:
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@3@422:
	cmp	dword ptr [bp-4],large 0
	jne	short @3@198
   ;	
   ;	 }
   ;	}
   ;	
	pop	si
	leave	
	ret	
_writenum	endp
   ;	
   ;	 void write_hex_byte (unsigned char b,char cas)
   ;	
	assume	cs:MGRP
_write_hex_byte	proc	near
	enter	2,0
   ;	
   ;	 {
   ;	  char letter;
   ;	
   ;	  if (cas == 'x') letter = 'a';
   ;	
	cmp	byte ptr [bp+6],120
	jne	short @4@86
	mov	byte ptr [bp-1],97
	jmp	short @4@114
@4@86:
   ;	
   ;	  else letter = 'A';
   ;	
	mov	byte ptr [bp-1],65
@4@114:
   ;	
   ;	  if ( (b>>4) > 9 ) putc ( (b>>4) + letter - 10 );
   ;	
	mov	al,byte ptr [bp+4]
	mov	ah,0
	sar	ax,4
	cmp	ax,9
	jle	short @4@170
	mov	al,byte ptr [bp+4]
	mov	ah,0
	sar	ax,4
	add	al,byte ptr [bp-1]
	add	al,246
	jmp	short @4@198
@4@170:
   ;	
   ;	  else  putc ( (b>>4) + '0' );
   ;	
	mov	al,byte ptr [bp+4]
	mov	ah,0
	sar	ax,4
	add	al,48
@4@198:
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
   ;	
   ;	  if ( (b & 0x0f) > 9 ) putc ( (b & 0x0f) + letter - 10 );
   ;	
	mov	al,byte ptr [bp+4]
	mov	ah,0
	and	ax,15
	cmp	ax,9
	jle	short @4@282
	mov	al,byte ptr [bp+4]
	and	al,15
	add	al,byte ptr [bp-1]
	add	al,246
	jmp	short @4@310
@4@282:
   ;	
   ;	  else  putc ( (b & 0x0f) + '0' );
   ;	
	mov	al,byte ptr [bp+4]
	and	al,15
	add	al,48
@4@310:
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
   ;	
   ;	 }
   ;	
	leave	
	ret	
_write_hex_byte	endp
   ;	
   ;	 void write_hex_word (unsigned int w, char cas)
   ;	
	assume	cs:MGRP
_write_hex_word	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  write_hex_byte (w>>8,cas);
   ;	
	mov	al,byte ptr [bp+6]
	push	ax
	mov	ax,word ptr [bp+4]
	shr	ax,8
	push	ax
	call	near ptr MGRP:_write_hex_byte
	add	sp,4
   ;	
   ;	  write_hex_byte (w&0x00ff,cas);
   ;	
	mov	al,byte ptr [bp+6]
	push	ax
	mov	al,byte ptr [bp+4]
	and	al,255
	push	ax
	call	near ptr MGRP:_write_hex_byte
	add	sp,4
   ;	
   ;	 }
   ;	
	pop	bp
	ret	
_write_hex_word	endp
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
   ;	 for (i=0; s[i] != 0; i++)
   ;	
	xor	si,si
	jmp	short @6@170
@6@58:
   ;	
   ;	 {
   ;	  if (s[i] == 10) putc (13);
   ;	
	mov	bx,si
	cmp	byte ptr [bx+di],10
	jne	short @6@114
	push	13
	call	near ptr MGRP:_putc
	pop	cx
@6@114:
   ;	
   ;	  putc (s[i]);
   ;	
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_putc
	pop	cx
	inc	si
@6@170:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @6@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_puts	endp
   ;	
   ;	void printf (char* format,...)
   ;	
	assume	cs:MGRP
_printf	proc	near
	enter	6,0
	push	si
	push	di
   ;	
   ;	{
   ;	 int adr;
   ;	 unsigned int tmp;
   ;	 char ch;
   ;	 va_list vl;
   ;	
   ;	 va_start (vl,format);
   ;	
	lea	ax,word ptr [bp+6]
	mov	word ptr [bp-4],ax
	jmp	@7@1402
@7@58:
   ;	
   ;	
   ;	 while (*format)
   ;	 {
   ;	  if (*format == '\n')  putc (13);
   ;	
	mov	bx,word ptr [bp+4]
	cmp	byte ptr [bx],10
	jne	short @7@114
	push	13
	call	near ptr MGRP:_putc
	pop	cx
@7@114:
   ;	
   ;	  if (*format != '%')
   ;	
	mov	bx,word ptr [bp+4]
	cmp	byte ptr [bx],37
	je	short @7@170
	jmp	@7@1290
@7@170:
   ;	
   ;	   putc (*format);
   ;	  else
   ;	  {
   ;	   switch (*++format)
   ;	
	inc	word ptr [bp+4]
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	cbw	
	mov	word ptr [bp-6],ax
	mov	cx,5
	mov	bx,offset @7@C66
@7@226:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-6]
	je	short @7@310
	add	bx,2
	loop	short @7@226
	jmp	@7@1290
@7@310:
	jmp	word ptr cs:[bx+10]
@7@338:
   ;	
   ;	   {
   ;	    case 's':   asm { mov ax,ss ; mov ds,ax }
   ;	
 	mov	 ax,ss 
 	mov	 ds,ax 
   ;	
   ;	                adr = va_arg (vl,int);
   ;	
	add	word ptr [bp-4],2
	mov	bx,word ptr [bp-4]
	mov	di,word ptr [bx-2]
   ;	
   ;	                asm { mov ax,cs ; mov ds,ax }
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	                if (!adr) puts ("<NULL>");
   ;	
	or	di,di
	jne	short @7@562
	push	offset MGRP:s@
@7@534:
	call	near ptr MGRP:_puts
	jmp	@7@1346
@7@562:
   ;	
   ;	                else puts ( (char*)adr );
   ;	
	push	di
	jmp	short @7@534
@7@590:
   ;	
   ;	                break;
   ;	    case 'u': asm { mov ax,ss ; mov ds,ax }
   ;	
 	mov	 ax,ss 
 	mov	 ds,ax 
   ;	
   ;	              tmp = va_arg (vl,unsigned int);
   ;	
	add	word ptr [bp-4],2
	mov	bx,word ptr [bp-4]
	mov	si,word ptr [bx-2]
   ;	
   ;	              asm { mov ax,cs ; mov ds,ax }
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	              writenum ( tmp ,16);
   ;	
	push	16
	movzx	eax,si
	push	eax
	call	near ptr MGRP:_writenum
	add	sp,6
   ;	
   ;	              break;
   ;	
	jmp	@7@1374
@7@758:
   ;	
   ;	    case 'x': asm { mov ax,ss ; mov ds,ax }
   ;	
 	mov	 ax,ss 
 	mov	 ds,ax 
   ;	
   ;	              tmp = va_arg (vl,unsigned int);
   ;	
	add	word ptr [bp-4],2
	mov	bx,word ptr [bp-4]
	mov	si,word ptr [bx-2]
   ;	
   ;	              asm { mov ax,cs ; mov ds,ax }
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	              write_hex_word (tmp,'x');
   ;	
	push	120
	jmp	short @7@1094
@7@926:
   ;	
   ;	              break;
   ;	    case 'X': asm { mov ax,ss ; mov ds,ax }
   ;	
 	mov	 ax,ss 
 	mov	 ds,ax 
   ;	
   ;	              tmp = va_arg (vl,unsigned int);
   ;	
	add	word ptr [bp-4],2
	mov	bx,word ptr [bp-4]
	mov	si,word ptr [bx-2]
   ;	
   ;	              asm { mov ax,cs ; mov ds,ax }
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	              write_hex_word (tmp,'X');
   ;	
	push	88
@7@1094:
	push	si
	call	near ptr MGRP:_write_hex_word
	add	sp,4
   ;	
   ;	              break;
   ;	
	jmp	short @7@1374
@7@1122:
   ;	
   ;	    case 'c': asm { mov ax,ss ; mov ds,ax }
   ;	
 	mov	 ax,ss 
 	mov	 ds,ax 
   ;	
   ;	              ch = va_arg (vl,char);
   ;	
	add	word ptr [bp-4],2
	mov	bx,word ptr [bp-4]
	mov	al,byte ptr [bx-2]
	mov	byte ptr [bp-1],al
   ;	
   ;	              asm { mov ax,cs ; mov ds,ax }
   ;	
 	mov	 ax,cs 
 	mov	 ds,ax 
   ;	
   ;	              putc (ch);
   ;	
	mov	al,byte ptr [bp-1]
	jmp	short @7@1318
@7@1290:
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
@7@1318:
	push	ax
	call	near ptr MGRP:_putc
@7@1346:
	pop	cx
@7@1374:
   ;	
   ;	              break;
   ;	    default:  putc (*format);
   ;	
   ;	   }
   ;	  }
   ;	  format++;
   ;	
	inc	word ptr [bp+4]
@7@1402:
	mov	bx,word ptr [bp+4]
	cmp	byte ptr [bx],0
	je short	@@0
	jmp	@7@58
@@0:
   ;	
   ;	  }
   ;	 va_end (vl);
   ;	
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_printf	endp
@7@C66	label	word
	db	88
	db	0
	db	99
	db	0
	db	115
	db	0
	db	117
	db	0
	db	120
	db	0
	dw	@7@926
	dw	@7@1122
	dw	@7@338
	dw	@7@590
	dw	@7@758
   ;	
   ;	 unsigned long f_open (char* fname)
   ;	
	assume	cs:MGRP
_f_open	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
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
   ;	        push    di
   ;	
	push	    di
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
   ;	        pop     di
   ;	
	pop	     di
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
	pop	di
	pop	si
	pop	bp
	ret	
_f_open	endp
   ;	
   ;	 unsigned long f_create (char* fname)
   ;	
	assume	cs:MGRP
_f_create	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
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
   ;	        push    di
   ;	
	push	    di
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
   ;	        pop     di
   ;	
	pop	     di
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
	pop	di
	pop	si
	pop	bp
	ret	
_f_create	endp
   ;	
   ;	 int f_read (unsigned long h,long count,void* buffer,unsigned int segm)
   ;	
	assume	cs:MGRP
_f_read	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;	        push    es
   ;	
	push	    es
   ;	
   ;	        push    si
   ;	
	push	    si
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
   ;	        pop     si
   ;	
	pop	     si
   ;	
   ;	        pop     es
   ;	
	pop	     es
   ;	
   ;	      }
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_f_read	endp
   ;	
   ;	 int f_write (unsigned long h,long count,void* buffer,unsigned int segm)
   ;	
	assume	cs:MGRP
_f_write	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
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
   ;	        push    di
   ;	
	push	    di
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
   ;	        pop     di
   ;	
	pop	     di
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
	pop	di
	pop	si
	pop	bp
	ret	
_f_write	endp
   ;	
   ;	 unsigned long f_size (unsigned long h)
   ;	
	assume	cs:MGRP
_f_size	proc	near
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
_f_size	endp
   ;	
   ;	FILE* fopen (char* filename, char* flag)
   ;	
	assume	cs:MGRP
_fopen	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
	mov	si,word ptr [bp+6]
   ;	
   ;	{
   ;	
   ;	 f = (unsigned long) malloc (1);
   ;	
	push	1
	call	near ptr MGRP:_malloc
	pop	cx
	mov	dx,ds
	push	dx
	push	ax
	pop	eax
	shld	edx,eax,16
	mov	word ptr MGRP:_f+2,dx
	mov	word ptr MGRP:_f,ax
   ;	
   ;	 asm { shl dword ptr f,16 };
   ;	
 	shl	 dword ptr MGRP:_f,16 
   ;	
   ;	
   ;	 if (flag[0] == 'r')
   ;	
	cmp	byte ptr [si],114
	je short	@@1
	jmp	@13@226
@@1:
   ;	
   ;	 {
   ;	  f->bofs = 0;
   ;	
	les	bx,dword ptr MGRP:_f
	mov	word ptr es:[bx+6],0
   ;	
   ;	  f->op = 2;
   ;	
	mov	word ptr es:[bx+10],2
   ;	
   ;	  f->handle = f_open (filename);
   ;	
	push	di
	call	near ptr MGRP:_f_open
	push	dx
	push	ax
	pop	eax
	pop	cx
	les	bx,dword ptr MGRP:_f
	mov	dword ptr es:[bx],eax
   ;	
   ;	  f->size = f_size (f->handle);
   ;	
	push	dword ptr es:[bx]
	call	near ptr MGRP:_f_size
	add	sp,4
	les	bx,dword ptr MGRP:_f
	mov	word ptr es:[bx+8],ax
   ;	
   ;	  if (f->handle <2)
   ;	
	cmp	dword ptr es:[bx],large 2
	jae	short @13@170
@13@142:
   ;	
   ;	  {
   ;	   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   ;	
	mov	eax,dword ptr MGRP:_f
	shr	eax,16
	mov	word ptr MGRP:_dc,ax
   ;	
   ;	   free (dc);
   ;	
	push	ax
	call	near ptr MGRP:_free
	pop	cx
	jmp	@13@338
@13@170:
   ;	
   ;	   return (FILE*)0;
   ;	  }
   ;	  f->bseg = malloc (  ((f->size) >> 4) +1);
   ;	
	les	bx,dword ptr MGRP:_f
	mov	ax,word ptr es:[bx+8]
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr MGRP:_malloc
	pop	cx
	les	bx,dword ptr MGRP:_f
	mov	word ptr es:[bx+4],ax
   ;	
   ;	  f_read (f->handle,f->size,(void*)f->bofs,f->bseg);
   ;	
	push	word ptr es:[bx+4]
	push	word ptr es:[bx+6]
	movzx	eax,word ptr es:[bx+8]
	push	eax
	push	dword ptr es:[bx]
	call	near ptr MGRP:_f_read
	add	sp,12
   ;	
   ;	  return (f);
   ;	
@13@198:
	mov	dx,word ptr MGRP:_f+2
	mov	ax,word ptr MGRP:_f
	jmp	short @13@366
@13@226:
   ;	
   ;	 }
   ;	 if (flag[0] == 'w')
   ;	
	cmp	byte ptr [si],119
	jne	short @13@338
   ;	
   ;	 {
   ;	  f->bseg = malloc (0xfff);
   ;	
	push	4095
	call	near ptr MGRP:_malloc
	pop	cx
	les	bx,dword ptr MGRP:_f
	mov	word ptr es:[bx+4],ax
   ;	
   ;	  f->bofs = 0;
   ;	
	mov	word ptr es:[bx+6],0
   ;	
   ;	  f->op = 3;
   ;	
	mov	word ptr es:[bx+10],3
   ;	
   ;	  f->size = 0;
   ;	
	mov	word ptr es:[bx+8],0
   ;	
   ;	  f->handle = f_create (filename);
   ;	
	push	di
	call	near ptr MGRP:_f_create
	push	dx
	push	ax
	pop	eax
	pop	cx
	les	bx,dword ptr MGRP:_f
	mov	dword ptr es:[bx],eax
   ;	
   ;	  if (f->handle <2)
   ;	
	cmp	dword ptr es:[bx],large 2
	jae	short @13@198
	jmp	@13@142
	jmp	short @13@198
@13@338:
   ;	
   ;	  {
   ;	   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   ;	   free (dc);
   ;	   return (FILE*)0;
   ;	  }
   ;	  return (f);
   ;	 }
   ;	 return (FILE*)0;
   ;	
	xor	dx,dx
	xor	ax,ax
@13@366:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fopen	endp
   ;	
   ;	int fread (void* buf, int size, int nelelm, FILE *fd)
   ;	
	assume	cs:MGRP
_fread	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
   ;	
   ;	{
   ;	 memcpy (_CS,(unsigned int)buf,fd->bseg,fd->bofs,size*nelelm);
   ;	
	mov	ax,si
	imul	di
	push	ax
	les	bx,dword ptr [bp+10]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	push	word ptr [bp+4]
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	 fd->bofs += size * nelelm;
   ;	
	mov	ax,si
	imul	di
	les	bx,dword ptr [bp+10]
	add	word ptr es:[bx+6],ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fread	endp
   ;	
   ;	int fwrite (void* buf, int size, int nelelm, FILE *fd)
   ;	
	assume	cs:MGRP
_fwrite	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
   ;	
   ;	{
   ;	 memcpy (fd->bseg,fd->bofs,_CS,(unsigned int)buf,size*nelelm);
   ;	
	mov	ax,si
	imul	di
	push	ax
	push	word ptr [bp+4]
	push	cs
	les	bx,dword ptr [bp+10]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	 fd->bofs += size * nelelm;
   ;	
	mov	ax,si
	imul	di
	les	bx,dword ptr [bp+10]
	add	word ptr es:[bx+6],ax
   ;	
   ;	 fd->size = fd->bofs;
   ;	
	mov	ax,word ptr es:[bx+6]
	mov	word ptr es:[bx+8],ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fwrite	endp
   ;	
   ;	int fseek (FILE *fd, long offset, int whence)
   ;	
	assume	cs:MGRP
_fseek	proc	near
	push	bp
	mov	bp,sp
	mov	dx,word ptr [bp+12]
   ;	
   ;	{
   ;	 if (whence == 0) fd->bofs = offset;
   ;	
	or	dx,dx
	jne	short @16@86
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+6],ax
@16@86:
   ;	
   ;	 if (whence == 1) fd->bofs += offset;
   ;	
	cmp	dx,1
	jne	short @16@142
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr es:[bx+6]
	add	ax,word ptr [bp+8]
	mov	word ptr es:[bx+6],ax
@16@142:
   ;	
   ;	 if (whence == 2) fd->bofs = fd->size - offset;
   ;	
	cmp	dx,2
	jne	short @16@198
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr es:[bx+8]
	sub	ax,word ptr [bp+8]
	mov	word ptr es:[bx+6],ax
@16@198:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fseek	endp
   ;	
   ;	char fgetc (FILE *fd)
   ;	
	assume	cs:MGRP
_fgetc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 if (fd->bofs == fd->size) { f_stat = 1; return 0; }
   ;	
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr es:[bx+6]
	cmp	ax,word ptr es:[bx+8]
	jne	short @17@86
	mov	byte ptr MGRP:_f_stat,1
	mov	al,0
	jmp	short @17@114
@17@86:
   ;	
   ;	 memcpy (_CS,(unsigned int)&(static_c),fd->bseg,fd->bofs,1);
   ;	
	push	1
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	push	offset MGRP:static_c
	push	cs
	call	near ptr MGRP:_memcpy
	add	sp,10
   ;	
   ;	 fd->bofs++;
   ;	
	les	bx,dword ptr [bp+4]
	inc	word ptr es:[bx+6]
   ;	
   ;	 return static_c;
   ;	
	mov	al,byte ptr MGRP:static_c
@17@114:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fgetc	endp
   ;	
   ;	char* fgets(char* buf, int len, FILE *f)
   ;	
	assume	cs:MGRP
_fgets	proc	near
	enter	2,0
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	   int c = 0;
   ;	
	mov	word ptr [bp-2],0
   ;	
   ;	   char ch;
   ;	   char* p = buf;
   ;	
	mov	si,di
   ;	
   ;	
   ;	   f_stat = 0;
   ;	
	mov	byte ptr MGRP:_f_stat,0
	jmp	short @18@114
@18@58:
   ;	
   ;	   while((c++ < (len-1)) && (!f_stat) ) {
   ;	      f_stat = 0;
   ;	
	mov	byte ptr MGRP:_f_stat,0
   ;	
   ;	      ch = fgetc (f);
   ;	
	push	dword ptr [bp+8]
	call	near ptr MGRP:_fgetc
	add	sp,4
	mov	dl,al
   ;	
   ;	      if(ch == '\r')
   ;	
	cmp	dl,13
	je	short @18@114
   ;	
   ;	         continue;
   ;	      *p++ = ch;
   ;	
	mov	byte ptr [si],dl
	inc	si
   ;	
   ;	      if(ch == '\n')
   ;	
	cmp	dl,10
	je	short @18@170
@18@114:
	mov	ax,word ptr [bp-2]
	inc	word ptr [bp-2]
	mov	dx,word ptr [bp+6]
	dec	dx
	cmp	ax,dx
	jge	short @18@170
	mov	al,byte ptr MGRP:_f_stat
	cbw	
	or	ax,ax
	je	short @18@58
@18@170:
   ;	
   ;	         break;
   ;	   }
   ;	
   ;	   if(!f_stat)
   ;	
	mov	al,byte ptr MGRP:_f_stat
	cbw	
	or	ax,ax
	jne	short @18@226
   ;	
   ;	      return(0);
   ;	
	xor	ax,ax
	jmp	short @18@254
@18@226:
   ;	
   ;	   *p++ = 0;
   ;	
	mov	byte ptr [si],0
   ;	
   ;	   return (buf);
   ;	
	mov	ax,di
@18@254:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_fgets	endp
   ;	
   ;	void fclose (FILE *fd)
   ;	
	assume	cs:MGRP
_fclose	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 if ( fd->op == 3) f_write (fd->handle,fd->size,0,fd->bseg);
   ;	
	les	bx,dword ptr [bp+4]
	cmp	word ptr es:[bx+10],3
	jne	short @19@86
	push	word ptr es:[bx+4]
	push	0
	movzx	eax,word ptr es:[bx+8]
	push	eax
	push	dword ptr es:[bx]
	call	near ptr MGRP:_f_write
	add	sp,12
@19@86:
   ;	
   ;	 free (fd->bseg);
   ;	
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+4]
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 dc = (unsigned int) ( (unsigned long)(fd) >> 16 );
   ;	
	mov	eax,dword ptr [bp+4]
	shr	eax,16
	mov	word ptr MGRP:_dc,ax
   ;	
   ;	 free (dc);
   ;	
	push	ax
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fclose	endp
   ;	
   ;	unsigned long fsize (FILE *f)
   ;	
	assume	cs:MGRP
_fsize	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 return (f_size ( f->handle ) );
   ;	
	les	bx,dword ptr [bp+4]
	push	dword ptr es:[bx]
	call	near ptr MGRP:_f_size
	add	sp,4
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fsize	endp
static_c	label	byte
	db	1 dup (0)
_dc	label	word
	db	2 dup (0)
_f	label	dword
	db	4 dup (0)
	?debug	C E9
	?debug	C FA10010000
s@	label	byte
	db	'<NULL>'
	db	0
VPSEG	ends
	public	_fsize
	public	_fclose
	public	_fgets
	public	_fgetc
_static_c	equ	static_c
	public	_fseek
	public	_fwrite
	public	_fread
	public	_fopen
	public	_dc
	public	_f
	public	_f_size
	public	_f_write
	public	_f_read
	public	_f_create
	public	_f_open
	public	_printf
	public	_puts
	public	_write_hex_word
	public	_write_hex_byte
	public	_writenum
	public	_putc
	public	_gets
	public	_f_stat
	extrn	_memcpy:near
	extrn	_free:near
	extrn	_malloc:near
_s@	equ	s@
	end
