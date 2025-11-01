# Complete Trading Workflow - CORRECTED VERSION
# This shows the proper way to use all TradingVerse packages together

# =============================================================================
# Install Packages (one time only)
# =============================================================================
devtools::install_github("Traderverse/tradeio")
devtools::install_github("Traderverse/tradefeatures")
devtools::install_github("Traderverse/tradeengine")
devtools::install_github("Traderverse/tradeviz")
devtools::install_github("Traderverse/tradedash")

# =============================================================================
# Load Libraries
# =============================================================================
library(tradeio)
library(tradefeatures)
library(tradeengine)
library(tradeviz)
library(tradedash)

# =============================================================================
# STEP 1: Fetch Real Data
# =============================================================================

# Option A: Yahoo Finance (FREE, no API key)
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# Option B: Alpha Vantage (FREE with API key, supports intraday)
# Sys.setenv(ALPHA_VANTAGE_KEY = "your_key_here")
# data <- fetch_alpha_vantage("AAPL", interval = "daily")
# # For intraday: interval = "5min", "15min", "30min", "60min"

# =============================================================================
# STEP 2: Add Technical Indicators
# =============================================================================

data <- data %>%
  add_sma(20) %>%      # 20-day simple moving average
  add_sma(50) %>%      # 50-day simple moving average
  add_rsi(14) %>%      # 14-day RSI
  add_macd() %>%       # MACD indicator
  add_bbands()         # Bollinger Bands

# View the data with indicators
head(data)

# =============================================================================
# STEP 3: Define Trading Strategy
# =============================================================================

# Use add_strategy() to add entry/exit signals to your data
data_with_strategy <- data %>%
  add_strategy(
    name = "SMA_RSI_Strategy",
    entry_rules = sma_20 > sma_50 & rsi_14 < 70,  # Buy when fast SMA crosses above slow and RSI not overbought
    exit_rules = sma_20 < sma_50 | rsi_14 > 80,   # Sell when fast crosses below or RSI overbought
    position_size = 100,    # Number of shares per trade
    commission = 0.001,     # 0.1% commission
    slippage = 0.0005      # 0.05% slippage
  )

# =============================================================================
# STEP 4: Run Backtest
# =============================================================================

results <- backtest(
  data_with_strategy,
  initial_capital = 100000,
  method = "vectorized"  # or "event_driven" for more realistic simulation
)

# View results summary
print(results)
summary(results)

# =============================================================================
# STEP 5: Visualize Results
# =============================================================================

# Equity curve
plot_equity_curve(results)

# Drawdown chart
plot_drawdown(results)

# If you have the trades data
if (!is.null(results$trades) && nrow(results$trades) > 0) {
  # View trades
  head(results$trades)
  
  # Plot with trade markers
  plot_candles(data_with_strategy, show_volume = TRUE)
}

# =============================================================================
# STEP 6: Launch Interactive Dashboard
# =============================================================================

launch_dashboard()

# The dashboard will automatically:
# - Fetch real market data (Yahoo Finance by default)
# - Display real-time equity curves
# - Show current market prices
# - Allow you to switch data sources in Settings

# =============================================================================
# Alternative: Simpler Strategy Example
# =============================================================================

# Simple SMA crossover
simple_strategy <- data %>%
  add_strategy(
    name = "Simple_SMA_Cross",
    entry_rules = sma_20 > sma_50,
    exit_rules = sma_20 < sma_50
  )

simple_results <- backtest(simple_strategy, initial_capital = 100000)
print(simple_results)

# =============================================================================
# Alternative: Multiple Stocks
# =============================================================================

# Fetch multiple stocks
tech_stocks <- fetch_yahoo(
  c("AAPL", "MSFT", "GOOGL", "NVDA"),
  from = "2023-01-01"
)

# Add indicators to all stocks
tech_with_indicators <- tech_stocks %>%
  add_sma(20) %>%
  add_sma(50)

# Strategy for multiple stocks
tech_strategy <- tech_with_indicators %>%
  add_strategy(
    name = "Multi_Stock_SMA",
    entry_rules = sma_20 > sma_50,
    exit_rules = sma_20 < sma_50
  )

# Backtest (will handle multiple symbols)
tech_results <- backtest(tech_strategy, initial_capital = 100000)

# =============================================================================
# Key Function Reference
# =============================================================================

# tradeio:
#   fetch_yahoo()         - Fetch from Yahoo Finance (FREE, no API key)
#   fetch_alpha_vantage() - Fetch from Alpha Vantage (FREE with API key)
#   fetch_prices()        - Universal fetch function

# tradefeatures:
#   add_sma()      - Simple Moving Average
#   add_ema()      - Exponential Moving Average
#   add_rsi()      - Relative Strength Index
#   add_macd()     - MACD
#   add_bbands()   - Bollinger Bands
#   add_atr()      - Average True Range
#   add_obv()      - On-Balance Volume

# tradeengine:
#   add_strategy() - Add trading signals to data
#   backtest()     - Run backtest simulation
#   create_portfolio() - Create multi-asset portfolio

# tradeviz:
#   plot_candles()       - Candlestick charts
#   plot_equity_curve()  - Equity curve
#   plot_drawdown()      - Drawdown chart
#   plot_line()          - Line charts
#   plot_correlation()   - Correlation heatmap

# tradedash:
#   launch_dashboard()   - Launch interactive dashboard

# =============================================================================
# Troubleshooting
# =============================================================================

# Error: "could not find function 'create_strategy'"
# Solution: Use add_strategy() instead

# Error: "No strategy signals found"
# Solution: Must call add_strategy() before backtest()

# Error: "Input must be a market_tbl object"
# Solution: Make sure you're using fetch_yahoo() or fetch_alpha_vantage()

# Dashboard shows "Sample Data"
# Solution: Install tradeio package:
# devtools::install_github("Traderverse/tradeio")

print("✅ Complete workflow ready!")
print("📊 Run the code step by step to build your trading system")
