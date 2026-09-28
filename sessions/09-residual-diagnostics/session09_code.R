# ============================================================
# Session 09 - Residual diagnostics
#
# Runnable companion to the notebook in this folder:
#   09_B_ResidualsAnalysis
# plus the one-page summary PDF, which is the spine of the
# session. The notebook carries the explanations; this script
# carries the code and stops where the exercises begin.
#
# TWO THINGS ABOUT THIS SESSION
#
#   1. It is NOT examined in the midterm. Coverage there runs
#      Sessions 1 to 8. Residual diagnostics opens the
#      evaluation block - this session, train/test accuracy
#      (Session 13) and cross-validation (Session 14) - and
#      those are examined together in the final.
#
#   2. It is also the midterm revision session. The second half
#      of class is yours: bring questions about Sessions 1 to 8.
#
# Set the working directory to this file's folder before you
# start.
#   RStudio:  Session > Set Working Directory > To Source File Location
#   console:  setwd("<repo>/sessions/09-residual-diagnostics")
# ============================================================

library(fpp3)


# ============================================================
# 1. WHAT A RESIDUAL IS, ONE MORE TIME
#
#   residual at t  =  y_t  -  yhat_{t|t-1}
#
# The gap between what happened and what the model would have
# said about it, having not yet seen it. Session 8's blue dots.
#
# A model has done its job when there is nothing left in the
# residuals but noise. So we check four properties:
#
#   ABOUT THE MODEL       (fixable, and worth fixing)
#     1. no autocorrelation   - no information left behind
#     2. zero mean            - the forecasts are not biased
#
#   ABOUT THE INTERVALS   (harder to fix, matters for Session 12)
#     3. constant variance    - homoscedasticity
#     4. normally distributed
#
# Properties 1 and 2 decide whether the model can be improved.
# Properties 3 and 4 decide whether you can trust a prediction
# interval built from it.
# ============================================================

bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)

# Two benchmarks at once, so the diagnostics have something to
# compare. Both are Session 8 models.
bricks_fit <- bricks |>
  model(
    Mean = MEAN(Bricks),
    Nv   = NAIVE(Bricks)
  )

bricks_fit

# augment() gives one row per observation per model.
bricks_aug <- bricks_fit |> augment()

head(bricks_aug)


# ============================================================
# 2. THE ONE FUNCTION THAT DOES MOST OF IT
#
# gg_tsresiduals() draws three panels at once:
#   - the residuals over time      -> mean and variance
#   - their correlogram            -> autocorrelation
#   - their histogram              -> normality
#
# It needs a single model, so select one column from the mable
# first.
# ============================================================

bricks_fit |> select(Nv) |> gg_tsresiduals()

# Read it in the order the properties are listed above.
#   Top panel    : does it sit on zero? does the spread stay
#                  constant left to right?
#   ACF panel    : are the bars inside +/- 2/sqrt(T)?
#   Histogram    : symmetric, one peak, tails not too heavy?

bricks_fit |> select(Mean) |> gg_tsresiduals()


# ============================================================
# 3. PROPERTY 2: ZERO MEAN
#
# A non-zero mean means the forecasts are biased: the model is
# systematically high or low. This is the EASY one to fix -
# subtract the mean of the residuals from the forecasts.
# ============================================================

bricks_aug |>
  as_tibble() |>
  summarise(mean_resid = mean(.resid, na.rm = TRUE), .by = .model)

# The mean model's residuals average to essentially zero by
# construction, which is not evidence that it is a good model.
# A biased model and a useless model are different problems.


# ============================================================
# 4. PROPERTY 1: NO AUTOCORRELATION
#
# This is Session 4's correlogram, used for the third time:
#   Session 4  on a raw series      - what patterns are there?
#   Session 7  on a decomposition remainder - what did the
#              decomposition fail to capture?
#   Session 9  on model residuals   - what did the model fail
#              to capture?
#
# Same instrument, sharper question each time.
# ============================================================

bricks_aug |>
  filter(.model == "Nv") |>
  ACF(.innov) |>
  autoplot() +
  labs(title = "Residual correlogram, naive model on bricks")

# Structure left in here is structure the model missed. Unlike
# a non-zero mean, it is hard to fix: you need a richer model,
# not an adjustment.


# ============================================================
# 5. PROPERTIES 3 AND 4: VARIANCE AND NORMALITY
#
# These two are about the prediction intervals of Session 12,
# not about whether the point forecast is any good.
# ============================================================

resid_nv <- bricks_aug |> filter(.model == "Nv")

