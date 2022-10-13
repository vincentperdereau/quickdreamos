 /*
  * quick/src/kernel/modules/sys/disk/disk.c
  *
  * lecture et ‚criture sur disque (interface avec l'interruption x13)
  */

  #include <typedef.h>
  #include <sys/disk/disk.h>
  #include <sys/disk/disks.h>

  UCHAR DRIVE;                            // lecteur en cours d'utilisation

  struct s_disk_state disk_state;

/*
 * reset_disk (): Initialise le disque
 * rem: fonction x00 (int x13)
 */

  BOOL reset_disk (UCHAR d)
  {
   asm {
        push dx
        mov ah,0
        mov dl,d
        int 0x13
        mov al,ah
        pop dx
       }
  }

/*
 * get_cyl (): renvoie le nombre de cylindres du lecteur 'd'
 *
 */

  ULONG get_cyl (UCHAR d)
  {
   asm {
	push bx
        push cx
        push si
        push di
        push es
        mov dl,d
        mov ah,8
        int 0x13
        mov al,ch
        shr cl,6
        mov ah,cl
        xor dx,dx
        pop es
        pop di
        pop si
        pop cx
        pop bx
       }
  }

/*
 * get_head (): renvoie le nombre de tˆtes du lecteur 'd'
 *
 */

  ULONG get_head (UCHAR d)
  {
   asm {
        push cx
        push bx
        push es
	push di
        push si
        mov dl,d
        mov ah,8
	int 0x13
        mov ah,0
        mov al,dh
        xor dx,dx
        pop si
        pop di
        pop es
        pop bx
        pop cx
       }
  }

/*
 * get_sector (): renvoie le nombre de secteurs du lecteur 'd'
 *
 */

 ULONG get_sector (UCHAR d)
 {
  asm {
       push cx
       push bx
       push es
       push di
       push si
       mov dl,d
       mov ah,8
       int 0x13
       xor ah,ah
       xor dx,dx
       and cl,63
       mov al,cl
       pop si
       pop di
       pop es
       pop bx
       pop cx
      }
 }

#ifdef BUFFER

PROC himem_write (UINT segs, UINT ofss,
                  ULONG c,ULONG count)
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

PROC himem_read (ULONG c, UINT segc,
                 UINT ofsc, ULONG count)
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

 BOOL disk_access (UCHAR d,               // lecteur
                   int h,                 // tˆte
                   int c,                 // cylindre
                   int s,                 // secteur
                   int count,             // nombre de secteur(s) … ‚crire
                   void* ofs,             // 'offset' du buffer
                   UINT segm,             // 'segm' du buffer
                   int op)                // op‚ration … effecteur 
 {

  ULONG adr;

  adr = ( h * 80 * 18 ) + ( c * 18 ) + s;

  if (op == 2) himem_read ( (adr * 512) + 0x200000 , (UINT)segm, (UINT)ofs, count * 512);
  if (op == 3) himem_write ((UINT)segm, (UINT)ofs, (adr * 512) + 0x200000, count * 512);
  return 0;

 }

#endif

 /*
  * disk_access (): lecture/ecriture sur lecteur via adresse PHYSIQUE
  *
  */

#ifdef BUFFER
 BOOL r_disk_access (UCHAR d,               // lecteur
                   int h,                 // tˆte
                   int c,                 // cylindre
                   int s,                 // secteur
                   int count,             // nombre de secteur(s) … ‚crire
                   void* ofs,             // 'offset' du buffer
                   UINT segm,             // 'segm' du buffer
                   int op)                // op‚ration … effecteur 
#else
 BOOL disk_access (UCHAR d,               // lecteur
                   int h,                 // tˆte
                   int c,                 // cylindre
                   int s,                 // secteur
                   int count,             // nombre de secteur(s) … ‚crire
                   void* ofs,             // 'offset' du buffer
                   UINT segm,             // 'segm' du buffer
                   int op)                // op‚ration … effecteur 
#endif
 {
  asm {
       push dx
       push cx
       push bx
       push es
       mov dl,d
       mov ax,h
       mov dh,al
       mov cx,c
       xchg ch,cl
       shl cl,6
       mov ax,s
       or cl,al
       mov ax,segm
       mov es,ax
       mov ax,count
       mov bx,op
       mov ah,bl
       mov bx,ofs
       int 0x13
       shr ax,8
       pop es
       pop bx
       pop cx
       pop dx
      }
 }

/*
 * absolute_disk_access (): lecture/ecriture sur lecteur via adresse LOGIQUE
 *
 */

 BOOL absolute_disk_access (UCHAR d,       // lecteur
                            int op,        // op‚ration … affectuer
                            int count,     // nombre de secteur
                            ULONG addr,    // adresse logique
                            UINT seg,      // adresse buffer 
                            UINT ofs)      // seg:ofs
 {
  ULONG c,h,s;
  BOOL stat;

  disk_state.cyl = get_cyl (d) +1;
  disk_state.head = get_head (d) +1;
  disk_state.sector = get_sector (d);

  // conversion logique -> physique

  s = 1 + (addr % (ULONG)disk_state.sector );
  h = (addr / (ULONG)disk_state.sector) % (ULONG)disk_state.head;
  c = addr / ((ULONG)disk_state.sector * (ULONG)disk_state.head);

  stat = disk_access (d,(UINT)h,(UINT)c,(UINT)s,count,(void*)ofs,seg,op);
  // (stat = 6) indique que la disquette a ‚t‚ chang‚, n'est donc pas
  //            une veritable erreur.
  if (stat == 6) stat = disk_access (d,(UINT)h,(UINT)c,(UINT)s,count,(void*)ofs,seg,op);
  if (stat == 6) stat = disk_access (d,(UINT)h,(UINT)c,(UINT)s,count,(void*)ofs,seg,op);
  if (stat) kpanic(3)

  return stat;
 }
