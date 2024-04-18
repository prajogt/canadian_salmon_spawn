#### Preamble ####
# Purpose: Clean Salmon Spawn Data
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data

#### Workplace setup ####

library(tidyverse)
library(arrow)

#### Clean Salmon Spawn Data ####

# Read in data

# Gill net
nuseds_data <- 
  read_csv(
    "input/data/nuseds.csv"
  )

# Rename cols
nuseds_data <-
  nuseds_data |> 
  rename(YEAR = ANALYSIS_YR, LOCAL_NAME = LOCAL_NAME_1)

# Split dataset to only include rows with specific features

# Spawning population features
spawning_population <-
  nuseds_data |>
  select(AREA, WATERBODY, LOCAL_NAME, YEAR, SPECIES,
         NATURAL_ADULT_SPAWNERS, NATURAL_JACK_SPAWNERS, NATURAL_SPAWNERS_TOTAL, TOTAL_RETURN_TO_RIVER) |>
  filter(!is.na(NATURAL_ADULT_SPAWNERS))
  
# Broodstock (amount taken out for the use of human influenced spawning)
broodstock <-
  nuseds_data |> 
  select(AREA, WATERBODY, YEAR, SPECIES,
         NATURAL_ADULT_SPAWNERS, NATURAL_SPAWNERS_TOTAL,
         ADULT_BROODSTOCK_REMOVALS, JACK_BROODSTOCK_REMOVALS, TOTAL_BROODSTOCK_REMOVALS, OTHER_REMOVALS, TOTAL_RETURN_TO_RIVER) |>
  filter(!is.na(NATURAL_ADULT_SPAWNERS) | !is.na(NATURAL_SPAWNERS_TOTAL) | !is.na(TOTAL_RETURN_TO_RIVER)) |>
  mutate(
    NATURAL_ADULT_SPAWNERS = ifelse(is.na(NATURAL_ADULT_SPAWNERS), 0, NATURAL_ADULT_SPAWNERS),
    NATURAL_SPAWNERS_TOTAL = ifelse(is.na(NATURAL_SPAWNERS_TOTAL), 0, NATURAL_SPAWNERS_TOTAL),
    TOTAL_RETURN_TO_RIVER = ifelse(is.na(TOTAL_RETURN_TO_RIVER), 0, TOTAL_RETURN_TO_RIVER),
    ADULT_BROODSTOCK_REMOVALS = ifelse(is.na(ADULT_BROODSTOCK_REMOVALS), 0, ADULT_BROODSTOCK_REMOVALS),
    JACK_BROODSTOCK_REMOVALS = ifelse(is.na(JACK_BROODSTOCK_REMOVALS), 0, JACK_BROODSTOCK_REMOVALS),
    TOTAL_BROODSTOCK_REMOVALS = ifelse(is.na(TOTAL_BROODSTOCK_REMOVALS), 0, TOTAL_BROODSTOCK_REMOVALS),
    OTHER_REMOVALS = ifelse(is.na(OTHER_REMOVALS), 0, OTHER_REMOVALS),
  ) |>
  mutate(TOTAL_RETURN_TO_RIVER, max(NATURAL_ADULT_SPAWNERS, NATURAL_SPAWNERS_TOTAL, TOTAL_RETURN_TO_RIVER))
  
# Spawn timing features (arrival, peak)
spawn_timings <-
  nuseds_data |> 
  select(AREA, WATERBODY, LOCAL_NAME, YEAR, SPECIES,
         STREAM_ARRIVAL_DT_FROM, STREAM_ARRIVAL_DT_TO, 
         START_SPAWN_DT_FROM, START_SPAWN_DT_TO, 
         PEAK_SPAWN_DT_FROM, PEAK_SPAWN_DT_TO, 
         END_SPAWN_DT_FROM, END_SPAWN_DT_TO) |>
  filter(
    !is.na(STREAM_ARRIVAL_DT_FROM) &
    !is.na(START_SPAWN_DT_FROM) &
    !is.na(PEAK_SPAWN_DT_FROM) &
    !is.na(END_SPAWN_DT_FROM)
  )

# Save cleaned data
write_parquet(spawning_population, "output/data/spawning_population.parquet")
write_parquet(broodstock, "output/data/broodstock.parquet")
write_parquet(spawn_timings, "output/data/spawn_timings.parquet")
