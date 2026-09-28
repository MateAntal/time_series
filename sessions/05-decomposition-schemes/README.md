# Session 05 — Additive vs multiplicative; detrended and seasonally adjusted series

**Date:** Monday, 21 September 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 3.2

**Focus:** The additive and multiplicative schemes; how square-root / cube-root / log / inverse
transformations differ in strength and what that tells you about the scheme; automating the
additive-vs-multiplicative decision; detrended and seasonally adjusted series, computed by hand and
checked with `all.equal()`; mixed schemes.

**Homework:** Reproduce the notebook's Example 1 and Example 2 manual computations and verify them
with `all.equal()`.

**Outcome:** Student picks the right scheme for a series and can produce detrended and seasonally
adjusted versions.

> **Course admin update.** Open [`announcements.md`](announcements.md) at the start
> of this session: the midterm now covers Sessions 1–8, homework deadlines move to the Sunday of
> each teaching week, and Group Assignment 1 is due after the exam.

> **Part 1 of 3.** Sessions 5, 6 and 7 are one topic, time series decomposition, taught in
> three parts: the scheme here, trend estimation by moving average in Session 6, the whole
> algorithm plus STL in Session 7. Read the three sets of notes together.

> Box–Cox (fpp3 3.1) is not covered here. It comes in Session 11, next to forecasting with
> transformations in Session 12, because the two belong together.
