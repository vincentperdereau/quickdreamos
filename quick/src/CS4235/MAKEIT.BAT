@echo off
bcc -O -Oe -Ob -Z -k- -mt -3 -S -w- -I..\..\sdk cs4235.c
tasm cs4235
tlink ..\..\sdk\entry.obj+cs4235.obj,cs4235.exe,,
exe2bin cs4235.exe
del *.obj
del *.map
del *.exe
