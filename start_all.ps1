# StockPilot - Complete System Starter Script (PowerShell)
$root = $PSScriptRoot
$env:PATH = "$env:LOCALAPPDATA\Programs\nodejs;$env:PATH"

Write-Host "========================================================" -ForegroundColor Green
Write-Host "       STARTING STOCKPILOT PORTFOLIO SYSTEM" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

Write-Host "[1/3] Starting Python Market Data Service (Port 8000)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$root\market-data-service'; .\venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"

Start-Sleep -Seconds 2

Write-Host "[2/3] Starting Node.js Backend API (Port 5000)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PATH = '$env:LOCALAPPDATA\Programs\nodejs;' + `$env:PATH; cd '$root\backend'; node server.js"

Start-Sleep -Seconds 2

Write-Host "[3/3] Starting React Frontend (Port 5173)..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$env:PATH = '$env:LOCALAPPDATA\Programs\nodejs;' + `$env:PATH; cd '$root\frontend'; npm.cmd run dev"

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "StockPilot is launching!" -ForegroundColor Green
Write-Host "  Frontend: http://localhost:5173" -ForegroundColor Yellow
Write-Host "  Backend API: http://localhost:5000" -ForegroundColor Yellow
Write-Host "  Market Data Docs: http://localhost:8000/docs" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Green
