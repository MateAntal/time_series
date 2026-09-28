# ============================================================
# Session 08 - Benchmark methods and fitted values
#
# Runnable companion to the notebook in this folder:
#   08_A_Benchmark_Methods_FittedVals
# The notebook carries the explanations. This script carries the
# code, and stops where the homework begins.
#
# This is the session the course turns on. Sessions 5 to 7
# described a series you already had. From here you predict one
# you do not.
#
# Set the working directory to this file's folder before you
# start.
#   RStudio:  Session > Set Working Directory > To Source File Location
#   console:  setwd("<repo>/sessions/08-benchmarks-fitted-values")
# ============================================================

library(fpp3)


# ============================================================
# 1. THE THREE VERBS
#
# Every model in the rest of this course goes through the same
# three steps, and they are worth learning as a shape rather
# than as three separate functions:
#
#   model()     define and fit. Returns a mable, a model table.
#   augment()   pull out the fitted values and residuals.
#   forecast()  produce forecasts beyond the data.
#
# Learn this on four methods so simple you can check them in
# your head. Then reuse it on everything from Session 15 on.
# ============================================================

bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)

bricks


# ============================================================
# 2. FITTED VALUES ARE NOT FORECASTS
#
#   FORECAST        yhat_{T+h|T}
#     the value at T+h, given everything up to T
#     lives BEYOND the data
#     can be many steps ahead (h > 1)
#
#   FITTED VALUE    yhat_{t|t-1}
#     the value at t, given everything up to t-1
#     lives INSIDE the data
#     is always one step ahead (h = 1)
#
# A fitted value is what the model would have said about a
# point it had not yet seen. That is what makes the residual
# y_t - yhat_t an honest measure of error rather than a measure
# of how well the model memorized the data.
# ============================================================


# ---- the mean model ----
# Every forecast is the average of the history.
#   yhat_{T+h|T} = (y_1 + y_2 + ... + y_T) / T

fit_mean <- bricks |>
  model(mean = MEAN(Bricks))

fit_mean

# augment() returns the original series, the fitted values
# (.fitted), the residuals (.resid) and the innovation
# residuals (.innov), all in one table.
fit_mean |> augment() |> head()

fit_mean |>
  augment() |>
  autoplot(Bricks, colour = "gray") +
  geom_line(aes(y = .fitted), colour = "#0072B2", linetype = "dashed") +
  labs(title = "Mean model: the fitted value is the same number everywhere")

# WATCH THIS ONE. The mean model is the exception to the
# definition above: its fitted value at t uses the whole series,
# including points after t. So it is NOT a one-step-ahead
# forecast. The definition holds for the other three.


# ---- the naive model ----
# Every forecast is the last observation.
#   yhat_{T+h|T} = y_T

aus_exports <- global_economy |> filter(Country == "Australia")

fit_naive <- aus_exports |>
  model(naive = NAIVE(Exports))

fit_naive |> augment() |> head()

# The fitted value at t is y_{t-1}. Check one by hand: the
# .fitted column should be the Exports column shifted down one
# row, which is exactly Session 4's lag().
fit_naive |>
  augment() |>
  mutate(check = lag(Exports)) |>
  select(Year, Exports, .fitted, check) |>
  head()


# ---- the seasonal naive model ----
# Every forecast is the last observation from the same season.
#   yhat_{T+h|T} = y_{T+h-m(k+1)}
# which in words is: every future March equals the last March
# you actually saw.

employed <- us_employment |>
  filter(Title == "Total Private", Month >= yearmonth("2010 Jan"))

fit_snaive <- employed |>
  model(snaive = SNAIVE(Employed))

fit_snaive |> augment() |> head(14)

# Here the fitted value at t is y_{t-12}, because the data is
# monthly and m = 12. The first twelve rows have no fitted value
# for the same reason the moving average had gaps in Session 6:
# there is nothing to look back at yet.


# ---- the drift method ----
# A naive forecast that is allowed to slope. The slope is the
# average change over the history, which works out to the slope
# of the straight line joining the first and last observations.
#
#   yhat_{T+h|T} = y_T + h * (y_T - y_1) / (T - 1)

fit_drift <- employed |>
  model(drift = RW(Employed ~ drift()))

# RW stands for random walk. The drift is the one parameter it
# estimates, so tidy() has something to show.
fit_drift |> tidy()

# Check the estimate against the formula by hand.
y <- employed$Employed
T_len <- length(y)
(y[T_len] - y[1]) / (T_len - 1)


# ============================================================
# 3. ALL FOUR AT ONCE
#
# model() takes several definitions, so all four fit in one
# call and land in one mable, one column each.
# ============================================================

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


# ============================================================
# 4. A FORECAST IS A DISTRIBUTION, NOT A NUMBER
#
# The .mean column is the POINT forecast: the mean of the
# forecast distribution. The Employed column in a fable holds
# the whole distribution.
#
# Plotting without level = NULL draws the prediction intervals,
# and they are the honest picture: the further ahead you look,
# the less you know.
# ============================================================

fc_all |> filter(.model == "Drift")

# Filter the FABLE rather than selecting a column from the
# mable: select() on a mable drops the key columns, and autoplot
# then refuses to match the forecasts to the data.
fc_all |>
  filter(.model == "Drift") |>
  autoplot(employed) +
  labs(y = "Persons (thousands)",
       title = "Drift forecast with 80% and 95% prediction intervals")

# Session 12 is where those intervals get built rather than
# just drawn. For now, notice only that they widen.


# ============================================================
# 5. RESIDUALS, AND INNOVATION RESIDUALS
#
#   residual            y_t - yhat_t        original units
#   innovation residual w_t - what_t        transformed units
#
# If no transformation was used the two are identical, which is
# the case everywhere in this session. They part company in
# Session 11, when transformations arrive. Session 09 works on
# the innovation residuals, so it is worth knowing the column
# exists now.
# ============================================================

fit_all |>
  augment() |>
  select(.model, Month, Employed, .fitted, .resid, .innov) |>
  head()

# Identical here, because nothing was transformed.
aug <- fit_all |> augment() |> filter(.model == "Drift")
isTRUE(all.equal(aug$.resid, aug$.innov))


# ============================================================
# 6. FORECASTING THROUGH A DECOMPOSITION        (fpp3 5.7)
#
# This is what makes the decomposition block a forecasting tool
# rather than only a descriptive one.
#
#   1. decompose the series
#   2. forecast the SEASONALLY ADJUSTED part with any
#      non-seasonal method, because the season is out of it
#   3. forecast the SEASONAL part, usually with SNAIVE, because
#      a season barely changes
#   4. recombine
#
# decomposition_model() does all four in one call.
# ============================================================

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


# ============================================================
# HOMEWORK
#
# Short on purpose. Group Assignment 1 is running this week and
# midterm revision starts now.
# ============================================================

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
