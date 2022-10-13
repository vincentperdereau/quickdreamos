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
	?debug	S "keyb.c"
	?debug	C E95B73212B066B6579622E63
	?debug	C E9E871212B0A717569636B77696E2E68
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
	jne	short @13@58
   ;	
   ;	   close
   ;	
	push	cs
	call	near ptr MGRP:_free
	pop	cx
@13@58:
   ;	
   ;	  if (WM_MESSAGE == CONTROL_BUTTON)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+1],193
	je short	@@0
	jmp	@13@394
@@0:
   ;	
   ;	  {
   ;	   if (WM_PARAM == OK)
   ;	
	cmp	byte ptr es:[bx+2],1
	je short	@@1
	jmp	@13@366
@@1:
   ;	
   ;	   {
   ;	    CommandTerm ("cd /lib/kbd",0);
   ;	
	push	0
	push	offset MGRP:s@
	call	near ptr MGRP:_CommandTerm
	add	sp,4
   ;	
   ;	    CommandTerm ("rm keymap",0);
   ;	
	push	0
	push	offset MGRP:s@+12
	call	near ptr MGRP:_CommandTerm
	add	sp,4
   ;	
   ;	   if (MyControl->word1 == FRENCH)
   ;	
	les	bx,dword ptr MGRP:_MyControl
	cmp	word ptr es:[bx+20],0
	jne	short @13@170
   ;	
   ;	    CommandTerm ("cp fr.map k",0);
   ;	
	push	0
	push	offset MGRP:s@+22
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@13@170:
   ;	
   ;	   if (MyControl->word1 == US)
   ;	
	les	bx,dword ptr MGRP:_MyControl
	cmp	word ptr es:[bx+20],1
	jne	short @13@226
   ;	
   ;	    CommandTerm ("cp us.map k",0);
   ;	
	push	0
	push	offset MGRP:s@+34
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@13@226:
   ;	
   ;	   if (MyControl->word1 == BRITISH)
   ;	
	les	bx,dword ptr MGRP:_MyControl
	cmp	word ptr es:[bx+20],2
	jne	short @13@282
   ;	
   ;	    CommandTerm ("cp br.map k",0);
   ;	
	push	0
	push	offset MGRP:s@+46
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@13@282:
   ;	
   ;	   if (MyControl->word1 == GERMAN)
   ;	
	les	bx,dword ptr MGRP:_MyControl
	cmp	word ptr es:[bx+20],3
	jne	short @13@338
   ;	
   ;	    CommandTerm ("cp gr.map kp",0);
   ;	
	push	0
	push	offset MGRP:s@+58
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@13@338:
   ;	
   ;	   CommandTerm ("cp k keymap",0);
   ;	
	push	0
	push	offset MGRP:s@+71
	call	near ptr MGRP:_CommandTerm
	add	sp,4
   ;	
   ;	   CommandTerm ("rm k",0);
   ;	
	push	0
	push	offset MGRP:s@+83
	call	near ptr MGRP:_CommandTerm
	add	sp,4
@13@366:
   ;	
   ;	   }
   ;	   if (WM_PARAM == CANCEL)
   ;	
	les	bx,dword ptr MGRP:_SysBuf
	cmp	byte ptr es:[bx+2],2
@13@394:
   ;	
   ;	   {
   ;	   // DestroyWindow (MyWindow);
   ;	   }
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
_Cycler	label	byte
	db	70
	db	114
	db	101
	db	110
	db	99
	db	104
	db	0
	db	85
	db	83
	db	0
	db	66
	db	114
	db	105
	db	116
	db	105
	db	115
	db	104
	db	0
	db	71
	db	101
	db	114
	db	109
	db	97
	db	110
	db	0
_ButtonOK	label	byte
	db	79
	db	75
	db	0
_ButtonCancel	label	byte
	db	67
	db	97
	db	110
	db	99
	db	101
	db	108
	db	0
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 MyWindow = CreateWindow (100,100,200,100,"Keyboard",&WinMain);
   ;	
	push	offset MGRP:_WinMain
	push	offset MGRP:s@+88
	push	large 0006400C8h
	push	large 000640064h
	call	near ptr MGRP:_CreateWindow
	add	sp,12
	mov	word ptr MGRP:_MyWindow+2,dx
	mov	word ptr MGRP:_MyWindow,ax
   ;	
   ;	 MyControl = CreateControl (10,20,135,18,MyWindow,FRENCH,CONTROL_TYPE_CYCLER,_CS,(unsigned int)Cycler,4);
   ;	
	push	4
	push	offset MGRP:_Cycler
	push	cs
	push	4
	push	0
	push	dx
	push	ax
	push	large 000120087h
	push	large 00014000Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
	mov	word ptr MGRP:_MyControl+2,dx
	mov	word ptr MGRP:_MyControl,ax
   ;	
   ;	
   ;	 CreateControl (10,45,65,20,MyWindow,OK,CONTROL_TYPE_BUTTON,_CS,(unsigned int)ButtonOK,0);
   ;	
	push	0
	push	offset MGRP:_ButtonOK
	push	cs
	push	1
	push	1
	push	dword ptr MGRP:_MyWindow
	push	large 000140041h
	push	large 0002D000Ah
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 CreateControl (80,45,65,20,MyWindow,CANCEL,CONTROL_TYPE_BUTTON,_CS,(unsigned int)ButtonCancel,0);
   ;	
	push	0
	push	offset MGRP:_ButtonCancel
	push	cs
	push	1
	push	2
	push	dword ptr MGRP:_MyWindow
	push	large 000140041h
	push	large 0002D0050h
	call	near ptr MGRP:_CreateControl
	add	sp,22
   ;	
   ;	 OutTextXY (10,2,"Choose a keyboard:",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+97
	push	large 00002000Ah
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	 ShowIcon (160,25,"/qwin/keyb.ico",MyWindow);
   ;	
	push	dword ptr MGRP:_MyWindow
	push	offset MGRP:s@+116
	push	large 0001900A0h
	call	near ptr MGRP:_ShowIcon
	add	sp,10
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_MyControl	label	dword
	db	4 dup (0)
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
	db	'cd /lib/kbd'
	db	0
	db	'rm keymap'
	db	0
	db	'cp fr.map k'
	db	0
	db	'cp us.map k'
	db	0
	db	'cp br.map k'
	db	0
	db	'cp gr.map kp'
	db	0
	db	'cp k keymap'
	db	0
	db	'rm k'
	db	0
	db	'Keyboard'
	db	0
	db	'Choose a keyboard:'
	db	0
	db	'/qwin/keyb.ico'
	db	0
VPSEG	ends
	public	_ButtonCancel
	public	_ButtonOK
	public	_Cycler
	public	_WinMain
	public	_MyControl
	public	_MyWindow
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