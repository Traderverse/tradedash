# Example Launch Scripts for tradedash

# Basic launch
library(tradedash)
launch_dashboard()

# ==========================================
# Specialized Dashboard Configurations
# ==========================================

# Live Market Monitor - Day Trading Setup
launch_dashboard(
  mode = "live",
  port = 3838,
  host = "127.0.0.1",
  launch.browser = TRUE
)

# Backtest Studio - Strategy Development
launch_dashboard(
  mode = "backtest",
  port = 3839,
  host = "127.0.0.1"
)

# Portfolio Analytics - Portfolio Management
launch_dashboard(
  mode = "portfolio",
  port = 3840,
  host = "127.0.0.1"
)

# ==========================================
# Multi-Monitor Trading Station Setup
# ==========================================

# Monitor 1: Live prices and alerts
launch_dashboard(mode = "live", port = 3838)

# Monitor 2: Portfolio tracking
# Run this in separate R session
launch_dashboard(mode = "portfolio", port = 3839)

# Monitor 3: Analysis and backtesting
# Run this in separate R session
launch_dashboard(mode = "backtest", port = 3840)

# ==========================================
# Network Access (Share with Team)
# ==========================================

# Allow access from local network
launch_dashboard(
  host = "0.0.0.0",  # Listen on all interfaces
  port = 3838
)

# Access from other computers:
# http://YOUR_COMPUTER_IP:3838

# ==========================================
# Custom Configuration File
# ==========================================

# Create config.yaml with custom settings
launch_dashboard(config_file = "my_trading_config.yaml")

# ==========================================
# Advanced: Programmatic Control
# ==========================================

# Create app but don't launch (for customization)
app <- launch_dashboard(launch.browser = FALSE)

# Customize app...
# Then launch manually
shiny::runApp(app, port = 3838)
