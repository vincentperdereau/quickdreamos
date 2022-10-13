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
	?debug	S "debugfs.c"
	?debug	C E9A0985A2A09646562756766732E63
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
   ;	void ProgramStartup (void)
   ;	
	assume	cs:MGRP
_ProgramStartup	proc	near
   ;	
   ;	{
   ;	 ProgramEntry ();
   ;	
	call	near ptr MGRP:_ProgramEntry
   ;	
   ;	 asm { retf };
   ;	
 	retf	 
   ;	
   ;	}
   ;	
	ret	
_ProgramStartup	endp
	?debug	C E951A3112709747970656465662E68
	?debug	C E96FA05627066469736B2E68
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
	jne	short @7@86
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
@7@86:
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	cmp	dl,6
	jne	short @7@142
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
@7@142:
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
	?debug	C E97DA06C27046C732E68
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
	?debug	C E98E635A2A08737472696E672E68
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
	jmp	short @10@114
@10@58:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	al,byte ptr [bx+di]
	mov	dl,cl
	mov	dh,0
	mov	bx,dx
	mov	byte ptr [bx+si],al
	inc	cl
@10@114:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+di],0
	jne	short @10@58
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
	jmp	short @11@86
@11@58:
	inc	dl
@11@86:
	mov	al,dl
	mov	ah,0
	mov	bx,word ptr [bp+4]
	add	bx,ax
	cmp	byte ptr [bx],0
	jne	short @11@58
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
	jmp	short @13@86
@13@58:
	inc	byte ptr [bp-1]
@13@86:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	mov	al,byte ptr [bx]
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	cmp	al,byte ptr [bx+si]
	jne	short @13@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,cx
	add	bx,ax
	cmp	byte ptr [bx],0
	je	short @13@170
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @13@58
@13@170:
   ;	
   ;	   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   ;	
	push	cx
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @13@254
	push	si
	call	near ptr MGRP:_strlen
	pop	cx
	cmp	al,byte ptr [bp-1]
	jne	short @13@254
	mov	al,0
	jmp	short @13@282
@13@254:
   ;	
   ;	   else return 1;
   ;	
	mov	al,1
@13@282:
   ;	
   ;	  }
   ;	
	pop	si
	leave	
	ret	
_strcmp	endp
   ;	
   ;	void set_mode (int mode)
   ;	
	assume	cs:MGRP
_set_mode	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;	      mov ax,mode
   ;	
	mov	 ax,[bp+4]
   ;	
   ;	      int 0x10
   ;	
	int	 010H
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_set_mode	endp
   ;	
   ;	void putpixel (unsigned int adr,unsigned char color)
   ;	
	assume	cs:MGRP
_putpixel	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm {
   ;		push es
   ;	
	push	 es
   ;	
   ;	        mov ax,0xa000
   ;	
	mov	 ax,0a000H
   ;	
   ;	        mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;	        mov bx,adr
   ;	
	mov	 bx,[bp+4]
   ;	
   ;	        mov al,color
   ;	
	mov	 al,[bp+6]
   ;	
   ;	        mov es:[bx],al
   ;	
	mov	 es:[bx],al
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;	 }
   ;	}
   ;	
	pop	bp
	ret	
_putpixel	endp
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
   ;	
   ;	void ConsoleWriteChar (char c)
   ;	
	assume	cs:MGRP
_ConsoleWriteChar	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	 asm { push ax ; mov al,c ; int 0x29 ; pop ax }
   ;	
 	push	 ax 
 	mov	 al,[bp+4] 
 	int	 029H 
 	pop	 ax 
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_ConsoleWriteChar	endp
   ;	
   ;	void ConsoleWriteString (char* s)
   ;	
	assume	cs:MGRP
