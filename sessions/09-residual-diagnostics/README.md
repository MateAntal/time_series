# Session 09 — Residual diagnostics

**Date:** Monday, 5 October 2026, 9:00–10:20 — IE Tower, room T-05.02

**Announcements:** this session's dates and deadlines are in [`announcements.md`](announcements.md).

**[fpp3](https://otexts.com/fpp3/index.html):** 5.4

**Focus:** The properties good residuals must have and what to do when each fails (the 1-page summary
sheet, [`09_A`](09_A_ResidualsDiagnostics_Summary.md), is the spine; the handwritten
[PDF original](09_A_ResidualsDiagnostics_Summary.pdf) is alongside); worked diagnostics on the bricks and stock examples — residual mean, ACF,
qq-plots, boxplots, boxplots-by-year; why checking each ACF bar individually is multiple hypothesis
testing, and hence portmanteau tests; Ljung–Box.

**R:** `gg_tsresiduals()`, `features(.innov, ljung_box)`

**Homework:** `09_B` Exercise 1. Due after the midterm; the date is in the announcements.

**Outcome:** Student runs a full residual diagnosis and judges whether a model has captured the
signal.

> The midterm revision deck is in the [Session 10 folder](../10-midterm/), for office hours and
> your own revision. This session's deck is diagnostics only.

> **This session is not on the midterm.** Residual diagnostics is examined in the final, which covers
> the whole course. Revise it for the final, not for the midterm.
