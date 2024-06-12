@echo off

tasm ps2m
tlink ps2m
exe2bin ps2m

rem del *.exe
del *.map
tinyfs "rm /dev/ps2mouse"
tinyfs "put ps2m.bin /dev/ps2mouse"


tasm ps2mtest
tlink ps2mtest
exe2bin ps2mtest

rem del *.exe
del *.map
tinyfs "rm /bin/mt"
tinyfs "put ps2mtest.bin /bin/mt"