@echo off
cd /d "%~dp0"

set logdatei=netzwerk.txt
set host1=heise.de
set host2=netzpolitik.org

:loop
ping -n 1 %host1%>nul
if errorlevel 1 goto :error
ping -n 60 localhost>nul
goto :loop

:error
ping -n 1 %host2%>nul
if errorlevel 1 goto :error2
ping -n 60 localhost>nul
goto :loop

:error2
echo Verbindungsunterbruch um %time:~0,-6%Uhr am %date%
echo Verbindungsunterbruch um %time:~0,-6%Uhr am %date%>>"%logdatei%"
goto :loop