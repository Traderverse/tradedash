# 🚀 TradingVerse Unified Workflow System

## The Problem We Solved

Previously, using TradingVerse required manually coordinating multiple packages:
- Fetch data with `tradeio`
- Add indicators with `tradefeatures` 
- Build strategy with `tradeengine`
- Backtest with `tradeengine`
- Visualize with `tradeviz`
- Dashboard with `tradedash`

**It worked, but lacked consolidation and visibility.**

## The Solution: `trading_session` Objects

We created a **unified workflow system** that consolidates everything into a single, verbose, organized object.

### ✨ Key Benefits

✅ **VERBOSE** - `print(session)` shows exactly what you have at every step  
✅ **ORGANIZED** - All components in one object (data, features, strategy, results)  
✅ **REPRODUCIBLE** - Session contains complete history for reproducibility  
✅ **EASY VISUALIZATION** - `plot(session)` handles all charting logic  
✅ **CLEAN SYNTAX** - Chain operations with `%>%` or build step-by-step  
✅ **DASHBOARD READY** - `dashboard(session)` launches pre-configured interface  
✅ **INSPECTABLE** - Access any component directly (`session$data`, `session$stats`)  
✅ **SAVEABLE** - Save entire session as RDS for later analysis  

---

## 📖 Complete Example

```r
library(tradeio)       # Data fetching
library(tradefeatures) # Technical indicators
library(tradeengine)   # Strategy & backtesting (includes trading_session)
library(tradeviz)      # Visualization
library(tradedash)     # Dashboard

# Create complete trading session in one pipeline
session <- fetch_yahoo("AAPL", from = "2023-01-01") %>%
  trading_session(
    name = "AAPL SMA Crossover",
    description = "Testing 20/50 SMA crossover with RSI filter"
  ) %>%
  add_features(
    sma_20 = add_sma(20),
    sma_50 = add_sma(50),
    rsi = add_rsi(14)
  ) %>%
  add_strategy(
    entry = sma_20 > sma_50 & rsi < 70,
    exit = sma_20 < sma_50 | rsi > 80,
    name = "SMA_Crossover_RSI"
  ) %>%
  run_backtest(initial_capital = 100000)

# ONE PRINT SHOWS EVERYTHING!
print(session)
```

### Output:
```
======================================================================
  TRADING SESSION: AAPL SMA Crossover
======================================================================

Description: Testing 20/50 SMA crossover with RSI filter
Created:     2025-11-01 14:30:25

---[ DATA ]------------------------------------------------------------
  Symbols:       AAPL
  Date Range:    2023-01-01 to 2025-11-01
  Observations:  1,453

---[ FEATURES ]--------------------------------------------------------
  [1] sma_20
  [2] sma_50
  [3] rsi

---[ STRATEGY ]--------------------------------------------------------
  Name:   SMA_Crossover_RSI
  Entry:  sma_20 > sma_50 & rsi < 70
  Exit:   sma_20 < sma_50 | rsi > 80

---[ BACKTEST ]--------------------------------------------------------
  Initial Capital: $100,000
  Final Equity:    $127,345
  Total Return:    +27.35%
  Sharpe Ratio:    1.84
  Max Drawdown:    -8.23%
  Trades:          42
  Win Rate:        61.9%
  Profit Factor:   2.31

======================================================================

Use summary(session) for detailed statistics
Use plot(session) for visualizations
Use dashboard(session) to launch interactive dashboard
```

---

## 🎨 Visualization Options

### Single Chart
```r
plot(session)                    # Default: equity curve
plot(session, type = "drawdown") # Drawdown analysis
plot(session, type = "returns")  # Returns distribution
plot(session, type = "trades")   # Trade markers on chart
```

### All Charts at Once
```r
plot(session, type = "all")      # Multi-panel layout
```

### Interactive Dashboard
```r
dashboard(session)               # Launch Shiny dashboard
```

---

## 📊 Detailed Statistics

```r
# Get comprehensive statistics
summary(session)

# Access specific stats
session$stats$sharpe          # Sharpe ratio
session$stats$win_rate        # Win rate %
session$stats$max_drawdown    # Max drawdown
session$stats$profit_factor   # Profit factor
```

---

## 🔍 Access Components

```r
# Access any component directly
session$data          # Market data with indicators
session$features      # List of feature functions
session$feature_names # Names of features
session$strategy      # Strategy specification
session$backtest      # Full backtest results
session$stats         # Calculated statistics

# Extract specific data
trades <- session$backtest$trades
equity_curve <- session$backtest$equity_curve
```

---

## 💾 Save & Load Sessions

```r
# Save complete session (includes everything!)
saveRDS(session, "my_strategy_20251101.rds")

# Load later for analysis/comparison
loaded_session <- readRDS("my_strategy_20251101.rds")
print(loaded_session)
plot(loaded_session)
```

---

## 🔄 Step-by-Step vs Pipeline

### Pipeline Approach (Recommended)
```r
session <- fetch_yahoo("MSFT") %>%
  trading_session(name = "Quick Test") %>%
  add_features(ema_12 = add_ema(12), ema_26 = add_ema(26)) %>%
  add_strategy(entry = ema_12 > ema_26) %>%
  run_backtest(initial_capital = 50000)

print(session)
```

