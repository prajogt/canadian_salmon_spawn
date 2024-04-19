## Analyzing Canadian Salmon Spawn Statistics

## Overview
This project makes use of a Linear Model to predict Salmon Populations. It examines the impact of commercial fishing on the reproductive capacity of Canadian Salmon, utilizing datasets from the NuSEDS and the Government of Canada's Pacific Region Commercial Salmon Fishery. We investigate the influence of commercial fishing alongside spawning health on salmon populations. Emphasizing the significance of effective management, we aim to show the need for sustainable fishing practices to mitigate negative impacts to the Canadian salmon population.

## File Structure
- `inputs` contains the NuSEDS and Catch Estimate data, including the corresponding data dictionaries. This is the raw dataset downloaded directly from Canada's open data portal.

- `other/sketches` contains the sketches of the dataset and figure we want to represent in our paper.

- `other/datasheets` contains the datasheets for both the datasets that were used in our paper.

- `output/data` contains the cleaned data which is ready to be processed into the models.

- `output/models` contains the two models generated from the dataset. 

- `output/paper.qmd` contains the written and programming portion used to generate the paper. Once generated, this Quarto file will output a `paper.pdf` which the user can use to read the paper. 

- `output/references.bib` contains the references used in the development of this paper.

- `scripts` contains the R scripts that simulated the data of the figure as well as download, clean, and create models to be later analyzed for any correlations.


## Execution Instructions

1. [OPTIONAL] Run `scripts/00_simulate_data.R` to see a simulation of our expected data and results.
2. Run `scripts/01_download_data.R` to download the raw dataset.
3. Run both `scripts/02.x_clean_xxx_data.R` to clean both datasets.
4. Run both `scrips/03.x_aggregate_xxx_data.R` to summarize the datasets for the model.
5. Run `scripts/04.x_xxx_model.R` to create models to later analyze for correlations.
6. Run `scripts/05_tests.R` to test the validity of our code and data.
7. Run `outputs/paper.qmd` and Render to generate the PDF of this paper.


## LLM Statement
No LLM was used in the development of this paper.