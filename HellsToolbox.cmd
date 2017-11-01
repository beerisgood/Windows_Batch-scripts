@echo off
:: [Hell's Toolbox] Version 2.0 Build 18.02.2017
:: Größe des Scriptes: 58,6 KB (60.030 Bytes)
:: Copyright (C) 2010-2017 beerisgood
:: Kontakt: beerisgood.github@protonmail.com
::
:: Dieses Programm ist freie Software. Sie können es unter den Bedingungen der
:: GNU General Public License, wie von der Free Software Foundation veröffentlicht,
:: weitergeben und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder
:: (nach Ihrer Option) jeder späteren Version.
::
:: Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen
:: von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite
:: Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK.
:: Details finden Sie in der GNU General Public License.
::
:: Ein Exemplar der GNU General Public License ist auf http://www.gnu.org/licenses zu finden.

cd /d "%~dp0"
color 8
set title=Hell's Toolbox
set builddate=18.02.2017
set taste=Beliebige Taste drcken, um fortzufahren.
set #=  	#
if "%1"=="admin" goto :start5
if exist "%temp%\admintools.txt" (
net session >nul 2>&1
if not errorlevel 1 goto :start5
)
:start
cls
title %title% - Hauptmen
echo 		   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo 		   º                                      º
echo 		   º            Hell's Toolbox            º
echo 		   º            ______________            º
echo 		   º                                      º
echo 		   º             Version 2.0              º
echo 		   º                                      º
echo 		   ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
echo.
echo.
echo   Deine Auswahl:
echo   --------------
echo.
echo   		 (S)ysteminfos, (I)nternettools, (T)uning, (K)ram
echo.
echo 		      (A)dmintools, (P)rogramminfos, (E)xit
echo.&echo.&echo.
choice /C SITKAPCE /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 8 color& cls& exit /b
goto :start%errorlevel%

:start1
cls
title %title% - Systeminfos
echo.
echo  Systeminfos
echo  -----------
echo.
for /f "tokens=2,* delims= " %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA') do set uacstate=%%b
if not defined uacstate set uac=Inaktiv/ šbersprungen&goto :nouac
echo %uacstate%|find "0x0">nul
if not errorlevel 1 set uac=Aus&goto :nouac
for /f "tokens=2,* delims= " %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin') do set uaclevel1=%%b
if "%uaclevel1%"=="0x5" (
for /f "tokens=2,* delims= " %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop') do set uaclevel2=%%b
)
if "%uaclevel2%"=="0x0" ( set uaclevel=Niedrig ) else set uaclevel=Normal
if "%uaclevel1%"=="0x0" set uac=Aus&goto :nouac
if "%uaclevel1%"=="0x2" set uaclevel=Hoch
set uac=An
:nouac
net user "%username%" 2> nul | find /i "admin" > nul
if not errorlevel 1 (
set ad=Ja
if not defined sessionname goto :badadmin
echo  Du bist als Adminstrator eingeloggt,
if "%uac%"=="Inaktiv/ šbersprungen" echo  und wirst nicht durch die UAC geschtzt, da nicht vorhanden&set uac=- UAC: Nicht vorhanden&goto :pcinfos
if "%uac%"=="Aus" echo  und wirst nicht durch die UAC geschtzt&set uac=- UAC: Aus&goto :pcinfos
echo  wirst aber durch die UAC - Level: %uaclevel% geschtzt&set uac=- UAC: Aktiv - Level: %uaclevel%
goto :pcinfos
)
if defined sessionname (
:lowuser
echo  Du bist als eingeschr„nkter User eingeloggt
set ad=Nein, Eingeschränkter User
set uac=
goto :pcinfos
)
:badadmin
echo  Du bist mit vollen Adminstratorrechten eingeloggt.
echo  Dies ist nicht empfohlen!
echo.
echo  Lesen warum?
choice /C JN /N /M " (j)a, (n)ein: "
if errorlevel 2 goto :pcinfos
if errorlevel 1 start http://forum.chip.de/windows-xp/faq-arbeiten-eingeschraenkten-rechten-970574.html

:pcinfos
echo.
if not defined whoami ( for /f "skip=1 tokens=2" %%i in ('whoami /user^|find "S"') do set SID=%%i ) else ( for /f "tokens=*" %%i in ('dir "%userprofile%\Lokale Einstellungen\Anwendungsdaten\Microsoft\Credentials" /A:D /B') do set SID=%%i )
echo  User SID: %SID%
echo.
for /f "delims=+." %%i in ('wmic os get InstallDate^|find "2"') do set installdate=%%i
echo  Windows wurde am %installdate:~6,2%.%installdate:~4,2%.%installdate:~0,4% um %installdate:~8,2%:%installdate:~10,2%:%installdate:~12% installiert
for /f "tokens=5" %%i in ('powercfg -getactivescheme') do echo  und befindet sich gerade im  %%i Modus
for /f "tokens=3*" %%i in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0"^|find "ProcessorNameString"') do set cpu=%%i %%j
echo.
for /f "skip=1 tokens=*" %%i in ('wmic computersystem get manufacturer^|findstr /i [a-z]') do set mainboardcreator=%%i
for /f "skip=1" %%i in ('wmic computersystem get model^|findstr /i [a-z]') do set mainboard=%%i
echo  Mainboard: %mainboard% von %mainboardcreator%
for /f "skip=1 tokens=*" %%i in ('wmic bios get name^|findstr /i [a-z]') do set biosn=%%i
for /f %%i in ('wmic bios get smbiosbiosversion^|findstr [1-9]') do set biosv=%%i
for /f %%i in ('wmic bios get releasedate^|findstr [1-9]') do set biosd=%%i
echo  Bios: "%biosn%" Version %biosv% vom %biosd:~6,2%.%biosd:~4,2%.%biosd:~0,4%
echo.
echo  Festplatten-Info:
wmic DISKDRIVE get Model,Status,FirmwareRevision

:nosysinfo
echo.
echo  Systeminfos speichern?
choice /N /M "(j)a, (n)ein: "
if errorlevel 2 goto :start

:sysend
set sysinf=Systeminfos.txt
if exist "%sysinf%" del "%sysinf%"
echo Systeminfos vom %date:~0% um %time:~0,8% Uhr:>>%sysinf%
echo.>>%sysinf%
echo Name des Computers: %computername%>>%sysinf%
if "%uac%"=="Inaktiv/ šbersprungen" echo Mit Admin Rechte eingeloggt: %ad%, UAC nicht vorhanden>>%sysinf%&goto :userlogdata
if "%uac%"=="Aus" echo Mit Admin Rechte eingeloggt: %ad%, UAC aus>>%sysinf%&goto :userlogdata
echo Mit Admin Rechte eingeloggt: %ad%, UAC auf Level: %uaclevel%>>%sysinf%
:userlogdata
echo Eingeloggt als User: %Username%>>%sysinf%
echo User SID: %SID% >>%sysinf%
echo.>>%sysinf%
if defined installdate echo Installationsdatum: %installdate:~6,2%.%installdate:~4,2%.%installdate:~0,4% um %installdate:~8,2%:%installdate:~10,2%:%installdate:~12% >>%sysinf%
echo.>>%sysinf%
echo CPU: %cpu% - Anzahl Kerne: %NUMBER_OF_PROCESSORS% >>%sysinf%
echo Mainboard: %mainboard% von %mainboardcreator%>>%sysinf%
echo Bios: %biosn% Version %biosv%>>%sysinf%
:sysende
echo.
echo  "%sysinf%" wurde unter "%~dp0" erstellt.
echo.
echo        %taste%
pause>nul
goto :start


:start2
cls
title %title% - Internettools
echo.
echo  Internettools
echo  -------------
echo.
echo  	(I)nfos, (P)ingen, (V)erbindug testen, (N)etstat
echo.
echo      (W)ebseiten-Cache anzeigen, (D)NS-Cache leeren, (H)auptmen
echo.&echo.
choice /C IPVNWDH /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 7 goto :start
goto :inettools%errorlevel%

:inettools1
echo.
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "IP-A"') do set IP=%%i
if not defined IP for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "IPv4"') do set IP=%%i
if not defined IP set IP=keine
echo  Interne IPv4 Adresse: %IP%
for /f "tokens=5 skip=2" %%i in ('ipconfig^|find "IPv6"') do echo %%i>>%temp%\ipv6.txt
if not exist %temp%\ipv6.txt goto :exip
set /p ipv6= <%temp%\ipv6.txt
del "%temp%\ipv6.txt"
echo  Interne IPv6 Adresse: %ipv6%
if "%IP%"=="keine" goto :noexip
ping -n 1 ccc.de>nul
if errorlevel 1 ping -n 1 netzpolitik.org>nul
if errorlevel 1 goto :noexip
:exip
cscript /?>nul
if errorlevel 1 set ExtIP=konnte wegen CScript Fehler nicht ermittelt werden&goto :noexip2
set URL=http://checkip.dyndns.com/
set G=%temp%\GetHTML.vbs
echo On Error Resume Next:Set Http=CreateObject("WinHttp.WinHttpRequest.5.1"):Http.Open "GET",WScript.Arguments(0),False:Http.Send:Q=Split(Http.ResponseText,":")(1):WScript.Echo Trim(Split(Q,"<")(0))>%G%
for /f %%i in ('cscript //nologo //B %G% "%URL%"') do set "ExtIP=%%i"
del "%G%"
:noexip2
echo.
echo  Externe IP Adresse: %ExtIP%
:noexip
echo.
set DHCP=Aktiviert
set DHCPd=
for /f "tokens=2 Delims=:" %%i in ('ipconfig /all^|find "DHCP"') do set DHCPt=%%i
if not "%DHCPt%"=="Ja" (
set DHCP=Deaktiviert
sc query DHCP|find /i "Running" >nul
if not errorlevel 1 set DHCPd= - Dienst l„uft aber
)
echo  DHCP aktiviert: %DHCP%%DHCPd%
:dns
echo.
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "Stand"^|find "%IP:~0,3%"') do set DNSSERVER=%%i
if not defined DNSSERVER set DNSSERVER=keiner
echo  DNS SERVER: %DNSSERVER%
echo.
for /f "tokens=2 Delims=:" %%i in ('ipconfig /all^|find "Physi"^|find /V "00-00"') do set MAC=%%i
if not defined MAC for /f "tokens=4" %%i in ('getmac /v /nh^|findstr "Nicht zutreffend"') do set MAC=%%i
if not defined MAC set MAC=unbekannt
echo  MAC Adresse: %MAC%
echo.
for /f "tokens=2 Delims=:" %%i in ('ipconfig /all^|find /i "Netbios"') do set NETBIOS=%%i
if not defined NETBIOS set NETBIOS=unbekannt
echo  NetBios ber TCP/IP: %NETBIOS%
echo.
echo  Infos speichern?
choice /N /M "(j)a, (n)ein: "
if errorlevel 2 goto :start2

:inetsave
set sysinf=Internetinfos.txt
if exist "%sysinf%" del "%sysinf%"
echo Systeminfos vom %date:~0% um %time:~0,8% Uhr:>>%sysinf%
echo.>>%sysinf%
echo Name des Computers: %computername%>>%sysinf%
echo Interne IP Adresse: %IP%>>%sysinf%
if defined ipv6 echo IPv6 Adresse: %ipv6%>>%sysinf%
if "%IP%"=="keine" goto :noexipw
echo Externe IP Adresse: %ExtIP%>>%sysinf%
:noexipw
echo DHCP aktiviert: %DHCP%%DHCPd%>>%sysinf%
echo DNS SERVER: %DNSSERVER%>>%sysinf%
echo MAC Adresse: %MAC%>>%sysinf%
echo NetBios über TCP/IP: %NETBIOS%>>%sysinf%
echo.
echo  "%sysinf%" wurde unter "%~dp0" erstellt.
echo.
echo        %taste%
pause>nul
goto :start2

:inettools2
echo.
echo  Ausgabe speichern lassen?
set ping=
choice /C NJ /N /M "(j)a, (n)ein: "
if errorlevel 2 set ping=j

:ping
echo.
echo  Welche Webseite m”chtest du anpingen?
set /P ping2= http://
if /i "%ping%"=="j" goto :pspeichern
ping %ping2%
goto :pingend

:pspeichern
echo %date:~0% - %time:~0,8% Uhr:>>ping.txt: http://%ping2%>>ping.txt
ping %ping2%>>ping.txt
echo.>>ping.txt
echo.&echo  Datei "ping.txt" wurde angelegt.
:pingend
echo.
echo        %taste%
pause>nul
goto :start2

:inettools3
echo.
set inetv=Lan
set routerp=Ja
set wwwp=Ja
set dnscheck=Ok
set router=Unbekannt
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "Stand"') do set router=%%i
if "%router%"==" " (
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "Stand"') do echo %%i>>%temp%\router.txt
set /p router= <%temp%\router.txt
del "%temp%\router.txt"
)
echo %router%|find ".">nul
if not errorlevel 1 goto :prouter
for /f "tokens=2" %%i in ('nslookup 127.0.0.1^|find "S"') do set routerls=%%i
cls
for /f "tokens=3" %%i in ('ping %routerls% -n 1^|find "Ant"') do set router=%%i
if errorlevel 1 set router=IP Unbekannt
:prouter
ping -n 1 %router% >nul
if errorlevel 1 set routerp=Nein
echo  Verbindung zum Router (%router% ): %routerp%
if defined routerls echo  Routerloginseite: %%i & goto :inettestdns
for /f "tokens=2" %%i in ('nslookup 127.0.0.1^|find "S"') do echo  Routerloginseite: %%i
:inettestdns
ping -n 1 ccc.de >nul
if not errorlevel 1 goto :dnsok 
echo  Router DNS Check: Probleme bei IP Aufl”sung
echo.&echo Soll versucht werden die DNS Probleme zu beheben?
echo.
choice /N /M "(j)a, (n)ein: "
if errorlevel 2 set dnscheck=Probleme bei IP Aufl”sung &goto :dnsok

echo Leere den DNS-Aufl”sungscache...
ipconfig /flushdns>nul
ping -n 1 ccc.de >nul
if not errorlevel 1 set dnscheck=OK &goto :dnsok
echo Erneuere die IPv4 Adresse...
ipconfig /renew >nul
ping -n 1 ccc.de >nul
if not errorlevel 1 set dnscheck=OK &goto :dnsok
echo DNS Einstellungen prfen!
set dnscheck=Probleme bei IP Aufl”sung
:dnsok
echo.
echo  Router DNS Check: %dnscheck%
ping -n 1 heise.de>nul
if errorlevel 1 ping -n 1 ccc.de>nul
if errorlevel 1 set wwwp=Nein
ipconfig /all|find "Lease erhalten">nul
if not errorlevel 1 set inetv=WLan
echo  Verbindung zum Internet: %wwwp% (ber %inetv%)
for /f "tokens=2" %%i in ('netstat -e^|find "Fehler"') do set efehler=%%i
for /f "tokens=3" %%i in ('netstat -e^|find "Fehler"') do set vfehler=%%i
echo.
echo  Fehler bei empfangenen Bytes: %efehler%
echo  Fehler bei versendeten Bytes: %vfehler%
echo.&echo Teste IPv6 Zugang...
ver|find /i "5." >nul
if not errorlevel 1 set ipv6=Nicht M”glich&goto :ipv6e
for /f "tokens=10" %%i in ('ping -n 1 -6 six.heise.de^|find "Verloren"') do set ipv6t1=%%i
if not defined ipv6t1 for /f "tokens=10" %%i in ('ping -n 1 -6 ipv6.google.com^|find "Verloren"') do set ipv6t1=%%i
if "%ipv6t1%"=="1" set ipv6=Nicht M”glich&goto :ipv6e
ping -n 1 -R six.heise.de>nul
if errorlevel 1 set ipv6=Eingeschr„nkt m”glich via IPv4 Tunnel&goto :ipv6e
set ipv6=Uneingeschränkt m”glich
:ipv6e
echo IPv6 Zugang: %ipv6%
echo.
echo        %taste%
pause>nul
goto :start2

:inettools4
echo.&echo  Daten werden ermittelt..
for /f "tokens=1 delims=[]" %%i in ('netstat -anop TCP^|find /N "TCP"') do set /a tcp=%%i
for /f "tokens=1 delims=[]" %%i in ('netstat -anop TCPv6^|find /N "TCP"') do set /a tcpv6=%%i
for /f "tokens=1 delims=[]" %%i in ('netstat -anop UDP^|find /N "UDP"') do set /a udp=%%i
for /f "tokens=1 delims=[]" %%i in ('netstat -anop UDPv6^|find /N "UDP"') do set /a udpv6=%%i
if not defined tcp set tcp=0
if not defined tcpv6 set tcpv6=0
if not defined udp set udp=0
if not defined udpv6 set udpv6=0
if not "%tcp%"=="0" set /a tcp=%tcp%-4
if not "%udp%"=="0" set /a udp=%udp%-4
if not "%tcpv6%"=="0" set /a tcpv6=%tcpv6%-4
if not "%udpv6%"=="0" set /a udpv6=%udpv6%-4
:tcpv4
set /a tcpudp=%tcp%+%tcpv6%+%udp%+%udpv6%
echo TCP: %tcp% - TCPv6: %tcpv6% >~netstat.txt
echo UDP: %udp% - UDPv6: %udpv6% >>~netstat.txt
echo Gesamt: %tcpudp% >>~netstat.txt
chcp 1252>nul
ver | find /i "6." >nul
if not errorlevel 1 goto :tcp6
echo  Verbindungen werden aufgelistet...
netstat -anbo>>~netstat.txt
goto :tcp5

:tcp6
echo  Verbindungen werden aufgelistet...
netstat -ano>>~netstat.txt

:tcp5
chcp 850>nul
echo.
echo  (Textdatei muss geschlossen werden, bevor es hier weiter geht)
echo.
~netstat.txt
del /q "~netstat.txt"
goto :start2

:inettools5
chcp 850>nul
echo Stand: %date% - %time%:>dns.txt
ipconfig /displaydns>>dns.txt
echo.
echo  "dns.txt" wurde unter "%~dp0" erstellt.
echo.
echo        %taste%
pause>nul
goto :start2

:inettools6
ipconfig /flushdns>nul
echo.&echo Der DNS-Aufl”sungscache wurde geleert.
echo.
echo        %taste%
pause>nul
goto :start2


:start3
cls
title %title% - Tuning
setlocal DisableDelayedExpansion
echo.
echo  Tuning
echo  ------
echo.
echo 		(U)nn”tige Dateien l”schen, (M)RU-Cache leeren
echo.
echo		(I)conCache reparieren, (B)rowser Hardening, (H)auptmen
echo.&echo.
choice /C UMIBH /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 5 goto :start
goto :tuning%errorlevel%

:tuning1
set A=
cls
title %title% - Reinigung
echo.
echo  Reinigung
echo  ---------
echo.
echo  Es wird zuerst nur eine Liste der l”schbaren Elemente angezeigt.
echo.
echo  		:: Beende alle Programme weitesgehend,
echo     		   um den besten Erfolg zu erzielen ::
echo.
echo        %taste%
pause>nul
cls
echo.
echo  Reinigung
echo  ---------
echo.
setlocal EnableDelayedExpansion
set progliste=12
set Ordner=12
set progtext=12
set Ordner1=%AppData%\Adobe\Flash Player\AssetCache
set Ordner2=%AppData%\Microsoft\Windows\Cookies
set Ordner3=%LocalAppData%\Microsoft\Internet Explorer\Recovery\Last Active
set Ordner4=%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files
set Ordner5=%userprofile%\AppData\Local\Microsoft\Windows\History
set Ordner6=%userprofile%\AppData\LocalLow\Sun\Java\Deployment\cache
set Ordner7=%userprofile%\AppData\LocalLow\Sun\Java\Deployment\tmp
set Ordner8=%AppData%\Macromedia\Flash Player
set Ordner10=%LocalAppData%\Microsoft\Media Player
set Ordner11=%SystemRoot%\Temp
set Ordner12=%AppData%\Microsoft\Windows\Recent
set papierkorb=$Recycle.Bin
for /f "skip=1 tokens=2" %%i in ('whoami /user^|find "S"') do set sid=%%i
:startclean
set Ordner9=%temp%
set progtext1=Adobe Flash Player Cache
set progtext2=Internet Explorer Cookies
set progtext3=Internet Explorer Besuchte Seiten
set progtext4=Internet Explorer Temp
set progtext5=Internet Explorer Verlauf
set progtext6=Java Cache
set progtext7=Java Temp
set progtext8=Macromedia Flash Player Cache
set progtext9=Temp
set progtext10=Windows Media Player
set progtext11=Windows Temp
set progtext12=Windows Zuletzt verwendete Dateien

for %%i in (C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do ( if exist %%i:\ set laufwerk=%%i&call :enum )
goto :neuerscan
:enum
dir %laufwerk%:\%papierkorb%\%sid% >nul 2>nul
if errorlevel 1 goto :eof
set /a progliste+=1
set /a Ordner+=1
set /a progtext+=1
set Ordner%Ordner%=%laufwerk%:\%papierkorb%\%sid%
set progtext%progtext%=Papierkorb Laufwerk %laufwerk%
goto :eof

:neuerscan
if exist summe.txt del "summe.txt">nul
:progs
set /a progtry+=1
if %progtry% GTR %progliste% goto :scanende
if not exist "!Ordner%progtry%!" goto :progs
set Ordner=!Ordner%progtry%!
set progtext=!progtext%progtry%!
set OGb=0,0
set OG=0,0
set b1=Kilob
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
if not %ergebnis1% GTR 1000 echo %ergebnis1%,%kommazahl%KB>>summe.txt&goto :dirend
set /a ergebnis2=%OGb%/1024/1024
set /a rest=%OGb%-%ergebnis2%*1024*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024/1024
set OG=%ergebnis2%,%kommazahl%
set b1=Megab
if not %ergebnis2% GTR 1000 echo %ergebnis2%,%kommazahl%MB>>summe.txt&goto :dirend
set /a ergebnis=%OGb%/1024/1024/1024
set /a rest=%OGb%-%ergebnis%*1024*1024*1024
set /a rest2=%rest%*100
set /a kommazahl=%rest2%/1024/1024/1024
set OG=%ergebnis%,%kommazahl%
set b1=Gigab
echo %ergebnis2%,%kommazahl%MB>>summe.txt
:dirend
set /a number+=1
set Ordner%number%=%Ordner%
echo %number%] %progtext%: %OG% %b1%ytes
set prognumber=%prognumber% %number%
goto :progs

:scanende
color 08
echo.
if not exist summe.txt echo Gibt nix zu l”schen&echo.&pause&goto :tuning
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
echo Es k”nnen bis zu %gesmain%,%geskomma% Megabytes entfernt werden
:wahl
set /a mitte=%number%/2-1
echo.&echo W„hle die Ordner, getrennt von Leerzeichen aus. zB:1 %mitte% %number%&echo Oder drcke ,A' fr alle Ordner. (,Z' um zum Hauptmen zu gelangen)
:wahlf
if exist "auswahl.txt" del "auswahl.txt"
set /p text= Wahl: 
if /i "%text%"=="Z" goto :tuning
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
echo.&echo  Noch eigene Ordner ausw„hlen?
set /p own= {J}a, {N}euer Scan, Jede andere beliebige Taste fr nein: 
if /i "%own%"=="J" goto :own
if /i "%own%"=="N" goto :neuerscan
goto :tuning

