
library(tidyverse)
library(tidymodels)
library(here)
library(broom)
library(ggplot2)
library(yardstick)

set.seed(42)

# --- Load data and refit the same model ---
df <- read_csv(here("data/processed/clean.csv")) |> 
  mutate(diabetes = as.factor(diabetes))

split <- initial_split(df, prop = 0.8, strata = diabetes)
train <- training(split)
test  <- testing(split)

rec <- recipe(diabetes ~ ., data = train) |>
  step_normalize(all_numeric_predictors())

log_spec <- logistic_reg() |> set_engine("glm")

wf <- workflow() |>
  add_recipe(rec) |>
  add_model(log_spec)

fit_log <- wf |> fit(train)

# --- Predictions ---
preds <- predict(fit_log, test, type = "prob") |>
  bind_cols(test |> select(diabetes))

# --- ROC curve ---
roc_df <- roc_curve(preds, truth = diabetes, .pred_1)
roc_auc_val <- roc_auc(preds, truth = diabetes, .pred_1)
p_roc <- autoplot(roc_df) +
  ggtitle(paste0("ROC curve — Logistic (AUC = ", round(roc_auc_val$.estimate, 3), ")"))
ggsave(here("plots/roc_curve.png"), p_roc, width = 6, height = 5, dpi = 300)

# --- Confusion matrix ---
preds_cls <- preds |>
  mutate(.pred_class = factor(if_else(.pred_1 > 0.5, "1", "0"),
                              levels = levels(test$diabetes)))
cm <- conf_mat(preds_cls, truth = diabetes, estimate = .pred_class)
p_cm <- autoplot(cm, type = "heatmap") + ggtitle("Confusion Matrix (threshold = 0.5)")
ggsave(here("plots/confusion_matrix.png"), p_cm, width = 5.5, height = 4.5, dpi = 300)

# --- Feature importance from standardized coefficients ---
glm_fit <- extract_fit_parsnip(fit_log)$fit
coef_df <- tidy(glm_fit) |>
  filter(term != "(Intercept)") |>
  mutate(importance = abs(estimate)) |>
  arrange(desc(importance)) |>
  slice_head(n = 15)

p_imp <- ggplot(coef_df, aes(x = reorder(term, importance), y = importance)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top features by |standardized coefficient|",
       x = NULL, y = "|coefficient|") +
  theme_minimal()

ggsave(here("plots/feature_importance_logit.png"), p_imp, width = 7.5, height = 6, dpi = 300)

message("✅ Saved plots to /plots: ROC curve, confusion matrix, feature importance.")

