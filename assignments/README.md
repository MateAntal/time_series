# Group assignments

Two group assignments, 20 % of the course grade between them. Both receive detailed written feedback.

## 1 — Classical decomposition (released Session 7, due Sunday 25 October 2026)

[`assignment-1-classical-decomposition/`](assignment-1-classical-decomposition/)

Reproduce `classical_decomposition()` exactly on the `a10` antidiabetic series for both the additive
and the multiplicative scheme, verify with `all.equal()`, redraw the output in ggplot without
`autoplot()`, and compare the two decompositions quantitatively.

## 2 — The Efficient Market Hypothesis (released Session 17)

[`assignment-2-efficient-market/`](assignment-2-efficient-market/) · needs `FTSE_Prices.csv`
(included in that folder)

The EMH as a random walk. Compare naïve, SES, damped Holt and an auto-ARIMA, with error metrics
computed both via `accuracy()` and by hand, then full cross-validation.

> The ARIMA syntax is handed to you. ARIMA itself is **not** taught in this course — it is the subject
> of the follow-up course, *Forecasting for Time Series*. You are being asked to run it as a
> black-box competitor, not to explain it.

---

Both assignments are submitted on Blackboard. See [`../SYLLABUS.md`](../SYLLABUS.md) for weights, the
AI policy and the library policy — using a different library for the same model is graded zero.

Assignment 1 runs for four weeks and is due **Sunday 25 October 2026, 23:59** — after the midterm,
so that exam revision and a from-scratch implementation do not compete for the same week.
