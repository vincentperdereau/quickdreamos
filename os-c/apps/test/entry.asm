.model tiny
.386

.code

extrn _main:PROC

        mov ax,es
        mov ds,ax
        mov si,bx
        mov ax,cs
        mov es,ax
        mov di,offset cmd_line
        mov cx,100
        rep movsb
        mov ax,cs
        mov ds,ax
        mov es,ax
        mov si,offset cmd_line
        mov argv,si
        mov argc,1
        dec si
_loop:
        inc si
        mov al,ds:[si]
        cmp al,0
        je _end_loop
        cmp al,32
        jne _loop
        mov byte ptr ds:[si],0
_loop2:
        inc si
        cmp byte ptr ds:[si],32
        je _loop2
        cmp byte ptr ds:[si],0
        je _end_loop

        mov ax,argc
        shl ax,1
        mov bx,offset argv
        add bx,ax
        mov [bx],si
        inc argc
        jmp _loop

_end_loop:
        mov ax,argc
        push offset argv
        push ax
        call _main
        add sp,4
        retf

argc            DW      0
argv            DW      10 dup(0)
cmd_line        DB      100 dup(0)
end
