# Summarise Victorian Public Transport Patronage

Calculate the mean of reported average daily patronage values across
selected transport modes, day types and reporting years.

## Usage

``` r
summarise_daily_patronage(
  data = NULL,
  modes = NULL,
  day_types = NULL,
  years = NULL
)
```

## Arguments

- data:

  A data frame containing patronage observations. Defaults to the
  bundled `patronage` dataset.

- modes:

  Character vector of transport modes to include. `NULL` (default)
  includes all available modes.

- day_types:

  Character vector of day types to include. `NULL` (default) includes
  all available day types.

- years:

  Numeric vector of length two specifying the inclusive reporting-year
  range. `NULL` (default) includes all available years.

## Value

A tibble containing `mode`, `day_type`, `day_of_week`,
`mean_daily_patronage` and `n_observations`.

## Details

The function first filters the data according to the selected modes, day
types and years. It then groups observations by transport mode, day type
and day of the week.

The summary is an unweighted mean of reported average daily patronage
values across the selected reporting months. It should not be
interpreted as total monthly patronage.

## Examples

``` r
# Summarise all transport modes
summarise_daily_patronage()
#> # A tibble: 60 × 5
#>    mode             day_type     day_of_week mean_daily_patronage n_observations
#>    <chr>            <chr>        <ord>                      <dbl>          <int>
#>  1 Metropolitan bus Normal Week… Monday                   329452.             93
#>  2 Metropolitan bus Normal Week… Tuesday                  350910.             93
#>  3 Metropolitan bus Normal Week… Wednesday                354643.             96
#>  4 Metropolitan bus Normal Week… Thursday                 355585.             95
#>  5 Metropolitan bus Normal Week… Friday                   334818.             94
#>  6 Metropolitan bus School Holi… Monday                   261829.             45
#>  7 Metropolitan bus School Holi… Tuesday                  275412.             46
#>  8 Metropolitan bus School Holi… Wednesday                281623.             46
#>  9 Metropolitan bus School Holi… Thursday                 282570.             46
#> 10 Metropolitan bus School Holi… Friday                   259965.             42
#> # ℹ 50 more rows

# Compare normal weekdays for metropolitan trains
summarise_daily_patronage(
  modes = "Metropolitan train",
  day_types = "Normal Weekday"
)
#> # A tibble: 5 × 5
#>   mode               day_type    day_of_week mean_daily_patronage n_observations
#>   <chr>              <chr>       <ord>                      <dbl>          <int>
#> 1 Metropolitan train Normal Wee… Monday                   495766.             93
#> 2 Metropolitan train Normal Wee… Tuesday                  556234.             93
#> 3 Metropolitan train Normal Wee… Wednesday                563695.             96
#> 4 Metropolitan train Normal Wee… Thursday                 569149.             95
#> 5 Metropolitan train Normal Wee… Friday                   538652.             94

# Examine tram patronage from 2022 to 2025
summarise_daily_patronage(
  modes = "Tram",
  years = c(2022, 2025)
)
#> # A tibble: 12 × 5
#>    mode  day_type               day_of_week mean_daily_patronage n_observations
#>    <chr> <chr>                  <ord>                      <dbl>          <int>
#>  1 Tram  Normal Weekday         Monday                   406063.             46
#>  2 Tram  Normal Weekday         Tuesday                  459423.             46
#>  3 Tram  Normal Weekday         Wednesday                469487.             46
#>  4 Tram  Normal Weekday         Thursday                 473853.             45
#>  5 Tram  Normal Weekday         Friday                   457550              45
#>  6 Tram  School Holiday Weekday Monday                   380608.             20
#>  7 Tram  School Holiday Weekday Tuesday                  411586.             21
#>  8 Tram  School Holiday Weekday Wednesday                420976.             23
#>  9 Tram  School Holiday Weekday Thursday                 438432.             22
#> 10 Tram  School Holiday Weekday Friday                   416708.             20
#> 11 Tram  Weekend                Saturday                 379051.             47
#> 12 Tram  Weekend                Sunday                   276671.             47
```
