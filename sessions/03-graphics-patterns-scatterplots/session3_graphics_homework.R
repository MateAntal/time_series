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
  scale_x_yearquarter(date_breaks = "2 year",
                      minor_breaks = "1 year") +
  
  # Flip x-labels by 90 degrees
  theme(axis.text.x = element_text(angle = 90))


#modified date break to 2 so the x labels are not so crowded 
#upward trend with seasonal fluctuation (likely more electricty used in winter)









# ---- cell 7 ----
aus_production |> 
  autoplot(Bricks) +

  scale_x_yearquarter(date_breaks = "4 year",
                    minor_breaks = "2 year") +
  
  # Flip x-labels by 90 degrees
  theme(axis.text.x = element_text(angle = 90))

# after experimenting with a few combinations I chose date break 4 years because I felt like it was not too overcroded like this but still detailed information
# and for minor break I chose 2 years so exact dates can be read without the too many lines a 1 year minor break would cause

#until 1981 strong upward trend then from then on downward trend with seasonal fluctuations throughout 







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


#strong downward trend with some fluctuation








# ---- cell 15 ----
pelt |> head(5)

# ---- cell 16 ----
lynx <- pelt |> select(Year, Lynx)
lynx |> head(5)

lynx_tsibble <- as_tsibble(lynx)
major_ticks <- seq(
  from = min(lynx_tsibble$Year),
  to = max(lynx_tsibble$Year),
  by = 10
)

minor_ticks <- seq(
  from = min(lynx_tsibble$Year),
  to = max(lynx_tsibble$Year),
  by = 5
)

lynx_tsibble |>
  ggplot(aes(x = Year, y = Lynx)) +
  geom_line() +
  scale_x_continuous(
    breaks = major_ticks,
    minor_breaks = minor_ticks
  )



# strong cyclic behavior (again annual data can't be seasonal), with large peaks and falls repeating around every 10 years.









# ---- cell 17 ----
hsales_ts <- hsales |> as_tsibble()

hsales_ts |> head(5)

hsales_ts |>
  autoplot(value) +
  scale_x_yearmonth(
    date_breaks = "5 years",
    date_minor_breaks = "1 year"
  )

#cyclical rises and falls over time, with big downturns around recession periods. at the same time seasonal changes can be seen as well, such as dips in every year january








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

#daily and weekly seasonality, lower on the weekends and lower at night















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

elec_jan_daily |>
  autoplot(daily_demand) +
  scale_x_date(
    date_breaks = "1 week",
    date_minor_breaks = "1 day"
  )


#fluctuates from day to day with a visible weekly pattern and lower demand on some weekends

















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

#upward trend with seasonal changes peaking in winter





