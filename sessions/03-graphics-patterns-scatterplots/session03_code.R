# ============================================================
# Source: 03_A_TSGraphs_Timeplots_Scatterplots_Seasonalplots.qmd
# ============================================================


# ---- cell 1 ----
library(fpp3)
library(fma)
library(readr)

# ---- cell 2 ----
library(fpp3)

# ---- cell 3 ----
library(patchwork) # Used to manage the relative location of ggplots
library(GGally)
library(fma) # to load the Us treasury bills dataset

# ---- cell 4 ----
aus_production

# ---- cell 5 ----
aus_production |>
  
  # Filter data to show appropriate timeframe
  filter((year(Quarter) >= 1980 & year(Quarter)<= 2000)) |>
  
  # autoplot generates a simple time plot, to be adjusted with
  # further commands.
  autoplot(Electricity) + 
  
  # Scale the x axis adequately
  # scale_x_yearquarter used because the index is a yearquarter column
  scale_x_yearquarter(date_breaks = "1 year",
                      minor_breaks = "1 year") +
  
  # Flip x-labels by 90 degrees
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 6 ----
aus_production |> 
  
  filter((year(Quarter) >= 1980 & year(Quarter)<= 2000)) |>
  
  # The two lines below are equivalent to autoplot(Electricity)
  ggplot(aes(x = Quarter, y = Electricity)) + 
  geom_line() +
  
  # Scale the x axis adequately
  # scale_x_yearquarter used because the index is a yearquarter column
  scale_x_yearquarter(date_breaks = "1 year",
                      minor_breaks = "1 year") +
  
  # Flip x-labels by 90 degrees
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 7 ----
aus_production |> 
  autoplot(Bricks)

# ---- cell 8 ----
ustreas

# ---- cell 9 ----
ustreas_tsibble <- as_tsibble(ustreas)
ustreas_tsibble

# ---- cell 10 ----
autoplot(ustreas_tsibble)

# ---- cell 11 ----
ustreas_tsibble |> head(5)

# ---- cell 12 ----
# Sequence for major ticks, from 0 to the maximum index in the data
major_ticks_seq = seq(0, max(ustreas_tsibble$index), 10)
major_ticks_seq

# ---- cell 13 ----
# Sequence for minor ticks, from 0 to the maximum index in the data
minor_ticks_seq = seq(0, max(ustreas_tsibble$index), 5)
minor_ticks_seq

# ---- cell 14 ----
ustreas_tsibble |>
  autoplot() +
  scale_x_continuous(breaks = major_ticks_seq,
                     minor_breaks = minor_ticks_seq)

# ---- cell 15 ----
pelt |> head(5)

# ---- cell 16 ----
lynx <- pelt |> select(Year, Lynx)
lynx |> head(5)

# ---- cell 17 ----
hsales_ts <- hsales |> as_tsibble()

# ---- cell 18 ----
class(taylor)

# ---- cell 19 ----
# Column index represented as a double! This is not what we want.
taylor |> as_tsibble()

# ---- cell 20 ----
# Define the start time based on information about the Taylor series
# Assume UTC time.
start_time <- as.POSIXct("2000-06-05 00:00:00", tz = "UTC")

# We set by = 1800 because the smallest unit in the date-time object
# start_time is seconds (hh:mm:ss). The samples in this ts object are taken
# every half hour, that is, every 1800 seconds (30 * 60).
# We also set the sequence to the same length as the taylor object.
datetime_seq <- start_time + seq(from = 0, by = 1800, length.out = length(taylor))

# Convert the time series to a tsibble
taylor_ts <- 
  tibble(
    index = datetime_seq,
    value = as.numeric(taylor)
  ) |>
  as_tsibble(index = index)

# Check the resulting tsibble
taylor_ts

# ---- cell 21 ----
autoplot(taylor_ts)

# ---- cell 22 ----
# Create an auxiliary column with the yearweek corresponding to
# each point in the time series.
taylor_ts <- 
  taylor_ts |> 
  mutate(
    week = yearweek(index)
  )

# Extract first week and compute 4th week
week1 <- taylor_ts$week[1]
week4 <- week1 + 3

# Filter for first four weeks and store in new object
taylor_ts_4w <- 
  taylor_ts |> 
    filter(
      week >= week1, 
      week <= week4
    )

# Show the result
taylor_ts_4w |> 
  
  autoplot() + 
  
  # Used because index is date-time
  scale_x_datetime(
    breaks = "1 week",
    minor_breaks = "1 day"
  )

# ---- cell 23 ----
vic_elec |> head(5)

# ---- cell 24 ----
elec_jan <- vic_elec |>
              mutate(month = yearmonth(Time)) |>
              filter(month == yearmonth("2012 Jan"))

# ---- cell 25 ----
elec_jan_daily <- 
  elec_jan |> 
    index_by(date = as_date(Time)) |> 
    summarize(
      daily_demand = sum(Demand)
    )

