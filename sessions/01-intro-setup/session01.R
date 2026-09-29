# Session 01 - Course intro, what forecasting is, local install day
# Companion to 01_Introduction_UseCase.html: the notebook carries the
# explanations, this script carries the code. Open tsa.Rproj first, and
# run it one section at a time. No data files are needed.

# ---- 0. check your setup ----
# Run this first. It reports what is installed; it installs nothing.

cat("R version :", R.version.string, "\n")
cat("Platform  :", R.version$platform, "\n")
cat("Library   :", .libPaths()[1], "\n\n")

core <- c("fpp3", "tsibble", "tsibbledata", "feasts", "fable",
          "dplyr", "ggplot2", "lubridate", "tidyr")

# Separate installs: install.packages("fpp3") does NOT include these.
# tidyverse, nycflights13, babynames are needed by the R primer
# (self-study/00-r-basics/); urca by ARIMA(); the rest by later sessions.
extra <- c("tidyverse", "nycflights13", "babynames",
           "urca",
           "GGally", "fma", "patchwork",
           "cowplot", "seasonal")

report_packages <- function(pkgs, label) {
  have <- pkgs %in% rownames(installed.packages())
  out <- data.frame(
    package = pkgs,
    status  = ifelse(have, "OK", "MISSING"),
    version = vapply(pkgs, function(p) {
      tryCatch(as.character(utils::packageVersion(p)),
               error = function(e) "-")
    }, character(1)),
    row.names = NULL
  )
  cat(label, "\n")
  print(out, right = FALSE)
  cat("\n")
  pkgs[!have]
}

missing_core  <- report_packages(core,  "Core toolkit (from install.packages(\"fpp3\")):")
missing_extra <- report_packages(extra, "Course packages (installed separately):")

if (length(missing_core) > 0) {
  cat(">>> MISSING from the core toolkit:", paste(missing_core, collapse = ", "), "\n")
  cat(">>> Run:  install.packages(\"fpp3\")\n")
  cat(">>> Then restart R (Session > Restart R) and re-run this section.\n")
}
if (length(missing_extra) > 0) {
  cat(">>> MISSING:", paste(missing_extra, collapse = ", "), "\n")
  cat(">>> Run:  install.packages(c(",
      paste0("\"", missing_extra, "\"", collapse = ", "), "))\n", sep = "")
}
if (length(missing_core) == 0 && length(missing_extra) == 0) {
  cat(">>> Everything is installed. Continue to section 1.\n")
}

if (getRversion() < "4.2.0") {
  warning("Your R is older than 4.2. Please upgrade - see setup/SETUP.md")
}


# ---- 1. what is a time series? ----

library(fpp3)

global_economy

spain_economy <-
  global_economy |>
  filter(Country == "Spain")

spain_economy

major_ticks_seq <- seq(0, max(spain_economy$Year), 10)
minor_ticks_seq <- seq(0, max(spain_economy$Year), 5)

spain_economy |>
  autoplot(Population) +
  scale_x_continuous(breaks       = major_ticks_seq,
                     minor_breaks = minor_ticks_seq) +
  labs(title = "Population of Spain",
       y     = "People",
       x     = "Year")


# ---- 2. why bother? forecasting many series at once ----
# A preview of where the course is going; not something to understand today.

# as_tibble() drops the time index, so distinct() works as in ordinary dplyr.
global_economy |>
  as_tibble() |> # <-- without this line, the result of "nrow()" is wrong.
  select(Country) |>
  distinct() |>
  nrow()

populations <-
  global_economy |>
  mutate(Pop = Population / 1e6) |>
  select(Country, Year, Pop)

populations

demo_countries <- c("Spain", "Germany", "Japan", "Brazil", "Nigeria")

populations_demo <-
  populations |>
  filter(Country %in% demo_countries)

# ARIMA() needs the urca package. If urca is missing we fit ETS on its own.
if (requireNamespace("urca", quietly = TRUE)) {
  fit <-
    populations_demo |>
    model(
      ets   = ETS(Pop),
      arima = ARIMA(Pop)
    )
} else {
  message("urca is not installed, so ARIMA() is being skipped. ",
          "Run install.packages(\"urca\") and re-run this section to include it.")
  fit <-
    populations_demo |>
    model(
      ets = ETS(Pop)
    )
}

fit

fc <- fit |> forecast(h = 4)

fc

spain_fc   <- fc               |> filter(Country == "Spain")
spain_hist <- populations_demo |> filter(Country == "Spain")

spain_fc |>
  autoplot(level = NULL) +
  labs(title = "Spain - point forecasts only")

spain_fc |>
  autoplot(level = 95, alpha = 0.6) +
  labs(title = "Spain - 95% prediction interval")

spain_fc |>
  autoplot(spain_hist, level = 95, alpha = 0.6) +
  labs(title = "Spain - population forecast",
       y     = "Millions of people")

germany_fc   <- fc               |> filter(Country == "Germany")
germany_hist <- populations_demo |> filter(Country == "Germany")

germany_fc |>
  autoplot(germany_hist, level = 95, alpha = 0.6) +
  labs(title = "Germany - population forecast",
       y     = "Millions of people")


# ---- 3. if something went wrong ----
# Uncomment and run the one you need. Full guide: setup/SETUP.md

# Where is R installing packages, and can it write there?
# .libPaths()
# file.access(.libPaths()[1], mode = 2)    # 0 = writable, -1 = not writable

# A package is installed but will not load? Usually a half-finished install.
# install.packages("fpp3", dependencies = TRUE)

# Stuck at a prompt that says "Selection:" or "Enter an item from the menu"?
# Type 0 and press Enter, or press Esc, to get back to the > prompt.

# Everything about your setup in one block. If you ask for help, paste this in.
# sessionInfo()


# ---- 4. the finish line ----
# Session 1 is done when fpp3 loads and you can plot a series.

library(fpp3)

aus_production |>
  autoplot(Beer) +
  labs(title    = "My first time series plot",
       subtitle = "Australian quarterly beer production",
       y        = "Megalitres")


# ---- homework, due before Session 2 ----
#
#   1. Work through these, in order, in self-study/00-r-basics/ :
#        00_A_1_Intro
#        00_A_2_BasicTypes_Operators
#        00_A_3_Lists_Vectors
#        00_A_4_conditionals_forloops
#        00_B_1_tibbles_dplyr_fundamentals
#
#   2. Confirm that library(fpp3) loads on your own machine without errors.
#
# Submit on Blackboard. Write the code yourself: the course policy on
# generative AI is strict, and it is in SYLLABUS.md.
