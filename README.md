Advanced Machine Learning and Natural Language Processing

Customer Churn Prediction | Sentiment Analysis

Project Overview

This project demonstrates the application of advanced statistical learning and natural language processing techniques to solve two real business problems:

Customer Churn Prediction in the telecom industry

Sentiment Classification using NLP

The objective was not only to build predictive models, but to compare model performance, interpret drivers, and extract actionable business insights.

1. Customer Churn Prediction
Business Objective

Customer churn is a major revenue risk in subscription based industries. The goal was to:

Predict which customers are likely to churn

Identify key behavioral drivers

Compare traditional statistical modeling with ensemble machine learning

Two models were implemented:

Logistic Regression

Random Forest

Data Quality and Preparation

No missing values

No duplicate records

Target variable properly encoded

Categorical predictors transformed into factors

Clean structured dataset ready for modeling

Model 1: Logistic Regression

Logistic regression provided a strong statistical baseline.

Performance

Accuracy: 85.91 percent

Precision: 51.06 percent

Recall: 25.26 percent

F1 Score: 0.338

Interpretation

While overall accuracy was high, recall was low. The model struggled to correctly identify churners due to class imbalance.

Key churn indicators:

International Plan

Customer Service Calls

Total International Calls

Voice Mail Plan (negative effect)

Insight: Customers with high service complaints and international usage show significantly higher churn probability.

Model 2: Random Forest (Ensemble Learning)

Random Forest significantly improved predictive performance.

Performance

Accuracy: 95.05 percent

Precision: 93.06 percent

Recall: 70.53 percent

F1 Score: 0.802

Impact

Recall improved from 25 percent to 70 percent

Strong improvement in identifying high risk customers

More balanced classification performance

This demonstrates the superiority of ensemble methods in capturing nonlinear patterns and feature interactions.

Most Important Features

Customer Service Calls

International Plan

Total Day Minutes

Total Day Charge

Total International Calls

Business Impact:

Telecom firms can proactively target high risk customers using complaint frequency and usage behavior to design retention strategies.

2. Sentiment Analysis Using NLP
Objective

To classify textual data into:

Positive

Negative

Neutral

Using lexicon based natural language processing (Bing lexicon).

Text Processing Pipeline

Text normalization

Removal of punctuation and numbers

Stopword removal

Stemming

Tokenization

Lexicon based scoring

Observations

Majority of sentiments were positive

Negative sentiments were moderate

Neutral sentiments were limited

The word cloud revealed emotionally expressive terms such as:

Love

Joy

Dream

Friend

Challenge

Model Considerations

Lexicon based models:

Do not capture sarcasm

Do not fully understand context

Have limitations in neutral detection

However, they provide fast, interpretable baseline sentiment scoring.

Technical Stack

R
Logistic Regression
Random Forest
Text Mining (tm)
Tidytext
Dplyr
Data Visualization
Feature Importance Analysis
