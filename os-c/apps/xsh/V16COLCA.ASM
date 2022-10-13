;**********************************************************************;
;*                       V 1 6 C O L C A . A S M                      *;
;*--------------------------------------------------------------------*;
;*    Fonction       : contient diverses routines pour travailler     *;
;*                     dans les modes graphiques … 16 couleurs        *;
;*                     des cartes EGA et VGA                          *;
;*--------------------------------------------------------------------*;
;*    Auteur         : MICHAEL TISCHER                                *;
;*    D‚velopp‚ le   :  5.12.1990                                     *;
;*    DerniŠre MAJ   : 14.02.1992                                     *;
;*--------------------------------------------------------------------*;
;*    ModŠle m‚moire : SMALL                                          *;
;*--------------------------------------------------------------------*;
;*    Assemblage     : MASM /mx V16COLCA    ou     TASM -mx V16COLCA  *;
;**********************************************************************;

MGRP    group   VPSEG

       assume CS:MGRP, DS:MGRP, ES:MGRP, SS:MGRP


VPSEG  segment byte public     ; Segment pour toutes les variables
				    ; statiques et globales initialis‚es

VPSEG  ends

;== Constantes =========================================================

SC_INDEX       = 3c4h    ; Registre d'index du contr“leur du s‚quenceur.
SC_MAP_MASK    = 2                         ; Num‚ro du registre Map-Mask
SC_MEM_MODE    = 4                  ; Num‚ro du registre de mode m‚moire

GC_INDEX       = 3ceh         ; registre d'index du contr“leur graphique
GC_FN_SELECT   = 3         ; Num‚ro du registre de s‚lection de fonction
GC_READ_MAP    = 4                         ; Num‚ro du registre Read Map
GC_GRAPH_MODE  = 5                ; Num‚ro du registre de mode graphique
GC_MISCELL     = 6                           ; Num‚ro du registre divers
GC_BIT_MASK    = 8              ; Num‚ro du registre de masquage binaire

CRTC_INDEX     = 3d4h           ; registre d'index du contr“leur d'‚cran
CC_MAX_SCAN    = 9               ; Num‚ro du registre de lignes balay‚es
CC_START_HI    = 0Ch                       ; Num‚ro du registre Hi_Start
CC_UNDERLINE   = 14h                ; Num‚ro du registre de soulignement
CC_MODE_CTRL   = 17h            ; Nummer du registre de contr“le de mode

DAC_WRITE_ADR  = 3C8h                                ; Adresse DAC Write
DAC_READ_ADR   = 3C7h                                 ; Adresse DAC-Read
DAC_DATA       = 3C9h                         ; Registres de donn‚es DAC

VERT_RETRACE   = 3DAh                   ; Registre d'‚tat des entr‚es #1

PIXX           = 640                            ; R‚solution horizontale

; == Donn‚es ===========================================================

VPSEG  segment byte public

vio_seg    dw 0A000h                       ; Segment vid‚o page courante
largeurl   dw 0                ; Largeur d'une ligne de pixels en octets
pageofs    dw 0                      ; Offset de la page dans le segment

VPSEG  ends

VPSEG  segment byte public

	;-- Num‚ro de code associ‚ au mode 800*600 de diff‚rentes ------
	;-- cartes Super-VGA -------------------------------------------

modenr     db 6Ah, 58h, 29h, 54h, 16h, 79h
modenrend  equ this byte

VPSEG  ends


; == Programme =========================================================

VPSEG  segment byte public                  ; Segment de programme

;-- D‚clarations publiques ---------------------------------------------

public    _init640350                ; initialise le mode 640*350 pixels
public    _init800600
public    _init640480                ; initialise le mode 640*480 pixels
public    _init640200                ; initialise le mode 640*200 pixels
public    _init320200                ; initialise le mode 320*200 pixels
public    _setpix1                                     ; Dessine un pixel
public    _getpix1                            ; Lit la couleur d'un pixel
public    _setpix2                                     ; Dessine un pixel
public    _getpix2                            ; Lit la couleur d'un pixel

public    _showpage                             ; Affiche la page 0 ou 1
public    _setpage                  ; Fixe la page pour setpix et getpix
public    _getfontptr              ; retourne un pointeur sur le jeu 8*8
public    _scroll_up1
public    _barasm1
public    _scroll_up2
public    _barasm2

