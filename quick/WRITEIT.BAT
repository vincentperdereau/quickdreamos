@echo off
cls
echo.
echo Ins‚rez une disquette vierge.
echo.
pause
.\util\floppy.exe
.\util\cf.exe
.\util\wsector .\bin\dreamos.bin 0 0 1 18
.\util\tinyfs "put .\bin\init.bin init"
.\util\tinyfs "put .\bin\sh.bin sh"
.\util\tinyfs "mkdir etc"
.\util\tinyfs "put .\bin\init.rc /etc/init.rc"
.\util\tinyfs "put .\bin\shut.rc /etc/shut.rc"
.\util\tinyfs "put .\bin\qwin\qwin.rc /etc/qwin.rc"
.\util\tinyfs "put .\bin\qwin\qshut.rc /etc/qshut.rc"
.\util\tinyfs "put .\bin\qwin\tools.rc /etc/tools.rc"
.\util\tinyfs "put .\bin\qwin\system.rc /etc/system.rc"
.\util\tinyfs "put .\bin\qwin\apps.rc /etc/apps.rc"
.\util\tinyfs "put .\bin\qwin\term.rc /etc/term.rc"
.\util\tinyfs "mkdir lib"
.\util\tinyfs "mkdir lib/fnt"
.\util\tinyfs "mkdir lib/kbd"
.\util\tinyfs "mkdir bin"
.\util\tinyfs "mkdir dev"
.\util\tinyfs "mkdir home"
.\util\tinyfs "mkdir doc"
.\util\tinyfs "mkdir src"
.\util\tinyfs "mkdir src/math"
.\util\tinyfs "mkdir src/system"
.\util\tinyfs "mkdir src/api"
.\util\tinyfs "mkdir qwin"
.\util\tinyfs "put .\bin\antique /lib/fnt/antique"
.\util\tinyfs "put .\bin\hylas.fnt /lib/fnt/hylas.fnt"
.\util\tinyfs "put .\bin\breeze.fnt /lib/fnt/breeze.fnt"
.\util\tinyfs "put .\bin\comp.fnt /lib/fnt/comp.fnt"
.\util\tinyfs "put .\bin\modern-1.fnt /lib/fnt/modern.fnt"
.\util\tinyfs "put .\bin\bold.fnt /lib/fnt/bold.fnt"
.\util\tinyfs "put .\bin\italics.fnt /lib/fnt/italics.fnt"
.\util\tinyfs "put .\bin\roman-1.fnt /lib/fnt/roman.fnt"

.\util\tinyfs "put .\bin\shut.bmp /lib/shut.bmp"
rem .\util\tinyfs "put .\bin\shutd.bmp /lib/shutd.bmp"
.\util\tinyfs "put .\bin\vasm.bin /bin/as"
.\util\tinyfs "put .\bin\xsh.bin /bin/xsh"
.\util\tinyfs "put .\bin\ved.bin /bin/ved"
.\util\tinyfs "put .\bin\ng.bin /bin/ng"
rem .\util\tinyfs "put .\bin\pshot.bin /bin/pshot"
.\util\tinyfs "put .\bin\date.bin /bin/date"
.\util\tinyfs "put .\bin\pak.bin /bin/pak"
.\util\tinyfs "put .\bin\mmap.bin /bin/mmap"
.\util\tinyfs "put .\bin\type.bin /bin/type"
.\util\tinyfs "put .\bin\debugfs.bin /bin/debugfs"
.\util\tinyfs "put .\bin\hostname.bin /bin/hostname"
.\util\tinyfs "put .\bin\fire.bin /bin/fire"
.\util\tinyfs "put .\bin\kmsg.bin /bin/kmsg"
.\util\tinyfs "put .\bin\qwin\qwin.ini /qwin/qwin.ini"
.\util\tinyfs "put .\bin\qwin\keyb.bin /qwin/keyb"
.\util\tinyfs "put .\bin\qwin\wpal.bin /qwin/wpal"
.\util\tinyfs "put .\bin\qwin\np.bin /qwin/np"
.\util\tinyfs "put .\bin\qwin\dock.bin /qwin/dock"
.\util\tinyfs "put .\bin\qwin\ds.bin /qwin/ds"
.\util\tinyfs "put .\bin\qwin\exec.bin /qwin/exec"
.\util\tinyfs "put .\bin\qwin\logon.bin /qwin/logon"
.\util\tinyfs "put .\bin\qwin\int.bin /qwin/int"
.\util\tinyfs "put .\bin\qwin\keyb.ico /qwin/keyb.ico"
.\util\tinyfs "put .\bin\qwin\eye.ico /qwin/eye.ico"
.\util\tinyfs "put .\bin\qwin\color.ico /qwin/color.ico"
.\util\tinyfs "put .\bin\qwin\logon.ico /qwin/logon.ico"

