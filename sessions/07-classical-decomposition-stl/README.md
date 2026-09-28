# Session 07 — Classical decomposition, from scratch and by algorithm; STL

**Date:** Monday, 28 September 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 3.4, 3.6

**Focus:** The four steps of classical decomposition (trend by MA → detrend → seasonal component →
remainder) for both schemes, built by hand and then reproduced by `classical_decomposition()`; the
criteria for a good decomposition; STL — advantages, disadvantages, the trend and season windows, and
tuning them on three worked examples.

**R:** `classical_decomposition()`, `STL(y ~ trend() + season())`, `components()`

**Homework:** `07_D` Exercise 1, then the two STL window-tuning tasks in `07_E`: *STL - Example 3*
(items 1.1–1.2) and *Exercise 2 - STL* (items 2.1–2.2).

**Outcome:** Student decomposes a series both ways, interprets every component, and knows when to
prefer STL.

**→ Group Assignment 1 launches** — due **Sunday 25 October 2026, 23:59**. See
[`assignments/`](../../assignments/).

> **Part 3 of 3.** Sessions 5, 6 and 7 are one topic, time series decomposition. Session 5 chose
> the scheme, Session 6 estimated the trend, and this session assembles the whole algorithm and
> adds STL. The three are examined together.

> The heaviest session in the decomposition block. fpp3 3.5 (X-11 / SEATS) is not covered.
