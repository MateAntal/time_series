# ============================================================
# Session 07 - Classical decomposition from scratch, and STL
#
# Runnable companion to the two notebooks in this folder:
#   07_D_ClassicalDecomposition_fromScratch
#   07_E_TSDecomposition_Algorithms
# The notebooks carry the derivations. This script carries the
# code, and stops where the exercises begin.
#
# Part 3 of the decomposition block, and the one that assembles
# the other two.
#   Session 5  the scheme: plus or times
#   Session 6  the trend, by moving average
#   Session 7  all four steps, then STL          <- you are here
#
# Set the working directory to this file's folder before you
# start.
#   RStudio:  Session > Set Working Directory > To Source File Location
#   console:  setwd("<repo>/sessions/07-classical-decomposition-stl")
# ============================================================

library(fpp3)


# ============================================================
# 1. THE ALGORITHM, IN FOUR STEPS
#
# Additive scheme, y_t = T_t + S_t + R_t:
#
#   1. Trend      T_t by centered moving average
#                   m even -> 2xm-MA
#                   m odd  -> m-MA
#   2. Detrend    D_t = y_t - T_t
#   3. Season     average D_t within each position of the
#                 season, then shift so the m values sum to 0,
#                 then repeat that shape along the series
#   4. Remainder  R_t = D_t - S_t = y_t - T_t - S_t
#
# Multiplicative scheme, y_t = T_t * S_t * R_t: the same four
# steps with divisions in place of subtractions, and the m
# seasonal values scaled to average 1 rather than shifted to
# sum to 0.
#
# Check each step against classical_decomposition() before you
# build the next one on top of it.
# ============================================================

us_retail_employment <-
  us_employment |>
  filter(year(Month) >= 1990, Title == "Retail Trade") |>
  select(-Series_ID)

us_retail_employment

# The reference answer, to check every step against.
reference <-
  us_retail_employment |>
  model(dcmp = classical_decomposition(Employed, type = "additive")) |>
  components()

reference


# ---- step 1: the trend, by 2x12-MA ----

# Monthly data, so m = 12, which is even. This is Session 6's
# 2xm construction, unchanged.
scratch <-
  us_retail_employment |>
  mutate(
    `12-MA_R` = slider::slide_dbl(Employed, mean,
                                  .before = 5, .after = 6, .complete = TRUE),
    `12-MA_L` = slider::slide_dbl(Employed, mean,
                                  .before = 6, .after = 5, .complete = TRUE),
    trend_manual = 0.5 * (`12-MA_R` + `12-MA_L`)
  )

# CHECK 1. Does our trend match the one the function produced?
isTRUE(all.equal(scratch$trend_manual, reference$trend))

# If that returned a character string instead of TRUE, stop here
# and fix step 1. Everything below is built on it.


# ---- step 2: detrend ----

# Additive scheme, so subtract.
scratch <- scratch |>
  mutate(detrended_manual = Employed - trend_manual)

# CHECK 2. The function does not expose a detrended column, so
# compare against what it implies: y - trend.
isTRUE(all.equal(scratch$detrended_manual,
                 reference$Employed - reference$trend))


# ---- step 3.1: the unadjusted seasonal component ----

# Average the detrended values within each month of the year.
# Twelve numbers out, one per calendar month.
s_unadj <-
  scratch |>
  as_tibble() |>
  mutate(month_of_year = month(Month)) |>
  summarise(s_unadj = mean(detrended_manual, na.rm = TRUE),
            .by = month_of_year)

s_unadj

# The twelve values do not sum to zero on their own. Check.
sum(s_unadj$s_unadj)


# ---- step 3.2: adjust so the season sums to zero ----

# Subtracting the mean centers any vector on zero. The notebook
# derives why this is the right correction.
s_adj <- s_unadj |>
  mutate(seasonal = s_unadj - mean(s_unadj))

s_adj

# SANITY CHECK. Must be zero, up to floating point, which is
# exactly the case all.equal() was built for.
isTRUE(all.equal(sum(s_adj$seasonal), 0))


# ---- step 3.3: repeat the season along the series ----

