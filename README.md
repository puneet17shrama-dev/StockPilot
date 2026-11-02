# StockPilot

StockPilot is a local portfolio monitoring and educational analysis application. It stores user-managed holdings and purchase lots, reads market data through Yahoo Finance's `yfinance` package, and provides portfolio, account, watchlist, analysis, and report screens.

> **Disclaimer:** StockPilot is a portfolio monitoring and educational analysis tool. It does not connect to brokers or execute trades. Market information may be delayed.

Yahoo Finance data can be delayed, stale, unavailable, or incomplete. StockPilot does not guarantee real-time prices. Unavailable quotes are marked as unavailable; they are not replaced with invented market prices.

## Features

- Executive dashboard with portfolio-wide and account-level summaries.
- Manual holding create, edit, delete, and separate purchase-lot management.
- Multiple investment accounts and weighted-average purchase-price calculations.
- Optional `.xlsx`, `.xls`, and `.csv` import with preview, column mapping, validation, and duplicate handling.
- Watchlist with quote status and error visibility.
- Stock analysis with historical data and RSI, MACD, SMA, EMA, and support/resistance indicators.
- Portfolio and account reports, CSV download, multi-sheet Excel download, and browser print/Save as PDF.
- Settings, health diagnostics, and persistent local storage fallback.
- Emerald Finance user interface. The application does not place trades.

## Technology stack

| Layer | Technologies |
|---|---|
| Frontend | React 18, Vite, Tailwind CSS, React Router, Recharts, Lucide |
| Backend | Node.js, Express, Mongoose, Axios, SheetJS (`xlsx`) |
| Market data | Python, FastAPI, Uvicorn, `yfinance`, pandas, NumPy |
| Storage | MongoDB when configured and available; otherwise `backend/data/portfolio_db.json` |

## Folder structure

```text
StockPilot/
├── AGENTS.md
├── README.md
├── PROJECT_STATUS.md
├── .gitignore
├── .env.example
├── start_all.bat
├── start_all.ps1
├── designs/                      # Emerald Finance designs and screen references
├── docs/
│   └── MARKET_DATA_SERVICE_API.md
├── frontend/
│   ├── .env.example
│   ├── package.json
│   ├── vite.config.js
│   └── src/                      # Components, layouts, pages, API client
├── backend/
│   ├── .env.example
│   ├── package.json
│   ├── server.js
│   ├── config/                   # MongoDB connection
│   ├── controllers/
│   ├── middleware/
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── test_*.js                 # Backend regression and model tests
│   └── data/                     # Local private portfolio store; ignored by Git
└── market-data-service/
    ├── .env.example
    ├── requirements.txt
    ├── test_service.py
    └── app/                      # FastAPI endpoints and indicators
```

Local virtual environments, `node_modules`, generated build files, local portfolio data, and the private portfolio CSV are intentionally excluded from Git. Back them up separately as described below; do not put account data in a public repository.

## Requirements

- Windows 10/11, PowerShell, Node.js (LTS recommended), and npm.
- Python 3.11 or newer; the current tested workspace uses Python 3.14.
- MongoDB Community Server locally or an existing MongoDB connection URI is optional. If MongoDB is unavailable, the backend uses its private persistent JSON store.
- Internet access is needed for Yahoo Finance requests; quote and history availability depends on Yahoo Finance and the ticker/exchange.

## First-time setup

Open PowerShell in the project root:

```powershell
cd "C:\path\to\StockPilot"
```

Install Node dependencies once, if the package folders do not already have `node_modules`:

```powershell
cd .\backend
npm install
cd ..\frontend
npm install
cd ..
```

Create the Python environment once if `market-data-service\venv` is absent:

```powershell
cd .\market-data-service
py -3 -m venv .\venv
.\venv\Scripts\Activate.ps1
python -m pip install -r .\requirements.txt
deactivate
cd ..
```

If PowerShell blocks activation, use the venv interpreter directly instead:

```powershell
.\market-data-service\venv\Scripts\python.exe -m pip install -r .\market-data-service\requirements.txt
```

Do not repeat dependency installation unless dependencies change or the environment is missing/broken.

## Environment configuration

Copy a service template to that service's local `.env` only if you need to change its defaults:

```powershell
Copy-Item .\backend\.env.example .\backend\.env
Copy-Item .\frontend\.env.example .\frontend\.env
Copy-Item .\market-data-service\.env.example .\market-data-service\.env
```

The templates contain local defaults, not credentials. `.env` files are ignored by Git. Never commit a real MongoDB URI, password, API key, or other secret.

### MongoDB

The backend reads `MONGO_URI` from `backend\.env`. The default is:

```text
mongodb://127.0.0.1:27017/stockpilot
```

For a local MongoDB Windows service, start it from an elevated PowerShell if needed:

```powershell
Start-Service MongoDB
Get-Service MongoDB
```

If MongoDB is not installed or is not running, no database setup is required to try the application: the backend uses `backend\data\portfolio_db.json`. To use MongoDB Atlas, place the URI in `backend\.env` locally and keep that file private. The application does not migrate or merge the JSON store into MongoDB automatically. A new empty installation creates a generic default account only; it does not populate sample or personal holdings.

