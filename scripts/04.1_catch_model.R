#### Preamble ####
# Purpose: Create LM predicting Salmon spawn using Catch rates
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

# Load in data
catch_data <- read_parquet("output/data/aggregated_pivoted_catch_data.parquet") 

catch_data <-
  catch_data |>
  rename(YEAR = CALENDAR_YEAR)

spawning_population_data <- read_parquet("output/data/aggregated_spawning_population.parquet")

# Since for this situation, the catch data only starts at 2002, only consider 
# spawning data for those years
spawning_population_data <-
  spawning_population_data |>
  filter(YEAR >= 2002) |>
  select(YEAR, SPECIES, SALMON_POPULATION)

# Join the tables together by year and species
model_data <- 
  left_join(catch_data, spawning_population_data, by = c("YEAR", "SPECIES")) |>
  mutate(SALMON_POPULATION = ifelse(is.na(SALMON_POPULATION), 0, SALMON_POPULATION)) |>
  filter(SPECIES != "STEELHEAD") # Not common

# Gather the data to predict total salmon population and not just one species
model_data <- 
  model_data |>
  group_by(YEAR) |>
  summarize(
    VESSEL_COUNT = max(VESSEL_COUNT), # Max since all are the same for a year
    BOAT_DAYS = max(BOAT_DAYS),
    SALMON_KPT = sum(SALMON_KPT),
    SALMON_RLD = sum(SALMON_RLD),
    SALMON_POPULATION = sum(SALMON_POPULATION)
  )

# The linear model based on the catch data
catch_population_model <- lm(SALMON_POPULATION ~ VESSEL_COUNT + BOAT_DAYS + SALMON_KPT + SALMON_RLD, data = model_data)

saveRDS(
  catch_population_model,
  file = "output/models/catch_population_model.rds"
)

