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
	?debug	C E9D0A0692B07737464696F2E63
	?debug	C E940190619075F646566732E68
	?debug	C E94E929B27087374646172672E68
	?debug	C E945979C27086D656D6F72792E68
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public use16 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public use16 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public use16 'DATA'
_f_stat	label	byte
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
   ;	
   ;	void gets (char* s,unsigned int c)
   ;	
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	assume	cs:_TEXT
_writenum	proc	near
	enter	6,0
	push	si
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
	cmp	byte ptr [bp+8],8
	jne	short @3@86
	mov	dword ptr [bp-4],large 100
@3@86:
   ;	
   ;	 if (size==16) i = 10000;
   ;	
	cmp	byte ptr [bp+8],16
	jne	short @3@142
	mov	dword ptr [bp-4],large 10000
@3@142:
   ;	
   ;	 if (size==32) i = 1000000000;
   ;	
	cmp	byte ptr [bp+8],32
	jne	short @3@198
	mov	dword ptr [bp-4],large 03B9ACA00h
@3@198:
	jmp	short @3@450
@3@226:
   ;	
   ;	
   ;	 for (;i!=0;i/=10)
   ;	 {
   ;	 b = dw / i ; dw = dw - (b*i) ;
   ;	
	mov	eax,dword ptr [bp+4]
	xor	edx,edx
	div	dword ptr [bp-4]
	mov	byte ptr [bp-5],al
	mov	al,byte ptr [bp-5]
	mov	ah,0
	movsx	eax,ax
	imul	eax,dword ptr [bp-4]
	mov	edx,dword ptr [bp+4]
	sub	edx,eax
	mov	dword ptr [bp+4],edx
   ;	
   ;	 if (b) flag = 1;
   ;	
	cmp	byte ptr [bp-5],0
	je	short @3@282
	mov	si,1
@3@282:
   ;	
   ;	 if (flag)  putc (b+48) ;
   ;	
	or	si,si
	je	short @3@338
	mov	al,byte ptr [bp-5]
	add	al,48
	push	ax
	call	near ptr _putc
	pop	cx
@3@338:
   ;	
   ;	 if ( (!i) && (!flag)) putc (48);
   ;	
	cmp	dword ptr [bp-4],large 0
	jne	short @3@422
	or	si,si
	jne	short @3@422
	push	48
	call	near ptr _putc
	pop	cx
@3@422:
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@3@450:
	cmp	dword ptr [bp-4],large 0
	jne	short @3@226
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
	assume	cs:_TEXT
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
	call	near ptr _putc
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
	call	near ptr _putc
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
	assume	cs:_TEXT
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
	call	near ptr _write_hex_byte
	add	sp,4
   ;	
   ;	  write_hex_byte (w&0x00ff,cas);
   ;	
	mov	al,byte ptr [bp+6]
	push	ax
	mov	al,byte ptr [bp+4]
	and	al,255
	push	ax
	call	near ptr _write_hex_byte
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
	assume	cs:_TEXT
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
	call	near ptr _putc
	pop	cx
@6@114:
   ;	
   ;	  putc (s[i]);
   ;	
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr _putc
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
	assume	cs:_TEXT
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
	jmp	@7@1374
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
	call	near ptr _putc
	pop	cx
@7@114:
   ;	
   ;	  if (*format != '%')
   ;	
	mov	bx,word ptr [bp+4]
	cmp	byte ptr [bx],37
	je	short @7@170
   ;	
   ;	   putc (*format);
   ;	
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	push	ax
	call	near ptr _putc
	pop	cx
	jmp	@7@1346
@7@170:
   ;	
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
	mov	bx,offset @7@C978
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
	jne	short @7@534
	push	offset DGROUP:s@
	jmp	short @7@562
@7@534:
   ;	
   ;	                else puts ( (char*)adr );
   ;	
	push	di
@7@562:
	call	near ptr _puts
	pop	cx
   ;	
   ;	                break;
   ;	
	jmp	@7@1346
@7@618:
   ;	
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
	call	near ptr _writenum
	add	sp,6
   ;	
   ;	              break;
   ;	
	jmp	@7@1346
@7@786:
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
	push	si
	call	near ptr _write_hex_word
	add	sp,4
   ;	
   ;	              break;
   ;	
	jmp	short @7@1346
@7@954:
   ;	
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
	push	si
	call	near ptr _write_hex_word
	add	sp,4
   ;	
   ;	              break;
   ;	
	jmp	short @7@1346
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
   ;	
   ;	              break;
   ;	    default:  putc (*format);
   ;	
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
@7@1318:
	push	ax
	call	near ptr _putc
	pop	cx
@7@1346:
   ;	
   ;	
   ;	   }
   ;	  }
   ;	  format++;
   ;	
	inc	word ptr [bp+4]
