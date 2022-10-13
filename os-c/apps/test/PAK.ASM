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
	?debug	S "pak.c"
	?debug	C E98D709C270570616B2E63
	?debug	C E929739C27092E5C737464696F2E68
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
   ;	void main (int argc, char **argv)
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 if (argc < 3)
   ;	
	cmp	word ptr [bp+4],3
	jge	short @1@86
   ;	
   ;	 {
   ;	  printf ("\nsyntax: %s file1 file2 filepak",argv[0]);
   ;	
	push	word ptr [di]
	push	offset DGROUP:s@
	call	near ptr _printf
	add	sp,4
   ;	
   ;	  return;
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
@1@86:
   ;	
   ;	 }
   ;	 asm { push si };
   ;	
 	push	 si 
   ;	
   ;	 output = fopen (argv[argc-1],"wb");
   ;	
	push	offset DGROUP:s@+32
	mov	bx,word ptr [bp+4]
	shl	bx,1
	add	bx,di
	push	word ptr [bx-2]
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_output,ax
   ;	
   ;	 asm { pop si }
   ;	
 	pop	 si 
   ;	
   ;	 puts (argv[1]);
   ;	
	push	word ptr [di+2]
	call	near ptr _puts
	add	sp,2
   ;	
   ;	
   ;	 if (output==(0))
   ;	
	cmp	word ptr DGROUP:_output,0
	jne	short @1@226
   ;	
   ;	 {
   ;	  printf ("\n ** can't create .pak file");
   ;	
	push	offset DGROUP:s@+35
	call	near ptr _printf
	add	sp,2
   ;	
   ;	  return;
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
@1@226:
   ;	
   ;	 }
   ;	 offset = 0;
   ;	
	mov	word ptr DGROUP:_offset,0
   ;	
   ;	
   ;	 for (i=1; i <= (argc-2); i++)
   ;	
	mov	word ptr DGROUP:_i,1
	jmp	@1@450
@1@254:
   ;	
   ;	 {
   ;	  asm { push si };
   ;	
 	push	 si 
   ;	
   ;	  input = fopen (argv[i],"rb");
   ;	
	push	offset DGROUP:s@+63
	mov	bx,word ptr DGROUP:_i
	shl	bx,1
	push	word ptr [bx+di]
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_input,ax
   ;	
   ;	  asm { pop si };
   ;	
 	pop	 si 
   ;	
   ;	  if (input==(0)) {
   ;	
	cmp	word ptr DGROUP:_input,0
	jne	short @1@394
   ;	
   ;	                     printf ("\n ** can't open %s <%u>",argv[i],i);
   ;	
	push	word ptr DGROUP:_i
	mov	bx,word ptr DGROUP:_i
	shl	bx,1
	push	word ptr [bx+di]
	push	offset DGROUP:s@+66
	call	near ptr _printf
	add	sp,6
   ;	
   ;	                     fclose (output);
   ;	
	push	word ptr DGROUP:_output
	call	near ptr _fclose
	add	sp,2
   ;	
   ;	                     return;
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
@1@394:
   ;	
   ;	                   }
   ;	  buffer = malloc (((input->size)>>4)+1);
   ;	
	mov	bx,word ptr DGROUP:_input
	mov	ax,word ptr [bx+8]
	shr	ax,4
	inc	ax
	push	ax
	call	near ptr _malloc
	add	sp,2
	mov	word ptr DGROUP:_buffer,ax
   ;	
   ;	  fread (buffer,(input->size),1,input);
   ;	
	push	word ptr DGROUP:_input
	push	1
	mov	bx,word ptr DGROUP:_input
	push	word ptr [bx+8]
	push	ax
	call	near ptr _fread
	add	sp,8
   ;	
   ;	  fwrite (buffer,(input->size),1,output);
   ;	
	push	word ptr DGROUP:_output
	push	1
	mov	bx,word ptr DGROUP:_input
	push	word ptr [bx+8]
	push	word ptr DGROUP:_buffer
	call	near ptr _fwrite
	add	sp,8
   ;	
   ;	  fclose (input);
   ;	
	push	word ptr DGROUP:_input
	call	near ptr _fclose
	add	sp,2
	inc	word ptr DGROUP:_i
@1@450:
	mov	ax,word ptr [bp+4]
	add	ax,-2
	cmp	ax,word ptr DGROUP:_i
	jl short	@@0
	jmp	@1@254
@@0:
   ;	
   ;	 }
   ;	 printf ("\nwritting %u bytes",(output->size));
   ;	
	mov	bx,word ptr DGROUP:_output
	push	word ptr [bx+8]
	push	offset DGROUP:s@+90
	call	near ptr _printf
	add	sp,4
   ;	
   ;	 fclose (output);
   ;	
	push	word ptr DGROUP:_output
	call	near ptr _fclose
	add	sp,2
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_main	endp
_TEXT	ends
VP	segment word public use16 'BSS'
_str	label	word
	db	2 dup (?)
_i	label	word
	db	2 dup (?)
_offset	label	word
	db	2 dup (?)
_buffer	label	word
	db	2 dup (?)
_output	label	word
	db	2 dup (?)
_input	label	word
	db	2 dup (?)
	?debug	C E9
	?debug	C FA10000000
VP	ends
_DATA	segment word public use16 'VP'
s@	label	byte
	db	10
	db	'syntax: %s file1 file2 filepak'
	db	0
	db	'wb'
	db	0
	db	10
	db	' ** can'
	db	39
	db	't create .pak file'
	db	0
	db	'rb'
	db	0
	db	10
	db	' ** can'
	db	39
	db	't open %s <%u>'
	db	0
	db	10
	db	'writting %u bytes'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	extrn	__setargv__:far
	public	_main
	public	_str
	public	_i
	public	_offset
	public	_buffer
	public	_output
	public	_input
	extrn	_malloc:near
	extrn	_fclose:near
	extrn	_fwrite:near
	extrn	_fread:near
	extrn	_fopen:near
	extrn	_puts:near
	extrn	_printf:near
_s@	equ	s@
	end
