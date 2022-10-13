;**********************************************************************;
;*                         S 6 4 3 5 C A . A S M                      *;
;*--------------------------------------------------------------------*;
;*    Fonction        : contient des routines pour travailler avec les*;
;*                     sprites dans le mode 640*350 des cartes EGA    *;
;*                     et VGA                                         *;
;*--------------------------------------------------------------------*;
;*    Auteur        : MICHAEL TISCHER                                 *;
;*    D‚velopp‚ le  :  8.12.1990                                      *;
;*    DerniŠre MAJ  : 14.02.1992                                      *;
;*--------------------------------------------------------------------*;
;*    ModŠle m‚moire : SMALL                                          *;
;*--------------------------------------------------------------------*;
;*    Assemblage     : MASM /mx S6435CA;    ou   TASM -mx S6435CA     *;
;*                     ... puis lier … S6435C.C                       *;
;**********************************************************************;

IGROUP group _text                   ;Regroupe les segments de programme
DGROUP group _bss,  _data              ;regroupe les segments de donn‚es
       assume CS:IGROUP, DS:DGROUP, ES:DGROUP, SS:DGROUP

_BSS   segment word public 'BSS'        ;Segment des variables statiques
_BSS   ends                                            ;non initialis‚es

_DATA  segment word public 'DATA'        ;Segment des variables globales
                                              ;et statiques initialis‚es

_DATA  ends

;== Constantes =========================================================

SC_INDEX       = 3c4h      ;Registre d'index du contr“leur du s‚quenceur
SC_MAP_MASK    = 2                          ;Num‚ro du registre Map Mask
SC_MEM_MODE    = 4                   ;Num‚ro du registre de mode m‚moire

GC_INDEX       = 3ceh          ;Registre d'index du contr“leur graphique
GC_READ_MAP    = 4                          ;Num‚ro du registre Read Map
GC_BIT_MASK    = 8               ;Num‚ro du registre de masquage binaire

PIXX           = 640                             ;R‚solution horizontale

;== Programme ==========================================================

_TEXT  segment byte public 'CODE'                  ;Segment de programme

;-- D‚clarations publiques

public     _copybuf2video
public     _mergeandcopybuf2video
public     _copyvideo2buf

;-----------------------------------------------------------------------
;-- CopyBuf2Video: Recopie en m‚moire d'‚cran le contenu d'une zone
;--                rectangulaire pr‚alablement sauv‚e par CopyVideo2Buf
;-- D‚claration: CopyBuf2Plane( byte *bufptr,
;--                             byte verspage,
;--                             int  versx,
;--                             int  versy,
;--                             byte largeur,
;--                             byte hauteur );

_copybuf2video proc near

sfr0      struc                             ;Structure d'accŠs … la pile
bp0        dw ?                                             ;M‚morise BP
stofs0     dw ?          ;Var loc : Offset de d‚but dans m‚moire d'‚cran
ret_adr0   dw ?                          ;Adresse de retour … l'appelant
bufptr0    dw ?                                     ;Pointeur sur buffer
verspage   dw ?                                     ;Page de destination
versx      dw ?                                 ;Abscisse de destination
versy      dw ?                                 ;Ordonn‚e de destination
largeur0   dw ?                                                 ;Largeur
hauteur0   dw ?                                      ;Hauteur de la zone
sfr0      ends                                      ;Fin de la structure

fr     equ [ bp - bp0 ]               ;adr. les ‚l‚ments de la structure
bfr    equ byte ptr [ bp - bp0 ]          ;adr. ‚l‚ment pile comme octet

       sub   sp,2                ;De la place pour les variables locales

       push  bp                      ;Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                  ; par le registre BP

       push  si                                     ;Sauvegarde SI et DI
       push  di

       ;-- Calcule le segment d'accŠs … la m‚moire d'‚cran  ------------

       mov   ax,0A000h            ;ES au d‚but de la page de destination
       cmp   bfr.verspage,0                          ;Est-ce la page 0 ?
       je    cv0                                        ;Oui, AL est bon

       mov   ax,0A6D6h                              ;Non Page 1 en A6D6h

