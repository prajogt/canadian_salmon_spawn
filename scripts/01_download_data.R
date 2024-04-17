#### Preamble ####
# Purpose: Download Salmon Data
# Author: Timothius Prajogi
# Date: 18 April 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####

library(tidyverse)
library(openxlsx)

#### Download and save Salmon data ####

# Get commercial catch data
url <- "https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/7ac5fe02-308d-4fff-b805-80194f8ddeb4/attachments/ise-ecs.zip"

download.file(url, "input/data/salmon-data-bundle.zip", mode = "wb")

zip_file <- "input/data/salmon-data-bundle.zip"

unzip(zip_file, exdir="input/data/")

# Get salmon spawning data
url <- "https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/c48669a3-045b-400d-b730-48aafe8c5ee6/attachments/All%20Areas%20NuSEDS_20240110.xlsx"
download.file(url, "input/data/nuseds.xlsx", mode = "wb")

nuseds_data_xlsx <- read.xlsx("input/data/nuseds.xlsx")

# Filter only relevant columns, otherwise the file becomes too large to save to github
nuseds_data_xlsx <- 
  nuseds_data_xlsx |> 
  select(-GAZETTED_NAME, -LOCAL_NAME_2, -ENUMERATION_METHODS, 
         -NATURAL_ADULT_FEMALES, -NATURAL_ADULT_MALES, -EFFECTIVE_FEMALES, -WEIGHTED_PCT_SPAWN,
         -WATERSHED_CDE, -POPULATION, -ACCURACY, -PRECISION, -INDEX_YN, -RELIABILITY, 
         -ESTIMATE_STAGE, -ESTIMATE_CLASSIFICATION, -NO_INSPECTIONS_USED, -ESTIMATE_METHOD, -CREATED_DTT, -UPDATED_DTT)

write_csv(nuseds_data_xlsx, "input/data/nuseds.csv")
