; mmu.asm: memory management unit
;
; vincent.perdereau@voila.fr
;
; no comments for moment.
;

jmp mmu_start

MemoryControlBlock struc
;state           db 0 
;size_pg         dw 0
;owner           db 12 dup (0)
;                db 0
ends

mmu_mcb_entry equ 2000h
mmu_mcb_used  equ 'V'
mmu_mcb_last  equ 'P'
mmu_mcb_free  equ 'Z'

mmu_malloc:
 push ds es bx cx dx si di

 add cs:block_memory_used,bx

 mov dx,bx

 mov ax,mmu_mcb_entry
 mov es,ax
 mov bx,ax

mmu_mcb_chain:
 mov al,es:[0]
 cmp al,mmu_mcb_last
 je mmu_mcb_found_last
 cmp al,mmu_mcb_free
 je mmu_mcb_found_free

mmu_mcb_chain_l1:

 mov cx,es:[1]
 add bx,cx
 inc bx
 mov es,bx
 jmp mmu_mcb_chain

mmu_mcb_found_free:
 mov cx,es:[1]
 cmp cx,dx
 jl mmu_mcb_chain_l1
 mov byte ptr es:[0],mmu_mcb_used
 mov es:[1],dx
 mov si,offset progname
 cmp cx,dx
 je mmu_mcb_found_free_equal

 mov bx,es
 sub cx,dx
 dec cx
 mov ax,es
 add ax,dx
 inc ax
 mov es,ax
 mov byte ptr es:[0],mmu_mcb_free
 mov es:[1],cx

mmu_mcb_found_free_equal:

 mov es,bx
 mov ax,2000h
 mov ds,ax
 mov di,3
 mov cx,12
 rep movsb

 mov ax,bx
 inc ax
 pop di si dx cx bx es ds
 ret

mmu_mcb_found_last:
 mov byte ptr es:[0],mmu_mcb_used
 mov cx,es:[1]
 mov ax,bx
 add ax,cx
 inc ax
 mov es,ax
 mov byte ptr es:[0],mmu_mcb_last
 mov es:[1],dx

 mov ax,2000h
 mov ds,ax
 mov si,offset progname
 mov di,3
 mov cx,12
 rep movsb

 mov ax,es
 inc ax
 pop di si dx cx bx es ds
 ret

mmu_free:
 push es bx cx dx di

 dec bx
 mov di,bx
 mov es,bx
 mov al,es:[0]
 cmp al,mmu_mcb_used
 je mmu_free_mcb_used
 cmp al,mmu_mcb_last
 je mmu_free_mcb_last
 mov ax,1
 pop di dx cx bx es
 ret

mmu_free_mcb_last:

 mov ax,es:[1]
 sub cs:block_memory_used,ax

 mov ax,mmu_mcb_entry
 mov es,ax
 mmu_free_mcb_last_loop:
 mov al,es:[0]

 mov cl,al

 cmp al,mmu_mcb_last
 je mmu_free_mcb_last_found
 mov bx,es:[1]
 inc bx
 mov ax,es
 add ax,bx

 cmp cl,mmu_mcb_used
 jne mmu_free_mcb_last_not_used
 mov dx,es
mmu_free_mcb_last_not_used:

 mov es,ax
 jmp mmu_free_mcb_last_loop
mmu_free_mcb_last_found:
 
 mov es,dx
 mov byte ptr es:[0],mmu_mcb_last
 mov es,di
 mov byte ptr es:[0],mmu_mcb_free
 mov ax,0
 pop di dx cx bx es
 ret

mmu_free_mcb_used:

 mov ax,es:[1]
 sub cs:block_memory_used,ax

 mov byte ptr es:[0],mmu_mcb_free
 mov ax,0
 pop di dx cx bx es
 ret

mmu_init:
 mov ax,mmu_mcb_entry
 mov es,ax
 mov byte ptr es:[0],mmu_mcb_last
 mov bx,offset eof
 shr bx,4
 inc bx
 mov cs:block_memory_used,bx
 mov es:[1],bx
 mov cx,12
 mov ax,cs
 mov ds,ax
 mov si,offset mcb1$
 mov di,3
 rep movsb
 ret

 mcb1$ db "kernel"
       db 6 dup (0)

block_memory_used  dw 0


mmu_start:
