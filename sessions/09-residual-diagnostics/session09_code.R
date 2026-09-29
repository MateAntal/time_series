# ============================================================
# Session 09 - Residual diagnostics
#
# Runnable companion to the notebook in this folder:
#   09_B_ResidualsAnalysis
# plus the one-page summary PDF, which is the spine of the
# session. The notebook carries the explanations; this script
# carries the code and stops where the exercises begin.
#
# NOT examined in the midterm (coverage runs Sessions 1 to 8).
# This session also doubles as the midterm revision session: the
# second half of class is yours to bring questions about
# Sessions 1 to 8.
#
# Set the working directory to this file's folder before you
# start.
#   RStudio:  Session > Set Working Directory > To Source File Location
#   console:  setwd("<repo>/sessions/09-residual-diagnostics")
# ============================================================

library(fpp3)


# ---- 1. what a residual is, one more time ----

bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)

bricks_fit <- bricks |>
  model(
    Mean = MEAN(Bricks),
    Nv   = NAIVE(Bricks)
  )

bricks_fit

bricks_aug <- bricks_fit |> augment()

head(bricks_aug)


# ---- 2. the one function that does most of it ----
# gg_tsresiduals() draws the residuals over time, their
# correlogram, and their histogram. It needs a single model.

bricks_fit |> select(Nv) |> gg_tsresiduals()

bricks_fit |> select(Mean) |> gg_tsresiduals()


# ---- 3. property 2: zero mean ----

bricks_aug |>
  as_tibble() |>
  summarise(mean_resid = mean(.resid, na.rm = TRUE), .by = .model)

# The mean model's residuals average to essentially zero by
# construction, which is not evidence that it is a good model.


# ---- 4. property 1: no autocorrelation ----

bricks_aug |>
  filter(.model == "Nv") |>
  ACF(.innov) |>
  autoplot() +
  labs(title = "Residual correlogram, naive model on bricks")


# ---- 5. properties 3 and 4: variance and normality ----

resid_nv <- bricks_aug |> filter(.model == "Nv")

# Normality: points on the QQ line means normal.
resid_nv |>
  ggplot(aes(sample = .innov)) +
  stat_qq() +
  stat_qq_line(colour = "#D55E00") +
  labs(title = "QQ plot of the residuals", x = "Theoretical", y = "Sample")

# Constant variance: boxes of the same height means homoscedastic.
resid_nv |>
  as_tibble() |>
  mutate(yr = year(Quarter)) |>
  ggplot(aes(x = factor(yr), y = .innov)) +
  geom_boxplot() +
  labs(title = "Residuals by year", x = NULL, y = "Innovation residual") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))


# ---- 6. the multiple testing problem ----
# A portmanteau test asks one question about the first l
# autocorrelations together. Ljung-Box is the one to use;
# Box-Pierce is the older version, shown for context.
#
#   H0: the residuals are white noise (no autocorrelation)
#   small p-value -> reject H0 -> structure is left

# lag: how many autocorrelations to include.
#      fpp3 suggests 10 for non-seasonal data, 2m for seasonal.
# dof: how many model parameters were estimated. Benchmarks
#      estimate none, so dof = 0 here.

bricks_aug |>
  filter(.model == "Nv") |>
  features(.innov, ljung_box, lag = 10, dof = 0)

bricks_aug |>
  filter(.model == "Nv") |>
  features(.innov, box_pierce, lag = 10, dof = 0)

# Both models at once, which is the useful form.
bricks_aug |>
  features(.innov, ljung_box, lag = 10, dof = 0)


# ---- 7. why squaring matters ----

tibble(
  r        = c(0.9, 0.7, 0.5, 0.25, 0.1),
  r_sq     = c(0.9, 0.7, 0.5, 0.25, 0.1)^2,
  shrunk_by = 1 - c(0.9, 0.7, 0.5, 0.25, 0.1)
)


# ============================================================
# EXERCISES
#
# ASSIGNED this week: exercise 1 only. Exercise 2 is optional -
# see the note on it below.
# ============================================================

# ---- exercise 1: the decomposition model's residuals ----
#
# ASSIGNED. This is 09_B Exercise 1. It diagnoses the model that
# 08_A Exercise 1 built: an STL decomposition of log Turnover,
# with drift on the seasonally adjusted part and SNAIVE on the
# seasonal part. The fitting code is given below, so you do not
# need to have done 08_A Exercise 1 first.
#
# Note log(Turnover) inside STL(): the series is multiplicative.
# This is also the first model in the course whose .resid and
# .innov columns DIFFER, because a transformation is involved.

retail_series <- aus_retail |>
  filter(`Series ID` == "A3349767W")

retail_series |> autoplot(Turnover)

fit_dcmp <- retail_series |>
  model(
    decomp = decomposition_model(
      STL(log(Turnover)),
      RW(season_adjust ~ drift()),
      SNAIVE(season_year)
    )
  )

fit_dcmp

# YOUR TURN:
#   1. gg_tsresiduals() on this model.
#   2. Work through all four properties in the order used in
#      class. One sentence each.
#   3. For the autocorrelation property: several bars cross the
#      bounds. Say why counting crossings one at a time is the
#      wrong way to decide, and name the test that fixes it.
#   4. Run that test. Monthly data, so work out lag from m, and
#      work out dof from how many parameters the model estimates.
#      Say why you chose each.
#
# Check whether .resid and .innov are still identical here. They
# are not, and the reason is the log.

# ---- exercise 2: Australian exports ----
#
# NOT ASSIGNED this term. Optional practice: a simpler diagnosis
# on a model with no transformation in it.

aus_exports <- global_economy |> filter(Country == "Australia")

#   1. Fit a NAIVE model to Exports.
#   2. Full diagnosis: gg_tsresiduals(), QQ plot, boxplots.
#   3. A Ljung-Box test. Annual, non-seasonal data and a
#      benchmark model, so lag and dof differ from exercise 1.
#   4. Which properties hold, which fail, what you would do.


# ============================================================
# MIDTERM REVISION - SESSIONS 1 TO 8
#
# The spine of what is examinable, in order. Use it as a
# checklist: for each line, can you say what it is and produce
# the R for it?
#
#  S1  R, RStudio, projects, packages
#  S2  stochastic processes; tsibbles; index, key, measured vars
#  S3  time plots, seasonal plots, subseries plots, scatterplots
#      trend / seasonality / cycle - and which is which
#  S4  lag plots; the ACF and the correlogram; white noise;
#      the +/- 2/sqrt(T) bounds
#  S5  additive vs multiplicative schemes; transformations;
#      detrended and seasonally adjusted series; all.equal()
#  S6  moving averages; centered windows; odd m and the 2xm
#      construction; why the ends are missing
#  S7  classical decomposition in four steps; the two criteria
#      for a good decomposition; STL and its two windows
#  S8  fitted values vs forecasts; the four benchmarks;
#      forecast distributions; forecasting through a
#      decomposition
# ============================================================
