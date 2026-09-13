# Session 16 — Fitting SES from scratch

**Date:** Monday, 16 November 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 8.1 (estimation)

**Data:** `yhat_SES_test`

**Focus:** Review the Excel workbook, then build the estimator in R: write `SES_levels()`, write an
SSE function, compose them into `my_ses_sse(α, ℓ₀)`, learn `optim()`, and recover `α` and `ℓ₀` for
Argentinian exports — then compare against `fable` and discuss why they differ slightly.

**R:** user-defined functions, `optim()`

**Homework:** `16_E_SES_Exercise` in full (timeplot, fit, interpret `α`, residual standard
deviation, manual 95% interval, compare to R's).

**Outcome:** Student can explain what `ETS()` is doing numerically, because they have done it.

> This build-it-then-verify pattern is the signature of the course. If you only ever call `ETS()`,
> this is the session that tells you what it was doing.
