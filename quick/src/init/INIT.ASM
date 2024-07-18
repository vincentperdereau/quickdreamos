;
; init.asm: d‚tection, routines Entr‚e/Sortie, Interface avec le noyau
;           gŠrant les fichiers.
;
; ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³INIT.ASM³                                                             ³
; ÃÄÄÄÄÄÄÄÄÙ                                                             ³
; ³                     SECOND STAGE KERNEL                              ³
; ³                                                                      ³
; ³ vincent.perdereau@lemel.fr                                     Alpha ³
; ³ heinz.rath@gmx.at - keyboard support                                 ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        .MODEL TINY
        .386                 ; ** instructions du i386

; ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³INIT.ASM³                                                             ³
; ÃÄÄÄÄÄÄÄÄÙ                                                             ³
; ³                     SECTION CONSTS                                   ³
; ³                                                                      ³
; ³                                                                Alpha ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        NULL            EQU     00            ; ** 
        LF              EQU     10            ; ** Saut de Ligne
        CR              EQU     13            ; ** Retour Chariot
        KERNEL$SEG      EQU     2000h         ; ** Segment de 'init'
        KERNEL$INT      EQU     44h           ; ** Interruption Noyau
        FCO$INT         EQU     29h           ; ** Ecriture Console

        API$PRINTLN     EQU     0010h         ; ** Num‚ros des fonctions API
        API$READLN      EQU     0011h
        API$MALLOC      EQU     0012h
        API$MFREE       EQU     0013h
        API$EXEC        EQU     0014h
        API$MGET        EQU     0015h
        API$LOGNAME     EQU     0016h
        API$FSETATTR    EQU     0017h
        API$INKEY       EQU     0018h
        API$GETSYS      EQU     0019h
        API$XMALLOC     EQU     0020h
        API$XMFREE      EQU     0021h
        API$DATE        EQU     0022h
        API$TIME        EQU     0023h

; ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³INIT.ASM³                                                             ³
; ÃÄÄÄÄÄÄÄÄÙ                                                             ³
; ³                     SECTION CODE                                     ³
; ³                                                                      ³
; ³                                                                Alpha ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         ASSUME CS:@CODE
        .CODE
start:          ; eviter le "no program entry point" du Linker

                mov ax,3
                int 10h

                mov     ax,cs                ; ** on charge les segments
                mov     ds,ax                ; ** ax = ds = es = gs
                mov     es,ax
                mov     gs,ax

                jmp second_stage
                 db 16 dup (0)
                second_stage:

