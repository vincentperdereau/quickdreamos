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
	?debug	S "ng.c"
	?debug	C E90472022B046E672E63
	?debug	C E9B1A1D52809737461727475702E68
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
	?debug	C E971635A2A08737472696E672E68
   ;	
   ;	  void strcpy (string c, string s)
   ;	
	assume	cs:MGRP
_strcpy	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;s[i]!=0;i++) c[i]=s[i];
   ;	
	mov	cl,0
	jmp	short @2@114
@2@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@2@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @2@58
   ;	
   ;	   c[i]=0;
   ;	
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	byte ptr [bx+si],0
   ;	
   ;	  }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_strcpy	endp
   ;	
   ;	  uchar strlen (string s)
   ;	
	assume	cs:MGRP
_strlen	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;s[i]!=0;i++);
   ;	
	mov	dl,0
	jmp	short @3@86
@3@58:
	inc	dl
@3@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @3@58
   ;	
   ;	   return i;
   ;	
	mov	al,dl
   ;	
   ;	  }
   ;	
	pop	bp
	ret	
_strlen	endp
   ;	
   ;	  void strcat (string c, string s)
   ;	
	assume	cs:MGRP
_strcat	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	  {
   ;	   strcpy ( (string)&(c[strlen(c)]),s);
   ;	
	push	word ptr [bp+6]
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_strcpy
	add	sp,4
   ;	
   ;	  }
   ;	
	pop	si
	pop	bp
	ret	
_strcat	endp
   ;	
   ;	  bool strcmp (string a, string b)
   ;	
	assume	cs:MGRP
_strcmp	proc	near
	enter	2,0
	push	si
	mov	cx,word ptr [bp+4]
	mov	si,word ptr [bp+6]
   ;	
   ;	  {
   ;	   register uchar i;
   ;	   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   ;	
	mov	byte ptr [bp-1],0
	jmp	short @5@86
@5@58:
	inc	byte ptr [bp-1]
@5@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @5@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @5@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @5@58
@5@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @5@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @5@254
	mov	al,0
	jmp	short @5@282
@5@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@5@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
	?debug	C E979A5F22A0666696C652E68
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
_isFont	label	byte
	db	0
oldx	label	word
	db	64
	db	1
oldy	label	word
	db	240
	db	0
cursor	label	byte
	db	0
	db	0
	db	0
	db	0
	db	1
	db	0
	db	1
	db	1
	db	0
	db	0
	db	2
	db	0
	db	1
	db	2
	db	15
	db	2
	db	2
	db	0
	db	0
	db	3
	db	0
	db	1
	db	3
	db	15
	db	2
	db	3
	db	15
	db	3
	db	3
	db	0
	db	0
	db	4
	db	0
	db	1
	db	4
	db	15
	db	2
	db	4
	db	15
	db	3
	db	4
	db	15
	db	4
	db	4
	db	0
	db	0
	db	5
	db	0
	db	1
	db	5
	db	15
	db	2
	db	5
	db	15
	db	3
	db	5
	db	15
	db	4
	db	5
	db	15
	db	5
	db	5
	db	0
	db	0
	db	6
	db	0
	db	1
	db	6
	db	0
	db	2
	db	6
	db	0
	db	3
	db	6
	db	0
	db	4
	db	6
	db	0
	db	5
	db	6
	db	0
	db	6
	db	6
	db	0
flag	label	word
	db	0
	db	0
mouse_status	label	word
	db	0
	db	0
   ;	
   ;	void mouse_handler ()
   ;	
	assume	cs:MGRP
_mouse_handler	proc	near
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
   ;	
   ;	 if (mouse_status)
   ;	
	cmp	word ptr MGRP:mouse_status,0
	jne short	@@0
	jmp	@10@394
@@0:
   ;	
   ;	 {
   ;	
   ;	 mx = _CX;
   ;	
	mov	word ptr MGRP:mx,cx
   ;	
   ;	 my = _DX;
   ;	
	mov	word ptr MGRP:my,dx
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	mov	word ptr MGRP:i,0
	jmp	short @10@226
@10@142:
   ;	
   ;	  {
   ;	    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @10@198
	mov	bx,word ptr MGRP:i
	mov	al,byte ptr MGRP:swap[bx]
	push	ax
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:oldy
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:oldx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@10@198:
	inc	word ptr MGRP:i
@10@226:
	cmp	word ptr MGRP:i,27
	jle	short @10@142
   ;	
   ;	  }
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	mov	word ptr MGRP:i,0
	jmp	short @10@338
@10@282:
   ;	
   ;	  {
   ;	     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
   ;	
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_getpix
	add	sp,4
	mov	bx,word ptr MGRP:i
	mov	byte ptr MGRP:swap[bx],al
   ;	
   ;	     setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
   ;	
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+2]
	push	ax
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,word ptr MGRP:i
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr MGRP:i
@10@338:
	cmp	word ptr MGRP:i,27
	jle	short @10@282
   ;	
   ;	  }
   ;	
   ;	  flag = 1;
   ;	
	mov	word ptr MGRP:flag,1
   ;	
   ;	  oldx = mx;
   ;	
	mov	ax,word ptr MGRP:mx
	mov	word ptr MGRP:oldx,ax
   ;	
   ;	  oldy = my;
   ;	
	mov	ax,word ptr MGRP:my
	mov	word ptr MGRP:oldy,ax
@10@394:
   ;	
   ;	 }
   ;	 asm { pop ds dx cx bx ax };
   ;	
 	pop	 ds dx cx bx ax 
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_mouse_handler	endp
   ;	
   ;	unsigned int ismouse (void)
   ;	
	assume	cs:MGRP
_ismouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	       mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;	      // int 0x33
   ;	     }
   ;	}
   ;	
	ret	
_ismouse	endp
   ;	
   ;	void showmouse ()
   ;	
	assume	cs:MGRP
_showmouse	proc	near
	push	si
   ;	
   ;	{
   ;	 register int i;
   ;	
   ;	 if ( ismouse()  != 0xffff) return;
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	je short	@@1
	jmp	@12@226
@@1:
   ;	
   ;	
   ;	 mx = oldx; my = oldy;
   ;	
	mov	ax,word ptr MGRP:oldx
	mov	word ptr MGRP:mx,ax
	mov	ax,word ptr MGRP:oldy
	mov	word ptr MGRP:my,ax
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	xor	si,si
	jmp	short @12@170
@12@86:
   ;	
   ;	  {
   ;	     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
   ;	
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_getpix
	add	sp,4
	mov	byte ptr MGRP:swap[si],al
   ;	
   ;	     if (flag) setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @12@142
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+2]
	push	ax
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:my
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:mx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@12@142:
	inc	si
@12@170:
	cmp	si,27
	jle	short @12@86
   ;	
   ;	  }
   ;	
   ;	 mouse_status = 1;
   ;	
	mov	word ptr MGRP:mouse_status,1
@12@226:
   ;	
   ;	// show_mouse = 1;
   ;	}
   ;	
	pop	si
	ret	
_showmouse	endp
   ;	
   ;	void hidemouse ()
   ;	
	assume	cs:MGRP
_hidemouse	proc	near
	push	si
   ;	
   ;	{
   ;	 register int i;
   ;	
   ;	 if ( ismouse()  != 0xffff) return;
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @13@226
   ;	
   ;	
   ;	  for (i=0 ; i <= 27 ; i++)
   ;	
	xor	si,si
	jmp	short @13@170
@13@86:
   ;	
   ;	  {
   ;	    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
   ;	
	cmp	word ptr MGRP:flag,0
	je	short @13@142
	mov	al,byte ptr MGRP:swap[si]
	push	ax
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx+1]
	mov	ah,0
	mov	dx,word ptr MGRP:oldy
	add	dx,ax
	push	dx
	mov	bx,si
	imul	bx,bx,3
	mov	al,byte ptr MGRP:cursor[bx]
	mov	ah,0
	mov	dx,word ptr MGRP:oldx
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@13@142:
	inc	si
@13@170:
	cmp	si,27
	jle	short @13@86
   ;	
   ;	  }
   ;	 mouse_status = 0;
   ;	
	mov	word ptr MGRP:mouse_status,0
@13@226:
   ;	
   ;	// show_mouse = 0;
   ;	}
   ;	
	pop	si
	ret	
_hidemouse	endp
   ;	
   ;	void init_mouse (void)
   ;	
	assume	cs:MGRP
