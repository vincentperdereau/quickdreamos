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
	?debug	S "np.c"
	?debug	C E9A258F158046E702E63
	?debug	C E93D51BF580A717569636B77696E2E68
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
   ;	 asm {
   ;	       mov      ax,0x0601
   ;	
	mov	      ax,00601H
   ;	
   ;	       int      0x46
   ;	
	int	      046H
   ;	
   ;	 }
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
   ;			       unsigned int h, HWND hWnd, unsigned char ID, unsigned char ControlType,
   ;			       unsigned int CapSegment, unsigned int CapOffset, unsigned int size)
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
   ;	void ProtectWindow (HWND hWnd)
   ;	
	assume	cs:MGRP
_ProtectWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x23;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],35
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
_ProtectWindow	endp
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
   ;	void ExitWindows (void)
   ;	
	assume	cs:MGRP
_ExitWindows	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x11;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],17
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_ExitWindows	endp
   ;	
   ;	void InitFullApp (void)
   ;	
	assume	cs:MGRP
_InitFullApp	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x24;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],36
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
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
   ;	 SysBuf->function = 0x25;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],37
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_CloseFullApp	endp
   ;	
   ;	void mem (void)
   ;	
	assume	cs:MGRP
_mem	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x29;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],41
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_mem	endp
   ;	
   ;	void halt (void)
   ;	
	assume	cs:MGRP
_halt	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x28;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],40
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_halt	endp
   ;	
   ;	void about (void)
   ;	
	assume	cs:MGRP
_about	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x27;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],39
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_about	endp
   ;	
   ;	void FullShell (void)
   ;	
	assume	cs:MGRP
_FullShell	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x26;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],38
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	ret	
_FullShell	endp
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
   ;	void Bar (unsigned int x, unsigned int y, unsigned int w, unsigned int h)
   ;	
	assume	cs:MGRP
_Bar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x14;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],20
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
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_Bar	endp
   ;	
   ;	void Rectangle (unsigned int x, unsigned int y, unsigned int x2, unsigned int y2)
   ;	
	assume	cs:MGRP
_Rectangle	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x15;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],21
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
   ;	 SysBuf->word3 = x2;
   ;	
	mov	ax,word ptr [bp+8]
	mov	word ptr es:[bx+7],ax
   ;	
   ;	 SysBuf->word4 = y2;
   ;	
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx+9],ax
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_Rectangle	endp
   ;	
   ;	void SetColor (unsigned char color)
   ;	
	assume	cs:MGRP
_SetColor	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x05;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],5
   ;	
   ;	 SysBuf->byte1 = color;
   ;	
	mov	al,byte ptr [bp+4]
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
_SetColor	endp
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
   ;	unsigned char getmode (void)
   ;	
	assume	cs:MGRP
_getmode	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x30;
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	byte ptr es:[bx],48
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	 return (SysBuf->byte1);
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	mov	al,byte ptr es:[bx+1]
   ;	
   ;	}
   ;	
	ret	
_getmode	endp
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
_filename	label	byte
	db	0
	db	29 dup (0)
   ;	
   ;	void ClearText (unsigned int SegText)
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
   ;		push    si
   ;	
	push	    si
   ;	
   ;		push    ds
   ;	
	push	    ds
   ;	
   ;		mov     ax,cs
   ;	
	mov	     ax,cs
   ;	
   ;		mov     ds,ax
   ;	
	mov	     ds,ax
   ;	
   ;		mov     ah,0x0003
   ;	
	mov	     ah,00003H
   ;	
   ;		mov     si,fname
   ;	
	mov	     si,[bp+4]
   ;	
   ;		int     0x44
   ;	
	int	     044H
   ;	
   ;		mov     edx,eax
   ;	
	mov	     edx,eax
   ;	
   ;		shr     edx,16
   ;	
	shr	     edx,16
   ;	
   ;		pop     ds
   ;	
	pop	     ds
   ;	
   ;		pop     si
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
   ;		pop     edx
   ;	
	pop	     edx
   ;	
   ;		pop     ecx
   ;	
	pop	     ecx
   ;	
   ;		pop     si
   ;	
	pop	     si
   ;	
   ;		pop     ds
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
   ;	 char fremove (handle h)
   ;	
	assume	cs:MGRP
