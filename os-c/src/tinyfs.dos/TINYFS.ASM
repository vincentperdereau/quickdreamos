	.386p
	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
	endif
	?debug	V 300h
	?debug	S "TINYFS.C"
	?debug	C E9F38E83270854494E5946532E43
	?debug	C E94019061915443A5C42435C494E434C5544455C535444494F2E48
	?debug	C E94019061915443A5C42435C494E434C5544455C5F444546532E48
	?debug	C E94019061916443A5C42435C494E434C5544455C5F4E46494C452E+
	?debug	C 48
	?debug	C E94019061915443A5C42435C494E434C5544455C5F4E554C4C2E48
	?debug	C E94019061916443A5C42435C494E434C5544455C5354444C49422E+
	?debug	C 48
	?debug	C E94019061916443A5C42435C494E434C5544455C535452494E472E+
	?debug	C 48
	?debug	C E94019061915443A5C42435C494E434C5544455C434F4E494F2E48
	?debug	C E94019061913443A5C42435C494E434C5544455C444F532E48
	?debug	C E94019061912443A5C42435C494E434C5544455C494F2E48
	?debug	C E951A3112709545950454445462E48
	?debug	C E9D97B4227064449534B2E48
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public use16 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public use16 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_TEXT	segment byte public use16 'CODE'
	?debug	C E802064449534B2E48D97B4227
   ;	
   ;	  bool reset_disk (uchar d)
   ;	
	?debug	L 31
	assume	cs:_TEXT
_reset_disk	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	  {
   ;	   asm {
   ;	        push dx
   ;	
	?debug	L 34
	push	 dx
   ;	
   ;	        mov ah,0
   ;	
	?debug	L 35
	mov	 ah,0
   ;	
   ;	        mov dl,d
   ;	
	?debug	L 36
	mov	 dl,[bp+4]
   ;	
   ;	        int 0x13
   ;	
	?debug	L 37
	int	 013H
   ;	
   ;	        mov al,ah
   ;	
	?debug	L 38
	mov	 al,ah
   ;	
   ;	        pop dx
   ;	
	?debug	L 39
	pop	 dx
   ;	
   ;	       }
   ;	  }
   ;	
	?debug	L 41
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_reset_disk	endp
   ;	
   ;	  ulong get_cyl (uchar d)
   ;	
	?debug	L 43
	assume	cs:_TEXT
_get_cyl	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	  {
   ;	   asm {
   ;		push bx
   ;	
	?debug	L 46
	push	 bx
   ;	
   ;	        push cx
   ;	
	?debug	L 47
	push	 cx
   ;	
   ;	        push si
   ;	
	?debug	L 48
	push	 si
   ;	
   ;	        push di
   ;	
	?debug	L 49
	push	 di
   ;	
   ;	        push es
   ;	
	?debug	L 50
	push	 es
   ;	
   ;	        mov dl,d
   ;	
	?debug	L 51
	mov	 dl,[bp+4]
   ;	
   ;	        mov ah,8
   ;	
	?debug	L 52
	mov	 ah,8
   ;	
   ;	        int 0x13
   ;	
	?debug	L 53
	int	 013H
   ;	
   ;	        mov al,ch
   ;	
	?debug	L 54
	mov	 al,ch
   ;	
   ;	        shr cl,6
   ;	
	?debug	L 55
	shr	 cl,6
   ;	
   ;	        mov ah,cl
   ;	
	?debug	L 56
	mov	 ah,cl
   ;	
   ;	        xor dx,dx
   ;	
	?debug	L 57
	xor	 dx,dx
   ;	
   ;	        pop es
   ;	
	?debug	L 58
	pop	 es
   ;	
   ;	        pop di
   ;	
	?debug	L 59
	pop	 di
   ;	
   ;	        pop si
   ;	
	?debug	L 60
	pop	 si
   ;	
   ;	        pop cx
   ;	
	?debug	L 61
	pop	 cx
   ;	
   ;	        pop bx
   ;	
	?debug	L 62
	pop	 bx
   ;	
   ;	       }
   ;	  }
   ;	
	?debug	L 64
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_get_cyl	endp
   ;	
   ;	  ulong get_head (uchar d)
   ;	
	?debug	L 66
	assume	cs:_TEXT
_get_head	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	  {
   ;	   asm {
   ;	        push cx
   ;	
	?debug	L 69
	push	 cx
   ;	
   ;	        push bx
   ;	
	?debug	L 70
	push	 bx
   ;	
   ;	        push es
   ;	
	?debug	L 71
	push	 es
   ;	
   ;		push di
   ;	
	?debug	L 72
	push	 di
   ;	
   ;	        push si
   ;	
	?debug	L 73
	push	 si
   ;	
   ;	        mov dl,d
   ;	
	?debug	L 74
	mov	 dl,[bp+4]
   ;	
   ;	        mov ah,8
   ;	
	?debug	L 75
	mov	 ah,8
   ;	
   ;		int 0x13
   ;	
	?debug	L 76
	int	 013H
   ;	
   ;	        mov ah,0
   ;	
	?debug	L 77
	mov	 ah,0
   ;	
   ;	        mov al,dh
   ;	
	?debug	L 78
	mov	 al,dh
   ;	
   ;	        xor dx,dx
   ;	
	?debug	L 79
	xor	 dx,dx
   ;	
   ;	        pop si
   ;	
	?debug	L 80
	pop	 si
   ;	
   ;	        pop di
   ;	
	?debug	L 81
	pop	 di
   ;	
   ;	        pop es
   ;	
	?debug	L 82
	pop	 es
   ;	
   ;	        pop bx
   ;	
	?debug	L 83
	pop	 bx
   ;	
   ;	        pop cx
   ;	
	?debug	L 84
	pop	 cx
   ;	
   ;	       }
   ;	  }
   ;	
	?debug	L 86
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_get_head	endp
   ;	
   ;	 ulong get_sector (uchar d)
   ;	
	?debug	L 88
	assume	cs:_TEXT
_get_sector	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  asm {
   ;	       push cx
   ;	
	?debug	L 91
	push	 cx
   ;	
   ;	       push bx
   ;	
	?debug	L 92
	push	 bx
   ;	
   ;	       push es
   ;	
	?debug	L 93
	push	 es
   ;	
   ;	       push di
   ;	
	?debug	L 94
	push	 di
   ;	
   ;	       push si
   ;	
	?debug	L 95
	push	 si
   ;	
   ;	       mov dl,d
   ;	
	?debug	L 96
	mov	 dl,[bp+4]
   ;	
   ;	       mov ah,8
   ;	
	?debug	L 97
	mov	 ah,8
   ;	
   ;	       int 0x13
   ;	
	?debug	L 98
	int	 013H
   ;	
   ;	       xor ah,ah
   ;	
	?debug	L 99
	xor	 ah,ah
   ;	
   ;	       xor dx,dx
   ;	
	?debug	L 100
	xor	 dx,dx
   ;	
   ;	       and cl,63
   ;	
	?debug	L 101
	and	 cl,63
   ;	
   ;	       mov al,cl
   ;	
	?debug	L 102
	mov	 al,cl
   ;	
   ;	       pop si
   ;	
	?debug	L 103
	pop	 si
   ;	
   ;	       pop di
   ;	
	?debug	L 104
	pop	 di
   ;	
   ;	       pop es
   ;	
	?debug	L 105
	pop	 es
   ;	
   ;	       pop bx
   ;	
	?debug	L 106
	pop	 bx
   ;	
   ;	       pop cx
   ;	
	?debug	L 107
	pop	 cx
   ;	
   ;	      }
   ;	 }
   ;	
	?debug	L 109
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_get_sector	endp
   ;	
   ;	 void write_disk_infos (uchar d)
   ;	
	?debug	L 111
	assume	cs:_TEXT
_write_disk_infos	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  write_string ("\r\nDisk "); write_string ((d) ? "C: " : "A: ");
   ;	
	?debug	L 113
	push	offset DGROUP:s@
	call	near ptr _printf
	pop	cx
	cmp	byte ptr [bp+4],0
	je	short @5@86
	mov	ax,offset DGROUP:s@+8
	jmp	short @5@114
@5@86:
	mov	ax,offset DGROUP:s@+12
@5@114:
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	  write_hex_word (get_cyl (d)+1); write_char ('C'); write_char (' ');
   ;	
	?debug	L 114
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	push	offset DGROUP:s@+16
	call	near ptr _printf
	add	sp,6
	inc	word ptr DGROUP:__streams+16
	jge	short @5@170
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,67
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@198
@5@170:
	push	offset DGROUP:__streams+16
	push	67
	call	near ptr __fputc
	add	sp,4
@5@198:
	inc	word ptr DGROUP:__streams+16
	jge	short @5@254
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,32
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@282
@5@254:
	push	offset DGROUP:__streams+16
	push	32
	call	near ptr __fputc
	add	sp,4
@5@282:
   ;	
   ;	  write_hex_byte (get_head (d)+1); write_char ('H'); write_char (' ');
   ;	
	?debug	L 115
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	push	offset DGROUP:s@+19
	call	near ptr _printf
	add	sp,6
	inc	word ptr DGROUP:__streams+16
	jge	short @5@338
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,72
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@366
@5@338:
	push	offset DGROUP:__streams+16
	push	72
	call	near ptr __fputc
	add	sp,4
@5@366:
	inc	word ptr DGROUP:__streams+16
	jge	short @5@422
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,32
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@450
@5@422:
	push	offset DGROUP:__streams+16
	push	32
	call	near ptr __fputc
	add	sp,4
@5@450:
   ;	
   ;	  write_hex_byte (get_sector (d)); write_char ('S'); write_char (',');
   ;	
	?debug	L 116
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_sector
	pop	cx
	push	dx
	push	ax
	push	offset DGROUP:s@+22
	call	near ptr _printf
	add	sp,6
	inc	word ptr DGROUP:__streams+16
	jge	short @5@506
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,83
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@534
@5@506:
	push	offset DGROUP:__streams+16
	push	83
	call	near ptr __fputc
	add	sp,4
@5@534:
	inc	word ptr DGROUP:__streams+16
	jge	short @5@590
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	al,44
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @5@618
@5@590:
	push	offset DGROUP:__streams+16
	push	44
	call	near ptr __fputc
	add	sp,4
@5@618:
   ;	
   ;	  write_hex_dword ( (get_cyl (d)+1)*(get_head(d)+1)*(get_sector(d)) );
   ;	
	?debug	L 117
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_cyl
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	push	eax
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_head
	push	dx
	push	ax
	pop	eax
	pop	cx
	inc	eax
	pop	edx
	imul	edx,eax
	push	edx
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_sector
	push	dx
	push	ax
	pop	eax
	pop	cx
	pop	edx
	imul	edx,eax
	push	edx
	push	offset DGROUP:s@+25
	call	near ptr _printf
	add	sp,6
   ;	
   ;	 }
   ;	
	?debug	L 118
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_write_disk_infos	endp
   ;	
   ;	 bool disk_access (uchar d,
   ;	
	?debug	L 120
	assume	cs:_TEXT
_disk_access	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E318000200150104
	?debug	C E6026F70040A120000047365676D0A0A10000003+
	?debug	C 6F6673180A0E000005636F756E74040A0C000001+
	?debug	C 73040A0A00000163040A0800000168040A060000+
	?debug	C 0164080A040000
	?debug	B
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
	?debug	L 130
	push	 dx
   ;	
   ;	       push cx
   ;	
	?debug	L 131
	push	 cx
   ;	
   ;	       push bx
   ;	
	?debug	L 132
	push	 bx
   ;	
   ;	       push es
   ;	
	?debug	L 133
	push	 es
   ;	
   ;	       mov dl,d
   ;	
	?debug	L 134
	mov	 dl,[bp+4]
   ;	
   ;	       mov ax,h
   ;	
	?debug	L 135
	mov	 ax,[bp+6]
   ;	
   ;	       mov dh,al
   ;	
	?debug	L 136
	mov	 dh,al
   ;	
   ;	       mov cx,c
   ;	
	?debug	L 137
	mov	 cx,[bp+8]
   ;	
   ;	       xchg ch,cl
   ;	
	?debug	L 138
	xchg	 ch,cl
   ;	
   ;	       shl cl,6
   ;	
	?debug	L 139
	shl	 cl,6
   ;	
   ;	       mov ax,s
   ;	
	?debug	L 140
	mov	 ax,[bp+10]
   ;	
   ;	       or cl,al
   ;	
	?debug	L 141
	or	 cl,al
   ;	
   ;	       mov ax,segm
   ;	
	?debug	L 142
	mov	 ax,[bp+16]
   ;	
   ;	       mov es,ax
   ;	
	?debug	L 143
	mov	 es,ax
   ;	
   ;	       mov ax,count
   ;	
	?debug	L 144
	mov	 ax,[bp+12]
   ;	
   ;	       mov bx,op
   ;	
	?debug	L 145
	mov	 bx,[bp+18]
   ;	
   ;	       mov ah,bl
   ;	
	?debug	L 146
	mov	 ah,bl
   ;	
   ;	       mov bx,ofs
   ;	
	?debug	L 147
	mov	 bx,[bp+14]
   ;	
   ;	       int 0x13
   ;	
	?debug	L 148
	int	 013H
   ;	
   ;	       shr ax,8
   ;	
	?debug	L 149
	shr	 ax,8
   ;	
   ;	       pop es
   ;	
	?debug	L 150
	pop	 es
   ;	
   ;	       pop bx
   ;	
	?debug	L 151
	pop	 bx
   ;	
   ;	       pop cx
   ;	
	?debug	L 152
	pop	 cx
   ;	
   ;	       pop dx
   ;	
	?debug	L 153
	pop	 dx
   ;	
   ;	      }
   ;	 }
   ;	
	?debug	L 155
	pop	bp
	ret	
	?debug	C E60164080A0400000168040A0600000163040A08+
	?debug	C 00000173040A0A000005636F756E74040A0C0000+
	?debug	C 036F6673180A0E0000047365676D0A0A10000002+
	?debug	C 6F70040A120000
	?debug	E
	?debug	E
