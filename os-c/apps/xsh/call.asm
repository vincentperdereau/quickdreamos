.model tiny
.386

.code

 mov ah,4
 int 46h
 mov cs:xsh_segment,bx
 mov cs:xsh_offset,cx

 mov es,bx
 mov di,cx
 mov al,1            ; function 01: CreateWindow()
 mov es:[di],al
 mov byte ptr es:[di+1],9     ; color
 mov word ptr es:[di+2],100   ; X
 mov word ptr es:[di+4],100   ; Y
 mov word ptr es:[di+6],200   ; W
 mov word ptr es:[di+8],200   ; H
 mov ax,cs
 mov word ptr es:[di+10],ax   ; Segment String
 mov word ptr es:[di+12],offset win$ ; Offset String

 int 48h

 mov bx,cs:xsh_segment
 mov cx,cs:xsh_offset
 mov es,bx
 mov di,cx

 mov al,3
 mov byte ptr es:[di],al
 mov ax,cs
 mov word ptr es:[di+10],ax
 mov word ptr es:[di+12],offset msg$
 mov word ptr es:[di+2],110
 mov word ptr es:[di+4],110
 int 48h

 retf

WinMain:
 mov ax,3
 int 10h
 mov ah,0eh
 mov al,"@"
 int 10h
 inf: jmp inf


xsh_segment dw 0
xsh_offset dw 0

win$ db "QuickGUI",0
msg$ db "V-I-N-C-E-N-T",0

end
