/* Plug and Play driver for Soundcards with CS4235 chipset
   Based on CS4235.PDF from Cirrus Logic.
   Written by Heinz Rath
   E-Mail: heinz.rath@gmx.at
   Version 1.0 (1.8.2000)
*/
void outb(int port,unsigned char data)
{
  asm {
   push ax
   push dx
    mov al,data
    mov dx,port
    out dx,al
   pop dx
   pop ax
  }
}
unsigned char hi(int val)
{
  return(val >> 8);
}
unsigned char lo(int val)
{
  return(val & 0xFF);
}

main()
{
   unsigned char dma,dma2,irq,mpuirq;
   unsigned basead,mpu,wss;
   int i;
   /* The writeing of unsigned char key[33]={....
      made a link error so i use now this method.
   */
   unsigned char key[33];
/*-------------------------------------------------------------------------*/
   /* Definations of settings of soundcard */
   basead=0x220; /* Soundblaster port */
   mpu=0x330;    /* MPU Port */
   wss=0x534;    /* WSS port */
   irq=7;        /* Soundblaster IRQ */
   mpuirq=9;     /* MPU IRQ */
   dma=1;        /* DMA 8-Bit (SB) */
   dma2=4;       /* DMA 16-Bit (WSS Capture) */
/*-------------------------------------------------------------------------*/
   key[0]=0x96;
   key[1]=0x35;
   key[2]=0x9A;
   key[3]=0xCD;
   key[4]=0xE6;
   key[5]=0xF3;
   key[6]=0x79;
   key[7]=0xBC;
   key[8]=0x5E;
   key[9]=0xAF;
   key[10]=0x57;
   key[11]=0x2B;
   key[12]=0x15;
   key[13]=0x8A;
   key[14]=0xC5;
   key[15]=0xE2;
   key[16]=0xF1;
   key[17]=0xF8;
   key[18]=0x7C;
   key[19]=0x3E;
   key[20]=0x9F;
   key[21]=0x4F;
   key[22]=0x27;
   key[23]=0x13;
   key[24]=0x09;
   key[25]=0x84;
   key[26]=0x42;
   key[27]=0xA1;
   key[28]=0xD0;
   key[29]=0x68;
   key[30]=0x34;
   key[31]=0x1A;
   /* Sending of Magic key */
   for (i=0;i<32;i++)
   {
     outb(0x279,key[i]);
   }
   outb(0x279,0x6);/* Card Select Number */
   outb(0x279,0x1);
   outb(0x279,0x15); /* Logical Device 0 */
   outb(0x279,0x00); /* Device number (0-5) */
   outb(0x279,0x47); /* WSS Base */
   outb(0x279,hi(wss));
   outb(0x279,lo(wss));
   outb(0x279,0x48); /* SYNbase */
   outb(0x279,0x03); /* 388 */
   outb(0x279,0x88);
   outb(0x279,0x42); /* SBbase */
   outb(0x279,hi(basead)); /* Set Base Adress */
   outb(0x279,lo(basead));
   outb(0x279,0x22); /* IRQ */
   outb(0x279,irq);
   outb(0x279,0x2A); /* DMA (8-Bit) */
   outb(0x279,dma);
   outb(0x279,0x25); /* WSS capture DMA */
   outb(0x279,dma2);
   outb(0x279,0x33); /* Activate */
   outb(0x279,0x01);
   outb(0x279,0x15); /* Logical Device 1 */
   outb(0x279,0x01); /* Device number (0-5) */
   outb(0x279,0x47); /* GAMEPORT Base */
   outb(0x279,0x02); /* 200 */
   outb(0x279,0x00);
   outb(0x279,0x33); /* Activate */
   outb(0x279,0x01);
   outb(0x279,0x15); /* Logical Device 2 */
   outb(0x279,0x02); /* Device number (0-5) */
   outb(0x279,0x47); /* CTRL Base */
   outb(0x279,0x01); /* 120 */
   outb(0x279,0x20);
   outb(0x279,0x33); /* Activate */
   outb(0x279,0x01);
   outb(0x279,0x15); /* Logical Device 3 */
   outb(0x279,0x03); /* Device number (0-5) */
   outb(0x279,0x47); /* MPU Base */
   outb(0x279,hi(mpu));
   outb(0x279,lo(mpu));
   outb(0x279,0x22); /* MPU Irq */
   outb(0x279,mpuirq);
   outb(0x279,0x33); /* Activate */
   outb(0x279,0x01);
   outb(0x279,0x79); /* Ready... for take off*/
}