public    _waitretrace

;-----------------------------------------------------------------------
;-- INIT640350  : Mode graphique EGA en 16 couleurs de 640*350 pixels
;-- D‚claration : void init640350( void );

_init640350 proc near

       mov   al,10h                                   ; Fixe le mode 10h
       mov   cx,28000/16                             ; Offset de la page

init16:
       mov   bx,640/8                              ; Largeur de la ligne

init:  mov   largeurl,bx                           ; M‚morise la largeur
       mov   pageofs,cx              ; M‚morise l'offset de la page pour
						  ; l'adresse de segment

       xor   ah,ah                  ; Appelle la fonction 00h pour fixer
       int   10h                                               ; le mode

       ret                                                ; Rend la main

_init640350 endp                                   ; Fin de la proc‚dure

;-----------------------------------------------------------------------
;-- INIT640480: Initialise le mode graphique VGA 640*480 en 16 couleurs
;-- D‚claration : void init640480( void );

_init640480 proc near

       mov   al,12h                              ; Installe le mode 12hn

       ;-- L'offset de la page n'est pas int‚ressant car une seule page-
       ;-- est repr‚sentable -------------------------------------------
       jmp   init16

_init640480 endp                                   ; Fin de la proc‚dure

;-- INIT640200: initialise le mode graphique EGA 640*200 en 16 couleurs
;-- D‚claration: void init640200 (void);

_init640200 proc near

       mov   al,0Eh                               ; Installe le mode 0Eh
       mov   bx,640/8                               ; Largeur des lignes
       mov   cx,(64000/4)/16                         ; Offset de la page
       jmp   init16

_init640200 endp                                   ; Fin de la proc‚dure

;-----------------------------------------------------------------------
;-- INIT320200: initialise le mode graphique EGA 320*200 en 16 couleurs
;-- D‚claration : void init320200( void );

_init320200 proc near

       mov   al,0Dh                               ; Installe le mode 0Dh
       mov   bx,320/8                               ; Largeur des lignes
       mov   cx,(32000/4)/16                         ; Offset de la page
       jmp   init

_init320200 endp                                   ; Fin de la proc‚dure

;-----------------------------------------------------------------------
;-- INIT800600: initialise le mode 800*600 Super-VGA en 16 couleurs

;-- D‚claration : int init800600( void );
;-- Valeur de retour : 1 = mode initialis‚ , 0 = Erreur

_init800600 proc near


       ;-- Essaye les modes du tableau MODENR jusqu'… ce que l'un d'eux-
       ;--   soit accept‚ par le BIOS ----------------------------------

       mov  si,offset modenr    ;Commence par le premier mode du tableau
it1:   xor  ah,ah                      ;Fonction 00h: initialise le mode
       mov  al,[si]                 ;Charge le num‚ro de code du tableau
       int  10h                                      ;Initialise le mode
       mov  ah,0fh                          ;Fonction 0Fh: teste le mode
       int  10h
       cmp  al,[si]                        ;Le mode s'est-il d‚clench‚ ?
       je   it2                                              ;Oui --> OK

       ;-- Mauvais num‚ro de code, choisit le suivant dans le tableau --

       inc  si                                   ;SI sur le code suivant
       cmp  si,offset modenrend         ;A-t-on parcouru tt le tableau ?
       jne  it1                                      ;Non, on recommence

       xor  ax,ax               ;Oui, cl“ture la fonction par une erreur
       ret                                        ;Retourne … l'appelant

it2:   ;-- Le mode a pu ˆtre initialis‚ --------------------------------

       mov  ax,1                                           ;tout est bon
       ret                                          ;Retour … l'appelant

_init800600 endp                                    ;Fin de la proc‚dure


;-- SETPIX: Dessine un pixel dans une couleur donn‚e  ------------------
;-- D‚claration : void setpix( int x, int y, unsigned char farbe );

_setpix1    proc near

sframe    struc                            ; Structure d'accŠs … la pile
bp0        dw ?                                            ; M‚morise BP
ret_adr0   dw ?                         ; Adresse de retour … l'appelant
x0         dw ?                                             ; Abscisse X
y0         dw ?                                             ; Ordonn‚e Y
couleur    dw ?                                                ; Couleur
sframe    ends                                     ; Fin de la structure

