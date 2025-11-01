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
# IMPORTANT: Column names created are sma_20, sma_50, and "rsi" (not rsi_14!)
data <- data %>%
  add_sma(20) %>%      # Creates column: sma_20
  add_sma(50) %>%      # Creates column: sma_50
  add_rsi(14)          # Creates column: rsi (NOT rsi_14!)

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
# IMPORTANT: Use "rsi" NOT "rsi_14" in your rules!
data_with_strategy <- data %>%
  add_strategy(
    name = "SMA_RSI_Strategy",
    entry_rules = sma_20 > sma_50 & rsi < 70,      # Use "rsi" not "rsi_14"!
    exit_rules = sma_20 < sma_50 | rsi > 80,       # Use "rsi" not "rsi_14"!
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
# NOTE: If you get an error about missing equity column, reload tradeviz:
# devtools::load_all("../tradeviz")

plot_equity_curve(results)  # Now works with backtest_results objects!
plot_drawdown(results)      # Also updated to handle backtest_results

# =============================================================================
# OPTION: Custom Column Names
# =============================================================================
# You can specify custom names for columns if you prefer rsi_14 over rsi
data_custom <- fetch_yahoo("AAPL", from = "2023-01-01")

data_custom <- data_custom %>%
  add_sma(20, name = "sma_20") %>%     # Custom name (same as default)
  add_sma(50, name = "sma_50") %>%     # Custom name (same as default)
  add_rsi(14, name = "rsi_14")         # Custom name: rsi_14 instead of rsi

# Fix class
class(data_custom) <- c("market_tbl", class(data_custom))

# Now you CAN use rsi_14 because we named it that way!
data_custom <- add_strategy(
  data_custom,
  name = "Custom_Names",
  entry_rules = sma_20 > sma_50 & rsi_14 < 70,
  exit_rules = sma_20 < sma_50 | rsi_14 > 80
)

results_custom <- backtest(data_custom, initial_capital = 100000)

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