cv0:   mov   es,ax

       ;-- calcule l'offset de la position de destination dans la page -

       mov   ax,PIXX / 8                 ;AX sur position de destination
       mul   fr.versy
       mov   bx,fr.versx
       shr   bx,1
       shr   bx,1
       shr   bx,1
       add   bx,ax
       mov   fr.stofs0,bx             ;M‚morise le r‚sultat dans var loc

       mov   si,fr.bufptr0                   ;DS:SI pointe sur le buffer

       ;-- Initialise les compteurs pour la boucle de copie ------------

       mov   dl,bfr.largeur0                                ;DL = octets
       mov   bx,PIXX / 8                 ;BX = offset sur ligne suivante
       sub   bl,dl
       xor   ch,ch                         ;Octet haut du compteur tjs 0

       ;-- Pr‚pare l'adressage du plan de bits -------------------------

       mov   ah,1               ;Le num‚ro du plan est pris comme masque
       mov   al,SC_MAP_MASK          ;Charge le num‚ro du registre en AL

cv1:   mov   dx,SC_INDEX                     ;Cl“ture la demande d'accŠs
       out   dx,ax

       ;-- Routine de copie pour un plan de bits sans respect-----------
                                                            ;--  du fond

       mov   di,fr.stofs0                       ;DI sur offset de d‚part
       mov   dh,bfr.hauteur0                                ;DH = lignes
       mov   dl,bfr.largeur0                                ;DL = octets

cv2:   mov   cl,dl                                ;Nombre d'octets en CL

       rep   movsb                                      ;Copie une ligne
       add   di,bx                                ;DI sur ligne suivante
       dec   dh                                  ;Reste-t-il une ligne ?
       jne   cv2                                    ;Oui---> on continue

       shl   ah,1                                 ;Passe au plan suivant
       test  ah,16                       ;A-t-on trait‚ tous les plans ?
       je    cv1                              ;Non, on traite le suivant

       mov   ax,(0Fh shl 8)+ SC_MAP_MASK             ;Autorise l'accŠs …
       mov   dx,SC_INDEX                                 ;tous les plans
       out   dx,ax

       pop   di                                       ;R‚cupŠre DI et SI
       pop   si
       pop   bp                                             ;R‚cupŠre BP

       add   sp,2                          ;Retire les variables locales
       ret                                        ;Retourne … l'appelant

_copybuf2video endp

;-----------------------------------------------------------------------
;-- MergeAndCopyBuf2Video: Combine contenu buffer de fond avec celui
;--                       d'un buffer de sprite par l'interm‚diaire d'un
;--                       masque binaire et copie le r‚sultat dans la
;--                       m‚moire d'‚cran
;-- D‚claration : MergeAndCopyBuf2Video( void * spribufptr,
;--                                      void * fondbufptr,
;--                                      void * andbufptr,
;--                                      BYTE page,
;--                                      int  versx,
;--                                      int  versy,
;--                                      BYTE largeur,
;--                                      BYTE hauteur );
;-- Info         : cf CopyVideo2Buf

_mergeandcopybuf2video proc near

sfr2      struc                             ;Structure d'accŠs … la pile
bp2        dw ?                                            ; m‚morise BP
andptr2    dw ?                       ;Var loc: Pointeur dans buffer AND
stofs2     dw ?              ;Var loc: Offset de d‚but en m‚mire d'‚cran
ret_adr2   dw ?                          ;Adresse de retour … l'appelant
spribufptr dw ?                           ;Pointeur sur buffer de sprite
fondbufptr dw ?                             ;Pointeur sur buffer de fond
andbufptr  dw ?                                 ;Pointeur sur buffer AND
verspage2  dw ?                                     ;Page de destination
versx2     dw ?                                 ;Abscisse de destination
versy2     dw ?                                 ;Ordonn‚e de destination
largeur2   dw ?                                                 ;Largeur
hauteur2   dw ?                                      ;Hauteur de la zone
sfr2      ends                                      ;Fin de la structure

fr     equ [ bp - bp2 ]               ;adr. les ‚l‚ments de la structure
bfr    equ byte ptr [ bp - bp2 ]        ;adr. ‚l‚ments pile comme octets

       sub   sp,4                ;De la place pour les variables locales

       push  bp                      ;Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                  ; par le registre BP

       push  ds
       push  si
       push  di

       ;-- Calcule le segment d'accŠs … la m‚moire d'‚cran -------------

       mov   ax,0A000h            ;ES au d‚but de la page de destination
       cmp   bfr.verspage2,0                          ;Est-ce la page 0?
       je    cm0                                        ;Oui, AL est o.k

       mov   ax,0A6D6h                            ;Non , page 1 en A6D6h

