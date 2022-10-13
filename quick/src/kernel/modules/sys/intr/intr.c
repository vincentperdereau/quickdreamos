 /*
  * quick/src/kernel/modules/sys/intr/intr.c
  *
  *
  */

  /*
   * intr (): installe une fonction en tant qu'interruption
   *
   */

  void intr (void* funcptr, char intc)
  {
   asm {
	push ax
	push bx
	push es
        xor ax,ax    
	mov es,ax
	xor bh,bh
	mov bl,intc
        shl bx,2             
	mov ax,funcptr
        mov es:[bx],ax       // 0000:(intc*4) = funcptr
        mov word ptr es:[bx+2],0x1000 // 0000:(intc*4+2) = segment noyau (x1000)
        pop es
        pop bx
        pop ax
       }
  }
