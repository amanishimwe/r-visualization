install.packages("tidyverse")
install.packages(
  c("arrow", "babynames", "curl", "duckdb", "gapminder",
    "ggrepel", "ggridges", "ggthemes", "hexbin", "janitor", "Lahman",
    "leaflet", "maps", "nycflights13", "openxlsx", "palmerpenguins",
    "repurrrsive", "tidymodels", "writexl")
)
# ==============================================================================
# Script: Penguin Flipper Length vs Body Mass Visualization
# Purpose: Explore the relationship between flipper length and body mass
#          across three penguin species (Adelie, Chinstrap, Gentoo)
# Data:    palmerpenguins::penguins dataset
# ==============================================================================

# --- Load Required Libraries ---
#===============================================================================

# tidyverse: collection of R packages for data manipulation and visualization
#(includes ggplot2)
library(tidyverse)
#===============================================================================
# palmerpenguins: provides the penguins dataset collected from Palmer Station
# Antarctica
library(palmerpenguins)

# ggthemes: extra themes and color scales for ggplot2,
# including colorblind-friendly palettes
library(ggthemes)

#===============================================================================
# --- Inspect the Dataset ---

# Print a summary of the penguins dataset to the console
# Contains variables: species, island, bill dimensions,
# flipper length, body mass, sex, year

# Open the dataset in RStudio's interactive spreadsheet viewer for a full overview
View(penguins)
#===============================================================================
# --- Build the Visualization ---

# Goal: Display the relationship between flipper length and body mass,
# differentiated by penguin species, with a single overall linear trend line.

ggplot(
  data = penguins,               # Dataset to use for the plot
  mapping = aes(
    x = flipper_length_mm,      # Global x-axis: flipper length in millimeters
    y = body_mass_g             # Global y-axis: body mass in grams
  )
) +

  # geom_point: draws a scatterplot
  # color and shape are mapped LOCALLY (only affect points, not other layers)
  # This ensures each species gets a distinct color AND shape for accessibility
  geom_point(
    mapping = aes(
      colour = species,           # Local: color each point by species
      shape  = species            # Local: use different shapes per species
    )
  ) +

  # geom_smooth: draws a single trend line for the ENTIRE dataset
  # method = "lm" fits a linear regression line (as opposed to a curve)
  # No color/shape mapping here — inherits only global x and y, so one line is drawn
  geom_smooth(method = "lm") +

  # labs: sets human-readable labels for the plot
  labs(
    title    = "Body mass and flipper length",        # Main plot title
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",# Descriptive subtitle
    x        = "Flipper length (mm)",                 # x-axis label
    y        = "Body mass (g)",                       # y-axis label
    color    = "Species",                             # Legend title for color
    shape    = "Species"    # Legend title for shape (merges with color legend)
  ) +

# scale_color_colorblind: applies a colorblind-friendly color palette from ggthemes
 # Ensures the plot is accessible to viewers with color vision deficiencies
  scale_color_colorblind()
#===============================================================================
#==========================Exercises============================================
# How many penguins? and how many columns?
dim(penguins)
#===============================================================================
#What does the bill_depth_mm variable in the penguins data frame describe?
# Read the help for ?penguins to find out
#=========for help==============================================================
?penguins
# bill length is a number denoting bill length in millimters

#===== Scatter plot of  bill_depth_mm vs. bill_length_mm

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species,
                     shape = species)) +
  geom_point()

# scatter plot of species Vs bill_depth

ggplot(penguins, aes(x=bill_depth_mm,y=species, colour = species)) +
  geom_point(na.rm=TRUE) +
  labs(title = "Data come from the palmerpenguins package")
#===============================================================================

#====scatter plot of body mass Vs bill_length===================================
ggplot(penguins, aes(x=bill_length_mm, y=body_mass_g))+
  geom_point(aes(color = bill_length_mm))+
  geom_smooth(method = "lm")
  labs(title = " Body Mass Vs Bill Length",
       x="Bill Length(mm)",
       y="Body Mass(g)") +
    scale_color_colorblind()

