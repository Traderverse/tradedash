# Using Real Market Data in TradeDash

## Quick Start - FREE Yahoo Finance Data 🎉

**No API key required!** Yahoo Finance is completely free to use.

### Step 1: Install tradeio Package

```r
# Install from GitHub
devtools::install_github("Traderverse/tradeio")
```

### Step 2: Launch Dashboard

```r
library(tradedash)
launch_dashboard()
```

**That's it!** The dashboard will automatically:
- Detect that `tradeio` is installed
- Fetch real data from Yahoo Finance for AAPL, MSFT, GOOGL, AMZN, TSLA
- Display real equity curves, prices, and performance metrics
- Show live market data

---

## What You Get (FREE)

### Yahoo Finance provides:

✅ **Stocks** - All US and international stocks
- Examples: AAPL, MSFT, GOOGL, TSLA, etc.

✅ **ETFs** - All major ETFs
- Examples: SPY, QQQ, IWM, GLD, TLT

✅ **Indices** - Major market indices
- Examples: ^GSPC (S&P 500), ^DJI (Dow), ^IXIC (NASDAQ)

✅ **Cryptocurrencies** - Major crypto pairs
- Examples: BTC-USD, ETH-USD, DOGE-USD

✅ **Forex** - Currency pairs
- Examples: EURUSD=X, GBPUSD=X

✅ **Commodities** - Futures contracts
- Examples: GC=F (Gold), CL=F (Oil)

### Data includes:
- Open, High, Low, Close prices (OHLC)
- Trading volume
- Adjusted close (for splits/dividends)
- Historical data (up to 20+ years)
- Daily, weekly, monthly intervals

### Limitations (all FREE APIs have these):
- No real-time tick data (15-20 minute delay)
- No order book / Level 2 data
- Rate limit: ~2000 requests/hour
- Best for: Daily trading, backtesting, portfolio tracking

---

## Using Real Data Directly

### Fetch data in your R scripts:

```r
library(tradeio)

# Single stock - 1 year of data
aapl <- fetch_yahoo("AAPL", from = "2024-01-01")

# Multiple stocks
tech_stocks <- fetch_yahoo(
  c("AAPL", "MSFT", "GOOGL", "AMZN"),
  from = "2023-01-01",
  to = Sys.Date()
)

# Bitcoin
btc <- fetch_yahoo("BTC-USD", from = "2024-01-01")

# S&P 500 Index
sp500 <- fetch_yahoo("^GSPC", from = "2020-01-01")

# ETF - SPDR S&P 500
spy <- fetch_yahoo("SPY", from = "2024-01-01")
```

### View the data:

```r
head(aapl)

# Output:
# # A tibble: 6 × 8
#   symbol datetime            open  high   low close   volume adjusted
#   <chr>  <dttm>             <dbl> <dbl> <dbl> <dbl>    <dbl>    <dbl>
# 1 AAPL   2024-01-01 00:00:00  180.  182.  179.  181. 75000000     181.
# 2 AAPL   2024-01-02 00:00:00  181.  183.  180.  182. 68000000     182.
# ...
```

### Use in backtesting:

```r
library(tradeengine)
library(tradeio)

# Fetch real data
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# Convert to market_tbl if needed (tradeio already returns this format)
# Run backtest
strategy <- create_strategy(
  entry = function(data) {
    SMA(data$close, 20) > SMA(data$close, 50)
  }
)

results <- backtest(strategy, data, initial_capital = 100000)
```

### Use in visualization:

```r
library(tradeviz)
library(tradeio)

# Fetch and plot
data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Candlestick chart
plot_candles(data, title = "AAPL - Real Yahoo Data")

# With volume
plot_candles(data, show_volume = TRUE)
```

---

## Alternative Data Sources

### Option 2: Alpha Vantage (FREE but requires API key)

**Get your free API key:** https://www.alphavantage.co/support/#api-key

```r
# Set your API key (one time)
Sys.setenv(ALPHA_VANTAGE_KEY = "your_api_key_here")

# Fetch data
data <- fetch_alpha_vantage("AAPL")

# Intraday data (1 min, 5 min, etc.)
intraday <- fetch_alpha_vantage("AAPL", interval = "5min")
```

**Pros:**
- Intraday data available (1min, 5min, 15min, 30min, 60min)
- Official API with good documentation
- More reliable than Yahoo (official API vs web scraping)

**Cons:**
- Rate limit: 5 calls/minute, 500 calls/day (free tier)
- Requires API key registration

### Option 3: Load from CSV Files

```r
# If you have your own data files
data <- fetch_csv("my_data.csv")

# Specify column names if different
data <- fetch_csv(
  "my_data.csv",
  symbol_column = "ticker",
  date_column = "date"
)

# Single symbol file without symbol column
data <- fetch_csv("aapl_prices.csv", symbol = "AAPL")
```