_init_mouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        push ax bx cx es
   ;	
	push	 ax bx cx es
   ;	
   ;		mov ax,4
   ;	
	mov	 ax,4
   ;	
   ;		mov bx,640
   ;	
	mov	 bx,640
   ;	
   ;		mov cx,480
   ;	
	mov	 cx,480
   ;	
   ;	       // int 0x33
   ;		mov ax,5
   ;	
	mov	 ax,5
   ;	
   ;		mov bx,1
   ;	
	mov	 bx,1
   ;	
   ;		mov cx,1
   ;	
	mov	 cx,1
   ;	
   ;	       // int 0x33
   ;		mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov ax,1
   ;	
	mov	 ax,1
   ;	
   ;		mov bx,offset MGRP:_mouse_handler
   ;	
	mov	 bx,offset MGRP:_mouse_handler
   ;	
   ;	       // int 0x33
   ;		mov ax,6
   ;	
	mov	 ax,6
   ;	
   ;	       // int 0x33
   ;	        pop es cx bx ax
   ;	
	pop	 es cx bx ax
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_init_mouse	endp
   ;	
   ;	void shut_mouse (void)
   ;	
	assume	cs:MGRP
_shut_mouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ax,2
   ;	
	mov	 ax,2
   ;	
   ;	      //  int 0x33
   ;		mov ax,7
   ;	
	mov	 ax,7
   ;	
   ;	      //  int 0x33
   ;	     }
   ;	}
   ;	
	ret	
_shut_mouse	endp
   ;	
   ;	int bmouse (void)
   ;	
	assume	cs:MGRP
_bmouse	proc	near
   ;	
   ;	{
   ;	 asm {
   ;		mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;	      //  int 0x33
   ;		mov ax,bx
   ;	
	mov	 ax,bx
   ;	
   ;	     }
   ;	}
   ;	
	ret	
_bmouse	endp
   ;	
   ;	char is_key (void)
   ;	
	assume	cs:MGRP
_is_key	proc	near
   ;	
   ;	{
   ;	 asm {
   ;	        mov ah,1
   ;	
	mov	 ah,1
   ;	
   ;	        int 0x16
   ;	
	int	 016H
   ;	
   ;	        setz al
   ;	
	setz	 al
   ;	
   ;	        xor al,1
   ;	
	xor	 al,1
   ;	
   ;	
   ;	       mov al,0
   ;	
	mov	 al,0
   ;	
   ;	
   ;	      }
   ;	}
   ;	
	ret	
_is_key	endp
   ;	
   ;	void SetVideo (char stat)
   ;	
	assume	cs:MGRP
