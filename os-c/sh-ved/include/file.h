
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

 handle fcreate (char* fname)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     ah,0x0003
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

 int fwrite (handle h,long count,void* buffer,unsigned int segm)
 {
  asm {
	push    ds
	push    si
	push    ecx
	push    edx
	mov     ax,segm
	mov     ds,ax
	mov     si,buffer
	mov     ecx,count
	mov     edx,h
	mov     ah,0x0005
	int     0x44
        pop     edx
        pop     ecx
        pop     si
        pop     ds
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

 unsigned char fattr (handle h)
 {
  asm {
        push    ecx
        mov     ah,0x000c
        mov     edx,h
        int     0x44
        pop     ecx
      }
 }

 int    setattr (handle h, char attr)
 {
  asm {
        push edx
        push cx
        mov ah,0x0017
        mov edx,h
        mov cl,attr
        int 0x44
        pop cx
        pop edx
      }
 }

 char fremove (handle h)
 {
  asm {
        push    edx
        mov     ah,0x000d
        mov     edx,h
        int     0x44
        pop     edx
      }
 }

 char exec (char* prog,unsigned int segArg,unsigned int ofsArg,char check)
 {
  unsigned long tm;
  tm = avail ();

   asm {
       mov      ax,0x0600
       int      0x46
      }
      
  asm {
       push     ds
       push     si
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
 if  ( (!is_xsh()) && (check) && (avail() != tm) ) puts ("\n\rwarning: memory no released");
 }
