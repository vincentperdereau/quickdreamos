; thread.asm
;
; to be continued


task        db 0
n_task      db 0
first_stack dw 0
old_int     dd 0

switch:
 cli
 pusha
 mov sp,cs:first_stack
 mov al,cs:task
 cmp al,cs:n_task
 jne follow
 mov al,0
 mov byte ptr cs:task,0
follow:
 xor ah,ah
 shl ax,7
 add sp,ax
 mov al,20h
 out 20h,al
 inc byte ptr cs:task
 popa
 sti
 iret

int82:
 cmp ah,1
 je function01
 cmp ah,2
 je function02
 cmp ah,3
 je function03
 iret
function01:
 mov cs:n_task,al
 mov cs:first_stack,bx
 push ax ebx es
 mov ax,0
 mov es,ax
 mov ebx,es:[8h*4]
 mov cs:old_int,ebx
 mov ax,cs
 mov word ptr es:[8h*4],offset switch 
 mov es:[8h*4+2],ax
 pop es ebx ax
 iret
function02:
 push ax es ebx
 mov ax,0
 mov es,ax
 mov ebx,cs:old_int
 mov es:[8h*4],ebx
 pop ebx es ax
 iret
function03:
 iret
