# Session 06 - Moving averages and trend estimation
#
# Runnable companion to the notebook 06_B_MovingAverages_TrendEstimation
# in this folder. The notebook carries the explanations; this script
# carries the code, and stops where the homework begins.
#
# RStudio: Session > Set Working Directory > To Source File Location

library(fpp3)


# ---- 1. A 7-MA of Australian exports ----

aus_exports <-
  global_economy |>
  filter(Country == "Australia") |>
  mutate(
    `7-MA` = slider::slide_dbl(Exports, mean,
                               .before = 3, .after = 3, .complete = TRUE)
  ) |>
  select(Country, Code, Year, Exports, `7-MA`)

aus_exports


# Check the first value by hand: the fourth element is the first
# one a complete window can reach.
all.equal(mean(aus_exports$Exports[1:7]), aus_exports$`7-MA`[[4]])
isTRUE(all.equal(mean(aus_exports$Exports[1:7]), aus_exports$`7-MA`[[4]]))


aus_exports |>
  autoplot(Exports) +
  geom_line(aes(y = `7-MA`), colour = "#D55E00") +
  labs(y = "% of GDP",
       title = "Total Australian exports")


# ---- 2. Window sizes: 3-MA through 13-MA ----

aus_exports <- global_economy |> filter(Country == "Australia")

for (i in seq(3, 13, by = 2)) {
  col_name <- paste0(as.character(i), "-MA")
  width <- (i - 1) / 2

  aus_exports[[col_name]] <- slider::slide_dbl(
    aus_exports$Exports, mean,
    .before = width, .after = width, .complete = TRUE
  )
}

aus_exports <- aus_exports |>
  select(Exports, `3-MA`, `5-MA`, `7-MA`, `9-MA`, `11-MA`, `13-MA`)

aus_exports

# (m - 1) / 2 values missing at each end.
colSums(is.na(as_tibble(aus_exports)))

aus_exports |>
  autoplot(Exports, colour = "gray") +
  geom_line(aes(y = `3-MA`), colour = "#D55E00") +
  geom_line(aes(y = `13-MA`), colour = "#0072B2") +
  labs(y = "% of GDP",
       title = "Australian exports: 3-MA in orange, 13-MA in blue")


# ---- 3. Even windows: the 2x4-MA of quarterly beer ----

beer <- aus_production |>
  filter(year(Quarter) >= 1992) |>
  select(Quarter, Beer)

beer <- beer |>
  mutate(
    `4-MA_R` = slider::slide_dbl(Beer, mean,
                                 .before = 1, .after = 2, .complete = TRUE),
    `4-MA_L` = slider::slide_dbl(Beer, mean,
                                 .before = 2, .after = 1, .complete = TRUE),
    `2x4-MA` = 0.5 * (`4-MA_R` + `4-MA_L`)
  )

beer |> select(Quarter, Beer, `4-MA_R`, `4-MA_L`, `2x4-MA`) |> head(5)
beer |> select(Quarter, Beer, `4-MA_R`, `4-MA_L`, `2x4-MA`) |> tail(5)

beer |>
  autoplot(Beer) +
  geom_line(aes(y = `2x4-MA`), colour = "#D55E00") +
  labs(y = "Production of beer (megalitres)",
       title = "Production of beer in Australia from 1992")


# The same 2x4-MA, built from the weights. The two must agree.
beer <- beer |>
  mutate(
    `2x4-MA_weights` =
      (1 / 8) * lag(Beer, 2) +
      (1 / 4) * lag(Beer, 1) +
      (1 / 4) * Beer +
      (1 / 4) * lead(Beer, 1) +
      (1 / 8) * lead(Beer, 2)
  )

isTRUE(all.equal(beer$`2x4-MA`, beer$`2x4-MA_weights`))


# ---- 4. One-sided moving averages ----

aus_exports_sided <-
  global_economy |>
  filter(Country == "Australia") |>
  mutate(
    `7-MA_left`  = slider::slide_dbl(Exports, mean,
                                     .before = 6, .after = 0, .complete = TRUE),
    `7-MA_right` = slider::slide_dbl(Exports, mean,
                                     .before = 0, .after = 6, .complete = TRUE)
  ) |>
  select(Year, Exports, `7-MA_left`, `7-MA_right`)

aus_exports_sided

aus_exports_sided |>
  autoplot(Exports, colour = "gray") +
  geom_line(aes(y = `7-MA_left`), colour = "#D55E00") +
  geom_line(aes(y = `7-MA_right`), colour = "#0072B2") +
  labs(y = "% of GDP",
       title = "Australian exports: left MA in orange, right MA in blue")


# ---- Homework: exercises 1, 3 and 4, due Sunday 27 September ----
# Exercise 2 is optional practice. The notebook and the slides
# carry the full instructions for each.

# Exercise 1: the 2x12-MA of US retail employment
us_retail_employment <-
  us_employment |>
  filter(year(Month) >= 1990, Title == "Retail Trade") |>
  select(-Series_ID)

us_retail_employment

# YOUR TURN: compute the 2x12-MA of Employed and plot it over the
# series. How many points are missing at each end, and why?

# Exercise 2 (optional): a 2x4-MA of quarterly demand from vic_elec

# Exercise 3 (on paper): the weights of a 3x7-MA

# Exercise 4 (on paper): the weights of a 2x8-MA
