#### Preamble ####
# Purpose: Validate data
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data, 02_clean_data, 03_aggregate_data

#### Workplace setup ####

library(testthat)
library(tidyverse)

#### Validate Data ####

catch_data <- read_parquet("output/data/aggregated_pivoted_catch_data.parquet")
spawning_data <- read_parquet("output/data/aggregated_spawning_population.parquet")
broodstock_data <- read_parquet("output/data/aggregated_broodstock.parquet")

# Catch data verification

# Check if years are in the range 2005 to 2022 inclusive
expect_true(all(catch_data$CALENDAR_YEAR >= 2005 & catch_data$CALENDAR_YEAR <= 2022),
            info = "Years should be in the range 2005 to 2022 inclusive")

# Check if VESSEL_COUNT and BOAT_DAYS are integers
expect_true(all(catch_data$VESSEL_COUNT %% 1 == 0),
            info = "VESSEL_COUNT should be integers")
expect_true(all(catch_data$BOAT_DAYS %% 1 == 0),
            info = "BOAT_DAYS should be integers")

# Check if all kept and released values are integers
expect_true(all(catch_data$SALMON_KPT %% 1 == 0),
            info = "SALMON_KEPT should contain integers")
expect_true(all(catch_data$SALMON_RLD %% 1 == 0),
            info = "SALMON_RLD should contain integers")

# Check that the species are in the expected set
allowed_species <- c("SOCKEYE", "COHO", "PINK", "CHUM", "CHINOOK", "STEELHEAD")
expect_true(all(catch_data$SPECIES %in% allowed_species),
            info = "SPECIES column should contain only specific species")

# Spawning data verification

expect_true(all(unique(spawning_data$SPECIES) %in% allowed_species),
            info = "SPECIES column should contain only specific species")

# Check if YEAR column values are within the specified range
expect_true(all(spawning_data$YEAR >= 1950 & spawning_data$YEAR <= 2022),
            info = "YEAR column values should be between 1950 and 2022 inclusive")
expect_true(all(broodstock_data$YEAR >= 1950 & spawning_data$YEAR <= 2022),
            info = "YEAR column values should be between 1950 and 2022 inclusive")

# Check if expected integer columns only contain intgers
expect_true(all(spawning_data$NATURAL_ADULT_SPAWNERS %% 1 == 0),
            info = "NATURAL_ADULT_SPAWNERS column values should be integers")

expect_true(all(spawning_data$NATURAL_JACK_SPAWNERS %% 1 == 0),
            info = "NATURAL_JACK_SPAWNERS column values should be integers")

expect_true(all(spawning_data$NATURAL_SPAWNERS_TOTAL %% 1 == 0),
            info = "NATURAL_SPAWNERS_TOTAL column values should be integers")

expect_true(all(spawning_data$TOTAL_RETURN_TO_RIVER %% 1 == 0),
            info = "TOTAL_RETURN_TO_RIVER column values should be integers")

expect_true(all(spawning_data$SALMON_POPULATION %% 1 == 0),
            info = "SALMON_POPULATION column values should be integers")

expect_true(all(catch_data$ADULT_BROODSTOCK_REMOVALS %% 1 == 0), 
            msg = "ADULT_BROODSTOCK_REMOVALS column contains only integers.")
expect_true(all(catch_data$JACK_BROODSTOCK_REMOVALS %% 1 == 0), 
            msg = "JACK_BROODSTOCK_REMOVALS column contains only integers.")
expect_true(all(catch_data$TOTAL_BROODSTOCK_REMOVALS %% 1 == 0), 
            msg = "TOTAL_BROODSTOCK_REMOVALS column contains only integers.")
expect_true(all(catch_data$OTHER_REMOVALS %% 1 == 0), 
            msg = "OTHER_REMOVALS column contains only integers.")
expect_true(all(catch_data$TOTAL_RETURN_TO_RIVER %% 1 == 0), 
            msg = "TOTAL_RETURN_TO_RIVER column contains only integers.")