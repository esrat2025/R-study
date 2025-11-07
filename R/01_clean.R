
library(tidyverse)
library(here)
library(janitor)

# 1. Load the raw data
df <- read_csv(here("data/raw/pima_diabetes.csv"))

# 2. Basic cleaning
clean <- df |>
  clean_names() |>
  mutate(
    diabetes = if_else(diabetes == "pos", 1, 0),
    across(everything(), ~ replace_na(., 0))
  )

# 3. Save processed data
write_csv(clean, here("data/processed/clean.csv"))
message("✅ Cleaned data saved to: ", here("data/processed/clean.csv"))

