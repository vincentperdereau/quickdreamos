
; Driver - Souris PS2
;
; vincentperdereau@gmail.com
;

 .MODEL TINY
 .386


 .CODE

        jmp start_program

print_char:
    mov ah, 0eh                ; TTY function to display character in AL
    int 10h                    ; Make BIOS call
    ret


        WRITE_DEC:                           ; ** Ecriture d'un d‚cimal
                        push    bx           ; ** sur le principe:
                        push    cx           ; ** 1999 = 1000 + 900 + 90 + 9
                        push    dx
                        mov     bx,10
                        xor     cx,cx
                        l1:
                        xor     dx,dx
                        div     bx
                        push    dx
                        inc     cx
                        or      ax,ax
                        jnz     l1
                        l2:
                        pop     ax
                        add     al,'0'
                        mov     ah,0eh
                        int     10h
                        loop    l2
                        pop     dx
                        pop     cx
                        pop     bx
                        ret

start_program:

        mov ax,8
        int 33h
        
        ;retf
        
loopit:        

MOV     CX, 00H
MOV     DX, 3d09H
MOV     AH, 86H
INT     15H

        mov ax,3
        int 33h

mov ax, cx
call WRITE_DEC 

mov al, ' '
call print_char

mov ax, dx
call WRITE_DEC 

mov al, ' '
call print_char

mov ax, bx
call WRITE_DEC 

mov al, 0dh
call print_char 

cmp bl, 1
jne loopit
        

        retf



 END
