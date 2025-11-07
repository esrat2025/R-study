
library(tidyverse)
library(here)
library(GGally)
library(skimr)
library(patchwork)

# Load the cleaned dataset
df <- read_csv(here("data/processed/clean.csv"))

# Quick overview
skim(df)
print(head(df))

# Target variable balance
p1 <- ggplot(df, aes(factor(diabetes))) +
  geom_bar(fill = "#0073C2FF") +
  labs(x = "Diabetes (0 = no, 1 = yes)", y = "Count",
       title = "Target variable balance") +
  theme_minimal()

# Glucose distribution by diabetes status (if the column exists)
if ("glucose" %in% names(df)) {
  p2 <- ggplot(df, aes(x = glucose, fill = factor(diabetes))) +
    geom_histogram(bins = 30, alpha = 0.6, position = "identity") +
    labs(title = "Glucose distribution by diabetes status") +
    theme_minimal()
  ggsave(here("plots/glucose_dist.png"), p2, width = 6, height = 4)
}

# Correlation pairs for numeric variables
num_vars <- df |> select(where(is.numeric))
p3 <- ggpairs(num_vars, aes(color = factor(df$diabetes), alpha = 0.4)) +
  theme_bw()

# Save plots
ggsave(here("plots/target_balance.png"), p1, width = 5, height = 4)
message("✅ EDA complete. Plots saved in /plots folder.")

