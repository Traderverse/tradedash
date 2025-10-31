# Quick Start Guide - tradedash

Get up and running with tradedash in 5 minutes!

## Installation (30 seconds)

```r
# Install from GitHub
devtools::install_github("tradingverse/tradedash")

# Load library
library(tradedash)
```

## Launch Dashboard (10 seconds)

```r
# One command - that's it!
launch_dashboard()
```

Your browser will open automatically at `http://localhost:3838`

## First Steps (2 minutes)

### 1. Explore the Interface

**Left Sidebar** - Navigate between sections:
- 📊 Dashboard - Overview of everything
- 📈 Live Market - Real-time prices
- 🧠 Strategy Studio - Build strategies
- ⚗️ Backtesting - Test strategies
- 💼 Portfolio - Track positions
- 📉 Performance - Analyze results
- 💾 Data - Import/export
- ⚙️ Settings - Configure dashboard

### 2. View Sample Data

The dashboard loads with sample data automatically. You'll see:
- Portfolio value: $1,234,567
- Today's P&L: +$12,345
- Equity curve chart
- Asset allocation pie chart
- Top positions table

### 3. Try Live Charts

1. Click **Live Market** → **Price Monitor**
2. Select symbols: AAPL, MSFT, GOOGL
3. Adjust refresh rate: 5 seconds
4. Watch live updates!

### 4. Run a Quick Backtest

1. Click **Backtesting** → **Run Backtest**
2. Select strategy: "SMA Crossover"
3. Select symbol: AAPL
4. Set date range: Last year
5. Click "Run Backtest"
6. View results in seconds!

### 5. Build a Strategy

1. Click **Strategy Studio** → **Builder**
2. Enter strategy name
3. Choose strategy type: "Moving Average"
4. Set parameters: Fast=20, Slow=50
5. See generated R code
6. Click "Save Strategy"

## Next Steps (2 minutes)

### Connect Real Data

```r
# Set up Yahoo Finance (free, no API key needed)
launch_dashboard()  # Yahoo is default

# Or use Alpha Vantage
launch_dashboard(config_file = "config_alpha_vantage.yaml")
```

**config_alpha_vantage.yaml:**
```yaml
data_sources:
  primary: "alpha_vantage"
  
api_keys:
  alpha_vantage: "YOUR_KEY_HERE"
```

### Customize Appearance

Go to **Settings** in the dashboard:
- Change theme: Dark / Light
- Adjust refresh rates
- Enable/disable notifications
- Set data sources

### Import Your Strategies

```r
# Save your tradeengine strategies
library(tradeengine)

my_strategy <- create_strategy(
  name = "My Strategy",
  entry = function(data) {
    # Your logic
  }
)

# Save to library
save_strategy(my_strategy, "strategies/my_strategy.R")

# Reload dashboard - it appears automatically!
```

## Specialized Dashboards

### Day Trading Setup

```r
# Launch live monitor only
launch_dashboard(mode = "live")
```

**Features:**
- Real-time prices
- Multiple symbols
- Fast refresh (1-60 seconds)
- Price alerts
- Volume analysis

### Research Setup

```r
# Launch full dashboard
launch_dashboard(mode = "full")
```

**Features:**
- Complete toolkit
- Data import/export
- Strategy development
- Backtesting
- Performance analysis

### Portfolio Monitoring

```r
# Launch portfolio dashboard
launch_dashboard(mode = "portfolio")
```

**Features:**
- Position tracking
- P&L monitoring
- Performance metrics
- Risk analytics
- Allocation analysis

## Common Tasks

### View Different Symbols

1. Go to Live Market
2. Use symbol selector dropdown
3. Select multiple symbols
4. Charts update automatically

### Compare Strategies

1. Go to Backtesting → Comparison
2. Select 2+ strategies
3. Run backtests
4. View side-by-side results

### Export a Report

1. Go to Performance
2. View metrics and charts
3. Click "Export Report" (top right)
4. Choose format: HTML, PDF, or Excel
5. Download file

### Set Price Alerts

1. Go to Live Market → Alerts
2. Click "New Alert"
3. Enter symbol, condition, price
4. Choose notification method
5. Save alert

## Tips & Tricks

### Keyboard Shortcuts
- `Ctrl+L` - Go to Live Market
- `Ctrl+B` - Run Backtest
- `Ctrl+S` - Save current layout
- `Ctrl+R` - Refresh all data
- `F11` - Fullscreen mode

### Multi-Monitor Setup

```r
# Monitor 1: Live prices
launch_dashboard(mode = "live", port = 3838)

# Monitor 2: Portfolio
launch_dashboard(mode = "portfolio", port = 3839)

# Monitor 3: Charts/analysis
launch_dashboard(mode = "backtest", port = 3840)
```

### Performance Optimization

- **Reduce refresh rate** for charts you don't actively watch
- **Limit data points** to last 6 months for faster loading
- **Close unused tabs** to save resources
- **Enable caching** in Settings → Advanced

### Backup Your Work

```r
# Save dashboard state
save_dashboard_state("backups/state_2025_10_31.rds")

# Load dashboard state
load_dashboard_state("backups/state_2025_10_31.rds")
```

## Troubleshooting

### Dashboard won't open?
```r
# Check if port is available
check_port(3838)

# Try different port
launch_dashboard(port = 8080)
```

### Slow performance?
- Reduce refresh rate in Settings
- Clear cache: Settings → Advanced → Clear Cache
- Limit symbols being tracked

### Data not loading?
```r
# Test data source
test_data_connection("yahoo")

# Check internet connection
# Verify API keys in Settings
```

### Charts not displaying?
- Ensure plotly is installed: `install.packages("plotly")`
- Clear browser cache
- Try different browser

## Get Help

- **Documentation**: Full docs at [tradingverse.github.io/tradedash](https://tradingverse.github.io/tradedash)
- **Examples**: See `examples/` folder in package
- **Issues**: Report bugs on [GitHub Issues](https://github.com/Traderverse/tradedash/issues)
- **Community**: Join our [Discord](https://discord.gg/tradingverse)

## What's Next?

Now that you're up and running:

1. ✅ **Import your own data** - Use tradeio to fetch historical data
2. ✅ **Create custom strategies** - Use Strategy Studio to build
3. ✅ **Run backtests** - Test your ideas
4. ✅ **Analyze results** - Use Performance tools
5. ✅ **Go live** - Connect to your broker (future feature)

**Welcome to TradingVerse! Happy trading! 🚀**
