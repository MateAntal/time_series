# Time Series Analysis — Syllabus 26-27

**Dual Degree in Business Administration & Data and Business Analytics** · BBADBA SEP-2026
TSA-NBDA.3.M.A
Area: Mathematics · Academic year 26-27 · Semester 1 · Third year · Compulsory · English
20 sessions · 3 credits · all sessions live in-person

**Professor:** Alejandro Berrizbeitia — aberrizbeitia@faculty.ie.edu
Office hours on request; write to the address above.

> This file mirrors the official syllabus filed with IE University. **Where the two disagree, the
> official syllabus governs.** The assessment method may be modified; if that happens you will be
> told on the first day of class and given a written document detailing the changes.

---

## Subject description

The analysis of data that have been observed at different points in time leads to new and unique
problems in statistical modeling and inference. The obvious correlation introduced by the sampling of
adjacent points in time can severely restrict the applicability of the many conventional statistical
methods, traditionally dependent upon the assumption that these adjacent observations are independent
and identically distributed (Shumway and Stoffer, 2017). Specific methods and techniques are therefore
necessary to handle time series data.

This course covers the analysis of time series and the foundations of forecasting. Students learn to
explore and visualize a series, decompose it into its components, interpret autocorrelation, transform
a series when its variance is not stable, and then build, evaluate and compare forecasting models. Two
families of models are studied: the benchmark methods, which set the standard any serious model must
beat, and the exponential smoothing family, taught end to end — from the simple exponential smoothing
recursion through Holt–Winters to the full ETS taxonomy, with maximum-likelihood estimation, automatic
model selection, and forecasting from a fitted ETS model.

A defining feature of the course is that the central methods are built by hand before they are used
through a library. Students implement classical decomposition, simple exponential smoothing,
prediction intervals and error metrics themselves, and then verify their results against the R
implementation. The objective is that students understand what the software does, rather than only how
to call it.

Time series analysis and forecasting are intrinsic to econometrics, finance, business, supply chain
management, climate and weather forecasting, predictive maintenance and many more disciplines.
Examples of time series data include the continuous monitoring of a person's heart rate, hourly
readings of air temperature, daily closing price of a company stock, monthly rainfall data, yearly
sales figures.

ARIMA models, time series regression and dynamic regression are **not** covered in this course. They
belong to the follow-up course, *Forecasting for Time Series*, for which this course is the
prerequisite. This course stops at the end of the exponential smoothing family. By that point students
hold one complete model family, along with every prerequisite the follow-up course builds on.

### Prerequisites

- Fundamentals of Probability and Statistics.
- Fundamentals of Data Analysis.
- Programming and Data Visualization in R.

### Software

R and RStudio Desktop, installed locally on your own machine, with the `fpp3` package collection
(`tsibble`, `feasts`, `fable`, `tsibbledata`) plus `tidyverse`, `GGally`, `fma`, `patchwork`,
`cowplot`, `seasonal` and `urca`. Everything used in this course is free and open source. No paid
license is required, and no ChatGPT Edu license is required.

Course materials are distributed through this public GitHub repository, which you clone or download.
Install instructions are in [`setup/SETUP.md`](setup/SETUP.md).

---

## Learning objectives

The main purpose of this course is to provide students with the necessary mathematical background and
tools to effectively handle time series analyses, as well as with a standardized workflow to
systematically tackle time series data. By the end of the course students should be able to:

- Explain what autocorrelation means and why it matters in Time Series Analysis (TSA), and why a time
  series cannot be treated as a sample of independent and identically distributed observations.
- Apply the graphical techniques specific to TSA and interpret what they show.
- Identify and capture the components of a time series by several different methods, and explain the
  technical details behind each method and the caveats that come with it.
- Select and justify a variance-stabilizing transformation, and handle forecasts and prediction
  intervals correctly when a transformation is in place.
- Produce forecasts from the benchmark methods and from a decomposition, then judge them honestly
  using train/test splits, point accuracy metrics and time series cross-validation.
- Fit any member of the exponential smoothing family, tailor it to the series at hand, produce point
  forecasts and prediction intervals from it, and explain the estimation and model-selection criteria
  that chose it.
- Implement the core methods from first principles and verify them against a library implementation.

---

## Teaching methodology

**Prior to every session, students must read any materials provided by the professor.** Reading the
materials in advance will allow you to get the most out of each lecture. During this reading, look at
the examples but do not try to solve them. Every session in the program below names the textbook
sections to read beforehand.

