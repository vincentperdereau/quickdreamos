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
	?debug	S "dock.c"
	?debug	C E994B3BC5806646F636B2E63
	?debug	C E9BBB3BC580A717569636B77696E2E68
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
   ;	
   ;	char exec (char* prog,unsigned int segArg,unsigned int ofsArg)
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
   ;	 if (WM_MESSAGE == CONTROL_BUTTON)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],193
	jne	short @26@366
   ;	
   ;	 { 
   ;	  if (WM_PARAM == BUTTON_01)
   ;	
	cmp	byte ptr es:[bx+2],1
	jne	short @26@142
   ;	
   ;	  {
   ;	   FullShell ();
   ;	
	call	near ptr MGRP:_FullShell
@26@142:
   ;	
   ;	  }
   ;	  if (WM_PARAM == BUTTON_02)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],2
	jne	short @26@198
   ;	
   ;	  {
   ;	   about ();
   ;	
	call	near ptr MGRP:_about
@26@198:
   ;	
   ;	  }
   ;	  if (WM_PARAM == BUTTON_03)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],3
	jne	short @26@254
   ;	
   ;	  {
   ;	   exec ("/qwin/exec",0,0);
   ;	
	push	large 0
	push	offset MGRP:s@
	call	near ptr MGRP:_exec
	add	sp,6
@26@254:
   ;	
   ;	  }
   ;	  if (WM_PARAM == BUTTON_04)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],4
	jne	short @26@310
   ;	
   ;	  {
   ;	   mem ();
   ;	
	call	near ptr MGRP:_mem
@26@310:
   ;	
   ;	  }
   ;	  if (WM_PARAM == BUTTON_05)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],5
	jne	short @26@366
   ;	
   ;	  {
   ;	    halt ();
   ;	
	call	near ptr MGRP:_halt
@26@366:
   ;	
   ;	  }
   ;	 }
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
b0	label	byte
	db	0
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 if (getmode () == 1)
   ;	
	call	near ptr MGRP:_getmode
	cmp	al,1
	jne	short @27@58
   ;	
   ;	 maxx = 640;
   ;	
	mov	word ptr MGRP:maxx,640
	jmp	short @27@86
@27@58:
   ;	
   ;	 else
   ;	 maxx = 800;
   ;	
	mov	word ptr MGRP:maxx,800
@27@86:
   ;	
   ;	 
   ;	 MyWindow = CreateWindow (maxx-60,10,40,200,"",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@+11
	push	large 000C80028h
	push	10
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	push	ax
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	 ProtectWindow (MyWindow);
   ;	
	push	dx
	push	ax
	call	near ptr MGRP:_ProtectWindow
	add	sp,4
   ;	
   ;	 SetColor (7);
   ;	
	push	7
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Bar (maxx-60,10,maxx-60+40+10,200+10);
   ;	
	push	210
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	add	ax,50
	push	ax
	push	10
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	push	ax
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Rectangle (maxx-60,10,maxx-60+40+10,200+10);
   ;	
	push	210
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	add	ax,50
	push	ax
	push	10
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Rectangle (maxx-60+1,0+1+10,maxx-60+40+10,200+10+1);
   ;	
	push	211
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	add	ax,50
	push	ax
	push	11
	mov	ax,word ptr MGRP:maxx
	sub	ax,60
	inc	ax
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	
   ;	 CreateControl (0,0  ,34,34,MyWindow,BUTTON_01,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
   ;	
	push	0
	push	offset MGRP:b0
	push	cs
	push	1
	push	1
	push	dword ptr MGRP:_MyWindow
	push	large 000220022h
	push	large 0
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (0,35 ,34,34,MyWindow,BUTTON_02,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
   ;	
	push	0
	push	offset MGRP:b0
	push	cs
	push	1
	push	2
	push	dword ptr MGRP:_MyWindow
	push	large 000220022h
	push	large 000230000h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (0,70 ,34,34,MyWindow,BUTTON_03,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
   ;	
	push	0
	push	offset MGRP:b0
	push	cs
	push	1
	push	3
	push	dword ptr MGRP:_MyWindow
	push	large 000220022h
	push	large 000460000h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (0,105,34,34,MyWindow,BUTTON_04,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
   ;	
	push	0
	push	offset MGRP:b0
	push	cs
	push	1
	push	4
	push	dword ptr MGRP:_MyWindow
	push	large 000220022h
	push	large 000690000h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (0,140,34,34,MyWindow,BUTTON_05,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
   ;	
	push	0
	push	offset MGRP:b0
	push	cs
	push	1
	push	5
	push	dword ptr MGRP:_MyWindow
	push	large 000220022h
	push	large 0008C0000h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	
   ;	 ShowIcon (2,  0+1,"/qwin/term.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+12
	push	large 000010002h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	 ShowIcon (2, 35+1,"/qwin/eye.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+27
	push	large 000240002h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	 ShowIcon (2, 70+1,"/qwin/exec.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+41
	push	large 000470002h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	 ShowIcon (2,105+1,"/qwin/mem.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+56
	push	large 0006A0002h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	 ShowIcon (1,140+1,"/qwin/shut.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+70
	push	large 0008D0001h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
maxx	label	word
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
	db	'/qwin/exec'
	db	0
	db	0
	db	'/qwin/term.ico'
	db	0
	db	'/qwin/eye.ico'
	db	0
	db	'/qwin/exec.ico'
	db	0
	db	'/qwin/mem.ico'
	db	0
	db	'/qwin/shut.ico'
	db	0
VPSEG	ends
_maxx	equ	maxx
_b0	equ	b0
	public	_WinMain
	public	_exec
	public	_MyWindow
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