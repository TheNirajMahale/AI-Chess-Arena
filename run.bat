@echo off
title AI Chess Arena Backend Launcher
echo ========================================================
echo          AI CHESS ARENA BACKEND SERVER LAUNCHER
echo ========================================================
echo.

cd /d "%~dp0"

echo [1/2] Checking Python dependencies...
python -m pip install -r backend\requirements.txt >nul 2>&1

echo [2/2] Starting AI Chess Arena Backend on http://localhost:8000 ...
echo.
echo REST API and WebSocket available at:
echo   - REST Endpoints: http://127.0.0.1:8000/docs
echo   - WebSocket Stream: ws://127.0.0.1:8000/ws/game
echo.
echo Connect the Flutter mobile client from the mobile/ directory (flutter run).
echo.

python backend\run_server.py
pause
