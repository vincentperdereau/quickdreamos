void himem_write (unsigned int segs,unsigned int ofss,
		 unsigned long c,unsigned long count)
{
asm {
	push si
	push ds
	push ax
	push ecx
	push ebx
	mov ax,segs
	mov ds,ax
	mov si,ofss
	mov ebx,c
	mov ecx,count
	himem_loop:
	mov al,ds:[si]
	mov fs:[ebx],al
	inc si
	inc ebx
	loopd himem_loop
	pop ebx
	pop ecx
	pop ax
	pop ds
	pop si
};
}

void himem_read (unsigned long c,unsigned int segc,
		 unsigned int ofsc,unsigned long count)
{
asm {
	push si
	push ds
	push ax
	push ecx
	push ebx
	mov ax,segc
	mov ds,ax
	mov si,ofsc
        mov ebx,c
	mov ecx,count
	himem_loop2:
	mov al,fs:[ebx]
	mov ds:[si],al
	inc si
	inc ebx
	loopd himem_loop2
	pop ebx
	pop ecx
	pop ax
	pop ds
	pop si
};
}

