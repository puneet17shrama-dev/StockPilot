# StockPilot – System Architecture & Agent Guidelines

## 1. Project Overview
StockPilot is a full-stack Stock Portfolio Management and Analysis System designed for college project demonstration and institutional-grade portfolio monitoring. It features actual portfolio management, MongoDB permanent storage, optional Excel import, Yahoo Finance integration via Python (`yfinance`), responsive React UI following Google Stitch Emerald Finance designs, and comprehensive technical analysis & reporting.

## 2. Core Non-Negotiable Rules
- **No Trading Execution**: Portfolio monitoring and educational analysis only. No broker integration, no order placement.
- **Mandatory Disclaimer**: *"StockPilot is a portfolio monitoring and educational analysis tool. It does not connect to brokers or execute trades. Market information may be delayed."*
- **Actual Portfolio Management**: Realistic user portfolio data. No fictitious holdings generated as "actual". Any sample data must be clearly tagged **DEMO DATA**.
- **Permanent MongoDB Storage**: Load saved holdings automatically upon opening. Manual add/edit/delete works independently of Excel.
- **Multiple Accounts & Multiple Purchase Lots**: Preserves individual purchase lots with different buy prices and dates; calculates weighted average buy price accurately.
- **Market Data**: Dedicated Python service using `yfinance` exposing REST endpoints to Node.js backend. Handles NSE (`.NS`) and BSE (`.BO`) suffixes. Displays last update time and statuses (Available, Delayed, Stale, Unavailable).

## 3. Technology Stack & Directory Architecture
```
StockPilot/
├── AGENTS.md
├── README.md
├── .gitignore
├── .env.example
├── designs/                  # Google Stitch visual references & design docs
│   ├── emerald_finance/      # Color tokens & typography specification
│   ├── executive_dashboard/
│   ├── portfolio_holdings/
│   ├── add_stock_holding/
│   ├── excel_import_manager/
│   ├── my_watchlist/
│   ├── stock_analysis/
│   ├── reports_analytics/
│   ├── account_management/
│   └── settings/
├── docs/                     # Documentation & specifications
├── frontend/                 # React + Tailwind CSS + Lucide / Material Symbols + Recharts
│   ├── package.json
│   ├── vite.config.js
│   ├── tailwind.config.js
│   └── src/
│       ├── assets/
│       ├── components/
│       ├── pages/
│       ├── layouts/
│       ├── services/
│       ├── hooks/
│       └── utils/
├── backend/                  # Node.js + Express + Mongoose (REST API)
│   ├── package.json
│   ├── server.js
│   ├── config/               # Database connection & env config
│   ├── models/               # Account, Holding, Watchlist, Settings schemas
│   ├── controllers/          # Business logic handlers
│   ├── routes/               # API endpoint definitions
│   ├── middleware/           # Error handling & validation
│   └── services/             # Excel parsing, Yahoo finance bridge, calculation helpers
└── market-data-service/      # Python FastAPI / Starlette service
    ├── requirements.txt
    └── app/
        ├── main.py           # REST API for yfinance quotes & historical data
        └── indicators.py     # RSI, MACD, SMA, EMA calculation engine
```

## 4. Design Guidelines (Emerald Finance)
- **Background**: `#0C1322` / `#111827`
- **Cards / Elevated Surfaces**: `#191F2F` / `#1F2937`
- **Elevated Hover / Flyouts**: `#283548`
- **Borders**: `#374151` / `#3C4A42`
- **Primary Emerald**: `#10B981` (Luminous: `#34D399`)
- **Secondary Gold Accent**: `#D4AF37` / `#E9C349`
- **Positive Performance**: `#10B981` (Background tint: `rgba(16, 185, 129, 0.12)`)
- **Negative Performance**: `#EF4444` (Background tint: `rgba(239, 68, 68, 0.12)`)
- **Primary Text**: `#F9FAFB`
- **Secondary Text**: `#9CA3AF`
- **Muted Text**: `#6B7280`
- **Typography**: Inter for general UI + JetBrains Mono for financial metrics (`tnum`), tickers, and timestamps.

## 5. Financial Calculation Formulas
- **Invested Value**: $\sum (\text{Lot Quantity}_i \times \text{Lot Buy Price}_i)$
- **Weighted Average Buy Price**: $\frac{\text{Total Invested Value}}{\text{Total Quantity}}$
- **Current Value**: $\text{Total Quantity} \times \text{Current Market Price}$
- **Overall Profit/Loss**: $\text{Current Value} - \text{Total Invested Value}$
- **Return Percentage**: $\left(\frac{\text{Overall Profit/Loss}}{\text{Total Invested Value}}\right) \times 100$
- **Daily Profit/Loss**: $\text{Total Quantity} \times (\text{Current Market Price} - \text{Previous Close Price})$
- **Daily Return %**: $\left(\frac{\text{Current Market Price} - \text{Previous Close Price}}{\text{Previous Close Price}}\right) \times 100$
- *Edge cases*: Total Quantity = 0, Invested Value = 0, Missing previous close, or Unlisted/unresolved tickers must be safely handled without throwing NaN or crashing the UI.

## 6. Implementation Phases
- [x] Phase A: Project inspection, directory structure setup, environment templates, and dependency auditing.
- [x] Phase B: Frontend development (React, Tailwind CSS, Lucide icons, Recharts, full Stitch screens matching all approved designs, production build verified).
- [x] Phase C: Backend development (Node.js, Express, REST routes, controllers, validation, calculation engine).
- [x] Phase D: Database development (Mongoose schemas, multi-lot tracking, weighted average pre-validate hooks, account safety rules).
- [x] Phase E: Python Market Data Service (`yfinance` API with RSI, MACD, SMA/EMA technical indicators, NSE/BSE support).
- [x] Phase F: Application integration (Frontend <-> Backend <-> Market Data Service <-> MongoDB/Persistent Storage with User's 20 Actual Holdings).
- [x] Phase G: Comprehensive testing, verification, restart persistence, and documentation.
