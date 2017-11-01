@echo off
:: [Xperf Log Analyzer] Version 0.3 Build 13.08.2012
:: Kontakt:  beerisgood.github@protonmail.com
:: Lizens: GNU General Public License v3

:: Microsoft Windows Performance Toolkit Verzeichnis hier einfügen
:: Beispiel: X:\Microsoft Windows Performance Toolkit
set wpt=

:: Verzeichnis für eventuelle XPERF Logdateien, die nicht in den wpt Ordner liegen, hier einfügen
:: Nur nötig, wenn das explizit bei XPERF geändert wurde!
:: Beispiel: D:\xperf logs
set xperf=

:: Verzeichnis für Logdateien hier einfügen
:: Beispiel: C:\ oder %temp%
set log=

:: Einstellungsende
cd /d "%wpt%"
if "%wpt:~0,16%"=="C:\Program Files" set wpt=%windir%\system32
if defined xperf set wpt=%xperf%
:: Log vor Optimierung erstellen
echo Erstelle Log Dateien...
xperf /tti -i "%wpt%\bootPrep_BASE+CSWITCH_1.etl" -o "%log%\01_summary_boot_start.xml" -a boot
:: Log nach Optimierung erstellen
xperf /tti -i "%wpt%\boot_BASE+CSWITCH_1.etl" -o "%log%\02_summary_boot_ende.xml" -a boot

:: Auswertung bootDoneViaExplorer
cls
for /f "tokens=2" %%i in ('type "%log%\01_summary_boot_start.xml"^|findstr "bootDoneViaExplorer"') do set bootDoneViaExplorer=%%i
set bootDoneViaExplorerV=%bootDoneViaExplorer:~21,-1%
if %bootDoneViaExplorerV% gtr 99999 echo bootDoneViaExplorer vorher: %bootDoneViaExplorerV:~0,3%,%bootDoneViaExplorerV:~3% Sekunden&goto :1
echo bootDoneViaExplorer vorher: %bootDoneViaExplorerV:~0,2%,%bootDoneViaExplorerV:~2% Sekunden
:1
for /f "tokens=2" %%i in ('type "%log%\02_summary_boot_ende.xml"^|findstr "bootDoneViaExplorer"') do set bootDoneViaExplorer=%%i
set bootDoneViaExplorerD=%bootDoneViaExplorer:~21,-1%
if %bootDoneViaExplorerD% gtr 99999 echo bootDoneViaExplorer nachher: %bootDoneViaExplorerD:~0,3%,%bootDoneViaExplorerD:~3% Sekunden&goto :2
echo bootDoneViaExplorer nachher: %bootDoneViaExplorerD:~0,2%,%bootDoneViaExplorerD:~2% Sekunden
:2
echo.
set /a viaExplorer=%bootDoneViaExplorerV%-%bootDoneViaExplorerD%
set tempvar=%bootDoneViaExplorerV%
set tempvar2=%viaExplorer%
call :prozent
echo %viaExplorer:~0,2%,%viaExplorer:~2% Sekunden schneller (rund %prozent% Prozent) !&echo.&echo.

:: Auswertung bootDoneViaPostBoot
for /f "tokens=3" %%i in ('type "%log%\01_summary_boot_start.xml"^|findstr "bootDoneViaPostBoot"') do set bootDoneViaPostBoot=%%i
set bootDoneViaPostBootV=%bootDoneViaPostBoot:~21,-1%
if %bootDoneViaPostBootV% gtr 99999 echo bootDoneViaPostBoot vorher: %bootDoneViaPostBootV:~0,3%,%bootDoneViaPostBootV:~3% Sekunden&goto :3
echo bootDoneViaPostBoot vorher: %bootDoneViaPostBootV:~0,2%,%bootDoneViaPostBootV:~2% Sekunden
:3
for /f "tokens=3" %%i in ('type "%log%\02_summary_boot_ende.xml"^|findstr "bootDoneViaPostBoot"') do set bootDoneViaPostBoot=%%i
set bootDoneViaPostBootD=%bootDoneViaPostBoot:~21,-1%
if %bootDoneViaPostBootD% gtr 99999 echo bootDoneViaPostBoot nachher: %bootDoneViaPostBootD:~0,3%,%bootDoneViaPostBootD:~3% Sekunden&goto :4
echo bootDoneViaPostBoot nachher: %bootDoneViaPostBootD:~0,2%,%bootDoneViaPostBootD:~2% Sekunden
:4
echo.
set /a ViaPostBoot=%bootDoneViaPostBootV%-%bootDoneViaPostBootD%
set tempvar=%bootDoneViaPostBootV%
set tempvar2=%ViaPostBoot%
call :prozent
echo %ViaPostBoot:~0,2%,%ViaPostBoot:~2% Sekunden schneller (rund %prozent% Prozent) !&echo.&echo.
pause&exit

:prozent
set /a tempmain=%tempvar%/100
set /a prozent=%tempvar2%/%tempmain%