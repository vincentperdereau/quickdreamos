/*
 * quick/src/kernel/include/typedef.h
 *
 */

 #define        INCLUDE_TYPEDEF_H

 typedef        unsigned        char    UCHAR;   /*  8-bits  */
 typedef        unsigned        int     UINT;    /* 16-bits  */
 typedef        unsigned        long    ULONG;   /* 32-bits  */
 typedef        unsigned        char*   STRING;  
 typedef        unsigned        char    BOOL;
 typedef        void                    PROC;

 #define        OK 1
 #define        ERROR 0  

 #define KERNEL_SEG 0x1000

 #define kpanic(nerr) asm { mov dl,nerr ; int 0x24 };