Homework is provided after each class and is due by 23:59 on the Sunday of the teaching week in which
it was assigned; the exact date for every assignment is posted on Blackboard. Homework must show a
genuine individual attempt but need not be correct — it is graded on completion and effort, not on
results. Most exercises are self-verifying: the manual computation is checked against R's own
implementation with `all.equal()`, so students confirm their own work as they go. After each due date
the professor publishes a common-errors note to the whole cohort on Blackboard and reviews the main
difficulties at the start of the first session after the deadline. A rotating sample of submissions receives
individual written comments on Blackboard, so that every student is commented on individually several
times over the course. The two group assignments receive detailed written feedback.

Plan for roughly 1.5 hours per session outside class, covering the pre-session reading and the
homework. The decomposition block (Sessions 5 to 7) and the weeks around each group assignment run
heavier than that.

Optional online preparation tutorials are offered before the midterm and before the final exam.

| Learning Activity | Weighting | Estimated hours |
|---|---|---|
| Lectures | 40 % | 30 |
| Discussions | 6,7 % | 5 |
| Exercises in class, Asynchronous sessions, Field Work | 13,3 % | 10 |
| Group work | 13,3 % | 10 |
| Individual studying | 26,7 % | 20 |
| **TOTAL** | **100 %** | **75 / 75** |

---

## AI policy

**Restricted use of Generative AI**

Generative AI tools can produce code, forecasts, and written interpretations for many of the tasks in
this course. However, the objective here is not just to obtain an answer, but to understand the
underlying time series techniques and learn how to implement them manually. For that reason,
AI-generated code or results are not allowed. You may use course materials, documentation, and your
own reasoning, but the analysis, implementation, and interpretation must be your own.

Therefore, the use of GenAI is not permitted unless otherwise stated by the instructor. If a student
is found to have used AI-generated content for any form of assessment, it will be considered academic
misconduct and the student might fail the respective assignment or the course.

---

## Program

### Session 1 — Introduction: what forecasting is, and local setup

- Class policy and rules; assessment; attendance; the generative AI and library policy
- Introduction to the domain of time series
- What can and cannot be forecast; the basic steps in a forecasting task
- Sample use case: automated forecasting of population by country
- Installation of R and RStudio Desktop, the `fpp3` packages, and the course repository

**Reading:** fpp3 1.1–1.7

### Session 2 — A time series as a stochastic process; the tsibble

- A time series as a collection of random variables indexed over time
- Process versus realization; why a forecast is a random variable
- Why time series observations are correlated, and therefore neither independent nor identically
  distributed, so the IID assumption behind the Central Limit Theorem does not apply
- Dates and times in R; `yearmonth`, `yearquarter`, `yearweek`
- Building and validating a tsibble: the index and the key

**Reading:** fpp3 2.1. Shumway & Stoffer, *Time Series: A Data Analysis Approach Using R*, Chapter 1,
for the stochastic-process framing.

### Session 3 — Time series graphs: time plots, seasonal plots, seasonal sub-series plots, scatterplots

- Time plots and the scale helpers for each index type
- Trend, seasonality and cyclicity; distinguishing seasonal from cyclic behavior
- Seasonal plots and seasonal sub-series plots
- Multiple seasonality
- Scatterplots and non-linearities; careful interpretation of the correlation coefficient
- The scatterplot matrix

**Reading:** fpp3 2.2–2.6

### Session 4 — Time series graphs: lag plots, autocorrelation, white noise

- Leading and lagged variables, on time plots and on scatterplots
- Autocorrelation versus Pearson's correlation coefficient
- Computing the autocorrelation function in R; the correlogram and how many lags to display
- Trend and seasonality in autocorrelation graphs, and the patterns you need to recognize
- White noise as the reference case

**Reading:** fpp3 2.7–2.9

### Session 5 — Time series decomposition (1/3): additive and multiplicative schemes

- Time series components; additive versus multiplicative schemes
- The relative strength of square-root, cube-root, logarithmic and inverse transformations, and what
  it reveals about the appropriate scheme
- Automating the additive-versus-multiplicative decision
- Detrended and seasonally adjusted series, computed manually and verified
- Mixed schemes

**Reading:** fpp3 3.2

### Session 6 — Time series decomposition (2/3): moving averages for trend estimation

- What a moving average is; neighboring windows at t and t+1
- Odd-order windows; the effect of the window size
- Even-order windows and the 2×m case
- The limitations of centered windows

**Reading:** fpp3 3.3

### Session 7 — Time series decomposition (3/3): classical decomposition and STL

- The four steps of classical decomposition, for both schemes, implemented from scratch
- Reproducing `classical_decomposition()` and verifying exact agreement
- The criteria for a good decomposition
- STL decomposition: advantages, disadvantages, the trend and season windows, and how to tune them
- **Group Assignment 1 released:** implementing classical decomposition from scratch