_SetVideo	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	return;
   ;	
	jmp	short @18@170
   ;	
   ;	 asm {
   ;		mov ah,0x12
   ;	
	mov	 ah,012H
   ;	
   ;		mov bl,0x36
   ;	
	mov	 bl,036H
   ;	
   ;		mov al,stat
   ;	
	mov	 al,[bp+4]
   ;	
   ;		int 0x10
   ;	
	int	 010H
@18@170:
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_SetVideo	endp
_fptr	label	dword
	db	0
	db	0
	db	0
	db	0
   ;	
   ;	void PrintChar( char caractere, int x, int y, BYTE cc, BYTE cf , BYTE m)
   ;	
	assume	cs:MGRP
_PrintChar	proc	near
	enter	4,0
	push	si
	push	di
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
   ;	
   ;	{
   ;	
   ;	 BYTE         i, k, j,                         /* Compteur d'it‚rations */
   ;	       masque;           /* Masque binaire pour dessiner le caractŠre */
   ;	
   ;	 if ( fptr == (CARPTR) 0 )     /* A-t-on d‚j… d‚termin‚ ce pointeur ? */
   ;	
	cmp	dword ptr MGRP:_fptr,large 0
	jne	short @19@86
   ;	
   ;	  fptr = getfontptr();    /* d‚termine avec la fonction en assembleur */
   ;	
	call	near ptr MGRP:_getfontptr
	mov	word ptr MGRP:_fptr+2,dx
	mov	word ptr MGRP:_fptr,ax
@19@86:
   ;	
   ;	
   ;	
   ;	  /*- Dessine le caractŠre pixel par pixel ---------------------------*/
   ;	
   ;	 if ( cf == 255 )                          /* CaractŠre transparent ? */
   ;	
	cmp	byte ptr [bp+12],255
	je short	@@2
	jmp	@19@366
@@2:
   ;	
   ;	  for ( i = 0, j = 0; i < (16<<m); i += (m+1),++j ) /* dessine que les pixels du premier plan */
   ;	
	mov	byte ptr [bp-1],0
	mov	byte ptr [bp-3],0
	jmp	@19@310
@19@142:
   ;	
   ;	   {
   ;	    masque = (*fptr)[caractere][j];         /* Lit le motif bin/ligne */
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	shl	ax,4
	les	bx,dword ptr MGRP:_fptr
	add	bx,ax
	mov	al,byte ptr [bp-3]
	mov	ah,0
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-4],al
   ;	
   ;	    for ( k = 0; k < (8<<m); k += (m+1), masque <<= 1 )  /* Parcourt les colonnes */
   ;	
	mov	byte ptr [bp-2],0
	jmp	short @19@254
@19@170:
   ;	
   ;	     {
   ;	     if ( masque & 128 )                        /* Pixel … dessiner ? */
   ;	
	test	byte ptr [bp-4],128
	je	short @19@226
   ;	
   ;	      {
   ;	       setpix( x+k, y+i, cc );                                  /* Oui */
   ;	
	mov	al,byte ptr [bp+10]
	push	ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,di
	add	dx,ax
	push	dx
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
@19@226:
	mov	al,byte ptr [bp+14]
	add	al,byte ptr [bp-2]
	inc	al
	mov	byte ptr [bp-2],al
	shl	byte ptr [bp-4],1
@19@254:
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,8
	mov	cl,byte ptr [bp+14]
	shl	dx,cl
	cmp	ax,dx
	jl	short @19@170
	mov	al,byte ptr [bp+14]
	add	al,byte ptr [bp-1]
	inc	al
	mov	byte ptr [bp-1],al
	mov	al,byte ptr [bp-3]
	inc	al
	mov	byte ptr [bp-3],al
@19@310:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,16
	mov	cl,byte ptr [bp+14]
	shl	dx,cl
	cmp	ax,dx
	jge short	@@3
	jmp	@19@142
@@3:
   ;	
   ;	      }
   ;	    }
   ;	   }
   ;	
	jmp	short @19@646
@19@366:
   ;	
   ;	 else                                     /* Non dessine chaque pixel */
   ;	  for ( i = 0; i < 8; ++i )                    /* Parcourt les lignes */
   ;	
	mov	byte ptr [bp-1],0
	jmp	short @19@618
@19@394:
   ;	
   ;	  {
   ;	   masque = (*fptr)[caractere][i];          /* Lit le motif bin/ligne */
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	shl	ax,4
	les	bx,dword ptr MGRP:_fptr
	add	bx,ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-4],al
   ;	
   ;	   for ( k = 0; k < 8; ++k, masque <<= 1 )   /* Parcourt les colonnes */
   ;	
	mov	byte ptr [bp-2],0
	jmp	short @19@562
@19@422:
   ;	
   ;	    setpix( x+k, y+i, (BYTE) (( masque & 128 ) ? cc : cf) );
   ;	
	test	byte ptr [bp-4],128
	je	short @19@478
	mov	al,byte ptr [bp+10]
	jmp	short @19@506
@19@478:
	mov	al,byte ptr [bp+12]
@19@506:
	push	ax
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	dx,di
	add	dx,ax
	push	dx
	mov	al,byte ptr [bp-2]
	mov	ah,0
	mov	dx,si
	add	dx,ax
	push	dx
	call	near ptr MGRP:_setpix
	add	sp,6
	mov	al,byte ptr [bp-2]
	inc	al
	mov	byte ptr [bp-2],al
	shl	byte ptr [bp-4],1
@19@562:
	cmp	byte ptr [bp-2],8
	jb	short @19@422
	mov	al,byte ptr [bp-1]
	inc	al
	mov	byte ptr [bp-1],al
@19@618:
	cmp	byte ptr [bp-1],8
	jb	short @19@394
@19@646:
   ;	
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_PrintChar	endp
   ;	
   ;	unsigned long getOfs (int i)
   ;	
	assume	cs:MGRP
_getOfs	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        mov dx,0x8000
   ;	
	mov	 dx,08000H
   ;	
   ;	        mov ax,i
   ;	
	mov	 ax,[bp+4]
   ;	
   ;	        shl ax,12
   ;	
	shl	 ax,12
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_getOfs	endp
   ;	
   ;	void setFont (int i)
   ;	
	assume	cs:MGRP
_setFont	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 fptr = (CARPTR)(getOfs (i));
   ;	
	push	word ptr [bp+4]
	call	near ptr MGRP:_getOfs
	push	dx
	push	ax
	pop	eax
	pop	cx
	shld	edx,eax,16
	mov	word ptr MGRP:_fptr+2,dx
	mov	word ptr MGRP:_fptr,ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_setFont	endp
   ;	
   ;	int abs (int n)
   ;	
	assume	cs:MGRP
_abs	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        mov ax,n
   ;	
	mov	 ax,[bp+4]
   ;	
   ;	        and ax,0111111111111111b
   ;	
	and	 ax,0111111111111111b
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_abs	endp
   ;	
   ;	void SwapInt( int *i1, int *i2 )
   ;	
	assume	cs:MGRP
_SwapInt	proc	near
	enter	2,0
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 int dummy;
   ;	
   ;	 dummy = *i2;
   ;	
	mov	ax,word ptr [di]
	mov	word ptr [bp-2],ax
   ;	
   ;	 *i2   = *i1;
   ;	
	mov	ax,word ptr [si]
	mov	word ptr [di],ax
   ;	
   ;	 *i1   = dummy;
   ;	
	mov	ax,word ptr [bp-2]
	mov	word ptr [si],ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_SwapInt	endp
   ;	
   ;	void Line( int x1, int y1, int x2, int y2)
   ;	
	assume	cs:MGRP
_Line	proc	near
	enter	12,0
	push	si
	push	di
   ;	
   ;	{
   ;	 int d, dx, dy,
   ;	     aincr, bincr,
   ;	     xincr, yincr,
   ;	     x, y;
   ;	
   ;	 if ( abs(x2-x1) < abs(y2-y1) )            /* Parcours : axe X ou Y ? */
   ;	
	mov	ax,word ptr [bp+8]
	sub	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	push	ax
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	pop	dx
	cmp	dx,ax
	jl short	@@4
	jmp	@24@422
@@4:
   ;	
   ;	  {                                                          /* Par Y */
   ;	   if ( y1 > y2 )                            /* y1 plus grand que y2? */
   ;	
	mov	ax,word ptr [bp+6]
	cmp	ax,word ptr [bp+10]
	jle	short @24@114
   ;	
   ;	    {
   ;	     SwapInt( &x1, &x2 );                    /* Oui ‚change X1 et X2, */
   ;	
	lea	ax,word ptr [bp+8]
	push	ax
	lea	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
   ;	
   ;	     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
   ;	
	lea	ax,word ptr [bp+10]
	push	ax
	lea	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
@24@114:
   ;	
   ;	    }
   ;	
   ;	   xincr = ( x2 > x1 ) ?  1 : -1;           /* Fixe le pas horizontal */
   ;	
	mov	ax,word ptr [bp+8]
	cmp	ax,word ptr [bp+4]
	jle	short @24@170
	mov	ax,1
	jmp	short @24@198
@24@170:
	mov	ax,-1
@24@198:
	mov	word ptr [bp-8],ax
   ;	
   ;	
   ;	   dy = y2 - y1;
   ;	
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	mov	word ptr [bp-2],ax
   ;	
   ;	   dx = abs( x2-x1 );
   ;	
	mov	ax,word ptr [bp+8]
	sub	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	mov	di,ax
   ;	
   ;	   d  = 2 * dx - dy;
   ;	
	mov	si,di
	shl	si,1
	sub	si,word ptr [bp-2]
   ;	
   ;	   aincr = 2 * (dx - dy);
   ;	
	sub	ax,word ptr [bp-2]
	shl	ax,1
	mov	word ptr [bp-4],ax
   ;	
   ;	   bincr = 2 * dx;
   ;	
	mov	ax,di
	shl	ax,1
	mov	word ptr [bp-6],ax
   ;	
   ;	   x = x1;
   ;	
	mov	di,word ptr [bp+4]
   ;	
   ;	   y = y1;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr [bp-12],ax
   ;	
   ;	
   ;	   setpix( x, y, COLOR );               /* dessine le premier pixel */
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	   for (y=y1+1; y<= y2; ++y )                 /* Parcourt l'axe des Y */
   ;	
	mov	ax,word ptr [bp+6]
	inc	ax
	mov	word ptr [bp-12],ax
	jmp	short @24@366
@24@226:
   ;	
   ;	    {
   ;	     if ( d >= 0 )
   ;	
	or	si,si
	jl	short @24@282
   ;	
   ;	      {
   ;	       x += xincr;
   ;	
	add	di,word ptr [bp-8]
   ;	
   ;	       d += aincr;
   ;	
	add	si,word ptr [bp-4]
   ;	
   ;	      }
   ;	
	jmp	short @24@310
@24@282:
   ;	
   ;	     else
   ;	      d += bincr;
   ;	
	add	si,word ptr [bp-6]
@24@310:
   ;	
   ;	     setpix( x, y, COLOR );
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr [bp-12]
@24@366:
	mov	ax,word ptr [bp-12]
	cmp	ax,word ptr [bp+10]
	jle	short @24@226
   ;	
   ;	    }
   ;	  }
   ;	
	jmp	@24@758
@24@422:
   ;	
   ;	 else                                                        /* par X */
   ;	  {
   ;	   if ( x1 > x2 )                            /* x1 plus grand que x2? */
   ;	
	mov	ax,word ptr [bp+4]
	cmp	ax,word ptr [bp+8]
	jle	short @24@478
   ;	
   ;	    {
   ;	     SwapInt( &x1, &x2 );                     /* Oui, ‚change X1 et X2*/
   ;	
	lea	ax,word ptr [bp+8]
	push	ax
	lea	ax,word ptr [bp+4]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
   ;	
   ;	     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
   ;	
	lea	ax,word ptr [bp+10]
	push	ax
	lea	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_SwapInt
	add	sp,4
@24@478:
   ;	
   ;	    }
   ;	
   ;	   yincr = ( y2 > y1 ) ? 1 : -1;              /* Fixe le pas vertical */
   ;	
	mov	ax,word ptr [bp+10]
	cmp	ax,word ptr [bp+6]
	jle	short @24@534
	mov	ax,1
	jmp	short @24@562
@24@534:
	mov	ax,-1
@24@562:
	mov	word ptr [bp-10],ax
   ;	
   ;	
   ;	   dx = x2 - x1;
   ;	
	mov	di,word ptr [bp+8]
	sub	di,word ptr [bp+4]
   ;	
   ;	   dy = abs( y2-y1 );
   ;	
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+6]
	push	ax
	call	near ptr MGRP:_abs
	pop	cx
	mov	word ptr [bp-2],ax
   ;	
   ;	   d  = 2 * dy - dx;
   ;	
	mov	si,word ptr [bp-2]
	shl	si,1
	sub	si,di
   ;	
   ;	   aincr = 2 * (dy - dx);
   ;	
	sub	ax,di
	shl	ax,1
	mov	word ptr [bp-4],ax
   ;	
   ;	   bincr = 2 * dy;
   ;	
	mov	ax,word ptr [bp-2]
	shl	ax,1
	mov	word ptr [bp-6],ax
   ;	
   ;	   x = x1;
   ;	
	mov	di,word ptr [bp+4]
   ;	
   ;	   y = y1;
   ;	
	mov	ax,word ptr [bp+6]
	mov	word ptr [bp-12],ax
   ;	
   ;	
   ;	/*   SetPixel*/
   ;	   setpix( x, y, COLOR );               /* Dessine le premier pixel */
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	   for (x=x1+1; x<=x2; ++x )                  /* Parcourt l'axe des X */
   ;	
	mov	di,word ptr [bp+4]
	inc	di
	jmp	short @24@730
@24@590:
   ;	
   ;	    {
   ;	     if ( d >= 0 )
   ;	
	or	si,si
	jl	short @24@646
   ;	
   ;	      {
   ;	       y += yincr;
   ;	
	mov	ax,word ptr [bp-10]
	add	word ptr [bp-12],ax
   ;	
   ;	       d += aincr;
   ;	
	add	si,word ptr [bp-4]
   ;	
   ;	      }
   ;	
	jmp	short @24@674
@24@646:
   ;	
   ;	     else
   ;	      d += bincr;
   ;	
	add	si,word ptr [bp-6]
@24@674:
   ;	
   ;	     setpix( x, y, COLOR );
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp-12]
	push	di
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	di
@24@730:
	cmp	di,word ptr [bp+8]
	jle	short @24@590
@24@758:
   ;	
   ;	    }
   ;	  }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_Line	endp
   ;	
   ;	char pic_peek (unsigned int ofs)
   ;	
	assume	cs:MGRP
