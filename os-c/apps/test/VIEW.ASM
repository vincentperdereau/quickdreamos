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
	?debug	S "view.c"
	?debug	C E98A6ECA5806766965772E63
	?debug	C E9E34B5357092E5C737464696F2E68
	?debug	C E9E34B53570A2E5C6D656D6F72792E68
	?debug	C E95351BF580A717569636B77696E2E68
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
   ;	
   ;	{
   ;	 Init ();
   ;	
	call	near ptr _Init
   ;	
   ;	 StartProgram (argc, argv);
   ;	
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _StartProgram
	add	sp,4
   ;	
   ;	  asm {
   ;	       mov      ax,0x0601
   ;	
	mov	      ax,00601H
   ;	
   ;	       int      0x46
   ;	
	int	      046H
   ;	
   ;	 }
   ;	}
   ;	
	pop	bp
	ret	
_main	endp
   ;	
   ;	HWND CreateWindow (int x, int y, int w, int h, char* title, void far (*WinMain) )
   ;	
	assume	cs:_TEXT
_CreateWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x01;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	les	bx,dword ptr DGROUP:_SysBuf
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
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_CreateControl	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;			       unsigned int h, HWND hWnd, unsigned char ID, unsigned char ControlType,
   ;			       unsigned int CapSegment, unsigned int CapOffset, unsigned int size)
   ;	{
   ;	 SysBuf->function = 0x09;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_DestroyWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x20;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_ProtectWindow	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x23;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_OutTextXY	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x03;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_CommandTerm	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x18;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_ExitWindows	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x11;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_InitFullApp	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x24;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_CloseFullApp	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x25;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_mem	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x29;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_halt	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x28;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_about	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x27;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_FullShell	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x26;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_ShowIcon	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x19;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_Bar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x14;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_Rectangle	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x15;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_SetColor	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x05;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_UpdateTextArea	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x21;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
_getmode	proc	near
   ;	
   ;	{
   ;	 SysBuf->function = 0x30;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
	mov	byte ptr es:[bx],48
   ;	
   ;	 WManager;
   ;	
 	int	 048H 
   ;	
   ;	 return (SysBuf->byte1);
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
	mov	al,byte ptr es:[bx+1]
   ;	
   ;	}
   ;	
	ret	
_getmode	endp
   ;	
   ;	unsigned int SizeTextArea (CONTROL dumControl)
   ;	
	assume	cs:_TEXT
_SizeTextArea	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 SysBuf->function = 0x22;
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
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
	les	bx,dword ptr DGROUP:_SysBuf
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
	assume	cs:_TEXT
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
	mov	 cs:DGROUP:_SysBufSegment,bx
   ;	
   ;	     mov cs:SysBufOffset,cx
   ;	
	mov	 cs:DGROUP:_SysBufOffset,cx
   ;	
   ;	     }
   ;	 SysBuf = (SB far*) (SysBufSegment * 65536 + SysBufOffset);
   ;	
	movzx	eax,word ptr DGROUP:_SysBufSegment
	shl	eax,16
	movzx	edx,word ptr DGROUP:_SysBufOffset
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr DGROUP:_SysBuf+2,dx
	mov	word ptr DGROUP:_SysBuf,ax
   ;	
   ;	}
   ;	
	ret	
_Init	endp
   ;	
   ;	void far WinMain (void)
   ;	
	assume	cs:_TEXT
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
	mov	word ptr DGROUP:DataSegment,ax
   ;	
   ;	          
   ;	  if (WM_MESSAGE == WINDOW_DESTROY)
   ;	
	les	bx,dword ptr DGROUP:_SysBuf
	cmp	byte ptr es:[bx+1],176
	jne	short @23@114
   ;	
   ;	  {
   ;	   close
   ;	
	push	cs
	call	near ptr _free
	add	sp,2
@23@114:
   ;	
   ;	  }
   ;	
   ;	 FuncEnd
   ;	
	mov	ax,word ptr DGROUP:DataSegment
	mov	ds,ax
 	popa	 
 	sti	 
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_WinMain	endp
_TEXT	ends
_DATA	segment word public use16 'VP'
_picI	label	word
	db	0
	db	0
_unusedMask	label	word
	db	0
	db	0
