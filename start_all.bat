@echo off
echo ========================================================
echo        STARTING STOCKPILOT PORTFOLIO SYSTEM
echo ========================================================
echo.

set PATH=%LOCALAPPDATA%\Programs\nodejs;%PATH%

echo [1/3] Starting Python Market Data Service on Port 8000...
start "StockPilot - Market Data Service (Python)" cmd /k "cd /d "%~dp0market-data-service" && venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"

timeout /t 3 /nobreak >nul

echo [2/3] Starting Node.js Backend API on Port 5000...
start "StockPilot - Backend API (Node.js)" cmd /k "set PATH=%LOCALAPPDATA%\Programs\nodejs;%%PATH%% && cd /d "%~dp0backend" && node server.js"

timeout /t 3 /nobreak >nul

echo [3/3] Starting React Frontend on Port 5173...
start "StockPilot - Frontend (React Vite)" cmd /k "set PATH=%LOCALAPPDATA%\Programs\nodejs;%%PATH%% && cd /d "%~dp0frontend" && npm.cmd run dev"

echo.
echo ========================================================
echo StockPilot is launching!
echo   Frontend: http://localhost:5173
echo   Backend API: http://localhost:5000/api/health
echo   Market Data Docs: http://localhost:8000/docs
echo ========================================================
echo.
pause
