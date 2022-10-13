Documentation for CS4235 driver.
Driver written by Heinz.rath  (heinz.rath@gmx.at)
Version V1.0 (1.8.2000)

This driver is based on the infos out of CS4235.PDF (Page 15-20)
from Cirrus Logic.
The driver is hardcoded to the following settings.
   basead=0x220; /* Soundblaster port */
   mpu=0x330;    /* MPU Port */
   wss=0x534;    /* WSS port */
   irq=7;        /* Soundblaster IRQ */
   mpuirq=9;     /* MPU IRQ */
   dma=1;        /* DMA 8-Bit (SB) */
   dma2=4;       /* DMA 16-Bit (WSS Capture) */
   SYNBase is hardcoded to 388
   GAMEPORT is hardcoded to 200

Please change the lines in CS4235.C if your settings are different.

I WILL NOT ACCEPT RESPONSIBILITY FOR ANY KIND OF DAMAGE DUE TO THE
USE OR MISUSE OF THIS DRIVER.!


