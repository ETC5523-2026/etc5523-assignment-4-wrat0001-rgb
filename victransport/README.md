# victransport

<!-- badges: start -->
<!-- badges: end -->

## Overview

`victransport` is an R package that provides an interactive Shiny application for exploring public transport patronage patterns in Victoria, Australia.

The application is designed for Victorian public transport users and anyone interested in understanding how public transport usage varies across transport modes, days of the week, day types and reporting periods.

It addresses the question:

**How does average daily public transport patronage differ across transport modes, days of the week and day types in Victoria, and how has patronage changed between 2018 and 2026?**

Users can explore these patterns through interactive visualisations, summary statistics and dynamically generated key findings.

## Data

The package uses the Victorian Government's *Monthly Average Patronage by Day Type and By Mode* dataset.

The dataset contains monthly observations of average daily public transport patronage, categorised by:

- **Transport mode:** Metropolitan train, metropolitan bus, tram, regional train and regional bus.
- **Day of the week:** Monday to Sunday.
- **Day type:** Normal weekday, school holiday weekday and weekend.
- **Reporting period:** January 2018 to March 2026.

The original measure, `Pax_daily`, represents reported average daily passenger patronage for each recorded category. In the package, this variable is named `avg_daily_patronage`.

**Data source:** Victorian Government, [Monthly Average Patronage by Day Type and By Mode](https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode).

The original data were obtained from the [official data resource](https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode/resource/c2f1279b-c414-4371-a12e-e1cc5836ee1a).

**Important:** The app calculates unweighted means of reported daily averages for the selected observations. These figures should not be interpreted as total monthly passenger journeys or combined network-wide daily patronage. Reporting coverage may also differ between years, particularly for 2026, which includes data only through March.

## Installation

You can install the development version of `victransport` from GitHub using the `remotes` package:

```r
# Install remotes if needed
install.packages("remotes")

# Install victransport from GitHub
remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-wrat0001-rgb",
  subdir = "victransport"
)
```

The `subdir` argument is required because the R package is located inside the `victransport` folder of the assignment repository.

## Launching the Shiny app

After installation, load the package and launch the interactive application:

```r
library(victransport)

run_transport_app()
```

## Using the app

The Victorian Public Transport Explorer allows users to investigate patronage patterns using four interactive filters:

- **Transport mode:** Select one or more metropolitan or regional transport modes.
- **Day type:** Include or exclude normal weekdays, school holiday weekdays and weekends.
- **Reporting years:** Select a range of years between 2018 and 2026.
- **Reporting months:** Select a calendar-month range that applies to every selected year. For example, selecting May–December includes those months in each year where observations are available.

The charts, summary figures and key findings update automatically when filters change.

### Summary statistics

The app displays two summary cards:

- **Mean reported daily patronage:** The unweighted mean of the selected reported daily averages, with an expandable breakdown by transport mode.
- **Reporting months:** The number of distinct reporting months represented in the filtered data, with an expandable summary of the selected reporting period.

### Interactive visualisations

The app provides three interactive charts:

1. **Trend over time:** A line chart showing how mean reported daily patronage changes across reporting months for different day types.
2. **Day-of-week comparison:** A grouped bar chart comparing patronage across days of the week, including normal weekdays, school holiday weekdays and weekends.
3. **Compare transport modes:** A horizontal bar chart comparing mean reported daily patronage across selected transport modes.

Users can hover over the charts to view values and explore how the patterns change with different filters.

Each chart also includes **dynamic key findings** that summarise relevant comparisons for the selected data.

### Interpreting the results

The visualisations describe patterns in the reported daily averages rather than total public transport usage across Victoria.

Comparisons between years should be interpreted carefully because the available reporting months may differ. In particular, 2026 contains only January–March observations.

## Documentation

A package documentation website will be published using `pkgdown`. It will include reference pages for exported functions and the `patronage` dataset, along with a vignette demonstrating how to use and interpret the package.

**Documentation website:** To be added after publication.

## AI-use declaration

ChatGPT (OpenAI) was used to assist with interpreting the assignment requirements, planning the R package structure, drafting and refining documentation, and developing and troubleshooting R and Shiny code. This included assistance with reactive filtering, interactive visualisations, dynamic summaries and explanations of the data.

AI-generated suggestions were reviewed and adapted during development. The author remains responsible for verifying the code, interpreting the data and ensuring the final submission meets the assignment requirements.

AI conversation record: [ChatGPT conversation](https://chatgpt.com/share/6ae93dfa-c9b4-83ec-8c0b-6deb345fc1ce).