_ConsoleWriteString	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	{
   ;	 int i;
   ;	 for ( i=0; s[i] != 0; i++) ConsoleWriteChar (s[i]);
   ;	
	xor	si,si
	jmp	short @18@114
@18@58:
	mov	bx,si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
	inc	si
@18@114:
	mov	bx,si
	cmp	byte ptr [bx+di],0
	jne	short @18@58
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_ConsoleWriteString	endp
   ;	
   ;	void ConsoleWriteDword (unsigned long dw)
   ;	
	assume	cs:MGRP
_ConsoleWriteDword	proc	near
	enter	4,0
	push	si
   ;	
   ;	{
   ;	 unsigned long i ; unsigned char b ;
   ;	 int flag=0;
   ;	
	xor	si,si
   ;	
   ;	 for (i=1000000000;i!=0;i/=10)
   ;	
	mov	dword ptr [bp-4],large 03B9ACA00h
	jmp	short @19@198
@19@58:
   ;	
   ;	 {
   ;	 b = dw / i ; dw = dw - (b*i) ;
   ;	
	mov	eax,dword ptr [bp+4]
	xor	edx,edx
	div	dword ptr [bp-4]
	mov	bl,al
	mov	ah,0
	movsx	eax,ax
	imul	eax,dword ptr [bp-4]
	mov	edx,dword ptr [bp+4]
	sub	edx,eax
	mov	dword ptr [bp+4],edx
   ;	
   ;	 if (b) flag = 1;
   ;	
	or	bl,bl
	je	short @19@114
	mov	si,1
@19@114:
   ;	
   ;	 if (flag) ConsoleWriteChar (b+48) ;
   ;	
	or	si,si
	je	short @19@170
	mov	al,bl
	add	al,48
	push	ax
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
@19@170:
	mov	ebx,large 10
	mov	eax,dword ptr [bp-4]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
@19@198:
	cmp	dword ptr [bp-4],large 0
	jne	short @19@58
   ;	
   ;	 }
   ;	}
   ;	
	pop	si
	leave	
	ret	
_ConsoleWriteDword	endp
   ;	
   ;	void ConsoleReadString (char* s, int length)
   ;	
	assume	cs:MGRP
_ConsoleReadString	proc	near
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
   ;		push cx
   ;	
	push	 cx
   ;	
   ;		push es
   ;	
	push	 es
   ;	
   ;		mov ax,cs
   ;	
	mov	 ax,cs
   ;	
   ;		mov es,ax
   ;	
	mov	 es,ax
   ;	
   ;		mov bx,s
   ;	
	mov	 bx,[bp+4]
   ;	
   ;		mov cx,length
   ;	
	mov	 cx,[bp+6]
   ;	
   ;		mov ah,0x0011
   ;	
	mov	 ah,00011H
   ;	
   ;		int 0x44
   ;	
	int	 044H
   ;	
   ;		pop es
   ;	
	pop	 es
   ;	
   ;		pop cx
   ;	
	pop	 cx
   ;	
   ;		pop bx
   ;	
	pop	 bx
   ;	
   ;		pop ax
   ;	
	pop	 ax
   ;	
   ;	     }
   ;	}
   ;	
	pop	bp
	ret	
_ConsoleReadString	endp
   ;	
   ;	char* ScanString (char* line,int count)
   ;	
	assume	cs:MGRP
_ScanString	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;	 unsigned char i ;
   ;	 unsigned char j ;
   ;	 int intern_count=0 ;
   ;	
	xor	di,di
   ;	
   ;	 for (i=0;i<=50;i++)
   ;	
	mov	dl,0
	jmp	short @21@282
@21@58:
   ;	
   ;	 {
   ;	  if (line[i]!=32) { for (j=i;(line[j]!=32)&&(line[j]!=0);j++);line[j]=0;
   ;	
	mov	al,dl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @21@254
	mov	cl,dl
	jmp	short @21@142
@21@114:
	inc	cl
@21@142:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],32
	je	short @21@198
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @21@114
@21@198:
	mov	al,cl
	mov	ah,0
	mov	bx,ax
	mov	byte ptr [bx+si],0
   ;	
   ;	
   ;			     intern_count++;
   ;	
	inc	di
   ;	
   ;			     if (intern_count==count) break ;
   ;	
	cmp	di,word ptr [bp+6]
	je	short @21@310
   ;	
   ;			     i=j;}
   ;	
	mov	dl,cl
@21@254:
	inc	dl
@21@282:
	cmp	dl,50
	jbe	short @21@58
@21@310:
   ;	
   ;	 }
   ;	return (line+i);
   ;	
	mov	al,dl
	mov	ah,0
	push	ax
	mov	ax,si
	pop	dx
	add	ax,dx
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_ScanString	endp
prompt	label	byte
	db	13
	db	10
	db	100
	db	101
	db	98
	db	117
	db	103
	db	102
	db	115
	db	62
	db	32
	db	0
nl	label	byte
	db	10
	db	13
	db	0
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
   ;	void ProgramEntry ()
   ;	
	assume	cs:MGRP
