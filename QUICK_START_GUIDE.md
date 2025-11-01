# 🚀 COPY & PASTE: COMPLETE TRADINGVERSE SETUP & RUN

## Quick Start (3 Steps)

### Step 1: Install All Packages (One-Time Setup)

Copy and paste this into R console:

```r
# Install remotes if needed
if (!require("remotes")) install.packages("remotes")

# Install all TradingVerse packages from GitHub
remotes::install_github("Traderverse/tradeio")
remotes::install_github("Traderverse/tradefeatures")
remotes::install_github("Traderverse/tradeengine")
remotes::install_github("Traderverse/tradeviz")
remotes::install_github("Traderverse/tradedash")

# Install dependencies
install.packages(c("dplyr", "ggplot2", "scales", "patchwork", "DT", 
                   "shiny", "shinydashboard", "plotly", "quantmod"))

cat("\n✅ ALL PACKAGES INSTALLED!\n\n")
```

### Step 2: Load Latest Code (Development Mode)

If you're working with the local repository (recommended for latest features):

```r
# Set working directory to Traderverse folder
setwd("/Users/danielperez/Documents/Traderverse")

# Load all packages in development mode
devtools::load_all("tradeio")
devtools::load_all("tradefeatures")
devtools::load_all("tradeengine")
devtools::load_all("tradeviz")
devtools::load_all("tradedash")

cat("\n✅ ALL PACKAGES LOADED (DEV MODE)!\n\n")
```

### Step 3: Run Complete Analysis

```r
# Run the comprehensive analysis script
source("tradedash/COMPLETE_TRADING_ANALYSIS.R")
```

That's it! The script will:
- ✅ Fetch live data for 8 stocks (AAPL, MSFT, GOOGL, AMZN, TSLA, NVDA, META, NFLX)
- ✅ Calculate 15+ technical indicators
- ✅ Test 4 different trading strategies
- ✅ Calculate risk metrics and investment scores
- ✅ Generate TODAY's recommendations
- ✅ Create visualizations
- ✅ Launch interactive dashboard with all tabs working

---

## Alternative: Unified Workflow (New System)

If you prefer the new `trading_session` approach:

```r
library(tradeio)
library(tradefeatures)
library(tradeengine)
library(tradeviz)

# Create session with live data
session <- fetch_yahoo("AAPL", from = "2023-01-01") %>%
  trading_session(
    name = "AAPL Strategy",
    description = "SMA crossover with RSI filter"
  ) %>%
  add_features(
    sma_20 = add_sma(20),
    sma_50 = add_sma(50),
    rsi = add_rsi(14)
  ) %>%
  add_strategy(
    entry = sma_20 > sma_50 & rsi < 70,
    exit = sma_20 < sma_50 | rsi > 80
  ) %>%
  run_backtest(initial_capital = 100000)

# See everything
print(session)       # Verbose output with all info
summary(session)     # Detailed statistics

# Visualize
plot(session)                    # Equity curve
plot(session, type = "drawdown") # Drawdown
plot(session, type = "all")      # All charts

# Launch dashboard
dashboard(session)
```

---

## Using Alpha Vantage API (Optional)

To use Alpha Vantage instead of Yahoo Finance:

```r
# Get FREE API key from: https://www.alphavantage.co/support/#api-key

# Set your API key
Sys.setenv(ALPHA_VANTAGE_KEY = "YOUR_API_KEY_HERE")

# Then in the dashboard:
# 1. Go to Settings tab
# 2. Enter API key
# 3. Select "Alpha Vantage" as data source
# 4. Click "Test Connection"

# Or use directly in code:
data <- fetch_alpha_vantage(
  "AAPL",
  api_key = Sys.getenv("ALPHA_VANTAGE_KEY")
)
```

---

## Troubleshooting

### Issue: "Package 'xxx' not found"
**Solution:** Run Step 1 again to install all packages

### Issue: "Function 'trading_session' not found"
**Solution:** Load tradeengine in dev mode:
```r
devtools::load_all("tradeengine")
```

### Issue: "No equity/value column found"
**Solution:** Reload tradeviz with latest fixes:
```r
devtools::load_all("tradeviz")
```

