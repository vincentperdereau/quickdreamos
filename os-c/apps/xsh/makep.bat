@echo off
bcc +kernel.cfg progman.c
tasm progman.asm
tlink progman.obj
exe2bin progman
rem del *.exe
del *.map