; ** interface avec le micro-noyau

        INCLUDE         stage1.api           ; **
        INCLUDE         .\mm\mmu.asm

                call    init$api             ; ** Initialisation 

                jmp     start$program

        oldint9 dd ?
        proc_stack dw ?

        include thread.asm

        WRITE_DEC:                           ; ** Ecriture d'un d‚cimal
                        push    bx           ; ** sur le principe:
                        push    cx           ; ** 1999 = 1000 + 900 + 90 + 9
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
                        pop     cx
                        pop     bx
                        ret


        FAST_CONSOLE_OUTPUT:                ; ** ecriture sur console
                        push    ax          ; ** fonction 0xe du VideoBios
                        mov     ah,0eh
                        int     10h
                        pop     ax
                        iret                ; iret = retour d'interruption
        HALT_INT:
                        iret


        BAD_OPCODE:
                                            ; utilis‚ pour la d‚tection
                        push bp             ; du processeur
                        mov bp,sp
                        add word ptr ss:[bp+2],3  ; ajoute 3 … l'adresse de 
                        pop bp                    ; retour
                        dec byte ptr cs:cpu_type
                        mov al,20h                ; EOI: signale la fin
                        out 20h,al                ; le l'interruption
                        iret

        INT9:           
                        push    ax
                        push    es
                        push    si

                        cmp byte ptr cs:int28_in,1
                        je __int9_ctrl_alt_suppr

                        mov ax,0040h
                        mov es,ax
                        mov si,0017h
                        mov al,es:[si]
                        shr al,2
                        and al,3
                        cmp al,3
                        jne __int9_ctrl_alt_suppr
                        in al,60h
                        cmp al,83
                        jne __int9_ctrl_alt_suppr
                        __int9_loop:
                        in al,60h
                        cmp al,83
                        je __int9_loop

                        mov al,20h                ; EOI: signale la fin
                        out 20h,al                ; le l'interruption

                        int 28h

                        __int9_ctrl_alt_suppr:
                        pop     si
                        pop     es
                        pop     ax
                        pushf
                        call    dword ptr cs:oldint9
                        iret

        INT28:
                        cmp byte ptr cs:int28_in,1
                        je int28_exit
                        push ax
                        push ds
                        push si

                        mov byte ptr cs:int28_in,1
                        mov ax,cs
                        mov ds,ax
                        mov si,offset int28_string
                        mov ah,10h
                        int 44h
                        xor ax,ax
                        int 16h
                        cmp al,"r"  
                        je int28_reboot
                        cmp al,"c"
                        je int28_exit
                        cmp al,"h"
                        je int28_halt
                        jmp int28_exit
                        int28_reboot:
                        db 0eah
                        dw 00000h
                        dw 0ffffh
                        int28_halt:
                        hlt
                        int28_exit:
                        mov byte ptr cs:int28_in,0

                        pop si
                        pop ds
                        pop ax
                        iret

        INT46:   ; ** utilis‚ comme interface "xsh/sh"
                        cmp ah,1
                        je int46_function1
                        cmp ah,2
                        je int46_function2
                        cmp ah,3
                        je int46_function3
                        cmp ah,4
                        je int46_function4
                        cmp ah,5
                        je int46_function5
                        cmp ah,6
                        je int46_function6
                        cmp ah,7
                        je int46_function7
                        cmp ah,8                        
                        je int46_function8
                        cmp ah,9
                        je int46_function9

                        jmp int46_end
                int46_function1:
                        mov     cs:sh_seg,si
                        mov     cs:sh_ofs,di
                        jmp     int46_end
                int46_function2:
                        mov     si,cs:sh_seg
                        mov     di,cs:sh_ofs
                        jmp     int46_end
                int46_function3:
                        mov     cs:_xsh,al
                        mov     cs:_xsh_segment,bx
                        mov     cs:_xsh_offset,cx
                        jmp     int46_end
                int46_function4:
                        mov     al,cs:_xsh
                        mov     bx,cs:_xsh_segment
                        mov     cx,cs:_xsh_offset
                        jmp     int46_end
                int46_function5:
                        push ax
                        push es
                        mov     ax,0
                        mov     es,ax
                        mov     word ptr es:[FCO$INT*4],offset FAST_CONSOLE_OUTPUT
                        mov     word ptr es:[FCO$INT*4+2],KERNEL$SEG       
                        pop es
                        pop ax
                        jmp     int46_end
                int46_function6:
                        mov     cs:_xsh_program,al
                        jmp     int46_end
                int46_function7:
                        push    es
                        push    ax
                        mov     ax,0
                        mov     es,ax
                        mov     word ptr es:[28h*4],offset INT28
                        mov     word ptr es:[28h*4+2],KERNEL$SEG
                        pop     ax
                        pop     es
                        jmp     int46_end
                int46_function8:
                        mov byte ptr cs:xsh_gmode,al
                        jmp int46_end
                int46_function9:
                        mov al,cs:xsh_gmode
                        jmp int46_end


                int46_end:
                        iret

         int24:
         critical_error:
                 cli
                 mov ax,3
                 int 10h
                 mov ax,0b800h
                 mov es,ax
                 mov di,0
                 mov ax,1720h
                 mov cx,2000
                 rep stosw
                 mov ax,cs
                 mov ds,ax
                 mov si,offset critical$
                 mov di,3*160+(32*2)   ; (x,y) = (3,32)
                 mov cx,16
                 .loop1:
                 mov al,ds:[si]
                 mov byte ptr es:[di+1],71h
                 mov es:[di],al
                 inc si
                 add di,2
                 dec cx
                 jnz .loop1
                 xor dh,dh
                 dec dl
                 shl dl,2
                 add dx,offset o_err1
                 mov bx,dx
                 mov di,12*160+(40*2)
                 mov si,[bx]
                 mov cl,[bx+2]
                 mov al,cl
                 xor ah,ah
                 sub di,ax
                 xor ch,ch
                 .loop2:
                 mov al,ds:[si]
                 mov es:[di],al
                 inc si
                 add di,2
                 dec cx
                 jnz .loop2
                 infinite:
                 jmp infinite
                 sti
                 ret


        INT0:           ; divide by zero
               mov dl,1
               call critical_error
               xor ax,ax
               int 16h
               db 0eah
               dw 00000h
               dw 0ffffh
        INT6:           ; bad opcode
               mov dl,2
               call critical_error
               xor ax,ax
               int 16h
               db 0eah
               dw 00000h
               dw 0ffffh

 critical$ db " CRITICAL ERROR "

 err1$ db "Processor has encountred a divide by zero (int0)"
 err2$ db "Processor has encountred an unvalid opcode (int6) "
 err3$ db "Disk failure"
 err4$ db "A program try to read/write an unvalid file "
 end_err$ db 0

 o_err1 dw offset err1$
 s_err1 db (offset err2$ - offset err1$)
        db 0
 o_err2 dw offset err2$
 s_err2 db (offset err3$ - offset err2$)
        db 0
 o_err3 dw offset err3$
 s_err3 db (offset err4$ - offset err3$)
        db 0
 o_err4 dw offset err4$
 s_err4 db (offset end_err$ - offset err4$)
        db 0

        STAGE1$INT:                               ; fonctions API

                        cmp     ah,API$TEST
                        je      FUNCTION$API$TEST
                        cmp     ah,API$FOPEN
                        je      FUNCTION$API$FOPEN
                        cmp     ah,API$FCREATE
                        je      FUNCTION$API$FCREATE
                        cmp     ah,API$FREAD
                        je      FUNCTION$API$FREAD
                        cmp     ah,API$FWRITE
                        je      FUNCTION$API$FWRITE
                        cmp     ah,API$CHDRIVE
                        je      FUNCTION$API$CHDRIVE
                        cmp     ah,API$CHDIR
                        je      FUNCTION$API$CHDIR
                        cmp     ah,API$MKDIR
                        je      FUNCTION$API$MKDIR
                        cmp     ah,API$FCBDIR
                        je      FUNCTION$API$FCBDIR
                        cmp     ah,API$INFOS
                        je      FUNCTION$API$INFOS
                        cmp     ah,API$FCBCOUNT
                        je      FUNCTION$API$FCBCOUNT
                        cmp     ah,API$FSIZE
                        je      FUNCTION$API$FSIZE
                        cmp     ah,API$FRM
                        je      FUNCTION$API$FRM
                        cmp     ah,API$RMDIR
                        je      FUNCTION$API$RMDIR
                        cmp     ah,API$CHDIR
                        je      FUNCTION$API$CHDIR
                        cmp     ah,API$ACDIR
                        je      FUNCTION$API$ACDIR
                        cmp     ah,API$PRINTLN
                        je      FUNCTION$API$PRINTLN
                        cmp     ah,API$READLN
                        je      FUNCTION$API$READLN
                        cmp     ah,API$MALLOC
                        je      FUNCTION$API$MALLOC
                        cmp     ah,API$MFREE
                        je      FUNCTION$API$MFREE
                        cmp     ah,API$EXEC
                        je      FUNCTION$API$EXEC
                        cmp     ah,API$MGET
                        je      FUNCTION$API$MGET
                        cmp     ah,API$LOGNAME
                        je      FUNCTION$API$LOGNAME
                        cmp     ah,API$FSETATTR
                        je      FUNCTION$API$FSETATTR
                        cmp     ah,API$INKEY
                        je      FUNCTION$API$INKEY
                        cmp     ah,API$GETSYS
                        je      FUNCTION$API$GETSYS
                        cmp     ah,API$XMALLOC
                        je      FUNCTION$API$XMALLOC
                        cmp     ah,API$XMFREE
                        je      FUNCTION$API$MFREE
                        cmp     ah,API$DATE
                        je      FUNCTION$API$DATE
                        cmp     ah,API$TIME
                        je      FUNCTION$API$TIME

                        jmp     END$STAGE1$INT


        FUNCTION$API$TEST:
                        jmp     END$STAGE1$INT
        FUNCTION$API$FOPEN:
                        call    fopen
                        jmp     END$STAGE1$INT
        FUNCTION$API$FCREATE:
                        call    fcreate
                        jmp     END$STAGE1$INT
        FUNCTION$API$FREAD:
                        cmp     edx,2
                        jnl     read$ok
                        mov     dl,4
                        int     24h
                       read$ok:
                        call    fread
                        jmp     END$STAGE1$INT
        FUNCTION$API$FWRITE:
                        cmp     edx,2
                        jnl     write$ok
                        mov     dl,4
                        int     24h
                       write$ok:
                        call    fwrite
                        jmp     END$STAGE1$INT
        FUNCTION$API$CHDRIVE:
                        call    chdrive
                        jmp     END$STAGE1$INT
        FUNCTION$API$CHDIR:
                        call    chdir
                        jmp     END$STAGE1$INT
        FUNCTION$API$MKDIR:
                        call    mkdir
                        jmp     END$STAGE1$INT
        FUNCTION$API$FCBDIR:
                        call    fcbdir
                        jmp     END$STAGE1$INT
        FUNCTION$API$INFOS:
                        call    infos
                        jmp     END$STAGE1$INT
        FUNCTION$API$FCBCOUNT:
                        call    fcbcount
                        jmp     END$STAGE1$INT
        FUNCTION$API$FSIZE:
                        call    fsize
                        jmp     END$STAGE1$INT
        FUNCTION$API$FRM:
                        call    frm
                        jmp     END$STAGE1$INT
        FUNCTION$API$RMDIR:
                        call    rmdir
                        jmp     END$STAGE1$INT
        FUNCTION$API$ACDIR:
                        call    acdir
                        jmp     END$STAGE1$INT
        FUNCTION$API$PRINTLN:                   ; ** ecriture d'une chaine
                        push    ax
                        push    si
              PRINTLN$BEGIN:
                        mov     al,ds:[si]
                        or      al,al           ; caractŠre ‚gal … z‚ro ?
                        jz      PRINTLN$END     ; si oui, alors -> fin
                        inc     si              ; si non, alors -> d‚but
                        int     FCO$INT
                        jmp     PRINTLN$BEGIN
              PRINTLN$END:
                        pop     si
                        pop     ax
                        jmp     END$STAGE1$INT

        FUNCTION$API$READLN:                    ; ** lecture d'une chaine
                FUNCTION$READLN:
                        pusha
                        mov     dx,cx
                        
                        mov     al,es:[bx]
                        cmp     al,0
                        je      FUNCTION$READ_readln 
                        inc     bx
                        dec     cx
                        
                FUNCTION$READ_readln:

                        mov     ah,18h          ; lecture touche
                        int     44h             ; est-ce retour chariot ?
                   ;     xor ax,ax
                   ;     int 16h

                        cmp     al,8
                        je      FUNCTION$READ_backspace
                        cmp     al,13           ; est-ce entr‚e ?
                        je      FUNCTION$READ_enterkey
                        cmp     cx,1            ; est-ce caractŠre max. ?
                        je      FUNCTION$READ_readln
                        mov     es:[bx],al      ; al -> caractŠre lu
                        int     29H             ; affichage console
                        inc     bx              ; incr‚mente l'offset du
                        dec     cx              ; tampon
                        jmp     FUNCTION$READ_readln
                FUNCTION$READ_backspace:
                        cmp     cx,dx
                        je      FUNCTION$READ_readln
                        push    bx              ;
                        mov     al,8            ; si retour ("<---")
                        int     29H             ; alors d‚calage … gauche,
                        mov     al,32           ; on place un espace pour
                        int     29H             ; effacer l'ancien caractŠre
                        mov     al,8            ; on retourne … la position
                        int     29H             ; x-1
                        pop     bx              ;
                        inc     cx              ;
                        dec     bx              ;
                        jmp     FUNCTION$READ_readln
                FUNCTION$READ_enterkey:
                        mov     byte ptr es:[bx],0  ; 0 … la fin du tampon
                        popa
                        jmp     END$STAGE1$INT
                
                        ; ** routines gestion de la m‚moire
                        ; ** trŠs sommaire pour l'instant: sujet d'un prochain
                        ; ** article
        FUNCTION$API$MALLOC:

                         call mmu_malloc

 ;                       mov     ax,0A000h
 ;                       sub     ax,cs:mem$stack$pointer
 ;                       cmp     bx,ax
 ;                       ja      API$MALLOC$EMPTY
 ;                       mov     ax,cs:mem$stack$pointer
 ;                       add     cs:mem$stack$pointer,bx
 ;                       jmp     END$STAGE1$INT
 ;             API$MALLOC$EMPTY:
 ;                       mov     ax,0
                         jmp     END$STAGE1$INT

        FUNCTION$API$MFREE:
                         call mmu_free
  ;                      sub     cs:mem$stack$pointer,bx
                         jmp     END$STAGE1$INT

        FUNCTION$API$EXEC:
                        push    ebx
                        push    ecx
                        push    edx
                        push    di
                        push    es
                        push    ds
                        mov     ax,ds
                        mov     cs:caller_addr,ax

                        mov     ah,API$FOPEN
                        int     KERNEL$INT
                        mov     cs:handle$prog,eax
                        cmp     eax,2
                        jg      EXEC$STEP2
                        mov     al,"O"
                        pop     ds
                        pop     es
                        pop     di
                        pop     edx
                        pop     ecx
                        pop     ebx
                        jmp     END$STAGE1$INT
              EXEC$STEP2:

                        push    es
                        push    cx
                        mov     ax,1000h
                        mov     ds,ax
                        mov     si,8000h
                        mov     ax,2000h
                        mov     es,ax
                        mov     di,offset progname
                        mov     cx,12
                        rep     movsb
                        pop     cx
                        pop     es

                        ;
                        mov     ah,API$FSIZE
                        mov     edx,cs:handle$prog
                        int     KERNEL$INT
                        mov     ebx,ecx
                        shr     bx,4
                        inc     bx
                        ;
                        mov     ah,API$MALLOC
                        ; mov     bx,0fffh
                        int     KERNEL$INT
                        mov     dx,ax
                        mov     cs:exec_addr,ax
                        or      ax,ax
                        jnz     EXEC$STEP3
                        pop     ds
                        pop     es
                        pop     di
                        pop     edx
                        pop     ecx
                        pop     ebx
                        mov     al,"M"
                        jmp     END$STAGE1$INT

              EXEC$STEP3:
                        ;mov     ecx,edx
                        mov     es,dx
                        mov     edx,cs:handle$prog
                        mov     di,0
                        ;mov     ecx,0ffffh
                        mov     ah,API$FREAD
                        int     KERNEL$INT
                        pop     ds
                        pop     es
                        pop     di
                        pop     edx
                        pop     ecx
                        pop     ebx

                        pushad
                        push    es
                        push    ds
                        push    gs

                        mov     ax,cs:exec_addr
                        mov     ds,ax
                        mov     cs:proc_stack,sp

                        mov     cx,cs:caller_addr
                        push    cx ; caller segment
                        push    ds ; segment
                        
                        db      9Ah
                        dw      0000h
                        exec_addr       dw      ?
              exec$return:
                       ; mov     sp,cs:proc_stack
                        pop     ds
                        cmp     byte ptr cs:_xsh_program,1
                        je      xsh_program
                        mov     ah,API$MFREE
                        mov     bx,ds
                        int     KERNEL$INT
                       xsh_program:
                        mov     byte ptr cs:_xsh_program,0
                        pop     ax               ; caller segment
                        dec     ax
                        mov     ds,ax
                        mov     si,3
                        mov     ax,2000h
                        mov     es,ax
                        mov     di,offset progname
                        mov     cx,12
                        rep     movsb
                       
                        pop     gs
                        pop     ds
                        pop     es
                        popad

                        jmp     END$STAGE1$INT

        FUNCTION$API$MGET:
                        mov     ax,cs:block_memory_used
                        jmp     END$STAGE1$INT

        FUNCTION$API$LOGNAME:
                        mov     si,offset logname
                        push    cs
                        pop     ds
                        jmp     END$STAGE1$INT

        FUNCTION$API$FSETATTR:
                        call    f_set_attr
                        jmp     END$STAGE1$INT
        FUNCTION$API$INKEY:                  ; "driver" clavier fran‡ais
