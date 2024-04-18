#### Preamble ####
# Purpose: Group together statistics based on species
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data, 02.x_clean_data

#### Workplace setup ####

library(tidyverse)
library(arrow)

#### Aggregate By Species ####

# Load in data
spawning_population <- read_parquet('output/data/spawning_population.parquet')
broodstock <- read_parquet("output/data/broodstock.parquet")

# Aggregate spawning population data

# Group first by the species, area, and year
aggregated_spawning_population_by_area <- 
  spawning_population |>
  mutate(SALMON_POPULATION = coalesce(TOTAL_RETURN_TO_RIVER, NATURAL_ADULT_SPAWNERS)) |>
  filter(SPECIES != "Atlantic" & SPECIES != "Kokanee") |>
  group_by(SPECIES, AREA, YEAR) |>
  summarize(
    NATURAL_ADULT_SPAWNERS = sum(NATURAL_ADULT_SPAWNERS, na.rm = TRUE),
    NATURAL_JACK_SPAWNERS = sum(NATURAL_JACK_SPAWNERS, na.rm = TRUE),
    NATURAL_SPAWNERS_TOTAL = sum(NATURAL_SPAWNERS_TOTAL, na.rm = TRUE),
    TOTAL_RETURN_TO_RIVER = sum(TOTAL_RETURN_TO_RIVER, na.rm = TRUE),
    SALMON_POPULATION = sum(SALMON_POPULATION, na.rm = TRUE)
  )

# Rename values to be capitalized
aggregated_spawning_population_by_area$SPECIES = toupper(aggregated_spawning_population_by_area$SPECIES)

# Group together only by species and year
aggregated_spawning_population <- 
  aggregated_spawning_population_by_area |>
  group_by(SPECIES, YEAR) |>
  summarize(
    NATURAL_ADULT_SPAWNERS = sum(NATURAL_ADULT_SPAWNERS, na.rm = TRUE),
    NATURAL_JACK_SPAWNERS = sum(NATURAL_JACK_SPAWNERS, na.rm = TRUE),
    NATURAL_SPAWNERS_TOTAL = sum(NATURAL_SPAWNERS_TOTAL, na.rm = TRUE),
    TOTAL_RETURN_TO_RIVER = sum(TOTAL_RETURN_TO_RIVER, na.rm = TRUE),
    SALMON_POPULATION = sum(SALMON_POPULATION, na.rm = TRUE)
  )

write_parquet(aggregated_spawning_population, "output/data/aggregated_spawning_population.parquet")

# Aggregate broodstock data

aggregated_broodstock <-
  broodstock |>
  group_by(YEAR) |>
  summarize(
    ADULT_BROODSTOCK_REMOVALS = sum(ADULT_BROODSTOCK_REMOVALS, na.rm = TRUE),
    JACK_BROODSTOCK_REMOVALS = sum(JACK_BROODSTOCK_REMOVALS, na.rm = TRUE),
    TOTAL_BROODSTOCK_REMOVALS = sum(TOTAL_BROODSTOCK_REMOVALS, na.rm = TRUE),
    OTHER_REMOVALS = sum(OTHER_REMOVALS, na.rm = TRUE),
    TOTAL_RETURN_TO_RIVER = sum(TOTAL_RETURN_TO_RIVER, na.rm = TRUE)
  ) |>
  filter(YEAR >= 1979) |>
  arrange(YEAR)

write_parquet(aggregated_broodstock, "output/data/aggregated_broodstock.parquet")
