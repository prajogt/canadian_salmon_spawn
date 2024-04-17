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
gill_net_catches <- read_parquet("output/data/gill_net_catches.parquet")
seine_catches <- read_parquet("output/data/seine_catches.parquet")
troll_catches <- read_parquet("output/data/troll_catches.parquet")

aggregated_gill_net_data <- 
  gill_net_catches |> 
  group_by(CALENDAR_YEAR, MGMT_AREA) |>
  summarize(
    VESSEL_COUNT = sum(VESSEL_COUNT, na.rm = TRUE),
    BOAT_DAYS = sum(BOAT_DAYS, na.rm = TRUE),
    SOCKEYE_KEPT = sum(SOCKEYE_KEPT, na.rm = TRUE),
    SOCKEYE_RELD = sum(SOCKEYE_RELD, na.rm = TRUE),
    COHO_KEPT = sum(COHO_KEPT, na.rm = TRUE),
    COHO_RELD = sum(COHO_RELD, na.rm = TRUE),
    PINK_KEPT = sum(PINK_KEPT, na.rm = TRUE),
    PINK_RELD = sum(PINK_RELD, na.rm = TRUE),
    CHUM_KEPT = sum(CHUM_KEPT, na.rm = TRUE),
    CHUM_RELD = sum(CHUM_RELD, na.rm = TRUE),
    CHINOOK_KEPT = sum(CHINOOK_KEPT, na.rm = TRUE),
    CHINOOK_RELD = sum(CHINOOK_RELD, na.rm = TRUE),
    STEELHEAD_KEPT = sum(STEELHEAD_KEPT, na.rm = TRUE),
    STEELHEAD_RELD = sum(STEELHEAD_RELD, na.rm = TRUE)
  )

aggregated_seine_data <- 
  seine_catches |> 
  group_by(CALENDAR_YEAR, MGMT_AREA) |>
  summarize(
    VESSEL_COUNT = sum(VESSEL_COUNT, na.rm = TRUE),
    BOAT_DAYS = sum(BOAT_DAYS, na.rm = TRUE),
    SOCKEYE_KEPT = sum(SOCKEYE_KEPT, na.rm = TRUE),
    SOCKEYE_RELD = sum(SOCKEYE_RELD, na.rm = TRUE),
    COHO_KEPT = sum(COHO_KEPT, na.rm = TRUE),
    COHO_RELD = sum(COHO_RELD, na.rm = TRUE),
    PINK_KEPT = sum(PINK_KEPT, na.rm = TRUE),
    PINK_RELD = sum(PINK_RELD, na.rm = TRUE),
    CHUM_KEPT = sum(CHUM_KEPT, na.rm = TRUE),
    CHUM_RELD = sum(CHUM_RELD, na.rm = TRUE),
    CHINOOK_KEPT = sum(CHINOOK_KEPT, na.rm = TRUE),
    CHINOOK_RELD = sum(CHINOOK_RELD, na.rm = TRUE),
    STEELHEAD_KEPT = sum(STEELHEAD_KEPT, na.rm = TRUE),
    STEELHEAD_RELD = sum(STEELHEAD_RELD, na.rm = TRUE)
  )

aggregated_troll_data <- 
  troll_catches |> 
  group_by(CALENDAR_YEAR, MGMT_AREA) |>
  summarize(
    VESSEL_COUNT = sum(VESSEL_COUNT, na.rm = TRUE),
    BOAT_DAYS = sum(BOAT_DAYS, na.rm = TRUE),
    SOCKEYE_KEPT = sum(SOCKEYE_KEPT, na.rm = TRUE),
    SOCKEYE_RELD = sum(SOCKEYE_RELD, na.rm = TRUE),
    COHO_KEPT = sum(COHO_KEPT, na.rm = TRUE),
    COHO_RELD = sum(COHO_RELD, na.rm = TRUE),
    PINK_KEPT = sum(PINK_KEPT, na.rm = TRUE),
    PINK_RELD = sum(PINK_RELD, na.rm = TRUE),
    CHUM_KEPT = sum(CHUM_KEPT, na.rm = TRUE),
    CHUM_RELD = sum(CHUM_RELD, na.rm = TRUE),
    CHINOOK_KEPT = sum(CHINOOK_KEPT, na.rm = TRUE),
    CHINOOK_RELD = sum(CHINOOK_RELD, na.rm = TRUE),
    STEELHEAD_KEPT = sum(STEELHEAD_KEPT, na.rm = TRUE),
    STEELHEAD_RELD = sum(STEELHEAD_RELD, na.rm = TRUE)
  )

