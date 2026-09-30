# ============================================================
# Source: 03_A_TSGraphs_Timeplots_Scatterplots_Seasonalplots.qmd
# ============================================================

library(fpp3)
library(fma)
library(readr)

library(fpp3)

library(patchwork) # Arrange ggplots relative to each other
library(GGally)
library(fma) # loads the US treasury bills dataset

aus_production

aus_production |>

  # Filter data to show appropriate timeframe
  filter((year(Quarter) >= 1980 & year(Quarter)<= 2000)) |>

  # scale_x_yearquarter: the index is a yearquarter column
  autoplot(Electricity) +
  scale_x_yearquarter(date_breaks = "1 year",
                      minor_breaks = "1 year") +

  theme(axis.text.x = element_text(angle = 90))

aus_production |>

  filter((year(Quarter) >= 1980 & year(Quarter)<= 2000)) |>

  # The two lines below are equivalent to autoplot(Electricity)
  ggplot(aes(x = Quarter, y = Electricity)) +
  geom_line() +

  scale_x_yearquarter(date_breaks = "1 year",
                      minor_breaks = "1 year") +

  theme(axis.text.x = element_text(angle = 90))

aus_production |>
  autoplot(Bricks)

ustreas

ustreas_tsibble <- as_tsibble(ustreas)
ustreas_tsibble

autoplot(ustreas_tsibble)

ustreas_tsibble |> head(5)

# Sequence for major ticks, from 0 to the maximum index in the data
major_ticks_seq = seq(0, max(ustreas_tsibble$index), 10)
major_ticks_seq

# Sequence for minor ticks, from 0 to the maximum index in the data
minor_ticks_seq = seq(0, max(ustreas_tsibble$index), 5)
minor_ticks_seq

ustreas_tsibble |>
  autoplot() +
  scale_x_continuous(breaks = major_ticks_seq,
                     minor_breaks = minor_ticks_seq)

pelt |> head(5)

lynx <- pelt |> select(Year, Lynx)
lynx |> head(5)

hsales_ts <- hsales |> as_tsibble()

class(taylor)

# Column index represented as a double! This is not what we want.
taylor |> as_tsibble()

# Taylor series: half-hourly data starting 2000-06-05, assumed UTC.
start_time <- as.POSIXct("2000-06-05 00:00:00", tz = "UTC")

# Samples every half hour = every 1800 seconds (the smallest unit of
# start_time is seconds), matching the length of the taylor object.
datetime_seq <- start_time + seq(from = 0, by = 1800, length.out = length(taylor))

# Convert the time series to a tsibble
taylor_ts <-
  tibble(
    index = datetime_seq,
    value = as.numeric(taylor)
  ) |>
  as_tsibble(index = index)

taylor_ts

autoplot(taylor_ts)

# Auxiliary column with the yearweek of each point
taylor_ts <-
  taylor_ts |>
  mutate(
    week = yearweek(index)
  )

# First week and 4th week
week1 <- taylor_ts$week[1]
week4 <- week1 + 3

# Filter for the first four weeks
taylor_ts_4w <-
  taylor_ts |>
    filter(
      week >= week1,
      week <= week4
    )

taylor_ts_4w |>

  autoplot() +

  # Index is date-time
  scale_x_datetime(
    breaks = "1 week",
    minor_breaks = "1 day"
  )

vic_elec |> head(5)

elec_jan <- vic_elec |>
              mutate(month = yearmonth(Time)) |>
              filter(month == yearmonth("2012 Jan"))

elec_jan_daily <-
  elec_jan |>
    index_by(date = as_date(Time)) |>
    summarize(
      daily_demand = sum(Demand)
    )

elec_jan_daily

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>

  # Notice the -> operator works as well as <-
  mutate(Cost = TotalC / 1e6) -> a10

a10 |> head(5)

autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales") +
  scale_x_yearmonth(breaks = "1 year") +
  theme(axis.text.x = element_text(angle = 90))

vic_elec

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

# Requires GGally. Stacks the plots, matching the x-axes.
p1 / p2

vic_elec |>
  filter(year(Time) == 2014) |>
  ggplot(aes(x = Temperature, y = Demand)) +

  geom_point() +

  # Linear trend line
  geom_smooth(method = "lm", se = FALSE) +

  # Non-linear trend line
  geom_smooth(method = "loess", color = "red", se = FALSE) +

  labs(x = "Temperature (degrees Celsius)",
       y = "Electricity demand (GW)")

df <- tibble(
              x = seq(-4, 4, 0.05),
              y = x^2
            )

df |>
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

cor(df$x, df$y)

# Correlation coefficient
round(cor(vic_elec$Temperature, vic_elec$Demand), 2)

visitors <- tourism |>
  group_by(State) |>
  summarise(Trips = sum(Trips))

visitors

distinct(visitors, State)

visitors |>
  pivot_wider(values_from=Trips, names_from=State)

visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9) +
  theme(axis.text.x = element_text(angle = 90))

visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9, lower = list(continuous = wrap("smooth_loess", color="lightblue"))) +
  theme(axis.text.x = element_text(angle = 90))

soi_recruitment <-
   read_csv("../../data/soi_recruitment.csv") |>
   mutate(ym = yearmonth(index)) |>
   select(ym, SOI, recruitment) |>
   as_tsibble(index = ym)

# Compute desired lags
for (i in seq(1, 8)) {
  lag_name <- paste0("SOI_l", i)
  soi_recruitment[[lag_name]] = lag(soi_recruitment[["SOI"]], i)
}

# Reorder
soi_recruitment <-
  soi_recruitment |>
  select(ym, recruitment, everything())

# Compute desired lags
for (i in seq(1, 8)) {
  lag_name <- paste0("SOI_l", i)
  soi_recruitment[[lag_name]] = lag(soi_recruitment[["SOI"]], i)
}

# Reorder
soi_recruitment <-
  soi_recruitment |>
  select(ym, recruitment, everything())

soi_recruitment

# Exercise: generate the scatterplot matrix of recruitment against SOI
# and its lags (SOI_l1 to SOI_l8). Do you detect any non-linear
# relationship that the correlation coefficient does not capture?

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>

  # Notice the -> operator works as well as <-
  mutate(Cost = TotalC / 1e6) -> a10

a10

autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales") +
  scale_x_yearmonth(breaks = "1 year") +
  theme(axis.text.x = element_text(angle = 90))

a10 |>
  gg_season(Cost, labels = "both") + # Labels -> "both", "right", "left"
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")

head(vic_elec)
tail(vic_elec)

vic_elec |> gg_season(Demand, period = "day") +
  theme(legend.position = "none") +
  labs(y="MWh", title="Electricity demand: Victoria")

vic_elec |> gg_season(Demand, period = "week") +
  theme(legend.position = "none") +
  labs(y="MWh", title="Electricity demand: Victoria")

vic_elec |> gg_season(Demand, period = "year") +
  labs(y="MWh", title="Electricity demand: Victoria")

aus_arrivals

a10

a10 |>
  gg_subseries(Cost) +
  labs(
    y = "$ (millions)",
    title = "Australian antidiabetic drug sales",
  )

a10 |>
  gg_subseries(Cost, period = "year") +
  labs(
    y = "$ (millions)",
    title = "Australian antidiabetic drug sales",
  )

head(vic_elec)
tail(vic_elec)
