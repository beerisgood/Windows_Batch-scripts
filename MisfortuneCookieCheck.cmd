@echo off
cd /d "%~dp0"
set curl=curl.exe
:curl
if not exist %curl% echo Curl.exe fehlt&echo.&pause&goto :curl

:Router IP Ermittlung
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "Stand"') do set router=%%i
if "%router%"==" " (
for /f "tokens=2 Delims=:" %%i in ('ipconfig^|find "Stand"') do echo %%i>>%temp%\router.txt
set /p router= <%temp%\router.txt
del "%temp%\router.txt"
)

:Misfortune Cookie Check
for /f "tokens=*" %%i in ('%curl% -I %router%^|find /i "RomPager"') do set rompager=%%i
cls
if not defined rompager echo Kein RomPager installiert - Router ist sicher&echo.&pause&exit
set rompagerv=%rompager:~17,1%%rompager:~19,2%
if %rompagerv% LSS 434 (
echo Router ist anf„llig - Version %rompager:~17,4% ist installiert
) else ( 
echo Router ist geschtzt - Version %rompager:~17,4% ist installiert
)
echo.&pause