_pic_peek	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	        push es
   ;	
	push	 es
   ;	
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        mov ax,9000h
   ;	
	mov	 ax,9000h
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov bx,ofs
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        mov al,es:[bx]
   ;	
	mov	 al,es:[bx]
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	        pop es
   ;	
	pop	 es
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_pic_peek	endp
   ;	
   ;	void pic (char* picname, int h)
   ;	
	assume	cs:MGRP
_pic	proc	near
	enter	8,0
	push	si
	push	di
   ;	
   ;	{
   ;	handle stream;
   ;	
   ;	unsigned int pici=0;
   ;	
   ;	
   ;	unsigned int picx=160,picy;
   ;	
	mov	si,160
   ;	
   ;	signed char picj=0;
   ;	
   ;	
   ;	unsigned char pixel;
   ;	
   ;	 picy = h+200;
   ;	
	mov	ax,word ptr [bp+6]
	add	ax,200
	mov	word ptr [bp-6],ax
   ;	
   ;	
   ;	 stream = fopen (picname);
   ;	
	push	word ptr [bp+4]
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	 if (stream < 2) return;
   ;	
	cmp	dword ptr [bp-4],large 2
	jb	short @26@338
   ;	
   ;	 fread (stream,8062,0,0x9000);
   ;	
	push	large 090000000h
	push	large 8062
	push	dword ptr [bp-4]
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	
   ;	 for (pici=0;pici<=(8000-1);pici++)
   ;	
	xor	di,di
	jmp	short @26@310
@26@86:
   ;	
   ;	 {
   ;	  for (picj=0;picj<=7;picj++)
   ;	
	mov	byte ptr [bp-7],0
	jmp	short @26@254
@26@114:
   ;	
   ;	   {
   ;	    pixel = (pic_peek(pici+62) & (128>>picj));
   ;	
	mov	ax,di
	add	ax,62
	push	ax
	call	near ptr MGRP:_pic_peek
	pop	cx
	mov	dx,128
	mov	cl,byte ptr [bp-7]
	sar	dx,cl
	and	al,dl
	mov	dl,al
   ;	
   ;	    if (!pixel) setpix (picx,picy,pixel );
   ;	
	mov	ah,0
	or	ax,ax
	jne	short @26@170
	push	dx
	push	word ptr [bp-6]
	push	si
	call	near ptr MGRP:_setpix
	add	sp,6
@26@170:
   ;	
   ;	    picx++;
   ;	
	inc	si
   ;	
   ;	    if (picx==480) { picy--;picx=160;}
   ;	
	cmp	si,480
	jne	short @26@226
	dec	word ptr [bp-6]
	mov	si,160
@26@226:
	inc	byte ptr [bp-7]
@26@254:
	cmp	byte ptr [bp-7],7
	jle	short @26@114
	inc	di
@26@310:
	cmp	di,7999
	jbe	short @26@86
@26@338:
   ;	
   ;	   }
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_pic	endp
   ;	
   ;	void OutTextXY (int X, int Y,char* s, char ul, BYTE m)
   ;	
	assume	cs:MGRP
_OutTextXY	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 register int i;
   ;	 for (i=0; s[i] != 0; i++)
   ;	
	xor	si,si
	jmp	short @27@142
@27@58:
   ;	
   ;	 {
   ;	  PrintChar (s[i],X+( (i<<3) << m) ,Y,COLOR,255,m);
   ;	
	mov	al,byte ptr [bp+12]
	push	ax
	push	255
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp+6]
	mov	ax,si
	shl	ax,3
	mov	cl,byte ptr [bp+12]
	shl	ax,cl
	mov	dx,di
	add	dx,ax
	push	dx
	mov	bx,word ptr [bp+8]
	add	bx,si
	mov	al,byte ptr [bx]
	push	ax
	call	near ptr MGRP:_PrintChar
	add	sp,12
   ;	
   ;	  if (ul) Line ( X+(i<<3),Y+14,X+(i<<3)+(8<<m),Y+14);
   ;	
	cmp	byte ptr [bp+10],0
	je	short @27@114
	mov	ax,word ptr [bp+6]
	add	ax,14
	push	ax
	mov	ax,si
	shl	ax,3
	mov	dx,di
	add	dx,ax
	mov	ax,8
	mov	cl,byte ptr [bp+12]
	shl	ax,cl
	add	dx,ax
	push	dx
	mov	ax,word ptr [bp+6]
	add	ax,14
	push	ax
	mov	ax,si
	shl	ax,3
	mov	dx,di
	add	dx,ax
	push	dx
	call	near ptr MGRP:_Line
	add	sp,8
@27@114:
	inc	si
@27@142:
	mov	bx,word ptr [bp+8]
	add	bx,si
	cmp	byte ptr [bx],0
	jne	short @27@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_OutTextXY	endp
   ;	
   ;	 char peekchar (unsigned int ofs)
   ;	
	assume	cs:MGRP
_peekchar	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	 {
   ;	  asm {
   ;		push ds
   ;	
	push	 ds
   ;	
   ;		push si
   ;	
	push	 si
   ;	
   ;		mov ax,bufferbatch
   ;	
	mov	 ax,MGRP:_bufferbatch
   ;	
   ;		mov ds,ax
   ;	
	mov	 ds,ax
   ;	
   ;		mov si,ofs
   ;	
	mov	 si,[bp+4]
   ;	
   ;		lodsb
   ;	
	lodsb	
   ;	
   ;		pop si
   ;	
	pop	 si
   ;	
   ;		pop ds
   ;	
	pop	 ds
   ;	
   ;	      }
   ;	 }
   ;	
	pop	si
	pop	bp
	ret	
_peekchar	endp
   ;	
   ;	 int fgets (char* s,int in,handle h)
   ;	
	assume	cs:MGRP
_fgets	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	 {
   ;	  int i;
   ;	  for (i=0; (peekchar (file_offset+i) != 13) && (peekchar (file_offset+i) != 0);i++) s[i] = peekchar (file_offset+i);
   ;	
	xor	si,si
	jmp	short @29@114
@29@58:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	mov	bx,si
	mov	byte ptr [bx+di],al
	inc	si
@29@114:
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	cmp	al,13
	je	short @29@170
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @29@58
@29@170:
   ;	
   ;	  if (peekchar (file_offset+i) == 0) return 0;
   ;	
	mov	ax,word ptr MGRP:_file_offset
	add	ax,si
	push	ax
	call	near ptr MGRP:_peekchar
	pop	cx
	or	al,al
	jne	short @29@226
	xor	ax,ax
	jmp	short @29@254
@29@226:
   ;	
   ;	  s[i] = 0;
   ;	
	mov	bx,si
	mov	byte ptr [bx+di],0
   ;	
   ;	  file_offset += i+2;
   ;	
	mov	ax,si
	add	ax,2
	add	word ptr MGRP:_file_offset,ax
   ;	
   ;	  return 1;
   ;	
	mov	ax,1
@29@254:
   ;	
   ;	 }
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_fgets	endp
   ;	
   ;	 addr malloc (unsigned int paragraph)
   ;	
	assume	cs:MGRP
_malloc	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	        push bx
   ;	
	push	 bx
   ;	
   ;	        mov ah,0x0012
   ;	
	mov	 ah,00012H
   ;	
   ;	        mov bx,paragraph
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        int 0x44
   ;	
	int	 044H
   ;	
   ;	        pop bx
   ;	
	pop	 bx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_malloc	endp
   ;	
   ;	 void free (addr adr)
   ;	
	assume	cs:MGRP
_free	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	 {
   ;	  asm {
   ;	       push bx
   ;	
	push	 bx
   ;	
   ;	       mov ah,0x0013
   ;	
	mov	 ah,00013H
   ;	
   ;	       mov bx,adr
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	       int 0x44
   ;	
	int	 044H
   ;	
   ;	       pop bx
   ;	
	pop	 bx
   ;	
   ;	      }
   ;	 }
   ;	
	pop	bp
	ret	
_free	endp
   ;	
   ;	 void clearBufferSegment (void)
   ;	
	assume	cs:MGRP
_clearBufferSegment	proc	near
	push	di
   ;	
   ;	 {
   ;	  asm {
   ;		push ax
   ;	
	push	 ax
   ;	
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		push di
   ;	
	push	 di
   ;	
   ;		mov ax,bufferbatch
   ;	
	mov	 ax,MGRP:_bufferbatch
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov di,0
   ;	
	mov	 di,0
   ;	
   ;	        mov cx,0xfff0
   ;	
	mov	 cx,0fff0H
   ;	
   ;		mov ax,0
   ;	
	mov	 ax,0
   ;	
   ;	        rep stosb
   ;	
	rep stosb	
   ;	
   ;		pop di
   ;	
	pop	 di
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	      }
   ;	 }
   ;	
	pop	di
	ret	
_clearBufferSegment	endp
   ;	
   ;	void Bar (int x, int y, int w, int h)
   ;	
	assume	cs:MGRP
_Bar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	/*
   ;	 register i,j;
   ;	
   ;	 for (i = y; i <= (h); i++)
   ;	  for (j = x; j <= (w); j++)
   ;	   setpix (j,i,COLOR);
   ;	*/
   ;	 barasm (x,y,w,h,COLOR);
   ;	
	mov	al,byte ptr MGRP:_COLOR
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr MGRP:_barasm
	add	sp,10
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_Bar	endp
   ;	
   ;	void SetColor (int color)
   ;	
	assume	cs:MGRP
_SetColor	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 COLOR = color;
   ;	
	mov	al,byte ptr [bp+4]
	mov	byte ptr MGRP:_COLOR,al
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_SetColor	endp
   ;	
   ;	void Rectangle (int x, int y, int x2, int y2)
   ;	
	assume	cs:MGRP
_Rectangle	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	 Line (x,y,x2,y);
   ;	
	push	di
	push	word ptr [bp+8]
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x,y,x,y2);
   ;	
	push	word ptr [bp+10]
	push	si
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x2,y,x2,y2);
   ;	
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	di
	push	word ptr [bp+8]
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (x,y2,x2,y2);
   ;	
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+10]
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_Rectangle	endp
   ;	
   ;	void fillscreen (void)
   ;	
	assume	cs:MGRP
