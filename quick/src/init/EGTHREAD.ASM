; ** egthread.asm
;
; Exemple d'utilisation des Threads Quick-D

.model tiny
.386

.code

start:

jmp entry

dummy0 db 4 dup (0)           ; ** D‚finition piles des trois taches
stackA db 128 dup (0)         ; ** !: Les trois piles doivent se suivrent
stackB db 128 dup (0)         ; **    et s'‚tendre sur 128 octets
stackC db 128 dup (0)         ; ** 

hex_map db '0123456789ABCDEF'

print_hex_byte:
 push ax
 push bx
 push cx
 mov cl,al
 shr al,4
 xor ah,ah
 mov bx,offset hex_map
 add bx,ax
 mov al,[bx]
 mov es:[di],al
 mov al,cl
 and al,0fh
 mov bx,offset hex_map
 add bx,ax
 mov al,[bx]
 add di,2
 mov es:[di],al
 sub di,2
 pop cx
 pop bx
 pop ax
 ret

; ** taskA: horloge

taskA:                        ; ** premiŠre tache
 sti                          ; ** doit obligatoirement commencer par 'sti'
 mov ax,0b800h
 mov es,ax
 mov di,0
 mov ax,1F20h
 mov cx,80
 rep stosw
 mov byte ptr es:[144],':'
 mov byte ptr es:[150],':'

taskA_l:
 mov al,4
 out 70h,al
 in al,71h
 mov di,140
 cli
 call print_hex_byte
 sti
 mov al,2
 out 70h,al
 in al,71h
 mov di,146
 cli
 call print_hex_byte
 sti
 mov al,0
 out 70h,al
 in al,71h
 mov di,152
 cli
 call print_hex_byte
 sti
 mov cl,al
 shr al,4
 xor ah,ah
 mov bx,offset hex_map
 add bx,ax
 mov al,[bx]
 mov es:[di],al
 mov al,cl
 and al,0fh
 mov bx,offset hex_map
 add bx,ax
 mov al,[bx]
 add di,2
 mov es:[di],al
 sub di,2

 jmp taskA_l                  ; boucle infini

; ** taskB: attend la pression de la touche ESC

taskB_msg$ db "** press ESC to quit **",0

taskB:
 sti
 mov ax,cs
 mov ds,ax
 mov ax,0b800h
 mov es,ax
 mov di,10*160+56
 mov si,offset taskB_msg$
 taskB_loop:
 mov al,[si]
 or al,al
 jz taskB_l
 mov es:[di],al
 add di,2
 inc si
 jmp taskB_loop
taskB_l:
 in al,60h
 cmp al,1
 je is_esc
 jmp taskB_l
is_esc:
 cli
 jmp itwas

; ** taskC: le mini scrolling

taskC_msg$ db " ** QuickDreamOS - thread management ** ",0

taskC:
 sti
 mov ax,0b800h
 mov es,ax
 mov di,24*160
 mov ax,cs
 mov ds,ax
 mov si,offset taskC_msg$
 mov bx,0
taskC_l:

 mov si,offset taskC_msg$
 mov dx,di
 taskC_write:
 mov al,[si]
 or al,al
 jz taskC_write_end
 mov es:[di],al
 inc si
 add di,2
 jmp taskC_write
taskC_write_end:
 mov di,dx

 mov cx,0ffffh
 .l:
 loop .l
 mov cx,0ffffh
 .l2:
 loop .l2


 inc bx
 add di,2
 cmp bx,79
 jne taskC_l
 mov bx,0
 mov di,24*160
 jmp taskC_l


_ip equ 10h
_cs equ 10h+2
_ax equ 10h-2
_cx equ 10h-4
_dx equ 10h-6
_bx equ 10h-8
_bp equ 10h-12
_si equ 10h-14
_di equ 10h-16

stack_pointer dw 0
stack_segment dw 0

entry:

 mov ax,3
 int 10h

 cli

 mov ax,ss                         ; ** on sauvegarde SS:SP
 mov cs:stack_segment,ax           ;
 mov ax,sp                         ;
 mov cs:stack_pointer,ax           ;

 mov ax,cs
 mov ds,ax
 mov ss,ax
 mov sp,5000h                      ; ** on fixe une nouvelle pile

 mov ah,1                          ; ** fonction 1: initialisation
 mov al,3                          ; ** al = nombre de taches ( 3 )
 mov bx,offset stackA              ; ** bx = offset de la pile pour
 int 82h                           ; **      la premiere tache

 mov bx,offset stackA                ; ** on configure les piles
 mov word ptr [bx+_ip],offset taskA  ; ** CS:IP des taches
 mov ax,cs
 mov cl,'A'
 mov [bx+_cx],cx
 mov word ptr [bx+_cs],ax

 mov bx,offset stackB
 mov word ptr [bx+_ip],offset taskB
 mov ax,cs
 mov cl,'B'
 mov [bx+_cx],cx
 mov word ptr [bx+_cs],ax

 mov bx,offset stackC
 mov word ptr [bx+_ip],offset taskC
 mov ax,cs
 mov cl,'C'
 mov [bx+_cx],cx
 mov word ptr [bx+_cs],ax

 jmp flush_queue
flush_queue:

 sti                                  ; ** pret … utiliser la switch

 inf:                                 ; ** 
 jmp inf

itwas:

 cli                                  ; ** stoppe le switch

 mov ah,2                             ; ** d‚truit le switch
 int 82h

 mov ax,cs:stack_segment              ; ** on restaure la pile
 mov ss,ax
 mov ax,cs:stack_pointer
 mov sp,ax

 sti

 mov ax,3
 int 10h

 retf                                 ; ** quitte

end start
