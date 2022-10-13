@echo off

 bcc +kernel.cfg vasm.c

 tasm vasm.asm
 tlink vasm.obj 
 exe2bin vasm.exe vasm.bin


 del vasm.obj
 del *.map
 del *.exe

