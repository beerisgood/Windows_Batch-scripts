@echo off
systeminfo|find /i "KB">%temp%\sys.txt
title KB Sucher
:s
set t=
set a=
echo.&set /p kb= KB: 
if "%kb%"=="" goto exit
if /i not %kb:~0,2%==KB set a=KB
type %temp%\sys.txt|find /i "%kb%"
if not errorlevel 1 echo  Installiert&echo.&goto :s
for /f "tokens=*" %%i in ('reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| find /i "(%a%%kb%)"') do set t=%%i
if defined t echo Installiert & goto :s
for /f "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| find /i "(%a%%kb%)"') do set t=%%i
if defined t echo Installiert & goto :s
wmic qfe where "HotFixID='%a%%kb%'" get InstalledOn|find "Installed" >nul
if not errorlevel 1 echo Installiert & goto :s
echo  nicht Installiert&goto :s