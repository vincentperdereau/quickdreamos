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
	?debug	S "winpal.c"
	?debug	C E96282192B0877696E70616C2E63
	?debug	C E9807B192B0A717569636B77696E2E68
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
   ;	 Init ();
   ;	
	call	near ptr MGRP:_Init
   ;	
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
   ;	HWND CreateWindow (int x, int y, int w, int h, char* title, void far (*WinMain) )
   ;	
	assume	cs:MGRP
_CreateWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x01;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],1
   ;	
   ;	 SysBuf->byte1 = 3;
   ;	
	mov	byte ptr es:[bx+1],3
   ;	
   ;	 SysBuf->word1 = x;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr es:[bx+3],ax
   ;	
   ;	 SysBuf->word2 = y;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr es:[bx+5],ax
   ;	
   ;	 SysBuf->word3 = w;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+7],ax
   ;	
   ;	 SysBuf->word4 = h,
   ;	
   ;	
   ;	 SysBuf->word5 = _CS;
   ;	
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx+9],ax
	mov	word ptr es:[bx+11],cs
   ;	
   ;	 SysBuf->word6 = (unsigned int)title;
   ;	
	mov	ax,word ptr [bp+12]
	mov	word ptr es:[bx+13],ax
   ;	
   ;	 WManager ;
   ;	
 	int	 048H 
   ;	
   ;	 SysBuf->function = 0x02;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],2
   ;	
   ;	 SysBuf->word3 = _CS;
   ;	
	mov	word ptr es:[bx+7],cs
   ;	
   ;	 SysBuf->word4 = (unsigned int)WinMain;
   ;	
	mov	ax,word ptr [bp+14]
	mov	word ptr es:[bx+9],ax
   ;	
   ;	 WManager ;
   ;	
 	int	 048H 
   ;	
   ;	
   ;	 return (HWND)SysBuf->dword1;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	dx,word ptr es:[bx+17]
	mov	ax,word ptr es:[bx+15]
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_CreateWindow	endp
   ;	
   ;	CONTROL CreateControl (unsigned int x, unsigned int y, unsigned int w,
   ;	
	assume	cs:MGRP
_CreateControl	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	                       unsigned int h, HWND hWnd, unsigned char ID, unsigned char ControlType,
   ;	                       unsigned int CapSegment, unsigned int CapOffset, unsigned int size)
   ;	{
   ;	 SysBuf->function = 0x09;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],9
   ;	
   ;	 SysBuf->word1 = x;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr es:[bx+3],ax
   ;	
   ;	 SysBuf->word2 = y;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr es:[bx+5],ax
   ;	
   ;	 SysBuf->word3 = w;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+7],ax
   ;	
   ;	 SysBuf->word4 = h;
   ;	
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx+9],ax
   ;	
   ;	 SysBuf->dword1 = (unsigned long) hWnd;
   ;	
	mov	eax,dword ptr [bp+12]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 SysBuf->byte1 = ID;
   ;	
	mov	al,byte ptr [bp+16]
	mov	byte ptr es:[bx+1],al
   ;	
   ;	 SysBuf->byte2 = ControlType;
   ;	
	mov	al,byte ptr [bp+18]
	mov	byte ptr es:[bx+2],al
   ;	
   ;	 SysBuf->word5 = CapSegment;
   ;	
	mov	ax,word ptr [bp+20]
	mov	word ptr es:[bx+11],ax
   ;	
   ;	 SysBuf->word6 = CapOffset;
   ;	
	mov	ax,word ptr [bp+22]
	mov	word ptr es:[bx+13],ax
   ;	
   ;	 SysBuf->word7 = size;
   ;	
	mov	ax,word ptr [bp+24]
	mov	word ptr es:[bx+19],ax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	 return (CONTROL)SysBuf->dword1;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	dx,word ptr es:[bx+17]
	mov	ax,word ptr es:[bx+15]
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_CreateControl	endp
   ;	
   ;	void DestroyWindow (HWND hWnd)
   ;	
	assume	cs:MGRP
_DestroyWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x20;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],32
   ;	
   ;	 SysBuf->dword1 = (unsigned long)hWnd;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_DestroyWindow	endp
   ;	
   ;	void OutTextXY (unsigned int x, unsigned int y, char* caption, HWND hWnd)
   ;	
	assume	cs:MGRP
