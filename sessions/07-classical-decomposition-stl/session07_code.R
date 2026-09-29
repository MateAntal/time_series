# ============================================================
# Session 07 - Classical decomposition from scratch, and STL
#
# Companion to the two notebooks in this folder:
#   07_D_ClassicalDecomposition_fromScratch
#   07_E_TSDecomposition_Algorithms
# The notebooks carry the derivations. This script carries the code and
# stops where the exercises begin.
#
# Set the working directory to this file's folder first:
#   Session > Set Working Directory > To Source File Location
# ============================================================

library(fpp3)


# ---- 1. the algorithm, in four steps ----
# Additive scheme, y_t = T_t + S_t + R_t. Check each step against
# classical_decomposition() before building the next on it.

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
# If not TRUE, stop and fix step 1: everything below is built on it.
isTRUE(all.equal(scratch$trend_manual, reference$trend))


# ---- step 2: detrend ----

scratch <- scratch |>
  mutate(detrended_manual = Employed - trend_manual)

# CHECK 2. The function exposes no detrended column, so compare
# against what it implies: y - trend.
isTRUE(all.equal(scratch$detrended_manual,
                 reference$Employed - reference$trend))


# ---- step 3.1: the unadjusted seasonal component ----

# Average the detrended values within each month of the year.
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

s_adj <- s_unadj |>
  mutate(seasonal = s_unadj - mean(s_unadj))

s_adj

# SANITY CHECK. Must be zero up to floating point.
isTRUE(all.equal(sum(s_adj$seasonal), 0))


# ---- step 3.3: repeat the season along the series ----

# left_join() matches each row to its month of the year.
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


# ---- 2. what makes a decomposition good ----
# Both criteria are about the remainder: its variance should be
# smaller than the trend and seasonal variances, and it should
# carry as little autocorrelation as possible.

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


# ---- 3. the limitations of classical decomposition ----
# See the notebook. Exercise 1 makes the outlier problem visible.


# ---- 4. STL ----

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

# The defaults, passed explicitly once, so the syntax is familiar
# before the numbers change.
us_retail_employment |>
  model(
    stl = STL(Employed ~ trend(window = 21) + season(window = 11))
  ) |>
  components() |>
  autoplot()


# ---- tuning, step A: the trend window ----
# Move one window at a time, and judge the result on the remainder's
# correlogram, not on whether the trend line looks nicer.

stl_trend <- function(w) {
  us_retail_employment |>
    model(STL(Employed ~ trend(window = w) + season(window = 11))) |>
    components()
}

trend_windows <- c(21, 13, 9, 5)

ci <- 1.96 / sqrt(nrow(us_retail_employment))

# Two numbers per setting: how big the remainder is, and how many of
# its first 24 autocorrelations fall outside the white noise bounds.
bind_rows(lapply(trend_windows, function(w) {
  cp <- stl_trend(w)
  tibble(
    trend_window  = w,
    var_remainder = round(var(cp$remainder)),
    acf_bars_out  = sum(abs(ACF(cp, remainder, lag_max = 24)$acf) > ci)
  )
}))

# The four correlograms on one plot.
window_label <- function(w) {
  factor(paste0("trend(window = ", w, ")"),
         levels = paste0("trend(window = ", trend_windows, ")"))
}

remainder_acfs <- bind_rows(lapply(trend_windows, function(w) {
  stl_trend(w) |>
    ACF(remainder, lag_max = 24) |>
    as_tibble() |>
    mutate(lag = as.numeric(lag), window = window_label(w))
}))

remainder_acfs |>
  ggplot(aes(x = lag, y = acf)) +
  geom_hline(yintercept = c(-ci, ci), linetype = "dashed", color = "steelblue") +
  geom_segment(aes(xend = lag, yend = 0)) +
  facet_wrap(~ window) +
  labs(title = "Remainder correlogram at four trend windows", y = "ACF")

# Read the table and the plot together, and come to the session with
# a window chosen and a reason for it.


# ---- tuning, step B: the seasonal window ----
# Judged on the SEASONAL component: track one seasonal factor across
# the years and see what each window lets it do.

# Replace this with the trend window you settled on in step A.
chosen_trend <- 21

stl_season <- function(s) {
  us_retail_employment |>
    model(STL(Employed ~ trend(window = chosen_trend) + season(window = s))) |>
    components()
}

december_factors <- bind_rows(lapply(list(5, 11, "periodic"), function(s) {
  stl_season(s) |>
    as_tibble() |>
    filter(month(Month) == 12) |>
    transmute(
      Year          = year(Month),
      season_window = factor(as.character(s), levels = c("5", "11", "periodic")),
      December      = season_year
    )
}))

december_factors |>
  ggplot(aes(x = Year, y = December, color = season_window)) +
  geom_line(linewidth = 0.8) +
  labs(title = "The December seasonal factor under three seasonal windows",
       y = "December seasonal component")

# Three lines, three claims about Christmas hiring in US retail.
# Decide which of the three you believe, and why.


# ---- an aside on robust = TRUE ----

# Run it both ways. Before you look at the numbers, think about what
# robustness is being asked to do to the 2008 observations.
us_retail_employment |>
  model(
    stl = STL(Employed ~ trend(window = chosen_trend) + season(window = 11),
              robust = TRUE)
  ) |>
  components() |>
  autoplot()


# ---- the decomposition this arrives at ----

# Put your two chosen windows together and check the result against
# the two criteria from section 2.
chosen_season <- 11

us_retail_employment |>
  model(
    stl = STL(Employed ~ trend(window = chosen_trend) + season(window = chosen_season))
  ) |>
  components() |>
  autoplot()


# ============================================================
# EXERCISES
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
# wins.
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

# Daily data with a weekly season: the defaults are trend(window = 13)
# and season(window = 11). Passing no arguments, STL(avg_demand),
# gives exactly this result.
dcmp_1 <-
  vic_elec_d |>
  model(decomp = STL(avg_demand ~ trend(window = 13) + season(window = 11))) |>
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
