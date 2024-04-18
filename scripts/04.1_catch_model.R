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

catch_by_method <- read_parquet("output/data/catch_by_method.parquet")

catch_by_method <-
  catch_by_method |>
  rename(YEAR = CALENDAR_YEAR)

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
  filter(SPECIES != "STEELHEAD") |> # Not common 
  left_join(catch_by_method, by = "YEAR")

# Gather the data to predict total salmon population and not just one species
model_data <- 
  model_data |>
  group_by(YEAR) |>
  summarize(
    VESSEL_COUNT = max(VESSEL_COUNT), # Max since all are the same for a year
    BOAT_DAYS = max(BOAT_DAYS),
    SALMON_KPT = sum(SALMON_KPT), # Track catches in 100,000s
    SALMON_RLD = sum(SALMON_RLD),
    SALMON_POPULATION = sum(SALMON_POPULATION) / 1000,
    PERCENTAGE_gill_net = max(PERCENTAGE_gill_net) * 100, # Convert decimals to percentages
    PERCENTAGE_seine = max(PERCENTAGE_seine) * 100,
    PERCENTAGE_troll = max(PERCENTAGE_troll) * 100
  )

# The linear model based on the catch data
catch_population_model <- 
  stan_glm(
    formula = SALMON_POPULATION ~ VESSEL_COUNT + BOAT_DAYS + SALMON_KPT + SALMON_RLD + PERCENTAGE_gill_net + PERCENTAGE_seine + PERCENTAGE_troll, 
    data = model_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(0, 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 302
  )

saveRDS(
  catch_population_model,
  file = "output/models/catch_population_model.rds"
)

