@echo off
net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Adminrechte
    ) else (
        echo Keine Adminrechte
    )
pause