**Reading:** fpp3 3.4, 3.6

### Session 8 — First time series models: benchmark methods, fitted values, and forecasting with decomposition

- Fitted values versus forecasts, starting from the linear regression analogy
- Point forecast versus forecast distribution; innovation residuals
- The Mean method
- Naïve
- Seasonal Naïve
- Drift method
- Model definition, fitted values, forecasts and parameter estimates for each
- Forecasting with a decomposition: forecasting the seasonally adjusted component and the seasonal
  component separately, and recombining them

**Reading:** fpp3 5.1–5.3, 5.7

### Session 9 — Residual diagnostics

- The properties that good residuals must have, and what to do when each one fails
- Residual mean, residual ACF, qq-plots and boxplots
- Why inspecting each ACF bar individually is multiple hypothesis testing, and hence portmanteau tests
- The Ljung–Box test
- Closing revision sweep of Sessions 1 to 8, ahead of the midterm

**Reading:** fpp3 5.4

### Session 10 — Midterm exam

- Coverage: Sessions 1 to 8
- Residual diagnostics (Session 9) is **not** examined here; it belongs to the evaluation block and is
  examined in the final
- Format: 20 multiple-choice questions, four options each
- An optional online preparation tutorial is offered in the preceding week

### Session 11 — Transformations to even out variance: logarithms, power, Box–Cox

- Interpreting logarithms and `log(1+x)`
- Power transformations
- The Box–Cox transformation and the choice of lambda with `guerrero()`
- The standard workflow and its caveats; alternatives for data containing zeros or negative values
- Worked examples: US GDP, Victorian bulls and bullocks, tobacco production, retail

**Reading:** fpp3 3.1

### Session 12 — Prediction intervals and forecasting with transformations

- Forecast distributions
- One-step and multi-step prediction intervals
- Computing intervals with `fable`, then reproducing them manually from the residual standard
  deviation and a normal quantile, and verifying that the two agree
- Forecasting when a transformation is in place: transforming the variable versus declaring the
  transformation in the model formula
- Back-transformed prediction intervals

**Reading:** fpp3 5.5–5.6

### Session 13 — Error metrics and their interpretation: train/test splits and point forecast accuracy

- Subsetting a series with `filter()`, `filter_index()` and `slice()`, including the negative-index
  idiom and the multiple-key case
- Forecast errors versus residuals; absolute versus relative errors
- MAE, RMSE, MAPE, sMAPE, MASE and RMSSE
- Which metrics are scale-dependent and which are scaled
- Manual recomputation of MAE and RMSE, verified against `accuracy()`

**Reading:** fpp3 5.8

### Session 14 — Train-test split / time series cross-validation

- Why k-fold cross-validation is invalid for time series
- Visualizing the expanding-window splits
- One-step, multi-step and multi-horizon variants
- `stretch_tsibble()`; comparing models by forecast horizon

**Reading:** fpp3 5.10

### Session 15 — Simple exponential smoothing: the equations

- Naïve, Mean and simple exponential smoothing as three different ways of weighting the past
- Derivation from a geometric progression
- Why simple exponential smoothing forecasts are flat
- The component form: the level equation
- The fitted-value equations; what fitting means: finding the smoothing parameter and the initial level
- Interpreting the smoothing parameter through the weight it places on recent observations

**Reading:** fpp3 8.1

### Session 16 — Fitting simple exponential smoothing from scratch

- Review of the manual computation of fitted values
- Writing the level recursion and a sum-of-squared-errors function in R
- Numerical optimization with `optim()`; recovering the smoothing parameter and the initial level
- Comparing the from-scratch estimates against the library implementation, and explaining why they
  differ slightly

**Reading:** fpp3 8.1 (estimation)

### Session 17 — Trended exponential smoothing: Holt's linear trend and damped trend

- Component equations: level and trend
- Interpreting the trend smoothing parameter
- The fitting process; extracting the components and rebuilding the fitted values from the equations
- Damped trend three ways: a fixed damping parameter, a bounded range, and automatic selection
- Examples and exercises
- **Group Assignment 2 released:** the Efficient Market Hypothesis

**Reading:** fpp3 8.2

### Session 18 — Seasonal exponential smoothing: Holt–Winters methods

- Component equations: level, trend and seasonal index
- Additive versus multiplicative seasonality
- The fitted-value and forecast equations
- Numerical stability and the choice of error term
- The damped Holt–Winters variant
- The daily-data example

**Reading:** fpp3 8.3

