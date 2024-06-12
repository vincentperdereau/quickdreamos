@echo off
copy view.c view.bak
make
tinyfs "rm /bin/view"
tinyfs "put view.bin /bin/view"
copy view.bak view.c