:own
set owno=1
set number=0
echo.
set /p oa= Gib die Anzahl der Ordner an: 
:ownorun
set /a oar+=1
if "%oar%" GTR "%oa%" goto :owndel
echo.&echo Gib den Ordnerpfad fr Ordner %oar% / %oa% ein
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


:tuning2
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f >nul
echo.&echo  MRU Cache gel”scht
echo.
echo        %taste%
pause>nul
goto :start3


:tuning4
set IE=%temp%\IE.reg
cls
echo.
echo  Auswahl:
echo  (1): Internet Explorer: Zoneneinstellung auf Maximum inkl. Geschtzten Modus
echo  (2): Internet Explorer: Datenschutz auf Maximum
echo  (3): Internet Explorer: Physische Position verbieten
echo  (4): Internet Explorer: Popup Blocker auf Maximum
echo  (5): Internet Explorer: DOM-Storage verbieten
echo  (6): Zurck
echo.
choice /C 123456 /N /M " Deine Eingabe: "
if errorlevel 6 goto :start3
goto :ie%errorlevel%
:ie1
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1] >>%IE%
echo "1001"=dword:00000003 >>%IE%
echo "1200"=dword:00000003 >>%IE%
echo "1206"=dword:00000003 >>%IE%
echo "1207"=dword:00000003 >>%IE%
echo "1208"=dword:00000003 >>%IE%
echo "1209"=dword:00000003 >>%IE%
echo "120B"=dword:00000003 >>%IE%
echo "1400"=dword:00000003 >>%IE%
echo "1402"=dword:00000003 >>%IE%
echo "1405"=dword:00000003 >>%IE%
echo "1406"=dword:00000003 >>%IE%
echo "1407"=dword:00000003 >>%IE%
echo "1408"=dword:00000003 >>%IE%
echo "1409"=dword:00000000 >>%IE%
echo "1601"=dword:00000001 >>%IE%
echo "1604"=dword:00000003 >>%IE%
echo "1606"=dword:00000003 >>%IE%
echo "1607"=dword:00000003 >>%IE%
echo "1608"=dword:00000003 >>%IE%
echo "160A"=dword:00000003 >>%IE%
echo "1802"=dword:00000001 >>%IE%
echo "1803"=dword:00000003 >>%IE%
echo "1804"=dword:00000003 >>%IE%
echo "1809"=dword:00000000 >>%IE%
echo "1A00"=dword:00010000 >>%IE%
echo "1A02"=dword:00000003 >>%IE%
echo "1A03"=dword:00000003 >>%IE%
echo "1A04"=dword:00000003 >>%IE%
echo "1A05"=dword:00000003 >>%IE%
echo "1A06"=dword:00000003 >>%IE%
echo "1C00"=dword:00000000 >>%IE%
echo "2000"=dword:00000003 >>%IE%
echo "2005"=dword:00000003 >>%IE%
echo "2100"=dword:00000003 >>%IE%
echo "2101"=dword:00000003 >>%IE%
echo "2102"=dword:00000003 >>%IE%
echo "2103"=dword:00000003 >>%IE%
echo "2104"=dword:00000003 >>%IE%
echo "2105"=dword:00000003 >>%IE%
echo "2106"=dword:00000003 >>%IE%
echo "2200"=dword:00000003 >>%IE%
echo "2201"=dword:00000003 >>%IE%
echo "2300"=dword:00000003 >>%IE%
echo "2301"=dword:00000000 >>%IE%
echo "2400"=dword:00000003 >>%IE%
echo "2401"=dword:00000003 >>%IE%
echo "2402"=dword:00000003 >>%IE%
echo "2600"=dword:00000003 >>%IE%
echo "2700"=dword:00000000 >>%IE%
echo "2007"=dword:00000003 >>%IE%
echo "2004"=dword:00000003 >>%IE%
echo "2001"=dword:00000003 >>%IE%
echo "2107"=dword:00000003 >>%IE%
echo "1812"=dword:00000001 >>%IE%
echo "270B"=dword:00000003 >>%IE%
echo "270C"=dword:00000000 >>%IE%
echo "270D"=dword:00000003 >>%IE%
echo "2701"=dword:00000003 >>%IE%
echo "2702"=dword:00000000 >>%IE%
echo "2703"=dword:00000003 >>%IE%
echo "2704"=dword:00000003 >>%IE%
echo "CurrentLevel"=dword:00012000 >>%IE%
echo "2500"=dword:00000000 >>%IE%
regedit /s %IE%
echo Lokales Intranet Zone geh„rtet
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2]>>%IE%
echo "1001"=dword:00000003>>%IE%
echo "1200"=dword:00000003>>%IE%
echo "1207"=dword:00000003>>%IE%
echo "1208"=dword:00000003>>%IE%
echo "120B"=dword:00000003>>%IE%
echo "1400"=dword:00000003>>%IE%
echo "1402"=dword:00000003>>%IE%
echo "1405"=dword:00000003>>%IE%
echo "1407"=dword:00000003>>%IE%
echo "1408"=dword:00000003>>%IE%
echo "1601"=dword:00000001>>%IE%
echo "1604"=dword:00000003>>%IE%
echo "1606"=dword:00000003>>%IE%
echo "1608"=dword:00000003>>%IE%
echo "160A"=dword:00000003>>%IE%
echo "1802"=dword:00000001>>%IE%
echo "1803"=dword:00000003>>%IE%
echo "1804"=dword:00000003>>%IE%
echo "1A00"=dword:00010000>>%IE%
echo "1A02"=dword:00000003>>%IE%
echo "1A03"=dword:00000003>>%IE%
echo "1A05"=dword:00000003>>%IE%
echo "1A06"=dword:00000003>>%IE%
echo "1C00"=dword:00000000>>%IE%
echo "2000"=dword:00000003>>%IE%
echo "2005"=dword:00000003>>%IE%
echo "2100"=dword:00000003>>%IE%
echo "2101"=dword:00000003>>%IE%
echo "2103"=dword:00000003>>%IE%
echo "2104"=dword:00000003>>%IE%
echo "2105"=dword:00000003>>%IE%
echo "2106"=dword:00000003>>%IE%
echo "2300"=dword:00000003>>%IE%
echo "2400"=dword:00000003>>%IE%
echo "2401"=dword:00000003>>%IE%
echo "2402"=dword:00000003>>%IE%
echo "2600"=dword:00000003>>%IE%
echo "2700"=dword:00000000>>%IE%
echo "2007"=dword:00000003>>%IE%
echo "2004"=dword:00000003>>%IE%
echo "2001"=dword:00000003>>%IE%
echo "2107"=dword:00000003>>%IE%
echo "1812"=dword:00000001>>%IE%
echo "270B"=dword:00000003>>%IE%
echo "270C"=dword:00000000>>%IE%
echo "270D"=dword:00000003>>%IE%
echo "2701"=dword:00000003>>%IE%
echo "2703"=dword:00000003>>%IE%
echo "2704"=dword:00000003>>%IE%
echo "CurrentLevel"=dword:00012000>>%IE%
echo "2500"=dword:00000000>>%IE%
regedit /s %IE%
echo Vertrauenswrdige Seiten Zone geh„rtet
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3]>>%IE%
echo "1001"=dword:00000003>>%IE%
echo "1200"=dword:00000003>>%IE%
echo "1400"=dword:00000003>>%IE%
echo "1402"=dword:00000003>>%IE%
echo "1405"=dword:00000003>>%IE%
echo "1407"=dword:00000003>>%IE%
echo "1601"=dword:00000001>>%IE%
echo "1604"=dword:00000003>>%IE%
echo "1606"=dword:00000003>>%IE%
echo "1608"=dword:00000003>>%IE%
echo "1802"=dword:00000001>>%IE%
echo "1803"=dword:00000003>>%IE%
echo "1804"=dword:00000003>>%IE%
echo "1A00"=dword:00010000>>%IE%
echo "1A02"=dword:00000003>>%IE%
echo "1A03"=dword:00000003>>%IE%
echo "1A05"=dword:00000003>>%IE%
echo "1A06"=dword:00000003>>%IE%
echo "1C00"=dword:00000000>>%IE%
echo "2000"=dword:00000003>>%IE%
echo "2100"=dword:00000003>>%IE%
echo "2101"=dword:00000003>>%IE%
echo "2106"=dword:00000003>>%IE%
echo "2300"=dword:00000003>>%IE%
echo "2401"=dword:00000003>>%IE%
echo "2600"=dword:00000003>>%IE%
echo "2001"=dword:00000003>>%IE%
echo "2007"=dword:00000003>>%IE%
echo "2004"=dword:00000003>>%IE%
echo "2701"=dword:00000003>>%IE%
echo "2704"=dword:00000003>>%IE%
echo "CurrentLevel"=dword:00012000>>%IE%
regedit /s %IE%
echo Internet Zone geh„rtet
del "%IE%">nul
echo.& echo  Fertig.
echo.
echo        %taste%
pause>nul
goto :start3
:ie2
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3]>>%IE%
echo "{AEBA21FA-782A-4A90-978D-B72164C80120}"=hex(3):1A,37,61,59,23,52,35,0C,7A,\>>%IE%
echo 5F,20,17,2F,1E,1A,19,0E,2B,01,73,13,37,13,12,14,1A,15,39>>%IE%
echo "1A10"=dword:00000003>>%IE%
echo "{A8A88C49-5EB2-4990-A1A2-0876022C854F}"=hex(3):1A,37,61,59,23,52,35,0C,7A,\>>%IE%
echo 5F,20,17,2F,1E,1A,19,0E,2B,01,73,13,37,13,12,14,1A,15,39>>%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections]>>%IE%
echo "SavedLegacySettings"=hex(3):46,00,00,00,21,00,00,00,09,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,04,00,00,00,00,00,00,00,80,07,F6,7E,5C,62,CF,01,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,02,00,00,00,02,00,00,00,0A,00,02,0F,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,17,00,00,00,00,00,\>>%IE%
echo 00,00,20,01,00,00,9D,38,6A,BD,30,EC,33,96,F5,FF,FD,F0,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\>>%IE%
echo 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows]>>%IE%
echo "PopupMgr"=dword:00000001>>%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows]>>%IE%
echo "BlockUserInit"=dword:00000001>>%IE%
echo "UseHooks"=dword:00000000>>%IE%
echo "BlockControls"=dword:00000001>>%IE%
regedit /s %IE%
echo Datenschutz geh„rtet
del "%IE%">nul
echo.& echo  Fertig.
echo.
echo        %taste%
pause>nul
goto :start3
:ie3
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Geolocation]>>%IE%
echo "BlockAllWebsites"=dword:00000001>>%IE%
regedit /s %IE%
echo Physische Position geh„rtet
del "%IE%">nul
echo.& echo  Fertig.
echo.
echo        %taste%
pause>nul
goto :start3
:ie4
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows]>>%IE%
echo "BlockUserInit"=dword:00000001>>%IE%
echo "UseHooks"=dword:00000000>>%IE%
echo "BlockControls"=dword:00000001>>%IE%
regedit /s %IE%
echo PopUp Blocker geh„rtet
del "%IE%">nul
echo.& echo  Fertig.
echo.
echo        %taste%
pause>nul
goto :start3
:ie5
echo Windows Registry Editor Version 5.00 >%IE%
echo.>>%IE%
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main]>>%IE%
echo "DOMStorage"=dword:00000000>>%IE%
regedit /s %IE%
echo DOM Storage geh„rtet
del "%IE%">nul
echo.& echo  Fertig.
echo.
echo        %taste%
pause>nul
goto :start3