_fremove	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;		push    edx
   ;	
	push	    edx
   ;	
   ;		mov     ah,0x000d
   ;	
	mov	     ah,0000dH
   ;	
   ;		mov     edx,h
   ;	
	mov	     edx,[bp+4]
   ;	
   ;		int     0x44
   ;	
	int	     044H
   ;	
   ;		pop     edx
   ;	
	pop	     edx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_fremove	endp
_loaded	label	byte
	db	0
   ;	
   ;	void far WinMain (void)
   ;	
	assume	cs:MGRP
_WinMain	proc	far
   ;	
   ;	{
   ;	 FuncEntry
   ;	
 	cli	 
 	pusha	 
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
	jne	short @33@114
   ;	
   ;	  {
   ;	   free (MySegment);
   ;	
	push	word ptr MGRP:_MySegment
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 //  CloseFullApp ();
   ;	   close
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@33@114:
   ;	
   ;	  }
   ;	  if (WM_MESSAGE == CONTROL_BUTTON)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],193
	jne	short @33@226
   ;	
   ;	   if (WM_PARAM == BUTTON_LOAD)
   ;	
	cmp	byte ptr es:[bx+2],1
	jne	short @33@226
   ;	
   ;	   {
   ;	    fichier = fopen (filename);
   ;	
	push	offset MGRP:_filename
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fichier,eax
   ;	
   ;	    if (fichier >= 2)
   ;	
	cmp	dword ptr MGRP:_fichier,large 2
	jb	short @33@226
   ;	
   ;	    {
   ;	     ClearText (MySegment);
   ;	
	push	word ptr MGRP:_MySegment
	call	near ptr MGRP:_ClearText
	pop	cx
   ;	
   ;	     fread (fichier,fsize (fichier), 0, MySegment);
   ;	
	push	word ptr MGRP:_MySegment
	push	0
	push	dword ptr MGRP:_fichier
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_fichier
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	     UpdateTextArea (MyControl,(unsigned int)fsize (fichier));
   ;	
	push	dword ptr MGRP:_fichier
	call	near ptr MGRP:_fsize
	add	sp,4
	push	ax
	push	dword ptr MGRP:_MyControl
	call	near ptr MGRP:_UpdateTextArea
	add	sp,6
   ;	
   ;	     loaded = 1;
   ;	
	mov	byte ptr MGRP:_loaded,1
@33@226:
   ;	
   ;	    }
   ;	   }
   ;	   if (WM_PARAM == BUTTON_SAVE)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],2
	jne	short @33@366
   ;	
   ;	   {
   ;	    if (loaded) fremove (fichier);
   ;	
	cmp	byte ptr MGRP:_loaded,0
	je	short @33@310
	push	dword ptr MGRP:_fichier
	call	near ptr MGRP:_fremove
	add	sp,4
@33@310:
   ;	
   ;	    fichier = fcreate (filename);
   ;	
	push	offset MGRP:_filename
	call	near ptr MGRP:_fcreate
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fichier,eax
   ;	
   ;	    if (fichier >= 2)
   ;	
	cmp	dword ptr MGRP:_fichier,large 2
	jb	short @33@366
   ;	
   ;	     fwrite (fichier,(unsigned long)SizeTextArea (MyControl),0,MySegment);
   ;	
	push	word ptr MGRP:_MySegment
	push	0
	push	dword ptr MGRP:_MyControl
	call	near ptr MGRP:_SizeTextArea
	add	sp,4
	movzx	eax,ax
	push	eax
	push	dword ptr MGRP:_fichier
	call	near ptr MGRP:_fwrite
	add	sp,12
@33@366:
   ;	
   ;	   }
   ;	
   ;	 FuncEnd
   ;	
	mov	ax,word ptr MGRP:DataSegment
	mov	ds,ax
 	popa	 
 	sti	 
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_WinMain	endp
_ButtonCaption	label	byte
	db	101
	db	120
	db	105
	db	116
	db	0