_fillscreen	proc	near
	push	di
   ;	
   ;	{
   ;	 asm {
   ;	   push ax bx cx dx di es
   ;	
	push	 ax bx cx dx di es
   ;	
   ;	   mov ax,(02h shl 8) + 5
   ;	
	mov	 ax,(02h shl 8) + 5
   ;	
   ;	   mov dx,3ceh
   ;	
	mov	 dx,3ceh
   ;	
   ;	   out dx,ax
   ;	
	out	 dx,ax
   ;	
   ;	   mov ax,0a000h
   ;	
	mov	 ax,0a000h
   ;	
   ;	   mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	   mov di,0
   ;	
	mov	 di,0
   ;	
   ;	   mov cx,0ffffh
   ;	
	mov	 cx,0ffffh
   ;	
   ;	   mov al,07h
   ;	
	mov	 al,07h
   ;	
   ;	   rep stosb
   ;	
	rep stosb	
   ;	
   ;	   pop es di dx cx bx ax
   ;	
	pop	 es di dx cx bx ax
   ;	
   ;	  }
   ;	}
   ;	
	pop	di
	ret	
_fillscreen	endp
   ;	
   ;	void Window (int X, int Y, int w, int h,int Color, char* title)
   ;	
	assume	cs:MGRP
_Window	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
   ;	
   ;	{
   ;	
   ;	// SetColor (7);
   ;	// Bar (X,Y,X+w,Y+h);
   ;	 waitretrace ();
   ;	
	call	near ptr MGRP:_waitretrace
   ;	
   ;	 fillscreen ();
   ;	
	call	near ptr MGRP:_fillscreen
   ;	
   ;	 SetColor (Color);
   ;	
	push	word ptr [bp+12]
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	
   ;	 Rectangle (X+1,Y+15,X+w,Y+h-1);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	dec	ax
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Rectangle (X+2,Y+15,X+w-1,Y+h-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	dec	ax
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,2
	push	ax
	call	near ptr MGRP:_Rectangle
	add	sp,8
   ;	
   ;	 Bar (X,Y,X+w,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Bar
	add	sp,8
   ;	
   ;	 SetColor (15);
   ;	
	push	15
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X,Y,X+w,Y);
   ;	
	push	di
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X,Y,X,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	push	si
	push	di
	push	si
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+15,Y,X+15,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,15
	push	ax
	push	di
	mov	ax,si
	add	ax,15
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3,Y+h-3,X+w-3,Y+h-3);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-3
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+11,Y+5,X+11,Y+11);
   ;	
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	mov	ax,di
	add	ax,5
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+5,Y+11,X+11,Y+11);
   ;	
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,11
	push	ax
	mov	ax,di
	add	ax,11
	push	ax
	mov	ax,si
	add	ax,5
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+w-2,Y+15,X+w-2,Y+h-3);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-3
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 SetColor (0);
   ;	
	push	0
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	 Line (X+14,Y+1,X+14,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,14
	push	ax
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	add	ax,14
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+1,Y+15,X+w-2,Y+15);
   ;	
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	add	ax,-2
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+3,Y+15,X+3,Y+h-2);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	add	ax,-2
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	mov	ax,di
	add	ax,15
	push	ax
	mov	ax,si
	add	ax,3
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+1,Y+h,X+w,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	push	ax
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+4,Y+4,X+10,Y+4);
   ;	
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,10
	push	ax
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+4,Y+4,X+4,Y+10);
   ;	
	mov	ax,di
	add	ax,10
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	mov	ax,di
	add	ax,4
	push	ax
	mov	ax,si
	add	ax,4
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 Line (X+w+1,Y,X+w+1,Y+h);
   ;	
	mov	ax,di
	add	ax,word ptr [bp+10]
	push	ax
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	push	di
	mov	ax,si
	add	ax,word ptr [bp+8]
	inc	ax
	push	ax
	call	near ptr MGRP:_Line
	add	sp,8
   ;	
   ;	 if (isFont) setFont (2);
   ;	
	cmp	byte ptr MGRP:_isFont,0
	je	short @37@86
	push	2
	call	near ptr MGRP:_setFont
	pop	cx
@37@86:
   ;	
   ;	 OutTextXY (X+20,Y+1,title,0,0);
   ;	
	push	0
	push	0
	push	word ptr [bp+14]
	mov	ax,di
	inc	ax
	push	ax
	mov	ax,si
	add	ax,20
	push	ax
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_Window	endp
   ;	
   ;	void readpg (void)
   ;	
	assume	cs:MGRP
