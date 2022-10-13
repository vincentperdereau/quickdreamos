@echo off

 bcc +kernel.cfg debugfs.c

 tasm debugfs.asm
 tlink debugfs.obj
 exe2bin debugfs.exe debugfs.bin


 del *.obj
 del *.map
 del *.exe

