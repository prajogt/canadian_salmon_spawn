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
  group_by(CALENDAR_YEAR) |>
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
  )|>
  mutate(KEPT_SUM = SOCKEYE_KEPT + COHO_KEPT + PINK_KEPT + CHUM_KEPT + CHINOOK_KEPT + STEELHEAD_KEPT)

aggregated_seine_data <- 
  seine_catches |> 
  group_by(CALENDAR_YEAR) |>
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
  )|>
  mutate(KEPT_SUM = SOCKEYE_KEPT + COHO_KEPT + PINK_KEPT + CHUM_KEPT + CHINOOK_KEPT + STEELHEAD_KEPT)

aggregated_troll_data <- 
  troll_catches |> 
  group_by(CALENDAR_YEAR) |>
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
  ) |>
  mutate(KEPT_SUM = SOCKEYE_KEPT + COHO_KEPT + PINK_KEPT + CHUM_KEPT + CHINOOK_KEPT + STEELHEAD_KEPT)


# Caculate the proportion of catches that came from a method
gill_net_sum <- 
  aggregated_gill_net_data |>
  select(CALENDAR_YEAR, KEPT_SUM)
seine_sum <- 
  aggregated_seine_data |>
  select(CALENDAR_YEAR, KEPT_SUM)
troll_sum <- 
  aggregated_troll_data |>
  select(CALENDAR_YEAR, KEPT_SUM)

# Merge the three tables based
merged_data <- merge(gill_net_sum, seine_sum, by = "CALENDAR_YEAR", suffixes = c("_gill_net", "_seine"))
merged_data <- merge(merged_data, troll_sum, by = "CALENDAR_YEAR")

# Calculate the percentage contribution of each table for each year
merged_data <- 
  merged_data |>
  mutate(
    PERCENTAGE_gill_net = KEPT_SUM_gill_net / (KEPT_SUM_gill_net + KEPT_SUM_seine + KEPT_SUM),
    PERCENTAGE_seine = KEPT_SUM_seine / (KEPT_SUM_gill_net + KEPT_SUM_seine + KEPT_SUM),
    PERCENTAGE_troll = KEPT_SUM / (KEPT_SUM_gill_net + KEPT_SUM_seine + KEPT_SUM)
  ) |>
  select(CALENDAR_YEAR, PERCENTAGE_gill_net, PERCENTAGE_seine, PERCENTAGE_troll)

# Save that data
write_parquet(merged_data, "output/data/catch_by_method.parquet")

# Combine all tables
aggregated_catch_data <- 
  bind_rows(aggregated_gill_net_data, aggregated_seine_data, aggregated_troll_data)

aggregated_catch_data <-
  aggregated_catch_data |>
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

  