_OutTextXY	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x03;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],3
   ;	
   ;	 SysBuf->dword1 = (unsigned long)hWnd;
   ;	
	mov	eax,dword ptr [bp+10]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 SysBuf->word1 = x;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr es:[bx+3],ax
   ;	
   ;	 SysBuf->word2 = y;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr es:[bx+5],ax
   ;	
   ;	 SysBuf->word5 = _CS;
   ;	
	mov	word ptr es:[bx+11],cs
   ;	
   ;	 SysBuf->word6 = (unsigned int)caption;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+13],ax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_OutTextXY	endp
   ;	
   ;	void CommandTerm (char* cmd, char scr)
   ;	
	assume	cs:MGRP
_CommandTerm	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x18;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],24
   ;	
   ;	 SysBuf->word5 = _CS;
   ;	
	mov	word ptr es:[bx+11],cs
   ;	
   ;	 SysBuf->word6 = (unsigned int)cmd;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr es:[bx+13],ax
   ;	
   ;	 SysBuf->byte1 = scr;
   ;	
	mov	al,byte ptr [bp+6]
	mov	byte ptr es:[bx+1],al
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_CommandTerm	endp
   ;	
   ;	void ShowIcon (unsigned int x, unsigned int y, char* fIcon, HWND hWnd)
   ;	
	assume	cs:MGRP
_ShowIcon	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x19;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],25
   ;	
   ;	 SysBuf->word1 = x;
   ;	
	mov	ax,word ptr [bp+4]
	mov	word ptr es:[bx+3],ax
   ;	
   ;	 SysBuf->word2 = y;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr es:[bx+5],ax
   ;	
   ;	 SysBuf->word5 = _CS;
   ;	
	mov	word ptr es:[bx+11],cs
   ;	
   ;	 SysBuf->word6 = (unsigned int)fIcon;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+13],ax
   ;	
   ;	 SysBuf->dword1 = (unsigned long)hWnd;
   ;	
	mov	eax,dword ptr [bp+10]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_ShowIcon	endp
   ;	
   ;	void UpdateTextArea (CONTROL dumControl, unsigned int size)
   ;	
	assume	cs:MGRP
_UpdateTextArea	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x21;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],33
   ;	
   ;	 SysBuf->word1 = size;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+3],ax
   ;	
   ;	 SysBuf->dword1 = (unsigned long)dumControl;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_UpdateTextArea	endp
   ;	
   ;	unsigned int SizeTextArea (CONTROL dumControl)
   ;	
	assume	cs:MGRP
_SizeTextArea	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x22;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],34
   ;	
   ;	 SysBuf->dword1 = (unsigned long)dumControl;
   ;	
	mov	eax,dword ptr [bp+4]
	mov	dword ptr es:[bx+15],eax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	 return (SysBuf->word1);
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	ax,word ptr es:[bx+3]
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_SizeTextArea	endp
   ;	
   ;	void Init (void)
   ;	
	assume	cs:MGRP
_Init	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	     mov ah,4
   ;	
	mov	 ah,4
   ;	
   ;	     int 0x46
   ;	
	int	 046H
   ;	
   ;	     mov cs:SysBufSegment,bx
   ;	
	mov	 cs:MGRP:_SysBufSegment,bx
   ;	
   ;	     mov cs:SysBufOffset,cx
   ;	
	mov	 cs:MGRP:_SysBufOffset,cx
   ;	
   ;	     }
   ;	 SysBuf = (SB far*) (SysBufSegment * 65536 + SysBufOffset);
   ;	
	movzx	eax,word ptr MGRP:_SysBufSegment
	shl	eax,16
	movzx	edx,word ptr MGRP:_SysBufOffset
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr MGRP:_SysBuf+2,dx
	mov	word ptr MGRP:_SysBuf,ax
   ;	
   ;	}
   ;	
	ret	
_Init	endp
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
   ;	void far WinMain (void)
   ;	
	assume	cs:MGRP
_WinMain	proc	far
   ;	
   ;	{
   ;	 FuncEntry
   ;	
	mov	ax,ds
	mov	bx,cs
	mov	ds,bx
	mov	word ptr MGRP:DataSegment,ax
   ;	
   ;	
   ;	  if (WM_MESSAGE == WINDOW_DESTROY)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],176
	jne	short @17@58
   ;	
   ;	   close
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@17@58:
   ;	
   ;	  if (WM_MESSAGE == CONTROL_BUTTON)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],193
	je short	@@0
	jmp	@17@814