_color16palMapping	label	byte
	db	0
	db	1
	db	2
	db	3
	db	4
	db	5
	db	14
	db	7
	db	56
	db	57
	db	58
	db	59
	db	60
	db	61
	db	62
	db	63
_DATA	ends
_TEXT	segment byte public use16 'CODE'
   ;	
   ;	void setpix (int x, int y, unsigned char couleur)
   ;	
	assume	cs:_TEXT
_setpix	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 if (getmode() == 1)
   ;	
	call	near ptr _getmode
	cmp	al,1
	jne	short @24@86
   ;	
   ;	  setpix1 (x,y,couleur);
   ;	
	mov	al,byte ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr _setpix1
	add	sp,6
	pop	di
	pop	si
	pop	bp
	ret	
@24@86:
   ;	
   ;	 else
   ;	  setpix2 (x,y,couleur);
   ;	
	mov	al,byte ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr _setpix2
	add	sp,6
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_setpix	endp
   ;	
   ;	void setPal(unsigned char pixel, unsigned char r, unsigned char g, unsigned char b) 
   ;	
	assume	cs:_TEXT
_setPal	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	    asm {
   ;	        mov dx, 0x3c6
   ;	
	mov	 dx, 03c6H
   ;	
   ;	        mov al, 0xff
   ;	
	mov	 al, 0ffH
   ;	
   ;	        out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        mov dx, 0x3c8
   ;	
	mov	 dx, 03c8H
   ;	
   ;	        mov al, pixel
   ;	
	mov	 al, [bp+4]
   ;	
   ;	        out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        inc dx
   ;	
	inc	 dx
   ;	
   ;	        mov al, r 
   ;	
	mov	 al, [bp+6] 
   ;	
   ;	        out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        mov al, g
   ;	
	mov	 al, [bp+8]
   ;	
   ;	        out dx, al
   ;	
	out	 dx, al
   ;	
   ;	        mov al, b
   ;	
	mov	 al, [bp+10]
   ;	
   ;	        out dx, al
   ;	
	out	 dx, al
   ;	
   ;	    }
   ;	}
   ;	
	pop	bp
	ret	
_setPal	endp
   ;	
   ;	void StartProgram (int argc, char **argv)
   ;	
	assume	cs:_TEXT