frame  equ [ bp - bp0 ]           ; Adresse les ‚l‚ments de la structure

       push  bp                     ; Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                              ; par BP

       ;--Cacule d'abord l'offset en m‚moire d'‚cran et le d‚calage ----

       mov   ax,frame.y0                           ; Charge l'ordonn‚e Y
       mov   dx,largeurl             ; Multiplie par la largeur de ligne
       mul   dx
       mov   bx,frame.x0                           ; Charge l'abscisse X
       mov   cl,bl                       ; Octet faible pour le d‚calage

       shr   bx,1                            ; Divise l'abscisse X par 8
       shr   bx,1
       shr   bx,1
       add   bx,ax                      ; + offset de la multiplication.

       and   cl,7                 ; Calcule masque binaire … partir de X
       xor   cl,7
       mov   ah,1
       shl   ah,cl

       mov   dx,GC_INDEX                ; AccŠde au contr“leur graphique
       mov   al,GC_BIT_MASK       ; Charge masque bin dans reg de masque
       out   dx,ax

       mov   ax,(02h shl 8)+GC_GRAPH_MODE
				   ; D‚clenche le mode Write 2 & le mode
       out   dx,ax                                              ; Read 0

       mov   ax,vio_seg               ; ES=segment de la m‚moire d'‚cran
       mov   es,ax                                        ; avec la page
       mov   al,es:[bx]                       ; Charge le registre latch
       mov   al,byte ptr frame.couleur
					      ; Fixe la couleur du point
       mov   es:[bx],al                 ; R‚‚crit dans le registre latch

       ;-- R‚tablit les valeurs par d‚faut dans les registres du -------
       ;-- contr“leur graphique qui ont ‚t‚ modifi‚s -------------------

       mov   ax,(0FFh shl 8 ) + GC_BIT_MASK
       out   dx,ax

       mov   ax,(00h shl 8) + GC_GRAPH_MODE
       out   dx,ax

       pop   bp
       ret                                ; Retour au programme appelant

_setpix1    endp                                    ; Fin de la proc‚dure

;-- SETPIX: Dessine un pixel dans une couleur donn‚e --------------
;-- D‚claration : void setpix( int x, int y, unsigned char couleur );

_setpix2    proc near

sframe    struc                             ;Structure d'accŠs … la pile
bp0        dw ?                                             ;M‚morise BP
ret_adr0   dw ?                          ;Adresse de retour … l'appelant
x0         dw ?                                              ;Abscisse X
y0         dw ?                                              ;Ordonn‚e Y
couleur    dw ?                                                 ;Couleur
sframe    ends                                      ;Fin de la structure

frame  equ [ bp - bp0 ]            ;adresse les ‚l‚ments de la structure

       push  bp                      ;Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                  ; par le registre BP

       ;-- Calcule l'offset dans la m‚moire d'‚cran et le d‚calage -----

       mov   ax,frame.y0                           ;Charge l'ordonn‚e  Y
       mov   dx,800/8              ;Multiplie par la largeur d'une ligne
       mul   dx
       mov   bx,frame.x0                            ;Charge l'abscisse X
       mov   cl,bl               ;M‚morise l'octet faible pour le calcul
							   ; du d‚calage

       shr   bx,1                          ;Divise l'abscisse X par huit
       shr   bx,1
       shr   bx,1
       add   bx,ax          ;Y ajoute l'offset issu de la multiplication

       and   cl,7               ;Calcule le masque binaire … partir de X
       xor   cl,7
       mov   ah,1
       shl   ah,cl

       mov   dx,GC_INDEX                 ;AccŠde au contr“leur graphique
       mov   al,GC_BIT_MASK          ;Masque bin. dans registre masquage
       out   dx,ax                                  ; Effectue la sortie

       mov   ax,(02h shl 8) + GC_GRAPH_MODE ;D‚clenche le mode Write 2 &
       out   dx,ax                                               ;Read 0

       mov   ax,0A000h   ;Charge en RES le segment de la m‚moire d'‚cran
       mov   es,ax

       mov   al,es:[bx]                        ;Charge le registre latch
       mov   al,byte ptr frame.couleur                  ;Fixe la couleur
       mov   es:[bx],al                       ;R‚‚crit le registre latch

       ;-- Remet les valeurs par d‚faut dans les diff‚rents registres --
       ;-- du contr“leur graphique , qui ont ‚t‚ modifi‚s --------------

       mov   ax,(0FFh shl 8 ) + GC_BIT_MASK
       out   dx,ax

       mov   ax,(00h shl 8) + GC_GRAPH_MODE
       out   dx,ax

       pop   bp
       ret                                        ;Retourne … l'appelant

