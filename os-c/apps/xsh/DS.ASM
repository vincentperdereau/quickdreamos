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
	?debug	S "ds.c"
	?debug	C E96A79C6580464732E63
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
	?debug	C E9E34B535709747970656465662E68
	?debug	C E9E34B5357046C732E68
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
	?debug	C E9E34B5357066469736B2E68
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
	jne	short @32@86
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
@32@86:
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	cmp	dl,6
	jne	short @32@142
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
@32@142:
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
   ;	   close
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@33@114:
   ;	
   ;	  }
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
   ;	
   ;	unsigned char acdisk (void)
   ;	
	assume	cs:MGRP
_acdisk	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;		mov ax,0x7c0
   ;	
	mov	 ax,07c0H
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov al,es:[509]
   ;	
	mov	 al,es:[509]
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_acdisk	endp
_quit	label	word
	db	0
	db	0
_total_size	label	word
	db	0
	db	0
	db	0
	db	0
_adr	label	word
	db	0
	db	0
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	
   ;	 MyWindow = CreateWindow (120,120,180+50,40,"Disk size",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@
	push	large 0002800E6h
	push	large 000780078h
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	 SetColor (8);
   ;	
	push	8
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (135,142,335,152);
   ;	
	push	large 00098014Fh
	push	large 0008E0087h
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (9);
   ;	
	push	9
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	// *******************************************
   ;	
   ;	 _drive = acdisk ();
   ;	
	call	near ptr MGRP:_acdisk
	mov	byte ptr MGRP:__drive,al
   ;	
   ;	 i = ((get_head (_drive)+1) * (get_cyl (_drive)+1) * (get_sector (_drive)) >> 11);
   ;	
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr MGRP:__drive
	push	ax
	call	near ptr MGRP:_get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	pop	edx
	imul	edx,eax
	push	edx
	mov	al,byte ptr MGRP:__drive
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	shr	edx,11
	mov	dword ptr MGRP:_i,edx
   ;	
   ;	 i = i * 1024 * 1024 ;
   ;	
	mov	eax,dword ptr MGRP:_i
	shl	eax,10
	shl	eax,10
	mov	dword ptr MGRP:_i,eax
   ;	
   ;	
   ;	 total_size = 0;
   ;	
	mov	dword ptr MGRP:_total_size,large 0
   ;	
   ;	 e = (((get_head (_drive)+1) * (get_cyl (_drive)+1)*(get_sector (_drive))-219) >> 3);
   ;	
	mov	al,byte ptr MGRP:__drive
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr MGRP:__drive
	push	ax
	call	near ptr MGRP:_get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	pop	edx
	imul	edx,eax
	push	edx
	mov	al,byte ptr MGRP:__drive
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	sub	edx,large 219
	shr	edx,3
	mov	dword ptr MGRP:_e,edx
   ;	
   ;	 e = (e>>9);
   ;	
	mov	eax,dword ptr MGRP:_e
	shr	eax,9
	mov	dword ptr MGRP:_e,eax
   ;	
   ;	 if (!e) e++;
   ;	
	cmp	dword ptr MGRP:_e,large 0
	jne	short @35@58
	inc	dword ptr MGRP:_e
@35@58:
   ;	
   ;	 for (b=219;(b<(e+219));b++)
   ;	
	mov	dword ptr MGRP:_b,large 219
	jmp	short @35@366
@35@86:
   ;	
   ;	 {
   ;	  fcb_dir (b,&bitmap);
   ;	
	push	offset MGRP:_bitmap
	push	dword ptr MGRP:_b
	call	near ptr MGRP:_fcb_dir
	add	sp,6
   ;	
   ;	  for (d=0;d<=511;d++)
   ;	
	mov	dword ptr MGRP:_d,large 0
	jmp	short @35@310
@35@114:
   ;	
   ;	  {
   ;	   for (c=0;c<=7;c++)
   ;	
	mov	dword ptr MGRP:_c,large 0
	jmp	short @35@254
@35@142:
   ;	
   ;	   {
   ;	    if ( bitmap[d] & (1<<c) )
   ;	
	mov	bx,word ptr MGRP:_d
	mov	al,byte ptr MGRP:_bitmap[bx]
	mov	ah,0
	mov	dx,1
	mov	cl,byte ptr MGRP:_c
	shl	dx,cl
	test	ax,dx
	je	short @35@198
   ;	
   ;	    {
   ;	     total_size++;
   ;	
	inc	dword ptr MGRP:_total_size
@35@198:
   ;	
   ;	    }
   ;	   adr++;
   ;	
	inc	word ptr MGRP:_adr
	inc	dword ptr MGRP:_c
@35@254:
	cmp	dword ptr MGRP:_c,large 7
	jbe	short @35@142
	inc	dword ptr MGRP:_d
@35@310:
	cmp	dword ptr MGRP:_d,large 511
	jbe	short @35@114
	inc	dword ptr MGRP:_b
@35@366:
	mov	eax,dword ptr MGRP:_e
	add	eax,large 219
	cmp	eax,dword ptr MGRP:_b
	ja	short @35@86
   ;	
   ;	   }
   ;	  }
   ;	 }
   ;	 j = total_size * 512;
   ;	
	mov	eax,dword ptr MGRP:_total_size
	shl	eax,9
	mov	dword ptr MGRP:_j,eax
   ;	
   ;	
   ;	// *******************************************
   ;	 diff = (j * 50) / i;
   ;	
	imul	eax,large 50
	xor	edx,edx
	div	dword ptr MGRP:_i
	mov	dword ptr MGRP:_diff,eax
   ;	
   ;	
   ;	 Bar (135,142, 135 + (unsigned int)diff,152);
   ;	
	push	152
	mov	ax,word ptr MGRP:_diff
	add	ax,135
	push	ax
	push	large 0008E0087h
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 S[0] = (_drive == 0x80) ? 'C' : 'A';
   ;	
	cmp	byte ptr MGRP:__drive,128
	jne	short @35@450
	mov	al,67
	jmp	short @35@478
@35@450:
	mov	al,65
@35@478:
	mov	byte ptr MGRP:_S,al
   ;	
   ;	 S[1] = 0;
   ;	
	mov	byte ptr MGRP:_S+1,0
   ;	
   ;	 OutTextXY (210,1,S,MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:_S
	push	large 0000100D2h
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_S	label	byte
	db	2 dup (0)
_bitmap	label	byte
	db	512 dup (0)
_e	label	word
	db	4 dup (0)
_d	label	word
	db	4 dup (0)
_c	label	word
	db	4 dup (0)
_b	label	word
	db	4 dup (0)
__drive	label	byte
	db	1 dup (0)
_diff	label	word
	db	4 dup (0)
_j	label	word
	db	4 dup (0)
_i	label	word
	db	4 dup (0)
_MyWindow	label	dword
	db	4 dup (0)
_DISK_STATE	label	word
	db	13 dup (0)
_DRIVE	label	byte
	db	1 dup (0)
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
	?debug	C FA10000000
s@	label	byte
	db	'Disk size'
	db	0
VPSEG	ends
	public	_S
	public	_adr
	public	_bitmap
	public	_quit
	public	_e
	public	_d
	public	_c
	public	_b
	public	_total_size
	public	__drive
	public	_diff
	public	_j
	public	_i
	public	_acdisk
	public	_WinMain
	public	_MyWindow
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