:tuning3
ver | find /i "5." >nul
if not errorlevel 1 set pfad=%userprofile%\Lokale Einstellungen\Anwendungsdaten&set befehl=tskill /A&set exe=explorer
ver | find /i "6." >nul
if not errorlevel 1 set pfad=%userprofile%\AppData\Local&set befehl=taskkill /f /IM&set exe=explorer.exe
echo.
echo  Es wird nun der Windows Explorer beendet um Fehler zu vermeiden.
echo  Jedoch wird er automatisch wieder gestartet, sobald das Programm
echo  fertig ist.
echo.
echo        %taste%
pause>nul
%befehl% %exe%>nul
cd /d %pfad%
if exist IconCache.db del IconCache.db /q /a
if "%exe%"=="explorer.exe" start explorer.exe
echo.
echo  Fertig.
echo        %taste%
pause>nul
goto :start3

:start4
cls
title %title% - Kram
echo.
echo  Kram
echo  ----
echo.
echo    (L)aufende Dienste anzeigen, (P)rozesse anzeigen
echo.
echo    (A)utostart anzeigen, (S)oftware anzeigen, (R)egistry sichern, (H)auptmen
echo.&echo.
choice /C LPASRH /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 6 goto :start
goto :kram%errorlevel%

:kram1
echo.
for /f "tokens=2,*" %%i in ('sc query^|find "DISPLAY_NAME:"') do echo %%i %%j>>%temp%\services.txt
sort %temp%\services.txt>%temp%\dienste.txt
del "%temp%\services.txt"
type %temp%\dienste.txt
echo.
set A=
echo  Ausgabe in Datei speichern?
choice /C NJ /N /M "(j)a, (n)ein: "
if errorlevel 2 set A=j
if defined A move "%temp%\dienste.txt" dienste.txt>nul &echo.&echo  Datei "dienste.txt" wurde angelegt.&goto :endshowservices
del "%temp%\dienste.txt"
goto :start4
:endshowservices
echo.
echo        %taste%
pause>nul
goto :start4