_setpix2    endp                                     ;Fin de la proc‚dure

;-- GETPIX: D‚termine la couleur d'un pixel ----------------------------
;-- D‚claration : unsigned char getpix( int x, int y );

_getpix2    proc near

sframe1   struc                             ;Structure d'accŠs … la pile
bp1        dw ?                                             ;M‚morise BP
ret_adr1   dw ?                          ;Adresse de retour … l'appelant
x1         dw ?                                              ;Abscisse X
y1         dw ?                                              ;Ordonn‚e Y
sframe1   ends                                      ;Fin de la structure

frame  equ [ bp - bp1 ]            ;adresse les ‚l‚ments de la structure

       push  bp                      ;Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                  ; par le registre BP

       push  si

       ;-- Calcule d'abord l'offset en m‚moire d'‚cran et le d‚calage --

       mov   ax,frame.y1                            ;Charge l'ordonn‚e Y
       mov   dx,800 / 8            ;Multiplie par la largeur d'une ligne
       mul   dx
       mov   si,frame.x1                            ;Charge l'abscisse X
       mov   cx,si                         ;La m‚morise pour le d‚calage

       shr   si,1                            ;Divise l'abscisse par huit
       shr   si,1
       shr   si,1
       add   si,ax          ;Y ajoute l'offset issu de la multiplication

       and   cl,7               ;Calcule le masque binaire … partir de X
       xor   cl,7
       mov   ch,1
       shl   ch,cl

       mov   ax,0A000h                          ;Charge en ES le segment
       mov   es,ax                               ; de la m‚moire d'‚cran

       mov   dx,GC_INDEX                 ;AccŠde au contr“leur graphique
       mov   ax,(3 shl 8)+ GC_READ_MAP                      ;Lit d'abord
       xor   bl,bl                                           ; le plan 3

gp1:   out   dx,ax                        ;Indique le plan de bit … lire
       mov   bh,es:[si]              ;Charge la valeur du registre latch
       and   bh,ch                       ;Ne garde que le pixel souhait‚
       neg   bh                      ;Fixe le bit 7 en fonction du pixel
       rol   bx,1              ;Rotation bit 7 de BH vers bit 1 dans BL.

       dec   ah                          ;Traite le plan de bits suivant
       jge   gp1                     ;sup ou ‚gal … 0 ? ---> on continue

       mov   al,bl                        ;R‚sultat de la fonction en AL

       pop   si
       pop   bp
       ret                                        ;Retourne … l'appelant

_getpix2    endp                                     ;Fin de la proc‚dure


;-- Bar: -------------------------
;-- D‚claration : void Bar( int x, int y, int x2, int y2
;                           unsigned char farbe );

_Barasm1    proc near
.386

bsframe    struc                            ; Structure d'accŠs … la pile
bbp0        dw ?                                            ; M‚morise BP
bret_adr0   dw ?                         ; Adresse de retour … l'appelant
bx0         dw ?                                             ; Abscisse X
by0         dw ?                                             ; Ordonn‚e Y
bx2         dw ?                           ; abs X2
by2         dw ?                           ; ord Y2
bcouleur    dw ?                                                ; Couleur
bsframe    ends                                     ; Fin de la structure

bframe  equ [ bp - bbp0 ]           ; Adresse les ‚l‚ments de la structure

       push  bp                     ; Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                              ; par BP

       ;--Cacule d'abord l'offset en m‚moire d'‚cran et le d‚calage ----

       push   es
       push   si
       push   di
       push   ds
       push   gs

       mov   ax,0a000h ; vio_seg               ; ES=segment de la m‚moire d'‚cran
       mov   es,ax                                        ; avec la page

       mov   di,bframe.by2
       mov   si,bframe.bx2
       mov   ax,bframe.by0                           ; Charge l'ordonn‚e Y
       mov   bx,bframe.bx0                           ; Charge l'abscisse X
       mov   ds,bx

