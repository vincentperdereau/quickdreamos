; ** sysinfo.s
; ** Get System Informations

jmp .entry

.print_int:   ; ** print a decimal ( ax=number )
 push ax      ; ** 123 = 1 * 100
 push bx      ;         +2 * 10
 push cx      ;         +3 * 1
 mov bx,10
 xor cx,cx
.print_int_l1:
 xor dx,dx
 div bx
 push dx
 inc cx
 or ax,ax
 jnz .print_int_l1
.print_int_l2:
 pop ax
 add al,'0'
 int $29
 loop .print_int_l2
 pop cx
 pop bx
 pop ax
 ret

.msg1:
 .word $0a0d
 .string "you'are running under a ?86 with "
 .byte 0

.entry:

 mov ax,cs  ; ** all segments equals
 mov es,ax
 mov ds,ax

 mov ah,$19   ; ** function $19: get sys infos
 int $44      ; ** kernel
 mov ax,$2000  ; ** x2000:SI = pointer to the sys block.
 mov ds,ax
; add si,0  ; ** first entry indicates the processor id.
 mov al,[si]   ; ** [al]86

 inc si ; [si+1] = himemKB
 mov bx,[si]

 mov si,offset .msg1
 add si,26 ; ** the '?'
 .es
 mov [si],al ; ** change '?' with 'al'

 mov ax,cs   ; ** restore DS
 mov ds,ax   ;

 mov ah,$10 ; ** function $10: print a string
 mov si,offset .msg1
 int $44   

 mov ax,bx
 call .print_int ; ** write ax

 mov al,'K' ; ** add 'K'
 int $29 ; ** int x29: fast console output, used for TTY

 retf
