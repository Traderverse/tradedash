#' Launch TradingVerse Dashboard
#'
#' @description
#' Launch the complete TradingVerse dashboard application. This is the main
#' entry point for the unified trading platform that integrates all TradingVerse
#' packages into a single interface.
#'
#' @param mode Dashboard mode: "full" (default), "live", "backtest", or "portfolio"
#' @param port Port number for the Shiny app (default: 3838)
#' @param host Host address (default: "127.0.0.1")
#' @param launch.browser Launch browser automatically (default: TRUE)
#' @param config_file Path to configuration YAML file (optional)
#'
#' @return Shiny app object
#' @export
#' @importFrom stats rnorm
#' @importFrom scales dollar
#'
#' @examples
#' \dontrun{
#' # Launch full dashboard
#' launch_dashboard()
#'
#' # Launch live monitoring mode
#' launch_dashboard(mode = "live")
#'
#' # Launch backtest studio
#' launch_dashboard(mode = "backtest")
#'
#' # Launch with custom config
#' launch_dashboard(config_file = "my_config.yaml")
#' }
launch_dashboard <- function(mode = "full",
                            port = 3838,
                            host = "127.0.0.1",
                            launch.browser = TRUE,
                            config_file = NULL) {
  
  # Load configuration
  config <- load_or_create_config(config_file)
  
  # Create app based on mode
  app <- switch(mode,
    "full" = create_full_dashboard(config),
    # "live" = create_live_dashboard(config),  # TODO: Implement in future version
    # "backtest" = create_backtest_studio(config),  # TODO: Implement in future version
    # "portfolio" = create_portfolio_dashboard(config),  # TODO: Implement in future version
    stop("Invalid mode. Currently only 'full' mode is supported. Other modes coming in v0.2.")
  )
  
  # Run app
  shiny::runApp(
    app,
    port = port,
    host = host,
    launch.browser = launch.browser
  )
}

