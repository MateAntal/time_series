# Session 13 — Train/test splits and point forecast accuracy

**Date:** Monday, 26 October 2026, 9:00–10:20 — IE Tower, room T-05.02

**fpp3:** 5.8

**Focus:** Subsetting a series with `filter()` and `slice()` (including the negative-index idiom and
the multi-key case); then errors — absolute vs relative; forecast errors vs residuals; MAE, RMSE,
MAPE, sMAPE, MASE and RMSSE; two worked examples (beer, Google) on both training and test sets, and
the manual recomputation of MAE and RMSE checked against `accuracy()`.

**R:** `filter()`, `slice()`, `accuracy()`

**Homework:** `13_Train_Test` train/test exercises, plus the `13_A_PointAccuracy` manual computation of MAE and RMSE for
the drift model on both sets.

**Outcome:** Student sets up an honest train/test split and reads all six metrics, knowing which is
scale-dependent and which is scaled.

> This session covers *point* forecast accuracy. fpp3 5.9, evaluating distributional forecast accuracy
> (Winkler score, CRPS), belongs to the follow-up course, where comparing models is the central task.
