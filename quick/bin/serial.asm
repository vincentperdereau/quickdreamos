
; Driver - Souris s‚rie COM1
;
; vincent.perdereau@lemel.fr
;

 .MODEL TINY
 .386


 .CODE

 port_com1              EQU             03f8h
 port_pic_master        EQU             0021h
 IRQ_mask               EQU             0010h
 intIRQ                 EQU             000ch        

        jmp start_program

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

; IRQ Handler

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

handler:

        cli

        push ax bx cx dx

        mov dx,port_com1
        in al,dx

        test al,64
        jz @sync
        mov byte ptr cs:bytepos,0
@sync:
        mov bx,offset mpacket
        add bl,cs:bytepos
        mov cs:[bx],al
        inc cs:bytepos

        cmp byte ptr cs:bytepos,3
        jne @end_handler

        mov cl,cs:mpacket
        xor ch,ch
        and cx,3
        shl cx,6
        mov al,cs:mpacket+1
        mov ah,0
        add cx,ax

        mov dl,cs:mpacket
        xor dh,dh
        and dx,12
        shl dx,4
        mov al,cs:mpacket+2
        mov ah,0
        add dx,ax

        cmp cx,128
        jl no_add_cx
        add cx,-256
no_add_cx:
        cmp dx,128
        jl no_add_dx
        add dx,-256
no_add_dx:

;        cmp     cs:is_activated,1
;        jne     @end_handler

        mov ax,cx
        mov bx,dx
        cwd
        idiv word ptr cs:horiz_sensitivity
        add cs:mouse_x,ax

        mov ax,bx
        cwd
        idiv word ptr cs:vert_sensitivity
        add cs:mouse_y,ax


        cmp     word ptr cs:mouse_x,0
	jge	short @4@422
        mov     word ptr cs:mouse_x,0
@4@422:
        mov     ax,word ptr cs:mouse_x
        cmp     ax,word ptr cs:max_screen_x
	jle	short @4@478
        mov     ax,word ptr cs:max_screen_x
        mov     word ptr cs:mouse_x,ax
@4@478:

        cmp     word ptr cs:mouse_y,0
	jge	short @4@534
        mov     word ptr cs:mouse_y,0
@4@534:
        mov     ax,word ptr cs:mouse_y
        cmp     ax,word ptr cs:max_screen_y
	jle	short @4@590
        mov     ax,word ptr cs:max_screen_y
        mov     word ptr cs:mouse_y,ax
@4@590:
        mov     al,byte ptr cs:mpacket
	and	al,32
        shr     al,5
        mov     byte ptr cs:mouse_b1,al
        mov     al,byte ptr cs:mpacket
	and	al,16
        shr     al,4
        mov     byte ptr cs:mouse_b2,al

        mov     byte ptr cs:bytepos,0
@4@618:
        

@end_handler:
            
        mov al,20h
        out 20h,al

        sti

        cmp cs:user_handler,0
        jz @next

        mov     bl,cs:mouse_b2
        shl     bl,1
        add     bl,cs:mouse_b1
        xor     bh,bh
        mov     cx,cs:mouse_x
        mov     dx,cs:mouse_y

        db 9Ah
        user_offset     DW      ?
        user_segment    DW      ?

@next:
        pop dx cx bx ax
        iret

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

; Data Used By Driver

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

  mpacket       DB      3       DUP (0)
  bytepos       DB      0
  mouse_x       DW      40
  mouse_y       DW      12
  mouse_b1      DB      0
  mouse_b2      DB      0
  horiz_sensitivity     DW      4
  vert_sensitivity      DW      4 
  max_screen_x  DW      79
  max_screen_y  DW      24
  user_handler  DB      0
  is_activated  DB      0
  char          DB      0
  old_offset    DW      2000   ;(x=40 y=14)

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

; DRIVER MOUSE SHOW

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

show_mouse:

        push ax bx cx dx es di si
        mov ax,0b800h
        mov es,ax
        shl cx,1
        mov di,cx
        mov ax,dx
        mov bx,160
        mul bx
        add di,ax

        mov si,cs:old_offset
        mov al,cs:char
        mov es:[si],al

        mov cs:old_offset,di
        mov al,es:[di]
        mov cs:char,al

        mov byte ptr es:[di],""
        pop si di es dx cx bx ax
        retf


; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