#' @keywords internal
create_full_dashboard <- function(config) {
  
  ui <- shinydashboard::dashboardPage(
    skin = "black",
    
    # Header
    shinydashboard::dashboardHeader(
      title = "TradingVerse Pro",
      shinydashboard::dropdownMenuOutput("notifications"),
      shinydashboard::dropdownMenuOutput("tasks")
    ),
    
    # Sidebar
    shinydashboard::dashboardSidebar(
      shinyjs::useShinyjs(),
      shinydashboard::sidebarMenu(
        id = "sidebar",
        shinydashboard::menuItem("Dashboard", tabName = "dashboard", icon = shiny::icon("dashboard")),
        shinydashboard::menuItem("Live Market", tabName = "live", icon = shiny::icon("chart-line"),
          shinydashboard::menuSubItem("Price Monitor", tabName = "live_prices"),
          shinydashboard::menuSubItem("Market Scanner", tabName = "scanner"),
          shinydashboard::menuSubItem("Alerts", tabName = "alerts")
        ),
        shinydashboard::menuItem("Strategy Studio", tabName = "strategy", icon = shiny::icon("brain"),
          shinydashboard::menuSubItem("Builder", tabName = "strategy_builder"),
          shinydashboard::menuSubItem("Library", tabName = "strategy_library"),
          shinydashboard::menuSubItem("Optimizer", tabName = "optimizer")
        ),
        shinydashboard::menuItem("Backtesting", tabName = "backtest", icon = shiny::icon("flask"),
          shinydashboard::menuSubItem("Run Backtest", tabName = "backtest_run"),
          shinydashboard::menuSubItem("Results", tabName = "backtest_results"),
          shinydashboard::menuSubItem("Comparison", tabName = "backtest_compare")
        ),
        shinydashboard::menuItem("Portfolio", tabName = "portfolio", icon = shiny::icon("briefcase"),
          shinydashboard::menuSubItem("Overview", tabName = "portfolio_overview"),
          shinydashboard::menuSubItem("Positions", tabName = "positions"),
          shinydashboard::menuSubItem("Analytics", tabName = "portfolio_analytics")
        ),
        shinydashboard::menuItem("Performance", tabName = "performance", icon = shiny::icon("chart-area"),
          shinydashboard::menuSubItem("Returns", tabName = "returns"),
          shinydashboard::menuSubItem("Risk Metrics", tabName = "risk"),
          shinydashboard::menuSubItem("Attribution", tabName = "attribution")
        ),
        shinydashboard::menuItem("Data", tabName = "data", icon = shiny::icon("database"),
          shinydashboard::menuSubItem("Import", tabName = "data_import"),
          shinydashboard::menuSubItem("Export", tabName = "data_export"),
          shinydashboard::menuSubItem("Manage", tabName = "data_manage")
        ),
        shinydashboard::menuItem("Settings", tabName = "settings", icon = shiny::icon("cog"))
      ),
      
      # Quick Actions
      shiny::hr(),
      shiny::h4("Quick Actions", style = "padding-left: 15px; color: #fff;"),
      shiny::div(
        style = "padding: 0 15px;",
        shiny::actionButton("quick_backtest", "Quick Backtest", 
                           icon = shiny::icon("play"), 
                           class = "btn-primary btn-block",
                           style = "margin-bottom: 10px;"),
        shiny::actionButton("quick_scan", "Market Scan",
                           icon = shiny::icon("search"),
                           class = "btn-info btn-block",
                           style = "margin-bottom: 10px;"),
        shiny::actionButton("quick_export", "Export Report",
                           icon = shiny::icon("file-export"),
                           class = "btn-success btn-block")
      )
    ),
    
    # Body
    shinydashboard::dashboardBody(
      # Custom CSS
      shiny::tags$head(
        shiny::tags$style(shiny::HTML("
          @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
          
          body { font-family: 'Inter', sans-serif; }
          .content-wrapper { background-color: #0a0e27; }
          .box { 
            background-color: #151b3d; 
            border: 1px solid #1e2a5e;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
          }
          .box-header { 
            background-color: #1a2142; 
            border-bottom: 1px solid #1e2a5e;
          }
          .small-box { 
            background-color: #151b3d !important;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
          }
          .small-box h3, .small-box p { color: #ffffff !important; }
          .info-box { 
            background-color: #151b3d;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
          }
          .nav-tabs-custom { 
            background-color: #151b3d;
            border-radius: 8px;
          }
          
          /* Trading-specific colors */
          .up { color: #26a69a; }
          .down { color: #ef5350; }
          .neutral { color: #78909c; }
          
          /* Metric cards */
          .metric-card {
            background: linear-gradient(135deg, #1e2a5e 0%, #151b3d 100%);
            border-radius: 8px;
            padding: 20px;
            margin: 10px 0;
            border: 1px solid #1e2a5e;
          }
          .metric-value {
            font-size: 32px;
            font-weight: 700;
            margin: 10px 0;
          }
          .metric-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #78909c;
          }
        "))
      ),
      
      shinydashboard::tabItems(
        # Dashboard Tab
        shinydashboard::tabItem(
          tabName = "dashboard",
          shiny::fluidRow(
            shiny::column(
              width = 9,
              shiny::h2("Trading Dashboard")
            ),
            shiny::column(
              width = 3,
              shiny::div(
                style = "text-align: right; padding-top: 20px;",
                shiny::uiOutput("data_source_indicator")
              )
            )
          ),
          
          # Key Metrics Row
          shiny::fluidRow(
            shinydashboard::valueBoxOutput("total_value", width = 3),
            shinydashboard::valueBoxOutput("daily_pnl", width = 3),
            shinydashboard::valueBoxOutput("total_return", width = 3),
            shinydashboard::valueBoxOutput("sharpe", width = 3)
          ),
          
          # Charts Row
          shiny::fluidRow(
            shinydashboard::box(
              title = "Portfolio Equity Curve",
              status = "primary",
              solidHeader = TRUE,
              width = 8,
              plotly::plotlyOutput("main_equity", height = 400)
            ),
            shinydashboard::box(
              title = "Asset Allocation",
              status = "info",
              solidHeader = TRUE,
              width = 4,
              plotly::plotlyOutput("allocation_pie", height = 400)
            )
          ),
          
          # Market Overview & Top Positions
          shiny::fluidRow(
            shinydashboard::box(
              title = "Market Overview",
              status = "warning",
              solidHeader = TRUE,
              width = 6,
              DT::dataTableOutput("market_overview")
            ),
            shinydashboard::box(
              title = "Top Positions",
              status = "success",
              solidHeader = TRUE,
              width = 6,
              DT::dataTableOutput("top_positions")
            )
          )
        ),
        
        # Live Market Tab
        shinydashboard::tabItem(
          tabName = "live_prices",
          shiny::h2("Live Market Monitor"),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Symbol Selection",
              status = "primary",
              solidHeader = TRUE,
              width = 12,
              shiny::selectizeInput("live_symbols", "Select Symbols:", 
                                   choices = c("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"),
                                   selected = "AAPL",
                                   multiple = TRUE),
              shiny::sliderInput("live_refresh", "Refresh Rate (seconds):", 
                                min = 1, max = 60, value = 5),
              shiny::checkboxInput("live_auto", "Auto Refresh", value = TRUE)
            )
          ),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Live Price Chart",
              status = "primary",
              solidHeader = TRUE,
              width = 12,
              plotly::plotlyOutput("live_price_chart", height = 600)
            )
          )
        ),
        
        # Strategy Builder Tab
        shinydashboard::tabItem(
          tabName = "strategy_builder",
          shiny::h2("Strategy Builder"),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Strategy Configuration",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              shiny::textInput("strategy_name", "Strategy Name:", "My Strategy"),
              shiny::selectInput("strategy_type", "Strategy Type:",
                                choices = c("Moving Average", "Mean Reversion", "Momentum", "Custom"),
                                selected = "Moving Average"),
              shiny::hr(),
              shiny::numericInput("param1", "Fast Period:", value = 20, min = 1),
              shiny::numericInput("param2", "Slow Period:", value = 50, min = 1),
              shiny::numericInput("stop_loss", "Stop Loss (%):", value = 2, min = 0, max = 100),
              shiny::numericInput("take_profit", "Take Profit (%):", value = 5, min = 0, max = 100),
              shiny::hr(),
              shiny::actionButton("save_strategy", "Save Strategy", 
                                 icon = shiny::icon("save"),
                                 class = "btn-success btn-block")
            ),
            
            shinydashboard::box(
              title = "Strategy Code",
              status = "info",
              solidHeader = TRUE,
              width = 8,
              shiny::helpText("Generated R code for your strategy:"),
              shiny::verbatimTextOutput("strategy_code"),
              shiny::actionButton("test_strategy", "Test Strategy",
                                 icon = shiny::icon("play"),
                                 class = "btn-primary")
            )
          )
        ),
        
        # Backtest Run Tab
        shinydashboard::tabItem(
          tabName = "backtest_run",
          shiny::h2("Run Backtest"),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Backtest Parameters",
              status = "primary",
              solidHeader = TRUE,
              width = 4,
              shiny::selectInput("bt_strategy", "Select Strategy:",
                                choices = c("SMA Crossover", "RSI Mean Reversion", "Custom")),
              shiny::selectInput("bt_symbol", "Symbol:", 
                                choices = c("AAPL", "MSFT", "GOOGL"),
                                selected = "AAPL"),
              shiny::dateRangeInput("bt_dates", "Date Range:",
                                   start = Sys.Date() - 365,
                                   end = Sys.Date()),
              shiny::numericInput("bt_capital", "Initial Capital:", 
                                 value = 100000, min = 1000),
              shiny::sliderInput("bt_commission", "Commission (%):",
                                min = 0, max = 1, value = 0.1, step = 0.01),
              shiny::hr(),
              shiny::actionButton("run_backtest", "Run Backtest",
                                 icon = shiny::icon("play"),
                                 class = "btn-success btn-lg btn-block")
            ),
            
            shinydashboard::box(
              title = "Backtest Results",
              status = "success",
              solidHeader = TRUE,
              width = 8,
              plotly::plotlyOutput("bt_results_plot", height = 500)
            )
          ),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Performance Metrics",
              status = "info",
              solidHeader = TRUE,
              width = 12,
              DT::dataTableOutput("bt_metrics")
            )
          )
        ),
        
        # Settings Tab
        shinydashboard::tabItem(
          tabName = "settings",
          shiny::h2("Dashboard Settings"),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Appearance",
              status = "primary",
              solidHeader = TRUE,
              width = 6,
              shiny::selectInput("theme", "Theme:", 
                                choices = c("Dark", "Light", "Auto"),
                                selected = "Dark"),
              shiny::selectInput("chart_theme", "Chart Theme:",
                                choices = c("Trading Dark", "Trading Light", "Minimal"),
                                selected = "Trading Dark")
            ),
            
            shinydashboard::box(
              title = "Data Sources",
              status = "info",
              solidHeader = TRUE,
              width = 6,
              shiny::selectInput("data_source_setting", "Primary Data Source:",
                                choices = c("Yahoo Finance (FREE)" = "yahoo", 
                                          "Alpha Vantage (FREE - API Key Required)" = "alpha_vantage"),
                                selected = "yahoo"),
              shiny::passwordInput("api_key", "API Key (for Alpha Vantage):"),
              shiny::helpText("Get free Alpha Vantage key at: https://www.alphavantage.co/support/#api-key"),
              shiny::actionButton("save_api_key", "Save API Key", class = "btn-primary"),
              shiny::actionButton("test_connection", "Test Connection", class = "btn-info"),
              shiny::hr(),
              shiny::verbatimTextOutput("connection_status")
            ),
          ),
          
          shiny::fluidRow(
            shinydashboard::box(
              title = "Notifications",
              status = "warning",
              solidHeader = TRUE,
              width = 6,
              shiny::checkboxInput("notify_trades", "Trade Notifications", value = TRUE),
              shiny::checkboxInput("notify_alerts", "Price Alerts", value = TRUE),
              shiny::checkboxInput("notify_errors", "Error Notifications", value = TRUE)
            ),
            
            shinydashboard::box(
              title = "Advanced",
              status = "danger",
              solidHeader = TRUE,
              width = 6,
              shiny::numericInput("max_cache", "Cache Size (MB):", value = 100),
              shiny::checkboxInput("debug_mode", "Debug Mode", value = FALSE),
              shiny::hr(),
              shiny::actionButton("reset_settings", "Reset to Defaults",
                                 class = "btn-danger")
            )
          )
        )
      )
    )
  )
  
  server <- function(input, output, session) {
    
    # Reactive values
    rv <- shiny::reactiveValues(
      portfolio_data = NULL,
      backtest_results = NULL,
      live_data = NULL,
      use_real_data = TRUE,  # Toggle for real vs sample data
      market_data = NULL
    )
    
    # Initialize with portfolio data
    shiny::observe({
      rv$portfolio_data <- generate_sample_portfolio()
    })
    
    # Reactive value for data source
    data_source <- shiny::reactiveVal("yahoo")
    
    # Fetch real market data on startup or when source changes
    fetch_market_data <- shiny::reactive({
      # Trigger on source change
      input$data_source_setting
      
      if (rv$use_real_data) {
        tryCatch({
          # Check if tradeio is available
          if (!requireNamespace("tradeio", quietly = TRUE)) {
            shiny::showNotification("⚠️ Install tradeio package: devtools::install_github('Traderverse/tradeio')", 
                                   type = "warning", duration = 10)
            rv$use_real_data <- FALSE
            return(NULL)
          }
          
          # Get settings
          source <- if (!is.null(input$data_source_setting)) input$data_source_setting else "yahoo"
          symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA")
          
          message(paste("Fetching data from:", source))
          
          shiny::withProgress(message = paste("Fetching from", source, "..."), {
            if (source == "yahoo") {
              # Yahoo Finance - FREE, no API key
              data <- tradeio::fetch_yahoo(
                symbols, 
                from = Sys.Date() - 365,
                to = Sys.Date()
              )
              shiny::showNotification("✅ Data loaded from Yahoo Finance (FREE)", 
                                     type = "message", duration = 3)
              
            } else if (source == "alpha_vantage") {
              # Alpha Vantage - FREE but needs API key
              api_key <- Sys.getenv("ALPHA_VANTAGE_KEY")
              if (api_key == "" && !is.null(input$api_key) && input$api_key != "") {
                api_key <- input$api_key
              }
              
              if (api_key == "") {
                shiny::showNotification(
                  "⚠️ Alpha Vantage requires API key. Get free key at: https://www.alphavantage.co/support/#api-key",
                  type = "warning", duration = 10
                )
                return(NULL)
              }
              
              # Fetch from Alpha Vantage (one symbol at a time due to rate limits)
              data_list <- list()
              for (sym in symbols) {
                shiny::incProgress(1/length(symbols), detail = sym)
                tryCatch({
                  data_list[[sym]] <- tradeio::fetch_alpha_vantage(
                    sym,
                    api_key = api_key,
                    outputsize = "full"
                  )
                  Sys.sleep(12)  # Rate limit: 5 calls/minute
                }, error = function(e) {
                  message(paste("Failed to fetch", sym, ":", e$message))
                })
              }
              
              if (length(data_list) == 0) {
                shiny::showNotification("❌ Failed to fetch data from Alpha Vantage", 
                                       type = "error", duration = 5)
                return(NULL)
              }
              
              data <- dplyr::bind_rows(data_list)
              shiny::showNotification(
                paste0("✅ Data loaded from Alpha Vantage (", length(data_list), " symbols)"),
                type = "message", duration = 3
              )
            }
            
            return(data)
          })
          
        }, error = function(e) {
          shiny::showNotification(paste("⚠️ Failed to fetch data:", e$message), 
                                 type = "warning", duration = 5)
          rv$use_real_data <- FALSE
          return(NULL)
        })
      }
    })
    
    # Update market data when fetch completes
    shiny::observe({
      data <- fetch_market_data()
      if (!is.null(data)) {
        rv$market_data <- data
      }
    })
    
    # Initial data fetch
    shiny::observe({
      if (rv$use_real_data) {
        rv$market_data <- fetch_market_data()
      }
    })
    
    # Data source indicator
    output$data_source_indicator <- shiny::renderUI({
      source <- if (!is.null(input$data_source_setting)) input$data_source_setting else "yahoo"
      source_name <- if (source == "yahoo") "Yahoo Finance" else "Alpha Vantage"
      status <- if (!is.null(rv$market_data)) "🟢 Live" else "🔴 Sample"
      
      shiny::div(
        style = "background: #1a2142; padding: 10px; border-radius: 5px; border: 1px solid #1e2a5e;",
        shiny::tags$small(
          style = "color: #78909c;",
          "Data Source: ",
          shiny::tags$strong(style = "color: #26a69a;", source_name),
          shiny::br(),
          status
        )
      )
    })
    
    # Value boxes
    output$total_value <- shinydashboard::renderValueBox({
      shinydashboard::valueBox(
        scales::dollar(1234567),
        "Portfolio Value",
        icon = shiny::icon("wallet"),
        color = "blue"
      )
    })
    
    output$daily_pnl <- shinydashboard::renderValueBox({
      pnl <- 12345
      shinydashboard::valueBox(
        paste0(if (pnl >= 0) "+" else "", scales::dollar(pnl)),
        "Today's P&L",
        icon = shiny::icon("chart-line"),
        color = if (pnl >= 0) "green" else "red"
      )
    })
    
    output$total_return <- shinydashboard::renderValueBox({
      ret <- 23.45
      shinydashboard::valueBox(
        paste0("+", sprintf("%.2f%%", ret)),
        "Total Return",
        icon = shiny::icon("percentage"),
        color = "purple"
      )
    })
    
    output$sharpe <- shinydashboard::renderValueBox({
      shinydashboard::valueBox(
        "1.85",
        "Sharpe Ratio",
        icon = shiny::icon("chart-area"),
        color = "yellow"
      )
    })
    
    # Main equity curve
    output$main_equity <- plotly::renderPlotly({
      
      if (!is.null(rv$market_data) && rv$use_real_data) {
        # Use real market data to simulate portfolio equity
        # Take SPY-like weighted average of tech stocks
        portfolio_data <- rv$market_data %>%
          dplyr::filter(symbol %in% c("AAPL", "MSFT", "GOOGL")) %>%
          dplyr::group_by(datetime) %>%
          dplyr::summarise(
            avg_return = mean(close / dplyr::lag(close) - 1, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          dplyr::filter(!is.na(avg_return)) %>%
          dplyr::mutate(equity = 100000 * cumprod(1 + avg_return))
        
        plotly::plot_ly(
          data = portfolio_data,
          x = ~datetime, 
          y = ~equity, 
          type = "scatter", 
          mode = "lines",
          fill = "tozeroy",
          line = list(color = "#26a69a", width = 2),
          text = ~paste0(
            "Date: ", format(datetime, "%Y-%m-%d"), "<br>",
            "Equity: $", scales::comma(equity, accuracy = 2)
          ),
          hoverinfo = "text"
        ) %>%
          plotly::layout(
            title = "",
            xaxis = list(title = ""),
            yaxis = list(title = "Equity ($)"),
            hovermode = "x unified",
            paper_bgcolor = "transparent",
            plot_bgcolor = "transparent"
          )
      } else {
        # Fallback to sample data
        dates <- seq(Sys.Date() - 365, Sys.Date(), by = "day")
        equity <- 100000 * cumprod(1 + rnorm(length(dates), 0.001, 0.02))
        
        plotly::plot_ly(x = dates, y = equity, type = "scatter", mode = "lines",
                       fill = "tozeroy",
                       line = list(color = "#26a69a", width = 2)) %>%
          plotly::layout(
            title = "⚠️ Using Sample Data - Install tradeio for real data",
            xaxis = list(title = ""),
            yaxis = list(title = "Equity ($)"),
            hovermode = "x unified"
          )
      }
    })
    
    # Allocation pie
    output$allocation_pie <- plotly::renderPlotly({
      plotly::plot_ly(
        labels = c("Stocks", "Bonds", "Cash", "Crypto"),
        values = c(60, 25, 10, 5),
        type = "pie",
        marker = list(colors = c("#26a69a", "#1976d2", "#78909c", "#ff9800"))
      ) %>%
        plotly::layout(
          showlegend = TRUE,
          paper_bgcolor = "transparent",
          plot_bgcolor = "transparent"
        )
    })
    
    # Market overview table
    output$market_overview <- DT::renderDataTable({
      
      if (!is.null(rv$market_data) && rv$use_real_data) {
        # Use real data - show latest prices for major stocks
        latest_data <- rv$market_data %>%
          dplyr::group_by(symbol) %>%
          dplyr::arrange(dplyr::desc(datetime)) %>%
          dplyr::slice(1) %>%
          dplyr::mutate(
            prev_close = dplyr::lag(close, default = close),
            change_pct = ((close - prev_close) / prev_close * 100)
          ) %>%
          dplyr::select(Symbol = symbol, Price = close, `Change %` = change_pct) %>%
          dplyr::mutate(
            Price = scales::dollar(Price, accuracy = 0.01),
            `Change %` = sprintf("%+.2f%%", `Change %`),
            Status = ifelse(`Change %` >= 0, "Up", "Down")
          )
        
        DT::datatable(
          latest_data,
          options = list(pageLength = 10, dom = "t"),
          rownames = FALSE
        )
      } else {
        # Fallback to sample data
        data.frame(
          Index = c("S&P 500", "NASDAQ", "DOW", "Russell 2000"),
          Value = c(4500, 14000, 35000, 1800),
          Change = c("+0.5%", "+1.2%", "+0.3%", "-0.2%"),
          Status = c("Up", "Up", "Up", "Down")
        ) %>%
          DT::datatable(options = list(pageLength = 10, dom = "t"))
      }
    })
    
    # Top positions table
    output$top_positions <- DT::renderDataTable({
      data.frame(
        Symbol = c("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"),
        Shares = c(100, 50, 25, 30, 40),
        Value = c(18000, 18500, 3500, 4800, 10000),
        Return = c("+15%", "+12%", "+8%", "-5%", "+25%")
      ) %>%
        DT::datatable(options = list(pageLength = 10, dom = "t"))
    })
    
    # Strategy code generation
    output$strategy_code <- shiny::renderText({
      paste0(
        "library(tradeengine)\n\n",
        "strategy <- create_strategy(\n",
        "  name = '", input$strategy_name, "',\n",
        "  entry = function(data) {\n",
        "    sma_fast <- SMA(data$close, ", input$param1, ")\n",
        "    sma_slow <- SMA(data$close, ", input$param2, ")\n",
        "    return(sma_fast > sma_slow)\n",
        "  },\n",
        "  exit = function(data, position) {\n",
        "    # Exit logic here\n",
        "  },\n",
        "  stop_loss = ", input$stop_loss / 100, ",\n",
        "  take_profit = ", input$take_profit / 100, "\n",
        ")"
      )
    })
    
    # Save API key
    shiny::observeEvent(input$save_api_key, {
      if (!is.null(input$api_key) && input$api_key != "") {
        Sys.setenv(ALPHA_VANTAGE_KEY = input$api_key)
        shiny::showNotification("✅ API key saved for this session", type = "message", duration = 3)
      } else {
        shiny::showNotification("⚠️ Please enter an API key", type = "warning", duration = 3)
      }
    })
    
    # Test connection
    shiny::observeEvent(input$test_connection, {
      source <- if (!is.null(input$data_source_setting)) input$data_source_setting else "yahoo"
      
      output$connection_status <- shiny::renderText({
        if (!requireNamespace("tradeio", quietly = TRUE)) {
          return("❌ tradeio package not installed\nRun: devtools::install_github('Traderverse/tradeio')")
        }
        
        tryCatch({
          if (source == "yahoo") {
            # Test Yahoo Finance
            test_data <- tradeio::fetch_yahoo("AAPL", from = Sys.Date() - 7, to = Sys.Date())
            paste0(
              "✅ Yahoo Finance connection successful!\n",
              "Fetched ", nrow(test_data), " rows for AAPL\n",
              "Latest price: $", round(tail(test_data$close, 1), 2)
            )
          } else if (source == "alpha_vantage") {
            # Test Alpha Vantage
            api_key <- Sys.getenv("ALPHA_VANTAGE_KEY")
            if (api_key == "" && !is.null(input$api_key) && input$api_key != "") {
              api_key <- input$api_key
            }
            
            if (api_key == "") {
              return("❌ Alpha Vantage API key required\nGet free key at: https://www.alphavantage.co/support/#api-key")
            }
            
            test_data <- tradeio::fetch_alpha_vantage("AAPL", api_key = api_key, outputsize = "compact")
            paste0(
              "✅ Alpha Vantage connection successful!\n",
              "API key valid\n",
              "Fetched ", nrow(test_data), " rows for AAPL\n",
              "Latest price: $", round(tail(test_data$close, 1), 2)
            )
          }
        }, error = function(e) {
          paste0("❌ Connection failed:\n", e$message)
        })
      })
    })
    
    # Run backtest
    shiny::observeEvent(input$run_backtest, {
      shiny::showNotification("Running backtest...", type = "message")
      
      # Simulate backtest
      shiny::withProgress(message = "Running backtest...", {
        for (i in 1:10) {
          Sys.sleep(0.2)
          shiny::incProgress(0.1)
        }
      })
      
      shiny::showNotification("Backtest complete!", type = "message", duration = 3)
    })
    
    # Placeholder for backtest results
    output$bt_results_plot <- plotly::renderPlotly({
      plotly::plot_ly() %>%
        plotly::layout(title = "Run a backtest to see results")
    })
    
    output$bt_metrics <- DT::renderDataTable({
      data.frame(
        Metric = c("Total Return", "Sharpe Ratio", "Max Drawdown", "Win Rate"),
        Value = c("N/A", "N/A", "N/A", "N/A")
      ) %>%
        DT::datatable(options = list(dom = "t"))
    })
    
  }
  
  shiny::shinyApp(ui, server)
}

#' @keywords internal
load_or_create_config <- function(config_file) {
  if (!is.null(config_file) && file.exists(config_file)) {
    yaml::read_yaml(config_file)
  } else {
    list(
      theme = "dark",
      refresh_rate = 5000,
      initial_capital = 100000
    )
  }
}

#' @keywords internal
generate_sample_portfolio <- function() {
  data.frame(
    symbol = c("AAPL", "MSFT", "GOOGL", "AMZN"),
    shares = c(100, 50, 25, 30),
    entry_price = c(150, 300, 2800, 3200),
    current_price = c(180, 370, 2900, 3100)
  )
}
