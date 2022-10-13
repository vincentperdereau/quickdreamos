.silent
projet  = test
cc      = bcc
as      = tasm
ld      = tlink
bin     = exe2bin
arg     = -S -zDVP -zTVP -3 -O2 -Fs -I. -H-

$(projet).c:
 copy $(projet).c $(projet).bak
 $(cc) $(arg) $(projet).c
 $(as) $(projet).asm
 $(ld) entry.obj string.obj memory.obj stdio.obj $(projet).obj,$(projet).exe
 $(bin) $(projet).exe $(projet).bin
 del $(projet).map
 del $(projet).obj

