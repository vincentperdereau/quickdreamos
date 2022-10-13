
 char mkdir (char* dir)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     si,dir
        mov     ah,8
        int     0x44
        mov     ah,0
        pop     ds
        pop     si
      }
 }

 char rmdir (char* dir)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     si,dir
        mov     ah,0xe
        int     0x44
        mov     ah,0
        pop     ds
        pop     si
      }
 }

 unsigned long chdir (char* dir)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     si,dir
        mov     ah,07h
        int     0x44
        mov     edx,eax
        shr     edx,16
        pop     ds
        pop     si
       }
 }

 unsigned long acdir (void)
 {
  asm {
        mov ah,0xf
        int 0x44
        mov edx,eax
        shr edx,16
      }
 }
