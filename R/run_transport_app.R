
#' Launch the Victorian Public Transport Explorer
#'
#' Launches the interactive Shiny application included
#' in the `victransport` package.
#'
#' The application allows users to explore average daily
#' public transport patronage in Victoria by filtering
#' transport modes, day types, reporting years and months.
#' Interactive charts and key findings update automatically
#' when the selected filters change.
#'
#' @return Invisibly returns the Shiny application result.
#'
#' @examples
#' \dontrun{
#' run_transport_app()
#' }
#'
#' @export
run_transport_app <- function() {

  # Locate the Shiny app in the installed package
  app_dir <- system.file(
    "app",
    package = "victransport"
  )

  # Check that the application directory exists
  if (app_dir == "") {
    stop("Shiny application files could not be found.")
  }

  # Launch the Shiny application
  shiny::runApp(app_dir)
}
