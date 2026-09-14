# Session 12 — Prediction intervals and forecasting with transformations

**Date:** Wednesday, 21 October 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 5.5–5.6

**Focus:** Forecast distributions; one-step vs multi-step intervals; computing them with `fable` and
then reproducing them by hand from the residual standard deviation and a normal quantile, checking the
two agree; then forecasting when a transformation is in play, fitting on the transformed variable vs
declaring the transformation in the model formula, and back-transformed intervals.

**R:** `hilo()`, `forecast()` distributions

**Homework:** Reproduce the notebook's manual interval computation on a series of your own and confirm
it matches `fable`.

**Outcome:** Student produces and interprets prediction intervals, and handles them correctly under a
Box–Cox transformation.

> **One of the three hardest topics in the course.** Prediction intervals as *distributions*, rather
> than as a formula to apply, is the idea to get right here.
>
> Bootstrapped intervals come up in the notebook but are outside the scope of this course.
