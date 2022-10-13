;***************************
;**   Loading of keymap   **
;***************************
; Keymap loading routine loads keymaps for support of different keyboards
; written by Heinz Rath
; Version 1.1 (Date: 1.8.2000) 
; Version 1.0 (Date:30.7.2000) 
; email: heinz.rath@gmx.at

; The routine searches for a file called keymap in the /lib/kbd
; directory. If no file is found the default keymap (French) which is
; defined in the INIT.ASM is used.

; Description of format of Keymap files
; First the number of keys (1 Byte) must be at least 1
; Name of defination file (19 Bytes)
; 0 Byte
; 60 Lines with 4 Bytes. Lines have the following format
;    SC,NC,EC,AC
; SC....Scan code
; NC....Normal char (char that is shown when pressing the key)
; EC....Extended char (char that is shown when key+shift is pressed)
; AC....Alt Char (char that is shown when key+Alt Gr is pressed)
; Lines which are not used look like this 000,000,000,000
; When a number + Alt GR is pressed then are special Scan codes produced
; AltGR+key     ScanCode
; 1             120
; 2             121
; 3             122
; 4             123
; 5             124
; 6             125
; 7             126
; 8             127 
; 9             128
; 0             129
; (key after 0) 130
;----------------------------------------------------------------------------
                        push ds
                        push si
                        push eax
                        push ecx
                        push edx
                        push es

                        mov ax,ds
                        mov es,ax
                        ; Writes "keyboard:"
                        xor ax,ax
                        mov ah,API$PRINTLN
                        mov si,offset keyboard$
                        int KERNEL$INT

                        ; Opens the "keymap" file
                        mov  ah,API$FOPEN
                        mov  si,offset keymapfile
                        int KERNEL$INT      
                        cmp eax,2
                        jl ready

                        ; Reads
                        mov edx,eax
                        mov di,offset Keymap
                        mov ecx,261
                        mov ah,API$FREAD
                        int KERNEL$INT

ready:                  ; Writes the Keymap Infostring 
                        mov ah,API$PRINTLN
                        mov si,offset Keymap
                        inc si
                        int KERNEL$INT
                        jmp outkey

 keyboard$              DB      LF,CR,"keyboard:        ",0
 keymapfile             DB      "/lib/kbd/keymap",0

outkey:                 pop es
                        pop edx
                        pop ecx
                        pop eax
                        pop si
                        pop ds