@7@1374:
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
@7@C978	label	word
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
	dw	@7@954
	dw	@7@1122
	dw	@7@338
	dw	@7@618
	dw	@7@786
   ;	
   ;	 unsigned long f_open (char* fname)
   ;	
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	assume	cs:_TEXT
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
	call	near ptr _malloc
	pop	cx
	mov	dx,ds
	push	dx
	push	ax
	pop	eax
	shld	edx,eax,16
	mov	word ptr DGROUP:_f+2,dx
	mov	word ptr DGROUP:_f,ax
   ;	
   ;	 asm { shl dword ptr f,16 };
   ;	
 	shl	 dword ptr DGROUP:_f,16 
   ;	
   ;	
   ;	 if (flag[0] == 'r')
   ;	
	cmp	byte ptr [si],114
	je short	@@1
	jmp	@13@254
@@1:
   ;	
   ;	 {
   ;	  f->bofs = 0;
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+6],0
   ;	
   ;	  f->op = 2;
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+10],2
   ;	
   ;	  f->handle = f_open (filename);
   ;	
	push	di
	call	near ptr _f_open
	push	dx
	push	ax
	pop	eax
	pop	cx
	les	bx,dword ptr DGROUP:_f
	mov	dword ptr es:[bx],eax
   ;	
   ;	  f->size = f_size (f->handle);
   ;	
	les	bx,dword ptr DGROUP:_f
	push	dword ptr es:[bx]
	call	near ptr _f_size
	add	sp,4
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+8],ax
   ;	
   ;	  if (f->handle <2)
   ;	
	les	bx,dword ptr DGROUP:_f
	cmp	dword ptr es:[bx],large 2
	jae	short @13@226
@13@142:
   ;	
   ;	  {
   ;	   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   ;	
	mov	eax,dword ptr DGROUP:_f
	shr	eax,16
	mov	word ptr DGROUP:_dc,ax
   ;	
   ;	   free (dc);
   ;	
	push	word ptr DGROUP:_dc
	call	near ptr _free
	pop	cx
   ;	
   ;	   return (FILE*)0;
   ;	
@13@170:
	xor	dx,dx
	xor	ax,ax
@13@198:
	jmp	@13@394
@13@226:
   ;	
   ;	  }
   ;	  f->bseg = malloc (  ((f->size) >> 4) +1);
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	ax,word ptr es:[bx+8]
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr _malloc
	pop	cx
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+4],ax
   ;	
   ;	  f_read (f->handle,f->size,(void*)f->bofs,f->bseg);
   ;	
	les	bx,dword ptr DGROUP:_f
	push	word ptr es:[bx+4]
	les	bx,dword ptr DGROUP:_f
	push	word ptr es:[bx+6]
	les	bx,dword ptr DGROUP:_f
	movzx	eax,word ptr es:[bx+8]
	push	eax
	les	bx,dword ptr DGROUP:_f
	push	dword ptr es:[bx]
	call	near ptr _f_read
	add	sp,12
	jmp	short @13@338
@13@254:
   ;	
   ;	  return (f);
   ;	 }
   ;	 if (flag[0] == 'w')
   ;	
	cmp	byte ptr [si],119
	jne	short @13@366
   ;	
   ;	 {
   ;	  f->bseg = malloc (0xfff);
   ;	
	push	4095
	call	near ptr _malloc
	pop	cx
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+4],ax
   ;	
   ;	  f->bofs = 0;
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+6],0
   ;	
   ;	  f->op = 3;
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+10],3
   ;	
   ;	  f->size = 0;
   ;	
	les	bx,dword ptr DGROUP:_f
	mov	word ptr es:[bx+8],0
   ;	
   ;	  f->handle = f_create (filename);
   ;	
	push	di
	call	near ptr _f_create
	push	dx
	push	ax
	pop	eax
	pop	cx
	les	bx,dword ptr DGROUP:_f
	mov	dword ptr es:[bx],eax
   ;	
   ;	  if (f->handle <2)
   ;	
	les	bx,dword ptr DGROUP:_f
	cmp	dword ptr es:[bx],large 2
	jae	short @13@338
	jmp	@13@142
@13@338:
   ;	
   ;	  {
   ;	   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   ;	   free (dc);
   ;	   return (FILE*)0;
   ;	  }
   ;	  return (f);
   ;	
	mov	dx,word ptr DGROUP:_f+2
	mov	ax,word ptr DGROUP:_f
	jmp	@13@198
@13@366:
	jmp	@13@170
@13@394:
   ;	
   ;	 }
   ;	 return (FILE*)0;
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
	assume	cs:_TEXT
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
	les	bx,dword ptr [bp+10]
	push	word ptr es:[bx+4]
	push	word ptr [bp+4]
	push	cs
	call	near ptr _memcpy
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
	assume	cs:_TEXT
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
	les	bx,dword ptr [bp+10]
	push	word ptr es:[bx+4]
	call	near ptr _memcpy
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
	les	bx,dword ptr [bp+10]
	mov	ax,word ptr es:[bx+6]
	les	bx,dword ptr [bp+10]
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
	assume	cs:_TEXT
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
	les	bx,dword ptr [bp+4]
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
	les	bx,dword ptr [bp+4]
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
	assume	cs:_TEXT
