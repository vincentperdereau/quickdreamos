; **************************************************************************
; **                     DETECTION DU PROCESSEUR                          **
; **************************************************************************
                        ; ** interruption 6: d‚tection du processeur
                        mov     ebx,es:[6*4]
                        mov     word ptr es:[6*4],offset BAD_OPCODE
                        mov     word ptr es:[6*4+2],KERNEL$SEG       
                        nop

                         ; ** execution des instructions
                        db      00Fh,020h,0C2h  ; ** pour 386
                        db      00Fh,0C1h,0D2h  ; ** pour 486
                        db      00Fh,0A2h,090h  ; ** pour 586 (Pentium)

                        sti
                        mov     es:[6*4],ebx
                        mov     ah,API$PRINTLN
                        mov     si,offset proc$
                        int     KERNEL$INT
                        mov     si,offset cpu_type
                        mov     al,[si]
                        mov     byte ptr cs:sys_block,al ; ** inscription var.

                        cmp     al,'5'    ; ** si c'est un pentium
                        jne     no_cpuid  ; ** alors on approfondie la d‚tection
                                          ; ** sinon on passe … la suite
                        ; ** cpuid
                        mov     eax,0     ; ** paramŠtre eax=0
                        db      00fh,0a2h ; ** = cpuid
                        mov     dword ptr cs:proc$,ebx
                        mov     dword ptr cs:proc$+4,edx
                        mov     dword ptr cs:proc$+8,ecx
                        mov     byte ptr cs:proc$+12,0
                        mov     ah,API$PRINTLN
                        mov     si,offset proc$   ; ** on ‚crit le nom du fondeur
                        int     KERNEL$INT
                        mov     eax,1             ; ** paramŠtre eax=1
                        db      00fh,0a2h         ; ** cpuid
                        bts     edx,23            ; ** bits 23 = 1 ?
                        jnc     no_cpuid          ; ** oui alors c'est un MMX
                        mov     ah,API$PRINTLN
                        mov     si,offset mmx$    ; ** et on le dit !
                        int     KERNEL$INT
                        mov     cs:sys_block+3,1  ; ** variable d‚finie
                        no_cpuid:
; **************************************************************************
; **                     DETECTION DU COPROCESSEUR                        **
; **************************************************************************
                        mov     ah,API$PRINTLN
                        mov     si,offset fpu$
                        int     KERNEL$INT
                        mov     al,14h    ; **
                        out     70h,al    ; ** bit 0 du registre 14h
                        in      al,71h    ; ** 1 = install‚, 0 = absent
                        and     al,1
                        jz      no_fpu
                        mov     si,offset found$
                        int     KERNEL$INT
                        mov     byte ptr cs:sys_block+4,1
                        jmp     next
                        no_fpu:
                        mov     si,offset nofound$
                        int     KERNEL$INT
                        next:
; **************************************************************************
; **                     DETECTION DE LA MEMOIRE                          **
; **************************************************************************
                        mov     ah,API$PRINTLN
                        mov     si,offset bmem$
                        int     KERNEL$INT
                        int     12h
                        call    WRITE_DEC     ; ** m‚moire de base -> int 12h
                        mov     al,'K'
                        int     29h
                        mov     ah,API$PRINTLN
                        mov     si,offset mem$
                        int     KERNEL$INT
                        mov     al,17h        ; **
                        out     70h,al        ; **
                        in      al,71h        ; ** registre 17h et 18h
                        mov     bl,al         ; ** m‚moire ‚tendue
                        mov     al,18h        ; **
                        out     70h,al        ; **
                        in      al,71h        ; **
                        mov     bh,al         ; **
                        mov     ax,bx         ; **
                        call    WRITE_DEC     ; **
                        mov     al,'K'
                        int     29h
                        mov     word ptr cs:sys_block+1,bx
; **************************************************************************
; **                     DETECTION DE LA CARTE VIDEO                      **
; **************************************************************************
                        mov     ah,API$PRINTLN
                        mov     si,offset video_card$
                        int     KERNEL$INT
                        mov     ax,8000h   ; ** on ‚tablit le buffer … 8000:0000
                        mov     es,ax      ; ** une zone m‚moire inutilis‚e alors
                        mov     di,0
                        mov     ax,4f00h   ; ** fonction 4f00h du VideoBios
                        int     10h
                        cmp     ax,004fh   ; ** retour 004fh, si oui alors nous
                        jne     no_vesa    ; ** sommes bien en pr‚sence d'une VESA
                        mov     ax,es:[06] ; ** 8000:0006 = offset "Nom du vendeur"
                        mov     si,ax
                        mov     ax,es:[08] ; ** 8000:0008 = segment "Nom du Vendeur"
                        mov     ds,ax
                        mov     ah,API$PRINTLN  ; On affiche le nom du vendeur
                        int     KERNEL$INT
                        mov     al," "
                        int     29h
                        mov     ax,es:[12h]    ; ** 8000:0012 = quantit‚ RAM 
                        shl     ax,6           ; ** par paquet de 64 Kb
                        call    WRITE_DEC
                        mov     al,'K'         ; ** 'K'
                        int     29h

                        mov     ax,cs
                        mov     ds,ax
                        mov     byte ptr cs:sys_block+5,1
                        jmp     load

                no_vesa:                      ; ** ce n'est pas une VESA ...
                        mov     ah,API$PRINTLN
                        mov     si,offset standard$
                        int     KERNEL$INT
; **************************************************************************
; **                     DETECTION DE LA CARTE SON                        **
; **************************************************************************
                load:
                        mov     ah,API$PRINTLN
                        mov     si,offset sound_card$
                        int     KERNEL$INT

                        mov     dx,210h     ; **  Test de la SoundBlaster
                        sc_l0:              ; **  On commence au port 210h
                        add     dx,6        ; **  216h = identification
                        mov     al,1        ; **
                        out     dx,al       ; **
                        in      al,dx       ; **  La r‚ponse est plutot longue
                        in      al,dx       ; **  !!
                        in      al,dx       ; **
                        in      al,dx       ; **
                        mov     al,0        ; **
                        out     dx,al       ; **
                        add     dx,4        ; **
                        mov     cx,100      ; **
                        sc_l1:              ; **
                        in      al,dx       ; **  On attend le retour de la 
                        cmp     al,0aah     ; **  valeur aah
                        je      sc_l3       ; **
                        loop    sc_l1       ; **
                        sub     dx,10       ; **
                        cmp     dx,270h     ; **
                        je      sc_l2       ; **
                        add     dx,10h      ; **  On augmente l'adresse du port
                        jmp     sc_l0       ; **
                        sc_l3:
                        sub     dx,10
                        mov     word ptr cs:sys_block+6,dx   
                        mov     ah,API$PRINTLN
                        mov     si,offset sound_blaster$
                        int     KERNEL$INT
                        jmp     load_shell  ; ** SoundBlaster trouv‚
                        sc_l2:
                        mov     dx,388h     ; ** D‚tection de l'Adlib
                        in      al,dx
                        cmp     al,0        ; adlib (al=0) ou (al=6)
                        je      adlib_l0
                        cmp     al,6
                        jne     adlib_l1
                        adlib_l0:
                        mov     word ptr cs:sys_block+6,dx
                        mov     ah,API$PRINTLN
                        mov     si,offset adlib$
                        int     KERNEL$INT
                        jmp     load_shell
                        adlib_l1:
                        mov     ah,API$PRINTLN
                        mov     si,offset nofound$
                        int     KERNEL$INT
