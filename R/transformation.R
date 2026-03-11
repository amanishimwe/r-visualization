#==================================================================================================
# This chapter introduces data transformation using the dplyr package, covering key tools
# such as row/column operations, grouping, and the pipe — demonstrated with the nycflights13
# dataset of flights departing New York City in 2013.
# While visualization reveals insights, you'll often need to reshape, summarize, or rename
# your data first; here, we show you how using dplyr alongside ggplot2 from the tidyverse.
#==================================================================================================
# Loading the Packages:
library(nycflights13)
library(tidyverse)
nycflights13::flights
#=================================================================================================
# We explore dplyr verbs using nycflights13::flights, a tibble of all 336,776 flights
# that departed New York City in 2013, sourced from the US Bureau of Transportation Statistics.
# Unlike regular data frames, tibbles print only the first few rows and visible columns —
# use View(flights), print(flights, width = Inf), or glimpse() to inspect the full dataset.
View(flights)
print(flights, width = Inf)
glimpse(flights)
dim(flights)

#===============dplyr Basics===================================================
# dplyr verbs share a consistent structure — they always take a data frame as the first
# argument, use unquoted column names, and return a new data frame — and are combined
# using the pipe (|>) to solve complex manipulation tasks across rows, columns, and groups.

# finding all flights with departure time greater than 120 minutes
flights |>
  filter(dep_delay > 120)
# filter() supports comparison operators (>, >=, <, <=, ==, !=) and logical operators
# (& or , for "and", | for "or") to combine multiple row conditions.
# Flights that departed on January 1
flights |>
  filter(month == 1 & day == 1)
# Flights that departed in January or February
flights |>
  filter(month == 1 | month == 2)

# Use %in% as a shortcut for combining | and == to keep rows where a variable
# matches any value in a given set.
# A shorter way to select flights that departed in January or February
flights |>
  filter(month %in% c(1, 2))
# arrange() sorts rows by one or more columns in ascending order by default,
# with each additional column used to break ties from the previous one.

flights |>
  arrange(year, month, day, dep_time)

# Wrap a column in desc() inside arrange() to sort it in descending order.
flights |>
  arrange(desc(dep_delay))
# distinct() returns unique rows from a dataset, optionally scoped to specific columns
# to find distinct combinations of those variables
flights |>
  distinct()
# Find all unique origin and destination pairs
flights |>
  distinct(origin, dest)
# Use .keep_all = TRUE in distinct() to retain all other columns alongside the unique rows.
flights |>
  distinct(origin, dest, .keep_all = TRUE)











