
library(tidyverse)
library(tidymodels)
library(here)
set.seed(42)

# Load the cleaned data
df <- read_csv(here("data/processed/clean.csv")) |>
  mutate(diabetes = as.factor(diabetes))

# Train/test split
split <- initial_split(df, prop = 0.8, strata = diabetes)
train <- training(split)
test  <- testing(split)

# Recipe
rec <- recipe(diabetes ~ ., data = train) |>
  step_normalize(all_numeric_predictors())

# Logistic regression
log_spec <- logistic_reg() |>
  set_engine("glm")

wf <- workflow() |>
  add_recipe(rec) |>
  add_model(log_spec)

# Fit
fit_log <- wf |> fit(train)

# Predict probabilities on test
preds <- predict(fit_log, test, type = "prob") |>
  bind_cols(test |> select(diabetes))

# --- Metrics ---
# ROC AUC (prob-based)
roc_val <- roc_auc(preds, truth = diabetes, .pred_1)

# Convert to class with threshold 0.5, and ensure factor levels match truth
preds_cls <- preds |>
  mutate(
    .pred_class = factor(if_else(.pred_1 > 0.5, "1", "0"),
                         levels = levels(test$diabetes))
  )

# Accuracy & confusion matrix
acc_val <- accuracy(preds_cls, truth = diabetes, estimate = .pred_class)
cm      <- conf_mat(preds_cls, truth = diabetes, estimate = .pred_class)

print(roc_val)
print(acc_val)
print(cm)

message("✅ Logistic regression model trained and evaluated.")