# Combine all tables
aggregated_catch_data <- 
  bind_rows(aggregated_gill_net_data, aggregated_seine_data, aggregated_troll_data)

# Sum up all catch statistics for any type of fishing
aggregated_catch_data_by_area <-
  aggregated_catch_data |>
  group_by(CALENDAR_YEAR, MGMT_AREA) |>
  summarize(
    VESSEL_COUNT = sum(VESSEL_COUNT),
    BOAT_DAYS = sum(BOAT_DAYS),
    SOCKEYE_KEPT = sum(SOCKEYE_KEPT),
    SOCKEYE_RELD = sum(SOCKEYE_RELD),
    COHO_KEPT = sum(COHO_KEPT),
    COHO_RELD = sum(COHO_RELD),
    PINK_KEPT = sum(PINK_KEPT),
    PINK_RELD = sum(PINK_RELD),
    CHUM_KEPT = sum(CHUM_KEPT),
    CHUM_RELD = sum(CHUM_RELD),
    CHINOOK_KEPT = sum(CHINOOK_KEPT),
    CHINOOK_RELD = sum(CHINOOK_RELD),
    STEELHEAD_KEPT = sum(STEELHEAD_KEPT),
    STEELHEAD_RELD = sum(STEELHEAD_RELD)
  )

aggregated_catch_data <-
  aggregated_catch_data_by_area |>
  group_by(CALENDAR_YEAR) |>
  summarize(
    VESSEL_COUNT = sum(VESSEL_COUNT),
    BOAT_DAYS = sum(BOAT_DAYS),
    SOCKEYE_KEPT = sum(SOCKEYE_KEPT),
    SOCKEYE_RELD = sum(SOCKEYE_RELD),
    COHO_KEPT = sum(COHO_KEPT),
    COHO_RELD = sum(COHO_RELD),
    PINK_KEPT = sum(PINK_KEPT),
    PINK_RELD = sum(PINK_RELD),
    CHUM_KEPT = sum(CHUM_KEPT),
    CHUM_RELD = sum(CHUM_RELD),
    CHINOOK_KEPT = sum(CHINOOK_KEPT),
    CHINOOK_RELD = sum(CHINOOK_RELD),
    STEELHEAD_KEPT = sum(STEELHEAD_KEPT),
    STEELHEAD_RELD = sum(STEELHEAD_RELD)
  )
  
write_parquet(aggregated_catch_data, "output/data/aggregated_catch_data.parquet")

# Reshape the table
pivoted_catch_data <- 
  aggregated_catch_data |>
  pivot_longer(cols = -c(CALENDAR_YEAR, VESSEL_COUNT, BOAT_DAYS), names_to = "fish_action", values_to = "value") |>
  separate(fish_action, into = c("fish_species", "action"), sep = "_", remove = FALSE) |>
  mutate(action = ifelse(action == "KEPT", "SALMON_KPT", "SALMON_RLD")) |>
  select(-fish_action) |>
  pivot_wider(names_from = action, values_from = value) |>
  mutate(SPECIES = fish_species) |>
  select(CALENDAR_YEAR, VESSEL_COUNT, BOAT_DAYS, SPECIES, SALMON_KPT, SALMON_RLD)

write_parquet(pivoted_catch_data, "output/data/aggregated_pivoted_catch_data.parquet")

# Aggregate spawning population data

spawning_population <- read_parquet('output/data/spawning_population.parquet')

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
  
  
