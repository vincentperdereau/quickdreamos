; ************************************************************************
; ** WHELLO.S: Example for QuickWindows programming **********************
; ************************************************************************

jmp .WinStart

WinSegment:                      ; Segment for System Buffer used by QW
 .word 0                         ;
WinOffset:                       ;
 .word 0                         ;
WinTitle:
 .string "Example"
 .byte 0
Caption:
 .string "Hello QuickWindows"
 .byte 0

.WinStart:

 mov ah,4
 int $46
 mov di,offset WinSegment
 .cs
 mov [di],bx
 mov di,offset WinOffset
 .cs
 mov [di],cx

 mov es,bx
 mov di,cx
 mov al,1

 .es
 mov [di],al
 inc di
 .es
 mov byte ptr [di],3
 add di,2
 .es
 mov word ptr [di],100
 add di,2
 .es
 mov word ptr [di],100
 add di,2
 .es
 mov word ptr [di],200
 add di,2
 .es
 mov word ptr [di],200
 mov ax,cs
 add di,2
 .es
 mov [di],ax
 add di,2
 mov ax,offset WinTitle
 .es
 mov [di],ax
 int $48

 .cs
 mov ax,WinSegment
 mov es,ax
 .cs
 mov di,WinOffset

 mov al,3
 .es
 mov [di],al
 mov ax,cs
 add di,11
 .es
 mov [di],ax
 add di,2
 mov ax,offset Caption
 .es
 mov [di],ax
 .cs
 mov di,WinOffset
 add di,3
 .es
 mov word ptr [di],10
 add di,2
 .es
 mov word ptr [di],60
 int $48

 retf
