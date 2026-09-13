library(fpp3)

library(babynames)
library(nycflights13)
library(tidyverse)

library(lubridate)

babynames

flights

?flights
?babynames

########filter
#Ex 1. Select the subset of the babynames dataset that contains data between 1990 and 2010 about female babies:

babies_90_10 = babynames |>
  filter(year >= 1990 & year <= 2010)


#Ex 2. Select the subset of the babynames dataset that contains data between 1990 and 2010 regarding babies named either Mary, Sarah or Carrie:
  
babies_90_10_MSC = babynames |>
  filter(year >= 1990 & year <= 2010 & (name=="Mary" | name=="Sarah" | name=="Carrie"))

babies_90_10_MSC



#Ex 3. Filter the flights dataset to contain only the flights that took place in June, July, August and September. Keep only the subset of flights that were delayed. Store the result in a variable called res

res = flights |>
  filter(month %in% c(6, 7, 8, 9) &
           dep_delay > 0)

res

#Ex 4. Take the result of 3 and select only the subset of flights that have a plane tail number (variable tailnum) that starts with N. For this you will need to use the function substr(). Research online how the function works.

new_res = res|>
  filter(substr(tailnum,1,1)=='N')

#interesrting that same number of rows - all flights are N start


############## select()

#Ex 5. Take the flights dataset and select only the first 3 columns
flights |>
  select(1:3)
#Ex 6. Take the flights dataset and select only the columns between year and dep_delay
flights |>
  select(year:dep_delay)
#Ex 7. Take the flights dataset and select all the columns except those between year and dep_delay:
flights |>
  select(-(year:dep_delay))
#Ex 8. Take the flights dataset, place the variable tailnum at the beginning of the dataset, drop the variable carrier and keep the rest of the columns in their original order:
flight_1 = flights |>
  select(tailnum, everything(),-carrier)


flight_1


#pull()

#Ex 9.
#Subset the flights dataset so that it only contains flights that took place on the first day of the month. Then use pull() to extract the variable dep_delay and store it in a variable called res.

#Finally compute the average and max value of the delay times contained in res using mean and max. You might need to set the argument na.rm of these functions to TRUE. Research the meaning of this argument.

res <- flights |>
  filter(day == 1) |>
  pull(dep_delay)

mean(res, na.rm = TRUE)
max(res, na.rm = TRUE)

#arrange()

#Ex 10.
#Use the function arrange in combination with des() to rearrange the dataset babynames all the conditions below are fulfilled:
  
# years are desplayed rom smallest to largest
#male names are shown before female names
#within each sex category the less frequently occurring names are shown first.
#mutate()

babynames |>
  arrange(year, desc(sex), n)


#Ex 11. Use mutate() to create two new columns in the flights dataset:
#  using make_date() combine year, month and day to create a date object. You may research online or use ?make_date on the console to understand how make_date() works
#create a new column that returns FALSE if arr_delay is smaller than an hour and TRUE else. For this us ifelse() create a conditional. Reseach online how ifelse() works in dplyr or use ?ifelse() to get help from the console.
#After this re-order the dataframe so that the newly created columns are located at the beginning of the dataframe.



flights |>
  mutate(
    date = make_date(year, month, day),
    long_arr_delay = ifelse(arr_delay > 60, TRUE, FALSE)
  ) |>
  select(date, long_arr_delay, everything())




#Ex 12. Use mutate() and substr() to create a new column with the initial letter of the name of every entry in the dataset babynames.

babynames |>
  mutate(initial = substr(name, 1, 1))


#Ex 13. Use group_by() + summarize() to get the mean() and median() value of arr_delay each month. You will need to specify a correct value for the argument na.rm of the funtions mean() and `median().
#group_by() + filter() + ungroup()


flights |>
  group_by(month) |>
  summarize(
    mean_arr_delay = mean(arr_delay, na.rm = TRUE),
    median_arr_delay = median(arr_delay, na.rm = TRUE)
  )

#negative delay meaning early flight arrival
  
  
#Ex 14. Use group_by(), filter() and ungroup() to get a list of the most unpopular male and female babynames names each year
#group_by() + mutate() + ungroup()

babynames |>
  group_by(year, sex) |>
  filter(n == min(n)) |>
  ungroup()


#Ex 15. Use group_by(), mutate() and ungroup()
#Use the function dense_rank() in combination with group_by(), mutate() and ungroup() to create a rank of flights within the same day based upon their arr_delay. Flights with greater delay should have the smallest rank. Research online or on the help how dense_rank() works.

#At the same time, use the function row_number() to assign an integer number to each row (each flight) of each day. The biggest arrival delays within a day should have the smallest row_number)


flights |>
  group_by(year, month, day) |>
  mutate(
    delay_rank = dense_rank(desc(arr_delay)),
    delay_row_number = row_number(desc(arr_delay))
  ) |>
  ungroup()






#Creating my own tsibble of my cycling routes: index - date , key - route_type , measured vars - dist, time



cycling_routes <- tibble(
  date = as.Date("2026-09-01") + 0:6,
  route_type = c("commute", "commute", "training", "commute", "training", "training", "commute"),
  distance_km = c(8.2, 8.5, 22.0, 8.1, 28, 35.0, 6.0),
  ride_time_min = c(28, 30, 50, 27, 60, 70, 22)
)

cycling_tsibble <- cycling_routes |>
  as_tsibble(index = date, key = route_type)

cycling_tsibble




