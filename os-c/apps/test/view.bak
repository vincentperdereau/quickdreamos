#include <stdio.h>
#include <memory.h>
#include "quickwin.h"

#define BUTTON_ID1 1

#define bool int
#define true 1
#define false 0

typedef unsigned char  byte;
typedef unsigned short word;
typedef unsigned long  dword;

extern void setpix1( int x, int y, unsigned char couleur);
extern void setpix2( int x, int y, unsigned char couleur);

HWND FormWnd; 

FILE *input;
unsigned char far* buffer;
unsigned long filesize;

void far WinMain (void)
{
 FuncEntry
          
  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   close
  }

 FuncEnd
}

char* filename;
unsigned long width, height, szImage;
unsigned int colorsBits, colors;
unsigned char pixel;

int orgX, orgY;
int x, y;
unsigned int picI = 0;
unsigned char red, green, blue;
unsigned char maskJ;
unsigned int offsetBuffer;
unsigned int offsetPal;
bool unusedMask = false;
unsigned int originalWidth;

unsigned char color16palMapping[16] = {0,1,2,3,4,5,14,7,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F};

void setpix (int x, int y, unsigned char couleur)
{
 if (getmode() == 1)
  setpix1 (x,y,couleur);
 else
  setpix2 (x,y,couleur);
}

void setPal(unsigned char pixel, unsigned char r, unsigned char g, unsigned char b) 
{
    asm {
        mov dx, 0x3c6
        mov al, 0xff
        out dx, al
        mov dx, 0x3c8
        mov al, pixel
        out dx, al
        inc dx
        mov al, r 
        out dx, al
        mov al, g
        out dx, al
        mov al, b
        out dx, al
    }
}

void StartProgram (int argc, char **argv)
{
 if (argc < 2)
    return;
        
 printf("\nFile name=%s", argv[1]);
 input = fopen (argv[1],"rb");

 if (input == 0) 
 {
    printf ("\n ** can't read %s.", argv[1]);
    return ;
 }

 filesize = fsize (input);     
 printf("\nFile size=%u", filesize);  
 buffer = (unsigned char far*) (input->bseg * 65536 + input->bofs);
 
 if ((buffer[0] != 'B') && (buffer[0] != 'M'))
 {
    printf ("\n ** BMP signature not found.");
    return ;
 }
 
 printf("\nBMP header = %c%c", buffer[0], buffer[1]);
 memcpy (_CS,(unsigned int)&width,input->bseg,input->bofs + 0x12,4);
 memcpy (_CS,(unsigned int)&height,input->bseg,input->bofs + 0x16,4);
 memcpy (_CS,(unsigned int)&szImage,input->bseg,input->bofs + 0x22,4);
 memcpy (_CS,(unsigned int)&colorsBits,input->bseg,input->bofs + 0x1c,2);
 switch(colorsBits) {
     case 1: colors = 2; break;
     case 4: colors = 16; break;
     case 8: colors = 256; break;
 }              
 printf("\nBMP width = %u", width);
 printf("\nBMP height = %u", height);
 printf("\nBMP size = %u", szImage);
 printf("\nBMP colors bits = %u", colorsBits);
 printf("\nBMP colors = %u", colors);

 orgX = 100; x = orgX + 10;
 orgY = 260; y = orgY + height + 24;
 
 FormWnd = CreateWindow (orgX,orgY,width + 12,height + 32,argv[1],&WinMain);
 orgX += 3;
 x += 3;

 unusedMask = false;
 if (colors == 16)
 {
    if ((width % 8) != 0)
    {
       unusedMask = true;
       originalWidth = width;
       width = ((width / 8) + 1) * 8;
       printf("\nBMP recalculated width = %u", width);
    }  
 }

 printf("\nBMP unusedMask = %u", unusedMask);
 
 offsetPal = 54;
 offsetBuffer = offsetPal + (colors * 4);
 
 for (picI = 0; picI < colors; picI++) 
 {
    pixel = picI;
    red = buffer[offsetPal + 2 + (pixel * 4)] >> 2;
    green = buffer[offsetPal + 1 + (pixel * 4)] >> 2;
    blue = buffer[offsetPal + 0 + (pixel * 4)] >> 2;   
    setPal(color16palMapping[pixel], red, green, blue);
 }

 for (picI = 0; picI <= szImage; picI++) 
 {
     if (colors == 2)
     {
        for (maskJ = 0; maskJ <= 7; maskJ++)
        {
            pixel = (buffer[offsetBuffer + picI] & (128 >> maskJ));
            if (pixel) 
               pixel = 15;
            setpix(x, y, pixel);
            x = x + 1;
            if (x == (orgX + 10 + width))
            {
               x = orgX + 10;
               y = y - 1;
            } 
        }
     }
     if ((colors == 16)||(colors == 256))
     {
         if (colors == 256)
            pixel = buffer[offsetBuffer + picI];
         if (colors == 16)
            pixel = buffer[offsetBuffer + picI] >> 4 ;
         
         if (!( (unusedMask == true)&&( x > (orgX + 10 + originalWidth)) ))
         {
            setpix(x, y, pixel);
         }   
         
         x = x + 1;
         if (x == (orgX + 10 + width))
         {
            x = orgX + 10;
            y = y - 1;
         } 
         
         if (colors == 16)
         {
           pixel = (buffer[offsetBuffer + picI] & 0x0f);
           
           if (!( (unusedMask == true)&&( x > (orgX + 10 + originalWidth)) ))
           {
              setpix(x, y, pixel);
           }   

           x = x + 1;
           if (x == (orgX + 10 + width))
           {
              x = orgX + 10;
              y = y - 1;
           }          
           
         }  

         
     }    
     
 }        
 
 fclose(input);
 
}

