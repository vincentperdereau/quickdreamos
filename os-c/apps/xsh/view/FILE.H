
 typedef         unsigned long   handle;

 handle fopen (char* fname)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     ah,0x0002
        mov     si,fname
        int     0x44
        mov     edx,eax
        shr     edx,16
        pop     ds
        pop     si
      }
 }

 int fread (handle h,long count,void* buffer,unsigned int segm)
 {
  asm {
        push    es
        push    di
        push    ecx
        push    edx
        mov     ax,segm
        mov     es,ax
        mov     di,buffer
        mov     ecx,count
        mov     edx,h
        mov     ah,0x0004
        int     0x44
        pop     edx
        pop     ecx
        pop     di
        pop     es
      }
 }

 unsigned long fsize (handle h)
 {
  asm {
        push    ecx
        mov     ah,0x000c
        mov     edx,h
        int     0x44
        mov     eax,ecx
        mov     edx,eax
        shr     edx,16
        pop     ecx
      }
 }

 char exec (char* prog,unsigned int segArg,unsigned int ofsArg)
 {
  asm {
       push     ds
       push     si
       mov      ax,0x0601
       int      0x46
       mov      ax,cs
       mov      ds,ax
       mov      ax,segArg
       mov      es,ax
       mov      bx,ofsArg
       mov      ah,0x0014
       mov      si,prog
       int      0x44
       pop      si
       pop      ds
      }
  }