_ProgramEntry	proc	near
	enter	2,0
   ;	
   ;	{
   ;	 char drive;
   ;	
   ;	 adr=0;
   ;	
	mov	word ptr MGRP:_adr,0
@22@58:
   ;	
   ;	 while (1)
   ;	 {
   ;	  ConsoleWriteString (prompt);
   ;	
	push	offset MGRP:prompt
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	  ConsoleReadString (cmd,19);
   ;	
	push	19
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ConsoleReadString
	add	sp,4
   ;	
   ;	  if (!strcmp ((string)ScanString(cmd,1),"help"))
   ;	
	push	offset MGRP:s@
	push	1
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@114
   ;	
   ;	  {
   ;	   ConsoleWriteString ("\n\rhelp - commands");
   ;	
	push	offset MGRP:s@+5
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	   ConsoleWriteString ("\n\rdisk [a/c] - disk informations (C/H/S)");
   ;	
	push	offset MGRP:s@+23
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	   ConsoleWriteString ("\n\rbitmap [a:/c:] [picture] - bitmap");
   ;	
	push	offset MGRP:s@+64
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	   ConsoleWriteString ("\n\rchain - FCB\n");
   ;	
	push	offset MGRP:s@+100
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@114:
   ;	
   ;	  }
   ;	
   ;	  if (!strcmp ((string)ScanString(cmd,1),"disk"))
   ;	
	push	offset MGRP:s@+115
	push	1
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@0
	jmp	@22@282
@@0:
   ;	
   ;	   {
   ;	    if (!strcmp ((string)ScanString(cmd,2),"a")) drive = 0x00;
   ;	
	push	offset MGRP:s@+120
	push	2
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@198
	mov	byte ptr [bp-1],0
@22@198:
   ;	
   ;	    if (!strcmp ((string)ScanString(cmd,2),"c")) drive = 0x80;
   ;	
	push	offset MGRP:s@+122
	push	2
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@254
	mov	byte ptr [bp-1],128
@22@254:
   ;	
   ;	    ConsoleWriteString ("\n\r * H/C/S        : ");
   ;	
	push	offset MGRP:s@+124
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	     ConsoleWriteDword (get_head (drive)+1); ConsoleWriteChar ('/');
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
	push	47
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
   ;	
   ;	     ConsoleWriteDword (get_cyl (drive)+1); ConsoleWriteChar ('/');
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
	push	47
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
   ;	
   ;	     ConsoleWriteDword (get_sector (drive));
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_sector
	pop	cx
	push	dx
	push	ax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	    ConsoleWriteString ("\n\r * Addr. Max.   : ");
   ;	
	push	offset MGRP:s@+145
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	     ConsoleWriteDword (  (get_head (drive)+1)
   ;	
   ;	
   ;				* (get_cyl (drive)+1)
   ;				* (get_sector (drive)) );
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp-1]
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
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	push	edx
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	    ConsoleWriteString ("\n\r * Size (Mb)    : ");
   ;	
	push	offset MGRP:s@+166
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	     ConsoleWriteDword (  (get_head (drive)+1)
   ;	
   ;	
   ;				* (get_cyl (drive)+1)
   ;				* (get_sector (drive)) >> 11);
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp-1]
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
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	shr	edx,11
	push	edx
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	    ConsoleWriteString ("\n\r * bitmap (b)   : ");
   ;	
	push	offset MGRP:s@+187
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	     ConsoleWriteDword ((((get_head (drive)+1)
   ;	
   ;	
   ;				* (get_cyl (drive)+1)
   ;				* (get_sector (drive))-1) >> 3) + 1);
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp-1]
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
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	dec	edx
	shr	edx,3
	inc	edx
	push	edx
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
@22@282:
   ;	
   ;	
   ;	
   ;	   }
   ;	
   ;	 if (!strcmp ((string)ScanString(cmd,1),"bitmap"))
   ;	
	push	offset MGRP:s@+208
	push	1
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@1
	jmp	@22@1122
