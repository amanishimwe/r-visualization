install.packages("tidyverse")
install.packages(
  c("arrow", "babynames", "curl", "duckdb", "gapminder",
    "ggrepel", "ggridges", "ggthemes", "hexbin", "janitor", "Lahman",
    "leaflet", "maps", "nycflights13", "openxlsx", "palmerpenguins",
    "repurrrsive", "tidymodels", "writexl")
)
# =============================================================================
# Script: Penguin Flipper Length vs Body Mass Visualization
# Purpose: Explore the relationship between flipper length and body mass
#          across three penguin species (Adelie, Chinstrap, Gentoo)
# Data:    palmerpenguins::penguins dataset
# =============================================================================

# --- Load Required Libraries ---

# tidyverse: collection of R packages for data manipulation and visualization (includes ggplot2)
library(tidyverse)

# palmerpenguins: provides the penguins dataset collected from Palmer Station, Antarctica
library(palmerpenguins)

# ggthemes: extra themes and color scales for ggplot2, including colorblind-friendly palettes
library(ggthemes)

# --- Inspect the Dataset ---

# Print a summary of the penguins dataset to the console
# Contains variables: species, island, bill dimensions, flipper length, body mass, sex, year
penguins

# Open the dataset in RStudio's interactive spreadsheet viewer for a full overview
View(penguins)

# --- Build the Visualization ---

# Goal: Display the relationship between flipper length and body mass,
# differentiated by penguin species, with a single overall linear trend line.

ggplot(
  data = penguins,                          # Dataset to use for the plot
  mapping = aes(
    x = flipper_length_mm,                  # Global x-axis: flipper length in millimeters
    y = body_mass_g                         # Global y-axis: body mass in grams
  )
) +

  # geom_point: draws a scatterplot
  # color and shape are mapped LOCALLY (only affect points, not other layers)
  # This ensures each species gets a distinct color AND shape for accessibility
  geom_point(
    mapping = aes(
      colour = species,                     # Local: color each point by species
      shape  = species                      # Local: use different shapes per species
    )
  ) +

  # geom_smooth: draws a single trend line for the ENTIRE dataset
  # method = "lm" fits a linear regression line (as opposed to a curve)
  # No color/shape mapping here — inherits only global x and y, so one line is drawn
  geom_smooth(method = "lm") +

  # labs: sets human-readable labels for the plot
  labs(
    title    = "Body mass and flipper length",                              # Main plot title
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",    # Descriptive subtitle
    x        = "Flipper length (mm)",                                       # x-axis label
    y        = "Body mass (g)",                                             # y-axis label
    color    = "Species",                                                   # Legend title for color
    shape    = "Species"                                                    # Legend title for shape (merges with color legend)
  ) +

  # scale_color_colorblind: applies a colorblind-friendly color palette from ggthemes
  # Ensures the plot is accessible to viewers with color vision deficiencies
  scale_color_colorblind()