_disk_access	endp
   ;	
   ;	 bool absolute_disk_access (uchar d,
   ;	
	?debug	L 157
	assume	cs:_TEXT
_absolute_disk_access	proc	near
	?debug	B
	enter	14,0
	push	si
	push	di
	?debug	C E6036F66730A0A100000037365670A0A0E000004+
	?debug	C 616464720C0A0A000005636F756E74040A080000+
	?debug	C 026F70040A0600000164080A040000
	mov	si,word ptr [bp+6]
	mov	di,word ptr [bp+8]
	?debug	B
   ;	
   ;	                            int op,
   ;	                            int count,
   ;	                            ulong addr,
   ;	                            uint seg,
   ;	                            uint ofs)
   ;	 {
   ;	  ulong c,h,s;
   ;	  bool stat;
   ;	  s = 1 + (addr % (ulong)disk_state.sector );
   ;	
	?debug	L 166
	movzx	ebx,byte ptr DGROUP:_disk_state+3
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	div	ebx
	inc	edx
	mov	dword ptr [bp-12],edx
   ;	
   ;	  h = (addr / (ulong)disk_state.sector) % (ulong)disk_state.head;
   ;	
	?debug	L 167
	movzx	ebx,byte ptr DGROUP:_disk_state+3
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	div	ebx
	movzx	ebx,byte ptr DGROUP:_disk_state+2
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-8],edx
   ;	
   ;	  c = addr / ((ulong)disk_state.sector * (ulong)disk_state.head);
   ;	
	?debug	L 168
	movzx	ebx,byte ptr DGROUP:_disk_state+3
	movzx	eax,byte ptr DGROUP:_disk_state+2
	imul	ebx,eax
	mov	eax,dword ptr [bp+10]
	xor	edx,edx
	div	ebx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	?debug	L 169
	push	si
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	di
	push	word ptr [bp-12]
	push	word ptr [bp-4]
	push	word ptr [bp-8]
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _disk_access
	add	sp,16
	mov	byte ptr [bp-13],al
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	?debug	L 170
	cmp	byte ptr [bp-13],6
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
	call	near ptr _disk_access
	add	sp,16
	mov	byte ptr [bp-13],al
@7@86:
   ;	
   ;	  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
   ;	
	?debug	L 171
	cmp	byte ptr [bp-13],6
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
	call	near ptr _disk_access
	add	sp,16
	mov	byte ptr [bp-13],al
@7@142:
   ;	
   ;	  return stat;
   ;	
	?debug	L 172
	mov	al,byte ptr [bp-13]
	jmp	short @7@170
@7@170:
   ;	
   ;	 }
   ;	
	?debug	L 173
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E604737461740802F3FF0001730C02F4FF000168+
	?debug	C 0C02F8FF0001630C02FCFF000164080A04000002+
	?debug	C 6F70040C060005636F756E74040C070004616464+
	?debug	C 720C0A0A0000037365670A0A0E0000036F66730A+
	?debug	C 0A100000
	?debug	E
	?debug	E
_absolute_disk_access	endp
	?debug	C E9D1A66527054643422E48
	?debug	C E96B531C2706415454522E48
	?debug	C E95C7D3927084249544D41502E48
_TEXT	ends
_DATA	segment word public use16 'DATA'
_cache	label	word
	db	0
	db	0
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
	?debug	C E803084249544D41502E485C7D3927
   ;	
   ;	 ulong get_cluster_free (uchar d)
   ;	
	?debug	L 17
	assume	cs:_TEXT
_get_cluster_free	proc	near
	?debug	B
	enter	12,0
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong temp;
   ;	  ulong b;
   ;	  ulong a;
   ;	  for (temp=BITMAP_ADDR_START;temp<=BITMAP_ADDR_START+(disk_state.bitmap_size>>9);temp++)
   ;	
	?debug	L 22
	mov	dword ptr [bp-4],large 219
	jmp	@8@450
@8@58:
   ;	
   ;	  {
   ;	   if (cache==temp);
   ;	
	?debug	L 24
	mov	eax,dword ptr DGROUP:_cache
	cmp	eax,dword ptr [bp-4]
	jne	short @8@114
	jmp	short @8@198
@8@114:
   ;	
   ;	   else if (absolute_disk_access (d,DISK_READ,1,temp,FP_SEG(bitmap),(uint)&bitmap)) return 0;
   ;	
	?debug	L 25
	push	offset DGROUP:_bitmap
	push	ds
	push	dword ptr [bp-4]
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @8@198
@8@142:
	xor	eax,eax
@8@170:
	shld	edx,eax,16
	jmp	@8@506
@8@198:
   ;	
   ;	   cache = temp;
   ;	
	?debug	L 26
	mov	eax,dword ptr [bp-4]
	mov	dword ptr DGROUP:_cache,eax
   ;	
   ;	   for (b=0;b<=512-1;b++)
   ;	
	?debug	L 27
	mov	dword ptr [bp-8],large 0
	jmp	short @8@394
@8@226:
   ;	
   ;	    for (a=0;a<=7;a++)
   ;	
	?debug	L 28
	mov	dword ptr [bp-12],large 0
	jmp	short @8@338
@8@254:
   ;	
   ;	     {
   ;	      if ( (bitmap[b]&(1<<a)) != (1<<a) ) return (((temp-BITMAP_ADDR_START)<<12)+(b<<3)+a+1);
   ;	
	?debug	L 30
	mov	bx,word ptr [bp-8]
	mov	al,byte ptr DGROUP:_bitmap[bx]
	mov	ah,0
	mov	dx,1
	mov	cl,byte ptr [bp-12]
	shl	dx,cl
	and	ax,dx
	mov	dx,1
	mov	cl,byte ptr [bp-12]
	shl	dx,cl
	cmp	ax,dx
	je	short @8@310
	mov	eax,dword ptr [bp-4]
	sub	eax,large 219
	shl	eax,12
	mov	edx,dword ptr [bp-8]
	shl	edx,3
	add	eax,edx
	add	eax,dword ptr [bp-12]
	inc	eax
	jmp	short @8@170
@8@310:
	?debug	L 28
	inc	dword ptr [bp-12]
@8@338:
	cmp	dword ptr [bp-12],large 7
	jbe	short @8@254
	?debug	L 27
	inc	dword ptr [bp-8]
@8@394:
	cmp	dword ptr [bp-8],large 511
	jbe	short @8@226
	?debug	L 22
	inc	dword ptr [bp-4]
@8@450:
	mov	eax,dword ptr DGROUP:_disk_state+8
	shr	eax,9
	add	eax,large 219
	cmp	eax,dword ptr [bp-4]
	jb short	@@0
	jmp	@8@58
@@0:
	jmp	@8@142
@8@506:
   ;	
   ;	     }
   ;	  }
   ;	  return 0;
   ;	 }                                                 
   ;	
	?debug	L 34
	leave	
	ret	
	?debug	C E601610C02F4FF0001620C02F8FF000474656D70+
	?debug	C 0C02FCFF000164080A040000
	?debug	E
	?debug	E
_get_cluster_free	endp
   ;	
   ;	 bool set_cluster (uchar d, ulong cluster, uchar state)
   ;	
	?debug	L 36
	assume	cs:_TEXT
_set_cluster	proc	near
	?debug	B
	enter	4,0
	?debug	C E6057374617465080A0A000007636C7573746572+
	?debug	C 0C0A0600000164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong dummy;
   ;	  if (absolute_disk_access (d,DISK_READ,1,((cluster-1)>>12)+BITMAP_ADDR_START,FP_SEG(bitmap),(uint)&bitmap)) return 0;
   ;	
	?debug	L 39
	push	offset DGROUP:_bitmap
	push	ds
	mov	eax,dword ptr [bp+6]
	dec	eax
	shr	eax,12
	add	eax,large 219
	push	eax
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @9@86
@9@58:
	mov	al,0
	jmp	@9@226
@9@86:
   ;	
   ;	   dummy = ((cluster-1)%(512*8));
   ;	
	?debug	L 40
	mov	eax,dword ptr [bp+6]
	dec	eax
	and	eax,large 4095
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	   /*
   ;	   printf ("\nCLUSTER [%d]",cluster);
   ;	   printf ("\n * dummy:  %u",dummy);
   ;	   printf ("\n * sector: %u",((cluster-1)>>12)+BITMAP_ADDR_START);
   ;	   printf ("\n * byte:   %u",((dummy)>>3));
   ;	   printf ("\n * bit:    %u\n",(1<<(dummy % 8)));
   ;	   */
   ;	
   ;	   if (state) bitmap [(dummy>>3) ] |= (1<<((dummy % 8)));
   ;	
	?debug	L 50
	cmp	byte ptr [bp+10],0
	je	short @9@142
	mov	eax,dword ptr [bp-4]
	shr	eax,3
	mov	cl,byte ptr [bp-4]
	and	cl,7
	mov	dl,1
	shl	dl,cl
	mov	ebx,eax
	or	byte ptr DGROUP:_bitmap[bx],dl
	jmp	short @9@170
@9@142:
   ;	
   ;	   else  bitmap [(dummy>>3)] &= (0xff ^ (1<<(dummy % 8)));
   ;	
	?debug	L 51
	mov	eax,dword ptr [bp-4]
	shr	eax,3
	mov	cl,byte ptr [bp-4]
	and	cl,7
	mov	dl,1
	shl	dl,cl
	mov	bl,255
	xor	bl,dl
	xchg	ebx,eax
	and	byte ptr DGROUP:_bitmap[bx],al
@9@170:
   ;	
   ;	  if (absolute_disk_access (d,DISK_WRITE,1,((cluster-1)>>12)+BITMAP_ADDR_START,FP_SEG(bitmap),(uint)&bitmap)) return 0;
   ;	
	?debug	L 52
	push	offset DGROUP:_bitmap
	push	ds
	mov	eax,dword ptr [bp+6]
	dec	eax
	shr	eax,12
	add	eax,large 219
	push	eax
	push	1
	push	3
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @9@226
	jmp	@9@58
@9@226:
   ;	
   ;	 }
   ;	
	?debug	L 53
	leave	
	ret	
	?debug	C E60564756D6D790C02FCFF000164080A04000007+
	?debug	C 636C75737465720C0A060000057374617465080A+
	?debug	C 0A0000
	?debug	E
	?debug	E
_set_cluster	endp
	?debug	C E979531D2706494E49542E48
	?debug	C E80406494E49542E4879531D27
   ;	
   ;	 bool init_disk (uchar d)
   ;	
	?debug	L 11
	assume	cs:_TEXT
_init_disk	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  if (reset_disk(d)) return 1;
   ;	
	?debug	L 13
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _reset_disk
	pop	cx
	or	al,al
	je	short @10@114
@10@58:
	mov	al,1
@10@86:
	jmp	short @10@198
@10@114:
   ;	
   ;	  disk_state.cyl = get_cyl (d) +1;
   ;	
	?debug	L 14
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_cyl
	pop	cx
	inc	ax
	mov	word ptr DGROUP:_disk_state,ax
   ;	
   ;	  disk_state.head = get_head (d) +1;
   ;	
	?debug	L 15
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_head
	pop	cx
	inc	al
	mov	byte ptr DGROUP:_disk_state+2,al
   ;	
   ;	  disk_state.sector = get_sector (d);
   ;	
	?debug	L 16
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_sector
	pop	cx
	mov	byte ptr DGROUP:_disk_state+3,al
   ;	
   ;	  disk_state.max_addr = disk_state.cyl * disk_state.head * disk_state.sector -1;
   ;	
	?debug	L 17
	mov	al,byte ptr DGROUP:_disk_state+2
	mov	ah,0
	push	ax
	mov	ax,word ptr DGROUP:_disk_state
	pop	dx
	imul	dx
	mov	dl,byte ptr DGROUP:_disk_state+3
	mov	dh,0
	imul	dx
	dec	ax
	movzx	eax,ax
	mov	dword ptr DGROUP:_disk_state+4,eax
   ;	
   ;	  disk_state.bitmap_size = (disk_state.max_addr >>3) +1;
   ;	
	?debug	L 18
	mov	eax,dword ptr DGROUP:_disk_state+4
	shr	eax,3
	inc	eax
	mov	dword ptr DGROUP:_disk_state+8,eax
   ;	
   ;	  if (!disk_state.max_addr) return 1;
   ;	
	?debug	L 19
	cmp	dword ptr DGROUP:_disk_state+4,large 0
	jne	short @10@170
	jmp	short @10@58
@10@170:
   ;	
   ;	  DRIVE = d;
   ;	
	?debug	L 20
	mov	al,byte ptr [bp+4]
	mov	byte ptr DGROUP:_DRIVE,al
   ;	
   ;	  return 0;
   ;	
	?debug	L 21
	mov	al,0
	jmp	short @10@86
@10@198:
   ;	
   ;	 }
   ;	
	?debug	L 22
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_init_disk	endp
	?debug	C E9098D832706464342322E48
	?debug	C E80506464342322E48098D8327
   ;	
   ;	 ulong get_fcb_free (uchar d)
   ;	
	?debug	L 13
	assume	cs:_TEXT
_get_fcb_free	proc	near
	?debug	B
	enter	8,0
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong i;
   ;	  ulong j=1;
   ;	
	?debug	L 16
	mov	dword ptr [bp-8],large 1
   ;	
   ;	
   ;	  for (i=FCB_ADDR_BEGIN;i <= FCB_ADDR_END; i++)
   ;	
	?debug	L 18
	mov	dword ptr [bp-4],large 18
	jmp	short @11@338