# Inspect result
elec_jan_daily

# ---- cell 26 ----
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  
  # Remove zeroes to the right if we don't need that resolution
  # Notice the -> operator works as well as <-
  mutate(Cost = TotalC / 1e6) -> a10

# ---- cell 27 ----
a10 |> head(5)

# ---- cell 28 ----
autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales") +
  scale_x_yearmonth(breaks = "1 year") +
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 29 ----
vic_elec

# ---- cell 30 ----
p1 <- vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Demand) +
  labs(y = "GW",
       title = "Half-hourly electricity demand: Victoria")

p2 <- vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Temperature) +
  labs(
    y = "Degrees Celsius",
    title = "Half-hourly temperatures: Melbourne, Australia"
  )

# Requires GGally. Places one graph above the other, ensuring proper
# matching of the x-axis.
p1 / p2

# ---- cell 31 ----
vic_elec |>
  filter(year(Time) == 2014) |>
  ggplot(aes(x = Temperature, y = Demand)) +
  
  geom_point() +
  
  # Linear trend line
  geom_smooth(method = "lm", se = FALSE) +
  
  # Non-linear trend line
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  
  # Labels
  labs(x = "Temperature (degrees Celsius)",
       y = "Electricity demand (GW)")

# ---- cell 32 ----
df <- tibble(
              x = seq(-4, 4, 0.05),
              y = x^2
            )

df |>
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# ---- cell 33 ----
cor(df$x, df$y)

# ---- cell 34 ----
# Compute correlation coefficient
round(cor(vic_elec$Temperature, vic_elec$Demand), 2)

# ---- cell 35 ----
visitors <- tourism |>
  group_by(State) |>
  summarise(Trips = sum(Trips))

visitors

# ---- cell 36 ----
# Check the distinct values of the State column
distinct(visitors, State)

# ---- cell 37 ----
visitors |>
  pivot_wider(values_from=Trips, names_from=State)

# ---- cell 38 ----
visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9) + 
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 39 ----
visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9, lower = list(continuous = wrap("smooth_loess", color="lightblue"))) + 
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 40 ----
soi_recruitment <- 
   read_csv("../../data/soi_recruitment.csv") |> 
   mutate(ym = yearmonth(index)) |> 
   select(ym, SOI, recruitment) |> 
   as_tsibble(index = ym)

# Compute lags
for (i in seq(1, 8)) {
  lag_name <- paste0("SOI_l", i)
  soi_recruitment[[lag_name]] = lag(soi_recruitment[["SOI"]], i)
}

# Reorder
soi_recruitment <- 
  soi_recruitment |> 
  select(ym, recruitment, everything())

# ---- cell 41 ----
# Compute desired lags
for (i in seq(1, 8)) {
  lag_name <- paste0("SOI_l", i)
  soi_recruitment[[lag_name]] = lag(soi_recruitment[["SOI"]], i)
}

# Reorder
soi_recruitment <- 
  soi_recruitment |> 
  select(ym, recruitment, everything())

# Inspect result.
soi_recruitment

# ---- cell 42 ----
# Exercise: generate the scatterplot matrix of recruitment against SOI
# and its lags (SOI_l1 to SOI_l8). Do you detect any non-linear
# relationship that the correlation coefficient does not capture?

# ---- cell 43 ----
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  
  # Comment on this assignment operator
  mutate(Cost = TotalC / 1e6) -> a10

a10

# ---- cell 44 ----
# Recall the time plot
autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales") +
  scale_x_yearmonth(breaks = "1 year") +
  theme(axis.text.x = element_text(angle = 90))

# ---- cell 45 ----
a10 |>
  gg_season(Cost, labels = "both") + # Labels -> "both", "right", "left"
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")

# ---- cell 46 ----
head(vic_elec)
tail(vic_elec)

# ---- cell 47 ----
vic_elec |> gg_season(Demand, period = "day") +
  theme(legend.position = "none") +
  labs(y="MWh", title="Electricity demand: Victoria")

# ---- cell 48 ----
vic_elec |> gg_season(Demand, period = "week") +
  theme(legend.position = "none") +
  labs(y="MWh", title="Electricity demand: Victoria")

# ---- cell 49 ----
vic_elec |> gg_season(Demand, period = "year") +
  labs(y="MWh", title="Electricity demand: Victoria")

# ---- cell 50 ----
aus_arrivals

# ---- cell 51 ----
a10

# ---- cell 52 ----
a10 |>
  gg_subseries(Cost) +
  labs(
    y = "$ (millions)",
    title = "Australian antidiabetic drug sales",
  )

# ---- cell 53 ----
a10 |>
  gg_subseries(Cost, period = "year") +
  labs(
    y = "$ (millions)",
    title = "Australian antidiabetic drug sales",
  )

# ---- cell 54 ----
head(vic_elec)
tail(vic_elec)
