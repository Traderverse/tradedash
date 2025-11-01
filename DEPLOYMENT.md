# TradeDash Deployment Guide

## Quick Start - Local Deployment

### 1. Install the Package

```r
# Install from GitHub
devtools::install_github("Traderverse/tradedash")

# Or install locally if you have the source
devtools::install()
```

### 2. Launch the Dashboard

```r
library(tradedash)
launch_dashboard()
```

That's it! The dashboard will open in your default browser at `http://127.0.0.1:3838`

---

## Current Data Sources

**⚠️ IMPORTANT: The current version (v0.1.0) uses SAMPLE DATA for demonstration.**

### What's Currently Implemented:

1. **Sample Portfolio Data** - Generated on startup with:
   - AAPL, MSFT, GOOGL, AMZN positions
   - Synthetic prices and returns
   - Random P&L and performance metrics

2. **Simulated Market Data** - Using R's random number generators:
   - Geometric Brownian motion for price simulation
   - Normal distribution for returns
   - Poisson distribution for volume

### Live Data Integration (Coming Soon):

The dashboard is designed to integrate with `tradeio` for real data:

```r
# Future implementation (v0.2+)
library(tradeio)

# Fetch real data
data <- fetch_yahoo("AAPL", from = "2024-01-01")

# Display in dashboard
launch_dashboard(data_source = "yahoo", symbols = c("AAPL", "MSFT", "GOOGL"))
```

**Current data sources being integrated:**
- ✅ Yahoo Finance (via `tradeio`)
- 🔄 Alpha Vantage (planned)
- 🔄 IEX Cloud (planned)
- 🔄 Local CSV/Database (planned)

---

## Deployment Options

### Option 1: Local Desktop (Current - Works Now)

**Best for:** Personal use, development, testing

```r
library(tradedash)
launch_dashboard()
```

- Runs on `localhost:3838`
- Only accessible from your computer
- No special setup required

### Option 2: Local Network (Requires Network Config)

**Best for:** Sharing with team on same network

```r
launch_dashboard(
  host = "0.0.0.0",  # Listen on all network interfaces
  port = 3838
)
```

Then access from any computer on your network:
```
http://YOUR_COMPUTER_IP:3838
```

To find your IP:
- **macOS/Linux:** `ifconfig | grep "inet "`
- **Windows:** `ipconfig`

### Option 3: Shiny Server (Production Deployment)

**Best for:** Always-on access, multiple users, professional deployment

#### Install Shiny Server:

```bash
# Ubuntu/Debian
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb
sudo gdebi shiny-server-1.5.20.1002-amd64.deb

# macOS (via Docker)
docker run -p 3838:3838 rocker/shiny
```

#### Deploy the App:

```bash
# Copy app to Shiny Server directory
sudo cp -R /path/to/tradedash /srv/shiny-server/tradedash

# Access at: http://your-server:3838/tradedash
```

### Option 4: ShinyApps.io (Cloud Hosting)

**Best for:** Easy cloud deployment, no server management

```r
# Install rsconnect
install.packages("rsconnect")

# Configure account (first time only)
rsconnect::setAccountInfo(
  name = "your-account",
  token = "your-token",
  secret = "your-secret"
)

# Deploy
library(rsconnect)
deployApp(appDir = "path/to/tradedash")
```

Visit: `https://your-account.shinyapps.io/tradedash`

**Pricing:**
- Free tier: 5 apps, 25 active hours/month
- Starter: $9/mo
- Basic: $39/mo
- Standard: $99/mo

### Option 5: Docker Container

**Best for:** Reproducible deployment, cloud platforms

Create `Dockerfile`:

```dockerfile
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('devtools', 'shiny', 'shinydashboard', 'plotly', 'DT'))"
RUN R -e "devtools::install_github('Traderverse/tradedash')"

# Copy app
COPY app.R /srv/shiny-server/
COPY config.yaml /srv/shiny-server/

# Expose port
EXPOSE 3838

# Run
CMD ["/init"]
```

Build and run:

```bash
docker build -t tradedash .
docker run -p 3838:3838 tradedash
```

### Option 6: AWS/Azure/GCP Cloud

