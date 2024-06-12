@echo off
bcc +kernel.cfg dock.c
tasm dock.asm
tlink dock.obj
exe2bin dock
rem del *.exe
del *.map
tinyfs "rm /qwin/dock"
tinyfs "put dock.bin /qwin/dock"
