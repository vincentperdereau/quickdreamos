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
	?debug	S "cs4235.c"
	?debug	C E9F99B0129086373343233352E63
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
   ;	
   ;	void outb(int port,unsigned char data)
   ;	
	assume	cs:_TEXT
_outb	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  asm {
   ;	   push ax
   ;	
	push	 ax
   ;	
   ;	   push dx
   ;	
	push	 dx
   ;	
   ;	    mov al,data
   ;	
	mov	 al,[bp+6]
   ;	
   ;	    mov dx,port
   ;	
	mov	 dx,[bp+4]
   ;	
   ;	    out dx,al
   ;	
	out	 dx,al
   ;	
   ;	   pop dx
   ;	
	pop	 dx
   ;	
   ;	   pop ax
   ;	
	pop	 ax
   ;	
   ;	  }
   ;	}
   ;	
	pop	bp
	ret	
_outb	endp
   ;	
   ;	unsigned char hi(int val)
   ;	
	assume	cs:_TEXT
_hi	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  return(val >> 8);
   ;	
	mov	ax,word ptr [bp+4]
	sar	ax,8
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_hi	endp
   ;	
   ;	unsigned char lo(int val)
   ;	
	assume	cs:_TEXT
_lo	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;	  return(val & 0xFF);
   ;	
	mov	al,byte ptr [bp+4]
	and	al,255
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_lo	endp
   ;	
   ;	main()
   ;	
	assume	cs:_TEXT