_readpg	proc	near
   ;	
   ;	{
   ;	
   ;	 SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 strcpy (fdisp,"index.qdl");
   ;	
	push	offset MGRP:s@
	push	offset MGRP:_fdisp
	call	near ptr MGRP:_strcpy
	add	sp,4
@38@30:
   ;	
   ;	
   ;	 display:
   ;	
   ;	 hidemouse ();
   ;	
	call	near ptr MGRP:_hidemouse
   ;	
   ;	 SetVideo (OFF);
   ;	
	push	1
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 Window (1,1,638,478,8,fdisp);
   ;	
	push	offset MGRP:_fdisp
	push	large 0000801DEh
	push	large 0027E0001h
	push	1
	call	near ptr MGRP:_Window
	add	sp,12
   ;	
   ;	
   ;	 for (bb=0;bb<=19;bb++)
   ;	
	mov	byte ptr MGRP:_bb,0
	jmp	short @38@114
@38@58:
   ;	
   ;	 {
   ;	      link_rect [bb].x  = 0;
   ;	
	mov	al,byte ptr MGRP:_bb
	cbw	
	imul	ax,ax,38
	mov	bx,ax
	mov	word ptr MGRP:_link_rect[bx],0
   ;	
   ;	      link_rect [bb].y  = 0;
   ;	
	mov	al,byte ptr MGRP:_bb
	cbw	
	imul	ax,ax,38
	mov	bx,ax
	mov	word ptr MGRP:_link_rect[bx+2],0
   ;	
   ;	      link_rect [bb].x2 = 0;
   ;	
	mov	al,byte ptr MGRP:_bb
	cbw	
	imul	ax,ax,38
	mov	bx,ax
	mov	word ptr MGRP:_link_rect[bx+4],0
   ;	
   ;	      link_rect [bb].y2 = 0;
   ;	
	mov	al,byte ptr MGRP:_bb
	cbw	
	imul	ax,ax,38
	mov	bx,ax
	mov	word ptr MGRP:_link_rect[bx+6],0
	inc	byte ptr MGRP:_bb
@38@114:
	cmp	byte ptr MGRP:_bb,19
	jle	short @38@58
   ;	
   ;	 }
   ;	
   ;	 file_offset = 0;
   ;	
	mov	word ptr MGRP:_file_offset,0
   ;	
   ;	 x = 20; l = 32; flag = 0; oldl = 32;oldx = 20;
   ;	
	mov	word ptr MGRP:_x,20
	mov	word ptr MGRP:_l,32
	mov	word ptr MGRP:flag,0
	mov	word ptr MGRP:_oldl,32
	mov	word ptr MGRP:oldx,20
   ;	
   ;	 ul = 0; m = 0;
   ;	
	mov	byte ptr MGRP:_ul,0
	mov	byte ptr MGRP:_m,0
   ;	
   ;	 link = 0;
   ;	
	mov	word ptr MGRP:_link,0
   ;	
   ;	 quit = 0;
   ;	
	mov	word ptr MGRP:_quit,0
   ;	
   ;	
   ;	 input = fopen (fdisp);
   ;	
	push	offset MGRP:_fdisp
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_input,eax
   ;	
   ;	 if (input < 2) return ;
   ;	
	cmp	dword ptr MGRP:_input,large 2
	jae short	@@5
	jmp	@38@2494
@@5:
   ;	
   ;	 bufferbatch = malloc (0xfff);
   ;	
	push	4095
	call	near ptr MGRP:_malloc
	pop	cx
	mov	word ptr MGRP:_bufferbatch,ax
   ;	
   ;	 clearBufferSegment ();
   ;	
	call	near ptr MGRP:_clearBufferSegment
   ;	
   ;	 fread (input,fsize(input),0,bufferbatch);
   ;	
	push	word ptr MGRP:_bufferbatch
	push	0
	push	dword ptr MGRP:_input
	call	near ptr MGRP:_fsize
	add	sp,4
	push	dx
	push	ax
	push	dword ptr MGRP:_input
	call	near ptr MGRP:_fread
	add	sp,12
	jmp	@38@2270
@38@198:
   ;	
   ;	
   ;	  while ( fgets (s,100,input) != NULL )
   ;	  {
   ;	
   ;	   if ( s[0] == '.')
   ;	
	cmp	byte ptr MGRP:_s,46
	je short	@@6
	jmp	@38@1766
@@6:
   ;	
   ;	   {
   ;	    if (!strcmp (s,".center")) flag = 1 ;
   ;	
	push	offset MGRP:s@+10
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@282
	mov	word ptr MGRP:flag,1
	jmp	@38@2158
@38@282:
   ;	
   ;	    else if (!strcmp (s,".left")) { x = 20 ; oldx = 20 ; }
   ;	
	push	offset MGRP:s@+18
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@338
	mov	word ptr MGRP:_x,20
	mov	word ptr MGRP:oldx,20
	jmp	@38@2158
@38@338:
   ;	
   ;	    else if (!strcmp (s,".tab")) x += 20;
   ;	
	push	offset MGRP:s@+24
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@394
	add	word ptr MGRP:_x,20
	jmp	@38@2158
@38@394:
   ;	
   ;	    else if (!strcmp (s,".right")) flag = 2;
   ;	
	push	offset MGRP:s@+29
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@450
	mov	word ptr MGRP:flag,2
	jmp	@38@2158
@38@450:
   ;	
   ;	    else if (!strcmp (s,".underline")) ul = 1;
   ;	
	push	offset MGRP:s@+36
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@506
	mov	byte ptr MGRP:_ul,1
	jmp	@38@2158
@38@506:
   ;	
   ;	    else if (!strcmp (s,".master"))  m = 1; 
   ;	
	push	offset MGRP:s@+47
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@562
	mov	byte ptr MGRP:_m,1
	jmp	@38@2158
@38@562:
   ;	
   ;	    else if (!strcmp (s,".link")) flag = 3;
   ;	
	push	offset MGRP:s@+55
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@618
	mov	word ptr MGRP:flag,3
	jmp	@38@2158
@38@618:
   ;	
   ;	    else if (!strcmp (s,".keepl")) { l = oldl ; x = oldx ; }
   ;	
	push	offset MGRP:s@+61
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@674
	mov	ax,word ptr MGRP:_oldl
	mov	word ptr MGRP:_l,ax
	mov	ax,word ptr MGRP:oldx
	mov	word ptr MGRP:_x,ax
	jmp	@38@2158
@38@674:
   ;	
   ;	    else if (!strcmp (s,".figure")) {
   ;	
	push	offset MGRP:s@+68
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@730
   ;	
   ;	                                     fgets (fdisp,100,input);
   ;	
	push	dword ptr MGRP:_input
	push	100
	push	offset MGRP:_fdisp
	call	near ptr MGRP:_fgets
	add	sp,8
   ;	
   ;	                                     pic (fdisp,l);
   ;	
	push	word ptr MGRP:_l
	push	offset MGRP:_fdisp
	call	near ptr MGRP:_pic
	add	sp,4
   ;	
   ;	                                     l += 210;
   ;	
	add	word ptr MGRP:_l,210
   ;	
   ;	                                    }
   ;	
	jmp	@38@2158
@38@730:
   ;	
   ;	    else if (!strcmp (s,".normal")) setFont (0);
   ;	
	push	offset MGRP:s@+76
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@786
	push	0
	jmp	@38@1066
@38@786:
   ;	
   ;	    else if (!strcmp (s,".computer")) setFont (1);
   ;	
	push	offset MGRP:s@+84
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@842
	push	1
	jmp	short @38@1066
@38@842:
   ;	
   ;	    else if (!strcmp (s,".bold")) setFont (3);
   ;	
	push	offset MGRP:s@+94
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@898
	push	3
	jmp	short @38@1066
@38@898:
   ;	
   ;	    else if (!strcmp (s,".italics")) setFont (4);
   ;	
	push	offset MGRP:s@+100
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@954
	push	4
	jmp	short @38@1066
@38@954:
   ;	
   ;	    else if (!strcmp (s,".modern")) setFont (5);
   ;	
	push	offset MGRP:s@+109
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1010
	push	5
	jmp	short @38@1066
@38@1010:
   ;	
   ;	    else if (!strcmp (s,".roman")) setFont (6);
   ;	
	push	offset MGRP:s@+117
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1094
	push	6
@38@1066:
	call	near ptr MGRP:_setFont
	pop	cx
	jmp	@38@2158
@38@1094:
   ;	
   ;	    else if (!strcmp (s,".black"))   COLOR = 0;
   ;	
	push	offset MGRP:s@+124
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1150
	mov	byte ptr MGRP:_COLOR,0
	jmp	@38@2158
@38@1150:
   ;	
   ;	    else if (!strcmp (s,".blue"))    COLOR = 1;
   ;	
	push	offset MGRP:s@+131
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1206
	mov	byte ptr MGRP:_COLOR,1
	jmp	@38@2158
@38@1206:
   ;	
   ;	    else if (!strcmp (s,".green"))   COLOR = 2;
   ;	
	push	offset MGRP:s@+137
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1262
	mov	byte ptr MGRP:_COLOR,2
	jmp	@38@2158
@38@1262:
   ;	
   ;	    else if (!strcmp (s,".lgreen"))  COLOR = 3;
   ;	
	push	offset MGRP:s@+144
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1318
	mov	byte ptr MGRP:_COLOR,3
	jmp	@38@2158
@38@1318:
   ;	
   ;	    else if (!strcmp (s,".red"))     COLOR = 4;
   ;	
	push	offset MGRP:s@+152
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1374
	mov	byte ptr MGRP:_COLOR,4
	jmp	@38@2158
@38@1374:
   ;	
   ;	    else if (!strcmp (s,".magenta")) COLOR = 5;
   ;	
	push	offset MGRP:s@+157
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1430
	mov	byte ptr MGRP:_COLOR,5
	jmp	@38@2158
@38@1430:
   ;	
   ;	    else if (!strcmp (s,".brown"))   COLOR = 6;
   ;	
	push	offset MGRP:s@+166
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1486
	mov	byte ptr MGRP:_COLOR,6
	jmp	@38@2158
@38@1486:
   ;	
   ;	    else if (!strcmp (s,".lgray"))   COLOR = 7;
   ;	
	push	offset MGRP:s@+173
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1542
	mov	byte ptr MGRP:_COLOR,7
	jmp	@38@2158
@38@1542:
   ;	
   ;	    else if (!strcmp (s,".dgray"))   COLOR = 8;
   ;	
	push	offset MGRP:s@+180
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @38@1598
	mov	byte ptr MGRP:_COLOR,8
	jmp	@38@2158
@38@1598:
   ;	
   ;	    else if (!strcmp (s,".line")) {
   ;	
	push	offset MGRP:s@+187
	push	offset MGRP:_s
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@7
	jmp	@38@2158
@@7:
   ;	
   ;					    for (ww=20;ww<=620;ww++)
   ;	
	mov	word ptr MGRP:_ww,20
	jmp	short @38@1710
@38@1654:
   ;	
   ;					    {
   ;	                                     setpix (ww,l+7,8);
   ;	
	push	8
	mov	ax,word ptr MGRP:_l
	add	ax,7
	push	ax
	push	word ptr MGRP:_ww
	call	near ptr MGRP:_setpix
	add	sp,6
   ;	
   ;	                                     setpix (ww,l+8,15);
   ;	
	push	15
	mov	ax,word ptr MGRP:_l
	add	ax,8
	push	ax
	push	word ptr MGRP:_ww
	call	near ptr MGRP:_setpix
	add	sp,6
	inc	word ptr MGRP:_ww
@38@1710:
	cmp	word ptr MGRP:_ww,620
	jle	short @38@1654
   ;	
   ;					    }
   ;					   l += 16;
   ;	
	add	word ptr MGRP:_l,16
	jmp	@38@2158
@38@1766:
   ;	
   ;					  }
   ;	   }
   ;	    else
   ;	    {
   ;	     if (flag == 1) x = 320 - ( strlen (s) * (4<<m) );
   ;	
	cmp	word ptr MGRP:flag,1
	jne	short @38@1822
	push	offset MGRP:_s
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	mov	dx,4
	mov	cl,byte ptr MGRP:_m
	shl	dx,cl
	imul	dx
	mov	dx,320
	sub	dx,ax
	mov	word ptr MGRP:_x,dx
@38@1822:
   ;	
   ;	     if (flag == 2) x = 620 - (strlen (s) * (8<<m));
   ;	
	cmp	word ptr MGRP:flag,2
	jne	short @38@1878
	push	offset MGRP:_s
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	mov	dx,8
	mov	cl,byte ptr MGRP:_m
	shl	dx,cl
	imul	dx
	mov	dx,620
	sub	dx,ax
	mov	word ptr MGRP:_x,dx
@38@1878:
   ;	
   ;	     if (flag == 3)
   ;	
	cmp	word ptr MGRP:flag,3
	je short	@@8
	jmp	@38@2074
@@8:
   ;	
   ;	     {
   ;	      if (link == 29) continue;
   ;	
	cmp	word ptr MGRP:_link,29
	jne short	@@9
	jmp	@38@2270
@@9:
   ;	
   ;	      link_rect [link].x  = x;
   ;	
	mov	bx,word ptr MGRP:_link
	imul	bx,bx,38
	mov	ax,word ptr MGRP:_x
	mov	word ptr MGRP:_link_rect[bx],ax
   ;	
   ;	      link_rect [link].y  = l;
   ;	
	mov	bx,word ptr MGRP:_link
	imul	bx,bx,38
	mov	ax,word ptr MGRP:_l
	mov	word ptr MGRP:_link_rect[bx+2],ax
   ;	
   ;	      link_rect [link].x2 = x + ( strlen (s) * 8 );
   ;	
	push	offset MGRP:_s
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	mov	dx,word ptr MGRP:_x
	add	dx,ax
	mov	bx,word ptr MGRP:_link
	imul	bx,bx,38
	mov	word ptr MGRP:_link_rect[bx+4],dx
   ;	
   ;	      link_rect [link].y2 = l+8+4;
   ;	
	mov	bx,word ptr MGRP:_link
	imul	bx,bx,38
	mov	ax,word ptr MGRP:_l
	add	ax,12
	mov	word ptr MGRP:_link_rect[bx+6],ax
   ;	
   ;	      ul = 1; SetColor (1);
   ;	
	mov	byte ptr MGRP:_ul,1
	push	1
	call	near ptr MGRP:_SetColor
	pop	cx
   ;	
   ;	      for (bb = 0; bb <= 29; bb++) link_rect [link].filename[bb] = 0;
   ;	
	mov	byte ptr MGRP:_bb,0
	jmp	short @38@2018
@38@1962:
	mov	al,byte ptr MGRP:_bb
	cbw	
	mov	bx,word ptr MGRP:_link
	imul	bx,bx,38
	add	bx,ax
	mov	byte ptr MGRP:_link_rect[bx+8],0
	inc	byte ptr MGRP:_bb
@38@2018:
	cmp	byte ptr MGRP:_bb,29
	jle	short @38@1962
   ;	
   ;	      fgets (link_rect [link].filename,29,input);
   ;	
	push	dword ptr MGRP:_input
	push	29
	mov	ax,word ptr MGRP:_link
	imul	ax,ax,38
	add	ax,offset MGRP:_link_rect+8
	push	ax
	call	near ptr MGRP:_fgets
	add	sp,8
   ;	
   ;	      link ++;
   ;	
	inc	word ptr MGRP:_link
@38@2074:
   ;	
   ;	     }
   ;	     oldl = l; 
   ;	
	mov	ax,word ptr MGRP:_l
	mov	word ptr MGRP:_oldl,ax
   ;	
   ;	     OutTextXY (x,l,s,ul,m);
   ;	
	mov	al,byte ptr MGRP:_m
	push	ax
	mov	al,byte ptr MGRP:_ul
	push	ax
	push	offset MGRP:_s
	push	word ptr MGRP:_l
	push	word ptr MGRP:_x
	call	near ptr MGRP:_OutTextXY
	add	sp,10
   ;	
   ;	     flag = 0;
   ;	
	mov	word ptr MGRP:flag,0
   ;	
   ;	     if (flag != 4) { l += 16; oldx = x; }
   ;	
	cmp	word ptr MGRP:flag,4
	je	short @38@2130
	add	word ptr MGRP:_l,16
	mov	ax,word ptr MGRP:_x
	mov	word ptr MGRP:oldx,ax
@38@2130:
   ;	
   ;	     oldx +=  ( (strlen (s))*8 );
   ;	
	push	offset MGRP:_s
	call	near ptr MGRP:_strlen
	pop	cx
	mov	ah,0
	shl	ax,3
	add	word ptr MGRP:oldx,ax
   ;	
   ;	     ul = 0;
   ;	
	mov	byte ptr MGRP:_ul,0
   ;	
   ;	     m = 0;
   ;	
	mov	byte ptr MGRP:_m,0
@38@2158:
   ;	
   ;	    }
   ;	    for (bb = 0; bb <= 99; bb++)
   ;	
	mov	byte ptr MGRP:_bb,0
	jmp	short @38@2242
@38@2186:
   ;	
   ;	    {
   ;	     s[bb] = 0;
   ;	
	mov	al,byte ptr MGRP:_bb
	cbw	
	mov	bx,ax
	mov	byte ptr MGRP:_s[bx],0
	inc	byte ptr MGRP:_bb
@38@2242:
	cmp	byte ptr MGRP:_bb,99
	jle	short @38@2186
@38@2270:
	push	dword ptr MGRP:_input
	push	100
	push	offset MGRP:_s
	call	near ptr MGRP:_fgets
	add	sp,8
	or	ax,ax
	je short	@@10
	jmp	@38@198
@@10:
   ;	
   ;	    }
   ;	    
   ;	  }
   ;	  free ((addr)bufferbatch);
   ;	
	push	word ptr MGRP:_bufferbatch
	call	near ptr MGRP:_free
	pop	cx
   ;	
   ;	 SetVideo (ON);
   ;	
	push	0
	call	near ptr MGRP:_SetVideo
	pop	cx
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	
   ;	 asm {
   ;	  xor ax,ax
   ;	
	xor	 ax,ax
   ;	
   ;	  int 0x16
   ;	
	int	 016H
   ;	
   ;	  mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;	  int 10h
   ;	
	int	 10h
@38@2438:
   ;	
   ;	 }
   ;	
   ;	  while (!quit)
   ;	
	cmp	word ptr MGRP:_quit,0
	je	short @38@2438
   ;	
   ;	  {
   ;	//   if (is_key ()) quit = 2;
   ;	 /*
   ;	   if ( bmouse () )
   ;	   {
   ;	    for ( bb = 0; bb <= link; bb++)
   ;	    {
   ;	     if (   (mx>link_rect[bb].x)  && (my>link_rect[bb].y)
   ;	         && (mx<link_rect[bb].x2) && (my<link_rect[bb].y2) )
   ;	         {
   ;	          for (ww = 0; ww <= 29; ww++) fdisp[ww] = 0;
   ;	          strcpy (fdisp,link_rect[bb].filename);
   ;	          quit = 1;
   ;	          if (!strcmp (link_rect[bb].filename,"<system>")) quit = 2;
   ;	         }
   ;	    }
   ;	   }
   ;	  */
   ;	  }
   ;	  if (quit==1) goto display;
   ;	
	cmp	word ptr MGRP:_quit,1
	jne short	@@11
	jmp	@38@30
@@11:
@38@2494:
   ;	
   ;	}
   ;	
	ret	