@11@58:
   ;	
   ;	  {
   ;	   if (absolute_disk_access (d,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 20
	push	offset DGROUP:_fcb
	push	ds
	push	dword ptr [bp-4]
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @11@142
@11@86:
	xor	eax,eax
@11@114:
	shld	edx,eax,16
	jmp	short @11@394
@11@142:
	jmp	short @11@254
@11@170:
   ;	
   ;	   {
   ;	    for (; j <= (FCB_PER_SECTOR-1); j++)
   ;	    {
   ;	     if (fcb[j].f_name[0]==0) return (((i-FCB_ADDR_BEGIN)<<4)+j+1);
   ;	
	?debug	L 24
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr DGROUP:_fcb[bx],0
	jne	short @11@226
	mov	eax,dword ptr [bp-4]
	sub	eax,large 18
	shl	eax,4
	add	eax,dword ptr [bp-8]
	inc	eax
	jmp	short @11@114
@11@226:
	?debug	L 22
	inc	dword ptr [bp-8]
@11@254:
	cmp	dword ptr [bp-8],large 15
	jbe	short @11@170
   ;	
   ;	    }
   ;	   j = 0;
   ;	
	?debug	L 26
	mov	dword ptr [bp-8],large 0
	?debug	L 18
	inc	dword ptr [bp-4]
@11@338:
	cmp	dword ptr [bp-4],large 218
	jbe	short @11@58
	jmp	short @11@86
@11@394:
   ;	
   ;	   }
   ;	  }
   ;	  return 0;
   ;	 }
   ;	
	?debug	L 30
	leave	
	ret	
	?debug	C E6016A0C02F8FF0001690C02FCFF000164080A04+
	?debug	C 0000
	?debug	E
	?debug	E
_get_fcb_free	endp
   ;	
   ;	 bool set_fcb (uchar d,ulong fcb_addr,struct file_control_block *FCB)
   ;	
	?debug	L 32
	assume	cs:_TEXT
_set_fcb	proc	near
	?debug	B
	enter	4,0
	?debug	C E31A1266696C655F636F6E74726F6C5F626C6F63+
	?debug	C 6B20001E01
	?debug	C E31B000C001A02
	?debug	C E319000200151A04
	?debug	C E603464342190A0A0000086663625F616464720C+
	?debug	C 0A0600000164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong dummy;
   ;	  dummy = ((fcb_addr-1)>>4);
   ;	
	?debug	L 35
	mov	eax,dword ptr [bp+6]
	dec	eax
	shr	eax,4
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 36
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr [bp-4]
	add	eax,large 18
	push	eax
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @12@114
@12@58:
	mov	al,0
@12@86:
	jmp	short @12@198
@12@114:
   ;	
   ;	
   ;	  /* MEMCPY !!!! */
   ;	  memcpy ( & (fcb [fcb_addr - (dummy<<4) -1]), FCB, FCB_SIZE);
   ;	
	?debug	L 39
	push	32
	push	word ptr [bp+10]
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,word ptr [bp+6]
	sub	dx,ax
	shl	dx,5
	add	dx,offset DGROUP:_fcb-32
	push	dx
	call	near ptr _memcpy
	add	sp,6
   ;	
   ;	
   ;	  if (absolute_disk_access (d,DISK_WRITE,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 41
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr [bp-4]
	add	eax,large 18
	push	eax
	push	1
	push	3
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @12@170
	jmp	short @12@58
@12@170:
   ;	
   ;	  return 1;
   ;	
	?debug	L 42
	mov	al,1
	jmp	short @12@86
@12@198:
   ;	
   ;	 }
   ;	
	?debug	L 43
	leave	
	ret	
	?debug	C E60564756D6D790C02FCFF000164080A04000008+
	?debug	C 6663625F616464720C0A06000003464342190A0A+
	?debug	C 0000
	?debug	E
	?debug	E
_set_fcb	endp
   ;	
   ;	 bool read_fcb (uchar d,ulong fcb_addr,struct file_control_block *FCB)
   ;	
	?debug	L 45
	assume	cs:_TEXT
_read_fcb	proc	near
	?debug	B
	enter	4,0
	?debug	C E603464342190A0A0000086663625F616464720C+
	?debug	C 0A0600000164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong dummy;
   ;	  dummy = ((fcb_addr-1)>>4);
   ;	
	?debug	L 48
	mov	eax,dword ptr [bp+6]
	dec	eax
	shr	eax,4
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 49
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr [bp-4]
	add	eax,large 18
	push	eax
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @13@114
	mov	al,0
@13@86:
	jmp	short @13@142
@13@114:
   ;	
   ;	
   ;	  /* MEMCPY !!!! */
   ;	  memcpy (FCB,& (fcb [fcb_addr - (dummy<<4) -1]), FCB_SIZE);
   ;	
	?debug	L 52
	push	32
	mov	ax,word ptr [bp-4]
	shl	ax,4
	mov	dx,word ptr [bp+6]
	sub	dx,ax
	shl	dx,5
	add	dx,offset DGROUP:_fcb-32
	push	dx
	push	word ptr [bp+10]
	call	near ptr _memcpy
	add	sp,6
   ;	
   ;	  return 1;
   ;	
	?debug	L 53
	mov	al,1
	jmp	short @13@86
@13@142:
   ;	
   ;	 }
   ;	
	?debug	L 54
	leave	
	ret	
	?debug	C E60564756D6D790C02FCFF000164080A04000008+
	?debug	C 6663625F616464720C0A06000003464342190A0A+
	?debug	C 0000
	?debug	E
	?debug	E
_read_fcb	endp
   ;	
   ;	 ulong get_fcb_count (uchar d)
   ;	
	?debug	L 56
	assume	cs:_TEXT
_get_fcb_count	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 58
	push	offset DGROUP:_fcb
	push	ds
	push	large 18
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @14@114
	xor	eax,eax
@14@86:
	shld	edx,eax,16
	jmp	short @14@142
@14@114:
   ;	
   ;	  return (fcb[0].f_size+1);
   ;	
	?debug	L 59
	mov	eax,dword ptr DGROUP:_fcb+12
	inc	eax
	jmp	short @14@86
@14@142:
   ;	
   ;	 }
   ;	
	?debug	L 60
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_get_fcb_count	endp
   ;	
   ;	 bool inc_fcb_count (uchar d)
   ;	
	?debug	L 62
	assume	cs:_TEXT
_inc_fcb_count	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 64
	push	offset DGROUP:_fcb
	push	ds
	push	large 18
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @15@114
@15@58:
	mov	al,0
@15@86:
	jmp	short @15@198
@15@114:
   ;	
   ;	  fcb[0].f_size++;
   ;	
	?debug	L 65
	inc	dword ptr DGROUP:_fcb+12
   ;	
   ;	  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 66
	push	offset DGROUP:_fcb
	push	ds
	push	large 18
	push	1
	push	3
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @15@170
	jmp	short @15@58
@15@170:
   ;	
   ;	  return 1;
   ;	
	?debug	L 67
	mov	al,1
	jmp	short @15@86
@15@198:
   ;	
   ;	 }
   ;	
	?debug	L 68
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_inc_fcb_count	endp
   ;	
   ;	 bool dec_fcb_count (uchar d)
   ;	
	?debug	L 70
	assume	cs:_TEXT
_dec_fcb_count	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 72
	push	offset DGROUP:_fcb
	push	ds
	push	large 18
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @16@114
@16@58:
	mov	al,0
@16@86:
	jmp	short @16@198
@16@114:
   ;	
   ;	  fcb[0].f_size--;
   ;	
	?debug	L 73
	dec	dword ptr DGROUP:_fcb+12
   ;	
   ;	  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 74
	push	offset DGROUP:_fcb
	push	ds
	push	large 18
	push	1
	push	3
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @16@170
	jmp	short @16@58
@16@170:
   ;	
   ;	  return 1;
   ;	
	?debug	L 75
	mov	al,1
	jmp	short @16@86
@16@198:
   ;	
   ;	 }
   ;	
	?debug	L 76
	pop	bp
	ret	
	?debug	C E60164080A040000
	?debug	E
	?debug	E
_dec_fcb_count	endp
   ;	
   ;	 ulong get_fcb (uchar d,
   ;	
	?debug	L 79
	assume	cs:_TEXT
_get_fcb	proc	near
	?debug	B
	enter	16,0
	?debug	C E31C000200150804
	?debug	C E603464342190A0E00000A6469725F6661746865+
	?debug	C 720C0A0A00000461747472080A08000005666E61+
	?debug	C 6D651C0A0600000164080A040000
	?debug	B
   ;	
   ;		       string fname,
   ;		       uchar attr,
   ;		       ulong dir_father,
   ;		       struct file_control_block *FCB)
   ;	 {
   ;	  ulong i,j;
   ;	  ulong fcb_count;
   ;	  ulong counter=0;
   ;	
	?debug	L 87
	mov	dword ptr [bp-16],large 0
   ;	
   ;	
   ;	  fcb_count = get_fcb_count (d);
   ;	
	?debug	L 89
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _get_fcb_count
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-12],eax
   ;	
   ;	  j = 1;
   ;	
	?debug	L 90
	mov	dword ptr [bp-8],large 1
   ;	
   ;	  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
   ;	
	?debug	L 91
	mov	dword ptr [bp-4],large 18
	jmp	@17@506
@17@58:
   ;	
   ;	  {
   ;	   if (absolute_disk_access (d,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb)) return 0;
   ;	
	?debug	L 93
	push	offset DGROUP:_fcb
	push	ds
	push	dword ptr [bp-4]
	push	1
	push	2
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @17@142
@17@86:
	xor	eax,eax
@17@114:
	shld	edx,eax,16
	jmp	@17@562
@17@142:
	jmp	@17@422
@17@170:
   ;	
   ;	   for (;j <= (FCB_PER_SECTOR-1); j++)
   ;	   {
   ;	    if ( (counter+1) == fcb_count ) return 0;
   ;	
	?debug	L 96
	mov	eax,dword ptr [bp-16]
	inc	eax
	cmp	eax,dword ptr [bp-12]
	jne	short @17@226
	jmp	short @17@86
@17@226:
   ;	
   ;	    if ( fcb[j].f_name [0] != 0) counter++;
   ;	
	?debug	L 97
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr DGROUP:_fcb[bx],0
	je	short @17@282
	inc	dword ptr [bp-16]
@17@282:
   ;	
   ;	    if (   (!strcmp (fname,fcb[j].f_name))
   ;	
	?debug	L 98
   ;	
   ;		&& (attr == fcb[j].f_attr)
   ;		&& (dir_father == fcb[j].f_dir_father) )
   ;	
	?debug	L 100
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset DGROUP:_fcb
	push	ax
	push	word ptr [bp+6]
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @17@394
	mov	bx,word ptr [bp-8]
	shl	bx,5
	mov	al,byte ptr DGROUP:_fcb[bx+26]
	cmp	al,byte ptr [bp+8]
	jne	short @17@394
	mov	bx,word ptr [bp-8]
	shl	bx,5
	mov	eax,dword ptr DGROUP:_fcb[bx+16]
	cmp	eax,dword ptr [bp+10]
	jne	short @17@394
   ;	
   ;		{
   ;			memcpy (FCB, & (fcb [j]), FCB_SIZE);
   ;	
	?debug	L 102
	push	32
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset DGROUP:_fcb
	push	ax
	push	word ptr [bp+14]
	call	near ptr _memcpy
	add	sp,6
   ;	
   ;			return (((i-FCB_ADDR_BEGIN)<<4)+j+1);
   ;	
	?debug	L 103
	mov	eax,dword ptr [bp-4]
	sub	eax,large 18
	shl	eax,4
	add	eax,dword ptr [bp-8]
	inc	eax
	jmp	@17@114
@17@394:
	?debug	L 94
	inc	dword ptr [bp-8]
@17@422:
	cmp	dword ptr [bp-8],large 15
	ja short	@@1
	jmp	@17@170
@@1:
   ;	
   ;		}
   ;	   }
   ;	   j = 0;
   ;	
	?debug	L 106
	mov	dword ptr [bp-8],large 0
	?debug	L 91
	inc	dword ptr [bp-4]
@17@506:
	cmp	dword ptr [bp-4],large 218
	ja short	@@2
	jmp	@17@58
@@2:
	jmp	@17@86
@17@562:
   ;	
   ;	  }
   ;	  return 0;
   ;	 }
   ;	
	?debug	L 109
	leave	
	ret	
	?debug	C E607636F756E7465720C02F0FF00096663625F63+
	?debug	C 6F756E740C02F4FF00016A0C02F8FF0001690C02+
	?debug	C FCFF000164080A04000005666E616D651C0A0600+
	?debug	C 000461747472080A0800000A6469725F66617468+
	?debug	C 65720C0A0A000003464342190A0E0000
	?debug	E
	?debug	E
_get_fcb	endp
	?debug	C E9118F8327084352454154452E48
	?debug	C E806084352454154452E48118F8327
   ;	
   ;	   ulong create (string fname,
   ;	
	?debug	L 13
	assume	cs:_TEXT
_create	proc	near
	?debug	B
	enter	44,0
	push	si
	?debug	C E60A6469725F6661746865720C0A0A0000016408+
	?debug	C 0A0800000461747472080A06000005666E616D65+
	?debug	C 1C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	                 uchar attr,
   ;	                 uchar d,
   ;	                 ulong dir_father)
   ;	   {
   ;	    struct file_control_block tempFCB;
   ;	    ulong fcb_cluster;
   ;	    struct time t;
   ;	    struct date da;
   ;	
   ;	    // find if FCB doesn't exist yet
   ;	    if (get_fcb (d,fname,attr,dir_father,&tempFCB)) return 0;
   ;	
	?debug	L 24
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp+10]
	mov	al,byte ptr [bp+6]
	push	ax
	push	si
	mov	al,byte ptr [bp+8]
	push	ax
	call	near ptr _get_fcb
	add	sp,12
	or	ax,dx
	je	short @18@114
@18@58:
	xor	eax,eax
@18@86:
	shld	edx,eax,16
	jmp	@18@254
@18@114:
   ;	
   ;	    // find free fcb
   ;	    fcb_cluster = get_fcb_free (d);
   ;	
	?debug	L 26
	mov	al,byte ptr [bp+8]
	push	ax
	call	near ptr _get_fcb_free
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	    if (!fcb_cluster) return 0;
   ;	
	?debug	L 27
	cmp	dword ptr [bp-4],large 0
	jne	short @18@170
	jmp	short @18@58
@18@170:
   ;	
   ;	    // fill FCB fields
   ;	    strcpy (tempFCB.f_name,fname);
   ;	
	?debug	L 29
	push	si
	lea	ax,word ptr [bp-44]
	push	ax
	call	near ptr _strcpy
	add	sp,4
   ;	
   ;	    tempFCB.f_attr = attr;
   ;	
	?debug	L 30
	mov	al,byte ptr [bp+6]
	mov	byte ptr [bp-18],al
   ;	
   ;	    tempFCB.f_dir_father = dir_father;
   ;	
	?debug	L 31
	mov	eax,dword ptr [bp+10]
	mov	dword ptr [bp-28],eax
   ;	
   ;	    tempFCB.f_cluster = get_cluster_free (d);
   ;	
	?debug	L 32
	mov	al,byte ptr [bp+8]
	push	ax
	call	near ptr _get_cluster_free
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-16],eax
   ;	
   ;	
   ;	    gettime (&t);
   ;	
	?debug	L 34
	lea	ax,word ptr [bp-8]
	push	ax
	call	near ptr _gettime
	pop	cx
   ;	
   ;	    tempFCB.f_hour = t.ti_hour;
   ;	
	?debug	L 35
	mov	al,byte ptr [bp-7]
	mov	byte ptr [bp-20],al
   ;	
   ;	    tempFCB.f_min = t.ti_min;
   ;	
	?debug	L 36
	mov	al,byte ptr [bp-8]
	mov	byte ptr [bp-19],al
   ;	
   ;	    getdate (&da);
   ;	
	?debug	L 37
	lea	ax,word ptr [bp-12]
	push	ax
	call	near ptr _getdate
	pop	cx
   ;	
   ;	    tempFCB.f_year = da.da_year;
   ;	
	?debug	L 38
	mov	ax,word ptr [bp-12]
	mov	word ptr [bp-22],ax
   ;	
   ;	    tempFCB.f_month = da.da_mon;
   ;	
	?debug	L 39
	mov	al,byte ptr [bp-9]
	mov	byte ptr [bp-23],al
   ;	
   ;	    tempFCB.f_day = da.da_day;
   ;	
	?debug	L 40
	mov	al,byte ptr [bp-10]
	mov	byte ptr [bp-24],al
   ;	
   ;	
   ;	    fcluster = tempFCB.f_cluster;
   ;	
	?debug	L 42
	mov	eax,dword ptr [bp-16]
	mov	dword ptr DGROUP:_fcluster,eax
   ;	
   ;	    tempFCB.f_size = 0;
   ;	
	?debug	L 43
	mov	dword ptr [bp-32],large 0
   ;	
   ;	    // write fcb
   ;	    if (!set_fcb (d,fcb_cluster,&tempFCB)) return 0;
   ;	
	?debug	L 45
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp-4]
	mov	al,byte ptr [bp+8]
	push	ax
	call	near ptr _set_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @18@226
	jmp	@18@58
@18@226:
   ;	
   ;	    inc_fcb_count (d);
   ;	
	?debug	L 46
	mov	al,byte ptr [bp+8]
	push	ax
	call	near ptr _inc_fcb_count
	pop	cx
   ;	
   ;	    // return FCB cluster
   ;	    return fcb_cluster;
   ;	
	?debug	L 48
	mov	eax,dword ptr [bp-4]
	jmp	@18@86