boucle:
       mov   gs,bx
       mov   cx,ax
       mov   dx,ax
       shl   ax,6
       shl   dx,4
       add   ax,dx
       mov   dx,cx
       mov   cl,bl                       ; Octet faible pour le d‚calage
       shr   bx,3                            ; Divise l'abscisse X par 8
       add   bx,ax                      ; + offset de la multiplication.
       and   cl,7                 ; Calcule masque binaire … partir de X
       xor   cl,7
       mov   ah,1
       shl   ah,cl
       mov   cx,dx
       mov   dx,GC_INDEX                ; AccŠde au contr“leur graphique
       mov   al,GC_BIT_MASK       ; Charge masque bin dans reg de masque
       out   dx,ax
       mov   ax,(02h shl 8)+GC_GRAPH_MODE
       out   dx,ax                                              ; Read 0
       mov   al,es:[bx]                       ; Charge le registre latch
       mov   al,byte ptr bframe.bcouleur
       mov   es:[bx],al                 ; R‚‚crit dans le registre latch
       mov   ax,cx
       mov   bx,gs
       cmp   bx,si
       je    nexty
       inc   bx
       jmp   boucle
       nexty:
       cmp   ax,di
       je    end_bar
       inc   ax
       mov   bx,ds
       jmp   boucle

end_bar:
       mov   ax,(0FFh shl 8 ) + GC_BIT_MASK
       out   dx,ax
       mov   ax,(00h shl 8) + GC_GRAPH_MODE
       out   dx,ax
       pop   gs
       pop   ds
       pop   di
       pop   si
       pop   es
       pop   bp
       ret                                ; Retour au programme appelant
.286
_Barasm1    endp                                    ; Fin de la proc‚dure


;-- GETPIX: D‚termine la couleur d'un pixel   --------------------------
;-- D‚claration : unsigned char getpix( int x, int y );

_getpix1    proc near

sframe1   struc                            ; Structure d'accŠs … la pile
bp1        dw ?                                            ; M‚morise BP
ret_adr1   dw ?                         ; Adresse de retour … l'appelant
x1         dw ?                                             ; Abscisse X
y1         dw ?                                             ; Ordonn‚e Y
sframe1   ends                                     ; Fin de la structure

frame  equ [ bp - bp1 ]           ; adresse les ‚l‚ments de la structure

       push  bp                     ; Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                              ; par BP

       push  si

       ;--Calcule d'abord l'offset en m‚moire d'‚cran et le d‚calage ---

       mov   ax,frame.y1                           ; Charge l'ordonn‚e Y
       mov   dx,largeurl             ; Multiplie par la largeur de ligne
       mul   dx
       mov   si,frame.x1                           ; Charge l'abscisse X
       mov   cx,si                              ; et pr‚pare le d‚calage

       shr   si,1                                    ; Divise X par huit
       shr   si,1
       shr   si,1
       add   si,ax          ; +offset en provenance de la multiplication

       and   cl,7              ; Calcule le masque binaire … partir de X
       xor   cl,7
       mov   ch,1
       shl   ch,cl

       mov   ax,vio_seg          ; Charge en ES le segment de la m‚moire
       mov   es,ax                                ; d'‚cran avec la page

       mov   dx,GC_INDEX                ; AccŠde au contr“leur graphique
       mov   ax,(3 shl 8)+ GC_READ_MAP
						; Lit d'abord le plan #3
       xor   bl,bl

gp1_2:   out   dx,ax                              ; Indique le plan … lire
       mov   bh,es:[si]               ; Lit le contenu du registre latch
       and   bh,ch                   ; Ne conserve que le pixel concern‚
       neg   bh                                 ; Fixe le bit 7 du pixel
       rol   bx,1                 ; Effectue une rotation du bit 7 de BH
						   ; dans le bit 1 de BL

       dec   ah                  ; Pr‚pare le traitement du plan suivant
       jge   gp1_2                    ; sup ou ‚gal … 0 ? ---> on continue

       mov   al,bl                       ; R‚sultat de la fonction en AL

       pop   si
       pop   bp
       ret                                       ; Retourne … l'appelant

_getpix1    endp                                    ; Fin de la proc‚dure

