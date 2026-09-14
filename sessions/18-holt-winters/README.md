# Session 18 — Holt–Winters seasonal methods

**Date:** Wednesday, 25 November 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 8.3

**Focus:** Additive vs multiplicative seasonality; the component form and the `k` subindex in the
seasonal component; fitted-value and forecast equations; the Australian overnight-trips example fitted
both ways (watch the error term for numerical stability); the damped Holt–Winters variant; the
daily-data example.

**R:** `ETS()` with `season("A")` / `season("M")`, damped variants

**Homework:** `18_B` Excel workbook, plus the notebook's Seasonal Exp Smoothing exercise (timeplot,
fit on a training set, forecast 8 ahead, plot, then the point-accuracy and cross-validation questions).

**Outcome:** Student chooses and fits the right Holt–Winters variant and justifies it.

> The `k` subindex in the seasonal component is the easiest thing to get wrong here. Take it slowly.
