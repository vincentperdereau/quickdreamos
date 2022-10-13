;
; \dreamos\src\boot\boot.asm
;
; ==========================================================================
; = boot.asm: secteur de dÇmarrage du systäme (turbo assembler)              =
; ==========================================================================
; vincent.perdereau@lemel.fr
;
; **************************************************************************
;  Fonction:
;
;  Le BIOS lit le premier secteur de la disquette (si disquette il y a)
;  S'il trouve le mot AA55 dans les deux derniers octets de ce secteur
;  il considäre alors la disquette comme une disquette de BOOT.
;  Il charge alors ce secteur dans la mÇmoire Ö l'adresse 07C0:0000
;  Il effectue enfin un saut Ö cette adresse.
;
;  Ce programme affiche en premier lieu une chaine de caractäre (MSG$)
;  Il lit ensuite le second secteur et ses suivants et les charge
;  Ö l'adresse 1000:0000 ( second secteur & suivants contiennent
;  le noyau ).
;
; compilation:
; tasm boot.asm
; tlink boot.obj
; exe2bin boot.exe boot.bin
;
; **************************************************************************

.model  tiny                    ;** (taille du programme) <= (64Kb)
.386P                           ;** Instructions du Intel 80386
                        
                                ;** Bloc de constantes
LF      equ     10              ;** LineFeed => Saut de ligne
BOOTSEG equ     07C0h           ;** Segment du secteur boot (07C0:0000)
MAGICW  equ     0AA55h          ;** MagicWord de boot
KERNELS equ     1000h           ;** Segment du noyau 1000h (arbitraire)
BOOTDRV equ     00H             ;** lecteur 00 (disquette) 

.code                           ;** ici, commence le code asm
start:

 mov ax,3h
 int 10h

 mov ax,0b800h
 mov es,ax

 mov di, 8*2*80+20 ;+40
 mov bx,8

 mov al,219
 mov ah,8
.loop:
 mov cx,60  ; 40
 rep stosw
 add di,40 ; 80
 mov ax,07020h
 dec bx
 jnz .loop

 mov ah,02
 mov bh,0
 mov dh,8
 mov dl,21
 int 10h

;        mov     ah,0eh          ;** fonction xE: Çcriture d'un caractäre
;        mov     al,LF           ;** caractäre LF (LineFeed) => Saut de ligne
;        int     10h             ;** appel du VideoBIOS

        cli                     ;** DÇsactivation des interruptions (CLI)
        mov     ax,1000h        ;**
        mov     ss,ax           ;** On fixe le segment de pile Ö 1000h
        mov     sp,0fffeh       ;** Pile fixÇe Ö 1000:fffe (arbitraire)
        sti                     ;** RÇactivation des interruptions (STI)

        mov     ax,BOOTSEG      ;**
        mov     es,ax           ;** On fixe l'extra-segment Ö 07C0
        mov     gs,ax
        mov     bx,offset MSG$  ;** bx=offset de la chaine MSG$ (ES:BX=07C0:MSG$)

        mov     ah,0eh          ;** fonction xE: Çcriture d'un caractäre
@L1:
        mov     al,es:[bx]      ;** al=caractäre de la chaine
        or      al,al           ;** si (al=0) ...
        jz      @L2             ;** ... alors saute Ö @L2
        cmp     al,'!'
        je      @L4
        cmp     al,'#'
        jne     @L3
        inc     bx
        mov     al,es:[bx]
        sub     al,48
        mov     cl,al
        inc     bx
        mov     al,es:[bx]
        mov     si,bx
        mov     bl,cl
        mov     ah,9
        mov     cx,1
        int     10h
        mov     bx,si
        mov     ah,0eh
@L3:
        inc     bx              ;** bx=bx+1 (caractäre suivant)
        int     10h             ;** appel du VideoBIOS (affichage du caractäre)
        jmp     @L1             ;** Retourne Ö @L1
@L2:                            ;** Çcriture terminÇe

 mov ah,02
 mov bh,0
 mov dh,24
 mov dl,50
 int 10h

        mov bx,offset OS$
        mov ah,0eh
        jmp @L1
@L4:

 mov ah,02
 mov bh,0
 mov dh,12
 mov dl,21
 int 10h

 mov ah,0eh
 mov al,"["
 int 10h
 mov cx,19*2
 .loop1:
 mov al,"∞"
 int 10h
 loop .loop1
 mov al,"]"
 int 10h


 mov ah,02
 mov bh,0
 mov dh,12
 mov dl,22
 int 10h


        mov ax,BOOTSEG
        mov es,ax
        mov ds,ax

        mov ax,0305h            ;
        mov bx,0                ; modifie la vitesse du clavier (facultatif)
        int 16h                 ;

        mov     ax,KERNELS      ;**
        mov     es,ax           ;** es=segment du noyau=1000h
        mov     ds,ax
        mov     ah,2            ;** Fonction 2: Lecture de secteur(s)
        mov     al,17           ;** al=nombre de secteurs Ö lire=(18-1)=17
        xor     bx,bx           ;** bx=offset pour l'Çcriture=0 {ES:BX=1000:0000}
        xor     ch,ch           ;** ch=numÇro de la piste=0
        mov     cl,2            ;** cl=lire Ö partir du 2e secteur
        mov     dh,0
        mov     dl,gs:[509]

        int     13h             ;** appel du diskBIOS

        mov     al,gs:[509]

        DB      0EAH            ;\
        DW      0000H           ; > SAUTE A 1000:0000 => noyau
        DW      1000H           ;/
        
                                ;** Bloc des variables

OS$      DB      "QuickDream #8Operating #8System!"
MSG$     DB      "€€€€",LF,LF
         DB      "Please wait while loading system",0
; MSG$    DB      "#8Q#8u#8i#8c#8k#3D#3r#3e#3a#3m#9O#9S",0

ORG     509                     ;** On se place au deux derniers octets
        DB      BOOTDRV         ;** Un secteur fait 512 octets
        DW      MAGICW          ;** On y Çcrit le MagicWord (AA55)

end start                       ;** Fin du fichier (EOF)
