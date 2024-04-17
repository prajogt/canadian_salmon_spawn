#### Preamble ####
# Purpose: Clean Salmon Catch Data
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data

#### Workplace setup ####

library(tidyverse)
library(arrow)

#### Clean Salmon Catch Data ####

# Read in data

# Gill net
gill_net_catches <- 
  read_csv(
    "input/data/ise-ecs/cs-gn-pac-dfo-mpo-science-eng.csv",
    skip = 1
  )

# Seine
seine_catches <-
  read_csv(
    "input/data/ise-ecs/cs-sn-pac-dfo-mpo-science-eng.csv",
    skip = 1
  )

# Troll
troll_catches <- 
  read_csv(
    "input/data/ise-ecs/cs-tr-pac-dfo-mpo-science-eng.csv",
    skip = 1,
    locale = locale(encoding = "latin1")
  )

# Replace all N/A values in catch and release values to be 0
# (we add up all the values, therefore NA is the same as 0)
# These values are values removed due to privacy restrictions, however
# the inclusion of these rows are important for total vessel counts
gill_net_catches <-
  gill_net_catches |>
  mutate_at(vars(starts_with(c(
    "SOCKEYE_KEPT", "SOCKEYE_RELD",
    "COHO_KEPT", "COHO_RELD",
    "PINK_KEPT", "PINK_RELD",
    "CHUM_KEPT", "CHUM_RELD",
    "CHINOOK_KEPT", "CHINOOK_RELD",
    "STEELHEAD_KEPT", "STEELHEAD_RELD"
  ))), ~replace_na(., 0))

seine_catches <-
  seine_catches |>
  mutate_at(vars(starts_with(c(
    "SOCKEYE_KEPT", "SOCKEYE_RELD",
    "COHO_KEPT", "COHO_RELD",
    "PINK_KEPT", "PINK_RELD",
    "CHUM_KEPT", "CHUM_RELD",
    "CHINOOK_KEPT", "CHINOOK_RELD",
    "STEELHEAD_KEPT", "STEELHEAD_RELD"
  ))), ~replace_na(., 0))

troll_catches <-
  troll_catches |>
  mutate_at(vars(starts_with(c(
    "SOCKEYE_KEPT", "SOCKEYE_RELD",
    "COHO_KEPT", "COHO_RELD",
    "PINK_KEPT", "PINK_RELD",
    "CHUM_KEPT", "CHUM_RELD",
    "CHINOOK_KEPT", "CHINOOK_RELD",
    "STEELHEAD_KEPT", "STEELHEAD_RELD"
  ))), ~replace_na(., 0))

# Only keep relevant columns
gill_net_catches <- 
  gill_net_catches |>
  select(-ESTIMATE_TYPE) |> # This column only indicates in season
  mutate(LICENCE_AREA = substr(LICENCE_AREA, 1, 6)) # Only the area character is relevant, type is defined in fishery

seine_catches <- 
  seine_catches |>
  select(-ESTIMATE_TYPE) |>
  mutate(LICENCE_AREA = substr(LICENCE_AREA, 1, 6))

troll_catches <- 
  troll_catches |>
  select(-ESTIMATE_TYPE) |>
  mutate(LICENCE_AREA = substr(LICENCE_AREA, 1, 6))

# Save data
write_parquet(gill_net_catches, "output/data/gill_net_catches.parquet")
write_parquet(seine_catches, "output/data/seine_catches.parquet")
write_parquet(troll_catches, "output/data/troll_catches.parquet")
