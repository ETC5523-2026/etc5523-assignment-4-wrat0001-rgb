# Victorian Public Transport Patronage

Monthly average daily public transport patronage in Victoria, Australia,
categorised by transport mode, day of the week, day type and reporting
month.

## Usage

``` r
patronage
```

## Format

A data frame with 4,450 rows and 7 variables:

|  |  |  |
|----|----|----|
| **Variable** | **Type** | **Description** |
| `year` | Integer | Reporting year, from 2018 to 2026. |
| `month` | Integer | Reporting month, from 1 (January) to 12 (December). |
| `date` | Date | First day of the reporting month, used to identify the month. |
| `day_of_week` | Ordered factor | Day of the week, ordered from Monday to Sunday. |
| `day_type` | Character | Day classification: Normal Weekday, School Holiday Weekday or Weekend. |
| `mode` | Character | Public transport mode: Metropolitan bus, Metropolitan train, Regional bus, Regional train or Tram. |
| `avg_daily_patronage` | Numeric | Reported average daily public transport patronage for the corresponding month, mode, day and day type. |

## Source

Victorian Government open transport data, *Monthly Average Patronage by
Day Type and By Mode*.

Dataset:
<https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode>

Data resource:
<https://opendata.transport.vic.gov.au/dataset/monthly-average-patronage-by-day-type-and-by-mode/resource/c2f1279b-c414-4371-a12e-e1cc5836ee1a>

## Details

Each observation represents a reporting combination of month, day of the
week, day type and transport mode.

The dataset covers January 2018 to March 2026. The final reporting year
is therefore incomplete.

The dataset contains reported average daily patronage values, not
monthly patronage totals. Values should not be summed across reporting
categories to estimate monthly totals.

## Examples

``` r
# Load the bundled dataset
data("patronage", package = "victransport")

# View the first observations
head(patronage)
#> # A tibble: 6 × 7
#>    year month date       day_of_week day_type          mode  avg_daily_patronage
#>   <int> <int> <date>     <ord>       <chr>             <chr>               <dbl>
#> 1  2018     1 2018-01-01 Monday      Normal Weekday    Metr…              308450
#> 2  2018     1 2018-01-01 Tuesday     Normal Weekday    Metr…              359800
#> 3  2018     1 2018-01-01 Wednesday   Normal Weekday    Metr…              400250
#> 4  2018     1 2018-01-01 Monday      School Holiday W… Metr…              298500
#> 5  2018     1 2018-01-01 Tuesday     School Holiday W… Metr…              295500
#> 6  2018     1 2018-01-01 Wednesday   School Holiday W… Metr…              299950

# Examine available transport modes
unique(patronage$mode)
#> [1] "Metropolitan bus"   "Metropolitan train" "Regional bus"      
#> [4] "Regional train"     "Tram"              

# Check the reporting period
range(patronage$date)
#> [1] "2018-01-01" "2026-03-01"
```
