# WORKING EXAMPLE - Copy and Paste This!
# This example includes the fix for the market_tbl class issue

# =============================================================================
# Install & Load Packages
# =============================================================================
library(tradeio)
library(tradefeatures)
library(tradeengine)
library(tradeviz)

# =============================================================================
# STEP 1: Fetch Real Data
# =============================================================================
data <- fetch_yahoo("AAPL", from = "2023-01-01")

# =============================================================================
# STEP 2: Add Indicators
# =============================================================================
data <- data %>%
  add_sma(20) %>%
  add_sma(50) %>%
  add_rsi(14)

# =============================================================================
# FIX: Preserve market_tbl class (important!)
# =============================================================================
# Sometimes dplyr operations strip the market_tbl class
# This ensures it's restored before calling add_strategy()
if (!"market_tbl" %in% class(data)) {
  class(data) <- c("market_tbl", class(data))
}

# =============================================================================
# STEP 3: Add Strategy
# =============================================================================
data_with_strategy <- data %>%
  add_strategy(
    name = "SMA_RSI_Strategy",
    entry_rules = sma_20 > sma_50 & rsi_14 < 70,
    exit_rules = sma_20 < sma_50 | rsi_14 > 80,
    position_size = 100,
    commission = 0.001,
    slippage = 0.0005
  )

# =============================================================================
# STEP 4: Backtest
# =============================================================================
results <- backtest(
  data_with_strategy,
  initial_capital = 100000
)

# =============================================================================
# STEP 5: View Results
# =============================================================================
print(results)

# =============================================================================
# STEP 6: Visualize
# =============================================================================
plot_equity_curve(results)
plot_drawdown(results)

# =============================================================================
# ALTERNATIVE: Simpler Approach (No Piping - Most Reliable!)
# =============================================================================

# Fetch data
data2 <- fetch_yahoo("MSFT", from = "2023-01-01")

# Add indicators one at a time
data2 <- add_sma(data2, 20)
data2 <- add_sma(data2, 50)
data2 <- add_rsi(data2, 14)

# Ensure market_tbl class
class(data2) <- c("market_tbl", class(data2))

# Add strategy
data2 <- add_strategy(
  data2,
  name = "Simple_Cross",
  entry_rules = sma_20 > sma_50,
  exit_rules = sma_20 < sma_50
)

# Backtest
results2 <- backtest(data2, initial_capital = 100000)
print(results2)

# =============================================================================
# BEST PRACTICE: Check Class Before add_strategy()
# =============================================================================

check_and_fix_class <- function(data) {
  if (!"market_tbl" %in% class(data)) {
    message("⚠️  Fixing market_tbl class...")
    class(data) <- c("market_tbl", class(data))
  } else {
    message("✅ market_tbl class is correct")
  }
  return(data)
}

# Use it:
data3 <- fetch_yahoo("GOOGL", from = "2023-01-01")
data3 <- data3 %>% add_sma(20) %>% add_sma(50)
data3 <- check_and_fix_class(data3)  # <- Fix if needed
data3 <- add_strategy(data3, entry_rules = sma_20 > sma_50, exit_rules = sma_20 < sma_50)
results3 <- backtest(data3)

print("✅ All examples completed successfully!")
