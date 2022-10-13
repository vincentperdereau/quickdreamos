@echo off
bcc +kernel.cfg ng.c
tasm ng.asm
tlink ng.obj v16colca.obj
exe2bin ng
rem del *.exe
del *.map

rem tinyfs "rm /bin/xsh"
rem tinyfs "put xsh.bin /bin/xsh"
