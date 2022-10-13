
 typedef        unsigned int    addr;

 addr malloc (unsigned int paragraph)
 {
  asm {
        push bx
        mov ah,0x0012
        mov bx,paragraph
        int 0x44
        pop bx
      }
 }

 void free (addr adr)
 {
  asm {
       push bx
       mov ah,0x0013
       mov bx,adr
       int 0x44
       pop bx
      }
 }

 unsigned long avail (void)
 {
  asm {
        mov ah,15h
        int 44h
        mov dx,0
      }
 }
