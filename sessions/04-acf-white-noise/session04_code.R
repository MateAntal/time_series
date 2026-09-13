# ============================================================
# Session 04 - Lag plots, autocorrelation, white noise
#
# Sources: 04_C_TSGraphs_Graphs_Lagplots_Autocorrelation.qmd
#          04_D_TSGraphs_MoreExercises.qmd
#
# This is the runnable companion to the two notebooks in this
# folder. It carries the code those notebooks show you and the
# exercise set-up, and it stops where the exercises begin --
# the answers are yours to write.
#
# HOW TO RUN IT
#   The data paths below are relative to THIS file's folder.
#   Set the working directory here before you start:
#
#     RStudio:  Session > Set Working Directory > To Source File Location
#     console:  setwd("<repo>/sessions/04-acf-white-noise")
#
#   Then run it top to bottom, or a block at a time with
#   Ctrl+Enter. Sections 1-12 are the walkthrough; everything
#   from "EXERCISE" onward is for you to complete.
# ============================================================


# ---- cell 1 ----
library(fpp3)

# ---- cell 2 ----
# Australian quarterly beer production, 2000 onwards.
# Quarterly data: the seasonal period m = 4, and T = 42 quarters.
recent_beer <- aus_production |>
  filter(year(Quarter) >= 2000) |>
  select(Quarter, Beer)

recent_beer

# ---- cell 3 ----
# Compute the first four lags of Beer.
# Each lag shifts the column down by k rows; the first k rows
# become NA because there is no past value to fill them with.
#
# lag() here is dplyr::lag(), which fpp3 loads and which masks
# stats::lag(). That masking is what you want: stats::lag() does
# not shift a column, it relabels a ts object's time attribute.
# The [[ ]] extraction hands lag() a plain numeric vector, so this
# is position-based shifting.
for (i in seq(1, 4)) {
  lag_name = paste0("Beer_lag", as.character(i))
  recent_beer[[lag_name]] = lag(recent_beer[["Beer"]], i)
}

recent_beer

# ---- cell 4 ----
# Compare Beer with its fourth lag side by side.
# Each value of Beer_lag4 is the value of Beer four quarters ago.
recent_beer |> select(Beer, Beer_lag4)

# ---- cell 5 ----
# Overlay the fourth lag on the time plot.
# Because the seasonal period is 4, the lagged series sits
# perfectly in phase with the original: every Q1 lines up with
# the Q1 from the previous year.
#
# Try n_lag = 1 and 3 (the lines drift apart) and n_lag = 2
# (peaks land on troughs -- anti-phase, not "no relationship").
# The loop above only built four lags, so n_lag = 5 errors.
#
# Two warnings are expected here and neither is a bug:
#   * aes_string() was deprecated in ggplot2 3.0.0. It is kept
#     because it injects a column name held in a variable; the
#     modern idiom is aes(x = Quarter, y = .data[[lag_name]]).
#   * "Removed 4 rows containing missing values" -- those are the
#     four NAs at the top of Beer_lag4.
n_lag = 4
lag_name = paste0("Beer_lag", n_lag)

recent_beer |>
  autoplot() +
  scale_x_yearquarter(breaks = "1 years",
                      minor_breaks = "1 year") +
  geom_line(aes_string(x = "Quarter", y = lag_name),
            color = "red",
            linetype = "dashed")

# ---- cell 6 ----
# Drop the time axis: scatterplot of Beer against its 4th lag.
# Each point is one quarter: the value then, versus the value
# four quarters earlier. The faint diagonal is y = x, drawn for
# reference. It is not a fitted line, so do not read its slope
# as a strength -- the strength is how tightly the cloud hugs it.
recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 4)

# ---- cell 7 ----
# The lag plot: scatterplots for lags 1 through 12 in one figure.
# Read the panels for TIGHTNESS, not for direction:
#   * lags 4, 8, 12  -- tight UPWARD diagonals. In phase.
#   * lags 2, 6, 10  -- tight DOWNWARD diagonals. Half a period
#     back, peaks sit on troughs. Anti-phase is just as much
#     memory as an upward cloud.
#   * odd lags       -- blobs. A quarter of the way round the
#     cycle, highs and lows are mixed.
recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 1:12)

# ---- cell 8 ----
# The autocorrelation function.
# ACF() computes the autocorrelation coefficient for each lag.
# It returns a tsibble (lag, acf), so it can be filtered and
# arranged like any other. The default lag_max is 10*log10(T),
# which for T = 42 quarters gives the 16 rows printed below.
#
# The lag column prints as 4Q rather than 4: it carries the
# interval of the original series, which is what stops you from
# silently comparing a quarterly correlogram with a monthly one.
recent_beer |>
  ACF()

# ---- cell 9 ----
# The correlogram: ACF values plotted against lag number.
# Spikes at 4, 8, 12, 16 (multiples of m) and troughs at
# 2, 6, 10, 14 (half-period offsets, deeply negative).
# Both shrink as you move right. That is the distance penalty
# built into the formula, not fading seasonality.
recent_beer |>
  ACF() |>
  autoplot()

# ---- cell 10 ----
# lag_max controls how many lags are computed and displayed.
# For seasonality to appear, you need enough lags to see at
# least one full seasonal cycle -- ideally two or more.
# The unit is the index unit: 24 here means 24 QUARTERS, i.e.
# six years. The same number would mean two years of monthly
# data, or under half a year of weekly data.
recent_beer |>
  ACF(lag_max = 24) |>
  autoplot()

