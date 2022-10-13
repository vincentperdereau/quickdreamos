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
	?debug	S "test.c"
	?debug	C E9796D012B06746573742E63
	?debug	C E9E459012B092E5C737464696F2E68
	?debug	C E9CEA19B270A2E5C737472696E672E68
	?debug	C E945979C270A2E5C6D656D6F72792E68
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
   ;	 void hex_byte (unsigned char b,char cas)
   ;	
	assume	cs:_TEXT
_hex_byte	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	 {
   ;	  char letter;
   ;	
   ;	  if (cas == 'x') letter = 'a';
   ;	
	cmp	byte ptr [bp+6],120
	jne	short @1@86
	mov	byte ptr [bp-1],97
	jmp	short @1@114
@1@86:
   ;	
   ;	  else letter = 'A';
   ;	
	mov	byte ptr [bp-1],65
@1@114:
   ;	
   ;	  if ( (b>>4) > 9 ) putc ( (b>>4) + letter - 10 );
   ;	
	mov	al,byte ptr [bp+4]
	mov	ah,0
	sar	ax,4
	mov	dx,ax
	cmp	ax,9
	jle	short @1@170
	add	al,byte ptr [bp-1]
	add	al,246
	push	ax
	call	near ptr _putc
	add	sp,2
	jmp	short @1@198
@1@170:
   ;	
   ;	  else  putc ( (b>>4) + '0' );
   ;	
	mov	ax,dx
	add	al,48
	push	ax
	call	near ptr _putc
	add	sp,2
@1@198:
   ;	
   ;	  if ( (b & 0x0f) > 9 ) putc ( (b & 0x0f) + letter - 10 );
   ;	
	mov	al,byte ptr [bp+4]
	mov	ah,0
	and	ax,15
	cmp	ax,9
	jle	short @1@254
	mov	al,byte ptr [bp+4]
	and	al,15
	add	al,byte ptr [bp-1]
	add	al,246
	push	ax
	call	near ptr _putc
	add	sp,2
	leave	
	ret	
@1@254:
   ;	
   ;	  else  putc ( (b & 0x0f) + '0' );
   ;	
	mov	al,byte ptr [bp+4]
	and	al,15
	add	al,48
	push	ax
	call	near ptr _putc
	add	sp,2
   ;	
   ;	 }
   ;	
	leave	
	ret	
_hex_byte	endp
   ;	
   ;	void main(int argc, char** argv)
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+6]
   ;	
   ;	{
   ;	   mf = fopen(argv[1],"rb");
   ;	
	push	offset DGROUP:s@
	push	word ptr [si+2]
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_mf+2,dx
	mov	word ptr DGROUP:_mf,ax
   ;	
   ;	   if (mf)
   ;	
	cmp	dword ptr DGROUP:_mf,large 0
	jne short	@@0
	jmp	@2@338
@@0:
   ;	
   ;	   {
   ;	    fsz = fsize (mf);
   ;	
	push	dx
	push	ax
	call	near ptr _fsize
	shl	eax,16
	shrd	eax,edx,16
	add	sp,4
	mov	dword ptr DGROUP:_fsz,eax
   ;	
   ;	    putc (13); putc (10);
   ;	
	push	13
	call	near ptr _putc
	add	sp,2
	push	10
	call	near ptr _putc
	add	sp,2
   ;	
   ;	    if ( !strcmp (argv[2],"/x")) for ( ; fsz ; fsz--) hex_byte (fgetc (mf),'X');
   ;	
	push	offset DGROUP:s@+3
	push	word ptr [si+4]
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @2@282
	jmp	short @2@170
@2@114:
	push	88
	push	dword ptr DGROUP:_mf
	call	near ptr _fgetc
	add	sp,4
	push	ax
	call	near ptr _hex_byte
	add	sp,4
	dec	dword ptr DGROUP:_fsz
@2@170:
	cmp	dword ptr DGROUP:_fsz,large 0
	jne	short @2@114
	jmp	short @2@282
@2@226:
   ;	
   ;	    for ( ; fsz ; fsz--) putc (fgetc (mf));
   ;	
	push	dword ptr DGROUP:_mf
	call	near ptr _fgetc
	add	sp,4
	push	ax
	call	near ptr _putc
	add	sp,2
	dec	dword ptr DGROUP:_fsz
@2@282:
	cmp	dword ptr DGROUP:_fsz,large 0
	jne	short @2@226
   ;	
   ;	    fclose(mf);
   ;	
	push	dword ptr DGROUP:_mf
	call	near ptr _fclose
	add	sp,4
@2@338:
   ;	
   ;	   }
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_main	endp
_TEXT	ends
VP	segment word public use16 'BSS'
_fsz	label	word
	db	4 dup (?)
_mf	label	dword
	db	4 dup (?)
	?debug	C E9
	?debug	C FA11000000
VP	ends
_DATA	segment word public use16 'VP'
s@	label	byte
	db	'rb'
	db	0
	db	'/x'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	extrn	__setargv__:far
	public	_main
	public	_hex_byte
	public	_fsz
	public	_mf
	extrn	_strcmp:near
	extrn	_fgetc:near
	extrn	_fsize:near
	extrn	_fclose:near
	extrn	_fopen:near
	extrn	_putc:near
_s@	equ	s@
	end
