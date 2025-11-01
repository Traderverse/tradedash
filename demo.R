# Quick Demo: Launch TradeDash
# Run this script to see the dashboard in action

# Load the package
library(tradedash)

# Launch the dashboard
# This will open in your default browser at http://127.0.0.1:3838
launch_dashboard()

# ============================================================
# What you'll see:
# ============================================================

# 1. DASHBOARD TAB (Main Overview):
#    - Portfolio value, daily P&L, total return, Sharpe ratio
#    - Equity curve chart (interactive)
#    - Asset allocation pie chart
#    - Market overview table (S&P 500, NASDAQ, etc.)
#    - Top positions table (AAPL, MSFT, GOOGL, etc.)

# 2. LIVE MARKET TAB:
#    - Real-time price monitoring (simulated in v0.1)
#    - Symbol selection and refresh rate controls
#    - Interactive price charts

# 3. STRATEGY STUDIO TAB:
#    - Visual strategy builder
#    - Pre-built strategy templates (SMA, RSI, etc.)
#    - Generates R code automatically
#    - Test and save strategies

# 4. BACKTESTING TAB:
#    - Run backtests with custom parameters
#    - Performance metrics table
#    - Equity curve and drawdown visualization
#    - Compare multiple strategies

# 5. PORTFOLIO TAB:
#    - Portfolio overview
#    - Position tracking
#    - Risk analytics

# 6. PERFORMANCE TAB:
#    - Returns analysis
#    - Risk metrics
#    - Attribution analysis

# 7. DATA TAB:
#    - Import/export data
#    - Data management tools

# 8. SETTINGS TAB:
#    - Theme customization
#    - Data source configuration
#    - Notification preferences

# ============================================================
# IMPORTANT: Current Data Sources
# ============================================================

# ⚠️  v0.1.0 uses SAMPLE/SIMULATED data for demonstration
# 
# Sample data includes:
# - Synthetic price movements (geometric Brownian motion)
# - Random portfolio positions
# - Simulated P&L and metrics
#
# Live data integration coming in v0.2.0 via tradeio package:
# - Yahoo Finance ✅
# - Alpha Vantage (planned)
# - IEX Cloud (planned)
# - Broker APIs (future)

# ============================================================
# Next Steps After Launching:
# ============================================================

# 1. Explore all tabs to see available features
# 2. Try the strategy builder (Strategy Studio tab)
# 3. Run a sample backtest (Backtesting tab)
# 4. Customize settings (Settings tab)
# 5. Check DEPLOYMENT.md for deployment options

# ============================================================
# Alternative Launch Options:
# ============================================================

# Different port
# launch_dashboard(port = 3839)

# Network access (share with team)
# launch_dashboard(host = "0.0.0.0", port = 3838)

# With custom config
# launch_dashboard(config_file = "my_config.yaml")

# Don't auto-open browser
# launch_dashboard(launch.browser = FALSE)

print("🚀 Dashboard launching...")
print("📊 Navigate to http://127.0.0.1:3838 in your browser")
print("⚠️  Note: Currently using sample data for demonstration")
print("📖 See DEPLOYMENT.md for full deployment guide")
