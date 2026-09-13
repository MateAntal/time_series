# ============================================================
# Source: 02_A_Dates_Times_R.html
# ============================================================

# ---- cell 1 ----
library(fpp3)

# ---- cell 2 ----
library(tidyverse)

# ---- cell 3 ----
library(nycflights13)

# ---- cell 4 ----
# Example 1
date1 <- ymd("2017-01-31")
date1

# ---- cell 5 ----
class(date1)

# ---- cell 6 ----
# Example 2
date2 <- mdy("January 31st, 2017")
date2

# ---- cell 7 ----
class(date2)

# ---- cell 8 ----
# Example 3
date3 <- dmy("31-Jan-2017")
date3

# ---- cell 9 ----
class(date3)

# ---- cell 10 ----
# Example 4 - unquoted numbers
date4 <- ymd(20170131)
class(date4)

# ---- cell 11 ----
# Example 1:
datetime1 <- ymd_hms("2017-01-31 20:11:59")
class(datetime1)

# ---- cell 12 ----
# Example 2
datetime2 <- mdy_hm("01/31/2017 08:01")
class(datetime2)

# ---- cell 13 ----
# Example 3
# You can also force the creation of a date-time
# from a date providing a timezone:
datetime3 <- ymd(20170131, tz = "UTC")
class(datetime3)

# ---- cell 14 ----
# Dataset from package nycflights13
flights |>
  select(year, month, day, hour, minute)

# ---- cell 15 ----
flights |>
  select(year, month, day, hour, minute) |>

  mutate(
    date = make_date(year, month, day), # Create new date column
    datetime = make_datetime(year, month, day, hour, minute) # Create date-time
  )

# ---- cell 16 ----
# Example 1:
today() # date

# ---- cell 17 ----
as_datetime(today()) #datetime

# ---- cell 18 ----
now() # datetime

# ---- cell 19 ----
as_date(now()) #date

# ---- cell 20 ----
date1 <- ymd(19700110)
date2 <- ymd(20230830)

# Number of days elapsed since "1970-01-01" and "1970-01-10"
as.integer(date1)

# ---- cell 21 ----
# Number of days elapsed since "1970-01-01" and "2023-08-30"
as.integer(date2)

# ---- cell 22 ----
# The 10th of January 1970 can therefore also be expressed as follows
as_date(9) # 9 days elapsed since 1st of January 1970

# ---- cell 23 ----
# Ten years offset in days from 1970-01-01.
# +2 accounts for two leap years
as_date(365 * 10 + 2)

# ---- cell 24 ----
#NOTE: the enclosing parentheses display the output without an additional line of code
(ym1 <- yearmonth(ymd("2017-01-31")))

# ---- cell 25 ----
(ym2 <- yearmonth(dmy("31-Jan-2017"), format="%Y%m"))

# ---- cell 26 ----
(ym5 <- yearmonth(mdy_hm("04/20/2020 08:01")))

# ---- cell 27 ----
class(ym1)

# ---- cell 28 ----
#NOTE: the enclosing parentheses display the output without an additional line of code
(yq1 <- yearquarter(ymd("2017-01-31")))

# ---- cell 29 ----
class(yq1)

# ---- cell 30 ----
#NOTE: the enclosing parentheses display the output without an additional line of code
(yw1 <- yearweek(ymd("2017-01-31")))

# ---- cell 31 ----
class(yw1)

# ---- cell 32 ----
seq(0, 60, by = 6)

# ---- cell 33 ----
# Sequence of 6 months steps starting in January 2012 and advancing
# for 60 months (5 years) in steps of six months
seq_months <- yearmonth("2012-01-01") + seq(0, 60, by = 6)
seq_months

# ---- cell 34 ----
# Sequence of 2 quarters steps starting in January 2012 and advancing
# for 20 quarters (4 years) in steps of 2 quarters.
seq_quarters <- yearquarter("2012-01-01") + seq(0, 20, by = 2)
seq_quarters

# ---- cell 35 ----
# Sequence of 2 weeks steps starting in January 2012 and advancing
# for 52 weeks (1 year) in steps of two weeks (starts on Monday Jan 2)
seq_weeks <- yearweek("2012-01-02") + seq(0, 52, 2)
seq_weeks

# ---- cell 36 ----
parse_datetime("2010-10-01T2010")

# ---- cell 37 ----
# If time is omitted, it is set to midnight
parse_datetime("20101010")

# ---- cell 38 ----
parse_date("2010-10-01")

