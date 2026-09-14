# Session 08 — Benchmark methods, fitted values, and forecasting with decomposition

**Date:** Wednesday, 30 September 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 5.1–5.3, 5.7

**Focus:** Fitted values vs forecasts — `ŷ_{t|t-1}` against `ŷ_{T+h|T}` — starting from the
linear-regression analogy; point forecast vs forecast distribution; innovation residuals; then the
four benchmarks (mean, naïve, seasonal naïve, drift), each with its model definition, fitted values,
forecasts and parameter estimates. Close with **forecasting with a decomposition** (5.7): forecast the
seasonally adjusted component and the seasonal component separately, then recombine.

**R:** `model()`, `MEAN()`, `NAIVE()`, `SNAIVE()`, `RW(y ~ drift())`, `forecast(h = ...)`,
`augment()`, `decomposition_model()`

**Homework:** Fit all four benchmarks to a series of your choice, extract the fitted values, and plot
forecasts. Begin midterm revision.

**Outcome:** Student produces and plots benchmark forecasts for any series, can say precisely what a
fitted value is, and can forecast a series through its decomposition.

> 5.7 closes the loop from the decomposition block: it is what makes decomposition a *forecasting*
> tool rather than only a descriptive one. It is also the ancestor of the STL + ETS approach the
> follow-up course uses.
