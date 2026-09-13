# ============================================================
# Source: 04_C_TSGraphs_Graphs_Lagplots_Autocorrelation.qmd
# ============================================================


# ---- cell 1 ----
library(fpp3)

# ---- cell 2 ----
# Australian quarterly beer production, 2000 onwards.
# Quarterly data: the seasonal period m = 4.
recent_beer <- aus_production |>
  filter(year(Quarter) >= 2000) |>
  select(Quarter, Beer)

recent_beer

# ---- cell 3 ----
# Compute the first four lags of Beer.
# Each lag shifts the column down by k rows; the first k rows
# become NA because there is no past value to fill them with.
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
# four quarters earlier.
recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 4)

# ---- cell 7 ----
# The lag plot: scatterplots for lags 1 through 12 in one figure.
# The clouds are tightest at multiples of the seasonal period
# (lags 4, 8, 12) and tight but DOWNWARD at the half-period lags
# (2, 6, 10), where peaks sit on troughs. Odd lags are blobs.
# The faint diagonal in each panel is y = x, not a fitted line.
recent_beer |>
  gg_lag(y = Beer, geom = "point", lags = 1:12)

# ---- cell 8 ----
# The autocorrelation function.
# ACF() computes the autocorrelation coefficient for each lag.
# It returns a tsibble (lag, acf), so it can be filtered and
# arranged like any other. The default lag_max is 10*log10(T),
# which for T = 42 quarters gives the 16 rows printed below.
recent_beer |>
  ACF()

# ---- cell 9 ----
# The correlogram: ACF values plotted against lag number.
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
y |>
  ACF(wn) |>
  autoplot() + labs(title = "White noise")