# ---- cell 11 ----
# White noise: a series with no autocorrelation at any lag.
# Knowing y[t-k] tells you nothing about y[t], for every k.
# That is the definition -- not "looks messy".
#
# Each value is drawn independently from a normal distribution,
# which makes this Gaussian white noise specifically -- white
# noise does not have to be normal. set.seed() fixes the draw so
# that everyone gets the same 50 numbers.
set.seed(30)

y <- tsibble(sample = 1:50, wn = rnorm(50), index = sample)

y |> autoplot(wn) + labs(title = "White noise", y = "")

# ---- cell 12 ----
# The correlogram of white noise.
# Spikes hover near zero; 95% are expected to fall inside the
# bounds at +/- 2/sqrt(T), where T is the length of the series.
# Here T = 50, so the bounds sit at +/- 2/sqrt(50) = +/- 0.283.
# Count your crossings: with 20 lags, about one is the expected
# result by chance, so a single crossing is not evidence.
#
# Worth doing once: delete set.seed(30) above and re-run this a
# few times. Spikes drift in and out of the bounds at random
# lags, which is the clearest demonstration that one crossing
# means very little.
y |>
  ACF(wn) |>
  autoplot() + labs(title = "White noise")


# ============================================================
# EXERCISES - 04_C
#
# From here on the code sets up each exercise and stops. Write
# the analysis yourself, and for every correlogram you produce
# add one sentence: which pattern dominates, and whether another
# could be hiding under it.
# ============================================================

# ---- exercise 1: ACF plot patterns ----
# No code. Match each of the four time series in the notebook to
# its correlogram.
#
# Method: classify each correlogram on its own before pairing
# anything -- envelope, rhythm, sign, scale -- then do the same
# for the time plots and match on the strongest discriminating
# feature. Check the sampling interval of every series first: a
# spike at lag 12 means one thing in monthly data and something
# quite different in quarterly or annual data. When you finish,
# every correlogram should be claimed exactly once.

# ---- exercise 2: Total Private employment ----
# Explore this series with autoplot() and ACF().
us_employment

total_private <- us_employment |>
  filter(Title == "Total Private")

total_private

# YOUR TURN: time plot, then correlogram. One sentence on what
# the correlogram shows and why.

# ---- exercise 3: corticosteroid prescription cost ----
# PBS holds monthly Medicare Australia prescription data.
# Run ?PBS for details. ATC2 == "H02" is corticosteroids for
# systemic use, and it has 4 rows per month (combinations of
# Concession and Type).
PBS |>
  filter(ATC2 == "H02") |>
  select(ATC2, Month, Cost, everything()) |>
  arrange(Month)

# YOUR TURN:
#   1. index_by() + summarise() to get total Cost per month.
#   2. A time plot with enough resolution to see the seasonality,
#      then lag plots (lags 1:16) and an ACF plot.
#   3. One sentence naming the seasonal period.

# ---- exercise 4: US gasoline supply ----
# Weekly supply of US finished motor gasoline product,
# February 1991 to January 2017, in million barrels per day.
head(us_gasoline)

# YOUR TURN:
#   1. A time plot with enough resolution to spot each year.
#   2. Lag plots and a correlogram, to examine the seasonality.
#
# Before you run anything: work out how many lags a yearly season
# needs in WEEKLY units, then check what ACF() gives you by
# default. Decide whether those two numbers are compatible before
# you draw any conclusion about seasonality.


# ============================================================
# 04_D - aggregation and time plots
#
# No ACF work here. This is the setup step the correlogram
# depends on: a lag is one step of whatever your index happens
# to be, so one year back is lag 8760 in hourly data, lag 52 in
# weekly data and lag 12 in monthly data. index_by() plus
# summarise() changes that unit, and with it the lag you should
# be looking at, the length T of the series, and therefore the
# white-noise bounds.
#
# NOTE ON PATHS: the notebooks are rendered with data/ beside
# them and so print read_csv("data/..."). This script lives in
# sessions/04-acf-white-noise/, so it reaches the repository's
# data/ folder with ../../data/. Same file, different starting
# point.
# ============================================================

# ---- cell 13 ----
library(readr)
library(readxl)

# ---- cell 14 ----
# Hourly readings from an air-quality station in Beijing:
# particulate matter (PM2.5, PM10), gaseous pollutants
# (SO2, NO2, CO, O3) and basic weather variables.
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

# ---- cell 15 ----
# A quick look at the hourly NO2 series.
autoplot(pollution, NO2)

# ---- exercise 5: Beijing NO2, weekly and monthly ----
# YOUR TURN:
#   1.1 index_by() the hourly values into average WEEKLY NO2
#       levels as NO2_weekly, add a column holding the
#       year-and-month of each row, then filter to March 2013
#       (included) through March 2014 (excluded).
#   1.2 A time plot of NO2_weekly with a major break every month.
#   1.3 The same thing aggregated MONTHLY as NO2_monthly, plotted
#       the same way.
#
# Watch the scale function: it has to match the type of the time
# index. scale_x_yearweek() for a yearweek index,
# scale_x_yearmonth() for a yearmonth one.

# ---- cell 16 ----
# Weekly petrol and diesel prices, reshaped long and keyed by
# fuel_type so the two series stay separate.
#
# One warning is expected and is not a bug:
#   "Expecting date in A884 ... got 'Return to Contents page'"
# The spreadsheet ends with a navigation row rather than data.
# read_xlsx() reads it as NA, and filter(!is.na(Date)) drops it.
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

# ---- cell 17 ----
# Average quarterly prices, separated by fuel_type.
#
# Run this with and without the group_by(fuel_type) line. Drop it
# and petrol and diesel are averaged together into a single
# meaningless series -- a silent wrong answer that no warning
# will catch for you.
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