cm0:   mov   es,ax

       ;-- calcule l'offset de la position de destination dans la page -

       mov   ax,PIXX / 8                 ;AX sur position de destination
       mul   fr.versy2
       mov   bx,fr.versx2
       shr   bx,1
       shr   bx,1
       shr   bx,1
       add   bx,ax
       mov   fr.stofs2,bx               ;M‚morise le r‚sultat en var loc

       ;-- Initialise les compteurs pour la boucle d'it‚ration ---------

       mov   dl,bfr.largeur2                                ;DL = octets
       mov   bx,PIXX / 8                 ;BX = offset sur ligne suivante
       sub   bl,dl
       xor   ch,ch                    ;Octet fort du compteur toujours 0

       ;-- Pr‚pare l'adressage du plan de bits -------------------------

       mov   ah,1                   ;Num‚ro du plan comme masque binaire

cm1:   mov   al,SC_MAP_MASK          ;Charge en AL le num‚ro du registre
       mov   dx,SC_INDEX                     ;Cl“ture la demande d'accŠs
       out   dx,ax

       ;-- Routine de copie pour un plan de bits sans tenir compte -----
       ;-- du fond -----------------------------------------------------

       mov   dx, word ptr fr.andbufptr                 ;Copie en var loc
       mov   word ptr fr.andptr2,dx            ;l'offset du pointeur AND

       mov   di,fr.stofs2                       ;DI sur offset de d‚part
       mov   dh,bfr.hauteur2                                ;DH = Lignes
       mov   dl,bfr.largeur2                                ;DL = octets

cm2:   mov   cl,dl                                ;Nombre d'octets en CL

cm3:   mov   si,fr.fondbufptr                  ;Charge pointeur de  fond
       lodsb                             ;Lit un octet du buffer du fond
       mov   word ptr fr.fondbufptr,si     ;M‚morise l'offset incr‚ment‚

       mov   si,fr.andptr2               ;Charge pointeur sur buffer AND
       and   al,[si]                 ;Combine le fond avec le masque AND
       inc   si                  ;Incr‚mente l'offset dans le buffer AND
       mov   word ptr fr.andptr2,si                    ;puis le m‚morise

       mov   si,fr.spribufptr           ;Charge ptr sur buffer du sprite
       or    al,[si]               ;Combine un octet de ce buffer par OR
       inc   si            ;Incr‚mente l'offset dans le buffer du sprite
       mov   word ptr fr.spribufptr,si                 ;puis le m‚morise

       stosb                          ;D‚pose l'octet en m‚moire d'‚cran
       loop  cm3                                 ;Traite l'octet suivant

       add   di,bx                                ;DI sur ligne suivante
       dec   dh                                  ;Reste-t-il une ligne ?
       jne   cm2                                   ;Oui ---> on continue

       shl   ah,1                                 ;Passe au plan suivant
       test  ah,16                 ;Tous les plans ont-ils ‚t‚ trait‚s ?
       je    cm1                                       ;Non, on continue

       mov   ax,(0Fh shl 8)+ SC_MAP_MASK               ;Autorise l'accŠs
       mov   dx,SC_INDEX                               ;… tous les plans
       out   dx,ax

       pop   di                                       ;R‚cupŠre DI et SI
       pop   si
       pop   ds                                             ;R‚cupŠre DS
       pop   bp

       add   sp,4                          ;Retire les variables locales
       ret                                        ;Retourne … l'appelant

_mergeandcopybuf2video endp

;-----------------------------------------------------------------------
;-- CopyVideo2Buf: Copie dans un buffer une zone rectangulaire de la
;--                m‚moire d'‚cran
;-- D‚claration : CopyPlane2Buf( byte *bufptr,
;--                              byte depage,
;--                              int  dex,
;--                              int  dey,
;--                              byte largeur,
;--                              byte hauteur );
;-- Info         : Dans cette version de la routine la zone … copier
;--                doit commencer … une colonne de pixels divisible par
;--                huit, et s'‚tendre sur un nombre de pixels multiple
;--                de huit.
;--                LARGEUR est ici le nombre d'octets par ligne dans un
;--                plan de bits !

