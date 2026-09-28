# Session 05 - Decomposition schemes: additive vs multiplicative
#
# Runnable companion to the notebook 05_A_TSDecomposition_Intro
# in this folder. The notebook carries the explanations; this script
# carries the code, and stops where the homework begins.
#
# RStudio: Session > Set Working Directory > To Source File Location

library(fpp3)


# ---- 1. The two schemes ----

# The additive case: US retail employment

us_retail_employment <- us_employment |>
  filter(year(Month) >= 1990, Title == "Retail Trade") |>
  select(-Series_ID)

us_retail_employment

autoplot(us_retail_employment, Employed) +
  labs(y = "Persons (thousands)",
       title = "Total employment in US retail")

dcmp_components <-
  us_retail_employment |>
  model(stl = STL(Employed)) |>
  components()

dcmp_components

dcmp_components |>
  as_tsibble() |>
  autoplot(Employed, colour = "gray") +
  geom_line(aes(y = trend), colour = "#D55E00") +
  labs(y = "Persons (thousands)",
       title = "Total employment in US retail")

dcmp_components |> autoplot()


# The multiplicative case: Australian antidiabetic drugs

a10 <-
  PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  index_by(Month) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC / 1e6)

a10

autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

x11_dcmp <-
  a10 |>
  model(x11 = X_13ARIMA_SEATS(Cost ~ x11())) |>
  components()

x11_dcmp

x11_dcmp |>
  as_tsibble() |>
  autoplot(Cost, colour = "gray") +
  geom_line(aes(y = trend), colour = "#D55E00") +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

x11_dcmp |> autoplot()


# ---- 2. Transformations ----

a10 <- a10 |>
  mutate(
    sqrt_cost = sqrt(Cost),
    cbrt_cost = Cost^(1 / 3),
    log_cost  = log(Cost),
    inv_cost  = -1 / Cost
  )

a10

transformations <- c(
  sqrt_cost = "square root",
  cbrt_cost = "cubic root",
  log_cost  = "logarithm",
  inv_cost  = "inverse"
)

for (col in names(transformations)) {

  # sym() turns the string into a name; !! splices it into the call.
  dcmp <- a10 |>
    model(stl = STL(!!sym(col)))

  print(
    components(dcmp) |>
      as_tsibble() |>
      autoplot(.data[[col]], colour = "gray") +
      geom_line(aes(y = trend), colour = "#D55E00") +
      labs(y = col,
           title = paste0("a10 under a ", transformations[[col]],
                          " transformation"))
  )
}


# ---- 3. Checking a hand computation against R ----

0.1 + 0.2 == 0.3

print(0.1 + 0.2, digits = 20)

all.equal(0.1 + 0.2, 0.3)

all.equal(c(1, 2, 3), c(1, 2, 3.3))

class(all.equal(c(1, 2, 3), c(1, 2, 3.3)))

# Errors, because a sentence is not a condition:
#   if (all.equal(1, 1.5)) "same" else "different"

isTRUE(all.equal(1, 1.5))
isTRUE(all.equal(0.1 + 0.2, 0.3))


# ---- 4. Detrended and seasonally adjusted series ----

# The additive fit
classical_add <-
  us_retail_employment |>
  model(dcmp = classical_decomposition(Employed, type = "additive")) |>
  components()

classical_add

# The multiplicative fit
classical_mult <-
  a10 |>
  model(dcmp = classical_decomposition(Cost, type = "multiplicative")) |>
  components()

classical_mult


# ---- Homework, due Sunday 27 September ----
# Reproduce notebook Examples 1 and 2 and type the code yourself.
# The slides and the notebook carry the full instructions.

# Example 1, on classical_add: the detrended series, the
# seasonally adjusted series, both plots, and the check against
# R's season_adjust column.

# Example 2, on classical_mult: same steps, with every
# subtraction replaced by a division.
