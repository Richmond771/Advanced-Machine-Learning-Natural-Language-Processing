# ==========================================================
# LEVEL 3 – ADVANCED MACHINE LEARNING & NLP
# 1. Customer Churn Prediction
# 2. Sentiment Analysis
# ==========================================================

rm(list = ls())

# ==========================================================
# PART 1: CUSTOMER CHURN PREDICTION
# ==========================================================

# -------------------------------
# Load Data
# -------------------------------
train_churn <- read.csv(file.choose())
test_churn  <- read.csv(file.choose())

# -------------------------------
# Data Cleaning & Preprocessing
# -------------------------------

# Check missing values
colSums(is.na(train_churn))
colSums(is.na(test_churn))

# Check duplicates
sum(duplicated(train_churn))
sum(duplicated(test_churn))

# Convert target variable to factor
train_churn$Churn <- factor(train_churn$Churn, levels = c("False", "True"))
test_churn$Churn  <- factor(test_churn$Churn,  levels = c("False", "True"))

# Convert categorical predictors
categorical_cols <- c("State", "International.plan", "Voice.mail.plan")

train_churn[categorical_cols] <- lapply(train_churn[categorical_cols], factor)
test_churn[categorical_cols]  <- lapply(test_churn[categorical_cols], factor)

# ==========================================================
# 1A. Logistic Regression
# ==========================================================

log_model <- glm(
  Churn ~ .,
  data = train_churn,
  family = binomial
)

summary(log_model)

# Predict probabilities
prob_pred <- predict(log_model, newdata = test_churn, type = "response")

# Convert to class labels
class_pred <- ifelse(prob_pred > 0.5, "True", "False")
class_pred <- factor(class_pred, levels = c("False", "True"))

# Confusion Matrix
conf_matrix_log <- table(Predicted = class_pred,
                         Actual = test_churn$Churn)

conf_matrix_log

# Extract values automatically
TN <- conf_matrix_log[1,1]
FP <- conf_matrix_log[2,1]
FN <- conf_matrix_log[1,2]
TP <- conf_matrix_log[2,2]

# Evaluation Metrics
accuracy_log  <- (TP + TN) / sum(conf_matrix_log)
precision_log <- TP / (TP + FP)
recall_log    <- TP / (TP + FN)
f1_log        <- 2 * (precision_log * recall_log) /
  (precision_log + recall_log)

accuracy_log
precision_log
recall_log
f1_log

# ==========================================================
# 1B. Random Forest
# ==========================================================

library(randomForest)

set.seed(123)

rf_model <- randomForest(
  Churn ~ .,
  data = train_churn,
  ntree = 200,
  importance = TRUE
)

rf_pred <- predict(rf_model, newdata = test_churn)

conf_matrix_rf <- table(Predicted = rf_pred,
                        Actual = test_churn$Churn)

conf_matrix_rf

# Extract values
TN_rf <- conf_matrix_rf[1,1]
FP_rf <- conf_matrix_rf[2,1]
FN_rf <- conf_matrix_rf[1,2]
TP_rf <- conf_matrix_rf[2,2]

# Evaluation Metrics
accuracy_rf  <- (TP_rf + TN_rf) / sum(conf_matrix_rf)
precision_rf <- TP_rf / (TP_rf + FP_rf)
recall_rf    <- TP_rf / (TP_rf + FN_rf)
f1_rf        <- 2 * (precision_rf * recall_rf) /
  (precision_rf + recall_rf)

accuracy_rf
precision_rf
recall_rf
f1_rf

# Variable Importance
importance(rf_model)

# ==========================================================
# PART 2: SENTIMENT ANALYSIS (NLP)
# ==========================================================

# -------------------------------
# Load Dataset
# -------------------------------
sentiment_raw <- read.csv(file.choose())

sentiment_data <- sentiment_raw[, c("Text", "Sentiment")]

# -------------------------------
# Text Cleaning
# -------------------------------

sentiment_data$clean_text <- tolower(sentiment_data$Text)
sentiment_data$clean_text <- gsub("[^a-z ]", "", sentiment_data$clean_text)
sentiment_data$clean_text <- gsub("\\s+", " ", sentiment_data$clean_text)
sentiment_data$clean_text <- trimws(sentiment_data$clean_text)

# Remove stopwords
library(tm)

corpus <- VCorpus(VectorSource(sentiment_data$clean_text))
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)

sentiment_data$clean_text <- sapply(corpus, as.character)
sentiment_data$clean_text <- trimws(sentiment_data$clean_text)

# ==========================================================
# Sentiment Scoring Using Bing Lexicon
# ==========================================================

library(dplyr)
library(tidyr)
library(tidytext)

sentiment_words <- sentiment_data %>%
  mutate(id = row_number()) %>%
  unnest_tokens(word, clean_text)

bing_lexicon <- get_sentiments("bing")

sentiment_scored <- sentiment_words %>%
  inner_join(bing_lexicon, by = "word")

sentiment_summary <- sentiment_scored %>%
  count(id, sentiment) %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = 0) %>%
  mutate(score = positive - negative)

# Assign predicted sentiment
sentiment_data$predicted_sentiment <- "Neutral"

sentiment_data$predicted_sentiment[sentiment_summary$score > 0] <- "Positive"
sentiment_data$predicted_sentiment[sentiment_summary$score < 0] <- "Negative"

# View results
head(sentiment_data[, c("Text", "Sentiment", "predicted_sentiment")])

# ==========================================================
# Visualization
# ==========================================================

library(ggplot2)


ggplot(sentiment_data,
       aes(x = predicted_sentiment)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Predicted Sentiment Distribution",
       x = "Sentiment",
       y = "Count") +
  theme_minimal()

# Word Cloud
library(wordcloud)
library(RColorBrewer)

all_words <- paste(sentiment_data$clean_text, collapse = " ")
word_freq <- table(unlist(strsplit(all_words, " ")))

wordcloud(
  words = names(word_freq),
  freq = as.numeric(word_freq),
  min.freq = 2,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

