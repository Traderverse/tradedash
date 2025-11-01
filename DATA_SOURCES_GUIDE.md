# Data Source Integration Guide - FREE APIs

## Overview

TradeDash now supports **TWO FREE data sources** with easy switching between them:

1. **Yahoo Finance** - No signup, no API key (default)
2. **Alpha Vantage** - FREE API key required (better for intraday data)

---

## Quick Comparison

| Feature | Yahoo Finance | Alpha Vantage |
|---------|--------------|---------------|
| **Cost** | FREE ✅ | FREE ✅ |
| **API Key** | Not needed ❌ | Required (free) ✅ |
| **Signup** | No | Yes (30 seconds) |
| **Daily Data** | ✅ 20+ years | ✅ 20+ years |
| **Intraday Data** | ❌ No | ✅ Yes (1, 5, 15, 30, 60 min) |
| **Rate Limit** | ~2000/hour | 5/min, 500/day |
| **Stocks** | ✅ All | ✅ All |
| **ETFs** | ✅ All | ✅ All |
| **Crypto** | ✅ Yes | ✅ Yes |
| **Forex** | ✅ Yes | ✅ Yes |
| **Delay** | 15-20 min | 15-20 min |

**Recommendation:** 
- Use **Yahoo Finance** for daily data (easier, no setup)
- Use **Alpha Vantage** if you need intraday (1min, 5min, etc.)

---

## Setup Guide

### Option 1: Yahoo Finance (Default - No Setup Needed!)

```r
# Install packages
devtools::install_github("Traderverse/tradeio")
devtools::install_github("Traderverse/tradedash")

# Launch dashboard
library(tradedash)
launch_dashboard()
```

**That's it!** Yahoo Finance works automatically with no configuration.

The dashboard will:
- ✅ Auto-fetch data from Yahoo Finance
- ✅ Display real stock prices
- ✅ Show real equity curves
- ✅ Update market overview table

### Option 2: Alpha Vantage (FREE API Key Required)

#### Step 1: Get Your Free API Key

1. Go to: https://www.alphavantage.co/support/#api-key
2. Enter your email
3. Click "GET FREE API KEY"
4. Copy your key (looks like: `ABC123XYZ456`)

**Note:** The free tier gives you:
- 5 API calls per minute
- 500 API calls per day
- Unlimited daily use within limits

#### Step 2: Set Up API Key

**Option A: Save in Environment Variable (Recommended)**

```r
# Save API key (persists for session)
Sys.setenv(ALPHA_VANTAGE_KEY = "your_api_key_here")

# Or add to .Renviron file (persists forever)
# In R console:
usethis::edit_r_environ()

# Add this line:
# ALPHA_VANTAGE_KEY=your_api_key_here
# Save and restart R
```

**Option B: Enter in Dashboard**

1. Launch dashboard
2. Go to **Settings** tab
3. Select "Alpha Vantage" from Data Source dropdown
4. Paste your API key
5. Click "Save API Key"
6. Click "Test Connection"

#### Step 3: Switch Data Source

In the dashboard:
1. Go to **Settings** → **Data Sources**
2. Select "Alpha Vantage (FREE - API Key Required)"
3. The dashboard will automatically refetch data

---

## Using Data Sources in Your Code

### Yahoo Finance Examples

```r
library(tradeio)

# Single stock - daily data
aapl <- fetch_yahoo("AAPL", from = "2024-01-01")

# Multiple stocks
tech <- fetch_yahoo(
  c("AAPL", "MSFT", "GOOGL", "NVDA"),
  from = "2023-01-01"
)

# Bitcoin
btc <- fetch_yahoo("BTC-USD", from = "2024-01-01")

# S&P 500
sp500 <- fetch_yahoo("^GSPC", from = "2020-01-01")

# ETFs
spy <- fetch_yahoo("SPY", from = "2024-01-01")

# Weekly data
weekly <- fetch_yahoo("AAPL", from = "2023-01-01", periodicity = "weekly")
```

### Alpha Vantage Examples

```r
library(tradeio)

# Set API key first
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key_here")

# Daily data
aapl_daily <- fetch_alpha_vantage("AAPL")

# Intraday data - 5 minute bars
aapl_5min <- fetch_alpha_vantage("AAPL", interval = "5min")

# Other intervals: "1min", "5min", "15min", "30min", "60min"
aapl_1min <- fetch_alpha_vantage("AAPL", interval = "1min")
aapl_15min <- fetch_alpha_vantage("AAPL", interval = "15min")
aapl_hourly <- fetch_alpha_vantage("AAPL", interval = "60min")

# Full historical data (20+ years)
aapl_full <- fetch_alpha_vantage("AAPL", outputsize = "full")

# Compact (last 100 data points)
aapl_compact <- fetch_alpha_vantage("AAPL", outputsize = "compact")
```

