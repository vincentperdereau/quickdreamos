; ** date.s

jmp entry  ; ** jmp entry point

; ** write a number in hex.base format

; al = hex number
print_hex:
 push ax
 push bx
 mov bh,0
 mov bl,al
 shr al,4
print_hex_entry:
 cmp al,9
 jg print_hex_alpha
 add al,48
 int $29
 jmp print_hex_fol_nibl
print_hex_alpha:
 add al,87
 int $29
print_hex_fol_nibl:
 cmp bh,1
 je print_hex_end
 and bl,$f
 mov al,bl
 mov bh,1
 jmp print_hex_entry
print_hex_end:
 pop bx
 pop ax
 ret

entry:         ; ** entry
 mov al,32     ; ** print a space
 int $29
 mov ah,4      ; ** function 4 
 int $1a       : ** int x1a: system (date) services
 mov al,dh
 call print_hex  ; ** print date 
 mov al,'.'      ; ** mm/dd/yy hh:mm
 int $29
 mov al,dl
 call print_hex
 mov al,'.'
 int $29
 mov al,ch
 call print_hex
 mov al,cl
 call print_hex
 mov al,32
 int $29
 mov ah,2
 int $1a
 mov al,ch
 call print_hex
 mov al,':'
 int $29
 mov al,cl
 call print_hex
 mov al,':'
 int $29
 mov al,dh
 call print_hex

 retf        ; ** return to caller
