# Session 02 — Time series as a stochastic process + the tsibble

**Date:** Monday, 7 September 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 2.1 (tsibbles)

**Also:** Shumway & Stoffer, *Time Series: A Data Analysis Approach Using R* (2019), Ch. 1 — the
stochastic-process framing. This is the compulsory-text citation for the course; the framing is not in
fpp3 at all.

**Focus:** A time series as a collection of random variables `{Y_t}` indexed over time; uppercase
(process) vs lowercase (realization); past values as realized random variables, future values as
unrealized; why the variables are correlated and therefore not independent, and in general not
identically distributed, so the IID hypothesis behind the CLT does not apply. Then the mechanics:
lubridate parsing, `yearmonth`/`yearquarter`/`yearweek`, `tsibble()`, `as_tsibble()`, `index_by()`.

**R:** `ymd()`, `make_date()`, `as_datetime()`, `yearmonth()`, `tsibble()`, `as_tsibble()`,
`index_by()`, `scale_x_yearmonth()`

**Homework:** `00_C_basic_tibbles_dplyr_exercises`, in
[`self-study/00-r-basics/`](../../self-study/00-r-basics/). No solutions are published for the
primer — work through it on your own.

**Outcome:** Student can state why forecasts are random variables, and can build a valid tsibble with
the right index and key.
