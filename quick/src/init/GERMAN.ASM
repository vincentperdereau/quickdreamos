; Keyboard map file for German/Austrian Keyboards
; Support for German/Austrian Keyboards
; written by Heinz Rath
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

DB      31                    ; Number of keys
DB      "German             ",0 ; Name of MAP file (19 Bytes)
;        01234567891234567890
DB      002,'1','!',000
DB      003,'2','"',000
DB      004,'3','ı',000
DB      005,'4','$',000
DB      006,'5','%',000
DB      007,'6','&',000
DB      008,'7','/',000
DB      009,'8','(',000
DB      010,'9',')',000
DB      011,'0','=',000
DB      012,'·','?',000
DB      016,'q','Q','@'
DB      021,'z','Z',000
DB      026,'Å','ö',000
DB      027,'+','*','~'
DB      039,'î','ô',000
DB      040,'Ñ','é',000
DB      043,'#',39 ,000
DB      044,'y','Y',000 
DB      050,'m','M','Ê' 
DB      051,',',';',000 
DB      052,'.',':',000
DB      053,'-','_',000
DB      086,'<','>','|'
DB      121,000,000,'˝'
DB      122,000,000,'¸'
DB      126,000,000,'{'
DB      127,000,000,'['
DB      128,000,000,']'
DB      129,000,000,'}'
DB      130,000,000,'\'
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
