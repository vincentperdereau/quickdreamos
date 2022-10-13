; ** reboot.s

 .byte $ea     ; \
 .word $0000   ;  > JMP FFFF:0000 [ address start for x86 ]
 .word $ffff   ; /