.\util\tinyfs "put .\bin\qwin\mem.ico /qwin/mem.ico"
.\util\tinyfs "put .\bin\qwin\exec.ico /qwin/exec.ico"
.\util\tinyfs "put .\bin\qwin\term.ico /qwin/term.ico"
.\util\tinyfs "put .\bin\qwin\shut.ico /qwin/shut.ico"

.\util\tinyfs "put .\bin\qwin\win.pal /qwin/win.pal"
.\util\tinyfs "put .\bin\qwin\next.pal /qwin/next.pal"
.\util\tinyfs "put .\bin\qwin\boot.bmp /qwin/boot.fig"
.\util\tinyfs "put .\bin\qwin\logo.bmp /qwin/logo.pic"

rem ****** Keyboard driver, select one *******
.\util\tinyfs "put .\bin\french.bin /lib/kbd/keymap"

.\util\tinyfs "put .\bin\french.bin /lib/kbd/fr.map"
.\util\tinyfs "put .\bin\german.bin /lib/kbd/gr.map"
.\util\tinyfs "put .\bin\british.bin /lib/kbd/br.map"
.\util\tinyfs "put .\bin\us.bin /lib/kbd/us.map"

rem ****** driver ****************************
rem .\util\tinyfs "put .\bin\cs4235.bin /lib/cs4235"

.\util\tinyfs "put .\bin\serial.bin /dev/cua0"
.\util\tinyfs "put .\bin\ps2m.bin /dev/ps2mouse"
.\util\tinyfs "put .\doc\sh.doc /doc/sh.doc"
.\util\tinyfs "put .\doc\as.doc /doc/as.doc"
.\util\tinyfs "put .\doc\api.doc /doc/api.doc"
.\util\tinyfs "put .\bin\gpl.txt /doc/gpl.txt"
.\util\tinyfs "put .\bin\debugfs.bin /bin/debugfs"
.\util\tinyfs "put .\bin\test.asm /src/test.s"
.\util\tinyfs "put .\bin\install install"

rem cls
rem choice /c:on Copy source files ?
rem if errorlevel 2 goto no1

.\util\tinyfs "put .\bin\src\system\date.s /src/system/date.s"
.\util\tinyfs "put .\bin\src\system\hostname.s /src/system/hostname.s"
.\util\tinyfs "put .\bin\src\system\reboot.s /src/system/reboot.s"
.\util\tinyfs "put .\bin\src\system\mouse.s /src/system/mouse.s"
.\util\tinyfs "put .\bin\src\system\mmap.s /src/system/mmap.s"
.\util\tinyfs "put .\bin\src\math\prime.s /src/math/prime.s"
.\util\tinyfs "put .\bin\src\api\iotst.s /src/api/iotst.s"
.\util\tinyfs "put .\bin\src\api\sysinfo.s /src/api/sysinfo.s"
.\util\tinyfs "put .\bin\whello.s /src/whello.s"


cd .\doc\qd
call writeit.bat
cd ..\..

echo Termin‚
echo.

:end
