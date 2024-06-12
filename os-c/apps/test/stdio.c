#include "_defs.h"
#include "stdarg.h"
#include "memory.h"

typedef struct 
{
 unsigned long handle;
 unsigned int bseg;
 unsigned int bofs;
 unsigned int size;
 int op;
// long unused;
} far FILE;

char f_stat = 0;

void gets (char* s,unsigned int c)
{
 asm {
        push ax
        push bx
        push cx
        push es
        mov ax,cs
        mov es,ax
        mov bx,s
        mov cx,c
        mov ah,0x0011
        int 0x44
        pop es
        pop cx
        pop bx
        pop ax
     }
}

void putc (char c)
{
 asm {
        push ax
        mov al,c
        int 0x29
        pop ax
     }
}

void writenum (unsigned long dw,char size)
{
 unsigned long i ; unsigned char b ;
 int flag=0;

 if (size==8) i = 100;
 if (size==16) i = 10000;
 if (size==32) i = 1000000000;

 for (;i!=0;i/=10)
 {
 b = dw / i ; dw = dw - (b*i) ;
 if (b) flag = 1;
 if (flag)  putc (b+48) ;
 if ( (!i) && (!flag)) putc (48);
 }
}

 void write_hex_byte (unsigned char b,char cas)
 {
  char letter;

  if (cas == 'x') letter = 'a';
  else letter = 'A';
  if ( (b>>4) > 9 ) putc ( (b>>4) + letter - 10 );
  else  putc ( (b>>4) + '0' );
  if ( (b & 0x0f) > 9 ) putc ( (b & 0x0f) + letter - 10 );
  else  putc ( (b & 0x0f) + '0' );
 }

 void write_hex_word (unsigned int w, char cas)
 {
  write_hex_byte (w>>8,cas);
  write_hex_byte (w&0x00ff,cas);
 }


void puts (char* s)
{
 int i;
 for (i=0; s[i] != 0; i++)
 {
  if (s[i] == 10) putc (13);
  putc (s[i]);
 }
}

void printf (char* format,...)
{
 int adr;
 unsigned int tmp;
 char ch;
 va_list vl;

 va_start (vl,format);

 while (*format)
 {
  if (*format == '\n')  putc (13);
  if (*format != '%')
   putc (*format);
  else
  {
   switch (*++format)
   {
    case 's':   asm { mov ax,ss ; mov ds,ax }
                adr = va_arg (vl,int);
                asm { mov ax,cs ; mov ds,ax }
                if (!adr) puts ("<NULL>");
                else puts ( (char*)adr );
                break;
    case 'u': asm { mov ax,ss ; mov ds,ax }
              tmp = va_arg (vl,unsigned int);
              asm { mov ax,cs ; mov ds,ax }
              writenum ( tmp ,16);
              break;
    case 'x': asm { mov ax,ss ; mov ds,ax }
              tmp = va_arg (vl,unsigned int);
              asm { mov ax,cs ; mov ds,ax }
              write_hex_word (tmp,'x');
              break;
    case 'X': asm { mov ax,ss ; mov ds,ax }
              tmp = va_arg (vl,unsigned int);
              asm { mov ax,cs ; mov ds,ax }
              write_hex_word (tmp,'X');
              break;
    case 'c': asm { mov ax,ss ; mov ds,ax }
              ch = va_arg (vl,char);
              asm { mov ax,cs ; mov ds,ax }
              putc (ch);
              break;
    default:  putc (*format);

   }
  }
  format++;
  }
 va_end (vl);
}
 unsigned long f_open (char* fname)
 {
  asm {
        push    si
        push    ds
        push    di
        mov     ax,cs
        mov     ds,ax
        mov     ah,0x0002
        mov     si,fname
        int     0x44
        mov     edx,eax
        shr     edx,16
        pop     di
        pop     ds
        pop     si
      }
 }

 unsigned long f_create (char* fname)
 {
  asm {
        push    si
        push    ds
        push    di
        mov     ax,cs
        mov     ds,ax
        mov     ah,0x0003
        mov     si,fname
        int     0x44
        mov     edx,eax
        shr     edx,16
        pop     di
        pop     ds
        pop     si
      }
 }

 int f_read (unsigned long h,long count,void* buffer,unsigned int segm)
 {
  asm {
        push    es
        push    si
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
        pop     si
        pop     es
      }
 }

 int f_write (unsigned long h,long count,void* buffer,unsigned int segm)
 {
  asm {
	push    ds
	push    si
        push    di
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
        pop     di
        pop     si
        pop     ds
      }
 }


 unsigned long f_size (unsigned long h)
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

FILE *f;
unsigned int dc;

FILE* fopen (char* filename, char* flag)
{

 f = (unsigned long) malloc (1);
 asm { shl dword ptr f,16 };

 if (flag[0] == 'r')
 {
  f->bofs = 0;
  f->op = 2;
  f->handle = f_open (filename);
  if (f->handle <2)
  {
   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   free (dc);
   return (FILE*)0;
  }
  f->size = f_size (f->handle);
  f->bseg = malloc (  ((f->size) >> 4) +1);
  f_read (f->handle,f->size,(void*)f->bofs,f->bseg);
  return (f);
 }
 if (flag[0] == 'w')
 {
  f->bseg = malloc (0xfff);
  f->bofs = 0;
  f->op = 3;
  f->size = 0;
  f->handle = f_create (filename);
  if (f->handle <2)
  {
   dc = (unsigned int) ( (unsigned long)(f) >> 16 );
   free (dc);
   return (FILE*)0;
  }
  return (f);
 }
 return (FILE*)0;
}

int fread (void* buf, int size, int nelelm, FILE *fd)
{
 memcpy (_CS,(unsigned int)buf,fd->bseg,fd->bofs,size*nelelm);
 fd->bofs += size * nelelm;
}

int fwrite (void* buf, int size, int nelelm, FILE *fd)
{
 memcpy (fd->bseg,fd->bofs,_CS,(unsigned int)buf,size*nelelm);
 fd->bofs += size * nelelm;
 fd->size = fd->bofs;
}

int fseek (FILE *fd, long offset, int whence)
{
 if (whence == 0) fd->bofs = offset;
 if (whence == 1) fd->bofs += offset;
 if (whence == 2) fd->bofs = fd->size - offset;
}

static char static_c;

char fgetc (FILE *fd)
{
 if (fd->bofs == fd->size) { f_stat = 1; return 0; }
 memcpy (_CS,(unsigned int)&(static_c),fd->bseg,fd->bofs,1);
 fd->bofs++;
 return static_c;
}

char* fgets(char* buf, int len, FILE *f)
{
   int c = 0;
   char ch;
   char* p = buf;

   f_stat = 0;
   while((c++ < (len-1)) && (!f_stat) ) {
      f_stat = 0;
      ch = fgetc (f);
      if(ch == '\r')
         continue;
      *p++ = ch;
      if(ch == '\n')
         break;
   }

   if(!f_stat)
      return(0);
   *p++ = 0;
   return (buf);
}

void fclose (FILE *fd)
{
 if ( fd->op == 3) f_write (fd->handle,fd->size,0,fd->bseg);
 free (fd->bseg);
 dc = (unsigned int) ( (unsigned long)(fd) >> 16 );
 free (dc);
}

unsigned long fsize (FILE *f)
{
 return (f_size ( f->handle ) );
}
