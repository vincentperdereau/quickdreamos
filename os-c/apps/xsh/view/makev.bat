@echo off
bcc +kernel.cfg memory.c
bcc +kernel.cfg stdio.c
bcc +kernel.cfg string.c
bcc +kernel.cfg view.c
tasm view.asm
tlink view.obj,view.exe
exe2bin view
rem del *.exe
del *.map
tinyfs "rm /bin/view"
tinyfs "put view.bin /bin/view"
