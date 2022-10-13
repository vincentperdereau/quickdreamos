title 'pshot'

.model tiny
.386

.code

        jmp main

 vector$int$9   dd      0
 buffer dd      0
 msg$ db 13,10,"page shot: ok [F9 - save, F10 - restore]",0

save$context:
        push ax
        push ebx
        push di
        push es
        mov ebx,cs:buffer
        mov ax,0b800h
        mov es,ax
        xor di,di
        save$context$loop:
        mov al,es:[di]
        mov fs:[ebx],al
        inc di
        inc ebx
        cmp di,4001
        jne save$context$loop
        save$context$loop1:
        in al,60h
        cmp al,67
        je save$context$loop1
        pop es
        pop di
        pop ebx
        pop ax
        ret

restore$context:
        push ax
        push ebx
        push di
        push esi
        push es
        mov ebx,cs:buffer
        mov esi,ebx
        add esi,4000
        mov ax,0b800h
        mov es,ax
        xor di,di
restore$context$loop:
        mov al,es:[di]
        mov fs:[esi],al
        mov al,fs:[ebx]
        mov es:[di],al
        inc di
        inc ebx
        inc esi
        cmp di,4001
        jne restore$context$loop
restore$context$loop2:
        in al,60h
        cmp al,68
        je restore$context$loop2
        xor di,di
        mov ebx,cs:buffer
        add ebx,4000
restore$context$loop3:
        mov al,fs:[ebx]
        mov es:[di],al
        inc di
        inc ebx
        cmp di,4001
        jne restore$context$loop3
        pop es
        pop esi
        pop di
        pop ebx
        pop ax
        ret

vector9:
        push ax
        pushf
        in al,60h
        cmp al,67 ; F9
        je vector9$save
        cmp al,68 ; F10
        je vector9$restore
        jmp vector9$noaction
vector9$save:
        call save$context
        popf
        pop ax
        jmp vector9$end
vector9$restore:
        call restore$context
        popf
        pop ax
        jmp vector9$end
vector9$noaction:
        popf
        pop ax
vector9$end:
        pushf
        call dword ptr cs:vector$int$9
        iret

main:
        xor ax,ax
        mov es,ax
        mov eax,es:[9h*4]
        mov cs:vector$int$9,eax
        mov ax,cs
        cli
        mov word ptr es:[9h*4],offset vector9
        mov es:[9h*4+2],ax
        sti
        mov ah,20h
        mov ecx,4000*2
        mov cs:buffer,ebx
        mov ah,10h
        mov si,offset msg$
        int 44h
        mov ah,12h
        mov bx,20
        int 44h

        retf

end
