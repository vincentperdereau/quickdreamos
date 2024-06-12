
; Driver - Souris PS2
;
; vincentperdereau@gmail.com
;

 .MODEL TINY
 .386


 .CODE

HW_EQUIP_PS2     equ 4          ; PS2 mouse installed?
MOUSE_PKT_BYTES  equ 3          ; Number of bytes in mouse packet
MOUSE_RESOLUTION equ 1          ; Mouse resolution 8 counts/mm


        jmp start_program

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; IRQ Handler

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

handler:

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; Data Used By Driver

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

  mpacket       DB      3       DUP (0)
  bytepos       DB      0
  mouse_x       DW      40
  mouse_y       DW      12
  mouse_b1      DB      0
  mouse_b2      DB      0
  horiz_sensitivity     DW      2
  vert_sensitivity      DW      2 
  max_screen_x  DW      79
  max_screen_y  DW      24
  user_handler  DB      0
  is_activated  DB      0
  char          DB      0
  old_offset    DW      2000   ;(x=40 y=14)
  cur_status    DB      0

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; DRIVER MOUSE SHOW

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

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


; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; DRIVER INTERRUPTION 33h

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

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


; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; Initialization

; лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; Function: mouse_initialize
;           Initialize the mouse if present
;
; Inputs:   None
; Returns:  CF = 1 if error, CF=0 success
; Clobbers: AX

mouse_initialize:
    push es
    push bx

    int 11h                    ; Get equipment list
    test ax, HW_EQUIP_PS2       ; Is a PS2 mouse installed?
    jz .no_mouse                ;     if not print error and end

    mov ax, 0C205h              ; Initialize mouse
    mov bh, MOUSE_PKT_BYTES     ; 3 byte packets
    int 15h                    ; Call BIOS to initialize
    jc .no_mouse                ;    If not successful assume no mouse

    mov ax, 0C203h              ; Set resolution
    mov bh, MOUSE_RESOLUTION    ; 8 counts / mm
    int 15h                    ; Call BIOS to set resolution
    jc .no_mouse                ;    If not successful assume no mouse

    ;push cs
    ;pop es                      ; ES = segment where code and mouse handler reside
    mov es, dx

    mov bx, offset mouse_callback_dummy
    mov ax, 0C207h              ; Install a default null handler (ES:BX)
    int 15h                    ; Call BIOS to set callback
    jc .no_mouse                ;    If not successful assume no mouse

    clc                         ; CF=0 is success
    jmp .finished
.no_mouse:
    stc                         ; CF=1 is error
.finished:
    pop bx
    pop es
    ret

; Function: mouse_enable
;           Enable the mouse
;
; Inputs:   None
; Returns:  None
; Clobbers: AX

mouse_enable:
    push es
    push bx

    call mouse_disable          ; Disable mouse before enabling

    ;push cs
    ;pop es
    mov es, dx
    
    mov bx, offset mouse_callback
    mov ax, 0C207h              ; Set mouse callback function (ES:BX)
    int 15h                    ; Call BIOS to set callback

    mov ax, 0C200h              ; Enable/Disable mouse
    mov bh, 1                   ; BH = Enable = 1
    int 15h                   ; Call BIOS to disable mouse

    pop bx
    pop es
    ret

; Function: mouse_disable
;           Disable the mouse
;
; Inputs:   None
; Returns:  None
; Clobbers: AX

mouse_disable:
    push es
    push bx

    mov ax, 0C200h             ; Enable/Disable mouse
    xor bx, bx                  ; BH = Disable = 0
    int 15h                   ; Call BIOS to disable mouse

    mov es, bx
    mov ax, 0C207h              ; Clear callback function (ES:BX=0:0)
    int 15h                    ; Call BIOS to set callback

    pop bx
    pop es
    ret

; Function: mouse_callback (FAR)
;           called by the interrupt handler to process a mouse data packet
;           All registers that are modified must be saved and restored
;           Since we are polling manually this handler does nothing
;
; Inputs:   SP+4  = Unused (0)
;           SP+6  = MovementY
;           SP+8  = MovementX
;           SP+10 = Mouse Status
;
; Returns:  None
; Clobbers: None

ARG_OFFSETS      equ 6          ; Offset of args from BP