### Issue: Dashboard doesn't load data
**Solution:** Check Settings tab, switch data source, or check API key

### Issue: Vignette errors during check
**Solution:** Vignettes are now ignored in .Rbuildignore - this is expected

---

## Output Files

After running `COMPLETE_TRADING_ANALYSIS.R`, you'll have:

1. **tradingverse_analysis_report.rds** - Complete analysis results
2. **best_strategy_results.rds** - Best strategy backtest results

Load them later:
```r
report <- readRDS("tradingverse_analysis_report.rds")
results <- readRDS("best_strategy_results.rds")

# View comparison
print(report$strategy_comparison)

# View recommendations
print(report$current_recommendations)
```

---

## What You'll See

### Console Output:
```
==================================================================
  TRADINGVERSE COMPLETE ANALYSIS
==================================================================

[1/8] Loading packages...
      [OK] All packages loaded

[2/8] Configuration...
      Portfolio: AAPL, MSFT, GOOGL, AMZN, TSLA, NVDA, META, NFLX
      [OK] Configuration set

[3/8] Fetching live market data...
      [OK] Fetched 11,624 observations

[4/8] Calculating technical indicators...
      [OK] Added 15+ technical indicators

[5/8] Testing multiple trading strategies...
      Strategy 1: SMA Crossover with RSI Filter
         Return: +27.35% | Trades: 42
      Strategy 2: EMA Crossover with MACD
         Return: +31.12% | Trades: 58
      ...

[6/8] Calculating risk metrics...

      STRATEGY PERFORMANCE COMPARISON
      ------------------------------------------------------------
      Strategy              Return  Sharpe  MaxDD  WinRate Trades Score
      EMA_MACD              +31.12%   1.84  12.34%   61.9%     58   89
      SMA_Cross_RSI         +27.35%   1.67  14.23%   59.2%     42   82
      ...

[7/8] Analyzing current market conditions...

      TODAY'S INVESTMENT RECOMMENDATIONS
      ------------------------------------------------------------
      
      AAPL | Price: $178.45 | Score: 87/100 | BUY
         Trend: Strong Uptrend | RSI: 54.3 (Bullish)
      
      MSFT | Price: $387.23 | Score: 82/100 | BUY
         Trend: Uptrend | RSI: 48.7 (Bearish)
      ...

[8/8] Generating visualizations...

==================================================================
  LAUNCHING INTERACTIVE DASHBOARD
==================================================================
```

### Dashboard Features:
- **Overview Tab**: Portfolio summary with key metrics
- **Charts Tab**: Interactive price charts with all indicators
- **Performance Tab**: Equity curves, drawdowns, returns distribution
- **Trades Tab**: Complete trade history table
- **Settings Tab**: Switch data sources (Yahoo/Alpha Vantage)

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Install everything | See Step 1 above |
| Load dev packages | `devtools::load_all("package_name")` |
| Run full analysis | `source("tradedash/COMPLETE_TRADING_ANALYSIS.R")` |
| Create session | `trading_session(data, name = "My Strategy")` |
| Add indicators | `add_features(session, sma_20 = add_sma(20))` |
| Define strategy | `add_strategy(session, entry = ..., exit = ...)` |
| Run backtest | `run_backtest(session, initial_capital = 100000)` |
| View results | `print(session)` or `summary(session)` |
| Visualize | `plot(session)` or `plot(session, type = "all")` |
| Launch dashboard | `launch_dashboard()` or `dashboard(session)` |
| Fetch Yahoo data | `fetch_yahoo("AAPL", from = "2023-01-01")` |
| Fetch AV data | `fetch_alpha_vantage("AAPL", api_key = "xxx")` |

---

## 🎯 YOU'RE READY!

Just copy Step 1, Step 2, Step 3 in order and you'll have:
- ✅ All packages installed and loaded
- ✅ Live market data
- ✅ Multiple strategies tested
- ✅ Risk analysis complete
- ✅ Investment recommendations
- ✅ Interactive dashboard running

**Copy Step 3 now and hit Enter!** 🚀
