@echo off
bcc +kernel.cfg xsh.c
tasm xsh.asm
tlink xsh.obj v16colca.obj
exe2bin xsh
rem del *.exe
del *.map
rem tinyfs "rm /bin/xsh"
rem tinyfs "put xsh.bin /bin/xsh"
