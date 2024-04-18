#### Preamble ####
# Purpose: Create LM predicting Salmon spawn using previous years data
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data, 02.x_clean_data, 03_aggregate_data

#### Workplace setup ####

library(rstanarm)
library(tidyverse)
library(modelsummary)

set.seed(302)

#### Create Model ####

# Load data
broodstock <- read_parquet("output/data/aggregated_broodstock.parquet")

broodstock_next_year <- 
  broodstock |>
  select(YEAR, TOTAL_RETURN_TO_RIVER) |>
  mutate(YEAR = YEAR - 1) |>
  rename(NEXT_YEAR_RETURN = TOTAL_RETURN_TO_RIVER)

# Since for the first and last year, we have nothing to predict, we remove those
broodstock <- 
  broodstock |>
  filter(YEAR != max(YEAR))

broodstock_next_year <-
  broodstock_next_year |>
  filter(YEAR != min(YEAR))

# Join the tables (essentially using last years spawning data to predict the next years spawning data)
model_data <- 
  left_join(broodstock, broodstock_next_year, by = "YEAR") |>
  mutate(
    TOTAL_RETURN_TO_RIVER = TOTAL_RETURN_TO_RIVER / 1000,
    NEXT_YEAR_RETURN = NEXT_YEAR_RETURN / 1000
  )

yearly_change_model <- lm(NEXT_YEAR_RETURN ~ ADULT_BROODSTOCK_REMOVALS + JACK_BROODSTOCK_REMOVALS + TOTAL_BROODSTOCK_REMOVALS + OTHER_REMOVALS + TOTAL_RETURN_TO_RIVER, data = model_data)

saveRDS(
  yearly_change_model,
  file = "output/models/yearly_change_model.rds"
)
