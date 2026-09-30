# ============================================================
# Session 04 - Lag plots, autocorrelation, white noise
#
# Companion to the notebooks in this folder:
#   04_C_TSGraphs_Graphs_Lagplots_Autocorrelation
#   04_D_TSGraphs_MoreExercises
# The notebooks carry the explanations. This script carries the code and
# stops where the exercises begin.
#
# Set the working directory to this file's folder first, so the ../../data/
# paths resolve: Session > Set Working Directory > To Source File Location
# ============================================================

library(fpp3)


# ---- lagged variables ----

# Australian quarterly beer production from 2000 on: m = 4, T = 42.
recent_beer <- aus_production |>
  filter(year(Quarter) >= 2000) |>
  select(Quarter, Beer)

recent_beer

# dplyr::lag(), which masks stats::lag()
for (i in seq(1, 4)) {
  lag_name = paste0("Beer_lag", as.character(i))
  recent_beer[[lag_name]] = lag(recent_beer[["Beer"]], i)
}

recent_beer

recent_beer |> select(Beer, Beer_lag4)

# Change n_lag to overlay a different lag. Only four lags were built above.
n_lag = 4
lag_name = paste0("Beer_lag", n_lag)

recent_beer |>
  autoplot() +
  scale_x_yearquarter(breaks = "1 years",
                      minor_breaks = "1 year") +
  geom_line(aes_string(x = "Quarter", y = lag_name),
            color = "red",
            linetype = "dashed")


# ---- lag plots ----

recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 4)

recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 1:12)


# ---- autocorrelation and the correlogram ----

recent_beer |>
  ACF()

recent_beer |>
  ACF() |>
  autoplot()

# lag_max counts in units of the index: 24 quarters = 6 years here.
recent_beer |>
  ACF(lag_max = 24) |>
  autoplot()


# ---- white noise ----

set.seed(30)

y <- tsibble(sample = 1:50, wn = rnorm(50), index = sample)

y |> autoplot(wn) + labs(title = "White noise", y = "")

y |>
  ACF(wn) |>
  autoplot() + labs(title = "White noise")

# Worth doing once: drop set.seed(30) and re-run, watching which
# spikes cross the bounds.


# ============================================================
# EXERCISES - 04_C
#
# The code sets up each exercise and stops. For every correlogram you
# produce, write one sentence: which pattern dominates, and whether
# another could be hiding under it.
# ============================================================

# ---- exercise 1: ACF plot patterns ----
# No code. Match each of the four time series in the notebook to
# its correlogram, with one justifying sentence per series.

# ---- exercise 2: Total Private employment ----
us_employment

total_private <- us_employment |>
  filter(Title == "Total Private")

total_private

# YOUR TURN: time plot, then correlogram, then one sentence on
# what the correlogram shows and why.

# ---- exercise 3: corticosteroid prescription cost ----
# ATC2 == "H02" is corticosteroids for systemic use, with 4 rows
# per month (combinations of Concession and Type). See ?PBS.
PBS |>
  filter(ATC2 == "H02") |>
  select(ATC2, Month, Cost, everything()) |>
  arrange(Month)

# YOUR TURN:
#   1. index_by() + summarise() to get total Cost per month.
#   2. Time plot, lag plots (lags 1:16), ACF plot.
#   3. One sentence naming the seasonal period.

# ---- exercise 4: US gasoline supply ----
# Weekly supply of US finished motor gasoline product, Feb 1991
# to Jan 2017, in million barrels per day.
head(us_gasoline)

# YOUR TURN:
#   1. Time plot with enough resolution to spot each year.
#   2. Lag plots and a correlogram, to examine the seasonality.
# Work out how many lags a yearly season needs in weekly units,
# and compare that with what ACF() gives you by default, before
# you conclude anything.


# ============================================================
# 04_D - aggregation and time plots
#
# index_by() plus summarise() changes the unit of the index, and with
# it the lag that matters, the length T, and the white-noise bounds.
#
# Data paths are relative to this file: ../../data/ is the repo's
# data/ folder.
# ============================================================

library(readr)
library(readxl)

# ---- Beijing pollution ----
pollution <-

  # Read the file
  read_csv("../../data/Beijing_Pollution_TSeries.csv") |>

  #Step 1: create the time_stamp
  mutate(time_stamp = make_datetime(year, month, day, hour)) |>

  #Step 2: reorder columns and drop timestamp components (keep only the newly created timestamp)
  select(time_stamp, everything(), -c(No, year, month, day, hour))  |>

  #Step 3: convert to tsibble
  as_tsibble(index = time_stamp)

pollution

autoplot(pollution, NO2)

# ---- exercise 5: Beijing NO2, weekly and monthly ----
# YOUR TURN:
#   1.1 index_by() the hourly values into average WEEKLY NO2
#       levels as NO2_weekly, add a column holding the
#       year-and-month of each row, then filter to March 2013
#       (included) through March 2014 (excluded).
#   1.2 Time plot of NO2_weekly with a major break every month.
#   1.3 The same aggregated MONTHLY as NO2_monthly, plotted the
#       same way.
# The scale function has to match the type of the time index.

# ---- weekly fuel prices ----
# Long and keyed by fuel_type. The spreadsheet ends with a navigation
# row rather than data, which is what filter(!is.na(Date)) drops.
fuel_prices <-

  # Read excel file
  read_xlsx("../../data/Weekly Fuel Prices.xlsx",
            col_types = c ("date", "numeric", "numeric")) |>

  filter(!is.na(Date)) |>

  pivot_longer(cols = c("Petrol (USD)", "Diesel (USD)"),
               names_to = "fuel_type",
               values_to = "price_USD"
               ) |>

  as_tsibble(key =  fuel_type, regular = FALSE, index = Date)

fuel_prices

# Average quarterly prices, separated by fuel_type.
fuel_quarterly <-

  fuel_prices |>

  # Use group_by so that the subsequent index_by is applied
  # group-wise.
  group_by(fuel_type) |>

  # Index by yearquarter
  index_by(yq = yearquarter(Date)) |>

  # Summarise
  summarise(
      # One mean per fuel_type per quarter, so the name must not say "petrol"
      mean_price_USD = mean(price_USD, na.rm = TRUE)
  ) |>

  ungroup()

fuel_quarterly

# ---- exercise 6: fuel prices, 2004-2008 ----
# YOUR TURN:
#   Filter fuel_quarterly to 2004 through 2008 (both included)
#   and plot it with a major tick every year and a minor tick
#   every quarter. One sentence on how the result changes if you
#   drop the group_by(fuel_type) step.
