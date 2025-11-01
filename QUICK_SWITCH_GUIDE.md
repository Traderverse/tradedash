# Quick Guide: Switching Between Data Sources

## 🎯 Two FREE Options Available

### Option 1: Yahoo Finance (Default)
- ✅ **NO setup needed**
- ✅ **NO API key required**
- ✅ Works immediately
- ⚡ Best for daily data

### Option 2: Alpha Vantage
- ✅ **FREE** but needs API key (30 seconds to get)
- ✅ Supports **intraday data** (1min, 5min, 15min, 30min, 60min)
- ⚡ Best for intraday analysis

---

## 📋 Quick Start: Yahoo Finance (No Setup!)

```r
# Install packages
devtools::install_github("Traderverse/tradeio")
devtools::install_github("Traderverse/tradedash")

# Launch
library(tradedash)
launch_dashboard()
```

**Done!** Yahoo Finance is already working with real data. Check top-right corner for: `🟢 Live - Yahoo Finance`

---

## 📋 Quick Start: Alpha Vantage (2-Minute Setup)

### Step 1: Get FREE API Key (30 seconds)
1. Visit: https://www.alphavantage.co/support/#api-key
2. Enter your email
3. Click "GET FREE API KEY"
4. Copy your key (e.g., `ABC123XYZ456`)

### Step 2: Configure in Dashboard (30 seconds)
1. Launch dashboard: `launch_dashboard()`
2. Click **Settings** tab (left sidebar)
3. Under **Data Sources**:
   - Select "Alpha Vantage (FREE - API Key Required)"
   - Paste your API key
   - Click "Save API Key"
   - Click "Test Connection"
4. See success message: ✅ Alpha Vantage connection successful!

### Step 3: Use It (instant!)
- Dashboard automatically refetches data
- Top-right shows: `🟢 Live - Alpha Vantage`
- All charts now use Alpha Vantage data

---

## 🔄 Switching Between Sources

### In the Dashboard:

1. **Go to Settings** (left sidebar, gear icon)
2. **Under "Data Sources":**
   - Select "Yahoo Finance (FREE)" → No API key needed
   - OR
   - Select "Alpha Vantage (FREE)" → Enter API key first
3. **Click "Test Connection"** → Verify it works
4. **Dashboard automatically updates** → No restart needed!

### In Your R Code:

```r
library(tradeio)

# Use Yahoo Finance
data_yahoo <- fetch_yahoo("AAPL", from = "2024-01-01")

# Switch to Alpha Vantage  
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key_here")
data_alpha <- fetch_alpha_vantage("AAPL")

# Or use universal function with source parameter
data1 <- fetch_prices("AAPL", source = "yahoo")
data2 <- fetch_prices("AAPL", source = "alpha_vantage")
```

---

## 🎨 Visual Dashboard Guide

### Main Dashboard
```
┌─────────────────────────────────────────────────────────┐
│  Trading Dashboard          🟢 Live - Yahoo Finance     │
├─────────────────────────────────────────────────────────┤
│  [Value Boxes: Portfolio, P&L, Returns, Sharpe]        │
│  [Equity Curve Chart]     [Allocation Pie]              │
│  [Market Overview Table]  [Top Positions Table]         │
└─────────────────────────────────────────────────────────┘
```

### Settings Tab - Data Sources
```
┌─────────────────────────────────────────┐
│ Data Sources                            │
├─────────────────────────────────────────┤
│ Primary Data Source:                    │
│ [▼ Yahoo Finance (FREE)            ]    │
│    - Alpha Vantage (FREE - API Key)     │
│                                         │
│ API Key (for Alpha Vantage):            │
│ [................................]      │
│ Get free key at: alphavantage.co        │
│                                         │
│ [Save API Key]  [Test Connection]       │
│                                         │
│ Connection Status:                      │
│ ✅ Yahoo Finance connection successful!│
│ Fetched 252 rows for AAPL              │
│ Latest price: $178.52                   │
└─────────────────────────────────────────┘
```

---

## 💡 When to Use Which Source

### Use Yahoo Finance When:
- ✅ You need **daily data** (OHLC by day)
- ✅ You want **zero setup** (no API key)
- ✅ You're doing **long-term analysis** (weeks, months, years)
- ✅ You're **backtesting daily strategies**
- ✅ You need **20+ years** of historical data
- ✅ You want **unlimited requests** (fair use)

**Examples:**
- Long-term trend analysis
- Daily SMA crossover strategies
- Multi-year backtests
- Portfolio rebalancing strategies

### Use Alpha Vantage When:
- ✅ You need **intraday data** (1min, 5min, 15min, 30min, 60min)
- ✅ You're doing **day trading** analysis
- ✅ You want to backtest **intraday strategies**
- ✅ You need **higher frequency** data
- ✅ You're okay with **5 calls/minute** limit

