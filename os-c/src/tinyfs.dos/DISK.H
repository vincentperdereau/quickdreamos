
 /*
  * include/sys/i386/disk/disk.h
  *
  * created: 08/17/99
  * modified: 08/17/99
  *
  */

  #define       INCLUDE_SYS_I386_DISK_DISK_H    1

  uchar DRIVE;

  #define       diskA           0x00
  #define       diskC           0x80
  #define       DISK_READ       0x02
  #define       DISK_WRITE      0x03
  #define       SECTOR_SIZE     512

  struct s_disk_state
  {
   uint         cyl;
   uchar        head;
   uchar        sector;
   ulong        max_addr;
   ulong        bitmap_size;
  };

  struct s_disk_state disk_state;

  bool reset_disk (uchar d)
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

  ulong get_cyl (uchar d)
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

  ulong get_head (uchar d)
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

 ulong get_sector (uchar d)
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

 void write_disk_infos (uchar d)
 {
  write_string ("\r\nDisk "); write_string ((d) ? "C: " : "A: ");
  write_hex_word (get_cyl (d)+1); write_char ('C'); write_char (' ');
  write_hex_byte (get_head (d)+1); write_char ('H'); write_char (' ');
  write_hex_byte (get_sector (d)); write_char ('S'); write_char (',');
  write_hex_dword ( (get_cyl (d)+1)*(get_head(d)+1)*(get_sector(d)) );
 }

 bool disk_access (uchar d,
                   int h,
                   int c,
                   int s,
                   int count,
		   void* ofs,
		   uint segm,
		   int op)
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

 bool absolute_disk_access (uchar d,
                            int op,
                            int count,
                            ulong addr,
                            uint seg,
                            uint ofs)
 {
  ulong c,h,s;
  bool stat;
  s = 1 + (addr % (ulong)disk_state.sector );
  h = (addr / (ulong)disk_state.sector) % (ulong)disk_state.head;
  c = addr / ((ulong)disk_state.sector * (ulong)disk_state.head);
  stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
  if (stat == 6) stat = disk_access (d,(uint)h,(uint)c,(uint)s,count,(void*)ofs,seg,op);
  return stat;
 }

