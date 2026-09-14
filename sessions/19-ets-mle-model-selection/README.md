# Session 19 — The ETS taxonomy, model selection, and forecasting with ETS

**Date:** Monday, 30 November 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 8.4–8.7

**Focus:** The ETS(Error, Trend, Season) notation and the full taxonomy. Then estimation: minimizing
SSE vs maximizing likelihood, following the MLE primer from the normal pdf through the joint density of
IID normals, the log-likelihood, the estimators for `μ` and `σ`, and the generalization to ETS. Then
selection: information criteria vs likelihood, IC vs cross-validation, AIC/AICc/BIC for ETS, the three
model combinations excluded for numerical reasons, multiplicative errors and their residuals, and
automatic selection with `ETS(y)`. Finally **forecasting with a fitted ETS model** (8.7) — point
forecasts and prediction intervals.

**R:** `ETS(y)` (automatic), `glance()`, `components()`, `forecast()`

**Homework:** `06_5_B` Exercises 1–3. Then revise for the final.

**Outcome:** Student lets `ETS()` auto-select, explains the chosen letters and why the criterion picked
them, and produces forecasts with intervals from the selected model.

> **The heaviest session of the term, and the third of the three hardest topics** — the ETS letter
> notation together with estimation.
>
> 8.7 is the payoff of the whole chapter: it takes the prediction-interval machinery from Session 12
> and applies it to the model family the course has spent five sessions building.
