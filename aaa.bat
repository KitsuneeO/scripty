@echo off
title Wykryte kamery
powershell -NoProfile -Command "Get-PnpDevice -Class Camera | Select-Object FriendlyName, Status | Format-Table -AutoSize"
echo.
pause
