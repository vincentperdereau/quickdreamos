; ** mouse.s
; ** test mouse driver services

jmp .entry  ; ** jump to the entry point

.msg:
; .word $ad
 .string "** click your mouse to leave the test **"
 .byte 0

.error:
; .word $ad
 .string "no mouse driver detected!"
 .byte 0

.entry:

; ** first of all, check Xsh isn't in usage
 mov ah,4     ; ** function 04
 int $46      ; ** int x46: Xsh services
 cmp ah,1     ; ** 1 = Xsh present
 je .end      ; ** then quit

; ** check mouse driver
 mov ax,0     ; ** function 00: test driver
 int $33      ; ** int x33: mouse driver services
 cmp ax,$ffff   ; ** flag xffff -> driver present
 je .driver     ; ** we can continue
 mov ah,$10     ; ** else, print error message (service x10, int x44)
 mov si,offset .error 
 int $44     ; ** kernel services
 jmp .end    ; ** quit

.driver:

 mov ax,cs
 mov ds,ax

 mov ah,$10
 mov si,offset .msg
 int $44

 mov ax,8  ; ** function 08: show mouse in text mode
 int $33   ; 

.lp:
 mov ax,3  ; ** function 03: get mouse status ( (cx,dx,bx) = (x,y,buttons) )
 int $33
 nop
 or bx,bx  ; ** bx = 0 means no button pressed!
 jz .lp   ; ** in this case, we continue (loop)

 mov ax,2  ; ** function 02: hide mouse
 int $33

 mov ax,7 ; ** function 07: shut mouse
 int $33

.end:
 retf
