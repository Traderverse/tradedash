# ==============================================================================
# UNIFIED TRADINGVERSE WORKFLOW
# ==============================================================================
# This example shows the NEW consolidated workflow using trading_session objects
# Everything is verbose, organized, and easy to visualize
# ==============================================================================

library(tradeio)       # Data fetching
library(tradefeatures) # Technical indicators
library(tradeengine)   # Strategy & backtesting
library(tradeviz)      # Visualization
library(tradedash)     # Dashboard (optional)

# ==============================================================================
# STEP 1: Create Trading Session
# ==============================================================================
# The trading_session object consolidates EVERYTHING:
# - Data
# - Features (indicators)
# - Strategy
# - Backtest results
# - Statistics

# Fetch data
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# Create session
session <- trading_session(
  data = data,
  name = "AAPL SMA Crossover Strategy",
  description = "Testing 20/50 SMA crossover with RSI filter for risk management"
)

# See what you have (VERBOSE!)
print(session)

# ==============================================================================
# STEP 2: Add Features (Technical Indicators)
# ==============================================================================
# The session tracks what features you add and shows them clearly

session <- session %>%
  add_features(
    sma_20 = add_sma(20),
    sma_50 = add_sma(50),
    rsi = add_rsi(14)
  )

# Print again to see features added
print(session)

# ==============================================================================
# STEP 3: Define Strategy
# ==============================================================================
# Strategy is stored with the session for reproducibility

session <- session %>%
  add_strategy(
    entry = sma_20 > sma_50 & rsi < 70,
    exit = sma_20 < sma_50 | rsi > 80,
    name = "SMA_Crossover_RSI_Filter"
  )

# Print to see strategy
print(session)

# ==============================================================================
# STEP 4: Run Backtest
# ==============================================================================
# Backtest results are stored in the session

session <- session %>%
  run_backtest(initial_capital = 100000)

# Print to see backtest results summary
print(session)

# Get detailed statistics
summary(session)

# ==============================================================================
# STEP 5: Visualize (Multiple Ways!)
# ==============================================================================

# Option 1: Simple plot (equity curve)
plot(session)

# Option 2: Specific plots
plot(session, type = "equity")      # Equity curve
plot(session, type = "drawdown")    # Drawdown analysis
plot(session, type = "returns")     # Returns distribution
plot(session, type = "trades")      # Trade markers on chart

# Option 3: All plots at once
plot(session, type = "all")

# Option 4: Launch interactive dashboard
dashboard(session)

# ==============================================================================
# STEP 6: Extract Components as Needed
# ==============================================================================

# Access raw data
raw_data <- session$data

# Access backtest results
results <- session$backtest

# Access trades
trades <- session$backtest$trades

# Access equity curve
equity_curve <- session$backtest$equity_curve

# Access statistics
stats <- session$stats

# Print specific stats
cat("Total Return:", sprintf("%.2f%%", stats$total_return_pct), "\n")
cat("Sharpe Ratio:", sprintf("%.2f", stats$sharpe), "\n")
cat("Max Drawdown:", sprintf("%.2f%%", stats$max_drawdown_pct), "\n")
cat("Win Rate:", sprintf("%.1f%%", stats$win_rate), "\n")

# ==============================================================================
# ALTERNATIVE: Quick Pipeline (All in One)
# ==============================================================================

quick_session <- fetch_yahoo("MSFT", from = "2023-01-01") %>%
  trading_session(name = "MSFT Quick Test") %>%
  add_features(
    ema_12 = add_ema(12),
    ema_26 = add_ema(26),
    rsi = add_rsi(14)
  ) %>%
  add_strategy(
    entry = ema_12 > ema_26 & rsi < 60,
    exit = ema_12 < ema_26 | rsi > 80
  ) %>%
  run_backtest(initial_capital = 50000)

# One print shows EVERYTHING
print(quick_session)

# One plot shows results
plot(quick_session)

# ==============================================================================
# MULTI-SYMBOL SESSION
# ==============================================================================

# Fetch multiple symbols
multi_data <- fetch_yahoo(c("AAPL", "MSFT", "GOOGL"), from = "2023-01-01")

multi_session <- trading_session(
  data = multi_data,
  name = "Tech Portfolio Strategy",
  description = "Testing momentum strategy across tech stocks"
) %>%
  add_features(
    sma_20 = add_sma(20),
    rsi = add_rsi(14)
  ) %>%
  add_strategy(
    entry = close > sma_20 & rsi < 65,
    exit = close < sma_20 | rsi > 75
  ) %>%
  run_backtest(initial_capital = 300000)

print(multi_session)
plot(multi_session)

# ==============================================================================
# SAVE/LOAD SESSIONS
# ==============================================================================

# Save session for later (includes everything!)
saveRDS(session, "my_trading_session.rds")

# Load later
loaded_session <- readRDS("my_trading_session.rds")
print(loaded_session)
plot(loaded_session)

# ==============================================================================
# BENEFITS OF THIS APPROACH
# ==============================================================================
# 
# 1. VERBOSE: print(session) shows exactly what you have at any point
# 2. ORGANIZED: All components in one object (data, features, strategy, results)
# 3. REPRODUCIBLE: Session contains all info needed to recreate analysis
# 4. EASY VISUALIZATION: plot(session) handles all visualization logic
# 5. CLEAN SYNTAX: Chain operations with %>% or build step-by-step
# 6. DASHBOARD READY: dashboard(session) launches pre-configured dashboard
# 7. INSPECTABLE: Access any component directly (session$data, session$stats, etc.)
# 8. SAVEABLE: Save entire session as RDS for later analysis
#
# This consolidates ALL packages into ONE clean workflow!
# ==============================================================================
