# tradedash <img src="man/figures/logo.png" align="right" height="139" />

> **Professional Trading Dashboard for TradingVerse**  
> Real-time market monitoring • Strategy development • Backtesting • Portfolio analytics

[![R](https://img.shields.io/badge/R-%3E%3D4.1.0-blue)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Status](https://img.shields.io/badge/status-production-success)](https://github.com/Traderverse/tradedash)

**tradedash** is a production-ready Shiny dashboard that unifies all TradingVerse packages into a single, powerful interface. Designed for quantitative traders, portfolio managers, and financial analysts who need professional-grade tools.

## ✨ Key Features

### 🔴 Live Market Monitoring
- **Real-time price charts** with auto-refresh
- **Market scanner** for opportunities
- **Price alerts** and notifications
- **Multi-symbol tracking**

### 🧠 Strategy Studio
- **Visual strategy builder** (no coding required)
- **Code generation** for custom strategies
- **Strategy library** with templates
- **Parameter optimization**

### ⚗️ Professional Backtesting
- **One-click backtesting** with visual results
- **Multi-strategy comparison**
- **Walk-forward analysis**
- **Monte Carlo simulation**

### 💼 Portfolio Management
- **Real-time portfolio tracking**
- **Position management**
- **Performance attribution**
- **Risk analytics**

### 📊 Advanced Analytics
- **Interactive charts** (powered by plotly)
- **Custom dashboards**
- **Export reports** (PDF, HTML, Excel)
- **Professional themes**

## 🚀 Quick Start

### Installation

```r
# Install tradedash
devtools::install_github("tradingverse/tradedash")

# Or install from CRAN (when available)
install.packages("tradedash")
```

### Launch in 30 Seconds

```r
library(tradedash)

# Launch full dashboard
launch_dashboard()

# That's it! Dashboard opens at http://localhost:3838
```

### Specialized Dashboards

```r
# Live market monitoring only
launch_dashboard(mode = "live")

# Backtest studio only
launch_dashboard(mode = "backtest")

# Portfolio analytics only
launch_dashboard(mode = "portfolio")
```

## 📸 Screenshots

### Main Dashboard
![Dashboard](man/figures/screenshot_dashboard.png)

### Live Market Monitor
![Live Monitor](man/figures/screenshot_live.png)

### Strategy Builder
![Strategy Builder](man/figures/screenshot_strategy.png)

### Backtest Results
![Backtest](man/figures/screenshot_backtest.png)

## 📖 Documentation

### Dashboard Modes

#### Full Dashboard (Default)
Complete trading workstation with all features:
```r
launch_dashboard(mode = "full")
```

**Includes:**
- Portfolio overview
- Live market data
- Strategy development
- Backtesting engine
- Performance analytics
- Data management

#### Live Monitor
Real-time market monitoring:
```r
launch_dashboard(mode = "live")
```

**Features:**
- Multi-symbol price charts
- Volume analysis
- Technical indicators
- Price alerts
- Market scanner

#### Backtest Studio
Strategy development and testing:
```r
launch_dashboard(mode = "backtest")
```

**Features:**
- Strategy builder
- Parameter optimization
- Walk-forward testing
- Results comparison
- Performance reports

#### Portfolio Analytics
Portfolio management and risk:
```r
launch_dashboard(mode = "portfolio")
```

**Features:**
- Position tracking
- Performance attribution
- Risk metrics
- Allocation analysis
- Rebalancing tools

### Configuration

Create a YAML config file for customization:

```yaml
# my_config.yaml
theme: "dark"
refresh_rate: 5000
initial_capital: 100000

data_sources:
  primary: "yahoo"
  backup: "alpha_vantage"
  
api_keys:
  alpha_vantage: "YOUR_KEY_HERE"
  
notifications:
  trades: true
  alerts: true
  errors: true
  
chart_defaults:
  theme: "trading_dark"
  height: 600
  show_volume: true
```

Load config:
```r
launch_dashboard(config_file = "my_config.yaml")
```

### Custom Port and Host

```r
# Custom port
launch_dashboard(port = 8080)

# Access from network
launch_dashboard(host = "0.0.0.0", port = 3838)

# Don't auto-launch browser
launch_dashboard(launch.browser = FALSE)
```

## 🎯 Use Cases

### 1. Day Trading Setup
```r
library(tradedash)

# Launch live monitor on separate screen
launch_dashboard(
  mode = "live",
  port = 3838,
  config_file = "day_trading_config.yaml"
)

# Monitor multiple symbols with 1-second refresh
# Set price alerts
# Track positions in real-time
```

### 2. Strategy Development
```r
# Launch backtest studio
launch_dashboard(mode = "backtest")

# Build strategy in visual builder
# Generate R code automatically
# Run backtest with one click
# Compare multiple variations
# Export detailed report
```

### 3. Portfolio Management
```r
# Launch portfolio dashboard
launch_dashboard(mode = "portfolio")

# Import current positions
# Track daily P&L
# Analyze performance attribution
# Generate client reports
# Monitor risk metrics
```

### 4. Research Workstation
```r
# Launch full dashboard
launch_dashboard(mode = "full")

# Complete research environment:
# - Import historical data
# - Develop and test strategies
# - Analyze results
# - Build custom dashboards
# - Export findings
```

## 🔧 Integration with TradingVerse

tradedash seamlessly integrates all TradingVerse packages:

```r
library(tradedash)
library(tradeengine)  # Backtesting
library(tradeio)      # Data fetching
library(tradefeatures) # Indicators
library(tradeviz)     # Visualization
library(trademetrics) # Performance analytics

# Everything works together automatically!
launch_dashboard()
```

### Using Your Own Strategies

```r
# Define strategy in tradeengine
my_strategy <- create_strategy(
  name = "My Custom Strategy",
  entry = function(data) {
    # Your entry logic
  },
  exit = function(data, position) {
    # Your exit logic
  }
)

# Save to strategy library
save_strategy(my_strategy, "strategies/my_strategy.R")

# Launch dashboard - strategy appears in dropdown!
launch_dashboard()
```

### Custom Data Sources

```r
# Register custom data fetcher
register_data_source("my_source", function(symbol, from, to) {
  # Your data fetching logic
  # Return data in standard format
})

# Use in dashboard
launch_dashboard(config_file = "config_with_custom_source.yaml")
```

## 📊 Dashboard Components

### Value Boxes
- Portfolio value
- Today's P&L
- Total return
- Sharpe ratio
- Max drawdown
- Win rate

### Charts
- **Equity curves** (line, area, candlestick)
- **Drawdown charts** (underwater plots)
- **Returns distribution** (histograms, QQ plots)
- **Correlation heatmaps**
- **Rolling metrics** (Sharpe, volatility)
- **Allocation charts** (pie, treemap, sankey)

### Tables
- **Positions** (current holdings)
- **Trades** (trade log with P&L)
- **Performance metrics** (all key statistics)
- **Market overview** (indices, sectors)

### Interactive Features
- **Zoom and pan** on all charts
- **Hover tooltips** with details
- **Click to drill down**
- **Export charts** (PNG, SVG)
- **Save layouts**

## 🎨 Customization

### Themes

```r
# Available themes
themes <- c(
  "dark",      # Professional dark theme (default)
  "light",     # Clean light theme
  "minimal",   # Minimalist design
  "bloomberg", # Bloomberg-style
  "trading_view" # TradingView-style
)
```

Set in config:
```yaml
theme: "dark"
chart_theme: "trading_dark"
```

### Custom CSS

Add custom styling:
```yaml
custom_css: "path/to/custom.css"
```

### Layout Customization

Modify dashboard layout:
```r
# Create custom layout
my_layout <- create_dashboard_layout(
  sections = c("portfolio", "charts", "metrics"),
  arrangement = "vertical"
)

launch_dashboard(layout = my_layout)
```

## 🔔 Notifications

### Price Alerts
```r
# Set in dashboard UI or via code
set_price_alert(
  symbol = "AAPL",
  condition = "above",
  price = 200,
  notification = "email"  # or "push", "sound"
)
```

### Trade Notifications
Automatic notifications for:
- Trade executions
- Stop loss hits
- Take profit hits
- Strategy signals

### System Alerts
- Data fetch failures
- Connection issues
- Strategy errors

## 📤 Export & Reporting

### Export Charts
- **Format**: PNG, SVG, PDF
- **Resolution**: Configurable DPI
- **Size**: Custom dimensions

### Generate Reports
```r
# From dashboard or programmatically
export_dashboard_report(
  format = "html",  # or "pdf", "markdown"
  sections = c("portfolio", "performance", "risk"),
  filename = "monthly_report.html"
)
```

### Data Export
- **Formats**: CSV, Excel, JSON, RDS
- **Tables**: Positions, trades, metrics
- **Time series**: Price data, equity curves

## 🚦 Performance

### Optimizations
- **Lazy loading** of data
- **Caching** for frequently accessed data
- **Efficient rendering** with plotly
- **Background processing** for heavy computations

### Resource Usage
- **Memory**: ~100-200 MB (depends on data)
- **CPU**: Low (except during backtests)
- **Network**: Minimal (only for data fetches)

### Recommended Specs
- **RAM**: 4 GB minimum, 8 GB recommended
- **CPU**: 2+ cores
- **Screen**: 1920x1080 minimum

## 🐛 Troubleshooting

### Dashboard Won't Launch
```r
# Check dependencies
check_dashboard_dependencies()

# Update packages
update_tradingverse()

# Clear cache
clear_dashboard_cache()
```

### Slow Performance
```r
# Reduce refresh rate
launch_dashboard(config_file = "low_refresh_config.yaml")

# Limit data points
# Disable auto-refresh for unused charts
# Clear old data
```

### Data Fetch Issues
```r
# Test data source
test_data_connection("yahoo")

# Switch to backup source
set_data_source("alpha_vantage")

# Check API keys
verify_api_keys()
```

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup
```r
# Clone repo
git clone https://github.com/Traderverse/tradedash.git
cd tradedash

# Install dependencies
renv::restore()

# Run tests
devtools::test()

# Run dashboard in dev mode
run_dev_dashboard()
```

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

## 🔗 Links

- **TradingVerse**: [https://github.com/Traderverse](https://github.com/Traderverse)
- **Documentation**: [https://tradingverse.github.io/tradedash](https://tradingverse.github.io/tradedash)
- **Issues**: [https://github.com/Traderverse/tradedash/issues](https://github.com/Traderverse/tradedash/issues)
- **Discussions**: [https://github.com/Traderverse/tradedash/discussions](https://github.com/Traderverse/tradedash/discussions)

## 🙏 Acknowledgments

Built with:
- [Shiny](https://shiny.rstudio.com/) - Web framework
- [shinydashboard](https://rstudio.github.io/shinydashboard/) - Dashboard layout
- [plotly](https://plotly.com/r/) - Interactive charts
- [DT](https://rstudio.github.io/DT/) - Interactive tables

## 📧 Support

- **Email**: support@tradingverse.com
- **Discord**: [Join our community](https://discord.gg/tradingverse)
- **Twitter**: [@TradingVerse](https://twitter.com/tradingverse)

---

<p align="center">
  <strong>Built with ❤️ by the TradingVerse team</strong>
</p>

<p align="center">
  <sub>Making quantitative trading accessible to everyone</sub>
</p>
