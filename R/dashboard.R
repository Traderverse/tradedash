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
          shiny::h2("Trading Dashboard"),
          
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
              shiny::selectInput("data_source", "Primary Data Source:",
                                choices = c("Yahoo Finance", "Alpha Vantage", "IEX Cloud", "Local")),
              shiny::passwordInput("api_key", "API Key:"),
              shiny::actionButton("test_connection", "Test Connection")
            )
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
      live_data = NULL
    )
    
    # Initialize with sample data
    shiny::observe({
      rv$portfolio_data <- generate_sample_portfolio()
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
      dates <- seq(Sys.Date() - 365, Sys.Date(), by = "day")
      equity <- 100000 * cumprod(1 + rnorm(length(dates), 0.001, 0.02))
      
      plotly::plot_ly(x = dates, y = equity, type = "scatter", mode = "lines",
                     fill = "tozeroy",
                     line = list(color = "#26a69a", width = 2)) %>%
        plotly::layout(
          title = "",
          xaxis = list(title = ""),
          yaxis = list(title = "Equity ($)"),
          hovermode = "x unified"
        )
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
      data.frame(
        Index = c("S&P 500", "NASDAQ", "DOW", "Russell 2000"),
        Value = c(4500, 14000, 35000, 1800),
        Change = c("+0.5%", "+1.2%", "+0.3%", "-0.2%"),
        Status = c("Up", "Up", "Up", "Down")
      ) %>%
        DT::datatable(options = list(pageLength = 10, dom = "t"))
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
