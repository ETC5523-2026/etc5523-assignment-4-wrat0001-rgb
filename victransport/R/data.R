#' Victorian Public Transport Patronage
#'
#' Monthly average daily public transport patronage in Victoria,
#' Australia, categorised by transport mode, day of the week,
#' day type and reporting month.
#'
#' @format A data frame with 4,450 rows and 7 variables:
#' 
#' | **Variable** | **Type** | **Description** |
#' |:----------|:------|:-------------|
#' | `year` | Integer | Reporting year, from 2018 to 2026. |
#' | `month` | Integer | Reporting month, from 1 (January) to 12 (December). |
#' | `date` | Date | First day of the reporting month, used to identify the month. |
#' | `day_of_week` | Ordered factor | Day of the week, ordered from Monday to Sunday. |
#' | `day_type` | Character | Day classification: Normal Weekday, School Holiday Weekday or Weekend. |
#' | `mode` | Character | Public transport mode: Metropolitan bus, Metropolitan train, Regional bus, Regional train or Tram. |
#' | `avg_daily_patronage` | Numeric | Reported average daily public transport patronage for the corresponding month, mode, day and day type. |
#'
#' @details
#' Each observation represents a reporting combination of month,
#' day of the week, day type and transport mode.
#' 
#' The dataset contains reported average daily patronage values,
#' not monthly patronage totals. Values should not be summed
#' across reporting categories to estimate monthly totals.
#'
#' @source Victorian Government open transport data, *Monthly Average Patronage by
#'   Day Type and By Mode*.
#' 
#' Dataset:
#' \url{https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode}
#' 
#' Data resource:
#' \url{https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode/resource/c2f1279b-c414-4371-a12e-e1cc5836ee1a}
#'
#' @examples
#' # Load the bundled dataset
#' data("patronage", package = "victransport")
#'
#' # View the first observations
#' head(patronage)
#'
#' # Examine available transport modes
#' unique(patronage$mode)
#'
#' # Check the reporting period
#' range(patronage$date)
#' 
"patronage"