### Session 19 — The ETS taxonomy, model selection, and forecasting with ETS

- The ETS(Error, Trend, Season) notation and the full taxonomy of exponential smoothing methods
- Estimation: minimizing the sum of squared errors versus maximizing the likelihood
- Information criteria: AIC, AICc and BIC for ETS models
- Information criteria versus cross-validation as selection strategies
- The model combinations excluded for numerical reasons; multiplicative errors and their residuals
- Automatic model selection with `ETS()`
- Forecasting with a fitted ETS model: point forecasts and prediction intervals

**Reading:** fpp3 8.4–8.7

### Session 20 — Final exam

- Coverage: the whole course, Sessions 1 to 19
- Format: 20 multiple-choice questions, four options each
- An optional online preparation tutorial is offered in the preceding week

---

## Evaluation

| Criteria | Weight |
|---|---|
| Intermediate tests (midterm, Session 10) | 30 % |
| Final Exam (Session 20) | 30 % |
| Group Work | 20 % |
| Individual work | 10 % |
| Class Participation | 10 % |
| **TOTAL** | **100 %** |

**Group Work** consists of two group assignments: implementing classical decomposition from scratch,
released in Session 7, and the Efficient Market Hypothesis, released in Session 17. Both receive
detailed written feedback. See [`assignments/`](assignments/).

**Individual work** is the per-session homework, assigned after each class and due by 23:59 on the
Sunday of the teaching week in which it was assigned. It is graded on completion and genuine
individual effort, not on correctness. Feedback is given as a cohort-wide common-errors note after
each due date, as a review at the start of the first session after the deadline, and as individual
written comments
on a rotating sample of submissions.

**Class Participation** is assessed on attendance and on engagement during in-class exercises and
discussions.

**Intermediate tests** is the midterm exam, held in Session 10. Both exams are 20 multiple-choice
questions with four options each.

Homework and assignments are submitted on **Blackboard**, not in this repository.

### Verification of individual understanding

As part of the normal assessment of this course, the professor may ask any student for a short
individual conversation about their submitted work or about the material covered in class. The
student is asked to explain their reasoning, the choices behind an analysis, and the concepts the
work relies on. No separate preparation is expected: if the work reflects the student's own
understanding, the conversation is straightforward.

These conversations are a routine part of assessment. They may be requested of any student at any
point in the term, and a request is not in itself an indication of any concern about that student's
work. Where the conversation does not support that a piece of work reflects the student's own
understanding, the professor may take that into account in assessing the work concerned and, where
appropriate, refer the matter under the University's Academic Integrity Policy.

### Midterm retake policy

The date for the midterm is the date of session 10, as specified in this syllabus.

There is no retake for the midterm. If any student cannot attend the midterm for personal / work
reasons the final exam will have a weight of 60% instead of 30%. That is, it will encompass both the
midterm and the final exam weights.

### Re-sit / re-take policy

Students with less than 3.5 out of 10 in the final exam will have to go to the retake exam, regardless
of their performance on the other gradable items of the course.

Retakers need to join a group to do the assignments or do the assignments on their own, but they do
need to do the assignments.

Retakers do not need to deliver any homework, they will be evaluated solely based on the group
assignments and the exams.

Retakers are subject to the same midterm and final exam requirements than the rest of the students.
They also need to comply with the requirement for a grade of at least 3.5 in the final to be able to
pass the subject (otherwise the rest of their work will not be considered).

The final grade for retakers will be computed as:

- 30 % Midterm exam
- 30 % Final exam
- 40 % Group assignments (it is therefore very important that retakers find a good group for the
  assignments)

---

## Bibliography

### Compulsory

**Forecasting: Principles and Practice**, 3rd edition — Hyndman, R.J. & Athanasopoulos, G. OTexts.
Digital. Free online at <https://otexts.com/fpp3/>.

Sections covered: 1.1–1.7, 2.1–2.9, 3.1–3.4, 3.6, 5.1–5.8, 5.10, 8.1–8.7.

**Time Series: A Data Analysis Approach Using R** — Shumway, R.H. & Stoffer, D.S. CRC Press, 2019.
Digital. Used in Session 2 for the stochastic-process framing of a time series.

### Recommended

**Time Series Analysis and Its Applications: With R Examples**, 4th edition — Shumway, R.H. &
Stoffer, D.S. Springer, 2017. Digital. The edition cited as "(Shumway and Stoffer, 2017)" above.

---

## Behavior, attendance and ethics

Please check the University's **Academic Integrity Policy**, **Attendance Policy** and **Student Code
of Conduct**. The Program Director may provide further indications.
