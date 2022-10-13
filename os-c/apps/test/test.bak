#include <stdio.h>
#include <string.h>
#include <memory.h>

FILE *mf;
unsigned long fsz;

 void hex_byte (unsigned char b,char cas)
 {
  char letter;

  if (cas == 'x') letter = 'a';
  else letter = 'A';
  if ( (b>>4) > 9 ) putc ( (b>>4) + letter - 10 );
  else  putc ( (b>>4) + '0' );
  if ( (b & 0x0f) > 9 ) putc ( (b & 0x0f) + letter - 10 );
  else  putc ( (b & 0x0f) + '0' );
 }


void main(int argc, char** argv)
{
   mf = fopen(argv[1],"rb");
   if (mf)
   {
    fsz = fsize (mf);
    putc (13); putc (10);
    if ( !strcmp (argv[2],"/x")) for ( ; fsz ; fsz--) hex_byte (fgetc (mf),'X');
    for ( ; fsz ; fsz--) putc (fgetc (mf));
    fclose(mf);
   }
}