; INKEY routine changed to support loading of keymap files.
; (See Keydrv.asm or changes.txt for details)
; last updated (1.8.2000)
                        push ds
                        push es
                        push bx
                        push cx
                        push dx
;                        xor ax,ax            
                        mov ax,00h          ; Is needed for some special key
                                              ; that for example exist on
                                              ; german but not on U.S.
                                              ; keyboards
                        int 16h
;                        mov cx,38  
                        xor cx,cx             ; Number of keys is now loaded
                        mov bx,cs
                        mov ds,bx
;                        mov bx,offset FrenchKeymap ; table des caractŠres 
                        mov bx,offset Keymap 
                        mov cl,[bx] ; Number of keys
                        mov bx,offset Keys
                Scan:   mov dl,[bx]
                        cmp dl,ah
                        je Convert
                        add bx,4
                        dec cx
                        jnz Scan
                        jmp Fin                    
                Convert:                         ; Convertion
                        mov dx,0040h
                        mov es,dx
                        mov dl,es:[0096h]
                        cmp dl,24
                        je AGR_key          ; Alt+GR pressed
                        mov dl,es:[0017h]
                        and dl,01000011b
                        or dl,dl
                        jnz lock_key
                        mov al,[bx+1]
                        jmp fin
                 AGR_key:                       ; ALT Gr Key
                        mov al,[bx+3]
                        jmp fin
                        jmp fin
                lock_key:
                        mov al,[bx+2]
                        jmp fin
                        jmp fin
                Fin:    pop dx
                        pop cx
                        pop bx
                        pop es
                        pop ds
                        jmp END$STAGE1$INT
        FUNCTION$API$GETSYS:
                        mov     si,offset sys_block
                        jmp     END$STAGE1$INT
        FUNCTION$API$XMALLOC:
                        mov     ebx,himem$pointer
                        add     cs:himem$pointer,ecx
                        jmp     END$STAGE1$INT
        FUNCTION$API$XMFREE:
                        sub     cs:himem$pointer,ecx
                        jmp     END$STAGE1$INT
        FUNCTION$API$DATE:
                        ; to do
                        jmp     END$STAGE1$INT
        FUNCTION$API$TIME:
                        ; to do
                        jmp     END$STAGE1$INT

        END$STAGE1$INT:
                        iret

        start$program:

                        mov     ax,0
                        mov     es,ax

                        ; ** on inscrit les vecteurs des interruptions

                        mov     word ptr es:[KERNEL$INT*4],offset STAGE1$INT
                        mov     word ptr es:[KERNEL$INT*4+2],KERNEL$SEG

                        mov     word ptr es:[FCO$INT*4],offset FAST_CONSOLE_OUTPUT
                        mov     word ptr es:[FCO$INT*4+2],KERNEL$SEG       

                        mov     word ptr es:[45h*4],offset HALT_INT
                        mov     word ptr es:[45h*4+2],KERNEL$SEG       

                        mov     word ptr es:[82h*4],offset int82
                        mov     word ptr es:[82h*4+2],KERNEL$SEG       

                        mov     word ptr es:[24h*4],offset int24
                        mov     word ptr es:[24h*4+2],KERNEL$SEG       

                        mov     word ptr es:[46h*4],offset INT46
                        mov     word ptr es:[46h*4+2],KERNEL$SEG       

                        mov     word ptr es:[28h*4],offset INT28
                        mov     word ptr es:[28h*4+2],KERNEL$SEG

                        mov     word ptr es:[0],offset INT0
                        mov     word ptr es:[2],KERNEL$SEG

                        cli
                        mov     eax,es:[9h*4]
                        mov     cs:oldint9,eax
                        mov     word ptr es:[9h*4],offset int9
                        mov     word ptr es:[9h*4+2],KERNEL$SEG
                        sti



        include         driver.asm   ; Loads Sounddriver



        include         detect.asm              ; detection du mat‚riel

                        mov     ax,0
                        mov     es,ax
                        cli
                        mov     word ptr es:[6h*4],offset INT6
                        mov     word ptr es:[6h*4+2],KERNEL$SEG
                        sti
                        nop



