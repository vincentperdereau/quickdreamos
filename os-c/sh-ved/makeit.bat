@echo off

 bcc +kernel.cfg sh.c

 tasm sh.asm
 tlink sh.obj
 exe2bin sh.exe sh.bin


 del *.obj
 del *.map
 del *.exe