---

## Dashboard Configuration

### Customize which symbols to fetch:

Edit the dashboard.R or create a config file:

```r
# In your R session before launching
options(tradedash.symbols = c("AAPL", "MSFT", "NVDA", "TSLA", "GOOGL"))

launch_dashboard()
```

Or create `config.yaml`:

```yaml
# config.yaml
data_source: "yahoo"
symbols: 
  - "AAPL"
  - "MSFT" 
  - "NVDA"
  - "TSLA"
  - "GOOGL"
  - "SPY"
  - "QQQ"
  
refresh_rate: 300000  # 5 minutes in milliseconds
auto_fetch: true
cache_data: true
```

Then launch:

```r
launch_dashboard(config_file = "config.yaml")
```

---

## Real-Time Updates (Advanced)

For near real-time updates in the dashboard, you can set up automatic refresh:

```r
# This will be added in v0.2.0
launch_dashboard(
  auto_refresh = TRUE,
  refresh_interval = 300  # seconds (5 minutes)
)
```

**Note:** Even with auto-refresh, Yahoo Finance has a 15-20 minute delay. For true real-time data, you need a paid service or broker API.

---

## Comparison of Data Sources

| Source | Cost | Real-time | Intraday | Historical | API Key |
|--------|------|-----------|----------|------------|---------|
| **Yahoo Finance** | FREE | No (15-20 min delay) | No | 20+ years | No ❌ |
| **Alpha Vantage** | FREE | No | Yes (1min+) | 20+ years | Yes ✅ |
| **IEX Cloud** | Paid | Yes | Yes | Limited | Yes ✅ |
| **Interactive Brokers** | Account req | Yes | Yes | Years | Yes ✅ |
| **Polygon.io** | Paid | Yes | Yes | Full | Yes ✅ |

**Recommendation:** Start with Yahoo Finance (FREE, no signup). Upgrade to Alpha Vantage if you need intraday data.

---

## Troubleshooting

### "Failed to fetch data" error:

1. **Check internet connection**
2. **Verify ticker symbol** - Use Yahoo Finance website to confirm symbol
3. **Try different date range** - Some stocks don't have old data
4. **Install required packages:**

```r
install.packages("quantmod")  # Required for Yahoo Finance
install.packages("httr")      # Required for Alpha Vantage
install.packages("jsonlite")  # Required for Alpha Vantage
```

### "tradeio not found" warning:

Install tradeio:

```r
devtools::install_github("Traderverse/tradeio")
```

### Data is cached/stale:

Clear the cache:

```r
# If using memoise caching
cache_dir <- "~/.tradedash/cache"
unlink(cache_dir, recursive = TRUE)
```

### Rate limit exceeded:

**Yahoo Finance:**
- Wait a few minutes
- Reduce number of symbols
- Fetch data less frequently

**Alpha Vantage (free tier):**
- 5 calls per minute
- 500 calls per day
- Script adds 12 second delay automatically

---

## Example: Complete Trading Workflow with Real Data

```r
library(tradeio)
library(tradefeatures)
library(tradeengine)
library(tradeviz)

# 1. Fetch real data
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# 2. Add technical indicators
data_with_indicators <- data %>%
  add_sma(20) %>%
  add_sma(50) %>%
  add_rsi(14)

# 3. Create strategy
strategy <- create_strategy(
  name = "SMA Crossover",
  entry = function(data) {
    data$sma_20 > data$sma_50 & data$rsi_14 < 70
  },
  exit = function(data) {
    data$sma_20 < data$sma_50 | data$rsi_14 > 80
  }
)

# 4. Backtest
results <- backtest(strategy, data_with_indicators, initial_capital = 100000)

# 5. Visualize
plot_equity_curve(results)
plot_drawdown(results)

# 6. Launch dashboard with results
launch_dashboard()
```

---

## Next Steps

1. ✅ **Install tradeio:** `devtools::install_github("Traderverse/tradeio")`
2. ✅ **Launch dashboard:** `launch_dashboard()`
3. ✅ **Watch real data load automatically**
4. 🔄 **Explore different symbols and timeframes**
5. 🔄 **Backtest your strategies with real data**
6. 🔄 **Share your results**

---

## Getting Help

- **Documentation:** https://traderverse.github.io/tradeio/
- **Issues:** https://github.com/Traderverse/tradeio/issues
- **Examples:** See `examples/basic_usage.R` in tradeio package

---

## Coming Soon (v0.2.0)

- 🔄 Auto-refresh real-time data in dashboard
- 🔄 WebSocket streaming for faster updates
- 🔄 More data sources (IEX Cloud, Polygon.io)
- 🔄 Broker integrations (Interactive Brokers, Alpaca)
- 🔄 Custom data source plugins