_fgetc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 if (fd->bofs == fd->size) { f_stat = 1; return 0; }
   ;	
	les	bx,dword ptr [bp+4]
	mov	ax,word ptr es:[bx+6]
	les	bx,dword ptr [bp+4]
	cmp	ax,word ptr es:[bx+8]
	jne	short @17@114
	mov	byte ptr DGROUP:_f_stat,1
	mov	al,0
@17@86:
	jmp	short @17@142
@17@114:
   ;	
   ;	 memcpy (_CS,(unsigned int)&(static_c),fd->bseg,fd->bofs,1);
   ;	
	push	1
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+6]
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+4]
	push	offset DGROUP:static_c
	push	cs
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	 fd->bofs++;
   ;	
	les	bx,dword ptr [bp+4]
	inc	word ptr es:[bx+6]
   ;	
   ;	 return static_c;
   ;	
	mov	al,byte ptr DGROUP:static_c
	jmp	short @17@86
@17@142:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fgetc	endp
   ;	
   ;	char* fgets(char* buf, int len, FILE *f)
   ;	
	assume	cs:_TEXT
_fgets	proc	near
	enter	4,0
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
	mov	byte ptr DGROUP:_f_stat,0
	jmp	short @18@170
@18@58:
   ;	
   ;	   while((c++ < (len-1)) && (!f_stat) ) {
   ;	      f_stat = 0;
   ;	
	mov	byte ptr DGROUP:_f_stat,0
   ;	
   ;	      ch = fgetc (f);
   ;	
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	call	near ptr _fgetc
	add	sp,4
	mov	byte ptr [bp-3],al
   ;	
   ;	      if(ch == '\r')
   ;	
	cmp	byte ptr [bp-3],13
	jne	short @18@114
   ;	
   ;	         continue;
   ;	
	jmp	short @18@170
@18@114:
   ;	
   ;	      *p++ = ch;
   ;	
	mov	al,byte ptr [bp-3]
	mov	byte ptr [si],al
	inc	si
   ;	
   ;	      if(ch == '\n')
   ;	
	cmp	byte ptr [bp-3],10
	jne	short @18@170
   ;	
   ;	         break;
   ;	
	jmp	short @18@226
@18@170:
	mov	ax,word ptr [bp-2]
	inc	word ptr [bp-2]
	mov	dx,word ptr [bp+6]
	dec	dx
	cmp	ax,dx
	jge	short @18@226
	mov	al,byte ptr DGROUP:_f_stat
	cbw	
	or	ax,ax
	je	short @18@58
@18@226:
   ;	
   ;	   }
   ;	
   ;	   if(!f_stat)
   ;	
	mov	al,byte ptr DGROUP:_f_stat
	cbw	
	or	ax,ax
	jne	short @18@310
   ;	
   ;	      return(0);
   ;	
	xor	ax,ax
@18@282:
	jmp	short @18@338
@18@310:
   ;	
   ;	   *p++ = 0;
   ;	
	mov	byte ptr [si],0
	inc	si
   ;	
   ;	   return (buf);
   ;	
	mov	ax,di
	jmp	short @18@282
@18@338:
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
	assume	cs:_TEXT
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
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+4]
	push	0
	les	bx,dword ptr [bp+4]
	movzx	eax,word ptr es:[bx+8]
	push	eax
	les	bx,dword ptr [bp+4]
	push	dword ptr es:[bx]
	call	near ptr _f_write
	add	sp,12
@19@86:
   ;	
   ;	 free (fd->bseg);
   ;	
	les	bx,dword ptr [bp+4]
	push	word ptr es:[bx+4]
	call	near ptr _free
	pop	cx
   ;	
   ;	 dc = (unsigned int) ( (unsigned long)(fd) >> 16 );
   ;	
	mov	eax,dword ptr [bp+4]
	shr	eax,16
	mov	word ptr DGROUP:_dc,ax
   ;	
   ;	 free (dc);
   ;	
	push	word ptr DGROUP:_dc
	call	near ptr _free
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
	assume	cs:_TEXT
_fsize	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 return (f_size ( f->handle ) );
   ;	
	les	bx,dword ptr [bp+4]
	push	dword ptr es:[bx]
	call	near ptr _f_size
	add	sp,4
	jmp	short @20@58
@20@58:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_fsize	endp
_TEXT	ends
_BSS	segment word public use16 'BSS'
static_c	label	byte
	db	1 dup (?)
_dc	label	word
	db	2 dup (?)
_f	label	dword
	db	4 dup (?)
	?debug	C E9
	?debug	C FA00000000
_BSS	ends
_DATA	segment word public use16 'DATA'
s@	label	byte
	db	'<NULL>'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
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