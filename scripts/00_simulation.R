#### Preamble ####
# Purpose: Simulates data for predicting salmon populations given commercial fishing and salmon stocking and spawning
# Author: Timothius Prajogi
# Data: April 18 2024
# Contact: timothius.prajogi@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####

library(tidyverse)
set.seed(302)

#### Simulate data ####

# Simulate a negative relation between salmon caught commercially 
# and the overall salmon population
salmon_population <- sample(100:1000, 18, replace = TRUE)
salmon_caught <- salmon_population + rnorm(18, mean = -50, sd = 50)
salmon_population <- salmon_population - salmon_caught

# simulate results from 2005 to 2022
data <- data.frame(
  year = 2005:2022,
  salmon_population = salmon_population,
  salmon_caught = salmon_caught
)

ggplot(data, aes(x = year)) +
  geom_line(aes(y = salmon_population, color = "Salmon Population")) +
  geom_line(aes(y = salmon_caught, color = "Salmon Caught")) +
  labs(x = "Year", y = "Count", title = "Salmon Population vs. Salmon Caught") +
  scale_color_manual(values = c("blue", "red"), labels = c("Salmon Population", "Salmon Caught")) +
  theme_minimal()

# simulate that an increase in population and an increase in the amount of
# salmon artificially breed then released increases future populations
salmon_population <- seq(100, 1000, length.out = 18) + rnorm(18, mean = 0, sd = 50)
salmon_stocking <- rnorm(18, mean = 50, sd = 50)
salmon_population <- salmon_population + salmon_stocking

sim_data <- data.frame(
  year = 2005:2022,
  salmon_population = salmon_population,
  salmon_stocking = salmon_stocking
)

ggplot(sim_data, aes(x = year)) +
  geom_line(aes(y = salmon_population, color = "Salmon Population")) +
  geom_line(aes(y = salmon_stocking, color = "Salmon Stocking")) +
  labs(x = "Year", y = "Count", title = "Salmon Population vs. Salmon Stocking") +
  scale_color_manual(values = c("blue", "red"), labels = c("Salmon Population", "Salmon Stocking")) +
  theme_minimal()
