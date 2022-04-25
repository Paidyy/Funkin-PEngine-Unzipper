@echo off
haxe --main Unzipper --cpp export/windows
echo.
cd export/windows
Unzipper.exe
PAUSE