_StartProgram	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+6]
   ;	
   ;	{
   ;	 if (argc < 2)
   ;	
	cmp	word ptr [bp+4],2
	jge short	@@4
	jmp	@26@1486
@@4:
   ;	
   ;	    return;
   ;	        
   ;	 printf("\nFile name=%s", argv[1]);
   ;	
	push	word ptr [si+2]
	push	offset DGROUP:s@
	call	near ptr _printf
	add	sp,4
   ;	
   ;	 input = fopen (argv[1],"rb");
   ;	
	push	offset DGROUP:s@+14
	push	word ptr [si+2]
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_input+2,dx
	mov	word ptr DGROUP:_input,ax
   ;	
   ;	
   ;	 if (input == 0) 
   ;	
	cmp	dword ptr DGROUP:_input,large 0
	jne	short @26@114
   ;	
   ;	 {
   ;	    printf ("\n ** can't read %s.", argv[1]);
   ;	
	push	word ptr [si+2]
	push	offset DGROUP:s@+17
	call	near ptr _printf
	add	sp,4
   ;	
   ;	    return ;
   ;	
	pop	si
	pop	bp
	ret	
@26@114:
   ;	
   ;	 }
   ;	
   ;	 filesize = fsize (input);     
   ;	
	push	dword ptr DGROUP:_input
	call	near ptr _fsize
	shl	eax,16
	shrd	eax,edx,16
	add	sp,4
	mov	dword ptr DGROUP:_filesize,eax
   ;	
   ;	 printf("\nFile size=%u", filesize);  
   ;	
	push	eax
	push	offset DGROUP:s@+37
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 buffer = (unsigned char far*) (input->bseg * 65536 + input->bofs);
   ;	
	les	bx,dword ptr DGROUP:_input
	movzx	eax,word ptr es:[bx+4]
	shl	eax,16
	movzx	edx,word ptr es:[bx+6]
	add	eax,edx
	shld	edx,eax,16
	mov	word ptr DGROUP:_buffer+2,dx
	mov	word ptr DGROUP:_buffer,ax
   ;	
   ;	 
   ;	 if ((buffer[0] != 'B') && (buffer[0] != 'M'))
   ;	
	les	bx,dword ptr DGROUP:_buffer
	cmp	byte ptr es:[bx],66
	je	short @26@198
	cmp	byte ptr es:[bx],77
	je	short @26@198
   ;	
   ;	 {
   ;	    printf ("\n ** BMP signature not found.");
   ;	
	push	offset DGROUP:s@+51
	call	near ptr _printf
	add	sp,2
   ;	
   ;	    return ;
   ;	
	pop	si
	pop	bp
	ret	
@26@198:
   ;	
   ;	 }
   ;	 
   ;	 printf("\nBMP header = %c%c", buffer[0], buffer[1]);
   ;	
	les	bx,dword ptr DGROUP:_buffer
	mov	al,byte ptr es:[bx+1]
	mov	ah,0
	push	ax
	mov	al,byte ptr es:[bx]
	mov	ah,0
	push	ax
	push	offset DGROUP:s@+81
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 memcpy (_CS,(unsigned int)&width,input->bseg,input->bofs + 0x12,4);
   ;	
	push	4
	les	bx,dword ptr DGROUP:_input
	mov	ax,word ptr es:[bx+6]
	add	ax,18
	push	ax
	push	word ptr es:[bx+4]
	push	offset DGROUP:_width
	push	cs
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	 memcpy (_CS,(unsigned int)&height,input->bseg,input->bofs + 0x16,4);
   ;	
	push	4
	les	bx,dword ptr DGROUP:_input
	mov	ax,word ptr es:[bx+6]
	add	ax,22
	push	ax
	push	word ptr es:[bx+4]
	push	offset DGROUP:_height
	push	cs
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	 memcpy (_CS,(unsigned int)&szImage,input->bseg,input->bofs + 0x22,4);
   ;	
	push	4
	les	bx,dword ptr DGROUP:_input
	mov	ax,word ptr es:[bx+6]
	add	ax,34
	push	ax
	push	word ptr es:[bx+4]
	push	offset DGROUP:_szImage
	push	cs
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	 memcpy (_CS,(unsigned int)&colorsBits,input->bseg,input->bofs + 0x1c,2);
   ;	
	push	2
	les	bx,dword ptr DGROUP:_input
	mov	ax,word ptr es:[bx+6]
	add	ax,28
	push	ax
	push	word ptr es:[bx+4]
	push	offset DGROUP:_colorsBits
	push	cs
	call	near ptr _memcpy
	add	sp,10
   ;	
   ;	 switch(colorsBits) {
   ;	
	mov	ax,word ptr DGROUP:_colorsBits
	cmp	ax,1
	je	short @26@366
	cmp	ax,4
	je	short @26@394
	cmp	ax,8
	je	short @26@422
	jmp	short @26@450
@26@366:
   ;	
   ;	     case 1: colors = 2; break;
   ;	
	mov	word ptr DGROUP:_colors,2
	jmp	short @26@450
@26@394:
   ;	
   ;	     case 4: colors = 16; break;
   ;	
	mov	word ptr DGROUP:_colors,16
	jmp	short @26@450
@26@422:
   ;	
   ;	     case 8: colors = 256; break;
   ;	
	mov	word ptr DGROUP:_colors,256
@26@450:
   ;	
   ;	 }              
   ;	 printf("\nBMP width = %u", width);
   ;	
	push	dword ptr DGROUP:_width
	push	offset DGROUP:s@+100
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 printf("\nBMP height = %u", height);
   ;	
	push	dword ptr DGROUP:_height
	push	offset DGROUP:s@+116
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 printf("\nBMP size = %u", szImage);
   ;	
	push	dword ptr DGROUP:_szImage
	push	offset DGROUP:s@+133
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 printf("\nBMP colors bits = %u", colorsBits);
   ;	
	push	word ptr DGROUP:_colorsBits
	push	offset DGROUP:s@+148
	call	near ptr _printf
	add	sp,4
   ;	
   ;	 printf("\nBMP colors = %u", colors);
   ;	
	push	word ptr DGROUP:_colors
	push	offset DGROUP:s@+170
	call	near ptr _printf
	add	sp,4
   ;	
   ;	
   ;	 orgX = 100; x = orgX + 10;
   ;	
	mov	word ptr DGROUP:_orgX,100
	mov	ax,100
	add	ax,10
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	 orgY = 260; y = orgY + height + 24;
   ;	
	mov	word ptr DGROUP:_orgY,260
	mov	ax,260
	add	ax,word ptr DGROUP:_height
	add	ax,24
	mov	word ptr DGROUP:_y,ax
   ;	
   ;	 
   ;	 FormWnd = CreateWindow (orgX,orgY,width + 12,height + 32,argv[1],&WinMain);
   ;	
	push	offset _WinMain
	push	word ptr [si+2]
	mov	ax,word ptr DGROUP:_height
	add	ax,32
	push	ax
	mov	ax,word ptr DGROUP:_width
	add	ax,12
	push	ax
	push	large 001040064h
	call	near ptr _CreateWindow
	add	sp,12
	mov	word ptr DGROUP:_FormWnd+2,dx
	mov	word ptr DGROUP:_FormWnd,ax
   ;	
   ;	 orgX += 3;
   ;	
	add	word ptr DGROUP:_orgX,3
   ;	
   ;	 x += 3;
   ;	
	add	word ptr DGROUP:_x,3
   ;	
   ;	
   ;	 unusedMask = false;
   ;	
	mov	word ptr DGROUP:_unusedMask,0
   ;	
   ;	 if (colors == 16)
   ;	
	cmp	word ptr DGROUP:_colors,16
	jne	short @26@534
   ;	
   ;	 {
   ;	    if ((width % 8) != 0)
   ;	
	test	dword ptr DGROUP:_width,large 7
	je	short @26@534
   ;	
   ;	    {
   ;	       unusedMask = true;
   ;	
	mov	word ptr DGROUP:_unusedMask,1
   ;	
   ;	       originalWidth = width;
   ;	
	mov	ax,word ptr DGROUP:_width
	mov	word ptr DGROUP:_originalWidth,ax
   ;	
   ;	       width = ((width / 8) + 1) * 8;
   ;	
	mov	eax,dword ptr DGROUP:_width
	shr	eax,3
	shl	eax,3
	add	eax,large 8
	mov	dword ptr DGROUP:_width,eax
   ;	
   ;	       printf("\nBMP recalculated width = %u", width);
   ;	
	push	eax
	push	offset DGROUP:s@+187
	call	near ptr _printf
	add	sp,6
@26@534:
   ;	
   ;	    }  
   ;	 }
   ;	
   ;	 printf("\nBMP unusedMask = %u", unusedMask);
   ;	
	push	word ptr DGROUP:_unusedMask
	push	offset DGROUP:s@+216
	call	near ptr _printf
	add	sp,4
   ;	
   ;	 
   ;	 offsetPal = 54;
   ;	
	mov	word ptr DGROUP:_offsetPal,54
   ;	
   ;	 offsetBuffer = offsetPal + (colors * 4);
   ;	
	mov	ax,word ptr DGROUP:_colors
	shl	ax,2
	mov	dx,54
	add	dx,ax
	mov	word ptr DGROUP:_offsetBuffer,dx
   ;	
   ;	 
   ;	 for (picI = 0; picI < colors; picI++) 
   ;	
	mov	word ptr DGROUP:_picI,0
	mov	ax,word ptr DGROUP:_picI
	cmp	ax,word ptr DGROUP:_colors
	jb short	@@5
	jmp	@26@674
@@5:
@26@590:
   ;	
   ;	 {
   ;	    pixel = picI;
   ;	
	mov	al,byte ptr DGROUP:_picI
	mov	byte ptr DGROUP:_pixel,al
   ;	
   ;	    red = buffer[offsetPal + 2 + (pixel * 4)] >> 2;
   ;	
	mov	ah,0
	shl	ax,2
	mov	dx,word ptr DGROUP:_offsetPal
	add	dx,ax
	mov	cx,dx
	add	dx,2
	les	bx,dword ptr DGROUP:_buffer
	add	bx,dx
	mov	al,byte ptr es:[bx]
	mov	ah,0
	sar	ax,2
	mov	byte ptr DGROUP:_red,al
   ;	
   ;	    green = buffer[offsetPal + 1 + (pixel * 4)] >> 2;
   ;	
	mov	ax,cx
	inc	ax
	mov	bx,word ptr DGROUP:_buffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	ah,0
	sar	ax,2
	mov	byte ptr DGROUP:_green,al
   ;	
   ;	    blue = buffer[offsetPal + 0 + (pixel * 4)] >> 2;   
   ;	
	mov	bx,word ptr DGROUP:_buffer
	add	bx,cx
	mov	al,byte ptr es:[bx]
	mov	ah,0
	sar	ax,2
	mov	byte ptr DGROUP:_blue,al
   ;	
   ;	    setPal(color16palMapping[pixel], red, green, blue);
   ;	
	push	ax
	mov	al,byte ptr DGROUP:_green
	push	ax
	mov	al,byte ptr DGROUP:_red
	push	ax
	mov	al,byte ptr DGROUP:_picI
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr DGROUP:_color16palMapping[bx]
	push	ax
	call	near ptr _setPal
	add	sp,8
	inc	word ptr DGROUP:_picI
	mov	ax,word ptr DGROUP:_picI
	cmp	ax,word ptr DGROUP:_colors
	jae short	@@6
	jmp	@26@590
@@6:
@26@674:
   ;	
   ;	 }
   ;	
   ;	 for (picI = 0; picI <= szImage; picI++) 
   ;	
	mov	word ptr DGROUP:_picI,0
	jmp	@26@1430
@26@702:
   ;	
   ;	 {
   ;	     if (colors == 2)
   ;	
	cmp	word ptr DGROUP:_colors,2
	je short	@@7
	jmp	@26@926
@@7:
   ;	
   ;	     {
   ;	        for (maskJ = 0; maskJ <= 7; maskJ++)
   ;	
	mov	byte ptr DGROUP:_maskJ,0
	jmp	short @26@898
@26@758:
   ;	
   ;	        {
   ;	            pixel = (buffer[offsetBuffer + picI] & (128 >> maskJ));
   ;	
	mov	ax,word ptr DGROUP:_offsetBuffer
	add	ax,word ptr DGROUP:_picI
	les	bx,dword ptr DGROUP:_buffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	dx,128
	mov	cl,byte ptr DGROUP:_maskJ
	sar	dx,cl
	and	al,dl
	mov	byte ptr DGROUP:_pixel,al
   ;	
   ;	            if (pixel) 
   ;	
	cmp	byte ptr DGROUP:_pixel,0
	je	short @26@814
   ;	
   ;	               pixel = 15;
   ;	
	mov	byte ptr DGROUP:_pixel,15
@26@814:
   ;	
   ;	            setpix(x, y, pixel);
   ;	
	mov	al,byte ptr DGROUP:_pixel
	push	ax
	push	word ptr DGROUP:_y
	push	word ptr DGROUP:_x
	call	near ptr _setpix
	add	sp,6
   ;	
   ;	            x = x + 1;
   ;	
	mov	ax,word ptr DGROUP:_x
	inc	ax
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	            if (x == (orgX + 10 + width))
   ;	
	movsx	eax,word ptr DGROUP:_x
	mov	dx,word ptr DGROUP:_orgX
	add	dx,10
	movsx	edx,dx
	add	edx,dword ptr DGROUP:_width
	cmp	eax,edx
	jne	short @26@870
   ;	
   ;	            {
   ;	               x = orgX + 10;
   ;	
	mov	ax,word ptr DGROUP:_orgX
	add	ax,10
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	               y = y - 1;
   ;	
	mov	ax,word ptr DGROUP:_y
	dec	ax
	mov	word ptr DGROUP:_y,ax
@26@870:
	inc	byte ptr DGROUP:_maskJ
@26@898:
	cmp	byte ptr DGROUP:_maskJ,7
	ja short	@@8
	jmp	@26@758
@@8:
@26@926:
   ;	
   ;	            } 
   ;	        }
   ;	     }
   ;	     if ((colors == 16)||(colors == 256))
   ;	
	cmp	word ptr DGROUP:_colors,16
	je	short @26@982
	cmp	word ptr DGROUP:_colors,256
	je short	@@9
	jmp	@26@1402
@@9:
@26@982:
   ;	
   ;	     {
   ;	         if (colors == 256)
   ;	
	cmp	word ptr DGROUP:_colors,256
	jne	short @26@1038
   ;	
   ;	            pixel = buffer[offsetBuffer + picI];
   ;	
	mov	ax,word ptr DGROUP:_offsetBuffer
	add	ax,word ptr DGROUP:_picI
	les	bx,dword ptr DGROUP:_buffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr DGROUP:_pixel,al
@26@1038:
   ;	
   ;	         if (colors == 16)
   ;	
	cmp	word ptr DGROUP:_colors,16
	jne	short @26@1094
   ;	
   ;	            pixel = buffer[offsetBuffer + picI] >> 4 ;
   ;	
	mov	ax,word ptr DGROUP:_offsetBuffer
	add	ax,word ptr DGROUP:_picI
	les	bx,dword ptr DGROUP:_buffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	ah,0
	sar	ax,4
	mov	byte ptr DGROUP:_pixel,al
@26@1094:
   ;	
   ;	         
   ;	         if (!( (unusedMask == true)&&( x > (orgX + 10 + originalWidth)) ))
   ;	
	cmp	word ptr DGROUP:_unusedMask,1
	jne	short @26@1150
	mov	ax,word ptr DGROUP:_orgX
	add	ax,10
	add	ax,word ptr DGROUP:_originalWidth
	cmp	ax,word ptr DGROUP:_x
	jb	short @26@1178
@26@1150:
   ;	
   ;	         {
   ;	            setpix(x, y, pixel);
   ;	
	mov	al,byte ptr DGROUP:_pixel
	push	ax
	push	word ptr DGROUP:_y
	push	word ptr DGROUP:_x
	call	near ptr _setpix
	add	sp,6
@26@1178:
   ;	
   ;	         }   
   ;	         
   ;	         x = x + 1;
   ;	
	mov	ax,word ptr DGROUP:_x
	inc	ax
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	         if (x == (orgX + 10 + width))
   ;	
	movsx	eax,word ptr DGROUP:_x
	mov	dx,word ptr DGROUP:_orgX
	add	dx,10
	movsx	edx,dx
	add	edx,dword ptr DGROUP:_width
	cmp	eax,edx
	jne	short @26@1234
   ;	
   ;	         {
   ;	            x = orgX + 10;
   ;	
	mov	ax,word ptr DGROUP:_orgX
	add	ax,10
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	            y = y - 1;
   ;	
	mov	ax,word ptr DGROUP:_y
	dec	ax
	mov	word ptr DGROUP:_y,ax
@26@1234:
   ;	
   ;	         } 
   ;	         
   ;	         if (colors == 16)
   ;	
	cmp	word ptr DGROUP:_colors,16
	jne	short @26@1402
   ;	
   ;	         {
   ;	           pixel = (buffer[offsetBuffer + picI] & 0x0f);
   ;	
	mov	ax,word ptr DGROUP:_offsetBuffer
	add	ax,word ptr DGROUP:_picI
	les	bx,dword ptr DGROUP:_buffer
	add	bx,ax
	mov	al,byte ptr es:[bx]
	and	al,15
	mov	byte ptr DGROUP:_pixel,al
   ;	
   ;	           
   ;	           if (!( (unusedMask == true)&&( x > (orgX + 10 + originalWidth)) ))
   ;	
	cmp	word ptr DGROUP:_unusedMask,1
	jne	short @26@1318
	mov	ax,word ptr DGROUP:_orgX
	add	ax,10
	add	ax,word ptr DGROUP:_originalWidth
	cmp	ax,word ptr DGROUP:_x
	jb	short @26@1346
@26@1318:
   ;	
   ;	           {
   ;	              setpix(x, y, pixel);
   ;	
	mov	al,byte ptr DGROUP:_pixel
	push	ax
	push	word ptr DGROUP:_y
	push	word ptr DGROUP:_x
	call	near ptr _setpix
	add	sp,6
@26@1346:
   ;	
   ;	           }   
   ;	
   ;	           x = x + 1;
   ;	
	mov	ax,word ptr DGROUP:_x
	inc	ax
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	           if (x == (orgX + 10 + width))
   ;	
	movsx	eax,word ptr DGROUP:_x
	mov	dx,word ptr DGROUP:_orgX
	add	dx,10
	movsx	edx,dx
	add	edx,dword ptr DGROUP:_width
	cmp	eax,edx
	jne	short @26@1402
   ;	
   ;	           {
   ;	              x = orgX + 10;
   ;	
	mov	ax,word ptr DGROUP:_orgX
	add	ax,10
	mov	word ptr DGROUP:_x,ax
   ;	
   ;	              y = y - 1;
   ;	
	mov	ax,word ptr DGROUP:_y
	dec	ax
	mov	word ptr DGROUP:_y,ax
@26@1402:
	inc	word ptr DGROUP:_picI
@26@1430:
	movzx	eax,word ptr DGROUP:_picI
	cmp	eax,dword ptr DGROUP:_szImage
	ja short	@@10
	jmp	@26@702
@@10:
   ;	
   ;	           }          
   ;	           
   ;	         }  
   ;	
   ;	         
   ;	     }    
   ;	     
   ;	 }        
   ;	 
   ;	 fclose(input);
   ;	
	push	dword ptr DGROUP:_input
	call	near ptr _fclose
	add	sp,4
@26@1486:
   ;	
   ;	 
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_StartProgram	endp
_TEXT	ends
VP	segment word public use16 'BSS'
_originalWidth	label	word
	db	2 dup (?)
_offsetPal	label	word
	db	2 dup (?)
_offsetBuffer	label	word
	db	2 dup (?)
_maskJ	label	byte
	db	1 dup (?)
_blue	label	byte
	db	1 dup (?)
_green	label	byte
	db	1 dup (?)
_red	label	byte
	db	1 dup (?)
_y	label	word
	db	2 dup (?)
_x	label	word
	db	2 dup (?)
_orgY	label	word
	db	2 dup (?)
_orgX	label	word
	db	2 dup (?)
_pixel	label	byte
	db	1 dup (?)
_colors	label	word
	db	2 dup (?)
_colorsBits	label	word
	db	2 dup (?)
_szImage	label	word
	db	4 dup (?)
_height	label	word
	db	4 dup (?)
_width	label	word
	db	4 dup (?)
_filename	label	word
	db	2 dup (?)
_filesize	label	word
	db	4 dup (?)
_buffer	label	dword
	db	4 dup (?)
_input	label	dword
	db	4 dup (?)
_FormWnd	label	dword
	db	4 dup (?)
_SysBufOffset	label	word
	db	2 dup (?)
_SysBufSegment	label	word
	db	2 dup (?)
dumWnd	label	word
	db	2 dup (?)
_SysBuf	label	dword
	db	4 dup (?)
DataSegment	label	word
	db	2 dup (?)
	?debug	C E9
	?debug	C FA11020000
VP	ends
_DATA	segment word public use16 'VP'
s@	label	byte
	db	10
	db	'File name=%s'
	db	0
	db	'rb'
	db	0
	db	10
	db	' ** can'
	db	39
	db	't read %s.'
	db	0
	db	10
	db	'File size=%u'
	db	0
	db	10
	db	' ** BMP signature not found.'
	db	0
	db	10
	db	'BMP header = %c%c'
	db	0
	db	10
	db	'BMP width = %u'
	db	0
	db	10
	db	'BMP height = %u'
	db	0
	db	10
	db	'BMP size = %u'
	db	0
	db	10
	db	'BMP colors bits = %u'
	db	0
	db	10
	db	'BMP colors = %u'
	db	0
	db	10
	db	'BMP recalculated width = %u'
	db	0
	db	10
	db	'BMP unusedMask = %u'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	public	_setPal
	public	_setpix
	public	_color16palMapping
	public	_originalWidth
	public	_unusedMask
	public	_offsetPal
	public	_offsetBuffer
	public	_maskJ
	public	_blue
	public	_green
	public	_red
	public	_picI
	public	_y
	public	_x
	public	_orgY
	public	_orgX
	public	_pixel
	public	_colors
	public	_colorsBits
	public	_szImage
	public	_height
	public	_width
	public	_filename
	public	_WinMain
	public	_filesize
	public	_buffer
	public	_input
	public	_FormWnd
	extrn	_setpix2:near
	extrn	_setpix1:near
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
	public	_SysBuf
_DataSegment	equ	DataSegment
	extrn	__setargv__:far
	public	_main
	public	_Init
	public	_StartProgram
	extrn	_memcpy:near
	extrn	_free:near
	extrn	_fsize:near
	extrn	_fclose:near
	extrn	_fopen:near
	extrn	_printf:near
_s@	equ	s@
	end
