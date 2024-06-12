@echo off
bcc +kernel.cfg xsh.c
tasm xsh.asm
tlink xsh.obj v16colca.obj
exe2bin xsh
rem del *.exe
del *.map
tinyfs "rm /bin/xsh"
tinyfs "put xsh.bin /bin/xsh"