### Universal fetch_prices() Function

The `fetch_prices()` function works with both sources:

```r
library(tradeio)

# Yahoo Finance (default)
data <- fetch_prices("AAPL", from = "2024-01-01")

# Alpha Vantage
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")
data <- fetch_prices(
  "AAPL",
  source = "alpha_vantage",
  interval = "5min"
)

# Multiple stocks (Yahoo)
data <- fetch_prices(
  c("AAPL", "MSFT", "GOOGL"),
  from = "2023-01-01"
)
```

---

## Integration Across Packages

### tradeio → tradeengine (Backtesting)

```r
library(tradeio)
library(tradeengine)

# Fetch real data from either source
data <- fetch_yahoo("AAPL", from = "2023-01-01")
# OR
# data <- fetch_alpha_vantage("AAPL")

# Create strategy
strategy <- create_strategy(
  entry = function(d) d$sma_20 > d$sma_50
)

# Backtest with real data
results <- backtest(strategy, data, initial_capital = 100000)

# View results
print(results)
```

### tradeio → tradefeatures (Technical Indicators)

```r
library(tradeio)
library(tradefeatures)

# Fetch real data
data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Add technical indicators
data_with_indicators <- data %>%
  add_sma(20) %>%
  add_sma(50) %>%
  add_rsi(14) %>%
  add_macd() %>%
  add_bbands()

# Use for analysis
head(data_with_indicators)
```

### tradeio → tradeviz (Visualization)

```r
library(tradeio)
library(tradeviz)

# Fetch real data
data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Candlestick chart with real data
plot_candles(data, title = "AAPL - Real Data")

# With volume
plot_candles(data, show_volume = TRUE)

# Line chart
plot_line(data, title = "AAPL Close Price")
```

### Complete Workflow Example

```r
library(tradeio)
library(tradefeatures)
library(tradeengine)
library(tradeviz)
library(tradedash)

# 1. Fetch real data (choose your source)
data <- fetch_yahoo("AAPL", from = "2023-01-01")
# OR with Alpha Vantage for intraday:
# Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")
# data <- fetch_alpha_vantage("AAPL", interval = "5min")

# 2. Add indicators
data <- data %>%
  add_sma(20) %>%
  add_sma(50) %>%
  add_rsi(14)

# 3. Create and backtest strategy
strategy <- create_strategy(
  entry = function(d) d$sma_20 > d$sma_50 & d$rsi_14 < 70,
  exit = function(d) d$sma_20 < d$sma_50 | d$rsi_14 > 80
)

results <- backtest(strategy, data, initial_capital = 100000)

# 4. Visualize results
plot_equity_curve(results)
plot_drawdown(results)

# 5. Launch dashboard with real data
launch_dashboard()
```

---

## Dashboard Features

### Data Source Indicator

The main dashboard shows your current data source in the top right:

```
🟢 Live - Yahoo Finance
```

or

```
🟢 Live - Alpha Vantage
```

### Switching Sources

1. Go to **Settings** tab
2. Under **Data Sources**, select:
   - "Yahoo Finance (FREE)" - No API key needed
   - "Alpha Vantage (FREE - API Key Required)" - Enter API key
3. Click "Save API Key" (for Alpha Vantage)
4. Click "Test Connection" to verify
5. Dashboard automatically refetches data

### Test Connection Feature

The "Test Connection" button:
- ✅ Verifies your internet connection
- ✅ Tests API key (for Alpha Vantage)
- ✅ Fetches sample data
- ✅ Shows latest price

Example output:
```
✅ Yahoo Finance connection successful!
Fetched 7 rows for AAPL
Latest price: $178.52
```

or

```
✅ Alpha Vantage connection successful!
API key valid
Fetched 100 rows for AAPL
Latest price: $178.52
```

---

## Rate Limits & Best Practices

### Yahoo Finance

**Limits:**
- ~2000 requests per hour
- No strict per-minute limit

**Best Practices:**
- ✅ Fetch multiple symbols at once
- ✅ Cache data locally
- ✅ Use reasonable time ranges
- ❌ Don't fetch every second

### Alpha Vantage (Free Tier)

**Limits:**
- 5 API calls per minute
- 500 API calls per day

**Best Practices:**
- ✅ Fetch during off-hours if possible
- ✅ Cache data aggressively
- ✅ Use `outputsize="compact"` when possible
- ✅ The package adds 12-second delays automatically
- ❌ Don't fetch all symbols in a loop without delays

**Example with caching:**

