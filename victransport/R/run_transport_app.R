#' Launch the Victorian Public Transport Explorer
#'
#' Launches the interactive Shiny application included
#' in the victransport package.
#'
#' @return Invisibly returns the Shiny application result.
#' @export
run_transport_app <- function() {

  app_dir <- system.file(
    "app",
    package = "victransport"
  )

  if (app_dir == "") {
    stop("Shiny application files could not be found.")
  }

  shiny::runApp(app_dir)
}