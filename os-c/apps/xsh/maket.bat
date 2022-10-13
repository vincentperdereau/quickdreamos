@echo off
bcc +kernel.cfg test.c
tasm test.asm
tlink test.obj
exe2bin test
rem del *.exe
del *.map
rem tinyfs "rm /bin/test"
rem tinyfs "put test.bin /bin/test"