; DRIVER INTERRUPTION 33h

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

driver:
        cli
        cmp ax,0000h
        je function_0000
        cmp ax,0001h
        je function_0001
        cmp ax,00002h
        je function_0002
        cmp ax,0003h
        je function_0003
        cmp ax,0004h
        je function_0004
        cmp ax,0005h
        je function_0005
        cmp ax,0006h
        je function_0006
        cmp ax,0007h
        je function_0007
        cmp ax,0008h
        je function_0008

        jmp end_driver

function_0000:
        mov ax,0ffffh
        jmp end_driver
function_0001:
        mov cs:user_offset,bx
        mov cs:user_segment,es
        mov cs:user_handler,1
        jmp end_driver
function_0002:
        mov cs:user_handler,0
        jmp end_driver
function_0003:
        mov cx,cs:mouse_x
        mov dx,cs:mouse_y
        mov bl,cs:mouse_b2
        shl bl,1
        add bl,cs:mouse_b1
        xor bh,bh
        jmp end_driver
function_0004:
        mov cs:max_screen_x,bx
        mov cs:max_screen_y,cx
        dec cs:max_screen_x
        dec cs:max_screen_y
        mov cs:mouse_x,bx
	mov cs:mouse_y,cx
	shr cs:mouse_x,1
        shr cs:mouse_y,1
	jmp end_driver
function_0005:
        mov cs:horiz_sensitivity,bx
        mov cs:vert_sensitivity,cx
        jmp end_driver
function_0006:
        mov cs:is_activated,1
        jmp end_driver
function_0007:
        mov cs:is_activated,0
        jmp end_driver
function_0008:

        push ax
        mov cs:max_screen_x,80
        mov cs:max_screen_y,25
        dec cs:max_screen_x
        dec cs:max_screen_y
        mov cs:mouse_x,80
        mov cs:mouse_y,25
	shr cs:mouse_x,1
        shr cs:mouse_y,1

        mov cs:horiz_sensitivity,2
        mov cs:vert_sensitivity,4

        mov ax,cs
        mov cs:user_offset,offset show_mouse
        mov cs:user_segment,ax
        mov cs:user_handler,1

        mov ax,0b800h
        mov es,ax
        mov al,es:[2000h]
        mov cs:char,al

        mov cs:is_activated,1

        pop ax
        jmp end_driver

end_driver:

        sti
        iret


; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

; COM1: Initialization

; ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ

start_program:

        mov ax,0
        int 33h
        cmp ax,0ffffh
        jne next
        mov ah,10h
        mov si,offset string2
        int 44h

        retf
next:
        mov dx,port_com1 + 3
        mov al,0080h
        out dx,al
        mov dx,port_com1 + 0
        mov al,0060h
        out dx,al
        mov dx,port_com1 + 1
        mov al,0000h
        out dx,al
        mov dx,port_com1 + 3
        mov al,0002h
        out dx,al
        mov dx,port_com1 + 1
        mov al,0000h
        out dx,al
        mov dx,port_com1 + 4
        mov al,0001h
        out dx,al
        mov dx,port_com1 + 5
        in  al,dx
        mov dx,port_com1 + 1
        mov al,0001h
        out dx,al
        mov dx,port_com1 + 4
        mov al,000bh
        out dx,al

        mov dx,port_pic_master
        in  al,dx
        xor al,IRQ_mask
        out dx,al

        cli
        xor ax,ax
        mov es,ax
        mov bx,intIRQ * 4
        mov word ptr es:[bx],offset handler
        mov ax,cs
;        mov es:[bx+2],ax
;        sti

        mov word ptr es:[33h*4],offset driver
;        mov es:[33h*4+2],ax

        mov ah,10h
        mov si,offset string1
        int 44h

        mov bx,offset start_program
        sub bx,offset handler
        shr bx,4
        inc bx
        mov ah,0012h
        int 44h

        mov dx,ax

        mov es,ax
        mov di,0
        mov ax,cs
        mov ds,ax
        mov si,0
        mov cx,bx
        shl cx,4
        rep movsb

        mov ax,0
        mov es,ax
        mov es:[33h*4+2],dx

        mov bx,intIRQ * 4
        mov es:[bx+2],dx

        sti
        retf

        string1  DB 13,10,"cua0: serial mouse driver v0.4",0
        string2  DB 13,10,"cua0: already installed",0


 END
