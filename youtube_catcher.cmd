@echo off
:: [YoutubeCatcher] Version 0.1 Build 06.11.2011
:: Kontakt: beerisgood.github@protonmail.com
::
:: Dieses Programm ist freie Software. Sie k�nnen es unter den Bedingungen der
:: GNU General Public License, wie von der Free Software Foundation ver�ffentlicht,
:: weitergeben und/oder modifizieren, entweder gem�� Version 3 der Lizenz oder
:: (nach Ihrer Option) jeder sp�teren Version.
::
:: Die Ver�ffentlichung dieses Programms erfolgt in der Hoffnung, da� es Ihnen
:: von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite
:: Garantie der MARKTREIFE oder der VERWENDBARKEIT F�R EINEN BESTIMMTEN ZWECK.
:: Details finden Sie in der GNU General Public License.
::
:: Ein Exemplar der GNU General Public License ist auf http://www.gnu.org/licenses zu finden.
set t=YoutubeCatcher
title %t%
:start
set /p y=Youtube Link: 
set http=http
echo %y%|find "https">nul
if not errorlevel 1 set http=https
set l=%y:~-11%
start %http%://www.youtube.com/embed/%l%
set /a catch+=1
title %t%  Letzter Link: %http%://www.youtube.com/v/%l%
cls&echo %catch% Sperre(n) umgangen&echo.
goto :start