_bSave	label	byte
	db	115
	db	97
	db	118
	db	101
	db	0
_bLoad	label	byte
	db	108
	db	111
	db	97
	db	100
	db	0
_d	label	word
	db	150
	db	0
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 //InitFullApp ();
   ;	 MyWindow = CreateWindow (0,0,605-d,410-d,"Notepad",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@
	mov	ax,410
	sub	ax,word ptr MGRP:_d
	push	ax
	mov	ax,605
	sub	ax,word ptr MGRP:_d
	push	ax
	push	large 0
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	 MySegment = malloc (0xff0);
   ;	
	push	4080
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_MySegment,ax
   ;	
   ;	 ClearText (MySegment);
   ;	
	push	ax
	call	near ptr MGRP:_ClearText
	pop	cx
   ;	
   ;	 MyControl = CreateControl (3,3,592-d,349-d,MyWindow,0,CONTROL_TYPE_TXTAREA,MySegment,0,0);
   ;	
	push	large 0
	push	word ptr MGRP:_MySegment
	push	3
	push	0
	push	dword ptr MGRP:_MyWindow
	mov	ax,349
	sub	ax,word ptr MGRP:_d
	push	ax
	mov	ax,592
	sub	ax,word ptr MGRP:_d
	push	ax
	push	large 000030003h
	call	near ptr MGRP:_CreateControl
	add	sp,22
	mov	word ptr MGRP:_MyControl+2,dx
	mov	word ptr MGRP:_MyControl,ax
   ;	
   ;	 CreateControl (8,360-d,200+100,20,MyWindow,0,CONTROL_TYPE_EDITBOX,_CS,(unsigned int)filename,0);
   ;	
	push	0
	push	offset MGRP:_filename
	push	cs
	push	2
	push	0
	push	dword ptr MGRP:_MyWindow
	push	large 00014012Ch
	mov	ax,360
	sub	ax,word ptr MGRP:_d
	push	ax
	push	8
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (210+100,360-d,40,20,MyWindow,BUTTON_SAVE,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bSave,0);
   ;	
	push	0
	push	offset MGRP:_bSave
	push	cs
	push	1
	push	2
	push	dword ptr MGRP:_MyWindow
	push	large 000140028h
	mov	ax,360
	sub	ax,word ptr MGRP:_d
	push	ax
	push	310
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (252+100,360-d,40,20,MyWindow,BUTTON_LOAD,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bLoad,0);
   ;	
	push	0
	push	offset MGRP:_bLoad
	push	cs
	push	1
	push	1
	push	dword ptr MGRP:_MyWindow
	push	large 000140028h
	mov	ax,360
	sub	ax,word ptr MGRP:_d
	push	ax
	push	352
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 loaded = 0;
   ;	
	mov	byte ptr MGRP:_loaded,0
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_MyControl	label	dword
	db	4 dup (0)
_fichier	label	word
	db	4 dup (0)
_MySegment	label	word
	db	2 dup (0)
_MyWindow	label	dword
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
	db	'Notepad'
	db	0
VPSEG	ends
	public	_d
	public	_bLoad
	public	_bSave
	public	_ButtonCaption
	public	_WinMain
	public	_loaded
	public	_fremove
	public	_fwrite
	public	_fcreate
	public	_ClearText
	public	_MyControl
	public	_filename
	public	_fichier
	public	_MySegment
	public	_MyWindow
	public	_exec
	public	_fsize
	public	_fread
	public	_fopen
	public	_SysBufOffset
	public	_SysBufSegment
	public	_SizeTextArea
	public	_getmode
	public	_UpdateTextArea
	public	_SetColor
	public	_Rectangle
	public	_Bar
	public	_ShowIcon
	public	_FullShell
	public	_about
	public	_halt
	public	_mem
	public	_CloseFullApp
	public	_InitFullApp
	public	_ExitWindows
	public	_CommandTerm
	public	_OutTextXY
	public	_ProtectWindow
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