:kram2
echo.
ver | find /i "6." >nul
if not errorlevel 1 tasklist& goto :prozessent6
qprocess *
:prozessent6
echo.
echo  Ausgabe in Datei speichern?
choice /N /M "(j)a, (n)ein: "
if errorlevel 2 goto :start4
:prozessej
if exist "prozesse.txt" del "prozesse.txt"
ver | find /i "6." >nul
if not errorlevel 1 tasklist >prozesse.txt& goto :prozessejnt6
qprocess * >prozesse.txt
:prozessejnt6
echo.
if exist "prozesse.txt" echo  Datei "prozesse.txt" wurde angelegt.
echo.
echo        %taste%
pause>nul
goto :start4

:kram3
echo.
for /f "tokens=1 skip=1" %%i in ('wmic startup') do echo %%i|find /v "ECHO"
echo.
echo        %taste%
pause>nul
goto :start4

:kram4
if exist software_.txt del "software_.txt"
for /f "tokens=2,* delims=	 " %%a in ('reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| find /i "DisplayName"') do (echo.%%b)>>%temp%\software_.txt
for /f "tokens=2,* delims=	 " %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| find /i "DisplayName"') do (echo.%%b)>>%temp%\software_.txt
sort %temp%\software_.txt>>%temp%\software.txt
del "%temp%\software_.txt"
echo.
type %temp%\software.txt
echo.
echo  Ausgabe in Datei speichern?
choice /N /M "(j)a, (n)ein: "
if errorlevel 2 del /q "%temp%\software.txt" & goto :start4