mouse_callback:
    push bp                     ; Function prologue
    mov bp, sp
    push ds                     ; Save registers we modify
    push ax
    push bx
    push cx
    push dx

    push cs
    pop ds                      ; DS = CS, CS = where our variables are stored

    mov al,[bp+ARG_OFFSETS+6]
    mov bl, al                  ; BX = copy of status byte
    mov cl, 3                   ; Shift signY (bit 5) left 3 bits
    shl al, cl                  ; CF = signY
                                ; Sign bit of AL = SignX
    sbb dh, dh                  ; CH = SignY value set in all bits
    cbw                         ; AH = SignX value set in all bits
    mov dl, [bp+ARG_OFFSETS+2]  ; CX = movementY
    mov al, [bp+ARG_OFFSETS+4]  ; AX = movementX

    ; new mouse X_coord = X_Coord + movementX
    ; new mouse Y_coord = Y_Coord + (-movementY)
    neg dx
    mov cx, [mouse_y]
    add dx, cx                  ; DX = new mouse Y_coord
    mov cx, [mouse_x]
    add ax, cx                  ; AX = new mouse X_coord

    ; Status
    mov [cur_status], bl         ; Update the current status with the new bits
    
    mov cl, bl
    and cl, 1
    mov cs:mouse_b1, cl 
    
    mov cl, bl
    and cl, 2
    shr cl, 1
    mov cs:mouse_b2, cl
        
    mov cs:mouse_x, ax            ; Update current virtual mouseX coord
    mov cs:mouse_y, dx            ; Update current virtual mouseY coord

    cmp word ptr cs:mouse_x,0
	jge	short @4@422
    mov word ptr cs:mouse_x,0
@4@422:
    mov ax,word ptr cs:mouse_x
    cmp ax,word ptr cs:max_screen_x
	jle	short @4@478
    mov ax,word ptr cs:max_screen_x
    mov word ptr cs:mouse_x,ax
@4@478:
    cmp word ptr cs:mouse_y,0
	jge	short @4@534
    mov word ptr cs:mouse_y,0
@4@534:
    mov ax,word ptr cs:mouse_y
    cmp ax,word ptr cs:max_screen_y
	jle	short @4@590
    mov ax,word ptr cs:max_screen_y
    mov word ptr cs:mouse_y,ax
@4@590:

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

    pop dx                      ; Restore all modified registers
    pop cx
    pop bx
    pop ax
    pop ds
    pop bp                      ; Function epilogue

mouse_callback_dummy:
    retf                        ; This routine was reached via FAR CALL. Need a FAR RET

; Function: print_char
;           Print character on specified page and in a specified color
;           if running in a graphics mode
;
; Inputs:   AL = Character to print
;           BH = Page number
;           BL = foreground color (graphics modes only)
; Returns:  None
; Clobbers: AX

print_char:
    mov ah, 0eh                ; TTY function to display character in AL
    int 10h                    ; Make BIOS call
    ret

; Function: print_word_hex
;           Print a 16-bit unsigned integer in hexadecimal on specified
;           page and in a specified color if running in a graphics mode
;
; Inputs:   AX = Unsigned 16-bit integer to print
;           BH = Page number
;           BL = foreground color (graphics modes only)
; Returns:  None
; Clobbers: Mone

print_word_hex:
    xchg al, ah                 ; Print the high byte first
    call print_byte_hex
    xchg al, ah                 ; Print the low byte second
    call print_byte_hex
    ret

; Function: print_byte_hex
;           Print a 8-bit unsigned integer in hexadecimal on specified
;           page and in a specified color if running in a graphics mode
;
; Inputs:   AL = Unsigned 8-bit integer to print
;           BH = Page number
;           BL = foreground color (graphics modes only)
; Returns:  None
; Clobbers: Mone

print_byte_hex:
    push ax
    push cx
    push bx

    lea bx, [.table]            ; Get translation table address

    ; Translate each nibble to its ASCII equivalent
    mov ah, al                  ; Make copy of byte to print
    and al, 0fh               ;     Isolate lower nibble in AL
    mov cl, 4
    shr ah, cl                  ; Isolate the upper nibble in AH
    xlat                        ; Translate lower nibble to ASCII
    xchg ah, al
    xlat                        ; Translate upper nibble to ASCII

    pop bx                      ; Restore attribute and page
    mov ch, ah                  ; Make copy of lower nibble
    mov ah, 0eh
    int 10h                    ; Print the high nibble
    mov al, ch
    int 10h                    ; Print the low nibble

    pop cx
    pop ax
    ret
.table: db "0123456789ABCDEF", 0

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
        
        mov ah,10h
        mov si,offset string1
        int 44h

        mov bx,offset start_program
        sub bx,offset handler
        shr bx,4
        inc bx
        mov ah,0012h
        int 44h

        cli
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
        mov word ptr es:[33h*4],offset driver

        call mouse_initialize
        jc .no_mouse2                ; If CF set then error, inform user and end
        call mouse_enable           ; Enable the mouse
        
        jmp next2

.no_mouse2:
        mov ah,10h
        mov si,offset noMouseMsg
        int 44h
        jmp end_program

next2:

end_program:

        sti
         
        retf

        string1     DB 13,10,"ps2mouse: mouse driver v0.1",0
        string2     DB 13,10,"ps2mouse: already installed",0
        noMouseMsg  DB 13,10,"ps2mouse: Error setting up & initializing mouse",0


 END
