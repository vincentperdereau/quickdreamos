; Keyboard map file for U.S. Keyboards
; Support for U.S. Keyboards is only a dummy driver because BIOS is in
; U.S. mode at startup. Because to the fact that Init loads a French font
; as default this driver is needed.
; Version 1.0 (Date: 1.8.2000)
; email: heinz.rath@gmx.at
.MODEL SMALL
.CODE
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

DB      1                     ; Number of keys 
DB      "U.S.               ",0 ; Name of MAP file (19 Bytes)
;        01234567891234567890
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
END                
                   