:softwarej
set iprogs=installierte_Programme.txt
if exist %iprogs% del "%iprogs%"
move "%temp%\software.txt" software.txt>nul
ren software.txt %iprogs%
echo.
echo  Datei "%iprogs%" wurde angelegt.
echo.
echo        %taste%
pause>nul
goto :start4

:kram5
verify on
cls
set backup=Backup wird angelegt...
echo.
echo  Auswahl:
echo          (1): Gesamte Registry speichern
echo          (2): HKEY_CLASSES_ROOT speichern
echo          (3): HKEY_CURRENT_USER speichern
echo          (4): HKLM speichern
echo          (5): HKEY_USERS speichern
echo          (6): HKEY_CURRENT_CONFIG speichern
echo          (7): Zurck
echo.
choice /C 1234567 /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 7 goto :start4
goto :registry%errorlevel%
:registry1
echo %backup%
reg export HKEY_CLASSES_ROOT HKEY_CLASSES_ROOT.reg>nul
reg export HKEY_CURRENT_USER HKEY_CURRENT_USER.reg>nul
reg export HKLM HKLM.reg>nul
reg export HKEY_USERS HKEY_USERS.reg>nul
reg export HKEY_CURRENT_CONFIG HKEY_CURRENT_CONFIG.reg>nul
goto :regend
:registry2
echo %backup%
reg export HKEY_CLASSES_ROOT HKEY_CLASSES_ROOT.reg>nul
goto :regend
:registry3
echo %backup%
reg export HKEY_CURRENT_USER HKEY_CURRENT_USER.reg>nul
goto :regend
:registry4
echo %backup%
reg export HKLM HKLM.reg>nul
goto :regend
:registry5
echo %backup%
reg export HKEY_USERS HKEY_USERS.reg>nul
goto :regend
:registry6
echo %backup%
reg export HKEY_CURRENT_CONFIG HKEY_CURRENT_CONFIG.reg>nul
:regend
echo.
echo  Backup beendet. Beliebige Taste zum beenden drcken
pause>nul
goto :start4