@@1:
   ;	
   ;	 {
   ;	  if (!strcmp ((string)ScanString(cmd,3),"picture"))
   ;	
	push	offset MGRP:s@+215
	push	3
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@366
   ;	
   ;	   {
   ;	    adr = 0;
   ;	
	mov	word ptr MGRP:_adr,0
   ;	
   ;	    set_mode (0x13);
   ;	
	push	19
	call	near ptr MGRP:_set_mode
	pop	cx
@22@366:
   ;	
   ;	   }
   ;	
   ;	  if (!strcmp ((string)ScanString(cmd,2),"a:")) drive = 0;
   ;	
	push	offset MGRP:s@+223
	push	2
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@422
	mov	byte ptr [bp-1],0
	jmp	short @22@506
@22@422:
   ;	
   ;	  else if (!strcmp ((string)ScanString(cmd,2),"c:")) drive = 0x80;
   ;	
	push	offset MGRP:s@+226
	push	2
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@478
	mov	byte ptr [bp-1],128
	jmp	short @22@506
@22@478:
   ;	
   ;	  else { ConsoleWriteString ("\n\r bitmap [drive:] "); continue ; }
   ;	
	push	offset MGRP:s@+229
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
	jmp	@22@58
@22@506:
   ;	
   ;	  quit = 0; total_size = 0;
   ;	
	mov	word ptr MGRP:_quit,0
	mov	dword ptr MGRP:_total_size,large 0
   ;	
   ;	  e = (((get_head (drive)+1) * (get_cyl (drive)+1)*(get_sector (drive))-219) >> 3);
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	call	near ptr MGRP:_get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp-1]
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
	mov	al,byte ptr [bp-1]
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
   ;	  e = (e>>9);
   ;	
	mov	eax,dword ptr MGRP:_e
	shr	eax,9
	mov	dword ptr MGRP:_e,eax
   ;	
   ;	  if (!e) e++;
   ;	
	cmp	dword ptr MGRP:_e,large 0
	jne	short @22@562
	inc	dword ptr MGRP:_e
@22@562:
   ;	
   ;	  for (b=219;(b<(e+219));b++)
   ;	
	mov	dword ptr MGRP:_b,large 219
	jmp	@22@898
@22@590:
   ;	
   ;	  {
   ;	   fcb_dir (b,&bitmap);
   ;	
	push	offset MGRP:_bitmap
	push	dword ptr MGRP:_b
	call	near ptr MGRP:_fcb_dir
	add	sp,6
   ;	
   ;	   for (d=0;d<=511;d++)
   ;	
	mov	dword ptr MGRP:_d,large 0
	jmp	short @22@842
@22@618:
   ;	
   ;	   {
   ;	    for (c=0;c<=7;c++)
   ;	
	mov	dword ptr MGRP:_c,large 0
	jmp	short @22@786
@22@646:
   ;	
   ;	    {
   ;	     if ( bitmap[d] & (1<<c) )
   ;	
	mov	bx,word ptr MGRP:_d
	mov	al,byte ptr MGRP:_bitmap[bx]
	mov	ah,0
	mov	dx,1
	mov	cl,byte ptr MGRP:_c
	shl	dx,cl
	test	ax,dx
	je	short @22@730
   ;	
   ;	     {
   ;	      total_size++;
   ;	
	inc	dword ptr MGRP:_total_size
   ;	
   ;	      if (!strcmp ((string)ScanString(cmd,3),"picture"))
   ;	
	push	offset MGRP:s@+249
	push	3
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@730
   ;	
   ;	       putpixel (adr,9);
   ;	
	push	9
	push	word ptr MGRP:_adr
	call	near ptr MGRP:_putpixel
	add	sp,4
@22@730:
   ;	
   ;	     }
   ;	    adr++;
   ;	
	inc	word ptr MGRP:_adr
	inc	dword ptr MGRP:_c
@22@786:
	cmp	dword ptr MGRP:_c,large 7
	jbe	short @22@646
	inc	dword ptr MGRP:_d
@22@842:
	cmp	dword ptr MGRP:_d,large 511
	jbe	short @22@618
	inc	dword ptr MGRP:_b
@22@898:
	mov	eax,dword ptr MGRP:_e
	add	eax,large 219
	cmp	eax,dword ptr MGRP:_b
	jbe short	@@2
	jmp	@22@590
@@2:
   ;	
   ;	    }
   ;	   }
   ;	  }
   ;	  if (!strcmp ((string)ScanString(cmd,3),"picture"))
   ;	
	push	offset MGRP:s@+257
	push	3
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @22@1094
   ;	
   ;	   {
   ;	    asm { push ax ; xor ax,ax ; int 0x16 ; pop ax };
   ;	
 	push	 ax 
 	xor	 ax,ax 
 	int	 016H 
 	pop	 ax 
   ;	
   ;	    set_mode (3);
   ;	
	push	3
	call	near ptr MGRP:_set_mode
	pop	cx
@22@1094:
   ;	
   ;	   }
   ;	  ConsoleWriteString ("\n\rcluster(s) used: ");
   ;	
	push	offset MGRP:s@+265
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	  ConsoleWriteDword (total_size);
   ;	
	push	dword ptr MGRP:_total_size
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	  ConsoleWriteString (" (= ");
   ;	
	push	offset MGRP:s@+285
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	  ConsoleWriteDword (total_size*512);
   ;	
	mov	eax,dword ptr MGRP:_total_size
	shl	eax,9
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	  ConsoleWriteString (" bytes)");
   ;	
	push	offset MGRP:s@+290
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@1122:
   ;	
   ;	 }
   ;	
   ;	 if (!strcmp ((string)ScanString(cmd,1),"chain"))
   ;	
	push	offset MGRP:s@+298
	push	1
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@3
	jmp	@22@1906
