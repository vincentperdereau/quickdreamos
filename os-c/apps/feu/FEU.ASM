DosSeg
.model small
.386

.data

Pos    equ 40000
;rand   dw 1234h                         ; C'est une valeur au Pif (Gadget ?)
;buf    db 64700 dup(0)                  ; buf !!! Vive Le "C" (ouarf! ouarf!)

;--------------- Et ben on le commence ce Feu, oui ou non ? ----------------
;-- Le premier qui me dit que mon code il se r‚pŠte, je le merde !!!      --
;-- D'abord c'est fait exprŠs ... c'est un programme simple et petit donc --
;-- je peux me r‚peter ...                                                --
;-- A MORT LA BDR !!! A MORT LE COBOL !!! A MORT LES PROFS DE C !!!       --
;-- VIVE L'ASM (Et le TP aussi !!!)                                       --
;-- Use this code freely ...                                              --
;---------------------------------------- Arrakis From Kortex System Inc. --
.code
     Mov AX,13h                         ; Mode 13h (320x200x256)
     Int 10h                            ; Hop, on l'enclenche

     mov ah,0eh
     mov al,"d"
     int 10h

     xor ax,ax
     int 16h

     MOV AX,0A000h                      ; On charge le Segment Video
     MOV ES,AX                          ; dans le Registre ES

     Mov DX,3C8h                        ; Let the colors change
     XOR AH,AH
     XOR BX,BX

     Mov CX,11                          ; CH=0; CL=11
CB1: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     Inc bl                             ; Degrad‚ de bleu (Fonc‚)
     dec cl
     jnz CB1

     Mov CL,5
CB2: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     Dec bl                             ; Degrad‚ de bleu (Fonc‚)
     dec cl
     jnz CB2

     Mov CL,50
CB3: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     Inc ah                             ; Degrad‚ de Rouge
     dec cl
     jnz CB3

     Mov CL,63
CB4: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     Inc bh                             ; Degrad‚ de Vert(with R et B)
     dec cl
     jnz CB4

     Mov CL,58
CB5: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     Inc bl                             ; Degrad‚ de bleu (Fonc‚)
     dec cl
     jnz CB5

     Mov CL,51+13
CB6: Mov AL,CH                          ; SetPal (ch, ah, bh, bl)
     Out DX,AL                          ; Stylo No AH
     Inc DX                             ; DX = 3C9h
     Mov AL,AH                          ; Composante Rouge
     Out DX,AL
     Mov AL,BH                          ; Composante Vert
     Out DX,AL
     Mov AL,BL                          ; Composante Bleu
     Out DX,AL
     Dec DX                             ; DX = 3C8h

     Inc ch                             ; Stylo suivante
     dec cl
     jnz CB6


Boucle:
     Mov DX,3DAh                        ; On va attendre le d‚but de
VSync1:                                 ; la synchro, ca nous evitera
     In AL,DX                           ; de la rencontrer pendant qu'on
     Test AL,8                          ; affiche le resultat de notre
     Jnz VSync1                         ; super calcul de feu ( voir
VSync2:                                 ; plus bas pour d‚tails ) Dans ce
     In AL,DX                           ; on verrait le d‚but de l'ancienne
     Test AL,8                          ; image et la fin de la nouvelle
     Jz Vsync2                          ; ( ou peut ˆtre l'inverse?! )

     mov bx,2                         ; DS:BX pointe sur notre buf !!!
     Xor CL,CL                          ; CL=0 => 256 it‚rations
     Mov dx,ds:[0]
merdes:                                 ; On va afficher des merdes (cach‚es)
     Mov DI,dx   ;Rand                        ; Ici on calcul une valeur pseudo
     Add DI,1000100010001000b           ; al‚atoire, plus pseudo qu'aleatoire
     Ror DI,3                           ; d'ailleurs mais enfin ca rend pas
;     Mov Rand,DI   ; optimization      ; mal .... (Position aleatoire)
         MOV AX,DI                      ; optimization ...
     And DI,511
     Sub DI, 512-320
     Shl DI,2

;     Mov AX,Rand       ;optimization   ; Ici, on recommence le meme cirque
     Add AX,1100000011000000b
     RoR AX,3
     Mov dx,AX                        ; (valeur aleatoire)
;     add al,127                 ; optimization
     or  al,00000111b              ; mieux ???
     mov ah,al
     Mov [64000+BX+DI],ax
     Dec CL
     Jnz merdes
     mov ds:[0],dx

     Mov CX,64000-1280-Pos
     MOV DI,2560+Pos
     ADD bx,1280+Pos

Fuego:
     Xor AH,AH                          ; AH=0               |-------> x
     Xor DH,DH                          ; DH=0               |
                                        ;                    |
     Mov AL,[BX]                        ; AL=col(x,y)        V y
     Mov DL,[BX+2]
     Add AX,DX                          ; AX=AX+col(x+2,y)
     Mov DL,[BX+320]
     Add AX,DX                          ; AX=AX+col(x,y+1)
     Mov DL,[BX+321]
     Add AX,DX                          ; AX=AX+col(x+1,y+1)
     Mov DL,[BX+322]
     Add AX,DX                          ; AX=AX+col(x+2,y)+1
     Mov DL,[BX+640]
     Add AX,DX                          ; AX=AX+col(x,y+2)
     Mov DL,[BX+641]
     Add AX,DX                          ; AX=AX+col(x+1,y+2)
     Mov DL,[BX+642]
     Add AX,DX                          ; AX=AX+col(x+2,y+2)
     Shr AX,3                           ; AX=AX/8
     Dec al
     Jns Zarbi
     Inc Al
Zarbi:
     Mov [BX+1],AL                      ; buffer(x+1,y) = AL
     Mov ES:[DI+1],AL                   ; ecran(x+1,y) = AL
     Inc BX                             ; Inc( buf )
     Inc DI                             ; inc( ecran )
     Dec CX
     Jnz Fuego                          ; On boucle le smooth ...

     In AL,60h                          ; Lit port 60h
     Cmp AL,1                           ; 1 = touche ESC
     Jne Boucle                         ; Non, alors on boucle

     Mov AX,3h                          ; Mode 3 (80x25x16 TXT)
     Int 10h                            ; Hp, on l'enclenche

     mov ax,4c00h
     int 21h
end
