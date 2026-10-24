# Prepare Victorian public transport patronage data
# Dataset: Monthly Average Patronage by Day Type and Mode

library(readr)
library(dplyr)

# Import raw data
patronage_raw <- read_csv(
  "data-raw/patronage_raw.csv",
  show_col_types = FALSE
)

# Inspect dataset structure
glimpse(patronage_raw)

# Check column names
names(patronage_raw)

# Check missing values
colSums(is.na(patronage_raw))

# Check available transport modes
unique(patronage_raw$Mode)

# Check day types
unique(patronage_raw$Day_type)

# Check reporting years
range(patronage_raw$Year, na.rm = TRUE)


# Clean and prepare patronage data
patronage <- patronage_raw |>
  dplyr::transmute(
    year = as.integer(Year),
    month = as.integer(Month),

    # Create a date representing the reporting month
    date = as.Date(
      sprintf("%04d-%02d-01", Year, Month)
    ),

    # Ensure weekdays appear in calendar order
    day_of_week = factor(
      Day_of_week,
      levels = c(
        "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
      ),
      ordered = TRUE
    ),

    day_type = Day_type,

    # Use readable labels in the Shiny app
    mode = dplyr::recode(
      Mode,
      "MetroBus" = "Metropolitan bus",
      "MetroTrain" = "Metropolitan train",
      "RegionalBus" = "Regional bus",
      "RegionalTrain" = "Regional train",
      "Tram" = "Tram"
    ),

    avg_daily_patronage = as.numeric(Pax_daily)
  ) |>
  dplyr::arrange(date, mode, day_type, day_of_week)

# Check that all observations are retained
stopifnot(nrow(patronage) == nrow(patronage_raw))

# Check missing values
colSums(is.na(patronage))

# Check for negative patronage values
sum(patronage$avg_daily_patronage < 0)

# Check for duplicate reporting combinations
patronage |>
  dplyr::count(date, day_of_week, day_type, mode) |>
  dplyr::filter(n > 1)


# Save cleaned dataset into the R package
usethis::use_data(
  patronage,
  overwrite = TRUE
)
