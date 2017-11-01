@echo off & setlocal EnableDelayedExpansion
:: [MyWinCleaner] Version 1.09 Build 09.05.2013
:: Kontakt: beerisgood.github@protonmail.com
::
:: Dieses Programm ist freie Software. Sie kˆnnen es unter den Bedingungen der
:: GNU General Public License, wie von der Free Software Foundation verˆffentlicht,
:: weitergeben und/oder modifizieren, entweder gem‰ﬂ Version 3 der Lizenz oder
:: (nach Ihrer Option) jeder sp‰teren Version.
::
:: Die Verˆffentlichung dieses Programms erfolgt in der Hoffnung, daﬂ es Ihnen
:: von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite
:: Garantie der MARKTREIFE oder der VERWENDBARKEIT F‹R EINEN BESTIMMTEN ZWECK.
:: Details finden Sie in der GNU General Public License.
::
:: Ein Exemplar der GNU General Public License ist auf http://www.gnu.org/licenses zu finden.

set progpfad=%~dp0MyWinCleaner.cmd
set progliste=11
title My Win Cleaner Version 1.0
if exist "C:\Users\Public\MyWinCleaner.cmd" del "C:\Users\Public\MyWinCleaner.cmd"
cd /d "%~dp0"
ver|find /i "6." >nul
if not errorlevel 1 goto :nt6
set Ordner1=%userprofile%\Anwendungsdaten\Adobe\Flash
set Ordner2=%userprofile%\Cookies
set Ordner4=%userprofile%\Lokale Einstellungen\Temporary Internet Files
set Ordner5=%userprofile%\Lokale Einstellungen\Verlauf
set Ordner6=%userprofile%\Anwendungsdaten\Sun\Java\Deployment\cache
set Ordner7=%userprofile%\Anwendungsdaten\Sun\Java\Deployment\tmp
set Ordner8=%userprofile%\Anwendungsdaten\Macromedia\Flash Player
set Ordner10=%userprofile%\Lokale Einstellungen\Microsoft\Media Player
set Ordner11=%userprofile%\Recent
goto :startclean
:nt6
set Ordner1=%AppData%\Adobe\Flash Player\AssetCache
set Ordner2=%AppData%\Microsoft\Windows\Cookies
set Ordner3=%LocalAppData%\Microsoft\Internet Explorer\Recovery\Last Active
set Ordner4=%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files
set Ordner5=%userprofile%\AppData\Local\Microsoft\Windows\History
set Ordner6=%userprofile%\AppData\LocalLow\Sun\Java\Deployment\cache
set Ordner7=%userprofile%\AppData\LocalLow\Sun\Java\Deployment\tmp
set Ordner8=%AppData%\Macromedia\Flash Player
set Ordner10=%LocalAppData%\Microsoft\Media Player
set Ordner11=%AppData%\Microsoft\Windows\Recent
:startclean
set Ordner9=%temp%

set progtext1=Adobe Flash Player Cache
set progtext2=Cookies
set progtext3=Internet Explorer Besuchte Seiten
set progtext4=Internet Explorer Temp
set progtext5=Internet Explorer Verlauf
set progtext6=Java Cache
set progtext7=Java Temp
set progtext8=Macromedia Flash Player Cache
set progtext9=Temp
set progtext10=Windows Media Player
set progtext11=Windows Zuletzt verwendete Dateien
echo …ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
echo ∫  My Win Cleaner  ∫
echo »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº
echo.
title My Win Cleaner Version 1.0 - Scanne...
::goto :own
if exist summe.txt del "summe.txt">nul
:progs
set /a progtry+=1
if %progtry% GTR %progliste% goto :scanende
if not exist "!Ordner%progtry%!" goto :progs
set Ordner=!Ordner%progtry%!
if "%progtry%"=="14" if "%Ordner:~-18%"=="%temp:~-18%" goto :progs
set progtext=!progtext%progtry%!
set OGb=0,0
set OG=0,0
set OG2=0,0
set b1=Kilob
set b2=B
for /f "tokens=3" %%i in ('dir /-c /s "%ordner%" 2^>nul^|find "Datei(en)"') do set OGb=%%i
if "%OGb%"=="0,0" for /f "tokens=3" %%i in ('dir /a:h /-c /s "%ordner%" 2^>nul^|find "Datei(en)"') do set OGb=%%i
if "%OGb%"=="0" goto :progs
if not "%progtext%"=="%progtext8%" for /f "tokens=3" %%i in ('dir /a:h /-c /s "%ordner%" 2^>nul^|find "Datei(en)"') do set /a OGb=%OGb%+%%i
:dir2
set /a ergebnis1=%OGb%/1024
set /a rest=%OGb%-%ergebnis1%*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024
set OG=%ergebnis1%,%kommazahl%
set OG2=%OGb%
if not %ergebnis1% GTR 1000 echo %ergebnis1%,%kommazahl%KB>>summe.txt&goto :dirend
set /a ergebnis2=%OGb%/1024/1024
set /a rest=%OGb%-%ergebnis2%*1024*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024/1024
set OG=%ergebnis2%,%kommazahl%
set OG2=%ergebnis1%
set b1=Megab
set b2=Kilob
if not %ergebnis2% GTR 1000 echo %ergebnis2%,%kommazahl%MB>>summe.txt&goto :dirend
set /a ergebnis=%OGb%/1024/1024/1024
set /a rest=%OGb%-%ergebnis%*1024*1024*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024/1024/1024
set OG=%ergebnis%,%kommazahl%
set OG2=%ergebnis2%
set b1=Gigab
set b2=Megab
echo %ergebnis2%,%kommazahl%MB>>summe.txt
:dirend
set /a number+=1
set Ordner%number%=%Ordner%
echo %number%] %progtext%: %OG% %b1%ytes (%OG2% %b2%ytes)
set prognumber=%prognumber% %number%
goto :progs

