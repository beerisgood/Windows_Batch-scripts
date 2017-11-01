@echo off
net user "%USERNAME%" 2> nul | find /i "admin" > nul
if not errorlevel 1 (
echo Mitglied der Administratorgruppe
if defined sessionname echo Aber durch UAC geschuetzt&goto :e
)
if defined sessionname echo keine admin rechte
if not defined sessionname echo volle admin rechte
:e
pause