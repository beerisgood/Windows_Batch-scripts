@echo off
cd /d "%~dp0"
title 32Bit accesschk
set exe=accesschk.exe
call :loop
set exe=accesschk64.exe
title 64Bit accesschk
call :loop
echo. & echo Ende & pause & exit

:loop
echo "C:\Program Files" - Benutzer:
%exe% -w -s -nobanner -u Benutzer "C:\Program Files"
pause
cls
echo "C:\Program Files (x86)" - Benutzer:
%exe% -w -s -nobanner -u Benutzer "C:\Program Files (x86)"
pause
cls
echo "C:\Windows" - Benutzer:
%exe% -w -s -nobanner -u Benutzer "C:\Windows"
pause
cls
echo "C:\Program Files" - Jeder:
%exe% -w -s -nobanner -u Jeder "C:\Program Files"
pause
cls
echo "C:\Program Files (x86)" - Jeder:
%exe% -w -s -nobanner -u Jeder "C:\Program Files (x86)"
pause
cls
echo "C:\Windows" - Jeder:
%exe% -w -s -nobanner -u Jeder "C:\Windows"
pause
cls
echo "C:\Program Files" - "Authentifizierte Benutzer":
%exe% -w -s -nobanner -u "Authentifizierte Benutzer" "C:\Program Files"
pause
cls
echo "C:\Program Files (x86)" - "Authentifizierte Benutzer":
%exe% -w -s -nobanner -u "Authentifizierte Benutzer" "C:\Program Files (x86)"
pause
cls
echo "C:\Windows" - "Authentifizierte Benutzer":
%exe% -w -s -nobanner -u "Authentifizierte Benutzer" "C:\Windows"
pause
cls
echo "C:\Program Files" - Interaktiv:
%exe% -w -s -nobanner -u Interaktiv "C:\Program Files"
pause
cls
echo "C:\Program Files (x86)" - Interaktiv:
%exe% -w -s -nobanner -u Interaktiv "C:\Program Files (x86)"
pause
cls
echo "C:\Windows" - Interaktiv:
%exe% -w -s -nobanner -u Interaktiv "C:\Windows"
pause
cls