_main	proc	near
	enter	42,0
	push	si
	push	di
   ;	
   ;	{
   ;	   unsigned char dma,dma2,irq,mpuirq;
   ;	   unsigned basead,mpu,wss;
   ;	   int i;
   ;	   /* The writeing of unsigned char key[33]={....
   ;	      made a link error so i use now this method.
   ;	   */
   ;	   unsigned char key[33];
   ;	/*-------------------------------------------------------------------------*/
   ;	   /* Definations of settings of soundcard */
   ;	   basead=0x220; /* Soundblaster port */
   ;	
	mov	di,544
   ;	
   ;	   mpu=0x330;    /* MPU Port */
   ;	
	mov	word ptr [bp-6],816
   ;	
   ;	   wss=0x534;    /* WSS port */
   ;	
	mov	word ptr [bp-8],1332
   ;	
   ;	   irq=7;        /* Soundblaster IRQ */
   ;	
	mov	byte ptr [bp-3],7
   ;	
   ;	   mpuirq=9;     /* MPU IRQ */
   ;	
	mov	byte ptr [bp-4],9
   ;	
   ;	   dma=1;        /* DMA 8-Bit (SB) */
   ;	
	mov	byte ptr [bp-1],1
   ;	
   ;	   dma2=4;       /* DMA 16-Bit (WSS Capture) */
   ;	
	mov	byte ptr [bp-2],4
   ;	
   ;	/*-------------------------------------------------------------------------*/
   ;	   key[0]=0x96;
   ;	
	mov	byte ptr [bp-42],150
   ;	
   ;	   key[1]=0x35;
   ;	
	mov	byte ptr [bp-41],53
   ;	
   ;	   key[2]=0x9A;
   ;	
	mov	byte ptr [bp-40],154
   ;	
   ;	   key[3]=0xCD;
   ;	
	mov	byte ptr [bp-39],205
   ;	
   ;	   key[4]=0xE6;
   ;	
	mov	byte ptr [bp-38],230
   ;	
   ;	   key[5]=0xF3;
   ;	
	mov	byte ptr [bp-37],243
   ;	
   ;	   key[6]=0x79;
   ;	
	mov	byte ptr [bp-36],121
   ;	
   ;	   key[7]=0xBC;
   ;	
	mov	byte ptr [bp-35],188
   ;	
   ;	   key[8]=0x5E;
   ;	
	mov	byte ptr [bp-34],94
   ;	
   ;	   key[9]=0xAF;
   ;	
	mov	byte ptr [bp-33],175
   ;	
   ;	   key[10]=0x57;
   ;	
	mov	byte ptr [bp-32],87
   ;	
   ;	   key[11]=0x2B;
   ;	
	mov	byte ptr [bp-31],43
   ;	
   ;	   key[12]=0x15;
   ;	
	mov	byte ptr [bp-30],21
   ;	
   ;	   key[13]=0x8A;
   ;	
	mov	byte ptr [bp-29],138
   ;	
   ;	   key[14]=0xC5;
   ;	
	mov	byte ptr [bp-28],197
   ;	
   ;	   key[15]=0xE2;
   ;	
	mov	byte ptr [bp-27],226
   ;	
   ;	   key[16]=0xF1;
   ;	
	mov	byte ptr [bp-26],241
   ;	
   ;	   key[17]=0xF8;
   ;	
	mov	byte ptr [bp-25],248
   ;	
   ;	   key[18]=0x7C;
   ;	
	mov	byte ptr [bp-24],124
   ;	
   ;	   key[19]=0x3E;
   ;	
	mov	byte ptr [bp-23],62
   ;	
   ;	   key[20]=0x9F;
   ;	
	mov	byte ptr [bp-22],159
   ;	
   ;	   key[21]=0x4F;
   ;	
	mov	byte ptr [bp-21],79
   ;	
   ;	   key[22]=0x27;
   ;	
	mov	byte ptr [bp-20],39
   ;	
   ;	   key[23]=0x13;
   ;	
	mov	byte ptr [bp-19],19
   ;	
   ;	   key[24]=0x09;
   ;	
	mov	byte ptr [bp-18],9
   ;	
   ;	   key[25]=0x84;
   ;	
	mov	byte ptr [bp-17],132
   ;	
   ;	   key[26]=0x42;
   ;	
	mov	byte ptr [bp-16],66
   ;	
   ;	   key[27]=0xA1;
   ;	
	mov	byte ptr [bp-15],161
   ;	
   ;	   key[28]=0xD0;
   ;	
	mov	byte ptr [bp-14],208
   ;	
   ;	   key[29]=0x68;
   ;	
	mov	byte ptr [bp-13],104
   ;	
   ;	   key[30]=0x34;
   ;	
	mov	byte ptr [bp-12],52
   ;	
   ;	   key[31]=0x1A;
   ;	
	mov	byte ptr [bp-11],26
   ;	
   ;	   /* Sending of Magic key */
   ;	   for (i=0;i<32;i++)
   ;	
	xor	si,si
	jmp	short @4@114
@4@58:
   ;	
   ;	   {
   ;	     outb(0x279,key[i]);
   ;	
	mov	al,byte ptr [bp+si-42]
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
	inc	si
@4@114:
	cmp	si,32
	jl	short @4@58
   ;	
   ;	   }
   ;	   outb(0x279,0x6);/* Card Select Number */
   ;	
	push	6
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x1);
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x15); /* Logical Device 0 */
   ;	
	push	21
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x00); /* Device number (0-5) */
   ;	
	push	0
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x47); /* WSS Base */
   ;	
	push	71
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,hi(wss));
   ;	
	push	word ptr [bp-8]
	call	near ptr _hi
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,lo(wss));
   ;	
	push	word ptr [bp-8]
	call	near ptr _lo
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x48); /* SYNbase */
   ;	
	push	72
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x03); /* 388 */
   ;	
	push	3
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x88);
   ;	
	push	136
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x42); /* SBbase */
   ;	
	push	66
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,hi(basead)); /* Set Base Adress */
   ;	
	push	di
	call	near ptr _hi
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,lo(basead));
   ;	
	push	di
	call	near ptr _lo
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x22); /* IRQ */
   ;	
	push	34
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,irq);
   ;	
	mov	al,byte ptr [bp-3]
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x2A); /* DMA (8-Bit) */
   ;	
	push	42
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,dma);
   ;	
	mov	al,byte ptr [bp-1]
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x25); /* WSS capture DMA */
   ;	
	push	37
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,dma2);
   ;	
	mov	al,byte ptr [bp-2]
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x33); /* Activate */
   ;	
	push	51
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01);
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x15); /* Logical Device 1 */
   ;	
	push	21
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01); /* Device number (0-5) */
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x47); /* GAMEPORT Base */
   ;	
	push	71
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x02); /* 200 */
   ;	
	push	2
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x00);
   ;	
	push	0
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x33); /* Activate */
   ;	
	push	51
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01);
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x15); /* Logical Device 2 */
   ;	
	push	21
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x02); /* Device number (0-5) */
   ;	
	push	2
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x47); /* CTRL Base */
   ;	
	push	71
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01); /* 120 */
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x20);
   ;	
	push	32
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x33); /* Activate */
   ;	
	push	51
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01);
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x15); /* Logical Device 3 */
   ;	
	push	21
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x03); /* Device number (0-5) */
   ;	
	push	3
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x47); /* MPU Base */
   ;	
	push	71
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,hi(mpu));
   ;	
	push	word ptr [bp-6]
	call	near ptr _hi
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,lo(mpu));
   ;	
	push	word ptr [bp-6]
	call	near ptr _lo
	pop	cx
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x22); /* MPU Irq */
   ;	
	push	34
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,mpuirq);
   ;	
	mov	al,byte ptr [bp-4]
	push	ax
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x33); /* Activate */
   ;	
	push	51
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x01);
   ;	
	push	1
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	   outb(0x279,0x79); /* Ready... for take off*/
   ;	
	push	121
	push	633
	call	near ptr _outb
	add	sp,4
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	
_main	endp
	?debug	C E9
	?debug	C FA10000000
_TEXT	ends
_DATA	segment word public use16 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	public	_main
	public	_lo
	public	_hi
	public	_outb
_s@	equ	s@
	end
