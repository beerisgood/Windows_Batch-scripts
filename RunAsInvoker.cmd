@echo off
title RunAsInvoker
:1
set __COMPAT_LAYER=RunAsInvoker
echo Ziehe dein Programm hier rein:
echo.
set /p pfad= 
%pfad%
cls
goto :1