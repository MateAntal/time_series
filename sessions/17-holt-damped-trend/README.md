# Session 17 — Holt's linear trend and damped trend

**Date:** Monday, 23 November 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 8.2

**Focus:** Component form and fitted-value equations for Holt's method; interpreting them; the effect
of `β*`; the fitting process; the Australian population example with components extracted and fitted
values rebuilt from the equations; then damped trend three ways — fixed `φ`, a bounded range, and
letting `ETS()` choose.

**R:** `ETS(y ~ error("A") + trend("A"/"Ad") + season("N"))`, `components()`, `augment()`

**Homework:** `17_B` Excel workbook, plus `17_A` Exercise 1 (internet usage — fit, compare
residuals of Holt vs damped Holt, qq-plot and boxplot).

**Outcome:** Student fits Holt and damped Holt and reads `α`, `β*` and `φ`.

**→ Group Assignment 2 launches** — see [`assignments/`](../../assignments/).
