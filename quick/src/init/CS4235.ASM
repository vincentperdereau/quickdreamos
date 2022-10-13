;**********************************************************
;**   Initializing of Soundcard with CS4235 Chipset      **
;** This routine is based on the CS4235.PDF from Cirrus. **
;**********************************************************
; CS4235 Driver written by Heinz Rath
; Version 1.0 (Date: 1.8.2000)
; heinz.rath@gmx.at

; WARNING!!! The KEY that is send to the soundcard is not the offical
; PNP key it is a special key from the CS4235.PDF!!!

; Soundcard is initialized with the following settings
; Soundblaster: 220
; WSS Base    : 534
; SYN Base    : 388
; MPU Base    : 330
; IRQ         : 7
; IRQ (MPU)   : 9
; DMA         : 1
; DMA (WSS)   : 4
                        push ds
                        push si
                        push eax
                        push ecx
                        push edx
                        push es
;----------------------------------------------------------------------------
; The NOP commands in this routine are needed so that the card has time to
; receivce the bytes.
                        mov dx,279h
                        mov bx,cs
                        mov ds,bx
                        ; Send magic key to card
                        mov bx,offset Magic_key
                        mov cx,1 
                   ag1: mov al,[bx]
                        nop
                        nop
                        out dx,al
                        nop 
                        nop
                        nop
                        inc cx
                        cmp cx,33
                        je r1
                        jmp ag1
                    r1: ; PNP Data is now send to card
                        mov bx,offset Data
                        mov cx,1 
                   ag2: mov al,[bx]
                        nop
                        nop
                        out dx,al
                        nop 
                        nop
                        nop
                        inc cx
                        cmp cx,46
                        je cs_ready
                        jmp ag2
;----------------------------------------------------------------------------
       Magic_key:       DB 96h,35h,9Ah,0CDh,0E6h,0F3h,79h,0BCh
                        DB 5Eh,0AFh,57h,2Bh,15h,8Ah,0C5h,0E2h
                        DB 0F1h,0F8h,7Ch,3Eh,9Fh,4Fh,27h,13h
                        DB 09h,84h,42h,0A1h,0D0h,68h,34h,1Ah
;----------------------------------------------------------------------------
            Data:       DB 6h   ; Card select number
                        DB 1h
                        DB 15h  ; Logical device
                        DB 00h  ; Device number 0
                        DB 47h  ; WSS Base
                        DB 05h  ; 534
                        DB 34h
                        DB 48h  ; SYNbase
                        DB 03h  ; 388h
                        DB 88h
                        DB 42h  ; Soundblaster base
                        DB 02h  ; 220h
                        DB 20h
                        DB 42h  ; Irq
                        DB 07h  ; 7
                        DB 2Ah  ; DMA (8-Bit)
                        DB 01h  ; 1
                        DB 25h  ; WSS capture DMA
                        DB 04h  ; 4
                        DB 33h  ; Activate
                        DB 01h

                        DB 15h  ; Logical Device
                        DB 01h  ; Device number 1
                        DB 47h  ; Gameport base
                        DB 02h  ; 200
                        DB 00h
                        DB 33h  ; Activate
                        DB 01h

                        DB 15h  ; Logical Device
                        DB 02h  ; Device number 2
                        DB 47h  ; Ctrl Base
                        DB 01h  ; 120
                        DB 20h
                        DB 33h  ; Activate
                        DB 01h

                        DB 15h  ; Logical Device
                        DB 02h  ; Device number 3
                        DB 47h  ; MPU Base
                        DB 03h  ; 330
                        DB 30h
                        DB 22h  ; MPU irq
                        DB 09h
                        DB 33h  ; Activate
                        DB 01h
                        DB 79h  ; Ready...
;----------------------------------------------------------------------------
              cs_ready: pop es
                        pop edx
                        pop ecx
                        pop eax
                        pop si
                        pop ds