@@3:
   ;	
   ;	  {
   ;	   quit = 0;
   ;	
	mov	word ptr MGRP:_quit,0
   ;	
   ;	   d = 1;
   ;	
	mov	dword ptr MGRP:_d,large 1
   ;	
   ;	   drive = 1;
   ;	
	mov	byte ptr [bp-1],1
   ;	
   ;	   e = 0;
   ;	
	mov	dword ptr MGRP:_e,large 0
   ;	
   ;	   total_size = 0;
   ;	
	mov	dword ptr MGRP:_total_size,large 0
   ;	
   ;	   fcb_dir (18,&cluster_buffer);
   ;	
	push	offset MGRP:_cluster_buffer
	push	large 18
	call	near ptr MGRP:_fcb_dir
	add	sp,6
   ;	
   ;	   b = (ulong)(cluster_buffer[0].f_size+1);
   ;	
	mov	eax,dword ptr MGRP:_cluster_buffer+12
	inc	eax
	mov	dword ptr MGRP:_b,eax
   ;	
   ;	   ConsoleWriteDword (b);
   ;	
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	   c = 1;
   ;	
	mov	dword ptr MGRP:_c,large 1
   ;	
   ;	   for (a=18; (!quit) ; a++)
   ;	
	mov	dword ptr MGRP:_a,large 18
	jmp	@22@1850
@22@1178:
   ;	
   ;	   {
   ;	    fcb_dir (a,&cluster_buffer);
   ;	
	push	offset MGRP:_cluster_buffer
	push	dword ptr MGRP:_a
	call	near ptr MGRP:_fcb_dir
	add	sp,6
	jmp	@22@1766
@22@1206:
   ;	
   ;	    for (; c <= 15; c++)
   ;	    {
   ;	     if (cluster_buffer[c].f_name [0] != 0)
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx],0
	jne short	@@4
	jmp	@22@1738
@@4:
   ;	
   ;	     {
   ;	      if (d==b) { quit = 1; break; }
   ;	
	mov	eax,dword ptr MGRP:_d
	cmp	eax,dword ptr MGRP:_b
	jne	short @22@1290
	mov	word ptr MGRP:_quit,1
	jmp	@22@1794
@22@1290:
   ;	
   ;	      d++;
   ;	
	inc	dword ptr MGRP:_d
   ;	
   ;	      e++;
   ;	
	inc	dword ptr MGRP:_e
   ;	
   ;	      ConsoleWriteString ("\n\rfcb      : ");
   ;	
	push	offset MGRP:s@+304
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       ConsoleWriteDword ( ((a-18) << 4) + c );
   ;	
	mov	eax,dword ptr MGRP:_a
	sub	eax,large 18
	shl	eax,4
	add	eax,dword ptr MGRP:_c
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	      ConsoleWriteString ("\n\rname     : ");
   ;	
	push	offset MGRP:s@+318
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       ConsoleWriteString (cluster_buffer [c].f_name);
   ;	
	mov	ax,word ptr MGRP:_c
	shl	ax,5
	add	ax,offset MGRP:_cluster_buffer
	push	ax
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	      ConsoleWriteString ("\n\rsize     : ");
   ;	
	push	offset MGRP:s@+332
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	      if (cluster_buffer [c].f_attr != 0xa) total_size += cluster_buffer [c].f_size;
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],10
	je	short @22@1346
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	mov	eax,dword ptr MGRP:_cluster_buffer[bx+12]
	add	dword ptr MGRP:_total_size,eax
@22@1346:
   ;	
   ;	       ConsoleWriteDword (cluster_buffer [c].f_size);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	push	dword ptr MGRP:_cluster_buffer[bx+12]
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	      ConsoleWriteString ("\n\rdate     : ");
   ;	
	push	offset MGRP:s@+346
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       ConsoleWriteDword ((ulong)cluster_buffer [c].f_month);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	movzx	eax,byte ptr MGRP:_cluster_buffer[bx+21]
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;		ConsoleWriteChar ('/');
   ;	
	push	47
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
   ;	
   ;	       ConsoleWriteDword ((ulong)cluster_buffer [c].f_day);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	movzx	eax,byte ptr MGRP:_cluster_buffer[bx+20]
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;		ConsoleWriteChar ('/');
   ;	
	push	47
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
   ;	
   ;	       ConsoleWriteDword ((ulong)cluster_buffer [c].f_year);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	movzx	eax,word ptr MGRP:_cluster_buffer[bx+22]
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	      ConsoleWriteString ("\n\rtime     : ");
   ;	
	push	offset MGRP:s@+360
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       ConsoleWriteDword ((ulong)cluster_buffer [c].f_hour);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	movzx	eax,byte ptr MGRP:_cluster_buffer[bx+24]
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;		ConsoleWriteChar (':');
   ;	
	push	58
	call	near ptr MGRP:_ConsoleWriteChar
	pop	cx
   ;	
   ;	       ConsoleWriteDword ((ulong)cluster_buffer [c].f_min);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	movzx	eax,byte ptr MGRP:_cluster_buffer[bx+25]
	push	eax
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	      ConsoleWriteString ("\n\rattribut : ");
   ;	
	push	offset MGRP:s@+374
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       if (cluster_buffer [c].f_attr == 0xa)
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],10
	jne	short @22@1402
   ;	
   ;		ConsoleWriteString ("dir");
   ;	
	push	offset MGRP:s@+388
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@1402:
   ;	
   ;	       if (cluster_buffer [c].f_attr == 0xb)
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],11
	jne	short @22@1458
   ;	
   ;		ConsoleWriteString ("archive");
   ;	
	push	offset MGRP:s@+392
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@1458:
   ;	
   ;	       if (cluster_buffer [c].f_attr == 0xc)
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],12
	jne	short @22@1514
   ;	
   ;		ConsoleWriteString ("executable");
   ;	
	push	offset MGRP:s@+400
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@1514:
   ;	
   ;	       if (cluster_buffer [c].f_attr == 0xd)
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	cmp	byte ptr MGRP:_cluster_buffer[bx+26],13
	jne	short @22@1570
   ;	
   ;		ConsoleWriteString ("script");
   ;	
	push	offset MGRP:s@+411
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
@22@1570:
   ;	
   ;	      ConsoleWriteString ("\n\rcluster  : ");
   ;	
	push	offset MGRP:s@+418
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	       ConsoleWriteDword (cluster_buffer [c].f_cluster);
   ;	
	mov	bx,word ptr MGRP:_c
	shl	bx,5
	push	dword ptr MGRP:_cluster_buffer[bx+28]
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
   ;	
   ;	      ConsoleWriteString ("\n\r컴컴컴컴컴컴컴컴�");
   ;	
	push	offset MGRP:s@+432
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	      if (e == 3) { ConsoleWriteString ("\n\rpess a key");
   ;	
	cmp	dword ptr MGRP:_e,large 3
	jne	short @22@1738
	push	offset MGRP:s@+452
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;			    e = 0;
   ;	
	mov	dword ptr MGRP:_e,large 0
   ;	
   ;			    asm { push ax ; xor ax,ax ; int 0x16 ; pop ax };
   ;	
 	push	 ax 
 	xor	 ax,ax 
 	int	 016H 
 	pop	 ax 
@22@1738:
	inc	dword ptr MGRP:_c
@22@1766:
	cmp	dword ptr MGRP:_c,large 15
	ja short	@@5
	jmp	@22@1206
@@5:
@22@1794:
   ;	
   ;			  }
   ;	     }
   ;	    }
   ;	    c = 0;
   ;	
	mov	dword ptr MGRP:_c,large 0
	inc	dword ptr MGRP:_a
