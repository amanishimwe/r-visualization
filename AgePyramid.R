
#===============================================================================
# Qn.  Choose a city in the USA, and plot an age pyramid for it
#using the 2010 census data. Compare it with the state's capital.
#==============================================================================

setwd("/Users/alban/Documents/GSOC")
install.packages("jsonlite")
install.packages("tidyverse")
install.packages("scales")

library(httr)       # GET() for reliable URL fetching
library(jsonlite)   # fromJSON() to parse Census API responses
library(tidyverse)  # tibble, dplyr, ggplot2, tidyr
library(scales)     # comma() for axis labels

#===02. DATA FETCHING FUNCTION (2010 Census SF1)====
# Fetches age-by-sex data for a given Census place
# Parameters:
#-------------
# 1. APIkey : Census Bureau API key
# 2. state  : 2-digit state FIPS code e.g. "48" for Texas
#   place  : 5-digit place FIPS code e.g. "35000" for Houston
getAgeData <- function(APIkey, state, place) {
  fetchVars <- function(vars) {
    url <- paste0(
      "https://api.census.gov/data/2010/dec/sf1?get=", vars,
      "&for=place:", place,
      "&in=state:", state,
      "&key=", APIkey
    )
    message("Fetching: ", url)
    response <- httr::GET(url)
    if (httr::status_code(response) != 200) {
      stop("API request failed. Status: ", httr::status_code(response),
           "\nMessage: ", httr::content(response, "text"))
    }
    # Extract response body as UTF-8 text
    txt <- httr::content(response, "text", encoding = "UTF-8")
    raw <- tryCatch(fromJSON(txt), error = function(e) {
      stop("JSON parse failed:\n", txt)
    })
    df <- as.data.frame(raw[-1, , drop = FALSE], stringsAsFactors = FALSE)
    colnames(df) <- raw[1, ]
    message("    → ", nrow(df), " row(s), ", ncol(df), " col(s)")
    df
  }

  # Build variable strings for male (P012A) and female (P012B)
  vars_m <- paste(paste0("P012A", sprintf("%03d", 1:25)), collapse = ",")
  vars_f <- paste(paste0("P012B", sprintf("%03d", 1:25)), collapse = ",")
  message("Fetching male age data")
  df_m <- fetchVars(vars_m)
  Sys.sleep(1)   # pause to avoid rate limiting

  message("Fetching female age data")
  df_f <- fetchVars(vars_f)

  # Convert age variable columns from character to numeric
  for (col in colnames(df_m)[1:25]) df_m[[col]] <- as.numeric(df_m[[col]])
  for (col in colnames(df_f)[1:25]) df_f[[col]] <- as.numeric(df_f[[col]])

  # Extract all 25 values (col 1 = total, cols 2–25 = 23 age bins + 1 extra)
  age_m <- as.numeric(df_m[1, 1:25])
  age_f <- as.numeric(df_f[1, 1:25])

  # ── Aggregate granular Census bins into standard 5-year age groups for both male and female
  male_5yr <- c(
    age_m[1],               # Under 5
    age_m[2],               # 5–9
    age_m[3],               # 10–14
    sum(age_m[4:5]),        # 15–19
    sum(age_m[6:8]),        # 20–24
    age_m[9],               # 25–29
    age_m[10],              # 30–34
    age_m[11],              # 35–39
    age_m[12],              # 40–44
    age_m[13],              # 45–49
    age_m[14],              # 50–54
    age_m[15],              # 55–59
    sum(age_m[16:17]),      # 60–64
    sum(age_m[18:19]),      # 65–69
    age_m[20],              # 70–74
    age_m[21],              # 75–79
    age_m[22],              # 80–84
    sum(age_m[23:25])       # 85+
  )

  female_5yr <- c(
    age_f[1],               # Under 5
    age_f[2],               # 5–9
    age_f[3],               # 10–14
    sum(age_f[4:5]),        # 15–19
    sum(age_f[6:8]),        # 20–24
    age_f[9],               # 25–29
    age_f[10],              # 30–34
    age_f[11],              # 35–39
    age_f[12],              # 40–44
    age_f[13],              # 45–49
    age_f[14],              # 50–54
    age_f[15],              # 55–59
    sum(age_f[16:17]),      # 60–64
    sum(age_f[18:19]),      # 65–69
    age_f[20],              # 70–74
    age_f[21],              # 75–79
    age_f[22],              # 80–84
    sum(age_f[23:25])       # 85+
  )

  # Diagnostic: totals should match known city populations
  message("  → Male total:   ", sum(male_5yr, na.rm = TRUE))
  message("  → Female total: ", sum(female_5yr, na.rm = TRUE))

  age_labels_5yr <- c(
    "0–4",   "5–9",   "10–14", "15–19", "20–24",
    "25–29", "30–34", "35–39", "40–44", "45–49",
    "50–54", "55–59", "60–64", "65–69", "70–74",
    "75–79", "80–84", "85+"
  )

  tibble(age = age_labels_5yr, male = male_5yr, female = female_5yr)
}

# ── 3. FETCH DATA ─────────────────────────────────────────────────────────────
# Texas state FIPS     = 48
# Houston place FIPS   = 35000
# Austin place FIPS    = 05000
APIkey <- "3397a8d05dcede52e86d9358ce6e1335f167c57f"

message("═══ Fetching Houston (FIPS place: 35000) ═══")
houston <- getAgeData(APIkey, state = "48", place = "35000")
Sys.sleep(2)

message("═══ Fetching Austin — Texas capital (FIPS place: 05000) ═══")
austin <- getAgeData(APIkey, state = "48", place = "05000")
# Check responses
message("── Houston preview:")
print(head(houston))

message("── Austin preview:")
print(head(austin))

# ── 5. PLOT FUNCTION ──────────────────────────────────────────────────────────
# Draws a population pyramid: males on left, females on right
# youngest age group at bottom, oldest at top
plotPyramid <- function(data, title) {

  data_long <- data %>%
    # Negate male so bars extend left
    mutate(male = -male) %>%
    pivot_longer(cols = c(male, female),
                 names_to  = "sex",
                 values_to = "pop") %>%
    # rev() puts youngest at bottom, oldest at top
    mutate(age = factor(age, levels = rev(unique(data$age))))

  ggplot(data_long, aes(x = pop, y = age, fill = sex)) +
    geom_col() +

    # Show absolute values — hide negative sign on male side
    scale_x_continuous(
      labels = function(x) comma(abs(x)),
      expand = expansion(mult = 0.05)
    ) +

    # Blue = male, red = female
    scale_fill_manual(
      values = c("male" = "#4575b4", "female" = "#d73027"),
      labels = c("Male", "Female")
    ) +

    labs(
      title = title,
      x     = "Population",
      y     = "Age Group",
      fill  = NULL
    ) +

    theme_minimal(base_size = 13) +
    theme(
      plot.title      = element_text(hjust = 0.5, face = "bold"),
      legend.position = "bottom"
    )
}

# ── 6. GENERATE PLOTS ─────────────────────────────────────────────────────────
message("── Plotting Houston pyramid")
plotPyramid(houston, "Houston, TX — Age Pyramid (2010)")

message("── Plotting Austin pyramid")
plotPyramid(austin, "Austin, TX (State Capital) — Age Pyramid (2010)")






