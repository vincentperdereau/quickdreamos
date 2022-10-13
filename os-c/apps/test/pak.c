/*
   pak.c:
   $Id:
 */

#include <stdio.h>
#include <memory.h>

FILE *input, *output;
unsigned char* buffer;
unsigned int offset;
int i;
int header;
int shift;
unsigned long fsz;
unsigned long paksize;
static unsigned long isize;
char fnm [12];

void main (int argc, char **argv)
{
 if (argc == 1)
 {
  printf ("\nsyntax: %s [+v] [+x] [-h] file1 file2 filepak",argv[0]);
  printf ("\nwhere: +v = listing of archive files");
  printf ("\n       +x = extract arhives files");
  printf ("\n       -h = archive without header (concat)");  
  return;
 }
 header = 12;
 i = 1;
 shift = 4;
 if ( argv[1][0] == '-')
 {
  header = 0;
  i = 2;
  shift = 0;
 }

 if ( argv[1][0] == '+')
 {
  input = fopen (argv[2],"rb");
  paksize = fsize (input);

  do {
  memcpy (_CS,(unsigned int)fnm,input->bseg,input->bofs,12);
  memcpy (_CS,(unsigned int)&fsz,input->bseg,input->bofs+12,4);
  printf ("\n %s",fnm);

  if ( argv[1][1] != 'v')
  {
   output = fopen (fnm,"wb");
   if (output == NULL) {
                        printf ("\n ** can't create %s",fnm);
                        fclose (output);
                        fclose (input);
                        return ;
                       }
   memcpy (output->bseg,output->bofs,input->bseg,input->bofs + 12 + 4,fsz);
   output->size = fsz;
   fclose (output);
  }
  input->bofs += (fsz + 12 + 4);
  } while ( (unsigned long)(input->bofs != paksize ));
  fclose (input);
  return ;
 }

 output = fopen (argv[argc-1],"wb");
 if (output==NULL) {
                     printf ("\n ** can't create .pak");
                     fclose (output);
                     return;
                   }
 offset = 0;
 printf ("\n%s:",argv[argc-1]);
 for (; i <= (argc-2); i++)
 {
  printf ("\n + %s",argv[i]);
  input = fopen (argv[i],"rb");
  if (input==NULL) {
                     printf ("\n ** can't open %s <%u>",argv[i],i);
                     fclose (input);
                     continue;
                   }
  memcpy (output->bseg,output->bofs,_CS,(unsigned int)argv[i],header);
  isize = input->size;
  memcpy (output->bseg,output->bofs+header,(unsigned int)_CS,(unsigned int)&(isize),4);
  memcpy (output->bseg,output->bofs+header + shift,input->bseg,input->bofs,input->size);
  output->bofs += (input->size + header + shift);
  output->size = output->bofs;
  fclose (input);                               
 }
 printf ("\n -> packed %u bytes",(output->size));
 fclose (output);
}
