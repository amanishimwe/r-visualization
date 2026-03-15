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
# Use count() instead of distinct() to tally occurrences, with sort = TRUE to return
# results in descending order.
flights |>
  count(origin, dest, sort = TRUE)

# =============================================================================
#           Exercises
# =============================================================================

# Exercise 1: Using a single pipeline for each, filter flights that:
#   a) Had an arrival delay of two or more hours
view(flights)
flights |> filter(arr_delay>120)
#   b) Flew to Houston (IAH or HOU)
flights |> filter(dest=='IAH' | dest == 'HOU')

#   c) Were operated by United, American, or Delta
flights |>
  filter(carrier %in% c("UA", "AA", "DL"))
#   d) Departed in summer (July, August, and September)
flights |> filter(month %in% c(7,8,9) )
#   e) Arrived more than two hours late but didn't leave late
flights |>
  filter(arr_delay > 120 & dep_time<=0)
#   f) Were delayed by at least an hour but made up over 30 minutes in flight
flights |>
  filter(dep_delay >= 60 & dep_delay - arr_delay > 30)

# Exercise 2: Sort flights to find those with the longest departure delays.
#             Then find the flights that left earliest in the morning.
flights |>
  arrange(desc(dep_delay))
# We get the earliest years first, then within a year, the earliest months, etc.
flights |>
  arrange(dep_time)

# Exercise 3: Sort flights to find the fastest flights.
#             Hint: try including a math calculation inside arrange().
flights |>
  arrange(air_time / distance) # sort by time per mile — lower = faster

# Exercise 4: Was there a flight on every day of 2013?
flights |>
  distinct(year, month, day) |> # find all unique dates
  count()                        # tally — 365 means a flight on every day of 2013

# Exercise 5: Which flights traveled the farthest distance?
#             Which traveled the least distance?

# Farthest distance
flights |>
  arrange(desc(distance))

# Least distance
flights |>
  arrange(distance)

# Exercise 6: Does the order of filter() and arrange() matter when using both?
#             Think about the results and how much work each function has to do.
# So order doesn't affect the final result,
#but putting filter() before arrange() is more efficient.

# ==============================================================================
#============================COLUMNS============================================
# Four verbs modify columns without changing rows: mutate() adds derived columns,
# select() picks which columns to keep, rename() renames them, and relocate() reorders them.
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1  # add new columns to the left side instead of the right
  )
# adding the new rows before day
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )
# only keep the columns that were used in the mutate function
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )
#===============================================================================
#===============================================================================
# Select columns by name:
flights |>
  select(year, month, day)
#Select all columns between year and day (inclusive):
flights |>
  select(year:day)
#Select all columns except those from year to day (inclusive):
flights |>
  select(!year:day)
#Select all columns that are characters:
flights |>
  select(where(is.character))
# There are a number of helper functions that you can use with select()
#starts_with("abc"): matches names that begin with “abc”.
#ends_with("xyz"): matches names that end with “xyz”.
#contains("ijk"): matches names that contain “ijk”.
#num_range("x", 1:3): matches x1, x2 and x3.
#You can rename variables as you select() them by using =.
# The new name appears on the left-hand side of the =,
# and the old variable appears on the right-hand side:
flights |>
  select(tail_num = tailnum)
flights |>
  rename(tail_num = tailnum) # rename tailnum to tail_num, keeping all other columns

# For bulk column name cleaning, janitor::clean_names() automatically standardizes
flights |>
  relocate(tailnum, air_time) # move time_hour and air_time to the front by default

flights |>
  relocate(year:dep_time, .after = time_hour) # move year through dep_time after time_hour

flights |>
  relocate(starts_with("arr"), .before = dep_time) # move all arr_ columns before dep_time
# =============================================================================
# 3.3.5 Exercises
# =============================================================================

# Exercise 1: Compare dep_time, sched_dep_time, and dep_delay.
#             How would you expect these three numbers to be related?
#             (Hint: dep_time - sched_dep_time should equal dep_delay)

flights |>
  select(dep_time, sched_dep_time, dep_delay)


# Exercise 2: Brainstorm as many ways as possible to select
#             dep_time, dep_delay, arr_time, and arr_delay from flights.

flights |> select(dep_time, dep_delay, arr_time, arr_delay)  # by name
flights |> select(starts_with("dep") | starts_with("arr"))   # by prefix
flights |> select(contains("time") | contains("delay"))       # by keyword
flights |> select(4, 6, 7, 9)                                 # by position


# Exercise 3: What happens if you specify the same variable multiple times in select()?

flights |> select(dep_time, dep_time, dep_time) # returns the column only once


# Exercise 4: What does any_of() do? Why is it helpful with this vector?

variables <- c("year", "month", "day", "dep_delay", "arr_delay")

flights |> select(any_of(variables)) # selects columns that exist, ignores those that don't


# Exercise 5: Does this surprise you? How do select helpers handle upper/lower case?
#             Use ignore.case = FALSE to make it case-sensitive.

flights |> select(contains("TIME"))               # case-insensitive by default
flights |> select(contains("TIME", ignore.case = FALSE)) # case-sensitive


# Exercise 6: Rename air_time to air_time_min and move it to the front.

flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)


# Exercise 7: Why doesn't this work?
#             select(tailnum) drops all other columns including arr_delay,
#             so arrange() cannot find arr_delay to sort by.

flights |>
  select(tailnum) |>
  arrange(arr_delay) # Error: arr_delay not found — it was dropped by select()

# =============================================================================











