### Python market-data service

The FastAPI application reads `CACHE_TTL_SECONDS` and `CORS_ORIGINS` from `market-data-service\.env`. Defaults are suitable for the local Vite frontend. Start Uvicorn from the `market-data-service` directory; the launch command binds to `127.0.0.1:8000`.

### Frontend

Vite runs on port `5173` and proxies `/api` requests to `http://127.0.0.1:5000`. `VITE_API_URL` is optional; leave it unset to use the proxy. The frontend does not need a Yahoo Finance API key.

### Report export endpoints

- `GET /api/reports/portfolio` returns the consolidated portfolio and account report as JSON.
- `GET /api/reports/portfolio.xlsx` downloads a workbook with Portfolio Summary, Holdings, Accounts, and Stock Allocation worksheets. Unavailable market prices are left blank and identified by status.
- The Reports screen also exports CSV and uses the browser's print dialog for **Print / Save PDF**.

## Windows startup

Start services in this order. Use a separate terminal for each service, and leave the terminals open while using StockPilot.

1. **MongoDB (optional):** start the installed MongoDB service as described above. If you skip it, persistent disk storage is used.
2. **Terminal 1 — FastAPI market data:**

   ```powershell
   cd "C:\path\to\StockPilot\market-data-service"
   .\venv\Scripts\Activate.ps1
   python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
   ```

3. **Terminal 2 — Node.js backend:**

   ```powershell
   cd "C:\path\to\StockPilot\backend"
   npm.cmd start
   ```

4. **Terminal 3 — React frontend:**

   ```powershell
   cd "C:\path\to\StockPilot\frontend"
   npm.cmd run dev
   ```

Open **[http://localhost:5173](http://localhost:5173)**. The API health check is [http://localhost:5000/api/health](http://localhost:5000/api/health); FastAPI docs are at [http://localhost:8000/docs](http://localhost:8000/docs).

Alternatively, run `.\start_all.ps1` or double-click `start_all.bat`; each service opens in its own terminal. Stop each service with **Ctrl+C** in its terminal. If using the starter scripts, stop each service terminal the same way. Stop MongoDB only if you started it solely for this session; in elevated PowerShell use `Stop-Service MongoDB`.

## Yahoo Finance integration

The backend calls the local Python service; Python uses `yfinance`. NSE symbols use the `.NS` suffix and BSE symbols use `.BO`. The service provides:

- Quote and batch quote endpoints: `/api/market/quote/{symbol}`, `/api/market/quotes`
- Historical prices: `/api/market/history/{symbol}`
- Analysis and indicators: `/api/market/analysis/{symbol}`
- Service health: `/health`

See [docs/MARKET_DATA_SERVICE_API.md](./docs/MARKET_DATA_SERVICE_API.md) for request and response shapes. Yahoo Finance is an external source; delayed, stale, missing, or unavailable values can occur. Verify investment decisions independently. No quote is guaranteed to be real time.

## Tests and checks

Run the existing checks from the project root:

```powershell
cd .\backend
node .\test_backend.js
node .\test_full_suite.js
node .\test_model_logic.js
node .\test_mongoose.js
cd ..\market-data-service
.\venv\Scripts\python.exe -m unittest -v test_service
cd ..\frontend
npm.cmd run build
```

The backend integration test uses isolated **DEMO DATA** and does not write to the local portfolio file. `test_mongoose.js` uses an in-memory MongoDB test server; it does not verify a user's external MongoDB credentials.

## Troubleshooting

- **Port already in use:** close the prior service terminal or identify the process bound to 5173, 5000, or 8000 before starting another instance.
- **Frontend cannot reach API:** confirm Node is listening on 5000 and that Vite's `/api` proxy targets `127.0.0.1:5000`.
- **Market quotes unavailable:** confirm FastAPI health at `http://127.0.0.1:8000/health`; then check ticker spelling and `.NS`/`.BO` suffix. Yahoo Finance may still be unavailable or delayed.
- **MongoDB connection refused:** start MongoDB or use the persistent disk fallback. The backend logs which store it selected.
- **Python activation is blocked:** use `.\venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload`.
- **Missing Python import:** activate the project venv and install `requirements.txt` only if required packages are missing.
- **Excel preview/import error:** confirm the file is `.xlsx`, `.xls`, or `.csv`, is under the configured upload limit, and has valid symbol, quantity, and buy-price columns.
- **Accidental public-data concern:** stop before publishing; inspect repository ignore rules and ensure local `.env` files, `backend\data`, private CSVs, and generated reports are excluded.

## Backup guidance

Before upgrading, moving, or cleaning the project, stop the services and copy the whole project folder to a secure location. Back up `backend\data\portfolio_db.json` separately because Git intentionally ignores it. Keep MongoDB backups separate if using MongoDB. Protect backups with the same care as financial records; do not upload them to a public repository or include them in a public archive.
