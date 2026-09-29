# ============================================================
# Session 08 - Benchmark methods and fitted values
#
# Runnable companion to the notebook in this folder:
#   08_A_Benchmark_Methods_FittedVals
# The notebook carries the explanations. This script carries the
# code, and stops where the homework begins.
#
# Set the working directory to this file's folder before you
# start.
#   RStudio:  Session > Set Working Directory > To Source File Location
#   console:  setwd("<repo>/sessions/08-benchmarks-fitted-values")
# ============================================================

library(fpp3)


# ---- 1. the three verbs ----
# model(), augment(), forecast() - the shape every model in the rest
# of the course goes through. Learn it on four methods simple enough
# to check in your head.

bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)

bricks


# ---- 2. fitted values are not forecasts ----

# ---- the mean model ----

fit_mean <- bricks |>
  model(mean = MEAN(Bricks))

fit_mean

fit_mean |> augment() |> head()

fit_mean |>
  augment() |>
  autoplot(Bricks, colour = "gray") +
  geom_line(aes(y = .fitted), colour = "#0072B2", linetype = "dashed") +
  labs(title = "Mean model: the fitted value is the same number everywhere")

# WATCH THIS ONE. The mean model is the exception: its fitted value
# at t uses the whole series, including points after t, so it is NOT
# a one-step-ahead forecast. The definition holds for the other three.


# ---- the naive model ----

aus_exports <- global_economy |> filter(Country == "Australia")

fit_naive <- aus_exports |>
  model(naive = NAIVE(Exports))

fit_naive |> augment() |> head()

# The fitted value at t is y_{t-1}: the .fitted column should be the
# Exports column shifted down one row, i.e. Session 4's lag().
fit_naive |>
  augment() |>
  mutate(check = lag(Exports)) |>
  select(Year, Exports, .fitted, check) |>
  head()


# ---- the seasonal naive model ----

employed <- us_employment |>
  filter(Title == "Total Private", Month >= yearmonth("2010 Jan"))

fit_snaive <- employed |>
  model(snaive = SNAIVE(Employed))

fit_snaive |> augment() |> head(14)

# Monthly data, so the fitted value at t is y_{t-12}. The first twelve
# rows have no fitted value: there is nothing to look back at yet.


# ---- the drift method ----

fit_drift <- employed |>
  model(drift = RW(Employed ~ drift()))

fit_drift |> tidy()

# Check the estimate against the formula by hand.
y <- employed$Employed
T_len <- length(y)
(y[T_len] - y[1]) / (T_len - 1)


# ---- 3. all four at once ----

fit_all <- employed |>
  model(
    Mean   = MEAN(Employed),
    Naive  = NAIVE(Employed),
    SNaive = SNAIVE(Employed),
    Drift  = RW(Employed ~ drift())
  )

fit_all

# One forecast set per model, 24 months ahead.
fc_all <- fit_all |> forecast(h = 24)

fc_all

fc_all |>
  autoplot(employed, level = NULL) +
  labs(y = "Persons (thousands)",
       title = "Four benchmark forecasts of US private employment")


# ---- 4. a forecast is a distribution, not a number ----

fc_all |> filter(.model == "Drift")

# Filter the FABLE rather than selecting a column from the mable:
# select() on a mable drops the key columns, and autoplot then
# refuses to match the forecasts to the data.
fc_all |>
  filter(.model == "Drift") |>
  autoplot(employed) +
  labs(y = "Persons (thousands)",
       title = "Drift forecast with 80% and 95% prediction intervals")


# ---- 5. residuals, and innovation residuals ----
# Identical when nothing was transformed, as everywhere in this
# session. They part company in Session 11.

fit_all |>
  augment() |>
  select(.model, Month, Employed, .fitted, .resid, .innov) |>
  head()

aug <- fit_all |> augment() |> filter(.model == "Drift")
isTRUE(all.equal(aug$.resid, aug$.innov))


# ---- 6. forecasting through a decomposition (fpp3 5.7) ----

fit_dcmp <- employed |>
  model(
    stl_drift = decomposition_model(
      STL(Employed),
      RW(season_adjust ~ drift()),   # the non-seasonal part
      SNAIVE(season_year)            # the seasonal part
    )
  )

fit_dcmp |>
  forecast(h = 24) |>
  autoplot(employed) +
  labs(y = "Persons (thousands)",
       title = "Forecasting through an STL decomposition")

# tidy() cannot describe this object, because it is two models
# combined. Fit the two parts separately if you want their
# parameter estimates.
dcmp <- employed |> model(stl = STL(Employed)) |> components()

dcmp |> select(season_adjust) |> model(drift = RW(season_adjust ~ drift())) |> tidy()


# ---- HOMEWORK ----
# Short on purpose. Group Assignment 1 is running this week and
# midterm revision starts now.

# YOUR TURN:
#   1. Pick one seasonal series. Anything from fpp3 you find
#      interesting - aus_production, us_employment, PBS, vic_elec
#      aggregated, or a series you used in Session 5.
#   2. Fit all four benchmarks in a single model() call.
#   3. forecast() far enough ahead to show at least two full
#      seasons, and plot all four over the data.
#   4. One sentence: which benchmark looks most reasonable for
#      your series, and why. Name the feature of the series that
#      makes it so.
#
# That is the whole assignment. Do not tune anything, do not
# compute error measures - measuring which forecast is actually
# better is Session 13.
