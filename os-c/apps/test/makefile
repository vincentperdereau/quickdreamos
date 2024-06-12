
projet  = view
cc      = bcc
as      = tasm
ld      = tlink
bin     = exe2bin
arg     = -S -zDVP -zTVP -3 -O2 -Fs -I. -H-
arglib  = -S -zDVP -zTVP -3 -O2 -Fs -I. -H-

$(projet).c:
 copy $(projet).c $(projet).bak
 $(cc) $(arglib) stdio.c
 $(cc) $(arg) stdio.c $(projet).c
 $(as) $(projet).asm
 $(ld) entry.obj memory.obj string.obj stdio.obj v16colca.obj $(projet).obj,$(projet).exe
 $(bin) $(projet).exe $(projet).bin
 del $(projet).map
 del $(projet).obj
 