@18@254:
   ;	
   ;	   }
   ;	
	?debug	L 49
	pop	si
	leave	
	ret	
	?debug	C E31D046461746504001E0D
	?debug	C E31E0474696D6504001E11
	?debug	C E60264611D02F4FF0001741E02F8FF000B666362+
	?debug	C 5F636C75737465720C02FCFF000774656D704643+
	?debug	C 421A02D4FF0005666E616D651C0C060004617474+
	?debug	C 72080A0600000164080A0800000A6469725F6661+
	?debug	C 746865720C0A0A0000
	?debug	E
	?debug	E
_create	endp
   ;	
   ;	   bool valid_name (string name)
   ;	
	?debug	L 51
	assume	cs:_TEXT
_valid_name	proc	near
	?debug	B
	enter	2,0
	push	si
	?debug	C E6046E616D651C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	   {
   ;	    uchar i;
   ;	    if (strlen (name) >= 12) return 0;
   ;	
	?debug	L 54
	push	si
	call	near ptr _strlen
	pop	cx
	cmp	ax,12
	jb	short @19@114
@19@58:
	mov	al,0
@19@86:
	jmp	@19@618
@19@114:
   ;	
   ;	    if (name[0] == 0) return 0;
   ;	
	?debug	L 55
	cmp	byte ptr [si],0
	jne	short @19@170
	jmp	short @19@58
@19@170:
   ;	
   ;	    for (i=0;i <= (strlen (name)-1); i++)
   ;	
	?debug	L 56
	mov	byte ptr [bp-1],0
	jmp	short @19@562
@19@198:
   ;	
   ;	    {
   ;	          if ( (name [i] > 96) && (name [i] < 123) );
   ;	
	?debug	L 58
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],96
	jbe	short @19@282
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],123
	jae	short @19@282
	jmp	short @19@534
@19@282:
   ;	
   ;	     else if ( (name [i] > 47) && (name [i] < 58) ) ;
   ;	
	?debug	L 59
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jbe	short @19@366
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],58
	jae	short @19@366
	jmp	short @19@534
@19@366:
   ;	
   ;	     else if ( (name [i] > 63) && (name [i] < 91 ) );
   ;	
	?debug	L 60
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],63
	jbe	short @19@450
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],91
	jae	short @19@450
	jmp	short @19@534
@19@450:
   ;	
   ;	     else if ( name [i] == 46 );
   ;	
	?debug	L 61
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],46
	jne	short @19@506
	jmp	short @19@534
@19@506:
	jmp	@19@58
@19@534:
	?debug	L 56
	inc	byte ptr [bp-1]
@19@562:
	mov	al,byte ptr [bp-1]
	mov	ah,0
	push	ax
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	pop	dx
	cmp	dx,ax
	ja short	@@3
	jmp	@19@198
@@3:
   ;	
   ;	     else return 0;
   ;	    }
   ;	    return 1;
   ;	
	?debug	L 64
	mov	al,1
	jmp	@19@86
@19@618:
   ;	
   ;	   }
   ;	
	?debug	L 65
	pop	si
	leave	
	ret	
	?debug	C E601690802FFFF00046E616D651C0C0600
	?debug	E
	?debug	E
_valid_name	endp
	?debug	C E93A65492706504154482E48
_TEXT	ends
_DATA	segment word public use16 'DATA'
_ACTUAL_DIR	label	word
	db	0
	db	0
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
	?debug	C E80706504154482E483A654927
   ;	
   ;	 ulong path (string s)
   ;	
	?debug	L 17
	assume	cs:_TEXT
_path	proc	near
	?debug	B
	enter	50,0
	push	si
	?debug	C E601731C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  uchar  i;
   ;	  uchar  j;
   ;	  char   Dir [12];
   ;	  ulong  tempDIR;
   ;	  struct file_control_block tempFCB;
   ;	
   ;	  i=0;
   ;	
	?debug	L 25
	mov	byte ptr [bp-1],0
   ;	
   ;	  tempDIR = ACTUAL_DIR;
   ;	
	?debug	L 26
	mov	eax,dword ptr DGROUP:_ACTUAL_DIR
	mov	dword ptr [bp-6],eax
   ;	
   ;	
   ;	  if ( s [strlen(s)-1] == '/') s [strlen (s)-1] = 0;
   ;	
	?debug	L 28
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jne	short @20@86
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	bx,ax
	mov	byte ptr [bx+si],0
@20@86:
   ;	
   ;	
   ;	  if (s[1] == ':') {
   ;	
	?debug	L 30
	cmp	byte ptr [si+1],58
	jne	short @20@310
   ;	
   ;	                    if (s[0]  == 'a') DRIVE =diskA;
   ;	
	?debug	L 31
	cmp	byte ptr [si],97
	jne	short @20@170
	mov	byte ptr DGROUP:_DRIVE,0
	jmp	short @20@282
@20@170:
   ;	
   ;	                    else if (s[0] == 'c') DRIVE =diskC;
   ;	
	?debug	L 32
	cmp	byte ptr [si],99
	jne	short @20@226
	mov	byte ptr DGROUP:_DRIVE,128
	jmp	short @20@282
@20@226:
   ;	
   ;	                    else return 0;
   ;	
	?debug	L 33
	xor	eax,eax
@20@254:
	shld	edx,eax,16
	jmp	@20@898
@20@282:
   ;	
   ;	                    i = 2;
   ;	
	?debug	L 34
	mov	byte ptr [bp-1],2
   ;	
   ;	                    init_disk (DRIVE);
   ;	
	?debug	L 35
	mov	al,byte ptr DGROUP:_DRIVE
	push	ax
	call	near ptr _init_disk
	pop	cx
@20@310:
   ;	
   ;	                   }
   ;	  if (s[i] == '/') {
   ;	
	?debug	L 37
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jne	short @20@366
   ;	
   ;	                    tempDIR = 0;
   ;	
	?debug	L 38
	mov	dword ptr [bp-6],large 0
   ;	
   ;	                    i++;
   ;	
	?debug	L 39
	inc	byte ptr [bp-1]
@20@366:
   ;	
   ;	                   }
   ;	  j = 0;
   ;	
	?debug	L 41
	mov	byte ptr [bp-2],0
@20@394:
   ;	
   ;	  do
   ;	  {
   ;	   if (s[i] == 0) break;
   ;	
	?debug	L 44
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],0
	jne	short @20@450
	jmp	@20@870
@20@450:
   ;	
   ;	
   ;	   if (s[i] == '/') { Dir [j] = 0;
   ;	
	?debug	L 46
	mov	al,byte ptr [bp-1]
	mov	ah,0
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	je short	@@4
	jmp	@20@814
@@4:
	mov	al,byte ptr [bp-2]
	mov	ah,0
	lea	dx,word ptr [bp-18]
	add	ax,dx
	mov	bx,ax
	mov	byte ptr [bx],0
   ;	
   ;	
   ;	                      if (!strcmp (Dir,".")) ;
   ;	
	?debug	L 48
	push	offset DGROUP:s@+28
	lea	ax,word ptr [bp-18]
	push	ax
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @20@534
	jmp	short @20@786
@20@534:
   ;	
   ;	                      else
   ;	                      if ( (!strcmp (Dir,".."))) if (!tempDIR);
   ;	
	?debug	L 50
	push	offset DGROUP:s@+30
	lea	ax,word ptr [bp-18]
	push	ax
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @20@730
	cmp	dword ptr [bp-6],large 0
	jne	short @20@618
	jmp	short @20@702
@20@618:
   ;	
   ;	                                                 else
   ;	                                                      {
   ;	                                                      if (!read_fcb (DRIVE,tempDIR,&tempFCB)) return 0xffffffff;
   ;	
	?debug	L 53
	lea	ax,word ptr [bp-50]
	push	ax
	push	dword ptr [bp-6]
	mov	al,byte ptr DGROUP:_DRIVE
	push	ax
	call	near ptr _read_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @20@674
	jmp	short @20@758
@20@674:
   ;	
   ;	                                                      tempDIR = tempFCB.f_dir_father;
   ;	
	?debug	L 54
	mov	eax,dword ptr [bp-34]
	mov	dword ptr [bp-6],eax
@20@702:
   ;	
   ;	                                                      }
   ;	
	?debug	L 55
	jmp	short @20@786
@20@730:
   ;	
   ;	                      else {
   ;	                            tempDIR = get_fcb (DRIVE,Dir,F_DIR,tempDIR,&tempFCB);
   ;	
	?debug	L 57
	lea	ax,word ptr [bp-50]
	push	ax
	push	dword ptr [bp-6]
	push	10
	lea	ax,word ptr [bp-18]
	push	ax
	mov	al,byte ptr DGROUP:_DRIVE
	push	ax
	call	near ptr _get_fcb
	push	dx
	push	ax
	pop	eax
	add	sp,12
	mov	dword ptr [bp-6],eax
   ;	
   ;	                            if (!tempDIR) return 0xFFFFFFFF;
   ;	
	?debug	L 58
	cmp	dword ptr [bp-6],large 0
	jne	short @20@786
@20@758:
	mov	eax,large -1
	jmp	@20@254
@20@786:
   ;	
   ;	                           }
   ;	
   ;	                      j=0; i++; }
   ;	
	?debug	L 61
	mov	byte ptr [bp-2],0
	inc	byte ptr [bp-1]
@20@814:
   ;	
   ;	
   ;	   Dir [j] = s[i];
   ;	
	?debug	L 63
	mov	al,byte ptr [bp-2]
	mov	ah,0
	lea	dx,word ptr [bp-18]
	add	ax,dx
	mov	dl,byte ptr [bp-1]
	mov	dh,0
	mov	bx,dx
	mov	dl,byte ptr [bx+si]
	mov	bx,ax
	mov	byte ptr [bx],dl
   ;	
   ;	   i++;j++;
   ;	
	?debug	L 64
	inc	byte ptr [bp-1]
	inc	byte ptr [bp-2]
   ;	
   ;	
   ;	  } while (1);
   ;	
	?debug	L 66
	jmp	@20@394
@20@870:
   ;	
   ;	 return tempDIR;
   ;	
	?debug	L 67
	mov	eax,dword ptr [bp-6]
	jmp	@20@254
@20@898:
   ;	
   ;	 }
   ;	
	?debug	L 68
	pop	si
	leave	
	ret	
	?debug	C E31F000C001A02
	?debug	C E60774656D704643421A02CEFF000774656D7044+
	?debug	C 49520C02FAFF00034469721F02EEFF00016A0802+
	?debug	C FEFF0001690802FFFF0001731C0C0600
	?debug	E
	?debug	E
_path	endp
   ;	
   ;	 string extract_filename (string path)
   ;	
	?debug	L 70
	assume	cs:_TEXT
_extract_filename	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E604706174681C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  int i;
   ;	  if ( path [strlen(path)-1] == '/') path [strlen (path)-1] = 0;
   ;	
	?debug	L 73
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	bx,ax
	cmp	byte ptr [bx+si],47
	jne	short @21@86
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	bx,ax
	mov	byte ptr [bx+si],0
@21@86:
   ;	
   ;	  for (i=strlen (path)-1; i >= 0; i--)
   ;	
	?debug	L 74
	push	si
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	di,ax
	jmp	short @21@254
@21@114:
   ;	
   ;	  {
   ;	   if ( (path [i] == '/') || (path [i] == ':') ) return (path+i+1);
   ;	
	?debug	L 76
	mov	bx,di
	cmp	byte ptr [bx+si],47
	je	short @21@170
	mov	bx,di
	cmp	byte ptr [bx+si],58
	jne	short @21@226
@21@170:
	mov	ax,si
	add	ax,di
	inc	ax
@21@198:
	jmp	short @21@310
@21@226:
	?debug	L 74
	dec	di
@21@254:
	or	di,di
	jge	short @21@114
   ;	
   ;	  }
   ;	  return (path) ;
   ;	
	?debug	L 78
	mov	ax,si
	jmp	short @21@198
@21@310:
   ;	
   ;	 }
   ;	
	?debug	L 79
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E601690404070004706174681C0C0600
	?debug	E
	?debug	E
_extract_filename	endp
	?debug	C E9CF812127054449522E48
	?debug	C E808054449522E48CF812127
   ;	
   ;	 bool mkdir (string dir)
   ;	
	?debug	L 11
	assume	cs:_TEXT
_mkdir	proc	near
	?debug	B
	enter	10,0
	push	si
	?debug	C E6036469721C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  bool ret;
   ;	  ulong dir_father;
   ;	  ulong tempDRIVE;
   ;	
   ;	  if (!valid_name (extract_filename (dir))) return 0;
   ;	
	?debug	L 17
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	call	near ptr _valid_name
	pop	cx
	mov	ah,0
	or	ax,ax
	jne	short @22@114
@22@58:
	mov	al,0
@22@86:
	jmp	short @22@198
@22@114:
   ;	
   ;	  tempDRIVE = DRIVE;
   ;	
	?debug	L 18
	mov	al,byte ptr DGROUP:_DRIVE
	mov	ah,0
	movsx	eax,ax
	mov	dword ptr [bp-10],eax
   ;	
   ;	  dir_father = path (dir);
   ;	
	?debug	L 19
	push	si
	call	near ptr _path
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-6],eax
   ;	
   ;	  DRIVE = tempDRIVE;
   ;	
	?debug	L 20
	mov	al,byte ptr [bp-10]
	mov	byte ptr DGROUP:_DRIVE,al
   ;	
   ;	  if (dir_father == 0xffffffff) return 0;
   ;	
	?debug	L 21
	cmp	dword ptr [bp-6],large -1
	jne	short @22@170
	jmp	short @22@58
@22@170:
   ;	
   ;	  ret = create (extract_filename (dir),F_DIR,tempDRIVE,dir_father);
   ;	
	?debug	L 22
	push	dword ptr [bp-6]
	mov	al,byte ptr [bp-10]
	push	ax
	push	10
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	call	near ptr _create
	add	sp,10
	mov	byte ptr [bp-1],al
   ;	
   ;	  return ret;
   ;	
	?debug	L 23
	mov	al,byte ptr [bp-1]
	jmp	short @22@86
@22@198:
   ;	
   ;	 }
   ;	
	?debug	L 24
	pop	si
	leave	
	ret	
	?debug	C E60974656D7044524956450C02F6FF000A646972+
	?debug	C 5F6661746865720C02FAFF00037265740802FFFF+
	?debug	C 00036469721C0C0600
	?debug	E
	?debug	E
_mkdir	endp
   ;	
   ;	 bool rmdir (string dir)
   ;	
	?debug	L 27
	assume	cs:_TEXT