# ---- cell 39 ----
parse_time("01:10 am")

# ---- cell 40 ----
parse_time("20:10:01")

# ---- cell 41 ----
parse_date("01/02/15", format = "%m/%d/%y")

# ---- cell 42 ----
parse_date("01/02/15", format = "%d/%m/%y")

# ---- cell 43 ----
parse_date("01/02/15", format = "%y/%m/%d")

# ---- cell 44 ----
datestring <- c("January 10, 2012;@ 10:40", "December 9, 2011;@ 9:10")
parse_datetime(datestring, format="%B %d, %Y;@ %H:%M")

# ---- cell 45 ----
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# ---- cell 46 ----
locale()

# ---- cell 47 ----
#Example:

locale_custom <- locale(date_format = "Day %d Mon %m Year %y",
                 time_format = "Sec %S Min %M Hour %H")


date_custom <- c("Day 01 Mon 02 Year 03", "Day 03 Mon 01 Year 01")
parse_date(date_custom)

# ---- cell 48 ----
parse_date(date_custom, locale = locale_custom)

# ---- cell 49 ----
time_custom <- c("Sec 01 Min 02 Hour 03", "Sec 03 Min 02 Hour 01")
parse_time(time_custom)

# ---- cell 50 ----
parse_time(time_custom, locale = locale_custom)

# ---- cell 51 ----
d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")

# ---- cell 52 ----
d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")

# ---- cell 53 ----
d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")

# ---- cell 54 ----
d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")

# ---- cell 55 ----
d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")

# ---- cell 56 ----
t1 <- "1705"
parse_time(t1, "%H%M")

# ---- cell 57 ----
# t2 uses real seconds (seconds are a real number)
t2 <- "11:15:10.12 PM"
parse_time(t2, "%H:%M:%OS %p")

# ============================================================
# Source: 02_B_tsibbles.html
# ============================================================

# ---- cell 1 ----
library(fpp3)

# ---- cell 2 ----
library(nycflights13)

# ---- cell 3 ----
global_economy

# ---- cell 4 ----
data_1 <- tsibble(
  year = 2012:2016,
  y = c(123, 39, 78, 52, 110),
  index = year
)
data_1

# ---- cell 5 ----
data_1 <- tibble(
  year = 2012:2016,
  y = c(123, 39, 78, 52, 110)
) |>
as_tsibble(index = year)

data_1

# ---- cell 6 ----
flights_ts <-
  flights |>

  #Select columns of interest
  select(year, carrier, flight, month, day, hour, minute, distance) |>

  #Create timestamp
  mutate(time = make_datetime(year, month, day, hour, minute)) |>

  #Drop columns
  select(time, everything(), -c(year, month, day, hour, minute)) |>

  #Create a tsibble,
  #NOTE: flight and carrier are both required to uniquely identify observations
  as_tsibble(key=c(carrier, flight), index = time)

#Inspect result
flights_ts

# ---- cell 7 ----
# This cell intentionally errors: key=flight alone is insufficient.
tryCatch({
flights_ts <-

  flights |>

  #Select columns of interest
  select(year, carrier, flight, month, day, hour, minute, distance) |>

  #Create timestamp
  mutate(time = make_datetime(year, month, day, hour, minute)) |>

  #Drop columns
  select(time, everything(), -c(year, month, day, hour, minute)) |>

  #Create a tsibble,
  #NOTE: flight and carrier are both required to uniquely identify observations
  as_tsibble(key=flight, index = time)
}, error = function(e) cat("Expected error:", conditionMessage(e), "\n"))

# ---- cell 8 ----
# Refuses to drop time information. Column time is selected implicitly
# Column carrier also selected implicitly, since it is part of the key
flights_ts |>
  select(flight)

# ---- cell 9 ----
# To succeed in selecting only the column flight, we need to cast the tsibble
# to a tibble first.
flights_ts |>
  as_tibble() |> # Cast to a tibble
  select(flight)

# ---- cell 10 ----
flights_ts |>
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance))

# ---- cell 11 ----
flights_ts |>
  as_tibble() |> # cast to tibble
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance)) # cast to tsibble

# ---- cell 12 ----
flights_ts |>
  as_tibble() |> # cast to tibble
  group_by(month = yearmonth(time)) |> # group by month
  summarise(mean_dist = mean(distance)) |>
  as_tsibble(index = month) # cast to tsibble

# ---- cell 13 ----
flights_ts |>
  index_by(month = yearmonth(time)) |>
  summarise(mean_dist = mean(distance))

