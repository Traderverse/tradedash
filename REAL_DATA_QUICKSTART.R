# =============================================================================
# QUICK START: Launch Dashboard with REAL Market Data (FREE!)
# =============================================================================

# Step 1: Install required packages (one time only)
# -------------------------------------------------
install.packages("devtools")
devtools::install_github("Traderverse/tradeio")    # For Yahoo Finance data (FREE)
devtools::install_github("Traderverse/tradedash")  # Dashboard

# Step 2: Launch the dashboard
# -------------------------------------------------
library(tradedash)
launch_dashboard()

# That's it! The dashboard will:
# ✅ Automatically fetch real data from Yahoo Finance (FREE - no API key!)
# ✅ Show real equity curves based on actual stock performance
# ✅ Display latest market prices for AAPL, MSFT, GOOGL, AMZN, TSLA
# ✅ Use 1+ year of real historical data

# =============================================================================
# What is Yahoo Finance?
# =============================================================================
# - FREE financial data provider (no signup, no API key needed)
# - Provides: Stocks, ETFs, Indices, Crypto, Forex, Commodities
# - Historical data: 20+ years available
# - Update frequency: ~15-20 minute delay (standard for free APIs)
# - Best for: Daily trading, backtesting, portfolio tracking

# =============================================================================
# Examples: Fetching Real Data Directly
# =============================================================================

library(tradeio)

# Example 1: Single stock
aapl <- fetch_yahoo("AAPL", from = "2024-01-01")
head(aapl)

# Example 2: Multiple stocks
tech <- fetch_yahoo(
  c("AAPL", "MSFT", "GOOGL", "NVDA"),
  from = "2023-01-01"
)

# Example 3: Bitcoin
btc <- fetch_yahoo("BTC-USD", from = "2024-01-01")

# Example 4: S&P 500 Index
sp500 <- fetch_yahoo("^GSPC", from = "2020-01-01")

# Example 5: ETFs
spy <- fetch_yahoo("SPY", from = "2024-01-01")    # S&P 500 ETF
qqq <- fetch_yahoo("QQQ", from = "2024-01-01")    # NASDAQ ETF

# =============================================================================
# Use Real Data in Backtesting
# =============================================================================

library(tradeengine)
library(tradefeatures)
library(tradeio)

# Fetch real Apple data
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# Add technical indicators
data <- data %>%
  add_sma(20) %>%
  add_sma(50) %>%
  add_rsi(14)

# Create a simple SMA crossover strategy
strategy <- create_strategy(
  name = "SMA Crossover",
  entry = function(data) {
    data$sma_20 > data$sma_50
  },
  exit = function(data) {
    data$sma_20 < data$sma_50
  }
)

# Run backtest with REAL DATA
results <- backtest(strategy, data, initial_capital = 100000)

# View results
print(results)

# =============================================================================
# Visualize Real Data
# =============================================================================

library(tradeviz)
library(tradeio)

# Fetch and visualize
data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Candlestick chart with real data
plot_candles(data, title = "AAPL - Real Yahoo Finance Data")

# With volume
plot_candles(data, show_volume = TRUE)

# Equity curve from backtest
plot_equity_curve(results)

# Drawdown chart
plot_drawdown(results)

# =============================================================================
# Need Intraday Data? Use Alpha Vantage (also FREE, but needs API key)
# =============================================================================

# Get free API key: https://www.alphavantage.co/support/#api-key
Sys.setenv(ALPHA_VANTAGE_KEY = "your_free_api_key_here")

# Fetch 5-minute intraday data
intraday <- fetch_alpha_vantage("AAPL", interval = "5min")

# Other intervals: "1min", "5min", "15min", "30min", "60min"

# =============================================================================
# Troubleshooting
# =============================================================================

# If you see "Failed to fetch data":
# 1. Check internet connection
# 2. Verify ticker symbol on Yahoo Finance website
# 3. Install quantmod: install.packages("quantmod")

# If dashboard shows "Using Sample Data":
# 1. Install tradeio: devtools::install_github("Traderverse/tradeio")
# 2. Restart R session
# 3. Launch dashboard again

# =============================================================================
# More Information
# =============================================================================

# See REAL_DATA_GUIDE.md for complete documentation
# - All available data sources
# - Configuration options
# - Advanced examples
# - Troubleshooting guide

print("🚀 Ready to trade with REAL market data!")
print("📊 Run: launch_dashboard()")
print("📖 See: REAL_DATA_GUIDE.md for more info")