_rmdir	proc	near
	?debug	B
	enter	44,0
	push	si
	?debug	C E6036469721C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  ulong dir_father;
   ;	  ulong tempDRIVE;
   ;	  ulong addr;
   ;	  struct file_control_block tempFCB;
   ;	
   ;	  tempDRIVE = DRIVE;
   ;	
	?debug	L 34
	mov	al,byte ptr DGROUP:_DRIVE
	mov	ah,0
	movsx	eax,ax
	mov	dword ptr [bp-8],eax
   ;	
   ;	  dir_father = path (dir);
   ;	
	?debug	L 35
	push	si
	call	near ptr _path
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-4],eax
   ;	
   ;	  DRIVE = tempDRIVE;
   ;	
	?debug	L 36
	mov	al,byte ptr [bp-8]
	mov	byte ptr DGROUP:_DRIVE,al
   ;	
   ;	  if (dir_father == 0xffffffff) return 0;
   ;	
	?debug	L 37
	cmp	dword ptr [bp-4],large -1
	jne	short @23@114
@23@58:
	mov	al,0
@23@86:
	jmp	short @23@254
@23@114:
   ;	
   ;	  addr = get_fcb (tempDRIVE,extract_filename (dir),F_DIR,dir_father,&tempFCB);
   ;	
	?debug	L 38
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp-4]
	push	10
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _get_fcb
	push	dx
	push	ax
	pop	eax
	add	sp,12
	mov	dword ptr [bp-12],eax
   ;	
   ;	  if (!addr) return 0;
   ;	
	?debug	L 39
	cmp	dword ptr [bp-12],large 0
	jne	short @23@170
	jmp	short @23@58
@23@170:
   ;	
   ;	  tempFCB.f_name [0] = 0;
   ;	
	?debug	L 40
	mov	byte ptr [bp-44],0
   ;	
   ;	  if (!set_fcb (tempDRIVE,addr,&tempFCB)) return 0;
   ;	
	?debug	L 41
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp-12]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @23@226
	jmp	short @23@58
@23@226:
   ;	
   ;	  return 1;
   ;	
	?debug	L 42
	mov	al,1
	jmp	short @23@86
@23@254:
   ;	
   ;	
   ;	 }
   ;	
	?debug	L 44
	pop	si
	leave	
	ret	
	?debug	C E60774656D704643421A02D4FF0004616464720C+
	?debug	C 02F4FF000974656D7044524956450C02F8FF000A+
	?debug	C 6469725F6661746865720C02FCFF00036469721C+
	?debug	C 0C0600
	?debug	E
	?debug	E
_rmdir	endp
	?debug	C E9796449270646494C452E48
	?debug	C E8090646494C452E4879644927
   ;	
   ;	 ulong f_create (string s)
   ;	
	?debug	L 11
	assume	cs:_TEXT
_f_create	proc	near
	?debug	B
	enter	8,0
	push	si
	?debug	C E601731C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  ulong handle;
   ;	  ulong tempDRIVE;
   ;	
   ;	  //struct file_control_block tempFCB;
   ;	
   ;	  if ( !valid_name ( extract_filename (s) ) ) return 0;
   ;	
	?debug	L 18
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	call	near ptr _valid_name
	pop	cx
	mov	ah,0
	or	ax,ax
	jne	short @24@114
	xor	eax,eax
@24@86:
	shld	edx,eax,16
	jmp	short @24@226
@24@114:
   ;	
   ;	  tempDRIVE = DRIVE;
   ;	
	?debug	L 19
	mov	al,byte ptr DGROUP:_DRIVE
	mov	ah,0
	movsx	eax,ax
	mov	dword ptr [bp-8],eax
   ;	
   ;	  path (s);
   ;	
	?debug	L 20
	push	si
	call	near ptr _path
	pop	cx
   ;	
   ;	  handle = create ( extract_filename (s), F_ARCH, DRIVE, path (s) );
   ;	
	?debug	L 21
	push	si
	call	near ptr _path
	pop	cx
	push	dx
	push	ax
	mov	al,byte ptr DGROUP:_DRIVE
	push	ax
	push	11
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	call	near ptr _create
	push	dx
	push	ax
	pop	eax
	add	sp,10
	mov	dword ptr [bp-4],eax
   ;	
   ;	  handle = (handle<<1);
   ;	
	?debug	L 22
	mov	eax,dword ptr [bp-4]
	shl	eax,1
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	  if (DRIVE==diskA);
   ;	
	?debug	L 24
	cmp	byte ptr DGROUP:_DRIVE,0
	jne	short @24@142
@24@142:
   ;	
   ;	  if (DRIVE==diskC) handle |= 1; 
   ;	
	?debug	L 25
	cmp	byte ptr DGROUP:_DRIVE,128
	jne	short @24@198
	or	dword ptr [bp-4],large 1
@24@198:
   ;	
   ;	
   ;	  DRIVE = tempDRIVE;
   ;	
	?debug	L 27
	mov	al,byte ptr [bp-8]
	mov	byte ptr DGROUP:_DRIVE,al
   ;	
   ;	
   ;	  return handle; /*fcluster;*/
   ;	
	?debug	L 29
	mov	eax,dword ptr [bp-4]
	jmp	short @24@86
@24@226:
   ;	
   ;	 }
   ;	
	?debug	L 30
	pop	si
	leave	
	ret	
	?debug	C E60974656D7044524956450C02F8FF000668616E+
	?debug	C 646C650C02FCFF0001731C0C0600
	?debug	E
	?debug	E
_f_create	endp
   ;	
   ;	 ulong f_open (string s)
   ;	
	?debug	L 33
	assume	cs:_TEXT
_f_open	proc	near
	?debug	B
	enter	40,0
	push	si
	?debug	C E601731C0A040000
	mov	si,word ptr [bp+4]
	?debug	B
   ;	
   ;	 {
   ;	  ulong handle;
   ;	  ulong tempDRIVE;
   ;	  struct file_control_block tempFCB;
   ;	
   ;	  tempDRIVE = DRIVE;
   ;	
	?debug	L 39
	mov	al,byte ptr DGROUP:_DRIVE
	mov	ah,0
	movsx	eax,ax
	mov	dword ptr [bp-8],eax
   ;	
   ;	  path (s);
   ;	
	?debug	L 40
	push	si
	call	near ptr _path
	pop	cx
   ;	
   ;	  handle = get_fcb (DRIVE,extract_filename (s),F_ARCH,path (s),&tempFCB);
   ;	
	?debug	L 41
	lea	ax,word ptr [bp-40]
	push	ax
	push	si
	call	near ptr _path
	pop	cx
	push	dx
	push	ax
	push	11
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	mov	al,byte ptr DGROUP:_DRIVE
	push	ax
	call	near ptr _get_fcb
	push	dx
	push	ax
	pop	eax
	add	sp,12
	mov	dword ptr [bp-4],eax
   ;	
   ;	  printf ("\n%s\n",extract_filename (s));
   ;	
	?debug	L 42
	push	si
	call	near ptr _extract_filename
	pop	cx
	push	ax
	push	offset DGROUP:s@+33
	call	near ptr _printf
	add	sp,4
   ;	
   ;	
   ;	  handle = (handle<<1);
   ;	
	?debug	L 44
	mov	eax,dword ptr [bp-4]
	shl	eax,1
	mov	dword ptr [bp-4],eax
   ;	
   ;	  if (DRIVE==diskA);
   ;	
	?debug	L 45
	cmp	byte ptr DGROUP:_DRIVE,0
	jne	short @25@58
@25@58:
   ;	
   ;	  if (DRIVE==diskC) handle |= 1;
   ;	
	?debug	L 46
	cmp	byte ptr DGROUP:_DRIVE,128
	jne	short @25@114
	or	dword ptr [bp-4],large 1
@25@114:
   ;	
   ;	
   ;	  DRIVE = tempDRIVE;
   ;	
	?debug	L 48
	mov	al,byte ptr [bp-8]
	mov	byte ptr DGROUP:_DRIVE,al
   ;	
   ;	
   ;	  return handle;
   ;	
	?debug	L 50
	mov	eax,dword ptr [bp-4]
	shld	edx,eax,16
	jmp	short @25@142
@25@142:
   ;	
   ;	 }
   ;	
	?debug	L 51
	pop	si
	leave	
	ret	
	?debug	C E60774656D704643421A02D8FF000974656D7044+
	?debug	C 524956450C02F8FF000668616E646C650C02FCFF+
	?debug	C 0001731C0C0600
	?debug	E
	?debug	E
_f_open	endp
   ;	
   ;	 ulong f_size (ulong handle)
   ;	
	?debug	L 53
	assume	cs:_TEXT
_f_size	proc	near
	?debug	B
	enter	36,0
	?debug	C E60668616E646C650C0A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong tempDRIVE;
   ;	  struct file_control_block tempFCB;
   ;	
   ;	  if ( (handle & 1) == 1) tempDRIVE = diskC;
   ;	
	?debug	L 58
	mov	eax,dword ptr [bp+4]
	and	eax,large 1
	cmp	eax,large 1
	jne	short @26@86
	mov	dword ptr [bp-4],large 128
	jmp	short @26@114
@26@86:
   ;	
   ;	  else tempDRIVE = diskA;
   ;	
	?debug	L 59
	mov	dword ptr [bp-4],large 0
@26@114:
   ;	
   ;	  handle = (handle >> 1);
   ;	
	?debug	L 60
	mov	eax,dword ptr [bp+4]
	shr	eax,1
	mov	dword ptr [bp+4],eax
   ;	
   ;	
   ;	  if (!read_fcb (tempDRIVE,handle,&tempFCB)) return 0;
   ;	
	?debug	L 62
	lea	ax,word ptr [bp-36]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-4]
	push	ax
	call	near ptr _read_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @26@198
	xor	eax,eax
@26@170:
	shld	edx,eax,16
	jmp	short @26@226
@26@198:
   ;	
   ;	  return (tempFCB.f_size);
   ;	
	?debug	L 63
	mov	eax,dword ptr [bp-24]
	jmp	short @26@170
@26@226:
   ;	
   ;	 }
   ;	
	?debug	L 64
	leave	
	ret	
	?debug	C E60774656D704643421A02DCFF000974656D7044+
	?debug	C 524956450C02FCFF000668616E646C650C0A0400+
	?debug	C 00
	?debug	E
	?debug	E
_f_size	endp
   ;	
   ;	 bool f_read (ulong handle, ulong size, uint seg, uint ofs)
   ;	
	?debug	L 67
	assume	cs:_TEXT