@@0:
   ;	
   ;	  {
   ;	   switch (WM_PARAM)
   ;	
	mov	al,byte ptr es:[bx+2]
	mov	ah,0
	dec	ax
	mov	bx,ax
	cmp	bx,8
	jbe short	@@1
	jmp	@17@786
@@1:
	shl	bx,1
	jmp	word ptr cs:@17@C882[bx]
@17@170:
   ;	
   ;	   {
   ;	    case RED_PLUS: ( Obj == 1 ) ? Pal[0] ++ : Pal[3]++ ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@226
	inc	byte ptr MGRP:_Pal
	mov	al,byte ptr MGRP:_Pal
	jmp	short @17@254
@17@226:
	inc	byte ptr MGRP:_Pal+3
	mov	al,byte ptr MGRP:_Pal+3
@17@254:
	jmp	@17@786
@17@282:
   ;	
   ;	    case RED_LESS: ( Obj == 1 ) ? Pal[0] -- : Pal[3]-- ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@338
	dec	byte ptr MGRP:_Pal
	mov	al,byte ptr MGRP:_Pal
	jmp	short @17@254
@17@338:
	dec	byte ptr MGRP:_Pal+3
	mov	al,byte ptr MGRP:_Pal+3
	jmp	short @17@254
@17@366:
   ;	
   ;	    case GREEN_PLUS: ( Obj == 1 ) ? Pal[1] ++ : Pal[4]++ ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@422
	inc	byte ptr MGRP:_Pal+1
	mov	al,byte ptr MGRP:_Pal+1
	jmp	short @17@254
@17@422:
	inc	byte ptr MGRP:_Pal+4
	mov	al,byte ptr MGRP:_Pal+4
	jmp	short @17@254
@17@450:
   ;	
   ;	    case GREEN_LESS: ( Obj == 1 ) ? Pal[1] -- : Pal[4]-- ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@506
	dec	byte ptr MGRP:_Pal+1
	mov	al,byte ptr MGRP:_Pal+1
	jmp	short @17@254
@17@506:
	dec	byte ptr MGRP:_Pal+4
	mov	al,byte ptr MGRP:_Pal+4
	jmp	short @17@254
@17@534:
   ;	
   ;	    case BLUE_PLUS: ( Obj == 1 ) ? Pal[2] ++ : Pal[5]++ ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@590
	inc	byte ptr MGRP:_Pal+2
	mov	al,byte ptr MGRP:_Pal+2
	jmp	short @17@254
@17@590:
	inc	byte ptr MGRP:_Pal+5
	mov	al,byte ptr MGRP:_Pal+5
	jmp	short @17@254
@17@618:
   ;	
   ;	    case BLUE_LESS: ( Obj == 1 ) ? Pal[2] -- : Pal[5]-- ; break;
   ;	
	cmp	byte ptr MGRP:_Obj,1
	jne	short @17@674
	dec	byte ptr MGRP:_Pal+2
	mov	al,byte ptr MGRP:_Pal+2
	jmp	@17@254
@17@674:
	dec	byte ptr MGRP:_Pal+5
	mov	al,byte ptr MGRP:_Pal+5
	jmp	@17@254
@17@702:
   ;	
   ;	    case WIN:  Obj = 3; break;
   ;	
	mov	byte ptr MGRP:_Obj,3
	jmp	short @17@786
@17@730:
   ;	
   ;	    case BACKGROUND: Obj = 1; break;
   ;	
	mov	byte ptr MGRP:_Obj,1
	jmp	short @17@786
@17@758:
   ;	
   ;	    case SAVE:
   ;	     fwrite (palfile,8,&Pal,_CS);
   ;	
	push	cs
	push	offset MGRP:_Pal
	push	large 8
	push	dword ptr MGRP:_palfile
	call	near ptr MGRP:_fwrite
	add	sp,12
   ;	
   ;	     DestroyWindow (MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
   ;	
   ;	     close
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@17@786:
   ;	
   ;	   }
   ;	  SetRGB (1,Pal[0],Pal[1],Pal[2]);
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
   ;	  SetRGB (3,Pal[3],Pal[4],Pal[5]);
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
@17@814:
   ;	
   ;	  }
   ;	
   ;	 FuncEnd
   ;	
	mov	ax,word ptr MGRP:DataSegment
	mov	ds,ax
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_WinMain	endp
@17@C882	label	word
	dw	@17@170
	dw	@17@366
	dw	@17@534
	dw	@17@282
	dw	@17@450
	dw	@17@618
	dw	@17@758
	dw	@17@702
	dw	@17@730
_Plus	label	byte
	db	43
	db	0
_Less	label	byte
	db	45
	db	0
_Window	label	byte
	db	87
	db	105
	db	110
	db	100
	db	111
	db	119
	db	0
_Desktop	label	byte
	db	68
	db	101
	db	115
	db	107
	db	116
	db	111
	db	112
	db	0
_Save	label	byte
	db	83
	db	97
	db	118
	db	101
	db	0
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 MyWindow = CreateWindow (150,150,240,95,"Colors",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@
	push	large 0005F00F0h
	push	large 000960096h
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	 Obj = 1;
   ;	
	mov	byte ptr MGRP:_Obj,1
   ;	
   ;	
   ;	 OutTextXY (10,35,"Red",MyWindow);
   ;	
	push	dx
	push	ax
	push	offset MGRP:s@+7
	push	large 00023000Ah
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	 OutTextXY (50+20,35,"Green",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+11
	push	large 000230046h
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	 OutTextXY (90+40,35,"Blue",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+17
	push	large 000230082h
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	
   ;	 CreateControl (10,50,15,15,MyWindow,RED_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
   ;	
	push	0
	push	offset MGRP:_Plus
	push	cs
	push	1
	push	1
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 00032000Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (25,50,15,15,MyWindow,RED_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);                                    
   ;	
	push	0
	push	offset MGRP:_Less
	push	cs
	push	1
	push	4
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 000320019h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	
   ;	 CreateControl (50+20,50,15,15,MyWindow,GREEN_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
   ;	
	push	0
	push	offset MGRP:_Plus
	push	cs
	push	1
	push	2
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 000320046h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (65+20,50,15,15,MyWindow,GREEN_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);
   ;	
	push	0
	push	offset MGRP:_Less
	push	cs
	push	1
	push	5
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 000320055h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	
   ;	 CreateControl (90+40,50,15,15,MyWindow,BLUE_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
   ;	
	push	0
	push	offset MGRP:_Plus
	push	cs
	push	1
	push	3
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 000320082h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (105+40,50,15,15,MyWindow,BLUE_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);                               
   ;	
	push	0
	push	offset MGRP:_Less
	push	cs
	push	1
	push	6
	push	dword ptr MGRP:_MyWindow
	push	large 0000F000Fh
	push	large 000320091h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	
   ;	 CreateControl (10,10,80,20,MyWindow,WIN,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Window,0);
   ;	
	push	0
	push	offset MGRP:_Window
	push	cs
	push	1
	push	8
	push	dword ptr MGRP:_MyWindow
	push	large 000140050h
	push	large 0000A000Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (90,10,80,20,MyWindow,BACKGROUND,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Desktop,0);
   ;	
	push	0
	push	offset MGRP:_Desktop
	push	cs
	push	1
	push	9
	push	dword ptr MGRP:_MyWindow
	push	large 000140050h
	push	large 0000A005Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (190,10,40,20,MyWindow,SAVE,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Save,0);
   ;	
	push	0
	push	offset MGRP:_Save
	push	cs
	push	1
	push	7
	push	dword ptr MGRP:_MyWindow
	push	large 000140028h
	push	large 0000A00BEh
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	
   ;	 ShowIcon (195,38,"/qwin/color.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+22
	push	large 0002600C3h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	
   ;	 palfile = fopen ("/qwin/win.pal");
   ;	
	push	offset MGRP:s@+38
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_palfile,eax
   ;	
   ;	 fread (palfile,8,&Pal,_CS);
   ;	
	push	cs
	push	offset MGRP:_Pal
	push	large 8
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_MyWindow	label	dword
	db	4 dup (0)
_Obj	label	byte
	db	1 dup (0)
_Pal	label	byte
	db	8 dup (0)
_palfile	label	word
	db	4 dup (0)
_SysBufOffset	label	word
	db	2 dup (0)
_SysBufSegment	label	word
	db	2 dup (0)
dumWnd	label	word
	db	2 dup (0)
_SysBuf	label	dword
	db	4 dup (0)
DataSegment	label	word
	db	2 dup (0)
	?debug	C E9
	?debug	C FA00000000
s@	label	byte
	db	'Colors'
	db	0
	db	'Red'
	db	0
	db	'Green'
	db	0
	db	'Blue'
	db	0
	db	'/qwin/color.ico'
	db	0
	db	'/qwin/win.pal'
	db	0
VPSEG	ends
	public	_Save
	public	_Desktop
	public	_Window
	public	_Less
	public	_Plus
	public	_WinMain
	public	_MyWindow
	public	_Obj
	public	_Pal
	public	_palfile
	public	_SetRGB
	public	_fwrite
	public	_fread
	public	_fopen
	public	_SysBufOffset
	public	_SysBufSegment
	public	_SizeTextArea
	public	_UpdateTextArea
	public	_ShowIcon
	public	_CommandTerm
	public	_OutTextXY
	public	_DestroyWindow
	public	_CreateControl
	public	_CreateWindow
_dumWnd	equ	dumWnd
	public	_free
	public	_malloc
	public	_SysBuf
_DataSegment	equ	DataSegment
	public	_main
	public	_Init
	public	_StartProgram
_s@	equ	s@
	end
