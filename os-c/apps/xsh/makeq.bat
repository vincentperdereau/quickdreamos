@echo off
bcc +kernel.cfg %1.c
tasm %1.asm
tlink %1.obj
exe2bin %1
rem del *.exe
del *.map
tinyfs "rm /qwin/%1"
tinyfs "put %1.bin /qwin/%1"
