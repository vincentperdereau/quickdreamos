; le classique programme 'HelloWorld' sous DreamOS
; compilation: as test.asm (sous DreamOS)
; execution: ./test (toujours sous DreamOS)

 jmp start

msg:
 .word $0a0d
 .string "Hello World!"
 .byte 0

start:
 mov ah,$10
 mov si,offset msg
 int $44

 retf

