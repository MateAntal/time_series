# Session 15 — Simple exponential smoothing: the equations

**Date:** Wednesday, 11 November 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 8.1

**Focus:** Naïve vs mean vs SES as three ways of weighting the past; the derivation from a geometric
progression; why SES forecasts are flat; the component form; the equations for the fitted values; what
fitting means — finding `ℓ₀` and `α`. Then the R half: specify the model, estimate the parameters,
interpret `α` by computing the weight on the three most recent observations, reconstruct the fitted
values by hand from `α` and `ℓ₀`, and forecast.

**R:** `ETS(y ~ error("A") + trend("N") + season("N"))`, `tidy()`, `augment()`

**Homework:** `15_C_SES_excel_fittedvals_exercise.xlsx` — compute the SES fitted values by hand in
Excel.

**Outcome:** Student writes the SES recursion, interprets `α`, and reproduces `fable`'s fitted values
from the parameters.