_readpg	endp
   ;	
   ;	void StartProgram ()
   ;	
	assume	cs:MGRP
_StartProgram	proc	near
   ;	
   ;	{
   ;	 init640480 ();
   ;	
	call	near ptr MGRP:_init640480
   ;	
   ;	
   ;	 fntfile = fopen ("/lib/fnt/breeze.fnt");
   ;	
	push	offset MGRP:s@+193
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, 0, 0x8000);
   ;	
	push	large 080000000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/comp.fnt");
   ;	
	push	offset MGRP:s@+213
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)4096, 0x8000);
   ;	
	push	large 080001000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/hylas.fnt");
   ;	
	push	offset MGRP:s@+231
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)8192, 0x8000);
   ;	
	push	large 080002000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/bold.fnt");
   ;	
	push	offset MGRP:s@+250
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)12288, 0x8000);
   ;	
	push	large 080003000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/italics.fnt");
   ;	
	push	offset MGRP:s@+268
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)16384, 0x8000);
   ;	
	push	large 080004000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/modern.fnt");
   ;	
	push	offset MGRP:s@+289
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)20480, 0x8000);
   ;	
	push	large 080005000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	 fntfile = fopen ("/lib/fnt/roman.fnt");
   ;	
	push	offset MGRP:s@+309
	call	near ptr MGRP:_fopen
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr MGRP:_fntfile,eax
   ;	
   ;	 fread (fntfile, 4096, (void*)24576, 0x8000);
   ;	
	push	large 080006000h
	push	large 4096
	push	eax
	call	near ptr MGRP:_fread
	add	sp,12
   ;	
   ;	
   ;	
   ;	 isFont = 1;
   ;	
	mov	byte ptr MGRP:_isFont,1
   ;	
   ;	 setFont (0);
   ;	
	push	0
	call	near ptr MGRP:_setFont
	pop	cx
   ;	
   ;	 COLOR = 0;
   ;	
	mov	byte ptr MGRP:_COLOR,0
   ;	
   ;	
   ;	 if (ismouse () == 0xffff)
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @39@58
   ;	
   ;	 {
   ;	  mouse_status = 1;
   ;	
	mov	word ptr MGRP:mouse_status,1
   ;	
   ;	  init_mouse ();
   ;	
	call	near ptr MGRP:_init_mouse
@39@58:
   ;	
   ;	 }
   ;	
   ;	 showmouse ();
   ;	
	call	near ptr MGRP:_showmouse
   ;	
   ;	 readpg ();
   ;	
	call	near ptr MGRP:_readpg
   ;	
   ;	
   ;	 if (ismouse () == 0xffff) shut_mouse ();
   ;	
	call	near ptr MGRP:_ismouse
	cmp	ax,00000FFFFh
	jne	short @39@114
	call	near ptr MGRP:_shut_mouse
