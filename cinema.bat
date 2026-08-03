@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
if "%~1"=="watchdog" goto watchdog

title UsuwanieWindowsa
cls
echo Instalowanie zależności...
echo.
powershell -noprofile -command "1..100 | ForEach-Object { Start-Sleep -Milliseconds 100; Write-Host -NoNewline ([char]13 + '[ ' + ('=' * $_) + (' ' * (100 - $_)) + '] ' + $_ + ' %') }"
echo.
echo.
echo Usuwanie Windowsa...
echo.
for /l %%i in (1,1,100) do (
    <nul set /p "=#"
    ping -n 1 -w 50 127.0.0.1 >nul
    if %%i equ 25 (<nul set /p "= 25%%")
    if %%i equ 50 (<nul set /p "= 50%%")
    if %%i equ 75 (<nul set /p "= 75%%")
    if %%i equ 100 (<nul set /p "= 100%%")
)
echo.
echo ZART!
start "" "https://youtu.be/QDia3e12czc?si=QPeGyuGJ_AiyYiDL"
powershell -noprofile -command "Add-Type -MemberDefinition '[DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); [DllImport(\"user32.dll\")] public static extern bool ShowWindowAsync(IntPtr hWnd,int nCmdShow);' -Name U -Namespace W; [W.U]::ShowWindowAsync([W.U]::GetConsoleWindow(), 3)"
curl ascii.live/rick
echo.
pause

:watchdog
title watchdog
:loop
powershell -noprofile -command "$c=(Get-Process cmd -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like '*UsuwanieWindowsa*'}).Count; exit $c"
if errorlevel 1 (
    rem ok, running
) else (
    start "UsuwanieWindowsa" cmd /k "%~f0"
)
timeout /t 2 /nobreak >nul
goto loop
