@echo off
title Everybody Edits Launcher
cd /d "%~dp0"

echo [1/2] Checking Private Server status...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8080/api/shop' -TimeoutSec 2; exit 0 } catch { exit 1 }"
if %ERRORLEVEL% NEQ 0 (
    echo Starting Node.js Server in background...
    start /min "Everybody Edits Server" powershell -WindowStyle Hidden -Command "node server/index.js"
    timeout /t 2 /nobreak >nul
) else (
    echo Server is already active!
)

echo [2/2] Launching Everybody Edits Client...
if exist "flashplayer_32_sa.exe" (
    start "" "flashplayer_32_sa.exe" "http://localhost:8080/game_local.swf"
) else if exist "%USERPROFILE%\Downloads\flashplayer_32_sa.exe" (
    start "" "%USERPROFILE%\Downloads\flashplayer_32_sa.exe" "http://localhost:8080/game_local.swf"
) else (
    echo Flash Player not found! Opening in default browser...
    start "http://localhost:8080"
)

exit
