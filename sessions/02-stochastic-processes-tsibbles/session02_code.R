# ============================================================
# Source: 02_A_Dates_Times_R.html
# ============================================================

library(fpp3)
library(tidyverse)
library(nycflights13)

# Example 1
date1 <- ymd("2017-01-31")
date1

class(date1)

# Example 2
date2 <- mdy("January 31st, 2017")
date2

class(date2)

# Example 3
date3 <- dmy("31-Jan-2017")
date3

class(date3)

# Example 4 - unquoted numbers
date4 <- ymd(20170131)
class(date4)

# Example 1:
datetime1 <- ymd_hms("2017-01-31 20:11:59")
class(datetime1)

# Example 2
datetime2 <- mdy_hm("01/31/2017 08:01")
class(datetime2)

# Example 3
datetime3 <- ymd(20170131, tz = "UTC")
class(datetime3)

# Dataset from package nycflights13
flights |>
  select(year, month, day, hour, minute)

flights |>
  select(year, month, day, hour, minute) |>

  mutate(
    date = make_date(year, month, day), # Create new date column
    datetime = make_datetime(year, month, day, hour, minute) # Create date-time
  )

# Example 1:
today() # date

as_datetime(today()) #datetime

now() # datetime

as_date(now()) #date

date1 <- ymd(19700110)
date2 <- ymd(20230830)

# Number of days elapsed since "1970-01-01" and "1970-01-10"
as.integer(date1)

# Number of days elapsed since "1970-01-01" and "2023-08-30"
as.integer(date2)

# The 10th of January 1970 can therefore also be expressed as follows
as_date(9) # 9 days elapsed since 1st of January 1970

# Ten years offset in days from 1970-01-01.
# +2 accounts for two leap years
as_date(365 * 10 + 2)

# NOTE: the enclosing parentheses display the output
(ym1 <- yearmonth(ymd("2017-01-31")))

(ym2 <- yearmonth(dmy("31-Jan-2017"), format="%Y%m"))

(ym5 <- yearmonth(mdy_hm("04/20/2020 08:01")))

class(ym1)

(yq1 <- yearquarter(ymd("2017-01-31")))

class(yq1)

(yw1 <- yearweek(ymd("2017-01-31")))

class(yw1)

seq(0, 60, by = 6)

# Sequence of 6-month steps starting in January 2012, advancing 60 months
seq_months <- yearmonth("2012-01-01") + seq(0, 60, by = 6)
seq_months

# Sequence of 2-quarter steps starting in January 2012, advancing 20 quarters
seq_quarters <- yearquarter("2012-01-01") + seq(0, 20, by = 2)
seq_quarters

# Sequence of 2-week steps starting in January 2012, advancing 52 weeks
seq_weeks <- yearweek("2012-01-02") + seq(0, 52, 2)
seq_weeks

parse_datetime("2010-10-01T2010")

# If time is omitted, it is set to midnight
parse_datetime("20101010")

parse_date("2010-10-01")

parse_time("01:10 am")

parse_time("20:10:01")

parse_date("01/02/15", format = "%m/%d/%y")

parse_date("01/02/15", format = "%d/%m/%y")

parse_date("01/02/15", format = "%y/%m/%d")

datestring <- c("January 10, 2012;@ 10:40", "December 9, 2011;@ 9:10")
parse_datetime(datestring, format="%B %d, %Y;@ %H:%M")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

locale()

locale_custom <- locale(date_format = "Day %d Mon %m Year %y",
                 time_format = "Sec %S Min %M Hour %H")


date_custom <- c("Day 01 Mon 02 Year 03", "Day 03 Mon 01 Year 01")
parse_date(date_custom)

parse_date(date_custom, locale = locale_custom)

time_custom <- c("Sec 01 Min 02 Hour 03", "Sec 03 Min 02 Hour 01")
parse_time(time_custom)

parse_time(time_custom, locale = locale_custom)

d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")

d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")

d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")

t1 <- "1705"
parse_time(t1, "%H%M")

# t2 uses real seconds (seconds are a real number)
t2 <- "11:15:10.12 PM"
parse_time(t2, "%H:%M:%OS %p")

# ============================================================
# Source: 02_B_tsibbles.html
# ============================================================

library(fpp3)
library(nycflights13)

global_economy

data_1 <- tsibble(
  year = 2012:2016,
  y = c(123, 39, 78, 52, 110),
  index = year
)
data_1

data_1 <- tibble(
  year = 2012:2016,
  y = c(123, 39, 78, 52, 110)
) |>
as_tsibble(index = year)

data_1

flights_ts <-
  flights |>

  # Select columns of interest
  select(year, carrier, flight, month, day, hour, minute, distance) |>

  # Create timestamp
  mutate(time = make_datetime(year, month, day, hour, minute)) |>

  # Drop columns
  select(time, everything(), -c(year, month, day, hour, minute)) |>

  # Create a tsibble.
  # NOTE: flight and carrier are both required to uniquely identify observations
  as_tsibble(key=c(carrier, flight), index = time)

flights_ts

# This intentionally errors: key = flight alone is insufficient.
tryCatch({
flights_ts <-

  flights |>

  # Select columns of interest
  select(year, carrier, flight, month, day, hour, minute, distance) |>

  # Create timestamp
  mutate(time = make_datetime(year, month, day, hour, minute)) |>

  # Drop columns
  select(time, everything(), -c(year, month, day, hour, minute)) |>

  # Create a tsibble,
  # NOTE: flight and carrier are both required to uniquely identify observations
  as_tsibble(key=flight, index = time)
}, error = function(e) cat("Expected error:", conditionMessage(e), "\n"))

# Refuses to drop time information: time and carrier are selected implicitly.
flights_ts |>
  select(flight)

# To select only the column flight, cast the tsibble to a tibble first.
flights_ts |>
  as_tibble() |> # Cast to a tibble
  select(flight)

flights_ts |>
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance))

flights_ts |>
  as_tibble() |> # cast to tibble
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance)) # cast to tsibble

flights_ts |>
  as_tibble() |> # cast to tibble
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance)) |>
  as_tsibble(index = month) # cast to tsibble

flights_ts |>
  index_by(month = yearmonth(time)) |>
  summarise(mean_dist = mean(distance))