;-- SETPAGE: S‚lectionne la page concern‚e par les appels aux fonctions-
;--          setpix et  getpix
;-- D‚claration : void setpage( int page );

_setpage   proc near

       pop   cx                             ; D‚pile l'adresse de retour
       pop   ax                                          ; et l'argument

       push  ax                            ; puis remet tout sur la pile
       push  cx
       mul   pageofs                   ; Multiplie le num‚ro de page par
						   ; l'offset de la page

       add   ax,0A000h                       ; Ajoute le segment de base
       mov   vio_seg,ax        ; M‚morise la nouvelle adresse de segment

       ret                      ; Retourne … l'appelant l'argument ayant
					    ; d‚j… ‚t‚ retir‚ de la pile

_setpage   endp                                    ; Fin de la proc‚dure

;-- SHOWPAGE: Affiche l'une des pages d'‚cran disponibles------
;-- D‚claration : void showpage( int page );

_showpage  proc near

       pop   cx                             ; D‚pile l'adresse de retour
       pop   ax                                   ; ainsi que l'argument

       push  ax                                 ; Remet tout sur la pile
       push  cx

       mul   pageofs                ; Multiplie le num‚ro de la page par
						   ; l'offset de la page
       mov   cl,4                                    ; et le tout par 16
       shl   ax,cl

       mov   bl,al                             ; M‚morise l'octet faible

       mov   dx,CRTC_INDEX               ; Adresse le contr“leur d'‚cran
       mov   al,CC_START_HI                  ; Emet d'abord l'octet fort
       out   dx,ax
       inc   al                                    ; puis l'octet faible
       mov   ah,bl
       out   dx,ax

       ;--Attend le d‚but d'un rafraŒchissement d'‚cran ----------------

       mov   dx,VERT_RETRACE         ; Attend d'abord la fin du balayage
sp3:   in    al,dx                                            ; vertical
       test  al,8
       jne   sp3

sp4:   in    al,dx                 ; puis le d‚but du retour du faisceau
       test  al,8
       je    sp4

       ret                                       ; Retourne … l'appelant

_showpage  endp                                    ; Fin de la proc‚dure

;-- GETFONTPTR: Retourne un pointeur FAR sur le jeu 8*8 ----------------
;-- D‚claration : void far * getfontptr( void ) ------------------------

_getfontptr proc near

      push  bp                                           ; Sauvegarde BP

      mov   ax,1130h          ; Charge les registres pour l'interruption
      mov   bh,6
      int   10h                         ; D‚clenche l'interruption vid‚o

      mov   dx,es                             ; TransfŠre ES:BP en DX:AX
      mov   ax,bp

      pop   bp                                  ; Reprend BP sur la pile
      ret                                        ; Retourne … l'appelant

_getfontptr endp                                   ; Fin de la proc‚dure

   ;
   ;    void scroll_up (int x,int y,int l,int h, char speed)
   ;
	assume  cs:MGRP