_f_read	proc	near
	?debug	B
	enter	44,0
	push	si
	?debug	C E6036F66730A0A0E0000037365670A0A0C000004+
	?debug	C 73697A650C0A0800000668616E646C650C0A0400+
	?debug	C 00
	mov	si,word ptr [bp+14]
	?debug	B
   ;	
   ;	 {
   ;	  ulong w_cluster;
   ;	  ulong tempDRIVE;
   ;	  struct file_control_block tempFCB;
   ;	  ulong i=0;
   ;	
	?debug	L 72
	mov	dword ptr [bp-12],large 0
   ;	
   ;	
   ;	  if ( (handle & 1) == 1) tempDRIVE = diskC;
   ;	
	?debug	L 74
	mov	eax,dword ptr [bp+4]
	and	eax,large 1
	cmp	eax,large 1
	jne	short @27@86
	mov	dword ptr [bp-8],large 128
	jmp	short @27@114
@27@86:
   ;	
   ;	  else tempDRIVE = diskA;
   ;	
	?debug	L 75
	mov	dword ptr [bp-8],large 0
@27@114:
   ;	
   ;	  handle = (handle >> 1);
   ;	
	?debug	L 76
	mov	eax,dword ptr [bp+4]
	shr	eax,1
	mov	dword ptr [bp+4],eax
   ;	
   ;	
   ;	  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
   ;	
	?debug	L 78
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _read_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @27@198
@27@142:
	mov	al,0
@27@170:
	jmp	@27@506
@27@198:
   ;	
   ;	  w_cluster = tempFCB.f_cluster;
   ;	
	?debug	L 79
	mov	eax,dword ptr [bp-16]
	mov	dword ptr [bp-4],eax
@27@226:
   ;	
   ;	
   ;	  do {
   ;	
   ;	      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint)
   ;	
	?debug	L 83
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr DGROUP:_disk_state+8
	shr	eax,9
	mov	edx,dword ptr [bp-4]
	add	edx,eax
	add	edx,large 219
	push	edx
	push	1
	push	2
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @27@282
	jmp	short @27@142
@27@282:
   ;	
   ;	      if (size > (CLUSTER_SIZE-4) )
   ;	
	?debug	L 84
	cmp	dword ptr [bp+8],large 508
	jbe	short @27@338
   ;	
   ;		   memcpy ((void*)(ofs+i),&fcb,CLUSTER_SIZE-4);
   ;	
	?debug	L 85
	push	508
	push	offset DGROUP:_fcb
	movzx	eax,si
	add	eax,dword ptr [bp-12]
	push	ax
	call	near ptr _memcpy
	add	sp,6
	jmp	short @27@366
@27@338:
   ;	
   ;	      else  {
   ;		     memcpy ((void*)(ofs+i),&fcb,size);
   ;	
	?debug	L 87
	push	word ptr [bp+8]
	push	offset DGROUP:_fcb
	movzx	eax,si
	add	eax,dword ptr [bp-12]
	push	ax
	call	near ptr _memcpy
	add	sp,6
   ;	
   ;		     break;
   ;	
	?debug	L 88
	jmp	short @27@478
@27@366:
   ;	
   ;		    }
   ;	      w_cluster = fcb [FCB_PER_SECTOR-1].f_cluster;
   ;	
	?debug	L 90
	mov	eax,dword ptr DGROUP:_fcb+508
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	      printf ("\nw_cluster: %d",w_cluster);
   ;	
	?debug	L 92
	push	dword ptr [bp-4]
	push	offset DGROUP:s@+38
	call	near ptr _printf
	add	sp,6
   ;	
   ;	
   ;	      if (fcb [FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
   ;	
	?debug	L 94
	cmp	dword ptr DGROUP:_fcb+508,large -1
	jne	short @27@422
	jmp	short @27@478
@27@422:
   ;	
   ;	      size -= CLUSTER_SIZE -4;
   ;	
	?debug	L 95
	sub	dword ptr [bp+8],large 508
   ;	
   ;	      i += CLUSTER_SIZE -4;
   ;	
	?debug	L 96
	add	dword ptr [bp-12],large 508
   ;	
   ;	
   ;	     } while (1);
   ;	
	?debug	L 98
	jmp	@27@226
@27@478:
   ;	
   ;	  return 1;
   ;	
	?debug	L 99
	mov	al,1
	jmp	@27@170
@27@506:
   ;	
   ;	 }
   ;	
	?debug	L 100
	pop	si
	leave	
	ret	
	?debug	C E601690C02F4FF000774656D704643421A02D4FF+
	?debug	C 000974656D7044524956450C02F8FF0009775F63+
	?debug	C 6C75737465720C02FCFF000668616E646C650C0A+
	?debug	C 0400000473697A650C0A080000037365670A0A0C+
	?debug	C 0000036F66730A0C0600
	?debug	E
	?debug	E
_f_read	endp
   ;	
   ;	 bool f_remove (ulong handle)
   ;	
	?debug	L 102
	assume	cs:_TEXT
_f_remove	proc	near
	?debug	B
	enter	40,0
	?debug	C E60668616E646C650C0A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong w_cluster;
   ;	  ulong tempDRIVE;
   ;	  struct file_control_block tempFCB;
   ;	
   ;	  if ( (handle & 1) == 1) tempDRIVE = diskC;
   ;	
	?debug	L 108
	mov	eax,dword ptr [bp+4]
	and	eax,large 1
	cmp	eax,large 1
	jne	short @28@86
	mov	dword ptr [bp-8],large 128
	jmp	short @28@114
@28@86:
   ;	
   ;	  else tempDRIVE = diskA;
   ;	
	?debug	L 109
	mov	dword ptr [bp-8],large 0
@28@114:
   ;	
   ;	  handle = (handle >> 1);
   ;	
	?debug	L 110
	mov	eax,dword ptr [bp+4]
	shr	eax,1
	mov	dword ptr [bp+4],eax
   ;	
   ;	
   ;	  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
   ;	
	?debug	L 112
	lea	ax,word ptr [bp-40]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _read_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @28@198
@28@142:
	mov	al,0
@28@170:
	jmp	@28@422
@28@198:
   ;	
   ;	  w_cluster = tempFCB.f_cluster;
   ;	
	?debug	L 113
	mov	eax,dword ptr [bp-12]
	mov	dword ptr [bp-4],eax
   ;	
   ;	
   ;	  set_cluster (tempDRIVE,w_cluster,0);
   ;	
	?debug	L 115
	push	0
	push	dword ptr [bp-4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_cluster
	add	sp,8
   ;	
   ;	
   ;	  tempFCB.f_name [0] = 0;
   ;	
	?debug	L 117
	mov	byte ptr [bp-40],0
   ;	
   ;	  set_fcb (tempDRIVE,handle,&tempFCB);
   ;	
	?debug	L 118
	lea	ax,word ptr [bp-40]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_fcb
	add	sp,8
@28@226:
   ;	
   ;	
   ;	  do {
   ;	      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint)
   ;	
	?debug	L 121
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr DGROUP:_disk_state+8
	shr	eax,9
	mov	edx,dword ptr [bp-4]
	add	edx,eax
	add	edx,large 219
	push	edx
	push	1
	push	2
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @28@282
	jmp	short @28@142
@28@282:
   ;	
   ;	      if (fcb[FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
   ;	
	?debug	L 122
	cmp	dword ptr DGROUP:_fcb+508,large -1
	jne	short @28@338
	jmp	short @28@394
@28@338:
   ;	
   ;	      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
   ;	
	?debug	L 123
	mov	eax,dword ptr DGROUP:_fcb+508
	mov	dword ptr [bp-4],eax
   ;	
   ;	      set_cluster (tempDRIVE,w_cluster,0);
   ;	
	?debug	L 124
	push	0
	push	dword ptr [bp-4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_cluster
	add	sp,8
   ;	
   ;	
   ;	     } while (1);
   ;	
	?debug	L 126
	jmp	short @28@226
@28@394:
   ;	
   ;	  dec_fcb_count (tempDRIVE);
   ;	
	?debug	L 127
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _dec_fcb_count
	pop	cx
   ;	
   ;	  return 1;
   ;	
	?debug	L 128
	mov	al,1
	jmp	@28@170
@28@422:
   ;	
   ;	 }
   ;	
	?debug	L 129
	leave	
	ret	
	?debug	C E60774656D704643421A02D8FF000974656D7044+
	?debug	C 524956450C02F8FF0009775F636C75737465720C+
	?debug	C 02FCFF000668616E646C650C0A040000
	?debug	E
	?debug	E
_f_remove	endp
   ;	
   ;	 bool f_write (ulong handle, ulong size, uint seg, uint ofs)
   ;	
	?debug	L 131
	assume	cs:_TEXT
_f_write	proc	near
	?debug	B
	enter	44,0
	?debug	C E6036F66730A0A0E0000037365670A0A0C000004+
	?debug	C 73697A650C0A0800000668616E646C650C0A0400+
	?debug	C 00
	?debug	B
   ;	
   ;	 {
   ;	  ulong w_cluster;
   ;	  ulong tempDRIVE;
   ;	  struct file_control_block tempFCB;
   ;	  ulong i=0;
   ;	
	?debug	L 136
	mov	dword ptr [bp-12],large 0
   ;	
   ;	
   ;	  if ( (handle & 1) == 1) tempDRIVE = diskC;
   ;	
	?debug	L 138
	mov	eax,dword ptr [bp+4]
	and	eax,large 1
	cmp	eax,large 1
	jne	short @29@86
	mov	dword ptr [bp-8],large 128
	jmp	short @29@114
@29@86:
   ;	
   ;	  else tempDRIVE = diskA;
   ;	
	?debug	L 139
	mov	dword ptr [bp-8],large 0
@29@114:
   ;	
   ;	  handle = (handle >> 1);
   ;	
	?debug	L 140
	mov	eax,dword ptr [bp+4]
	shr	eax,1
	mov	dword ptr [bp+4],eax
   ;	
   ;	
   ;	  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
   ;	
	?debug	L 142
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _read_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @29@198
@29@142:
	mov	al,0
@29@170:
	jmp	@29@562
@29@198:
   ;	
   ;	  w_cluster = tempFCB.f_cluster;
   ;	
	?debug	L 143
	mov	eax,dword ptr [bp-16]
	mov	dword ptr [bp-4],eax
   ;	
   ;	  tempFCB.f_size = size;
   ;	
	?debug	L 144
	mov	eax,dword ptr [bp+8]
	mov	dword ptr [bp-32],eax
   ;	
   ;	  if (!set_fcb (tempDRIVE,handle,&tempFCB) ) return 0;
   ;	
	?debug	L 145
	lea	ax,word ptr [bp-44]
	push	ax
	push	dword ptr [bp+4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_fcb
	add	sp,8
	mov	ah,0
	or	ax,ax
	jne	short @29@254
	jmp	short @29@142
@29@254:
   ;	
   ;	
   ;	  set_cluster (tempDRIVE,w_cluster,1);
   ;	
	?debug	L 147
	push	1
	push	dword ptr [bp-4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_cluster
	add	sp,8
@29@282:
   ;	
   ;	
   ;	  do {
   ;	
   ;	/* !! */
   ;	      memcpy (&fcb,(void*)(ofs+i),CLUSTER_SIZE-4);
   ;	
	?debug	L 152
	push	508
	movzx	eax,word ptr [bp+14]
	add	eax,dword ptr [bp-12]
	push	ax
	push	offset DGROUP:_fcb
	call	near ptr _memcpy
	add	sp,6
   ;	
   ;	      i += CLUSTER_SIZE-4;
   ;	
	?debug	L 153
	add	dword ptr [bp-12],large 508
   ;	
   ;	
   ;	      set_cluster (tempDRIVE,w_cluster,1);
   ;	
	?debug	L 155
	push	1
	push	dword ptr [bp-4]
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _set_cluster
	add	sp,8
   ;	
   ;	      if ( i >= size) fcb[FCB_PER_SECTOR-1].f_cluster = 0xffffffff;
   ;	
	?debug	L 156
	mov	eax,dword ptr [bp-12]
	cmp	eax,dword ptr [bp+8]
	jb	short @29@338
	mov	dword ptr DGROUP:_fcb+508,large -1
	jmp	short @29@394
@29@338:
   ;	
   ;	      else {
   ;		     fcb[FCB_PER_SECTOR-1].f_cluster = get_cluster_free (tempDRIVE);
   ;	
	?debug	L 158
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _get_cluster_free
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_fcb+508,eax
   ;	
   ;		     if (!fcb[FCB_PER_SECTOR-1].f_cluster) return 0;
   ;	
	?debug	L 159
	cmp	dword ptr DGROUP:_fcb+508,large 0
	jne	short @29@394
	jmp	@29@142
@29@394:
   ;	
   ;	
   ;		   }
   ;	      printf ("\ncluster: %d",w_cluster);
   ;	
	?debug	L 162
	push	dword ptr [bp-4]
	push	offset DGROUP:s@+53
	call	near ptr _printf
	add	sp,6
   ;	
   ;	
   ;	      if (absolute_disk_access (tempDRIVE,DISK_WRITE,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint
   ;	
	?debug	L 164
	push	offset DGROUP:_fcb
	push	ds
	mov	eax,dword ptr DGROUP:_disk_state+8
	shr	eax,9
	mov	edx,dword ptr [bp-4]
	add	edx,eax
	add	edx,large 219
	push	edx
	push	1
	push	3
	mov	al,byte ptr [bp-8]
	push	ax
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @29@450
	jmp	@29@142
@29@450:
   ;	
   ;	      printf ("\nsector: %u",w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9));
   ;	
	?debug	L 165
	mov	eax,dword ptr DGROUP:_disk_state+8
	shr	eax,9
	mov	edx,dword ptr [bp-4]
	add	edx,eax
	add	edx,large 219
	push	edx
	push	offset DGROUP:s@+66
	call	near ptr _printf
	add	sp,6
   ;	
   ;	
   ;	      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
   ;	
	?debug	L 167
	mov	eax,dword ptr DGROUP:_fcb+508
	mov	dword ptr [bp-4],eax
   ;	
   ;	      if ( i >= size ) break;
   ;	
	?debug	L 168
	mov	eax,dword ptr [bp-12]
	cmp	eax,dword ptr [bp+8]
	jb	short @29@506
	jmp	short @29@534
@29@506:
   ;	
   ;	
   ;	     } while (1);
   ;	
	?debug	L 170
	jmp	@29@282
@29@534:
   ;	
   ;	
   ;	  return 1;
   ;	
	?debug	L 172
	mov	al,1
	jmp	@29@170
@29@562:
   ;	
   ;	 }
   ;	
	?debug	L 173
	leave	
	ret	
	?debug	C E601690C02F4FF000774656D704643421A02D4FF+
	?debug	C 000974656D7044524956450C02F8FF0009775F63+
	?debug	C 6C75737465720C02FCFF000668616E646C650C0A+
	?debug	C 0400000473697A650C0A080000037365670A0A0C+
	?debug	C 0000036F66730A0A0E0000
	?debug	E
	?debug	E
_f_write	endp
	?debug	C E96C7A1C270854494E5946532E48
_TEXT	ends
_DATA	segment word public use16 'DATA'
_cluster	label	byte
	db	0
	db	511 dup (0)
_DATA	ends
_TEXT	segment byte public use16 'CODE'
	?debug	C E8010854494E5946532E43F38E8327
   ;	
   ;	 void dir (string pt)
   ;	
	?debug	L 46
	assume	cs:_TEXT
_dir	proc	near
	?debug	B
	enter	20,0
	push	si
	?debug	C E60270741C0A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong i;
   ;	  ulong j;
   ;	  ulong _dir;
   ;	  ulong fcb_count;
   ;	  ulong counter=1;
   ;	
	?debug	L 52
	mov	dword ptr [bp-20],large 1
   ;	
   ;	  int quit=0;
   ;	
	?debug	L 53
	xor	si,si
   ;	
   ;	
   ;	   _dir = ACTUAL_DIR;
   ;	
	?debug	L 55
	mov	eax,dword ptr DGROUP:_ACTUAL_DIR
	mov	dword ptr [bp-12],eax
   ;	
   ;	   fcb_count = get_fcb_count (0);
   ;	
	?debug	L 56
	push	0
	call	near ptr _get_fcb_count
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr [bp-16],eax
   ;	
   ;	
   ;	  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
   ;	
	?debug	L 58
	mov	dword ptr [bp-4],large 18
	jmp	@30@450
@30@58:
   ;	
   ;	   {
   ;	    absolute_disk_access (0,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb);
   ;	
	?debug	L 60
	push	offset DGROUP:_fcb
	push	ds
	push	dword ptr [bp-4]
	push	1
	push	2
	push	0
	call	near ptr _absolute_disk_access
	add	sp,14
   ;	
   ;	    for (j=1;j <= (FCB_PER_SECTOR-1); j++)
   ;	
	?debug	L 61
	mov	dword ptr [bp-8],large 1
	jmp	short @30@338
@30@86:
   ;	
   ;	    {
   ;	     //if ( (((i-FCB_ADDR_BEGIN)<<4)+j) > fcb_count ) goto ending;
   ;	     if (counter == fcb_count) {quit=1; break;}
   ;	
	?debug	L 64
	mov	eax,dword ptr [bp-20]
	cmp	eax,dword ptr [bp-16]
	jne	short @30@142
	mov	si,1
	jmp	short @30@366
@30@142:
   ;	
   ;	     if (fcb[j].f_name[0]!=0)
   ;	
	?debug	L 65
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr DGROUP:_fcb[bx],0
	je	short @30@310
   ;	
   ;	      {
   ;	       counter++;
   ;	
	?debug	L 67
	inc	dword ptr [bp-20]
   ;	
   ;	       if (fcb[j].f_dir_father==_dir) { printf ("\n%12s   %c    %5d   y%d",fcb[j].f_name,(fcb[j].f_attr==F_DIR) ? 'D' : 'A',fcb[
   ;	
	?debug	L 68
	mov	bx,word ptr [bp-8]
	shl	bx,5
	mov	eax,dword ptr DGROUP:_fcb[bx+16]
	cmp	eax,dword ptr [bp-12]
	jne	short @30@310
	mov	bx,word ptr [bp-8]
	shl	bx,5
	push	word ptr DGROUP:_fcb[bx+22]
	mov	bx,word ptr [bp-8]
	shl	bx,5
	push	dword ptr DGROUP:_fcb[bx+12]
	mov	bx,word ptr [bp-8]
	shl	bx,5
	cmp	byte ptr DGROUP:_fcb[bx+26],10
	jne	short @30@254
	mov	ax,68
	jmp	short @30@282
@30@254:
	mov	ax,65
@30@282:
	push	ax
	mov	ax,word ptr [bp-8]
	shl	ax,5
	add	ax,offset DGROUP:_fcb
	push	ax
	push	offset DGROUP:s@+78
	call	near ptr _printf
	add	sp,12
@30@310:
	?debug	L 61
	inc	dword ptr [bp-8]
@30@338:
	cmp	dword ptr [bp-8],large 15
	ja short	@@5
	jmp	@30@86
@@5:
@30@366:
   ;	
   ;	      }
   ;	    }
   ;	   if (quit) break;
   ;	
	?debug	L 71
	or	si,si
	je	short @30@422
	jmp	short @30@478
@30@422:
	?debug	L 58
	inc	dword ptr [bp-4]
@30@450:
	cmp	dword ptr [bp-4],large 218
	ja short	@@6
	jmp	@30@58
@@6:
@30@478:
   ;	
   ;	   }
   ;	 ending:
   ;	 printf ("\n");
   ;	
	?debug	L 74
	push	offset DGROUP:s@+102
	call	near ptr _printf
	pop	cx
   ;	
   ;	 }
   ;	
	?debug	L 75
	pop	si
	leave	
	ret	
	?debug	C E604717569740404060007636F756E7465720C02+
	?debug	C ECFF00096663625F636F756E740C02F0FF00045F+
	?debug	C 6469720C02F4FF00016A0C02F8FF0001690C02FC+
	?debug	C FF000270741C0A040000
	?debug	E
	?debug	E
_dir	endp
   ;	
   ;	 void format (uchar d)
   ;	
	?debug	L 77
	assume	cs:_TEXT
_format	proc	near
	?debug	B
	enter	4,0
	?debug	C E60164080A040000
	?debug	B
   ;	
   ;	 {
   ;	  ulong i;
   ;	  if (reset_disk (d)) { printf ("\nreset_disk () error %d!\n",reset_disk(d));
   ;	
	?debug	L 80
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _reset_disk
	pop	cx
	or	al,al
	je	short @31@86
	mov	al,byte ptr [bp+4]
	push	ax
	call	near ptr _reset_disk
	pop	cx
	mov	ah,0
	push	ax
	push	offset DGROUP:s@+104
	call	near ptr _printf
	add	sp,4
   ;	
   ;				 return;
   ;	
	?debug	L 81
	jmp	short @31@254
@31@86:
   ;	
   ;			       }
   ;	  printf ("\nreset_disk () Ok");
   ;	
	?debug	L 83
	push	offset DGROUP:s@+130
	call	near ptr _printf
	pop	cx
   ;	
   ;	
   ;	  for (i=0;i<=disk_state.max_addr;i++)
   ;	
	?debug	L 85
	mov	dword ptr [bp-4],large 0
	jmp	short @31@198
@31@114:
   ;	
   ;	   {
   ;	   printf ("%4d.",i);
   ;	
	?debug	L 87
	push	dword ptr [bp-4]
	push	offset DGROUP:s@+148
	call	near ptr _printf
	add	sp,6
   ;	
   ;	     if (absolute_disk_access (0,DISK_WRITE,1,i,FP_SEG(cluster),FP_OFF(cluster)))
   ;	
	?debug	L 88
	push	offset DGROUP:_cluster
	push	ds
	push	dword ptr [bp-4]
	push	1
	push	3
	push	0
	call	near ptr _absolute_disk_access
	add	sp,14
	or	al,al
	je	short @31@170
   ;	
   ;	     { printf ("\nerror at %d",i); return; }
   ;	
	?debug	L 89
	push	dword ptr [bp-4]
	push	offset DGROUP:s@+153
	call	near ptr _printf
	add	sp,6
	jmp	short @31@254
@31@170:
	?debug	L 85
	inc	dword ptr [bp-4]
@31@198:
	mov	eax,dword ptr [bp-4]
	cmp	eax,dword ptr DGROUP:_disk_state+4
	jbe	short @31@114
   ;	
   ;	   }
   ;	
   ;	  printf ("\nformat () Ok\n");
   ;	
	?debug	L 92
	push	offset DGROUP:s@+166
	call	near ptr _printf
	pop	cx
@31@254:
   ;	
   ;	 }
   ;	
	?debug	L 93
	leave	
	ret	
	?debug	C E601690C02FCFF000164080A040000
	?debug	E
	?debug	E
_format	endp
   ;	
   ;	 void main (int argc, char* argv[])
   ;	
	?debug	L 98
	assume	cs:_TEXT
_main	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E321000200150204
	?debug	C E320000200152104
	?debug	C E60461726776200A0600000461726763040A0400+
	?debug	C 00
	mov	si,word ptr [bp+4]
	mov	di,word ptr [bp+6]
	?debug	B
   ;	
   ;	 {
   ;	
   ;	  printf ("\ntinyfs.exe");
   ;	
	?debug	L 101
	push	offset DGROUP:s@+181
	call	near ptr _printf
	pop	cx
   ;	
   ;	  printf ("\ntype 'exit' to quit\n");
   ;	
	?debug	L 102
	push	offset DGROUP:s@+193
	call	near ptr _printf
	pop	cx
   ;	
   ;	  init_disk (0);
   ;	
	?debug	L 103
	push	0
	call	near ptr _init_disk
	pop	cx
   ;	
   ;	
   ;	  strcpy (prompt,"a:/"); 
   ;	
	?debug	L 105
	push	offset DGROUP:s@+215
	push	offset DGROUP:_prompt
	call	near ptr _strcpy
	add	sp,4
@32@58:
   ;	
   ;	  do {
   ;		printf ("\n%s",prompt);
   ;	
	?debug	L 107
	push	offset DGROUP:_prompt
	push	offset DGROUP:s@+219
	call	near ptr _printf
	add	sp,4
   ;	
   ;		if (argc > 1) strcpy (cmd,argv[1]);
   ;	
	?debug	L 108
	cmp	si,1
	jle	short @32@114
	push	word ptr [di+2]
	push	offset DGROUP:_cmd
	call	near ptr _strcpy
	add	sp,4
	jmp	short @32@142
@32@114:
   ;	
   ;		else gets (cmd);
   ;	
	?debug	L 109
	push	offset DGROUP:_cmd
	call	near ptr _gets
	pop	cx
@32@142:
   ;	
   ;		sscanf (cmd,"%s %s %s",cmd1,cmd2,cmd3);
   ;	
	?debug	L 110
	push	offset DGROUP:_cmd3
	push	offset DGROUP:_cmd2
	push	offset DGROUP:_cmd1
	push	offset DGROUP:s@+223
	push	offset DGROUP:_cmd
	call	near ptr _sscanf
	add	sp,10
   ;	
   ;	
   ;		if (!strcmp (cmd1,"ls")) dir (cmd2);
   ;	
	?debug	L 112
	push	offset DGROUP:s@+232
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@198
	push	offset DGROUP:_cmd2
	call	near ptr _dir
	pop	cx
	jmp	@32@1374
@32@198:
   ;	
   ;		else if (!strcmp (cmd1,"format")) format (0);
   ;	
	?debug	L 113
	push	offset DGROUP:s@+235
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@254
	push	0
	call	near ptr _format
	pop	cx
	jmp	@32@1374
@32@254:
   ;	
   ;		else if (!strcmp (cmd1,"mkdir")) mkdir (cmd2);
   ;	
	?debug	L 114
	push	offset DGROUP:s@+242
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@310
	push	offset DGROUP:_cmd2
	call	near ptr _mkdir
	pop	cx
	jmp	@32@1374
@32@310:
   ;	
   ;		else if (!strcmp (cmd1,"get")) {
   ;	
	?debug	L 115
	push	offset DGROUP:s@+248
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	je short	@@7
	jmp	@32@478
@@7:
   ;	
   ;					       handle = f_open (cmd2);
   ;	
	?debug	L 116
	push	offset DGROUP:_cmd2
	call	near ptr _f_open
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_handle,eax
   ;	
   ;					       if (!handle) break;
   ;	
	?debug	L 117
	cmp	dword ptr DGROUP:_handle,large 0
	jne	short @32@394
	jmp	@32@1430
@32@394:
   ;	
   ;					       temp = f_size (handle);
   ;	
	?debug	L 118
	push	dword ptr DGROUP:_handle
	call	near ptr _f_size
	push	dx
	push	ax
	pop	eax
	add	sp,4
	mov	dword ptr DGROUP:_temp,eax
   ;	
   ;					       f_read (handle,temp,FP_SEG(fbuffer),FP_OFF(fbuffer));
   ;	
	?debug	L 119
	push	offset DGROUP:_fbuffer
	push	ds
	push	dword ptr DGROUP:_temp
	push	dword ptr DGROUP:_handle
	call	near ptr _f_read
	add	sp,12
   ;	
   ;					       printf ("\n%s -> %s [%d]",cmd2,cmd3,temp);
   ;	
	?debug	L 120
	push	dword ptr DGROUP:_temp
	push	offset DGROUP:_cmd3
	push	offset DGROUP:_cmd2
	push	offset DGROUP:s@+252
	call	near ptr _printf
	add	sp,10
   ;	
   ;					       stream = fopen (cmd3,"wb");
   ;	
	?debug	L 121
	push	offset DGROUP:s@+267
	push	offset DGROUP:_cmd3
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_stream,ax
   ;	
   ;					       if (stream==NULL) break;
   ;	
	?debug	L 122
	cmp	word ptr DGROUP:_stream,0
	jne	short @32@450
	jmp	@32@1430
@32@450:
   ;	
   ;					       fwrite (fbuffer,temp,1,stream);
   ;	
	?debug	L 123
	push	word ptr DGROUP:_stream
	push	1
	push	word ptr DGROUP:_temp
	push	offset DGROUP:_fbuffer
	call	near ptr _fwrite
	add	sp,8
   ;	
   ;					       fclose (stream);
   ;	
	?debug	L 124
	push	word ptr DGROUP:_stream
	call	near ptr _fclose
	pop	cx
   ;	
   ;					       }
   ;	
	?debug	L 125
	jmp	@32@1374
@32@478:
   ;	
   ;		else if (!strcmp (cmd1,"put")) {
   ;	
	?debug	L 126
	push	offset DGROUP:s@+270
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	je short	@@8
	jmp	@32@590
@@8:
   ;	
   ;						stream = fopen (cmd2,"rb");
   ;	
	?debug	L 127
	push	offset DGROUP:s@+274
	push	offset DGROUP:_cmd2
	call	near ptr _fopen
	add	sp,4
	mov	word ptr DGROUP:_stream,ax
   ;	
   ;						if (stream==NULL) break;
   ;	
	?debug	L 128
	cmp	word ptr DGROUP:_stream,0
	jne	short @32@562
	jmp	@32@1430
@32@562:
   ;	
   ;						fread (fbuffer,filelength ( fileno(stream)),1,stream);
   ;	
	?debug	L 129
	push	word ptr DGROUP:_stream
	push	1
	mov	bx,word ptr DGROUP:_stream
	mov	al,byte ptr [bx+4]
	cbw	
	push	ax
	call	near ptr _filelength
	pop	cx
	push	ax
	push	offset DGROUP:_fbuffer
	call	near ptr _fread
	add	sp,8
   ;	
   ;						printf ("\n%s -> %s [%u]\n",cmd2,cmd3,filelength ( fileno(stream)));
   ;	
	?debug	L 130
	mov	bx,word ptr DGROUP:_stream
	mov	al,byte ptr [bx+4]
	cbw	
	push	ax
	call	near ptr _filelength
	pop	cx
	push	dx
	push	ax
	push	offset DGROUP:_cmd3
	push	offset DGROUP:_cmd2
	push	offset DGROUP:s@+277
	call	near ptr _printf
	add	sp,10
   ;	
   ;						handle = f_create (cmd3);
   ;	
	?debug	L 131
	push	offset DGROUP:_cmd3
	call	near ptr _f_create
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_handle,eax
   ;	
   ;						printf ("\nhandle: %d\n",handle);
   ;	
	?debug	L 132
	push	dword ptr DGROUP:_handle
	push	offset DGROUP:s@+293
	call	near ptr _printf
	add	sp,6
   ;	
   ;						printf ("\n%d\n",f_write (handle,filelength ( fileno(stream)),FP_SEG(fbuffer),FP_OFF(fbuffer)));
   ;	
	?debug	L 133
	push	offset DGROUP:_fbuffer
	push	ds
	mov	bx,word ptr DGROUP:_stream
	mov	al,byte ptr [bx+4]
	cbw	
	push	ax
	call	near ptr _filelength
	pop	cx
	push	dx
	push	ax
	push	dword ptr DGROUP:_handle
	call	near ptr _f_write
	add	sp,12
	mov	ah,0
	push	ax
	push	offset DGROUP:s@+306
	call	near ptr _printf
	add	sp,4
   ;	
   ;						fclose (stream);
   ;	
	?debug	L 134
	push	word ptr DGROUP:_stream
	call	near ptr _fclose
	pop	cx
   ;	
   ;					       }
   ;	
	?debug	L 135
	jmp	@32@1374
@32@590:
   ;	
   ;		else if (!strcmp (cmd1,"rm")) {
   ;	
	?debug	L 136
	push	offset DGROUP:s@+311
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@758
   ;	
   ;	
   ;					       handle = f_open (cmd2);
   ;	
	?debug	L 138
	push	offset DGROUP:_cmd2
	call	near ptr _f_open
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_handle,eax
   ;	
   ;					       if (!handle) break;
   ;	
	?debug	L 139
	cmp	dword ptr DGROUP:_handle,large 0
	jne	short @32@674
	jmp	@32@1430
@32@674:
   ;	
   ;					       if (!f_remove (handle)) printf ("\nerror\n");
   ;	
	?debug	L 140
	push	dword ptr DGROUP:_handle
	call	near ptr _f_remove
	add	sp,4
	mov	ah,0
	or	ax,ax
	jne	short @32@730
	push	offset DGROUP:s@+314
	call	near ptr _printf
	pop	cx
@32@730:
   ;	
   ;	
   ;					      }
   ;	
	?debug	L 142
	jmp	@32@1374
@32@758:
   ;	
   ;		else if (!strcmp (cmd1,"rmdir")) { if (!rmdir (cmd2)) printf ("\nerreur\n"); }
   ;	
	?debug	L 143
	push	offset DGROUP:s@+322
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@870
	push	offset DGROUP:_cmd2
	call	near ptr _rmdir
	pop	cx
	mov	ah,0
	or	ax,ax
	jne	short @32@842
	push	offset DGROUP:s@+328
	call	near ptr _printf
	pop	cx
@32@842:
	jmp	@32@1374
@32@870:
   ;	
   ;	
   ;	
   ;		else if (!strcmp (cmd1,"cd")) {
   ;	
	?debug	L 146
	push	offset DGROUP:s@+337
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@1122
   ;	
   ;	
   ;						if ( cmd2 [strlen(cmd2)-1] != '/')
   ;	
	?debug	L 148
	push	offset DGROUP:_cmd2
	call	near ptr _strlen
	pop	cx
	dec	ax
	mov	bx,ax
	cmp	byte ptr DGROUP:_cmd2[bx],47
	je	short @32@954
   ;	
   ;						strcat (cmd2,"/.");
   ;	
	?debug	L 149
	push	offset DGROUP:s@+340
	jmp	short @32@982
@32@954:
   ;	
   ;						else strcat (cmd2,".");
   ;	
	?debug	L 150
	push	offset DGROUP:s@+343
@32@982:
	push	offset DGROUP:_cmd2
	call	near ptr _strcat
	add	sp,4
   ;	
   ;	
   ;	
   ;						temp = (path (cmd2));
   ;	
	?debug	L 153
	push	offset DGROUP:_cmd2
	call	near ptr _path
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_temp,eax
   ;	
   ;						if (temp==0xffffffff) printf ("\nerreur\n");
   ;	
	?debug	L 154
	cmp	dword ptr DGROUP:_temp,large -1
	jne	short @32@1066
	push	offset DGROUP:s@+345
	call	near ptr _printf
	pop	cx
	jmp	short @32@1094
@32@1066:
   ;	
   ;						else ACTUAL_DIR=temp;
   ;	
	?debug	L 155
	mov	eax,dword ptr DGROUP:_temp
	mov	dword ptr DGROUP:_ACTUAL_DIR,eax
@32@1094:
   ;	
   ;						printf ("\ntemp=%d\n",temp);
   ;	
	?debug	L 156
	push	dword ptr DGROUP:_temp
	push	offset DGROUP:s@+354
	call	near ptr _printf
	add	sp,6
   ;	
   ;	
   ;					      }
   ;	
	?debug	L 158
	jmp	@32@1374
@32@1122:
   ;	
   ;		else if (!strcmp (cmd1,"path")) printf ("\n%d\n",path(cmd2));
   ;	
	?debug	L 159
	push	offset DGROUP:s@+364
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@1178
	push	offset DGROUP:_cmd2
	call	near ptr _path
	pop	cx
	push	dx
	push	ax
	push	offset DGROUP:s@+369
	call	near ptr _printf
	add	sp,6
	jmp	short @32@1374
@32@1178:
   ;	
   ;		else if (!strcmp (cmd1,"handle")) {
   ;	
	?debug	L 160
	push	offset DGROUP:s@+374
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@1234
   ;	
   ;						    handle = f_open (cmd2);
   ;	
	?debug	L 161
	push	offset DGROUP:_cmd2
	call	near ptr _f_open
	push	dx
	push	ax
	pop	eax
	pop	cx
	mov	dword ptr DGROUP:_handle,eax
   ;	
   ;						    printf ("\n%d\n",handle);
   ;	
	?debug	L 162
	push	dword ptr DGROUP:_handle
	push	offset DGROUP:s@+381
	call	near ptr _printf
	add	sp,6
   ;	
   ;						  }
   ;	
	?debug	L 163
	jmp	short @32@1374
@32@1234:
   ;	
   ;	
   ;	
   ;		else if (!strcmp (cmd1,""));
   ;	
	?debug	L 166
	push	offset DGROUP:s@+386
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@1290
	jmp	short @32@1374
@32@1290:
   ;	
   ;		else if (!strcmp (cmd1,"exit"));
   ;	
	?debug	L 167
	push	offset DGROUP:s@+387
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	jne	short @32@1346
	jmp	short @32@1374
@32@1346:
   ;	
   ;		else printf ("unknown command\n");
   ;	
	?debug	L 168
	push	offset DGROUP:s@+392
	call	near ptr _printf
	pop	cx
@32@1374:
   ;	
   ;	
   ;	     } while ( (strcmp(cmd1,"exit")) && (argc < 2));
   ;	
	?debug	L 170
	push	offset DGROUP:s@+409
	push	offset DGROUP:_cmd1
	call	near ptr _strcmp
	add	sp,4
	or	ax,ax
	je	short @32@1430
	cmp	si,2
	jge short	@@9
	jmp	@32@58
@@9:
@32@1430:
   ;	
   ;	
   ;	 }
   ;	
	?debug	L 172
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E60461726763040C06000461726776200C0700
	?debug	E
	?debug	E
_main	endp
_TEXT	ends
_BSS	segment word public use16 'BSS'
_handle	label	word
	db	4 dup (?)
_stream	label	word
	db	2 dup (?)
_temp	label	word
	db	4 dup (?)
_myFCB	label	word
	db	32 dup (?)
_fcluster	label	word
	db	4 dup (?)
_fcb	label	word
	db	512 dup (?)
_bitmap	label	byte
	db	512 dup (?)
_disk_state	label	word
	db	12 dup (?)
_DRIVE	label	byte
	db	1 dup (?)
_fbuffer	label	byte
	db	40000 dup (?)
_prompt	label	byte
	db	100 dup (?)
_cmd3	label	byte
	db	100 dup (?)
_cmd2	label	byte
	db	100 dup (?)
_cmd1	label	byte
	db	100 dup (?)
_cmd	label	byte
	db	100 dup (?)
	?debug	C E9
	?debug	C FA00000000
_BSS	ends
_DATA	segment word public use16 'DATA'
s@	label	byte
	db	13
	db	10
	db	'Disk '
	db	0
	db	'C: '
	db	0
	db	'A: '
	db	0
	db	'%X'
	db	0
	db	'%X'
	db	0
	db	'%X'
	db	0
	db	'%X'
	db	0
	db	'.'
	db	0
	db	'..'
	db	0
	db	10
	db	'%s'
	db	10
	db	0
	db	10
	db	'w_cluster: %d'
	db	0
	db	10
	db	'cluster: %d'
	db	0
	db	10
	db	'sector: %u'
	db	0
	db	10
	db	'%12s   %c    %5d   y%d'
	db	0
	db	10
	db	0
	db	10
	db	'reset_disk () error %d!'
	db	10
	db	0
	db	10
	db	'reset_disk () Ok'
	db	0
	db	'%4d.'
	db	0
	db	10
	db	'error at %d'
	db	0
	db	10
	db	'format () Ok'
	db	10
	db	0
	db	10
	db	'tinyfs.exe'
	db	0
	db	10
	db	'type '
	db	39
	db	'exit'
	db	39
	db	' to quit'
	db	10
	db	0
	db	'a:/'
	db	0
	db	10
	db	'%s'
	db	0
	db	'%s %s %s'
	db	0
	db	'ls'
	db	0
	db	'format'
	db	0
	db	'mkdir'
	db	0
	db	'get'
	db	0
	db	10
	db	'%s -> %s [%d]'
	db	0
	db	'wb'
	db	0
	db	'put'
	db	0
	db	'rb'
	db	0
	db	10
	db	'%s -> %s [%u]'
	db	10
	db	0
	db	10
	db	'handle: %d'
	db	10
	db	0
	db	10
	db	'%d'
	db	10
	db	0
	db	'rm'
	db	0
	db	10
	db	'error'
	db	10
	db	0
	db	'rmdir'
	db	0
	db	10
	db	'erreur'
	db	10
	db	0
	db	'cd'
	db	0
	db	'/.'
	db	0
	db	'.'
	db	0
	db	10
	db	'erreur'
	db	10
	db	0
	db	10
	db	'temp=%d'
	db	10
	db	0
	db	'path'
	db	0
	db	10
	db	'%d'
	db	10
	db	0
	db	'handle'
	db	0
	db	10
	db	'%d'
	db	10
	db	0
	db	0
	db	'exit'
	db	0
	db	'unknown command'
	db	10
	db	0
	db	'exit'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	extrn	__setargv__:far
	public	_main
	public	_handle
	public	_stream
	public	_format
	public	_dir
	public	_temp
	public	_cluster
	public	_myFCB
	public	_f_write
	public	_f_remove
	public	_f_read
	public	_f_size
	public	_f_open
	public	_f_create
	public	_rmdir
	public	_mkdir
	public	_extract_filename
	public	_path
	public	_ACTUAL_DIR
	public	_valid_name
	public	_create
	public	_fcluster
	public	_get_fcb
	public	_dec_fcb_count
	public	_inc_fcb_count
	public	_get_fcb_count
	public	_read_fcb
	public	_set_fcb
	public	_get_fcb_free
	public	_fcb
	public	_init_disk
	public	_set_cluster
	public	_get_cluster_free
	public	_cache
	public	_bitmap
	public	_absolute_disk_access
	public	_disk_access
	public	_write_disk_infos
	public	_get_sector
	public	_get_head
	public	_get_cyl
	public	_reset_disk
	public	_disk_state
	public	_DRIVE
	public	_fbuffer
	public	_prompt
	public	_cmd3
	public	_cmd2
	public	_cmd1
	public	_cmd
	extrn	_filelength:near
	extrn	_gettime:near
	extrn	_getdate:near
	extrn	_strlen:near
	extrn	_strcpy:near
	extrn	_strcmp:near
	extrn	_strcat:near
	extrn	_memcpy:near
	extrn	__fputc:near
	extrn	_sscanf:near
	extrn	_printf:near
	extrn	_gets:near
	extrn	_fwrite:near
	extrn	_fread:near
	extrn	_fopen:near
	extrn	_fclose:near
	extrn	__streams:word
_s@	equ	s@
	?debug	C EA0109
	?debug	C E32200000023040500
	?debug	C EB0B5F5F736574617267765F5F2200
	?debug	C E32300000023010000
	?debug	C EC055F6D61696E231800
	?debug	C EC075F68616E646C650C0000
	?debug	C E3250010001E16
	?debug	C E324000200152504
	?debug	C EC075F73747265616D240000
	?debug	C E32600000023010000
	?debug	C EC075F666F726D6174261800
	?debug	C E32700000023010000
	?debug	C EC045F646972271800
	?debug	C EC055F74656D700C0000
	?debug	C E3280000021A02
	?debug	C EC085F636C7573746572280000
	?debug	C EC065F6D794643421A0000
	?debug	C E32900000023080000
	?debug	C EC085F665F7772697465291800
	?debug	C E32A00000023080000
	?debug	C EC095F665F72656D6F76652A1800
	?debug	C E32B00000023080000
	?debug	C EC075F665F726561642B1800
	?debug	C E32C000000230C0000
	?debug	C EC075F665F73697A652C1800
	?debug	C E32D000000230C0000
	?debug	C EC075F665F6F70656E2D1800
	?debug	C E32E000000230C0000
	?debug	C EC095F665F6372656174652E1800
	?debug	C E32F00000023080000
	?debug	C EC065F726D6469722F1800
	?debug	C E33000000023080000
	?debug	C EC065F6D6B646972301800
	?debug	C E331000000231C0000
	?debug	C EC115F657874726163745F66696C656E616D6531+
	?debug	C 1800
	?debug	C E332000000230C0000
	?debug	C EC055F70617468321800
	?debug	C EC0B5F41435455414C5F4449520C0000
	?debug	C E33300000023080000
	?debug	C EC0B5F76616C69645F6E616D65331800
	?debug	C E334000000230C0000
	?debug	C EC075F637265617465341800
	?debug	C EC095F66636C75737465720C0000
	?debug	C E335000000230C0000
	?debug	C EC085F6765745F666362351800
	?debug	C E33600000023080000
	?debug	C EC0E5F6465635F6663625F636F756E74361800
	?debug	C E33700000023080000
	?debug	C EC0E5F696E635F6663625F636F756E74371800
	?debug	C E338000000230C0000
	?debug	C EC0E5F6765745F6663625F636F756E74381800
	?debug	C E33900000023080000
	?debug	C EC095F726561645F666362391800
	?debug	C E33A00000023080000
	?debug	C EC085F7365745F6663623A1800
	?debug	C E33B000000230C0000
	?debug	C EC0D5F6765745F6663625F667265653B1800
	?debug	C E33C0000021A1A
	?debug	C EC045F6663623C0000
	?debug	C E33D00000023080000
	?debug	C EC0A5F696E69745F6469736B3D1800
	?debug	C E33E00000023080000
	?debug	C EC0C5F7365745F636C75737465723E1800
	?debug	C E33F000000230C0000
	?debug	C EC115F6765745F636C75737465725F667265653F+
	?debug	C 1800
	?debug	C EC065F63616368650C0000
	?debug	C E3400000021A08
	?debug	C EC075F6269746D6170400000
	?debug	C E34100000023080000
	?debug	C EC155F6162736F6C7574655F6469736B5F616363+
	?debug	C 657373411800
	?debug	C E34200000023080000
	?debug	C EC0C5F6469736B5F616363657373421800
	?debug	C E34300000023010000
	?debug	C EC115F77726974655F6469736B5F696E666F7343+
	?debug	C 1800
	?debug	C E344000000230C0000
	?debug	C EC0B5F6765745F736563746F72441800
	?debug	C E345000000230C0000
	?debug	C EC095F6765745F68656164451800
	?debug	C E346000000230C0000
	?debug	C EC085F6765745F63796C461800
	?debug	C E34700000023080000
	?debug	C EC0B5F72657365745F6469736B471800
	?debug	C E3480C735F6469736B5F73746174650C001E20
	?debug	C EC0B5F6469736B5F7374617465480000
	?debug	C EC065F4452495645080000
	?debug	C E34900409C1A08
	?debug	C EC085F66627566666572490000
	?debug	C E34A0064001A02
	?debug	C EC075F70726F6D70744A0000
	?debug	C E34B0064001A02
	?debug	C EC055F636D64334B0000
	?debug	C E34C0064001A02
	?debug	C EC055F636D64324C0000
	?debug	C E34D0064001A02
	?debug	C EC055F636D64314D0000
	?debug	C E34E0064001A02
	?debug	C EC045F636D644E0000
	?debug	C E34F00000023060000
	?debug	C EB0B5F66696C656C656E6774684F00
	?debug	C E35000000023010000
	?debug	C EB085F67657474696D655000
	?debug	C E35100000023010000
	?debug	C EB085F676574646174655100
	?debug	C E352000000230A0000
	?debug	C EB075F7374726C656E5200
	?debug	C E35300000023210000
	?debug	C EB075F7374726370795300
	?debug	C E35400000023040000
	?debug	C EB075F737472636D705400
	?debug	C E35500000023210000
	?debug	C EB075F7374726361745500
	?debug	C E35600000023180000
	?debug	C EB075F6D656D6370795600
	?debug	C E35700000023040000
	?debug	C EB075F5F66707574635700
	?debug	C E35800000023040001
	?debug	C EB075F737363616E665800
	?debug	C E35900000023040001
	?debug	C EB075F7072696E74665900
	?debug	C E35A00000023210000
	?debug	C EB055F676574735A00
	?debug	C E35B000000230A0000
	?debug	C EB075F6677726974655B00
	?debug	C E35C000000230A0000
	?debug	C EB065F66726561645C00
	?debug	C E35D00000023240000
	?debug	C EB065F666F70656E5D00
	?debug	C E35E00000023040000
	?debug	C EB075F66636C6F73655E00
	?debug	C E35F0000001A25
	?debug	C EB095F5F73747265616D735F00
	?debug	C E604626F6F6C08060006737472696E671C060005+
	?debug	C 756C6F6E670C06000475696E740A060005756368+
	?debug	C 61720806000777636861725F740206000446494C+
	?debug	C 452506000666706F735F740606000673697A655F+
	?debug	C 740A06001266696C655F636F6E74726F6C5F626C+
	?debug	C 6F636B1A07000C735F6469736B5F737461746548+
	?debug	C 070004646174651D07000474696D651E0700
	?debug	C E20006665F6E616D651B0006665F73697A650C00+
	?debug	C 0C665F6469725F6661746865720C0005665F6461+
	?debug	C 79080007665F6D6F6E7468080006665F79656172+
	?debug	C 0A0006665F686F7572080005665F6D696E080006+
	?debug	C 665F61747472080008665F756E75736564080009+
	?debug	C 665F636C75737465720CC020000000
	?debug	C E2000764615F7965617204000664615F64617902+
	?debug	C 000664615F6D6F6E02C004000000
	?debug	C E2000674695F6D696E08000774695F686F757208+
	?debug	C 000774695F68756E6408000674695F73656308C0+
	?debug	C 04000000
	?debug	C E200056C6576656C040005666C6167730A000266+
	?debug	C 64020004686F6C640800056273697A6504000662+
	?debug	C 75666665721C0004637572701C0006697374656D+
	?debug	C 700A0005746F6B656E04C010000000
	?debug	C E2000363796C0A00046865616408000673656374+
	?debug	C 6F720800086D61785F616464720C000B6269746D+
	?debug	C 61705F73697A650CC00C000000
	end