:scanende
color 08
echo.
if not exist summe.txt echo Gibt nix zu lîschen&goto :wahl
for /f "delims=" %%i in (summe.txt) do set tempvar=%%i&call :sub
goto :nachsub
 
:sub
echo %tempvar%|find "KB">nul
if errorlevel 1 goto :sub2
set tempvar=%tempvar:~0,-2%
echo %tempvar%|findstr ",">nul
if errorlevel 1 set tempmain=%tempvar%&set tempkomma=0&goto :sub02
echo %tempvar%|findstr ",[0-9][0-9]">nul
if errorlevel 1 goto :sub01
set tempvar=%tempvar:~0,-3%
set tempkomma=%tempvar:~-2%
goto :sub02
:sub01
set tempvar=%tempvar:~0,-2%
set tempkomma=%tempvar:~-1%
:sub02
if "%tempvar%"=="" goto :eof
set /a tempmain=%tempvar%/1024
set /a rest=%tempvar%-%tempmain%*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024
set /a tempkomma=%kommazahl%
goto :subend
:sub2
set tempvar=%tempvar:~0,-2%
echo %tempvar%|findstr ",">nul
if errorlevel 1 set tempmain=%tempvar%&set tempkomma=0&goto :eof
echo %tempvar%|findstr ",[0-9][0-9]">nul
if errorlevel 1 goto :sub3
set tempmain=%tempvar:~0,-3%
set tempkomma=%tempvar:~-2%
goto :subend
:sub3
echo %tempvar%|findstr ",[0-9]">nul
set tempmain=%tempvar:~0,-2%
set tempkomma=%tempvar:~-1%
:subend
set /a gesmain=%gesmain%+%tempmain%
set /a geskomma=%geskomma%+%tempkomma%
goto :eof

:nachsub
del "summe.txt"
if "%geskomma%" GEQ "100" set /a gesmain+=%geskomma:~0,1%&set geskomma=%geskomma:~-2%
title My Win Cleaner Version 1.0 - Scan fertig
echo Es kînnen bis zu %gesmain%,%geskomma% Megabytes entfernt werden
:wahl
set /a mitte=%number%/2-1
echo.&echo WÑhle die Ordner, getrennt von Leerzeichen aus. zB:1 %mitte% %number%&echo Oder drÅcke ,A' fÅr alle Ordner.
:wahlf
if exist "auswahl.txt" del "auswahl.txt"
set /p text= Wahl: 
if /i "%text%"=="A" echo %prognumber% >auswahl.txt&goto :wahlrun
echo %text% >auswahl.txt
:wahlrun
set /a t+=1
if "%t%"=="%progliste%" goto :showdel
for /f "tokens=%t%" %%i in (auswahl.txt) do (
if not "%%i"=="0" echo !Ordner%%%i!>>pfade.txt
)
goto :wahlrun
:showdel
del "auswahl.txt"
echo.
echo Beginne Reinigung...
:delrun
for /f "delims=: tokens=1,*" %%i in ('findstr /n $ "pfade.txt"') do set delo=%%j&call :dels
echo Fertig&goto :delend
:dels
del /S /Q "%delo%" >nul 2>nul
goto :eof
:delend
del "pfade.txt"

:ownf
if "%owno%"=="1" goto :own
echo.&echo  Noch eigene Ordner auswÑhlen?
set /p own= {J}a, {N}euer Scan, Jede andere beliebige Taste fÅr nein: 
if /i "%own%"=="J" goto :own
if /i "%own%"=="N" start %progpfad%&exit
exit

:own
set owno=1
set number=0
echo.
set /p oa= Gib die Anzahl der Ordner an: 
:ownorun
set /a oar+=1
if "%oar%" GTR "%oa%" goto :owndel
echo.&echo Gib den Ordnerpfad fÅr Ordner %oar% / %oa% ein
set /p myOrdner%oar%= Pfad: 
goto :ownorun

:owndel
set /a myprogtry+=1
if "%progtry%" GTR "%oa%" echo end&pause&goto :scanende
if not exist "!myOrdner%myprogtry%!" goto :progs
set Ordner=!myOrdner%myprogtry%!
set progtext=%ordner:~0,5%...%ordner:~-7%

call :number
call :dir
echo %number%] %myprogtext%: %OG% %b1%ytes (%OG2% %b2%ytes)
pause
set myprognumber=%myprognumber% %number%
goto :owndel