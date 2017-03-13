# Estimate predictive models to classify patents.

rm(list=ls())

library(dplyr)
library(caret)

# Set working directoyr
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  wdpath <- 'D:/patent-automat'
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- '/Users/Lukas/Documents/mydocs/econ/projects/PatentSearch_Automation/patent-automat'
}

setwd(wdpath)

cat('Load patent data ... '); tic = proc.time()[3]
loadPath <- paste(getwd(), "/output/pdata.RData", sep = "")
load(loadPath)
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))


# Outcome variable: manual classification of whether a patent is an 
# automation patent
fullData <- cbind(manAutomat = pdata$manAutomat,
                  ipc_ocat = pdata$ipc_ocat,
                    select(pdata, starts_with("t_")),
                    select(pdata, starts_with("a_")),
                    select(pdata, starts_with("b_")))

smp_size <- floor(0.75 * nrow(fullData))  # pick training set size
set.seed(123)                             # make partition reproducible
ix_train <- sample(seq_len(nrow(fullData)), size = smp_size)
train <- fullData[ix_train, ]
test <- fullData[-ix_train, ]


# Technology classes as predictors
# ----------------------------------------------------------------
model <- glm(manAutomat ~ ipc_ocat + b_automat, family = binomial(link = 'logit'), data = train)
summary(model)

trueClass <- factor(ifelse(train$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, newdata = subset(train, select = c(manAutomat, ipc_ocat, b_automat)), type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat('IPC + b_automat:\n')
cat(paste("[Training] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))

trueClass <- factor(ifelse(test$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(test, select = c(manAutomat, ipc_ocat, b_automat)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat(paste("    [Test] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))


# Simple model with only one feature
# ----------------------------------------------------------------
model <- glm(manAutomat ~ b_automat, family = binomial(link = 'logit'), data = train)
summary(model)

trueClass <- factor(ifelse(train$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, newdata = subset(train, select = c(manAutomat, b_automat)), type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat('b_automat:\n')
cat(paste("[Training] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))

trueClass <- factor(ifelse(test$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(test, select = c(manAutomat, b_automat)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat(paste("    [Test] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))


# A few more features
# ----------------------------------------------------------------
regList <- c("b_automat", "b_output", "b_signal", "b_execut", "b_inform", 
             "b_input", "b_detect", "b_user", "b_display", "b_sensor", 
             "b_switch", "b_retriev")
model <- glm(paste("manAutomat ~ ", paste(regList, collapse = " + "), sep = ""),
             family = binomial(link = 'logit'), data = train)
summary(model)

trueClass <- factor(ifelse(train$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(train, select = c("manAutomat", regList)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat('Many b_*:\n')
cat(paste("[Training] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))

trueClass <- factor(ifelse(test$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(test, select = c("manAutomat", regList)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat(paste("    [Test] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))




# A few more features
# ----------------------------------------------------------------
regList <- c("ipc_ocat", "b_automat", "b_output", "b_signal", "b_execut", "b_inform", 
             "b_input", "b_detect", "b_user", "b_display", "b_sensor", 
             "b_switch", "b_retriev")
model <- glm(paste("manAutomat ~ ", paste(regList, collapse = " + "), sep = ""),
             family = binomial(link = 'logit'), data = train)
summary(model)

trueClass <- factor(ifelse(train$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(train, select = c("manAutomat", regList)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat('IPC + many b_*:\n')
cat(paste("[Training] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))

trueClass <- factor(ifelse(test$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, 
                       newdata = subset(test, select = c("manAutomat", regList)), 
                       type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

cat(paste("    [Test] ",
          "F1-measure: ", round(f1, digits = 3), 
          ", Precision: ", round(prec, digits = 2),
          ", Recall: ", round(rec, digits = 2),
          ", Accuracy: ", round(unname(cm$overall["Accuracy"]), digits = 2), 
          ", N: ", length(trueClass), 
          ".\n", sep = ""))



