@39@114:
   ;	
   ;	
   ;	 asm {
   ;	        mov ax,3
   ;	
	mov	 ax,3
   ;	
   ;	        int 10h
   ;	
	int	 10h
   ;	
   ;	      }
   ;	
   ;	}
   ;	
	ret	
_StartProgram	endp
_fntfile	label	word
	db	4 dup (0)
_link_rect	label	word
	db	760 dup (0)
_fdisp	label	byte
	db	30 dup (0)
_quit	label	word
	db	2 dup (0)
_link	label	word
	db	2 dup (0)
_ww	label	word
	db	2 dup (0)
_bb	label	byte
	db	1 dup (0)
_m	label	byte
	db	1 dup (0)
_ul	label	byte
	db	1 dup (0)
_oldl	label	word
	db	2 dup (0)
_l	label	word
	db	2 dup (0)
_x	label	word
	db	2 dup (0)
_s	label	byte
	db	100 dup (0)
_input	label	word
	db	4 dup (0)
_file_offset	label	word
	db	2 dup (0)
_bufferbatch	label	word
	db	2 dup (0)
i	label	word
	db	2 dup (0)
show_mouse	label	word
	db	2 dup (0)
swap	label	byte
	db	28 dup (0)
mb	label	word
	db	2 dup (0)
my	label	word
	db	2 dup (0)
mx	label	word
	db	2 dup (0)
_COLOR	label	byte
	db	1 dup (0)
	?debug	C E9
	?debug	C FA10010000
s@	label	byte
	db	'index.qdl'
	db	0
	db	'.center'
	db	0
	db	'.left'
	db	0
	db	'.tab'
	db	0
	db	'.right'
	db	0
	db	'.underline'
	db	0
	db	'.master'
	db	0
	db	'.link'
	db	0
	db	'.keepl'
	db	0
	db	'.figure'
	db	0
	db	'.normal'
	db	0
	db	'.computer'
	db	0
	db	'.bold'
	db	0
	db	'.italics'
	db	0
	db	'.modern'
	db	0
	db	'.roman'
	db	0
	db	'.black'
	db	0
	db	'.blue'
	db	0
	db	'.green'
	db	0
	db	'.lgreen'
	db	0
	db	'.red'
	db	0
	db	'.magenta'
	db	0
	db	'.brown'
	db	0
	db	'.lgray'
	db	0
	db	'.dgray'
	db	0
	db	'.line'
	db	0
	db	'/lib/fnt/breeze.fnt'
	db	0
	db	'/lib/fnt/comp.fnt'
	db	0
	db	'/lib/fnt/hylas.fnt'
	db	0
	db	'/lib/fnt/bold.fnt'
	db	0
	db	'/lib/fnt/italics.fnt'
	db	0
	db	'/lib/fnt/modern.fnt'
	db	0
	db	'/lib/fnt/roman.fnt'
	db	0
VPSEG	ends
	public	_fntfile
	public	_readpg
	public	_link_rect
	public	_fdisp
	public	_quit
	public	_link
	public	_ww
	public	_bb
	public	_m
	public	_ul
	public	_oldl
	public	_l
	public	_x
	public	_s
	public	_input
	public	_Window
	public	_fillscreen
	public	_Rectangle
	public	_SetColor
	public	_Bar
	public	_clearBufferSegment
	public	_free
	public	_malloc
	public	_fgets
	public	_file_offset
	public	_peekchar
	public	_bufferbatch
	public	_OutTextXY
	public	_pic
	public	_pic_peek
	public	_Line
	public	_SwapInt
	public	_abs
	public	_setFont
	public	_getOfs
	public	_PrintChar
	public	_fptr
	public	_SetVideo
	public	_is_key
	public	_bmouse
	public	_shut_mouse
	public	_init_mouse
	public	_ismouse
	public	_mouse_handler
_i	equ	i
_show_mouse	equ	show_mouse
_mouse_status	equ	mouse_status
_flag	equ	flag
_swap	equ	swap
_cursor	equ	cursor
_oldy	equ	oldy
_oldx	equ	oldx
_mb	equ	mb
_my	equ	my
_mx	equ	mx
	public	_showmouse
	public	_hidemouse
	extrn	_waitretrace:near
	extrn	_barasm:near
	extrn	_getfontptr:near
	extrn	_getpix:near
	extrn	_setpix:near
	extrn	_init640480:near
	public	_isFont
	public	_COLOR
	public	_exec
	public	_fsize
	public	_fread
	public	_fopen
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
	public	_main
	public	_StartProgram
_s@	equ	s@
	end
