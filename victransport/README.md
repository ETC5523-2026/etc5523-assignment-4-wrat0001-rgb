
# victransport

<!-- badges: start -->
<!-- badges: end -->

## Overview
victransport is an R package that provides an interactive Shiny application for exploring public transport patronage patterns in Victoria, Australia.

The application is designed for Victorian public transport users and anyone interested in understanding how public transport usage varies across different travel conditions.

It addresses the question:

How does average daily public transport patronage vary across transport modes, days of the week and day types, and how have these patterns changed over time?

Users will be able to explore and compare patronage patterns using interactive visualisations and summary statistics.

## Data
The package uses the Victorian Government's Monthly Average Patronage by Day Type and Mode dataset.

The dataset contains monthly observations of average daily public transport patronage, categorised by:

- **Transport mode:** Metropolitan train, metropolitan bus, tram, regional train and regional bus.
- **Day of the week:** Monday to Sunday.
- **Day type:** Normal weekday, school holiday weekday and weekend.
- **Reporting period:** January 2018 to March 2026.

The main measure is `Pax_daily`, representing reported average daily passenger patronage for each recorded category.

**Data source:** Victorian Government,
[Monthly Average Patronage by Day Type and By Mode](https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode).

The original data were obtained from the
[official data resource](https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode/resource/c2f1279b-c414-4371-a12e-e1cc5836ee1a).

**Important:** The data represent average daily patronage within reporting categories, rather than total monthly boardings or individual passenger journeys.

## Installation

You can install the development version of victransport from [GitHub](https://github.com/) with:

``` r
# Install pak if needed
install.packages("pak")

# Install victransport from GitHub
pak::pak("ETC5523-2026/etc5523-assignment-4-wrat0001-rgb/victransport")
```
Alternatively, using remotes:

``` r
install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-wrat0001-rgb",
  subdir = "victransport"
)
```

## Launching the Shiny app
Once the package is installed, the interactive application will be launched using:

``` r
library(victransport)

run_transport_app()
```

The application is currently under development. These instructions will be verified once the launch function is implemented.

## Using the app
The application is being designed to let users:

- Select a public transport mode.
- Explore different days of the week and day types.
- Filter observations by reporting period.
- Compare patronage patterns using interactive charts and summary statistics.

The visualisations will help users investigate how public transport use differs between normal weekdays, school holidays and weekends, and how these patterns have changed over time.

## Documentation
A package documentation website will be published using pkgdown. It will include reference pages for the exported functions and dataset, along with a vignette explaining how to install and use the application.

Documentation website URL to be added after publication.

## AI-use declaration
ChatGPT (OpenAI) was used to assist with planning the package structure, interpreting the assignment requirements, drafting package documentation and suggesting R code.

All AI-assisted material will be reviewed, tested and revised by the author before submission. The final declaration will be updated to reflect the specific assistance received throughout development.

## Example

After installing the package, load `victransport` and launch the
interactive Shiny application:

```r
library(victransport)

run_transport_app()
```

The app allows users to explore average daily public transport
patronage in Victoria by selecting transport modes, day types,
and reporting periods.

Users can examine changes in patronage over time and compare
travel patterns across different days of the week.

