# Predicting Diabetes Risk Using Machine Learning in R

This project explores the **Pima Hospital Diabetes dataset** to predict the likelihood of diabetes based on key medical attributes such as glucose level, BMI, and age.  
It demonstrates a complete **machine learning pipeline in R** — including data cleaning, exploratory analysis, model training, and performance evaluation using the `tidymodels` framework.  
The final logistic regression model achieved an **AUC of approximately 0.82**, highlighting its potential for early risk detection and clinical decision support.

A complete end-to-end **data analysis and modeling project in R** using the Pima Indians Diabetes dataset as a case study for **hospital readmission prediction**.  
This project demonstrates how to clean and explore medical data, build a logistic regression model using `tidymodels`, and visualize key insights such as ROC curves, confusion matrices, and feature importance.  
The model achieved a strong **AUC (~0.82)**, showing good predictive performance for identifying diabetic cases.  
This workflow can serve as a template for healthcare analytics, risk scoring, and predictive modeling tasks in R.  
All steps are reproducible — from data loading to visualization and model evaluation — and use open-source R packages only.

## Preview

<img src="plots/roc_curve.png" width="420">  
<img src="plots/confusion_matrix.png" width="420">  
<img src="plots/feature_importance_logit.png" width="420">

## Folder structure

## How to run

source("R/00_get_data.R")   # generate pima_diabetes.csv into data/raw
source("R/01_clean.R")      # create data/processed/clean.csv
source("R/02_eda.R")        # save EDA plots to /plots
source("R/03_model.R")      # train logistic model, print ROC AUC & accuracy
source("R/04_insights.R")   # save ROC curve, confusion matrix, feature importance

## 🛠️ Skills & Tools Used

| Category | Tools / Packages |
|-----------|------------------|
| **Language** | R (base R, tidyverse) |
| **Data Wrangling & Cleaning** | dplyr, janitor, tidyr, lubridate |
| **Exploratory Data Analysis (EDA)** | ggplot2, GGally, skimr, patchwork |
| **Modeling Framework** | tidymodels (parsnip, recipes, workflows, rsample, yardstick) |
| **Model Type** | Logistic Regression (binary classification) |
| **Evaluation Metrics** | ROC-AUC, accuracy, confusion matrix |
| **Visualization & Reporting** | ggplot2, yardstick, R Markdown / Quarto-ready outputs |
| **Version Control & Collaboration** | Git, GitHub Desktop |
| **Reproducibility** | R 4.x, here package for paths, script-based workflow |

Results
Metric	Value
Accuracy	0.78
ROC AUC	0.82
Sensitivity (Recall)	0.76
Specificity	0.80

The logistic regression model performed well on the test data, achieving a balanced performance between true positive and true negative rates.

Key Insights

Glucose level is the most influential predictor for diabetes risk.

BMI and Age also have strong positive associations with diabetes likelihood.

The logistic regression model provides an interpretable baseline model that can be easily extended with regularization or tree-based methods (e.g., Random Forest).

This workflow can be generalized to other clinical risk prediction problems.



