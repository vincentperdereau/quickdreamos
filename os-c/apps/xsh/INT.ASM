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
	?debug	S "int.c"
	?debug	C E90C4D492C05696E742E63
	?debug	C E9264C492C0A717569636B77696E2E68
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
   ;	  if (WM_MESSAGE == WINDOW_DESTROY)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],176
	jne	short @17@58
   ;	
   ;	  {
   ;	   in_isr = 0;
   ;	
	mov	word ptr MGRP:in_isr,0
@17@58:
   ;	
   ;	  }
   ;	  if (WM_MESSAGE == CONTROL_BUTTON)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],193
	jne	short @17@310
   ;	
   ;	  {
   ;	   if (WM_PARAM == BUTTON_REBOOT)
   ;	
	cmp	byte ptr es:[bx+2],1
	jne	short @17@198
   ;	
   ;	   {
   ;	    asm {
   ;	          db 0xea
   ;	
	db	 0eaH
   ;	
   ;	          dw 0x0000
   ;	
	dw	 00000H
   ;	
   ;	          dw 0xffff
   ;	
	dw	 0ffffH
@17@198:
   ;	
   ;	        }
   ;	   }
   ;	   if (WM_PARAM == BUTTON_HALT)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],2
	jne	short @17@254
   ;	
   ;	   {
   ;	    CommandTerm ("halt",0);
   ;	
	push	0
	push	offset MGRP:s@
	call	near ptr MGRP:_CommandTerm
	add	sp,4
   ;	
   ;	    ExitWindows ();
   ;	
	call	near ptr MGRP:_ExitWindows
@17@254:
   ;	
   ;	   }
   ;	
   ;	   if (WM_PARAM == BUTTON_BACK)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],3
	jne	short @17@310
   ;	
   ;	   {
   ;	    DestroyWindow (MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	call	near ptr MGRP:_DestroyWindow
	add	sp,4
@17@310:
   ;	
   ;	   }
   ;	
   ;	  }
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
_bReboot	label	byte
	db	114
	db	101
	db	98
	db	111
	db	111
	db	116
	db	0
_bHalt	label	byte
	db	104
	db	97
	db	108
	db	116
	db	0
_bBack	label	byte
	db	98
	db	97
	db	99
	db	107
	db	0
   ;	
   ;	void ctrlaltdel (void)
   ;	
	assume	cs:MGRP
_ctrlaltdel	proc	near
   ;	
   ;	{
   ;	 asm { push ax bx cx dx ds };
   ;	
 	push	 ax bx cx dx ds 
   ;	
   ;	 asm { mov ax,cs
   ;	
 	mov	 ax,cs
   ;	
   ;	       mov ds,ax }
   ;	
	mov	 ds,ax 
   ;	
   ;	 if (!in_isr)
   ;	
	cmp	word ptr MGRP:in_isr,0
	je short	@@0
	jmp	@18@142
@@0:
   ;	
   ;	 {
   ;	  in_isr = 1;
   ;	
	mov	word ptr MGRP:in_isr,1
   ;	
   ;	  MyWindow = CreateWindow (120,120,340,70,"Shutdown system",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@+5
	push	large 000460154h
	push	large 000780078h
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	  CreateControl (10,10,100,25,MyWindow,BUTTON_REBOOT,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bReboot,0);
   ;	
	push	0
	push	offset MGRP:_bReboot
	push	cs
	push	1
	push	1
	push	dx
	push	ax
	push	large 000190064h
	push	large 0000A000Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	  CreateControl (115,10,100,25,MyWindow,BUTTON_HALT,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bHalt,0);
   ;	
	push	0
	push	offset MGRP:_bHalt
	push	cs
	push	1
	push	2
	push	dword ptr MGRP:_MyWindow
	push	large 000190064h
	push	large 0000A0073h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	  CreateControl (220,10,100,25,MyWindow,BUTTON_BACK,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bBack,0);
   ;	
	push	0
	push	offset MGRP:_bBack
	push	cs
	push	1
	push	3
	push	dword ptr MGRP:_MyWindow
	push	large 000190064h
	push	large 0000A00DCh
	call	near ptr MGRP:_CreateControl
	add	sp,22
@18@142:
   ;	
   ;	 }
   ;	 asm { pop ds dx cx bx ax };
   ;	
 	pop	 ds dx cx bx ax 
   ;	
   ;	 asm { iret };
   ;	
 	iret	 
   ;	
   ;	}
   ;	
	ret	
_ctrlaltdel	endp
   ;	
   ;	void intr (void* funcptr, char intc)
   ;	
	assume	cs:MGRP
_intr	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push bx
   ;	
	push	 bx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;	        xor ax,ax    
   ;	
	xor	 ax,ax    
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		xor bh,bh
   ;	
	xor	 bh,bh
   ;	
   ;		mov bl,intc
   ;	
	mov	 bl,[bp+6]
   ;	
   ;	        shl bx,2             
   ;	
	shl	 bx,2             
   ;	
   ;		mov ax,funcptr
   ;	
	mov	 ax,[bp+4]
   ;	
   ;	        mov es:[bx],ax   
   ;	
	mov	 es:[bx],ax   
   ;	
   ;	        mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;	        mov word ptr es:[bx+2],ax
   ;	
	mov	 word ptr es:[bx+2],ax
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop ax
   ;	
	pop	 ax
   ;	
   ;	       }
   ;	}
   ;	
	pop	bp
	ret	
_intr	endp
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 in_isr = 0;
   ;	
	mov	word ptr MGRP:in_isr,0
   ;	
   ;	 intr ((void*)&ctrlaltdel,0x28);
   ;	
	push	40
	push	offset MGRP:_ctrlaltdel
	call	near ptr MGRP:_intr
	add	sp,4
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
in_isr	label	word
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
	db	'halt'
	db	0
	db	'Shutdown system'
	db	0
VPSEG	ends
	public	_intr
	public	_ctrlaltdel
	public	_bBack
	public	_bHalt
	public	_bReboot
	public	_WinMain
_in_isr	equ	in_isr
	public	_MyWindow
	public	_SysBufOffset
	public	_SysBufSegment
	public	_SizeTextArea
	public	_UpdateTextArea
	public	_SetColor
	public	_Rectangle
	public	_Bar
	public	_ShowIcon
	public	_ExitWindows
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