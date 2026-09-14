# Session 11 — Transformations: logs, power, Box–Cox

**Date:** Monday, 19 October 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 3.1

**Data:** `australian_imports_japan.csv`, `private_housing_US.csv` (homework)

**Focus:** Interpreting logarithms and `log(1+x)`; power transformations; Box–Cox and choosing λ with
`guerrero()`; the standard workflow and its caveats; alternatives for data with zeros or negatives;
four worked examples (US GDP, Victorian bulls/bullocks, tobacco, retail).

**R:** `box_cox()`, `features(y, guerrero)`

**Homework:** The notebook's own Homework section — Exercise 1 (Australian imports from Japan) and
Exercise 2 (US private housing starts, non-deterministic seasonality).

**Outcome:** Student picks and justifies a transformation, and recognizes multiplicative
heteroskedasticity.

> Box–Cox is taught here, not back in the decomposition block, so that it sits adjacent to S12. fpp3
> separates 3.1 from 5.6 by two chapters; this ordering reunites them into one argument. Keep the
> adjacency.
