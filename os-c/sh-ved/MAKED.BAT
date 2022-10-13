@echo off

 bcc +kernel.cfg ved.c

 tasm ved.asm
 tlink ved.obj
 exe2bin ved.exe ved.bin


 del *.obj
 del *.map
 del *.exe