:start5
if exist "%temp%\admintools.txt" del "%temp%\admintools.txt"
set admin=1
cls
title %title% - Admintools
echo.
echo  Admintools
echo  ----------
echo.
if not defined sessionname goto :admin1
set ad=Nein
echo.
echo  Es werden Adminstratorrechte ben”gtigt.
echo.
echo  Script als Administrator starten?
echo.
choice /C JN /N /M " (j)a, (n)ein: "
if errorlevel 2 goto :start
if errorlevel 1 goto :UACPrompt
if defined sessionname ( goto :UACPrompt ) else ( goto :gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "admin", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
tasklist|find /i "notepad">nul
if errorlevel 1 exit /B
echo.>%temp%\admintools.txt
echo.&echo  Das ausfhren von VBS Code ist deaktivert.
echo  HellsToolbox.cmd bitte manuell als Administrator starten.
echo  Es wird automatisch zu den Admintools navigiert
echo.
echo        %taste%
pause>nul
color& cls& exit /b

:gotAdmin
if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
set ad=Ja
:admin1
echo   	(F)estplatte auf Fehler untersuchen, (A)utostart aufr„umen
echo  		(W)indows reparieren, (D)ism, (B)ackup anlegen
echo   			(S)ysten Hardening, (H)auptmen
echo.&echo. 
choice /C FAWDBSH /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 7 goto :start
goto :admintools%errorlevel%

:admintools1
echo.
echo  M”glichkeiten:
echo  (N)ur šberprfung
echo  (M)it Reparatur
echo  (Z)urck
echo.
choice /C NMZ /N /M " Deine Eingabe: "
if errorlevel 3 goto :start5
goto :chkdsk%errorlevel%

:chkdsk1
cls
chkdsk /v
echo.
if errorlevel 2 goto :chkerror
if errorlevel 3 goto :chkerror
echo.
echo        %taste%
pause>nul
goto :start5

:chkdsk2
echo  Es wurden Fehler gefunden
echo  Es wird nun die Reparatur gestartet.
echo.
echo        %taste%
pause>nul
goto :chkrep

:chkrep
cls
chkdsk /f /r
if errorlevel 1 goto :chkt
goto :chkrepe
:chkt
echo.&echo Soll die Festplatte trotzdem auf Fehler untersucht werden?
set /p chkt= {J}a, {N}ein: 
if /i "%chkt%"=="J" call :chktest
if /i "%chkt%"=="N" goto :start5
:chkrepe
echo.
echo        %taste%
pause>nul
goto :start5

:admintools2
cls
title %title% - Autostartreinigung
echo.
echo  Msconfig muss geschlossen werden, bevor es weiter geht.
%systemroot%\System32\msconfig.exe -4
goto :start5

:admintools3
set A=
cls
title %title% - Windows Reparatur
echo.
echo        Beende alle offenen Prozesse und drcke dann eine beliebige Taste.
echo                    Die Windows CD wird eventuell verlangt!
echo.
echo  	Dies kann einige Zeit dauern. Abbrechen via Strg+C jederzeit m”glich
echo.
echo.
choice /C WA /N /M " W drcken fr weiter, A fr abbrechen: "
if errorlevel 2 goto :start5
echo.
sfc /scannow
echo.
echo        %taste%
pause>nul
goto :start5

:admintools4
cls
title %title% - Deployment Imaging and Servicing Management
echo.
for /f "tokens=4" %%i in ('ver') do set vertest=%%i
if %vertest:~0,1%%vertest:~2,1% LSS 61 if not %vertest:~0,1% equ 1 (
echo Dism erfordert Kernel 6.1 [Windows 7 und h”her]
echo.
echo        %taste%
pause>nul
goto :start5
)
echo  Auswahl:
echo  ab Win 8   (A):  Image auf Besch„digungen prfen
echo  ab Win 8   (B):  šberprfen ob am Image eine Besch„digung erkannt wurde
echo  ab Win 8   (C):  Image reparieren
echo             (D):  Offlineimage mit einer eigenen Quelle reparieren
echo             (E):  Onlineimage mit eigener Quelle reparieren
echo  ab Win 8.1 (F):  Gr”áe des WinSxS-Ordners ermitteln
echo  ab Win 8.1 (G):  Prfen ob der WinSxS Ordner bereinigt werden sollte
echo  ab Win 8   (H):  Bereinigen und Komprimieren von Komponenten 1
echo  ab Win 8.1 (I):  Bereinigen und Komprimieren von Komponenten 2
echo             (J): Bereinigen und Komprimieren von Komponenten 3
echo             (K): Zurck
echo.
choice /C ABCDEFGHIJK /N /M " Deine Eingabe: "
if errorlevel 11 goto :admintools4
goto :dism%errorlevel%

:dism1
echo dism1&pause
Dism /Online /Cleanup-Image /ScanHealth
goto :dismend

:dism2
Dism /Online /Cleanup-Image /CheckHealth
goto :dismend

:dism3
echo.&echo  Der Vorgang kann einige Minuten dauern
Dism /Online /Cleanup-Image /RestoreHealth
goto :dismend

:dism4
set dismoffline=
set dismsource=
set /p dismoffline= Pfad zum Offlineimage angeben: 
set /p dismsource= Pfad zur Quelle angeben: 
Dism /Image:"%dismoffline%" /Cleanup-Image /RestoreHealth /Source:"%dismsource%"
goto :dismend

:dism5
set dismsource=
set /p dismsource= Pfad zur Quelle angeben: 
Dism /Online /Cleanup-Image /RestoreHealth /Source:"%dismsource%" /LimitAccess
goto :dismend

:dism6
echo.&echo  Der Vorgang kann einige Minuten dauern
Dism /Online /Cleanup-Image /AnalyzeComponentStore
goto :dismend

:dism7
echo.&echo  Der Vorgang kann einige Minuten dauern
Dism /Online /Cleanup-Image /AnalyzeComponentStore
goto :dismend

:dism8
echo.&echo  Der Vorgang kann einige Minuten dauern
Dism /online /Cleanup-Image /StartComponentCleanup
goto :dismend

:dism9
echo.&echo  Der Vorgang kann einige Minuten dauern
Dism /online /Cleanup-Image /StartComponentCleanup /ResetBase
goto :dismend

:dism10
echo dism10&pause
Dism /online /Cleanup-Image /SPSuperseded

:dismend
echo.
echo        %taste%
pause>nul
goto :admintools4

:admintools5
verify on
cls
title %title% - Windows Backup
echo.
set /p target= Gib den Speicherort an:
echo.
echo  Windows Backup wird in "%target%" angelegt.
echo  Dies kann einige Zeit dauern. Abbrechen via Strg+C m”glich
echo.
wbadmin start backup -allcritical -backuptarget:"%target%" -vsscopy -quiet
echo.
echo        %taste%
pause>nul
goto :start5


:admintools6
mode con lines=30 cols=82
cls
echo.
echo  Auswahl:
echo  (A): Windows Dienste h„rten
echo  (B): Netzwerk h„rten (derzeit nur abschalten von Netbios)
echo  (C): AutoRun/ AutoPlay abschalten
echo  (D): UAC (Benutzerkontensteuerung) auf Maximum stellen
echo  (E): DCOM (OLE) abschalten
echo  (F): ICMPRedirect abschalten
echo  (G): Erweiterungen bei bekannten Dateitypen anzeigen
echo  (H): Windows Script Host (WSH) deaktivieren
echo  (I): Windows Script Host (WSH) Trust Policy aktivieren
echo.
echo  (J) direkte Ausfhrung von .bat blocken
echo  (K) direkte Ausfhrung von .cmd blocken
echo  (L) direkte Ausfhrung von .hta blocken
echo  (M) direkte Ausfhrung von .js blocken
echo  (N) direkte Ausfhrung von .jse blocken
echo  (O) direkte Ausfhrung von .vbe blocken
echo  (P) direkte Ausfhrung von .vbs blocken
echo  (Q) direkte Ausfhrung von .wsf blocken
echo  (R) direkte Ausfhrung von .wsh blocken
echo.
echo  (S) cscript.exe blocken
echo  (T) iexplore.exe blocken
echo  (U) powershell.exe blocken
echo  (V) wscript.exe blocken
echo.
echo  (Z): Zurck
echo.
choice /C ABCDEFGHIJKLMNOPQRSTUVZ /N /M "Deine Eingabe: "
if errorlevel 24 goto :start5
goto :systemhardening%errorlevel%

:systemhardening1
if exist Windows-Dienste-Backup_*.reg (
echo.&echo  Es wurde ein Backup gefunden. Dieses jetzt wiederherstellen?
choice 
if errorlevel 2 goto :systemhardening1b
reg import Windows-Dienste-Backup_*.reg >nul
if not errorlevel 1 echo Backup wurde erfolgreich eingespielt
echo.
echo        %taste%
pause>nul
goto :admintools6
)
echo.
echo Sichere aktuelle Konfiguration...
reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services Windows-Dienste-Backup_%date%.reg >nul
if not errorlevel 1 echo Konfiguration erfolgreich unter "%~dp0" gesichert
:systemhardening1b
echo.
set dienst=AxInstSV
set dienstname=ActiveX-Installer
call :configserviceloop
set dienst=LanmanWorkstation
set dienstname=Arbeitsstationsdienst
call :configserviceloop
set dienst=lmhosts
set dienstname=TCP/IP-NetBIOS-Hilfsdienst
call :configserviceloop
set dienst=SessionEnv
set dienstname=Konfiguration für Remotedesktops
call :configserviceloop
set dienst=MSiSCSI
set dienstname=Microsoft iSCSI-Initiator-Dienst
call :configserviceloop
set dienst=TermService
set dienstname=Remotedesktopdienste
call :configserviceloop
set dienst=RemoteRegistry
set dienstname=Remoteregistrierung
call :configserviceloop
set dienst=RemoteAccess
set dienstname=Routing und RAS
call :configserviceloop
set dienst=SNMPTRAP
set dienstname=SNMP-Trap
call :configserviceloop
set dienst=RasAuto
set dienstname=Verwaltung für automatische RAS-Verbindung
call :configserviceloop
set dienst=WinRM
set dienstname=Windows-Remoteverwaltung (WS-Verwaltung)
call :configserviceloop
echo.
echo        %taste%
pause>nul
goto :admintools6
:configserviceloop
sc query %dienst%^|find "STOPPED">nul
if errorlevel 1 sc stop %dienst% 4:5:16 Dienste_Hardening_durch_HellsToolbox >nul
sc config %dienst% start= disabled >nul
echo %dienstname% deaktiviert
goto :eof

:systemhardening2
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LmHosts /v Start /f /d 0x4 >nul
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT /v Start /f /d 0x4 >nul
wmic NICConfig where TcpipNetbiosOptions=0 Get Description,index |find "2" >%temp%\wmic.txt
for /f "tokens=1,2,3" %%i in ('type %temp%\wmic.txt') do set tcpdevice=%%i %%j & set tcpindex=%%k &call :confignetbios
del "%temp%\wmic.txt">nul
echo.
echo        %taste%
pause>nul
goto :admintools6
:confignetbios
echo.
echo  Bearbeite "%tcpdevice%"
wmic nicconfig where index=%tcpindex% call SetTcpipNetbios 2 >nul
goto :eof

:systemhardening3
red add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDriveTypeAutorun /t REG_DWORD /d 0xFF /f >nul
echo.&echo AutoRun/ AutoPlay wurde deaktiviert.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening4
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA|find "0x1">nul
if errorlevel 1 reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /f /d 0x1 >nul
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop| find "0x1">nul
if errorlevel 1 reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /f /d 0x1 >nul
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin|find "0x2">nul
if errorlevel 1 set set uac=uachoch &goto :uachoch
echo.&echo UAC ist bereits auf Maximum. UAC auf Standard setzen?
set /p uaca= {j}a, jede andere Taste fr nein: 
if not "%uaca%"=="j" goto :admintools6
set uac=uacstandard
:uacstandard
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0x5 /f >nul
echo.&echo UAC wurde auf Standard gesetzt.&goto :uacend
:uachoch
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0x2 /f >nul
echo.&echo UAC wurde auf Maximum gesetzt.
:uacend
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening5
set dcom=N
echo.
reg query HKLM\Software\Microsoft\OLE /v EnableDCOM|find "Y">nul
if not errorlevel 1 goto :dcom2
echo DCOM ist bereits deaktiviert. Wieder aktivieren?
set /p dcoma= {j}a, jede andere Taste fr nein: 
if "%dcoma%"=="j" set dcom=Y
echo.
:dcom2
reg add HKLM\Software\Microsoft\OLE /v EnableDCOM /f /d %dcom% >nul
if defined dcoma (
echo DCOM wurde aktiviert
) else (
echo DCOM wurde deaktiviert
)
echo Die Žnderung wirkt erst nach einem Neustart!
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening6
for /f "tokens=3" %%i in ('reg query HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect') do echo %%i|find "1">nul
if not errorlevel 1 goto :hardenicmp
echo ICMP Redirect ist deaktiviert - System ist geschtzt
echo.&echo Rckg„ngig machen?
set /p undo= {j}a, jede andere Taste fr nein: 
if /i "%undo%"=="j" goto :undoicmp
goto :admintools6
:undoicmp
echo.
reg add HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect /t REG_DWORD /d 1 /f >nul
goto :icmpende
:hardenicmp
echo ICMP ist aktiv - System ist nicht geschtzt.
echo.& echo System h„rten?
set /p icmp= {j}a, jede andere Taste fr nein: 
if /i "%icmp%"=="j" goto :hardenicmp2
goto :admintools6
:hardenicmp2
echo.
reg add HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect /t REG_DWORD /d 0 /f >nul
:icmpende
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening7
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f >nul
echo.&echo  Einstellung wurde aktiviert.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening8
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Scrit Host\Settings" /v Enabled /t REG_DWORD /d 0 /f >nul
echo.&echo  WSH wurde deaktiviert.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening9
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host\Settings" /v TrustPolicy REG_DWORD /d 1 /f >nul
echo.&echo  WSH wurde geh„rtet.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening10
reg add "HKEY_CLASSES_ROOT\batfile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .bat kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening11
reg add "HKEY_CLASSES_ROOT\cmdfile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .cmd kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening12
reg add "HKEY_CLASSES_ROOT\htafile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .hta kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening13
reg add "HKEY_CLASSES_ROOT\jsfile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .js kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening14
reg add "HKEY_CLASSES_ROOT\jsefile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .jse kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening15
reg add "HKEY_CLASSES_ROOT\vbefile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .vbe kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening16
reg add "HKEY_CLASSES_ROOT\vbsfile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .vbs kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening17
reg add "HKEY_CLASSES_ROOT\wsffile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .wsf kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening18
reg add "HKEY_CLASSES_ROOT\wshfile\shell" /t REG_SZ /d edit /f >nul
echo.&echo  .wsh kann nun nurnoch manuell via Rechtsklick ausgefhrt werden.
echo.
echo        %taste%
pause>nul
goto :admintools6

:systemhardening19
::cscript::
echo.
echo        %taste%
pause>nul
goto :admintools6

:start6
cls
title %title% - Programminfos
echo.
echo  Programminfos
echo  -------------
echo.
for /f "tokens=1 delims=[]" %%i in ('find /V /N "XYZ@" HellsToolbox.cmd') do set Zeilennr=%%i
echo  Diese Batch besteht zur Zeit aus %zeilennr% Zeilen Code
echo  und wurde am %builddate% erstellt.
echo  Geschrieben habe ich alles mit dem OpenSource Editor "Notepad++".
echo.&echo.
echo  (Q)uellcode anzeigen, (C)hangelog, (N)otepad++ laden, (H)auptmen
echo.
choice /C QCNH /N /M "Bitte einen Buchstaben in der Klammer ausw„hlen: "
if errorlevel 4 goto :start
goto :programminfos%errorlevel%

:sourcecode
:programminfos1
type HellsToolbox.cmd >HellsToolbox-Sourcecode.txt
HellsToolbox-Sourcecode.txt
goto :start6

:changelog
:programminfos2
cls
title %title% - Changelog
echo.
echo  Changelog
echo  ---------
echo.
echo  1.0:
echo %#% Programm soweit fertig gestellt
echo %#% Hauptmen aufger„umt
echo %#% 'Tuning' fertig gestellt
echo %#% 3 'gotos' bei Dienstekonfig gefixt
echo %#% 2 ">nuls" bei systeminfo gefixt
echo %#% Service Pack 'gotos' umbenannt
echo %#% Code bersichtlicher gemacht
echo.
echo  1.1:
echo %#% Bug bei Bit Ermittlung unter Adminstratorrechten
echo  	  ab Vista behoben
echo %#% Fehlermeldung fr nicht vorhandene externe Tools gebastelt 
echo %#% Windows 98 Service Pack Erkennung nachgerstet
echo %#% Code Optimierung
echo %#% Wirre DNS Server Ausgabe bei getrennten Internet behoben
echo %#% Registry Backup Funktion eingebaut
echo %#% 'REM' durch '::' ersetzt
echo %#% Sinnfreie Errorlevel 0 Abfragen umgebaut
echo %#% Taschenrechner kann Rechnungen und Ergebnisse mitloggen
echo %#% Windows 95 und ME Erkennung eingebaut
echo %#% Alte Prozessorkerne Ermittlung gegen schnellere getauscht
echo %#% Doppeltes "set net" entfernt
echo %#% Prozesse Anzeigen unter NT 6.0+ erm”glicht
echo %#% 'del' bei netstat Ausgabe vergessen
echo %#% Taschenrechner Log verbessert
echo %#% Falsche Tastenauswahl in den Mens korregiert
echo %#% Paar unn”tige Sachen entfernt
echo %#% Windows Defrag erweitert
echo.
echo  1.2:
echo %#% Externe IP Ermittlung eingebaut
echo %#% Paar Zeilen Code durch Optimierung gespart
echo %#% Wochentag kann nun angezeigt werden
echo %#% Code nochmal um paar Zeilen erleichtert
echo %#% Webseitentools nach Internettools umbenannt
echo %#% 'Zurck' unter Registry sichern vergessen
echo %#% Pfad Fehler unter Adminrechten behoben
echo %#% Traffic Verbrauch kann nun unter Internettools angezeigt werden
echo %#% Es werden nun fehlerhafte Bytes der Internetverbindung angezeigt
echo %#% Externe Programme durch eigenen Code ersetzt
echo %#% Netstat zeigt nun offene TCPv4+6 und UDPv4+6 Ports an
echo %#% Erroranzeige bei nichtvorhandenen WMIC + systeminfo gebaut
echo %#% ,Reinigung' fr NT6+ erm”glicht und Fehler beseitigt
echo %#% Falsche MAC Adresse Anzeige bei inaktivem Internet
echo %#% Falscher ,goto' Sprung bei ,SFC' Teil
echo %#% Nun kann man sich unter ,Kram' laufende Dienste anzeigen lassen
echo %#% Langsame ,systeminfo' Anzeige durch ,WMIC' ersetzt
echo %#% Externe IP wird nichtmehr angezeigt falls keine interne besteht
echo %#% IP, DNSServer und MAC Ermittlung beschleunigt und Netbios
echo 	  Bestimmung korregiert
echo %#% Benutzereingaben werden besser verwaltet
echo %#% Paar Zeilen Code nochmal durch Optmierung gespart
echo %#% Benutzerkonten anzeigen unter ,Kram' verfgbar
echo %#% ,Kram' Seite umgebaut
echo.
echo  1.3:
echo %#% IconCache Reparatur eingebaut
echo %#% Internettest auf 2 anpingbare Seiten gestreckt
echo %#% Hauptmen leicht ge„ndert
echo %#% Doppelte Prozesse anzeigen und Temp l”schen entfernt
echo %#% Falsche Umlaute unter ,Defrag' und ein "|" beseitigt
echo %#% ,H”ren' wird nun korrekt bei der Netstat Ausgabe angezeigt
echo %#% Eine Tilde bei Umbenennung der Software.txt war zuviel
echo %#% Negative Werte bei Netstat Ausgabe korregiert
echo %#% Server 2003 + 2008 Erkennung eingebaut
echo %#% OS Anzeige stark optimiert
echo %#% Externe IP wird nichtmehr im Systeminfo Log stehen wenn keine
echo 	  interne vorhanden ist
echo %#% Bei Reinigung Anzeigen wird nun komplett zum Hauptmen gegangen
echo.
echo  1.4:
echo %#% Windows 8 Erkennung eingebaut
echo %#% Internettest hat nun einen Router DNS Check
echo %#% Dienstekonfig entfernt
echo %#% Leichte Anpassungen an diversen Logdateien vorgenommen
echo %#% Infos zum Netzwerk sind nun unter Internettools
echo %#% Windows 7 SP1 Erkennung eingebaut
echo %#% ,Reinigung' nach ,Tuning' verschoben
echo %#% ,Logo' mehr mittig geschoben
echo %#% Leichte Anpassungen an den Mens
echo %#% Unter Systeminfos wird nun der Monitor aufgelistet
echo %#% Es kann nun zwischen einschr„nkten Rechten,
echo 	  Adminrechten mit UAC und ohne UAC unterschieden werden
echo %#% Windows Defrag entfernt
echo.
echo  1.5:
echo %#% Registrysicherung gibt weniger unn”tige Infos aus
echo %#% Korrektur des IPv6 Tests unter Windows XP
echo %#% UAC-Level Erkennung eingebaut
echo %#% ,Netstat' beschleunigt
echo %#% Leichte Verbesserungen bei einigen txt Dateien
echo %#% Windowserkennung beschleunigt
echo %#% Windows Server 2012 Erkennung eingebaut
echo %#% Autostartreinigung via Msconfig eingebaut
echo %#% Registry sichern + IconCache reparieren nach ,Tuning' verschoben
echo %#% Windows Backup eingebaut
echo %#% Reinigung komplett optimiert und erneuert
echo.
echo  1.6:
echo %#% Windows 8.1 Erkennung eingebaut
echo %#% Windows Erkennung beschleunigt
echo %#% Falschen Zurck Pfad bei ,Registry sichern', behoben
echo %#% WMIC Abfragen beschleunigt
echo %#% Windowsinstallationsdatum und SSD/ HDD Erkennung eingebaut
echo %#% Erweiterten Systeminfos werden auch in die Log geschrieben
echo %#% Speicherort aller Logdateien wird nun angezeigt
echo %#% Zurck bei Chkdsk geht nun zu Admintools, statt zum Hauptmen 
echo %#% Bei Windows Reparatur kann man nun abbrechen
echo %#% Die User SID wird nun angezeigt
echo %#% Neben dem Windowsinstallationdatum wird nun die Onlinezeit angezeigt
echo %#% Bei Reinigung kann man nun zurckgehen
echo %#% DHCP Dienststatus wird nun auch im Log angezeigt
echo %#% Kleinen Fehler bei Reinigung behoben
echo %#% CHKDSK bietet nun mehr Optionen an
echo.
echo  1.7:
echo %#% Bessere Router IP Erkennung eingebaut
echo %#% IPv6 Erkennung ist nun vorhanden
echo %#% DNS Problemerkennung erweitert
echo %#% DNS Problembeseitigung eingebaut
echo %#% Falsches goto bei Iconcache korregiert
echo %#% Es kann nun automatisch das Script als Admin gestartet werden
echo %#% ,whoami' wird nun nichtmehr aufgerufen wenn nicht vorhanden 
echo 	  und wurde unter OS Erkennung verschoben
echo %#% Bessere L”sung fr OS ohne ,WMIC'
echo %#% Korrektur bei Nichtvorhanden von IPv6
echo %#% Kleine Fehlerbeseitigung bei der Vista Editions Erkennung
echo %#% ,DISM' eingebaut
echo %#% Kleinen Fix unter XP bei der Adminerkennung eingebaut
echo %#% Die Info bei ,Reinigung' wird wieder angezeigt
echo %#% Der Papierkorb wird bei ,Reinigung' bercksichtigt
echo %#% Die User SID wird nun auch unter Win XP angezeigt
echo %#% Windows Server 2012 R2 Erkennung eingebaut
echo.
echo  1.8:
echo %#% Erkennung von Verbundene Netzwerkart korregiert
echo %#% Registry-Codeoptimierung
echo %#% ,Letzte besuchte Seiten anzeigen' umbenannt
echo.
echo %#% BIOS Versionserkennung mehr toleranter gemacht
echo %#% BIOS Datum hinzugefgt
echo %#% Windows10 Support
echo %#% Registry sichern nach ,Kram' verschoben
echo %#% Windows MRU-Cache L”schung eingebaut
echo %#% Energiesparmodus-Erkennung eingebaut
echo %#% System + Browserhardening hinzugefgt
echo %#% Windows10 Erkennung optimiert
echo %#% Fallback fr MAC-Ermittlung eingebaut
echo %#% eine grobe Autostart Anzeige eingebaut
echo.
echo  2.0:
echo %#% Versionssprung von 1.8 zu 2.0 aufgrund von massiven Žnderungen
echo %#% Besseres Admin-Management
echo %#% unn”tige Info-Abfragen entfernt (einiges)
echo %#% Fehlerbehebung bei der DHCP und IPv6 Erkennung
echo %#% Auflistung der verbauten Festplatten samt Firmware+Status
echo %#% Erkennung von CScript Blockierung eingebaut
echo %#% Notepad++ Link aktualisiert
echo %#% Admin-Check beschleunigt und :Admintools optimiert
echo %#% etliche Systen-Hardening Optionen eingebaut
echo.
echo.
echo        %taste%
pause>nul
goto :start6

:notepad++
:programminfos3
start https://notepad-plus-plus.org/
goto :start6