_scroll_up1     proc    near
	push    bp
	mov     bp,sp
	push    si
	push    di
   ;
   ;    {
   ;    asm {
   ;        push  ds
   ;
	push      ds
   ;
   ;        mov   dx, 0x3CE
   ;
	mov        dx, 03CEH
   ;
   ;        mov   ax, 0x0105
   ;
	mov        ax, 00105H
   ;
   ;        out   dx, ax
   ;
	out        dx, ax
   ;
   ;        cld
   ;
	cld
   ;
   ;        mov   cx, h
   ;
	mov        cx, [bp+10]
   ;
   ;        mov   ax, cx
   ;
	mov        ax, cx
   ;
   ;        shl   ax, 4
   ;
	shl        ax, 4
   ;
   ;        shl   cx, 6
   ;
	shl        cx, 6
   ;
   ;        add   cx, ax
   ;
	add        cx, ax
   ;
   ;        mov   bx, y
   ;
	mov        bx, [bp+6]
   ;
   ;        mov   ax, bx
   ;
	mov        ax, bx
   ;
   ;        shl   ax, 4
   ;
	shl        ax, 4
   ;
   ;        shl   bx, 6
   ;
	shl        bx, 6
   ;
   ;        add   bx, ax
   ;
	add        bx, ax
   ;
   ;        mov   ax, x
   ;
	mov        ax, [bp+4]
   ;
   ;        shr   ax, 3
   ;
	shr        ax, 3
   ;
   ;        add   bx, ax
   ;
	add        bx, ax
   ;
   ;        xor   dh, dh
   ;
	xor        dh, dh
   ;
   ;        mov   dl, speed
   ;
	mov        dl, [bp+12]
   ;
   ;        mov   ax, dx
   ;
	mov        ax, dx
   ;
   ;        shl   ax, 4
   ;
	shl        ax, 4
   ;
   ;        shl   dx, 6
   ;
	shl        dx, 6
   ;
   ;        add   dx, ax
   ;
	add        dx, ax
   ;
   ;        mov   ax, cx
   ;
	mov        ax, cx
   ;
   ;        add   ax, bx
   ;
	add        ax, bx
   ;
   ;        mov   cl, 1
   ;
	mov        cl, 1
   ;
   ;        mov   si, 0xA000
   ;
	mov        si, 0A000H
   ;
   ;        mov   ds, si
   ;
	mov        ds, si
   ;
   ;        mov   es, si
   ;
	mov        es, si
   ;
   ;        cmp   cl, 1
   ;
	cmp        cl, 1
   ;
      l1:
   ;        mov   si, bx
   ;
	mov        si, bx
   ;
   ;        mov   di, si
   ;
	mov        di, si
   ;
   ;        sub   di, dx
   ;
	sub        di, dx
   ;
   ;        mov   cx, l
   ;
	mov        cx, [bp+8]
   ;
   ;        shr   cx, 3
   ;
	shr        cx, 3
   ;
   ;        rep   movsb
   ;
	rep   movsb
   ;
   ;        add   bx, 80
   ;
	add        bx, 80
   ;
   ;        cmp   bx, ax
   ;
	cmp        bx, ax
   ;
   ;
	    jb    l1
   ;        pop   ds
   ;
	pop        ds
   ;
   ;     };
   ;    }
   ;
	pop     di
	pop     si
	pop     bp
	ret
_scroll_up1     endp

;-- Bar: -------------------------
;-- D‚claration : void Bar( int x, int y, int x2, int y2
;                           unsigned char farbe );

_Barasm2    proc near
.386

bsframe    struc                            ; Structure d'accŠs … la pile
bbp0        dw ?                                            ; M‚morise BP
bret_adr0   dw ?                         ; Adresse de retour … l'appelant
bx0         dw ?                                             ; Abscisse X
by0         dw ?                                             ; Ordonn‚e Y
bx2         dw ?                           ; abs X2
by2         dw ?                           ; ord Y2
bcouleur    dw ?                                                ; Couleur
bsframe    ends                                     ; Fin de la structure

bframe  equ [ bp - bbp0 ]           ; Adresse les ‚l‚ments de la structure

       push  bp                     ; Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                              ; par BP

       ;--Cacule d'abord l'offset en m‚moire d'‚cran et le d‚calage ----

       push   es
       push   si
       push   di
       push   ds
       push   gs

       mov   ax,0a000h ; vio_seg               ; ES=segment de la m‚moire d'‚cran
       mov   es,ax                                        ; avec la page

       mov   di,bframe.by2
       mov   si,bframe.bx2
       mov   ax,bframe.by0                           ; Charge l'ordonn‚e Y
       mov   bx,bframe.bx0                           ; Charge l'abscisse X
       mov   ds,bx

boucle_2:
       mov   gs,bx
       mov   cx,ax
       mov   dx,ax
       shl   ax,6
     ;  shl   dx,4    ; PA.
       mov bx,dx
       shl dx,5
       shl bx,2
       add ax,dx
       add ax,bx
       mov bx,gs


       ;add   ax,dx
       mov   dx,cx
       mov   cl,bl                       ; Octet faible pour le d‚calage
       shr   bx,3                            ; Divise l'abscisse X par 8
       add   bx,ax                      ; + offset de la multiplication.
       and   cl,7                 ; Calcule masque binaire … partir de X
       xor   cl,7
       mov   ah,1
       shl   ah,cl
       mov   cx,dx
       mov   dx,GC_INDEX                ; AccŠde au contr“leur graphique
       mov   al,GC_BIT_MASK       ; Charge masque bin dans reg de masque
       out   dx,ax
       mov   ax,(02h shl 8)+GC_GRAPH_MODE
       out   dx,ax                                              ; Read 0
       mov   al,es:[bx]                       ; Charge le registre latch
       mov   al,byte ptr bframe.bcouleur
       mov   es:[bx],al                 ; R‚‚crit dans le registre latch
       mov   ax,cx
       mov   bx,gs
       cmp   bx,si
       je    nexty_2
       inc   bx
       jmp   boucle_2
       nexty_2:
       cmp   ax,di
       je    end_bar_2
       inc   ax
       mov   bx,ds
       jmp   boucle_2