_copyvideo2buf proc near

sfr1     struc                              ;Structure d'accŠs … la pile
bp1       dw ?                                              ;M‚morise BP
stofs1    dw ?              ;Var loc: Offset de d‚but en m‚moire d'‚cran
ret_adr1  dw ?                           ;Adresse de retour … l'appelant
bufptr1   dw ?                                      ;Pointeur sur buffer
depage    dw ?                                           ;Page d'origine
dex       dw ?                                       ;Abscisse d'origine
dey       dw ?                                       ;Ordonn‚e d'origine
largeur1  dw ?                             ;Largeur de la zone en pixels
hauteur1  dw ?                             ;Hauteur de la zone en pixels
sfr1     ends                                       ;Fin de la structure

fr     equ [ bp - bp1 ]               ;adr. les ‚l‚ments de la structure
bfr    equ byte ptr [ bp - bp1 ]          ;adr. ‚l‚ment pile comme octet

       sub   sp,2                ;de la place pour les variables locales

       push  bp                      ;Pr‚pare l'adressage des paramŠtres
       mov   bp,sp                                              ; par BP

       push  ds                                             ;m‚morise DS
       push  si                                      ;ainsi que SI et DI
       push  di

       push  ds                         ;Charge ES avec le contenu de DS
       pop   es                                  ;pour acc‚der au buffer

       ;-- Calcule le segment d'accŠs … la m‚moire d'‚cran -------------

       mov   ax,0A000h                 ;ES au d‚but de la page d'origine
       cmp   bfr.depage,0                            ;Est-ce la page 0 ?
       je    cc0                                        ;Oui, AL est bon

       mov   ax,0A6D6h                           ;Non , page 1 en  A6D6h

cc0:   mov   ds,ax

       ;-- Forme l'offset dans la page … lire --------------------------

       mov   ax,PIXX / 8                      ;AX sur position d'origine
       mul   fr.dey
       mov   bx,fr.dex
       shr   bx,1
       shr   bx,1
       shr   bx,1
       add   bx,ax
       mov   fr.stofs1,bx             ;m‚morise le r‚sultat dans var loc

       mov   di,fr.bufptr1                   ;ES:DI pointe sur le buffer

       ;-- Initialise les compteurs pour la boucle de copie ------------

       mov   dl,bfr.largeur1                                ;DL = octets
       mov   bx,PIXX / 8                ;BX =  Offset sur ligne suivante
       sub   bl,dl
       xor   ch,ch                         ;Octet fort du compteur tjs 0

       ;-- Pr‚pare l'adressage du plan de bits -------------------------

       xor   ah,ah                               ;Commence par le plan 0
       mov   al,GC_READ_MAP          ;Charge le num‚ro du registre en AL

cc1:   mov   dx,GC_INDEX          ;Adresse index du contr“leur graphique
       out   dx,ax                          ;Charge le registre Read Map

       ;-- Routine de copie d'un plan de bits, ne tient pas compte------
       ;-- du fond -----------------------------------------------------

       mov   dh,bfr.hauteur1                                ;DH = lignes
       mov   dl,bfr.largeur1                                ;DL = octets
       mov   si,fr.stofs1                        ;Offset de d‚part en SI

cc2:   mov   cl,dl                                ;Nombre d'octets en CL
       rep   movsb                                      ;Copie une ligne
       add   si,bx                                ;SI sur ligne suivante
       dec   dh                                  ;Reste-t-il une ligne ?
       jne   cc2                                        ;Oui on poursuit

       inc   ah                                   ;Passe au plan suivant
       cmp   ah,4                          ;A-t-on trait‚ ts les plans ?
       jne   cc1                          ;Non, c'est le tour du suivant
       pop   di                                       ;R‚cupŠre DI et SI
       pop   si
       pop   ds                                             ;R‚cupŠre DS

       pop   bp

       add   sp,2                          ;Retire les variables locales
       ret                                     ;et retourne … l'appelant

_copyvideo2buf endp

;== Fin=================================================================

_text    ends                               ;Fin du segment de programme
         end                             ;Fin de la source en assembleur