@22@1850:
	cmp	word ptr MGRP:_quit,0
	jne short	@@6
	jmp	@22@1178
@@6:
   ;	
   ;	   }
   ;	   ConsoleWriteString ("\n\r *** total bytes: ");
   ;	
	push	offset MGRP:s@+465
	call	near ptr MGRP:_ConsoleWriteString
	pop	cx
   ;	
   ;	   ConsoleWriteDword (total_size);
   ;	
	push	dword ptr MGRP:_total_size
	call	near ptr MGRP:_ConsoleWriteDword
	add	sp,4
@22@1906:
   ;	
   ;	  }
   ;	
   ;	 if (!strcmp ((string)ScanString(cmd,1),"exit")) break;
   ;	
	push	offset MGRP:s@+486
	push	1
	push	offset MGRP:_cmd
	call	near ptr MGRP:_ScanString
	add	sp,4
	push	ax
	call	near ptr MGRP:_strcmp
	add	sp,4
	mov	ah,0
	or	ax,ax
	je short	@@7
	jmp	@22@58
@@7:
   ;	
   ;	
   ;	 }
   ;	}
   ;	
	leave	
	ret	
_ProgramEntry	endp
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
_a	label	word
	db	4 dup (0)
_cmd	label	byte
	db	20 dup (0)
