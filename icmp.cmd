@echo off
for /f "tokens=3" %%i in ('reg query HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect') do echo %%i|find "1">nul
if not errorlevel 1 goto :hardenicmp
echo ICMP Redirect ist deaktiviert - System ist geschÅtzt
echo.&echo RÅckgÑngig machen?
set /p undo= {j}a, jede andere Taste fÅr nein: 
if /i "%undo%"=="j" goto :undo
exit

:undo
echo.
reg add HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect /t REG_DWORD /d 1 /f
goto :ende

:hardenicmp
echo ICMP ist aktiv - System ist nicht geschÅtzt.
echo.& echo System hÑrten?
set /p icmp= {j}a, jede andere Taste fÅr nein: 
if /i "%icmp%"=="j" goto :harden
exit
:harden
echo.
reg add HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters /v EnableICMPRedirect /t REG_DWORD /d 0 /f

:ende
echo.
pause&exit