**Best for:** Enterprise deployment, scalability

- **AWS:** EC2 + Shiny Server or ECS with Docker
- **Azure:** VM + Shiny Server or Container Instances
- **GCP:** Compute Engine + Shiny Server or Cloud Run

---

## Configuration

### Custom Config File

Create `config.yaml`:

```yaml
# Dashboard appearance
theme: "dark"
chart_theme: "trading_dark"

# Data settings
data_source: "yahoo"
symbols: ["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"]
refresh_rate: 5000  # milliseconds

# Trading parameters
initial_capital: 100000
commission: 0.001  # 0.1%
slippage: 0.0005   # 0.05%

# API keys (optional)
alpha_vantage_key: "your-key-here"
iex_cloud_key: "your-key-here"

# Notifications
enable_notifications: true
notification_methods: ["browser", "email"]
alert_email: "your@email.com"
```

Use it:

```r
launch_dashboard(config_file = "config.yaml")
```

---

## Security Considerations

### For Network/Cloud Deployment:

1. **Authentication** - Add user login (requires Shiny Server Pro or custom auth)
2. **HTTPS** - Use SSL certificates for encrypted connections
3. **API Keys** - Store securely in environment variables or secrets manager
4. **Firewall** - Restrict port access to known IPs
5. **Rate Limiting** - Prevent API abuse

### Example: Environment Variables for API Keys

```r
# In R
Sys.setenv(ALPHA_VANTAGE_KEY = "your-key")
Sys.setenv(IEX_CLOUD_KEY = "your-key")

# Access in app
api_key <- Sys.getenv("ALPHA_VANTAGE_KEY")
```

---

## Performance Optimization

### For Live Data Streaming:

1. **Use Caching** - Cache frequently requested data
2. **Batch Updates** - Update multiple symbols at once
3. **WebSockets** - For real-time data (future feature)
4. **Database Backend** - Store historical data locally

### Example with Caching:

```r
library(memoise)

# Cache fetch function
fetch_cached <- memoise(
  fetch_yahoo,
  cache = cachem::cache_disk("~/.tradedash/cache")
)

# Use cached version
data <- fetch_cached("AAPL")
```

---

## Monitoring & Maintenance

### Check Dashboard Status:

```bash
# If using Shiny Server
sudo systemctl status shiny-server

# View logs
sudo tail -f /var/log/shiny-server.log
```

### Restart:

```bash
sudo systemctl restart shiny-server
```

---

## Troubleshooting

### Port Already in Use:

```r
# Use different port
launch_dashboard(port = 3839)
```

### Can't Access from Other Computers:

1. Check firewall settings
2. Ensure host is set to `"0.0.0.0"`
3. Verify IP address with `ifconfig` or `ipconfig`

### Dashboard Not Loading:

1. Check R console for errors
2. Verify all dependencies installed
3. Check Shiny Server logs

### Sample Data Not Updating:

This is expected in v0.1.0. Real-time data coming in v0.2.

---

## Next Steps

1. **Try it locally:** `launch_dashboard()`
2. **Explore features:** Navigate through all tabs
3. **Customize:** Edit config.yaml for your preferences
4. **Integrate real data:** Wait for v0.2 or contribute to `tradeio` integration
5. **Deploy:** Choose deployment option based on your needs

---

## Getting Help

- **Issues:** https://github.com/Traderverse/tradedash/issues
- **Discussions:** https://github.com/Traderverse/tradedash/discussions
- **Documentation:** https://traderverse.github.io/tradedash/

---

## Roadmap

### v0.2.0 (Coming Soon):
- ✅ Live data integration with `tradeio`
- ✅ Real-time price updates
- ✅ Custom strategy builder (visual interface)
- ✅ Advanced backtesting with walk-forward analysis

### v0.3.0 (Planned):
- 🔄 Multi-strategy portfolio optimization
- 🔄 Machine learning strategy templates
- 🔄 Paper trading integration
- 🔄 Broker API connections (Interactive Brokers, etc.)

### v1.0.0 (Future):
- 🔄 Production-ready live trading
- 🔄 Risk management system
- 🔄 Order execution and monitoring
- 🔄 Full backtesting suite with transaction costs