```r
library(memoise)
library(tradeio)

# Create cached version
fetch_cached <- memoise(
  fetch_yahoo,
  cache = cachem::cache_disk("~/.tradeio_cache")
)

# First call: fetches from Yahoo
data <- fetch_cached("AAPL", from = "2024-01-01")

# Subsequent calls: uses cache (instant!)
data <- fetch_cached("AAPL", from = "2024-01-01")
```

---

## Troubleshooting

### Issue: "Failed to fetch data"

**Solution:**
1. Check internet connection
2. Verify ticker symbol on Yahoo Finance website
3. Try different date range
4. Install required packages:

```r
install.packages("quantmod")  # For Yahoo
install.packages("httr")      # For Alpha Vantage
install.packages("jsonlite")  # For Alpha Vantage
```

### Issue: "Alpha Vantage API key required"

**Solution:**
1. Get free key: https://www.alphavantage.co/support/#api-key
2. Set in R: `Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")`
3. Or enter in dashboard Settings tab

### Issue: "Rate limit exceeded" (Alpha Vantage)

**Solution:**
1. Wait 1 minute before next call
2. You've made 5 calls in last minute
3. Free tier: 5 calls/min, 500 calls/day
4. Use caching (see above)

### Issue: Dashboard shows "Sample Data"

**Solution:**
1. Install tradeio: `devtools::install_github("Traderverse/tradeio")`
2. Restart R session
3. Launch dashboard again
4. Check Settings → Data Sources

### Issue: "Connection failed"

**Solutions:**
- Check firewall settings
- Try different data source
- Verify API key (Alpha Vantage)
- Check Yahoo Finance status: https://finance.yahoo.com

---

## Upgrading from Sample to Real Data

If dashboard currently shows sample data:

```r
# 1. Install tradeio
devtools::install_github("Traderverse/tradeio")

# 2. Restart R
.rs.restartR()  # In RStudio
# Or quit and reopen R

# 3. Launch dashboard
library(tradedash)
launch_dashboard()

# 4. Verify in dashboard:
# - Top right should show: 🟢 Live - Yahoo Finance
# - Charts should show real data
# - Market Overview should show actual prices
```

---

## Advanced Configuration

### Custom Symbols

Create a config file `config.yaml`:

```yaml
data_source: "yahoo"  # or "alpha_vantage"
symbols:
  - "AAPL"
  - "MSFT"
  - "GOOGL"
  - "NVDA"
  - "TSLA"
  - "SPY"
  - "QQQ"

refresh_interval: 300  # seconds
auto_refresh: true

# For Alpha Vantage
alpha_vantage:
  api_key: "your_key_here"
  interval: "5min"
  outputsize: "compact"
```

Launch with config:

```r
launch_dashboard(config_file = "config.yaml")
```

### Programmatic Source Switching

```r
library(tradedash)

# Set data source before launching
options(tradedash.data_source = "alpha_vantage")
Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")

launch_dashboard()
```

---

## Cost Comparison

| Source | Free Tier | Paid Tier | Real-time |
|--------|-----------|-----------|-----------|
| **Yahoo Finance** | Unlimited (fair use) | N/A | 15-20 min delay |
| **Alpha Vantage** | 5/min, 500/day | $50/mo (1200/min) | 15-20 min delay |
| IEX Cloud | 50k/mo | $9-79/mo | Real-time ✅ |
| Polygon.io | 5/min | $29-399/mo | Real-time ✅ |
| Interactive Brokers | Account required | Free with account | Real-time ✅ |

**For most users:**
- **Daily trading:** Yahoo Finance (free, unlimited)
- **Intraday analysis:** Alpha Vantage (free, 500/day)
- **Professional trading:** IEX Cloud or broker API (paid)

---

## Getting Help

- **Documentation:** https://traderverse.github.io/tradeio/
- **Issues:** https://github.com/Traderverse/tradeio/issues
- **Dashboard Help:** https://github.com/Traderverse/tradedash/issues
- **Alpha Vantage Support:** support@alphavantage.co

---

## Next Steps

1. ✅ Choose your data source (Yahoo for simplicity, Alpha Vantage for intraday)
2. ✅ Get API key if using Alpha Vantage
3. ✅ Install tradeio: `devtools::install_github("Traderverse/tradeio")`
4. ✅ Launch dashboard: `launch_dashboard()`
5. ✅ Go to Settings → Test Connection
6. ✅ Start trading with real data!

---

## Coming Soon

- 🔄 WebSocket streaming for real-time updates
- 🔄 IEX Cloud integration
- 🔄 Polygon.io integration  
- 🔄 Interactive Brokers API
- 🔄 Alpaca paper trading
- 🔄 Custom data source plugins