_DISK_STATE	label	word
	db	13 dup (0)
_DRIVE	label	byte
	db	1 dup (0)
	?debug	C E9
	?debug	C FA10000000
s@	label	byte
	db	'help'
	db	0
	db	10
	db	13
	db	'help - commands'
	db	0
	db	10
	db	13
	db	'disk [a/c] - disk informations (C/H/S)'
	db	0
	db	10
	db	13
	db	'bitmap [a:/c:] [picture] - bitmap'
	db	0
	db	10
	db	13
	db	'chain - FCB'
	db	10
	db	0
	db	'disk'
	db	0
	db	'a'
	db	0
	db	'c'
	db	0
	db	10
	db	13
	db	' * H/C/S        : '
	db	0
	db	10
	db	13
	db	' * Addr. Max.   : '
	db	0
	db	10
	db	13
	db	' * Size (Mb)    : '
	db	0
	db	10
	db	13
	db	' * bitmap (b)   : '
	db	0
	db	'bitmap'
	db	0
	db	'picture'
	db	0
	db	'a:'
	db	0
	db	'c:'
	db	0
	db	10
	db	13
	db	' bitmap [drive:] '
	db	0
	db	'picture'
	db	0
	db	'picture'
	db	0
	db	10
	db	13
	db	'cluster(s) used: '
	db	0
	db	' (= '
	db	0
	db	' bytes)'
	db	0
	db	'chain'
	db	0
	db	10
	db	13
	db	'fcb      : '
	db	0
	db	10
	db	13
	db	'name     : '
	db	0
	db	10
	db	13
	db	'size     : '
	db	0
	db	10
	db	13
	db	'date     : '
	db	0
	db	10
	db	13
	db	'time     : '
	db	0
	db	10
	db	13
	db	'attribut : '
	db	0
	db	'dir'
	db	0
	db	'archive'
	db	0
	db	'executable'
	db	0
	db	'script'
	db	0
	db	10
	db	13
	db	'cluster  : '
	db	0
	db	10
	db	13
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	-60
	db	0
	db	10
	db	13
	db	'pess a key'
	db	0
	db	10
	db	13
	db	' *** total bytes: '
	db	0
	db	'exit'
	db	0
VPSEG	ends
	public	_adr
	public	_bitmap
	public	_total_size
	public	_quit
	public	_e
	public	_d
	public	_c
	public	_b
	public	_a
	public	_cmd
_nl	equ	nl
_prompt	equ	prompt
	public	_ScanString
	public	_ConsoleReadString
	public	_ConsoleWriteDword
	public	_ConsoleWriteString
	public	_ConsoleWriteChar
	public	_acdisk
	public	_putpixel
	public	_set_mode
	public	_strcmp
	public	_strcat
	public	_strlen
	public	_strcpy
	public	_fcb_dir
	public	_get_fcb_count
	public	_cluster_buffer
	public	_lastf
	public	_absolute_disk_access
	public	_disk_access
	public	_get_sector
	public	_get_head
	public	_get_cyl
	public	_reset_disk
	public	_DISK_STATE
	public	_DRIVE
	public	_ProgramStartup
	public	_ProgramEntry
_s@	equ	s@
	end
