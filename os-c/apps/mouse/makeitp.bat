@echo off

tasm ps2mouse
tlink ps2mouse
exe2bin ps2mouse

rem del *.exe
del *.map
tinyfs "rm /dev/ps2mouse"
tinyfs "put ps2mouse.bin /dev/ps2mouse"
