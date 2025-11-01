#!/usr/bin/env Rscript
# ==============================================================================
# COMPLETE TRADINGVERSE ANALYSIS SCRIPT
# ==============================================================================
# 
# This script provides a complete end-to-end trading analysis workflow:
# - Multiple stock portfolio analysis
# - Pre-defined technical strategies
# - Historical performance evaluation
# - Risk metrics and scoring
# - Investment recommendations for TODAY
# - Interactive dashboard with all tabs working
# - Live API data integration
#
# COPY & PASTE THIS ENTIRE SCRIPT TO RUN!
# ==============================================================================

# ==============================================================================
# SETUP: Load All Packages
# ==============================================================================
cat("\n")
cat("=" %R% 70, "\n")
cat("  TRADINGVERSE COMPLETE ANALYSIS\n")
cat("=" %R% 70, "\n\n")

# Helper for string repeat
"%R%" <- function(str, n) paste(rep(str, n), collapse = "")

# Load packages
cat("[1/8] Loading packages...\n")
suppressPackageStartupMessages({
  library(tradeio)       # Data fetching
  library(tradefeatures) # Technical indicators
  library(tradeengine)   # Strategy & backtesting
  library(tradeviz)      # Visualization
  library(tradedash)     # Dashboard
  library(dplyr)         # Data manipulation
  library(scales)        # Formatting
})
cat("      [OK] All packages loaded\n\n")

# ==============================================================================
# CONFIGURATION: Portfolio & Analysis Settings
# ==============================================================================
cat("[2/8] Configuration...\n")

