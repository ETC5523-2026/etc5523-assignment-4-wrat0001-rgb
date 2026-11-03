## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(victransport)

## ----installation, eval=FALSE-------------------------------------------------
# install.packages("remotes")
# 
# remotes::install_github(
#   "ETC5523-2026/etc5523-assignment-4-wrat0001-rgb"
# )

## ----load-package, eval=FALSE-------------------------------------------------
# library(victransport)

## ----explore-data-------------------------------------------------------------
data("patronage", package = "victransport")

head(patronage)

## ----data-coverage------------------------------------------------------------
range(patronage$date)

unique(patronage$mode)

unique(patronage$day_type)

## ----overall-summary----------------------------------------------------------
patronage_summary <- summarise_daily_patronage()

head(patronage_summary)

## ----mode-comparison----------------------------------------------------------
mode_summary <- summarise_daily_patronage(
  modes = c("Metropolitan train", "Tram")
)

head(mode_summary)

## ----weekday-summary----------------------------------------------------------
weekday_summary <- summarise_daily_patronage(
  day_types = "Normal Weekday"
)

head(weekday_summary)

## ----year-comparison----------------------------------------------------------
recent_summary <- summarise_daily_patronage(
  years = c(2022, 2025)
)

head(recent_summary)

## ----combined-filters---------------------------------------------------------
selected_summary <- summarise_daily_patronage(
  modes = "Metropolitan train",
  day_types = "Normal Weekday",
  years = c(2022, 2025)
)

head(selected_summary)

## ----launch-app, eval=FALSE---------------------------------------------------
# library(victransport)
# run_transport_app()