### Step-by-Step Approach (More Verbose)
```r
# Step 1: Create session
data <- fetch_yahoo("MSFT", from = "2023-01-01")
session <- trading_session(data, name = "MSFT Test")
print(session)  # See initial state

# Step 2: Add features
session <- add_features(session, 
  ema_12 = add_ema(12),
  ema_26 = add_ema(26)
)
print(session)  # See features added

# Step 3: Add strategy
session <- add_strategy(session,
  entry = ema_12 > ema_26,
  exit = ema_12 < ema_26
)
print(session)  # See strategy defined

# Step 4: Run backtest
session <- run_backtest(session, initial_capital = 50000)
print(session)  # See results!
```

---

## 🎯 Multi-Symbol Sessions

```r
# Analyze portfolio of symbols
multi_session <- fetch_yahoo(c("AAPL", "MSFT", "GOOGL")) %>%
  trading_session(name = "Tech Portfolio") %>%
  add_features(sma_20 = add_sma(20), rsi = add_rsi(14)) %>%
  add_strategy(
    entry = close > sma_20 & rsi < 65,
    exit = close < sma_20 | rsi > 75
  ) %>%
  run_backtest(initial_capital = 300000)

print(multi_session)
```

---

## 📚 Complete Workflow Reference

### 1. Create Session
```r
session <- trading_session(
  data = market_tbl_object,
  name = "Strategy Name",
  description = "Optional description"
)
```

### 2. Add Features
```r
session <- add_features(session,
  feature_name = feature_function(...),
  ...
)
```

Available feature functions from `tradefeatures`:
- `add_sma(n)` - Simple Moving Average
- `add_ema(n)` - Exponential Moving Average  
- `add_rsi(n)` - Relative Strength Index
- `add_macd()` - MACD indicator
- `add_bbands(n, sd)` - Bollinger Bands
- `add_atr(n)` - Average True Range
- `add_adx(n)` - ADX indicator
- And many more...

### 3. Add Strategy
```r
session <- add_strategy(session,
  entry = logical_expression,
  exit = logical_expression,
  name = "Strategy Name",
  commission = 0.001,    # Optional
  slippage = 0.0005      # Optional
)
```

### 4. Run Backtest
```r
session <- run_backtest(session,
  initial_capital = 100000,
  method = "vectorized",   # or "event_driven"
  compound = TRUE,
  max_positions = 1
)
```

### 5. Analyze Results
```r
print(session)           # Summary
summary(session)         # Detailed stats
plot(session)            # Visualizations
dashboard(session)       # Interactive dashboard
```

---

## 🔗 Integration with Existing Code

The `trading_session` system works **alongside** traditional workflows:

```r
# Traditional approach still works
data <- fetch_yahoo("AAPL")
data <- add_sma(data, 20)
data <- add_strategy(data, entry_rules = close > sma_20)
results <- backtest(data, initial_capital = 100000)

# Convert to session for better organization
session <- trading_session(data, name = "AAPL Traditional")
session$backtest <- results
print(session)
plot(session)
```

---

## 🎓 Learning Path

1. **Start Simple** - Use UNIFIED_WORKFLOW_EXAMPLE.R
2. **Try Examples** - Run examples from `?trading_session`
3. **Build Your Own** - Create custom strategies
4. **Compare Sessions** - Save/load multiple sessions for comparison
5. **Dashboard** - Launch interactive dashboards for presentations

---

## 🤔 Why This Matters

### Before
```r
# Scattered workflow
data <- fetch_yahoo("AAPL")
data <- add_sma(data, 20)  # What columns did this create?
data <- add_rsi(data, 14)  # What's the column name?
data <- add_strategy(...)  # Did this work?
results <- backtest(...)   # What were the results?
# Print what? Plot what? How do I see everything?
```

### After
```r
# Organized workflow
session <- fetch_yahoo("AAPL") %>%
  trading_session("AAPL Test") %>%
  add_features(sma_20 = add_sma(20), rsi = add_rsi(14)) %>%
  add_strategy(...) %>%
  run_backtest(...)

print(session)  # SEE EVERYTHING!
```

---

## 📦 Package Integration

The `trading_session` system lives in **tradeengine** but integrates all packages:

- **tradeio** → Data fetching
- **tradefeatures** → Technical indicators  
- **tradeengine** → Strategy & backtesting (includes trading_session)
- **tradeviz** → Plotting (via plot.trading_session)
- **tradedash** → Dashboard (via dashboard())

**One object, all packages!**

---

## 🚀 Next Steps

1. Try the example: `/UNIFIED_WORKFLOW_EXAMPLE.R`
2. Read function docs: `?trading_session`
3. Explore methods: `?print.trading_session`, `?plot.trading_session`
4. Build your strategy!

---

## 📄 License

MIT License - Part of the TradingVerse ecosystem

---

## 🙋 Questions?

See:
- `UNIFIED_WORKFLOW_EXAMPLE.R` - Complete examples
- `?trading_session` - Function documentation  
- `START_HERE.md` - General TradingVerse guide
- GitHub Issues - Ask questions, report bugs

**Welcome to the unified TradingVerse workflow!** 🎉
