#include <stdio.h>
#include <himem.h>

typedef char BOOL;
typedef unsigned int UINT;
typedef unsigned char UCHAR;
typedef unsigned long ULONG;

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


 /*
  * disk_access (): lecture/ecriture sur lecteur via adresse PHYSIQUE
  *
  */

 BOOL r_disk_access (UCHAR d,               // lecteur
                   int h,                 // tˆte
                   int c,                 // cylindre
                   int s,                 // secteur
                   int count,             // nombre de secteur(s) … ‚crire
                   void* ofs,             // 'offset' du buffer
                   UINT segm,             // 'segm' du buffer
                   int op)                // op‚ration … effecteur 
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


int head, cyl, sector;

void main ()
{
 printf ("\nplease wait while refreshing buffer");
 for ( head = 0 ; head <= 1 ; head++)
   for ( cyl = 0 ; cyl <= 79 ; cyl++)
   {
    r_disk_access (0,head,cyl,1,18,0,0x6000,2);
    disk_access (0,head,cyl,1,18,0,0x6000,3);
    asm {
          push ax
          mov al,'.'
          int 29h
          pop ax
        }
   }

}
