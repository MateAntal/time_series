# R code from the 09_B_ResidualsAnalysis notebook, in notebook order.

# Libraries ----
library(fpp3)
library(patchwork)

# Example 1: brick production ----
bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |> # Shorthand for filtering data between 1970 and 2004
  select(Bricks)

bricks_fit <- bricks |> model(
                                Mean = MEAN(Bricks), # Fit two models at once
                                Nv = NAIVE(Bricks)
                               )

bricks_fit

model_vals <-
  bricks_fit |>
  augment()

model_vals

## Mean model ----
model_vals |> 
  filter(.model == "Mean") |>
  autoplot(Bricks, colour = "gray") +
  geom_line(aes(y=.fitted), colour = "blue", linetype = "dashed")

### Residual panels ----
bricks_fit |> 
  select(Mean) |> # Selects the Mean model
  gg_tsresiduals()

# Compute the mean of the residuals
model_vals |> as_tibble() |>
  filter(.model == "Mean") |>
  summarise(mean = mean(.innov, na.rm = TRUE))

### QQ plot and boxplot ----
mean_vals <- filter(model_vals, .model=="Mean")

# QQ plot
p1 <- ggplot(mean_vals, aes(sample = .innov))
p1 <- p1 + stat_qq() + stat_qq_line()

# Boxplot
p2 <- ggplot(data = mean_vals, aes(y = .innov)) +
      geom_boxplot(fill="light blue", alpha = 0.7) +
      stat_summary(aes(x=0), fun="mean", colour= "red") # Include the mean

p1 + p2

### Boxplots by year ----
model_vals <- 
  
  model_vals |> 
  
  # Add a column with the year of each observation
  mutate(
    year = year(Quarter),
    year_group = floor((year - 1970) / 2) * 2 + 1970 # Group two consecutive years
  ) 
  
# One boxplot per year
model_vals |> 
  
  # Select the appropriate model within model vals
  filter(.model == "Mean") |> 
  
  # Draw the boxplots
  ggplot(aes(x = factor(year), y = .innov)) +
  geom_boxplot() +
  theme(axis.text.x=element_text(angle = 90))

model_vals |> 
  
  # Select the appropriate model within model vals
  filter(.model == "Mean") |> 
  
  # Draw the boxplots
  ggplot(aes(x = factor(year_group), y = .innov)) +
  geom_boxplot() +
  theme(axis.text.x=element_text(angle = 90))

## Naive model ----

### Residual panels ----
bricks_fit |> 
  select(Nv) |>
  gg_tsresiduals()

# Compute the mean of the residuals
model_vals |> as_tibble() |>
  filter(.model == "Nv") |>
  summarise(mean = mean(.innov, na.rm = TRUE))

### QQ plot and boxplot ----
mean_vals <- filter(model_vals, .model=="Nv")

# QQ plot
p1 <- ggplot(mean_vals, aes(sample = .innov))
p1 <- p1 + stat_qq() + stat_qq_line()

# Boxplot
p2 <- ggplot(data = mean_vals, aes(y = .innov)) +
      geom_boxplot(fill="light blue", alpha = 0.7) +
      stat_summary(aes(x=0), fun="mean", colour= "red") # Include the mean

p1 + p2

### Boxplots by year ----
model_vals <- 
  
  model_vals |> 
  
  # Add a column with the year of each observation
  mutate(
    year = year(Quarter),
    year_group = floor((year - 1970) / 2) * 2 + 1970 # Group two consecutive years
  )
  
  
# One boxplot per year
model_vals |> 
  
  # Select the appropriate model within model vals
  filter(.model == "Nv") |> 
  
  ggplot(aes(x = factor(year), y = .innov)) +
  geom_boxplot() +
  theme(axis.text.x=element_text(angle = 90))

model_vals |> 
  
  # Select the appropriate model within model vals
  filter(.model == "Nv") |> 
  
  ggplot(aes(x = factor(year_group), y = .innov)) +
  geom_boxplot() +
  theme(axis.text.x=element_text(angle = 90))

# Example 2: Google stock ----
# Re-index based on trading days
google_stock <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) >= 2015) |>
  mutate(day = row_number()) |>
  update_tsibble(index = day, regular = TRUE)

# Filter the year of interest
google_2015 <- google_stock |> filter(year(Date) == 2015)

# Fit the models
google_fit <- google_2015 |>
  model(
    Mean = MEAN(Close),
    Naive = NAIVE(Close)
  )

# Extract values from the mable:
model_vals <- google_fit |> augment()

# Plot fitted values for the NAIVE model:
model_vals |> 
  filter(.model == "Naive") |>
  autoplot(Close, colour = "gray") +
  geom_line(aes(y=.fitted), colour = "blue", linetype = "dashed")

## Naive model ----
google_fit |> 
  select(Naive) |> # Selects the Naive model
  gg_tsresiduals()

# Compute the mean of the residuals
model_vals |> as_tibble() |>
  filter(.model == "Naive") |>
  summarise(mean = mean(.innov, na.rm = TRUE))

mean_vals <- filter(model_vals, .model=="Naive")

# QQ plot
p1 <- ggplot(mean_vals, aes(sample = .innov))
p1 <- p1 + stat_qq() + stat_qq_line()

# Boxplot
p2 <- ggplot(data = mean_vals, aes(y = .innov)) +
      geom_boxplot(fill="light blue", alpha = 0.7) +
      stat_summary(aes(x=0), fun="mean", colour= "red") # Include the mean

p1 + p2

## Mean model ----
google_fit |> 
  select(Mean) |> # Selects the Mean model
  gg_tsresiduals()

# Compute the mean of the residuals
model_vals |> as_tibble() |>
  filter(.model == "Mean") |>
  summarise(mean = mean(.innov, na.rm = TRUE))

mean_vals <- filter(model_vals, .model=="Mean")

# QQ plot
p1 <- ggplot(mean_vals, aes(sample = .innov))
p1 <- p1 + stat_qq() + stat_qq_line()

# Boxplot
p2 <- ggplot(data = mean_vals, aes(y = .innov)) +
      geom_boxplot(fill="light blue", alpha = 0.7) +
      stat_summary(aes(x=0), fun="mean", colour= "red") # Include the mean

p1 + p2

# Portmanteau tests for autocorrelation ----

## Running the test ----
bricks_aug <- bricks_fit |> augment()

bricks_aug |> filter(.model == "Nv") |> features(.innov, box_pierce, lag = 8, dof = 0)

bricks_aug |> filter(.model == "Nv") |> features(.innov, ljung_box, lag = 8, dof = 0)
bricks_aug |> filter(.model == "Mean") |> features(.innov, ljung_box, lag = 8, dof = 1)

# Exercise 1 ----
retail_series <- aus_retail |>
  filter(`Series ID` == "A3349767W") 

retail_series |> autoplot()

fit_dcmp <- retail_series |> 
  model(
    decomp = decomposition_model(
                # Specify the decomposition scheme to be used.
                STL(log(Turnover)),
                # Specify a model for the seasonally adjusted component (in this case, a drift).
                RW(season_adjust ~ drift()),
                # Specify a model for the seasonal component (unnecessary, since SNAIVE is the default).
                SNAIVE(season_year)
            )
  )

fit_dcmp

# Exercise 2 ----
aus_exports <- filter(global_economy, Country == "Australia")