# left_join() matches each row to its month of the year and
# carries the right seasonal value across.
scratch <- scratch |>
  mutate(month_of_year = month(Month)) |>
  left_join(s_adj |> select(month_of_year, seasonal),
            by = "month_of_year")

# CHECK 3. Against the function's seasonal column.
isTRUE(all.equal(scratch$seasonal, reference$seasonal))


# ---- step 4: the remainder ----

scratch <- scratch |>
  mutate(remainder_manual = detrended_manual - seasonal)

# CHECK 4. The function calls this column `random`.
isTRUE(all.equal(scratch$remainder_manual, reference$random))


# ---- the four components, plotted ----

scratch |>
  select(Month, Employed, trend_manual, seasonal, remainder_manual) |>
  pivot_longer(c(Employed, trend_manual, seasonal, remainder_manual),
               names_to = "component", values_to = "value") |>
  mutate(component = factor(component,
                            levels = c("Employed", "trend_manual",
                                       "seasonal", "remainder_manual"))) |>
  autoplot(value) +
  facet_grid(vars(component), scales = "free_y") +
  labs(y = NULL, title = "Classical decomposition, built by hand")


# ============================================================
# 2. WHAT MAKES A DECOMPOSITION GOOD
#
# Two criteria, both about the remainder:
#
#   1. Its variance should be SMALLER than the variance of the
#      trend and the seasonal components. The trend and the
#      season should be doing most of the explaining.
#   2. It should carry AS LITTLE AUTOCORRELATION AS POSSIBLE.
#      Structure left in the remainder is structure the model
#      failed to capture.
#
# Criterion 2 is Session 4's correlogram, pointed at what the
# model missed. That is also what Session 9 does with residuals.
#
# Sometimes no decomposition satisfies both across the whole
# series. Take the closest one, and say where it falls short.
# ============================================================

# Criterion 1, as numbers.
scratch |>
  as_tibble() |>
  summarise(
    var_trend     = var(trend_manual, na.rm = TRUE),
    var_seasonal  = var(seasonal, na.rm = TRUE),
    var_remainder = var(remainder_manual, na.rm = TRUE)
  )

# Criterion 2, as a picture.
scratch |>
  ACF(remainder_manual) |>
  autoplot() +
  labs(title = "Correlogram of the remainder")


# ============================================================
# 3. THE LIMITATIONS OF CLASSICAL DECOMPOSITION
#
#   - No trend estimate for the first and last few points, which
#     is Session 6's ends problem.
#   - The seasonal component is forced to repeat unchanged from
#     year to year, so it cannot follow a season that evolves.
#   - It is not robust to outliers. An unusual value in the
#     middle of the series contaminates the trend, then the
#     detrended series, then the seasonal component.
#
# The third one is worth seeing rather than being told, which is
# what exercise 1 is for.
# ============================================================


# ============================================================
# 4. STL
#
# "Seasonal and Trend decomposition using LOESS". LOESS is local
# regression: to fit a value at a point, take its nearest
# neighbours, weight them by how close they are, and fit a low
# degree polynomial to that neighbourhood. Do that at every
# point and you get a smooth curve with no global formula.
#
# STL applies LOESS repeatedly to separate the components.
#
# WHAT IT BUYS YOU
#   - the seasonal component is allowed to change over time, and
#     you control how fast
#   - any seasonal period, not just monthly or quarterly
#   - multiple seasonal periods at once
#   - you control the smoothness of the trend
#   - it can be made robust to outliers
#
# WHAT IT COSTS
#   - additive only. For a multiplicative series, take logs
#     first, which is Session 5's identity.
#   - no automatic handling of calendar effects
#   - the windows usually need tuning by hand
#
# THE TWO WINDOWS
#   trend(window = )   how fast the trend may change.
#                      Smaller = more flexible. Must be ODD.
#                      Default 21.
#   season(window = )  how fast the season may change.
#                      Smaller = more flexible. Must be ODD.
#                      Default 13.
#                      "periodic" makes it infinite, which
#                      forces a constant season, like classical
#                      decomposition.
# ============================================================

# ---- STL with the defaults ----

stl_default <-
  us_retail_employment |>
  model(stl = STL(Employed)) |>
  components()

stl_default |> autoplot()

