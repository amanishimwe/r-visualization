install.packages("tidycensus")
install.packages("sf")
install.packages("viridis")

library(tidycensus)
library(sf)
library(ggplot2)
library(viridis)

#Create a chloropleth (by county) of the median age for the corresponding state.
# ── 1. SET YOUR CENSUS API KEY ────────────────────────────────────────────────
census_api_key("3397a8d05dcede52e86d9358ce6e1335f167c57f", install = TRUE)

# ── 2. FETCH MEDIAN AGE BY COUNTY FOR TEXAS (2010 DECENNIAL) ─────────────────
# P013001 = median age (total) from SF1
texas_age <- get_decennial(
  geography = "county",
  variables = "P013001",   # median age
  state     = "TX",
  year      = 2010,
  geometry  = TRUE         # pulls county shapefile automatically
)

# ── 3. PLOT CHOROPLETH ────────────────────────────────────────────────────────
p_choropleth <- ggplot(texas_age, aes(fill = value, geometry = geometry)) +
  geom_sf(color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(
    option    = "plasma",
    name      = "Median Age",
    direction = -1
  ) +
  labs(
    title    = "Median Age by County — Texas (2010 Census)",
    subtitle = "Source: U.S. Census Bureau, SF1",
    caption  = "Darker = older median age"
  ) +
  theme_void(base_size = 13) +
  theme(
    plot.title    = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
    legend.position = "right"
  )
print(p_choropleth)


