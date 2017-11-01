@echo off & setlocal enabledelayedexpansion
reg query HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Printers>%temp%\p.txt /s /v Port
cd /d %temp%
for /f "tokens=*" %%i in ('type p.txt^|findstr /e "Printer"') do set p=%%i&call :l

del "%temp%\p.txt">nul
echo VerfÅgbare Drucker:&echo.
:l3
set /a ur+=1
if %ur% GTR %maxir% echo.&pause&exit
echo !p%ur%! - !ip%ur%!
goto :l3

:l
set /a dr+=1
set p%dr%=%p:~63%
call :ip
goto :eof

:ip
for /f "tokens=1 delims=[]" %%i in ('type p.txt^|find /c "IP_"') do set maxir=%%i
for /f "tokens=3" %%i in ('type p.txt^|find "IP_"') do set ip=%%i&call :l2
goto :eof
:l2
set /a ir+=1
if %ir% GTR %maxir% goto :eof
set ip%ir%=%ip%
goto :eof