# Normality: a QQ plot puts the residual quantiles against the
# quantiles of a normal distribution. Points on the line means
# normal.
resid_nv |>
  ggplot(aes(sample = .innov)) +
  stat_qq() +
  stat_qq_line(colour = "#D55E00") +
  labs(title = "QQ plot of the residuals", x = "Theoretical", y = "Sample")

# Constant variance: a boxplot per year shows whether the spread
# is drifting. Boxes of the same height means homoscedastic.
resid_nv |>
  as_tibble() |>
  mutate(yr = year(Quarter)) |>
  ggplot(aes(x = factor(yr), y = .innov)) +
  geom_boxplot() +
  labs(title = "Residuals by year", x = NULL, y = "Innovation residual") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

# If normality fails, transformations sometimes help (Session
# 11). If they do not, bootstrapped intervals are the way out -
# they need uncorrelated, homoscedastic residuals but not
# normal ones.


# ============================================================
# 6. THE MULTIPLE TESTING PROBLEM
#
# Checking each ACF bar against +/- 2/sqrt(T) is twenty
# hypothesis tests, each with its own 5% false-positive rate.
# Run twenty and about one crossing is the EXPECTED result even
# on perfect white noise. Session 4 said this; here is the fix.
#
# A PORTMANTEAU test asks one question about the first l
# autocorrelations together. The name is the French word for a
# rack that carries several items of clothing.
#
#   Box-Pierce   Q  = T * sum_{k=1..l} r_k^2
#   Ljung-Box    Q* = T(T+2) * sum_{k=1..l} (T-k)^-1 * r_k^2
#
# Both grow as the autocorrelation grows, because every term is
# r_k squared: positive, and small values shrink much harder
# than large ones. So small accidental correlations contribute
# almost nothing and real structure dominates the sum.
#
#   H0: the residuals are white noise (no autocorrelation)
#   small p-value -> reject H0 -> structure is left
#
# Ljung-Box is the one to use. Box-Pierce is the older, simpler
# version and is shown for context.
# ============================================================

# lag: how many autocorrelations to include (l above).
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

# Read the p-value, not the statistic. A p-value below 0.05 says
# the residuals are not white noise, so the model has left
# something on the table.


# ============================================================
# 7. WHY SQUARING MATTERS
#
# Every r_k is between -1 and 1, so squaring shrinks all of
# them - but it shrinks small ones far more:
# ============================================================

tibble(
  r        = c(0.9, 0.7, 0.5, 0.25, 0.1),
  r_sq     = c(0.9, 0.7, 0.5, 0.25, 0.1)^2,
  shrunk_by = 1 - c(0.9, 0.7, 0.5, 0.25, 0.1)
)

# An autocorrelation of 0.1 contributes 0.01 to the sum; one of
# 0.9 contributes 0.81, eighty times as much. That is what stops
# a handful of tiny accidental correlations from triggering the
# test.


# ============================================================
# EXERCISES
#
# From here the script sets each exercise up and stops.
#
# ASSIGNED this week: exercise 1 only. Exercise 2 is optional -
# see the note on it below. The midterm is the following
# Wednesday, so the homework is short on purpose.
# ============================================================

# ---- exercise 1: the decomposition model's residuals ----
#
# ASSIGNED. This is 09_B Exercise 1. It diagnoses the model that
# 08_A Exercise 1 built: an STL decomposition of log Turnover,
# with drift on the seasonally adjusted part and SNAIVE on the
# seasonal part. The fitting code is given below, so you do not
# need to have done 08_A Exercise 1 first.
#
# Note log(Turnover) inside STL(): the series is multiplicative,
# and Session 5's identity turns it additive. This is also the
# first model in the course whose .resid and .innov columns
# DIFFER, because a transformation is involved.

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
# NOT ASSIGNED this term. It is here as optional practice if you
# want a second, simpler diagnosis on a model with no
# transformation in it.

aus_exports <- global_economy |> filter(Country == "Australia")

#   1. Fit a NAIVE model to Exports.
#   2. Full diagnosis: gg_tsresiduals(), QQ plot, boxplots.
#   3. A Ljung-Box test. Annual, non-seasonal data and a
#      benchmark model, so lag and dof differ from exercise 1.
#   4. Which properties hold, which fail, what you would do.


# ============================================================
# MIDTERM REVISION - SESSIONS 1 TO 8
#
# The second half of class is revision. This is the spine of
# what is examinable, in order. Use it as a checklist: for each
# line, can you say what it is and produce the R for it?
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
#
# NOT examinable in the midterm: everything above this section.
# ============================================================