end_bar_2:
       mov   ax,(0FFh shl 8 ) + GC_BIT_MASK
       out   dx,ax
       mov   ax,(00h shl 8) + GC_GRAPH_MODE
       out   dx,ax
       pop   gs
       pop   ds
       pop   di
       pop   si
       pop   es
       pop   bp
       ret                                ; Retour au programme appelant
.286
_Barasm2    endp                                    ; Fin de la proc‚dure


   ;
   ;    void scroll_up (int x,int y,int l,int h, char speed)
   ;
	assume  cs:MGRP
_scroll_up2     proc    near
	push    bp
	mov     bp,sp
	push    si
	push    di
   ;
   ;    {
   ;    asm {
   ;        push  ds
   ;
	push      ds
   ;
   ;        mov   dx, 0x3CE
   ;
	mov        dx, 03CEH
   ;
   ;        mov   ax, 0x0105
   ;
	mov        ax, 00105H
   ;
   ;        out   dx, ax
   ;
	out        dx, ax
   ;
   ;        cld
   ;
	cld
   ;
   ;        mov   cx, h
   ;
	mov        cx, [bp+10]
   ;
   ;        mov   ax, cx
   ;
	mov        ax, cx
	shl        ax, 5
	shl        cx, 2
	add        cx, ax
	shl        ax,1
	add        cx,ax
	mov        bx, [bp+6]
	mov        ax, bx
	shl        ax, 5
	shl        bx, 2
	add        bx, ax
	shl        ax,1
	add        bx,ax
   ;
   ;        mov   ax, x
   ;
	mov        ax, [bp+4]
   ;
   ;        shr   ax, 3
   ;
	shr        ax, 3
   ;
   ;        add   bx, ax
   ;
	add        bx, ax
   ;
   ;        xor   dh, dh
   ;
	xor        dh, dh
   ;
   ;        mov   dl, speed
   ;
	mov        dl, [bp+12]
   ;
   ;        mov   ax, dx
   ;
	mov        ax, dx
	shl        ax, 5
	shl        dx, 2
	add        dx, ax
	shl        ax,1
	add        dx,ax

	mov        ax, cx
	add        ax, bx
   ;
   ;        mov   cl, 1
   ;
	mov        cl, 1
   ;
   ;        mov   si, 0xA000
   ;
	mov        si, 0A000H
   ;
   ;        mov   ds, si
   ;
	mov        ds, si
   ;
   ;        mov   es, si
   ;
	mov        es, si
   ;
   ;        cmp   cl, 1
   ;
	cmp        cl, 1
   ;
      l1_2:
   ;        mov   si, bx
   ;
	mov        si, bx
   ;
   ;        mov   di, si
   ;
	mov        di, si
   ;
   ;        sub   di, dx
   ;
	sub        di, dx
   ;
   ;        mov   cx, l
   ;
	mov        cx, [bp+8]
   ;
   ;        shr   cx, 3
   ;
	shr        cx, 3
   ;
   ;        rep   movsb
   ;
	rep   movsb
   ;
   ;        add   bx, 80
   ;
	add        bx,100
	   ;
   ;        cmp   bx, ax
   ;
	cmp        bx, ax
   ;
   ;
	    jb    l1_2
   ;        pop   ds
   ;
	pop        ds
   ;
   ;     };
   ;    }
   ;
	pop     di
	pop     si
	pop     bp
	ret
_scroll_up2     endp


_waitretrace proc
	push ax dx
	mov dx,3dah
	lu:
	in al,dx
	test al,8
	jz lu
	l2:
	in al,dx
	test al,8
	jnz l2
	pop dx ax
	ret
_waitretrace endp


; == Fin ===============================================================
VPSEG    ends                              ; Fin du segment de programme
	 end                            ; Fin de la source en assembleur
