#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' tradedash: Interactive Trading Dashboard for TradingVerse
#'
#' @description
#' A comprehensive, production-ready Shiny dashboard that unifies all TradingVerse
#' packages into a single, powerful interface. Designed for quantitative traders,
#' portfolio managers, and financial analysts who need professional-grade tools.
#'
#' @section Key Features:
#' \describe{
#'   \item{Live Market Monitoring}{Real-time price charts, market scanner, alerts}
#'   \item{Strategy Studio}{Visual strategy builder with code generation}
#'   \item{Professional Backtesting}{One-click backtesting with visual results}
#'   \item{Portfolio Management}{Real-time tracking, position management, analytics}
#'   \item{Advanced Analytics}{Interactive charts, custom dashboards, reports}
#' }
#'
#' @section Quick Start:
#' \preformatted{
#' library(tradedash)
#'
#' # Launch full dashboard
#' launch_dashboard()
#'
#' # Launch specialized dashboards
#' launch_dashboard(mode = "live")      # Live market monitor
#' launch_dashboard(mode = "backtest")  # Backtest studio
#' launch_dashboard(mode = "portfolio") # Portfolio analytics
#' }
#'
#' @section Dashboard Modes:
#' \describe{
#'   \item{Full (default)}{Complete trading workstation with all features}
#'   \item{Live}{Real-time market monitoring and alerts}
#'   \item{Backtest}{Strategy development and testing}
#'   \item{Portfolio}{Portfolio management and risk analytics}
#' }
#'
#' @section Configuration:
#' Create a YAML configuration file for customization:
#' \preformatted{
#' theme: "dark"
#' refresh_rate: 5000
#' initial_capital: 100000
#' data_sources:
#'   primary: "yahoo"
#' }
#'
#' Load with: \code{launch_dashboard(config_file = "config.yaml")}
#'
#' @section Integration:
#' tradedash integrates seamlessly with all TradingVerse packages:
#' \itemize{
#'   \item \strong{tradeengine}: Backtesting and strategy execution
#'   \item \strong{tradeio}: Data fetching and management
#'   \item \strong{tradefeatures}: Technical indicator calculation
#'   \item \strong{tradeviz}: Chart generation and visualization
#'   \item \strong{trademetrics}: Performance analytics and metrics
#' }
#'
#' @section Main Functions:
#' \describe{
#'   \item{\code{\link{launch_dashboard}}}{Launch the main trading dashboard}
#' }
#'
#' @examples
#' \dontrun{
#' # Basic launch
#' launch_dashboard()
#'
#' # Custom configuration
#' launch_dashboard(
#'   mode = "live",
#'   port = 3838,
#'   config_file = "my_config.yaml"
#' )
#'
#' # Multi-monitor setup
#' launch_dashboard(mode = "live", port = 3838)      # Monitor 1
#' launch_dashboard(mode = "portfolio", port = 3839) # Monitor 2
#' launch_dashboard(mode = "backtest", port = 3840)  # Monitor 3
#' }
#'
#' @docType package
#' @name tradedash-package
NULL

# Suppress R CMD check notes for NSE and Shiny reactive expressions
utils::globalVariables(c(
  "input", "output", "session", "rv", "observeEvent", "reactive",
  "renderPlotly", "renderDataTable", "renderValueBox", "renderText",
  "showNotification", "incProgress", "invalidateLater"
))

# Import pipe operator
#' @importFrom magrittr %>%
NULL
