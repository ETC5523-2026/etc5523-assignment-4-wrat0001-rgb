#' Summarise Victorian Public Transport Patronage
#'
#' Calculate the mean of reported average daily patronage values
#' across selected transport modes, day types and reporting years.
#'
#' @param data A data frame containing patronage observations.
#'   Defaults to the bundled `patronage` dataset.
#' @param modes Character vector of transport modes to include.
#'   Defaults to all available modes.
#' @param day_types Character vector of day types to include.
#'   Defaults to all available day types.
#' @param years Numeric vector of length two specifying the
#'   inclusive reporting-year range. Defaults to all years.
#'
#' @return A tibble containing `mode`, `day_type`,
#'   `day_of_week`, `mean_daily_patronage` and `n_observations`.
#'
#' @details
#' The function first filters the data according to the selected
#' modes, day types and years. It then groups observations by
#' transport mode, day type and day of the week.
#'
#' The summary is an unweighted mean of reported average daily
#' patronage values across the selected reporting months.
#' It should not be interpreted as total monthly patronage.
#'
#' @examples
#' # Summarise all transport modes
#' summarise_daily_patronage()
#'
#' # Compare normal weekdays for metropolitan trains
#' summarise_daily_patronage(
#'   modes = "Metropolitan train",
#'   day_types = "Normal Weekday"
#' )
#'
#' # Examine tram patronage from 2022 to 2025
#' summarise_daily_patronage(
#'   modes = "Tram",
#'   years = c(2022, 2025)
#' )
#'
#' @importFrom rlang .data
#' 
#' @export
summarise_daily_patronage <- function(
    data = patronage,
    modes = NULL,
    day_types = NULL,
    years = NULL
) {

  # Filter by transport mode, if specified
  if (!is.null(modes)) {
    data <- dplyr::filter(data, .data$mode %in% modes)
  }

  # Filter by day type, if specified
  if (!is.null(day_types)) {
    data <- dplyr::filter(data, .data$day_type %in% day_types)
  }

  # Filter by reporting-year range, if specified
  if (!is.null(years)) {
    if (length(years) != 2 ||
        anyNA(years) ||
        years[1] > years[2]) {
      stop("`years` must be a valid range of two years.")
    }

    data <- dplyr::filter(
      data,
      .data$year >= years[1],
      .data$year <= years[2]
    )
  }

  # Summarise average daily patronage by group
  data |>
    dplyr::group_by(
      .data$mode,
      .data$day_type,
      .data$day_of_week
    ) |>
    dplyr::summarise(
      mean_daily_patronage = mean(
        .data$avg_daily_patronage,
        na.rm = TRUE
      ),
      n_observations = dplyr::n(),
      .groups = "drop"
    )
}