# Run this code in your head and predict what the output will look like.
# Then, run the code in R and check your predictions.
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
  ) +
    geom_point() +
    geom_smooth(se = FALSE)
# Will these two graphs look different? Why/why not?
#=====01========================================================================
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

#===02==========================================================================
ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()
#===============================================================================
# Visualizing Categorical Variables
# A variable is categorical if it can only take one of a small set of values
# To examine the distribution of a categorical variable, you can use a bar chart
#===============================================================================

# Unordered Bar graphs
ggplot(penguins, aes(x = species)) +
  geom_bar()

# Ordered Bar graphs
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()
#===============================================================================
#A variable is numerical (or quantitative) if it can take on a wide range of
#numerical values, and it is sensible to add, subtract, or take averages with
#those values. Numerical variables can be continuous or discrete
#===============================================================================
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

#A histogram divides the x-axis into equally spaced bins and then uses the
#height of a bar to display the number of observations that fall in each bin.
#In the graph, the tallest bar shows that 39 observations have a body_mass_g
#value between 3,500 and 3,700 grams, which are the left and right edges of the bar.
#You can set the width of the intervals in a histogram with the binwidth argument,
#which is measured in the units of the x variable

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)
#You should always explore a variety of binwidths when working with histograms,
#as different binwidths can reveal different patterns.
#In the plots below a binwidth of 20 is too narrow, resulting in too many bars,
#making it difficult to determine the shape of the distribution.
#Similarly, a binwidth of 2,000 is too high, resulting in all data being binned
#into only three bars, and also making it difficult to determine the shape of the distribution. A binwidth of 200 provides a sensible balance.

##===========Density Plot ======================================================
#An alternative visualization for distributions of numerical variables is
#a density plot.
#A density plot is a smoothed-out version of a histogram and a practical
#alternative, particularly for continuous data that comes from an underlying
#smooth distribution
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()
#===============================================================================

#===================EXERCISES===================================================

#1. Make a bar plot of species of penguins, where you assign species to the y aesthetic.
#How is this plot different?
ggplot(penguins, aes(y=species))+
  geom_bar()
# Ans: The graph becomes horizontal

#2. How are the following two plots different?
#Which aesthetic, color or fill, is more useful for changing the color of bars?
#====This one only changes the color of the bar line
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")
#==========This one changes the color of the entire bar and is thus more favorable
ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
#3. What does the bins argument in geom_histogram() do?
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 7)
# The bins argument controls how many bars the histogram is divided into

#=====================Visualization of relationships===========================
# To visualize a relationship, we need to atleast have two variables mapped to
# Aesthics of the plot
#===================Numerical and Categorical Variables=========================
# To visualize the relationship between a categorical and numerical variable,
# We can use side by side box plots
# A boxplot is a type of visual shorthand for measures of position (percentiles)
# that describe a distribution. It is also useful for identifying potential outliers
# A boxplot shows:
#1. Box — covers the middle 50% of data (IQR), with a line at the median
#2.Dots — individual outliers (points beyond 1.5× IQR from the box edges)
#3. Whiskers — lines extending to the furthest non-outlier values

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()
# Alternatively, we can make density plots with geom_density().
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)
# linewidth controls the thickness of lines in the plot.
#-------------------------------------------------------------------------------
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

#======================Two Categorical Variables ===============================
#We Use stacked bar plots to visualize the relationship between two categorical variables
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()
#For example, the following two stacked bar plots both display the relationship
# between island and species, or specifically, visualizing the distribution of
#species within each island

#NB to set a relative frquence we add position=fill as argument within the geo_bar()
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
# x = bar variable, fill = color variable; use labs(y = "proportion")
# to override default "count" label
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")

#====================Two Numerical Variables====================================
# we Use Scatter Plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#================Three or More variables =======================================
## map species to color and island to shape for additional variables in scatterplot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))
























