**Examples:**
- Day trading strategies
- 5-minute scalping strategies
- Intraday momentum analysis
- High-frequency pattern detection

---

## 📊 Feature Comparison

| Feature | Yahoo Finance | Alpha Vantage |
|---------|--------------|---------------|
| **Setup Time** | 0 seconds ⚡ | 2 minutes ⏱️ |
| **API Key** | Not needed | FREE key required |
| **Daily Data** | ✅ Yes | ✅ Yes |
| **Intraday (5min)** | ❌ No | ✅ Yes |
| **Rate Limit** | ~2000/hour | 5/min, 500/day |
| **Best For** | Daily trading | Intraday trading |

---

## 🚀 Complete Examples

### Example 1: Yahoo Finance for Daily Strategy

```r
library(tradeio)
library(tradeengine)
library(tradefeatures)

# Fetch daily data (no API key needed)
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# Add daily indicators
data <- data %>%
  add_sma(20) %>%
  add_sma(50)

# Daily strategy
strategy <- create_strategy(
  entry = function(d) d$sma_20 > d$sma_50
)

# Backtest
results <- backtest(strategy, data, initial_capital = 100000)
```

### Example 2: Alpha Vantage for Intraday Strategy

```r
library(tradeio)
library(tradeengine)

# Set API key
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key_here")

# Fetch 5-minute intraday data
data <- fetch_alpha_vantage("AAPL", interval = "5min")

# 5-minute strategy
strategy <- create_strategy(
  entry = function(d) {
    # Enter on breakout
    d$close > d$high_5min_ago
  }
)

# Backtest intraday
results <- backtest(strategy, data)
```

### Example 3: Comparing Both Sources

```r
library(tradeio)
library(dplyr)

# Fetch from Yahoo (daily)
yahoo_data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Fetch from Alpha Vantage (daily)
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")
alpha_data <- fetch_alpha_vantage("AAPL")

# Compare
nrow(yahoo_data)  # More historical data
nrow(alpha_data)  # Recent data

# Both have same structure!
colnames(yahoo_data)
colnames(alpha_data)
# Both: symbol, datetime, open, high, low, close, volume, adjusted
```

---

## ⚡ Pro Tips

### 1. Cache Your Data

```r
library(memoise)

# Cache Yahoo Finance calls
fetch_yahoo_cached <- memoise(
  fetch_yahoo,
  cache = cachem::cache_disk("~/.cache/yahoo")
)

# First call: fetches from API
data <- fetch_yahoo_cached("AAPL", from = "2024-01-01")

# Second call: instant from cache!
data <- fetch_yahoo_cached("AAPL", from = "2024-01-01")
```

### 2. Respect Rate Limits

```r
# Yahoo: Can fetch multiple symbols at once
data <- fetch_yahoo(c("AAPL", "MSFT", "GOOGL"))

# Alpha Vantage: Automatic 12s delay between calls
symbols <- c("AAPL", "MSFT", "GOOGL")
data_list <- lapply(symbols, function(sym) {
  fetch_alpha_vantage(sym)
  # Package adds Sys.sleep(12) automatically
})
```

### 3. Save API Key Permanently

```r
# Add to .Renviron file
usethis::edit_r_environ()

# Add this line:
ALPHA_VANTAGE_KEY=your_actual_key_here

# Save, close, restart R
# Key now works in all sessions!
```

---

## 🔧 Troubleshooting

### Dashboard shows "Sample Data"
```r
# 1. Install tradeio
devtools::install_github("Traderverse/tradeio")

# 2. Restart R
.rs.restartR()

# 3. Relaunch
launch_dashboard()
```

### "Alpha Vantage API key required"
```r
# Get key at: https://www.alphavantage.co/support/#api-key
# Then:
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")
```

### "Connection failed"
1. Check internet connection
2. Try other data source
3. Test in R console:
```r
library(tradeio)
fetch_yahoo("AAPL", from = Sys.Date() - 7)
```

---

## 📖 More Information

- **Complete Guide:** See `DATA_SOURCES_GUIDE.md`
- **Real Data Guide:** See `REAL_DATA_GUIDE.md`
- **Quick Examples:** See `REAL_DATA_QUICKSTART.R`

---

## ✅ Summary

**To use Yahoo Finance (easiest):**
```r
launch_dashboard()  # That's it!
```

**To use Alpha Vantage (for intraday):**
1. Get key: https://www.alphavantage.co/support/#api-key
2. In dashboard: Settings → Enter API key → Save
3. Switch source to "Alpha Vantage"
4. Done!

**Both are 100% FREE!** 🎉