# The default windows do not let the trend bend sharply enough
# to follow the 2008 crisis, so the crisis lands in the
# remainder instead. Look at the remainder panel around 2008.


# ---- STL with the windows written out ----

# Pass the defaults explicitly once, so the syntax is familiar
# before you start changing the numbers.
us_retail_employment |>
  model(
    stl = STL(Employed ~ trend(window = 21) + season(window = 13))
  ) |>
  components() |>
  autoplot()


# ---- tuning, and how to judge it ----

# Reducing the trend window lets the trend follow the crisis.
# robust = TRUE makes the fit less sensitive to outliers; it
# does not always improve things, so try it both ways.
us_retail_employment |>
  model(
    stl = STL(Employed ~ trend(window = 13) + season(window = 13),
              robust = TRUE)
  ) |>
  components() |>
  autoplot()

# Judge a change by the two criteria from section 2, not by
# whether the trend line looks nicer. The remainder's ACF is the
# harder test of the two.
us_retail_employment |>
  model(stl = STL(Employed ~ trend(window = 13) + season(window = 13))) |>
  components() |>
  ACF(remainder) |>
  autoplot() +
  labs(title = "Remainder ACF, trend window 13")


# ============================================================
# EXERCISES
#
# From here the script sets each exercise up and stops.
#
# ASSIGNED: exercise 1, exercise 2, and exercise 3 item 2.1.
# ============================================================

# ---- exercise 1 (07_D): gas, and an outlier ----
# The last five years of quarterly Gas production.
gas <- tail(aus_production, 5 * 4) |> select(Gas)
gas

# YOUR TURN:
#   a. classical_decomposition() with type = "multiplicative".
#      Extract the components.
#   b. Compute and plot the seasonally adjusted series over the
#      original.
#   c. Add 300 to ONE observation near the MIDDLE of the series,
#      recompute, and plot the seasonally adjusted series. What
#      happened, and to which components?
#   d. Now move the outlier near the END of the series and do it
#      again. One sentence on why the answer is different.
#
# Before you run (d), predict the answer from Session 6: which
# region of the series can the 2x4-MA reach, and which can it
# not?

# ---- exercise 2 (07_E): STL Example 3, the labour series ----
# Monthly Australian civilian labour force, Feb 1978 to Aug 1995.
# Needs the fma package.
#
# Loading fma prints "The following object is masked _by_
# '.GlobalEnv': gas". That is expected and harmless: fma also
# ships a dataset called gas, and your own `gas` from exercise 1
# wins. Session 4's lag() masking was the same mechanism.
library(fma)
labour_tsibble <- as_tsibble(labour)
labour_tsibble |> autoplot(value)

# YOUR TURN:
#   1.1 STL with the default windows. Plot the components.
#   1.2 Look at the 1991-1992 crisis and answer:
#       - do the trend and seasonal components capture it?
#       - compare the grey scale bars across panels. Is this a
#         good decomposition, by the two criteria in section 2?
#       - tune the windows to capture the crisis better. Report
#         what you tried, not only what worked.

# ---- exercise 3 (07_E): STL on daily electricity demand ----
vic_elec_d <-
  vic_elec |>
  index_by(Date) |>
  summarise(avg_demand = mean(Demand)) |>
  filter(year(Date) == 2012)

vic_elec_d |> autoplot(avg_demand)

# The default decomposition, and the ACF of its remainder.
dcmp_1 <-
  vic_elec_d |>
  model(decomp = STL(avg_demand ~ trend(window = 21) + season(window = 13))) |>
  components()

dcmp_1 |> autoplot()

dcmp_1 |> ACF(remainder) |> autoplot()

# YOUR TURN:
#   2.1 What is wrong with this decomposition? Use both criteria
#       from section 2: the relative variances, read off the
#       grey bars, and the remainder's ACF.
#
# This is a diagnosis, not a tuning task. You are not asked to
# fix it, and on this series it cannot be fully fixed: no window
# setting gets the remainder to white noise. Saying that, with
# the evidence, is the complete answer.
#
# The notebook continues with a tuning item (2.2) on this
# series. NOT ASSIGNED - exercise 2 above already covers the
# tuning mechanics.