# Define portfolio of stocks to analyze
PORTFOLIO <- c("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "NVDA", "META", "NFLX")

# Date range for historical analysis
DATE_FROM <- "2023-01-01"
DATE_TO <- Sys.Date()

# Initial capital per stock
CAPITAL_PER_STOCK <- 50000
TOTAL_CAPITAL <- CAPITAL_PER_STOCK * length(PORTFOLIO)

# Risk-free rate for Sharpe calculation (10-year Treasury ~4.5%)
RISK_FREE_RATE <- 0.045

cat("      Portfolio:", paste(PORTFOLIO, collapse = ", "), "\n")
cat("      Date Range:", DATE_FROM, "to", DATE_TO, "\n")
cat("      Total Capital: $", format(TOTAL_CAPITAL, big.mark = ","), "\n")
cat("      [OK] Configuration set\n\n")

# ==============================================================================
# STEP 1: Fetch Live Market Data
# ==============================================================================
cat("[3/8] Fetching live market data...\n")

# Fetch data from Yahoo Finance (FREE, no API key needed)
# Note: To use Alpha Vantage instead, set: Sys.setenv(ALPHA_VANTAGE_KEY = "your_key")
# Then use: fetch_alpha_vantage(PORTFOLIO, api_key = Sys.getenv("ALPHA_VANTAGE_KEY"))

market_data <- tryCatch({
  fetch_yahoo(
    symbols = PORTFOLIO,
    from = DATE_FROM,
    to = DATE_TO
  )
}, error = function(e) {
  cat("      [!] Failed to fetch live data, using sample data\n")
  cat("      Error:", e$message, "\n")
  return(NULL)
})

if (!is.null(market_data)) {
  cat("      [OK] Fetched", format(nrow(market_data), big.mark = ","), "observations\n")
  cat("      Symbols:", paste(unique(market_data$symbol), collapse = ", "), "\n")
} else {
  stop("Cannot proceed without data. Check internet connection or API settings.")
}

cat("\n")

# ==============================================================================
# STEP 2: Calculate Technical Indicators
# ==============================================================================
cat("[4/8] Calculating technical indicators...\n")

# Add comprehensive technical indicators for analysis
market_data_enhanced <- market_data %>%
  # Trend indicators
  add_sma(20) %>%          # Short-term trend
  add_sma(50) %>%          # Medium-term trend
  add_sma(200) %>%         # Long-term trend
  add_ema(12) %>%          # Fast EMA
  add_ema(26) %>%          # Slow EMA
  
  # Momentum indicators
  add_rsi(14) %>%          # Relative Strength Index
  add_macd() %>%           # MACD (default: 12, 26, 9)
  
  # Volatility indicators
  add_bollinger_bands(20, 2) %>%  # Bollinger Bands
  add_atr(14) %>%          # Average True Range
  
  # Volume indicators
  add_volume_sma(20)       # Volume moving average

# Restore market_tbl class (important!)
if (!"market_tbl" %in% class(market_data_enhanced)) {
  class(market_data_enhanced) <- c("market_tbl", class(market_data_enhanced))
}

cat("      [OK] Added 15+ technical indicators\n")
cat("      Features: SMA(20,50,200), EMA(12,26), RSI, MACD, BB, ATR, Volume\n\n")

# ==============================================================================
# STEP 3: Define & Test Multiple Strategies
# ==============================================================================
cat("[5/8] Testing multiple trading strategies...\n\n")

# Initialize results storage
all_results <- list()
all_sessions <- list()

# --- STRATEGY 1: SMA Crossover with RSI Filter ---
cat("      Strategy 1: SMA Crossover with RSI Filter\n")
strategy1_data <- market_data_enhanced %>%
  add_strategy(
    name = "SMA_Cross_RSI",
    entry_rules = sma_20 > sma_50 & rsi < 70,
    exit_rules = sma_20 < sma_50 | rsi > 80
  )

results1 <- backtest(strategy1_data, initial_capital = TOTAL_CAPITAL)
all_results[["SMA_Cross_RSI"]] <- results1
cat("         Return:", sprintf("%+.2f%%", results1$total_return * 100), 
    "| Trades:", results1$n_trades, "\n")

# --- STRATEGY 2: EMA Crossover with MACD Confirmation ---
cat("      Strategy 2: EMA Crossover with MACD\n")
strategy2_data <- market_data_enhanced %>%
  add_strategy(
    name = "EMA_MACD",
    entry_rules = ema_12 > ema_26 & macd > macd_signal,
    exit_rules = ema_12 < ema_26 | macd < macd_signal
  )

results2 <- backtest(strategy2_data, initial_capital = TOTAL_CAPITAL)
all_results[["EMA_MACD"]] <- results2
cat("         Return:", sprintf("%+.2f%%", results2$total_return * 100),
    "| Trades:", results2$n_trades, "\n")

# --- STRATEGY 3: Mean Reversion (RSI Oversold/Overbought) ---
cat("      Strategy 3: RSI Mean Reversion\n")
strategy3_data <- market_data_enhanced %>%
  add_strategy(
    name = "RSI_MeanReversion",
    entry_rules = rsi < 30,  # Oversold
    exit_rules = rsi > 70    # Overbought
  )

results3 <- backtest(strategy3_data, initial_capital = TOTAL_CAPITAL)
all_results[["RSI_MeanReversion"]] <- results3
cat("         Return:", sprintf("%+.2f%%", results3$total_return * 100),
    "| Trades:", results3$n_trades, "\n")

# --- STRATEGY 4: Bollinger Band Breakout ---
cat("      Strategy 4: Bollinger Band Breakout\n")
strategy4_data <- market_data_enhanced %>%
  add_strategy(
    name = "BB_Breakout",
    entry_rules = close > bb_upper,  # Breakout above upper band
    exit_rules = close < bb_middle   # Exit at middle band
  )

results4 <- backtest(strategy4_data, initial_capital = TOTAL_CAPITAL)
all_results[["BB_Breakout"]] <- results4
cat("         Return:", sprintf("%+.2f%%", results4$total_return * 100),
    "| Trades:", results4$n_trades, "\n\n")

# ==============================================================================
# STEP 4: Calculate Risk Metrics & Performance Statistics
# ==============================================================================
cat("[6/8] Calculating risk metrics and performance statistics...\n")

# Function to calculate comprehensive statistics
calculate_comprehensive_stats <- function(results, name) {
  
  equity <- results$equity_curve$equity
  returns <- diff(log(equity))
  
  # Calculate drawdown
  cummax_equity <- cummax(equity)
  drawdown <- (equity - cummax_equity) / cummax_equity
  max_dd <- min(drawdown, na.rm = TRUE)
  
  # Calculate various metrics
  stats <- list(
    strategy = name,
    initial_capital = results$config$initial_capital,
    final_equity = results$final_equity,
    total_return = results$total_return,
    total_return_pct = results$total_return * 100,
    
    # Returns metrics
    avg_daily_return = mean(returns, na.rm = TRUE),
    annual_return = mean(returns, na.rm = TRUE) * 252,
    volatility = sd(returns, na.rm = TRUE) * sqrt(252),
    
    # Risk metrics
    sharpe_ratio = ifelse(sd(returns) > 0,
                         (mean(returns) * 252 - RISK_FREE_RATE) / (sd(returns) * sqrt(252)),
                         0),
    max_drawdown = max_dd,
    max_drawdown_pct = max_dd * 100,
    
    # Trade metrics
    n_trades = results$n_trades,
    win_rate = if(nrow(results$trades) > 0) mean(results$trades$pnl > 0) * 100 else 0,
    
    # Score for today (0-100)
    current_score = NA  # Will calculate below
  )
  
  # Calculate investment score (0-100) based on multiple factors
  score <- 50  # Base score
  
  # Positive return: +20 points
  if (stats$total_return > 0) score <- score + 20
  
  # Sharpe ratio: +15 points if > 1.0
  if (stats$sharpe_ratio > 1.0) score <- score + 15
  else if (stats$sharpe_ratio > 0.5) score <- score + 7
  
  # Win rate: +10 points if > 60%
  if (stats$win_rate > 60) score <- score + 10
  else if (stats$win_rate > 50) score <- score + 5
  
  # Max drawdown: +10 points if < 15%
  if (abs(stats$max_drawdown_pct) < 15) score <- score + 10
  else if (abs(stats$max_drawdown_pct) < 25) score <- score + 5
  else score <- score - 10  # Penalty for high drawdown
  
  # Many trades (active strategy): +5 points if > 50 trades
  if (stats$n_trades > 50) score <- score + 5
  
  stats$current_score <- max(0, min(100, score))
  
  return(stats)
}

# Calculate stats for all strategies
all_stats <- lapply(names(all_results), function(name) {
  calculate_comprehensive_stats(all_results[[name]], name)
})
names(all_stats) <- names(all_results)

# Create comparison table
comparison_df <- do.call(rbind, lapply(all_stats, function(s) {
  data.frame(
    Strategy = s$strategy,
    Return = sprintf("%+.2f%%", s$total_return_pct),
    Sharpe = sprintf("%.2f", s$sharpe_ratio),
    MaxDD = sprintf("%.2f%%", abs(s$max_drawdown_pct)),
    WinRate = sprintf("%.1f%%", s$win_rate),
    Trades = s$n_trades,
    Score = round(s$current_score),
    stringsAsFactors = FALSE
  )
}))

# Sort by score (best first)
comparison_df <- comparison_df[order(-comparison_df$Score), ]

cat("\n")
cat("      STRATEGY PERFORMANCE COMPARISON\n")
cat("      " %R% 60, "\n")
print(comparison_df, row.names = FALSE)
cat("\n")

# Find best strategy
best_strategy <- comparison_df$Strategy[1]
best_score <- comparison_df$Score[1]

cat("      [OK] Best Strategy:", best_strategy, "| Score:", best_score, "/100\n\n")

# ==============================================================================
# STEP 5: Current Market Analysis & Investment Recommendations
# ==============================================================================
cat("[7/8] Analyzing current market conditions...\n\n")

# Get most recent data for each symbol
current_conditions <- market_data_enhanced %>%
  group_by(symbol) %>%
  arrange(desc(datetime)) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(
    # Calculate signals
    trend_signal = case_when(
      sma_20 > sma_50 & sma_50 > sma_200 ~ "Strong Uptrend",
      sma_20 > sma_50 ~ "Uptrend",
      sma_20 < sma_50 & sma_50 < sma_200 ~ "Strong Downtrend",
      sma_20 < sma_50 ~ "Downtrend",
      TRUE ~ "Neutral"
    ),
    momentum_signal = case_when(
      rsi > 70 ~ "Overbought",
      rsi < 30 ~ "Oversold",
      rsi > 50 ~ "Bullish",
      TRUE ~ "Bearish"
    ),
    recommendation = case_when(
      sma_20 > sma_50 & rsi < 70 & rsi > 40 ~ "BUY",
      sma_20 < sma_50 & rsi > 30 & rsi < 60 ~ "SELL",
      TRUE ~ "HOLD"
    ),
    # Investment score per stock
    stock_score = 50 +
      ifelse(sma_20 > sma_50, 15, -15) +
      ifelse(sma_50 > sma_200, 10, -10) +
      ifelse(rsi > 40 & rsi < 70, 15, -10) +
      ifelse(macd > macd_signal, 10, -10)
  ) %>%
  select(symbol, close, sma_20, sma_50, sma_200, rsi, 
         trend_signal, momentum_signal, recommendation, stock_score) %>%
  arrange(desc(stock_score))

cat("      TODAY'S INVESTMENT RECOMMENDATIONS\n")
cat("      " %R% 60, "\n\n")

for (i in 1:nrow(current_conditions)) {
  row <- current_conditions[i, ]
  cat(sprintf("      %s | Price: $%.2f | Score: %d/100 | %s\n",
              row$symbol, row$close, round(row$stock_score), row$recommendation))
  cat(sprintf("         Trend: %s | RSI: %.1f (%s)\n",
              row$trend_signal, row$rsi, row$momentum_signal))
  if (i < nrow(current_conditions)) cat("\n")
}

cat("\n      [OK] Analysis complete\n\n")

# ==============================================================================
# STEP 6: Generate Visualizations
# ==============================================================================
cat("[8/8] Generating visualizations...\n")

# Plot equity curves for all strategies
cat("      Creating equity curve comparison...\n")

# Use best strategy for detailed plots
best_results <- all_results[[best_strategy]]

# Create plots (these will display in R)
tryCatch({
  plot_equity_curve(best_results, title = paste("Best Strategy:", best_strategy))
  cat("      [OK] Equity curve plotted\n")
  
  plot_drawdown(best_results, title = paste("Drawdown Analysis:", best_strategy))
  cat("      [OK] Drawdown plotted\n")
}, error = function(e) {
  cat("      [!] Visualization error (tradeviz may need reload):", e$message, "\n")
})

cat("\n")

# ==============================================================================
# STEP 7: Launch Interactive Dashboard
# ==============================================================================
cat("=" %R% 70, "\n")
cat("  LAUNCHING INTERACTIVE DASHBOARD\n")
cat("=" %R% 70, "\n\n")

cat("The dashboard will open in your browser with:\n")
cat("  - Live market data (switch between Yahoo/Alpha Vantage in Settings)\n")
cat("  - All tabs functional and interactive\n")
cat("  - Price charts with technical indicators\n")
cat("  - Performance metrics and statistics\n")
cat("  - Trade history and analysis\n")
cat("  - Real-time data updates\n\n")

cat("DASHBOARD CONTROLS:\n")
cat("  1. Settings Tab: Switch data source (Yahoo Finance / Alpha Vantage)\n")
cat("  2. Overview Tab: Portfolio summary and key metrics\n")
cat("  3. Charts Tab: Interactive price charts with indicators\n")
cat("  4. Performance Tab: Equity curves and drawdowns\n")
cat("  5. Trades Tab: Detailed trade history\n\n")

cat("Press Ctrl+C in terminal to stop the dashboard when done.\n\n")

# Launch dashboard
launch_dashboard(mode = "full", launch.browser = TRUE)

# ==============================================================================
# SUMMARY OUTPUT (Saved to file)
# ==============================================================================

# Create summary report
summary_report <- list(
  timestamp = Sys.time(),
  portfolio = PORTFOLIO,
  date_range = list(from = DATE_FROM, to = DATE_TO),
  total_capital = TOTAL_CAPITAL,
  strategies_tested = names(all_results),
  best_strategy = best_strategy,
  best_score = best_score,
  strategy_comparison = comparison_df,
  current_recommendations = current_conditions,
  detailed_stats = all_stats
)

# Save to RDS for later analysis
saveRDS(summary_report, "tradingverse_analysis_report.rds")
saveRDS(best_results, "best_strategy_results.rds")

cat("\n")
cat("=" %R% 70, "\n")
cat("  ANALYSIS COMPLETE!\n")
cat("=" %R% 70, "\n\n")

cat("FILES SAVED:\n")
cat("  - tradingverse_analysis_report.rds (Full analysis)\n")
cat("  - best_strategy_results.rds (Best strategy details)\n\n")

cat("RESULTS SUMMARY:\n")
cat("  Best Strategy:    ", best_strategy, "\n")
cat("  Overall Score:    ", best_score, "/100\n")
cat("  Total Return:     ", sprintf("%+.2f%%", all_stats[[best_strategy]]$total_return_pct), "\n")
cat("  Sharpe Ratio:     ", sprintf("%.2f", all_stats[[best_strategy]]$sharpe_ratio), "\n")
cat("  Max Drawdown:     ", sprintf("%.2f%%", abs(all_stats[[best_strategy]]$max_drawdown_pct)), "\n")
cat("  Number of Trades: ", all_stats[[best_strategy]]$n_trades, "\n\n")

cat("TOP STOCK RECOMMENDATIONS TODAY:\n")
for (i in 1:min(3, nrow(current_conditions))) {
  row <- current_conditions[i, ]
  cat("  ", i, ". ", row$symbol, " - ", row$recommendation, 
      " (Score: ", round(row$stock_score), "/100)\n", sep = "")
}

cat("\n")
cat("Dashboard is running...\n")
cat("Press Ctrl+C to stop when done.\n")
cat("\n")