; **************************************************************************
; **                      CHARGEMENT DU 'SHELL'                           **
; **************************************************************************

        load_shell:
        include         keydrv.asm   ; Added for keymap support

                        call mmu_init


                        mov     ax,cs
                        mov     ds,ax
                        mov     es,ax

                        mov     ah,API$PRINTLN
                        mov     si,offset login$

;                        int     KERNEL$INT

                        mov     ah,API$READLN
                        mov     bx,offset logname
                        mov     cx,14

;                        int     KERNEL$INT    ; no login


                        mov     si,offset sh$   ;
                        mov     ah,API$EXEC     ; ** On charge le 'shell'
                        int     KERNEL$INT      ;

                        mov     ax,cs
                        mov     ds,ax
                        mov     ah,API$PRINTLN
                        mov     si,offset end$
                        int     KERNEL$INT


                        int     45h
                        inf: jmp inf

; ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³INIT.ASM³                                                             ³
; ÃÄÄÄÄÄÄÄÄÙ                                                             ³
; ³                            DATA                                      ³
; ³                                                                      ³
; ³                                                                Alpha ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        proc$           DB      LF,CR,LF
                        DB            "cpu:             "
        cpu_type        DB      "586 ",0
        bmem$           DB      LF,CR,"base memory:     ",0
        mem$            DB      LF,CR,"extended memory: ",0
        fpu$            DB      LF,CR,"fpu:             ",0
        found$          DB            "installed",0
        nofound$        DB            "no",0
        video_card$     DB      LF,CR,"video card:      ",0
        sound_blaster$  DB            "sound blaster",0
        adlib$          DB            "adlib",0  
        standard$       DB            "standard card (no VESA support)",0
        sound_card$     DB      LF,CR,"sound card:      ",0
        mmx$            DB            " with MMX(c) extensions",0

        sys_block       DB      ?  ; ** id. processeur
        himem_size      DW      ?  ; ** memoire etendue
                        DB      0  ; ** MMX (1=oui)
                        DB      0  ; ** FPU (1=install‚)
                        DB      0  ; ** VESA support
                        DW      0  ; ** port carte son

        sh_seg          DW      0
        sh_ofs          DW      0

        int28_in        DB      0
        int28_string    DB      LF,CR
                        DB      "<Kernel/Init/Service/CtrAltDel>"
                        DB      LF,CR,LF
                        DB      "What would you like to do ?" 
                        DB      LF,CR
                        DB      " <r>eboot",CR,LF
                        DB      " <h>alt",CR,LF
                        DB      " <s>top"
                        DB      0


        _xsh            DB      0
        _xsh_segment    DW      0
        _xsh_offset     DW      0
        _xsh_program    DB      0

        login$          DB      LF,CR,LF
                        DB      "DreamOS release 1.0 ("
                        DB      ??date
                        DB      " "
                        DB      ??time
                        DB      ")"
                        DB      LF,CR
                        DB      "Kernel 0.0.5 (Asylum)"
                        DB      LF,CR,LF
                        DB      "DreamOS login: "
                        DB      NULL
        sh$             DB      "sh",0
        end$            DB      LF,CR
                        DB      "system halted."
                        DB      LF,CR
                        DB      NULL

 Keymap                 DB      38
                        DB      "French             ",00
 Keys                   DB      002,'&','1',000
                        DB      003,'‚','2',000
                        DB      004,'"','3',000
                        DB      005,039,'4',000
                        DB      006,'(','5',000
                        DB      007,'-','6',000
                        DB      008,'Š','7',000
                        DB      009,'_','8',000
                        DB      010,'‡','9',000
                        DB      011,'…','0',000
                        DB      012,')','ø',000
                        DB      013,'=','+',000
                        DB      016,'a','A',000
                        DB      017,'z','Z',000
                        DB      026,'^','ù',000
                        DB      027,'$','œ',000
                        DB      030,'q','Q',000
                        DB      039,'m','M',000
                        DB      040,'—','%',000
                        DB      041,'ý',000,000
                        DB      043,'*','æ',000
                        DB      044,'w','W',000
                        DB      050,',','?',000
                        DB      051,';','.',000
                        DB      052,':','/',000
                        DB      053,'!','õ',000
                        DB      086,'<','>',000
                        DB      121,'~',000,'~'
                        DB      122,'#',000,'#'
                        DB      123,'{',000,'{'
                        DB      124,'[',000,'['
                        DB      125,'|',000,'|'
                        DB      126,'`',000,'`'
                        DB      127,'\',000,'\'
                        DB      128,'^',000,'^'
                        DB      129,'@',000,'@'
                        DB      130,']',000,']'
                        DB      131,'}',000,'}'
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000
                        DB      000,000,000,000

        mem$stack$pointer       dw      2000h
        himem$pointer           dd      200000h
        logname         DB      15      DUP (0)
        handle$prog     DD      0
        caller_addr     DW      0
        xsh_gmode       DB      1   
        progname        DB      12      DUP (0)
        eof             DW      ?

        END start
                                
