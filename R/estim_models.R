# Estimate predictive models to classify patents.

rm(list=ls())

library(dplyr)
library(caret)

# Set working directoyr
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  # wdpath <- 
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- "/Users/Lukas/Documents/mydocs/econ/projects/PatentSearch_Automation/patent-automat"
}

setwd(wdpath)

cat('Load patent data ... ')
tic = proc.time()[3]
loadPath <- paste(getwd(), "/output/pdata.RData", sep = "")
load(loadPath)
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))


# Outcome variable: manual classification of whether a patent is an 
# automation patent
fullData <- cbind(manAutomat = pdata$manAutomat,
                    select(pdata, starts_with("t_")),
                    select(pdata, starts_with("a_")),
                    select(pdata, starts_with("b_")))

smp_size <- floor(0.75 * nrow(fullData))  # pick training set size
set.seed(123)                             # make partition reproducible
ix_train <- sample(seq_len(nrow(fullData)), size = smp_size)
train <- fullData[ix_train, ]
test <- fullData[-ix_train, ]

model <- glm(manAutomat ~ b_automat, family = binomial(link = 'logit'), data = train)
summary(model)

trueClass <- factor(ifelse(test$manAutomat == 1, "yes", "no"))
trueClass <- relevel(trueClass, "yes")

predAutomat <- predict(model, newdata = subset(test, select = c(manAutomat, b_automat)), type='response')
predClass <- factor(ifelse(predAutomat > 0.5, "yes", "no"))
predClass <- relevel(predClass, "yes")

# Calculate classification statistics
cm <- confusionMatrix(predClass, trueClass, dnn = c('predicted', 'true'))
prec <- precision(predClass, trueClass)
rec <- recall(predClass, trueClass)
f1 <- F_meas(predClass, trueClass, beta = 1)

# model <- glm(manAutomat ~ b_automat + b_output + b_signal + b_execut + 
#                b_inform + b_input + b_detect + b_user + b_display + b_sensor +
#                b_switch + b_retriev, 
#              family = binomial(link = 'logit'), data = train)
# summary(model)
# 
# model <- glm(manAutomat ~ t_automat + a_automat + b_automat, 
#              family = binomial(link = 'logit'), data = train)
# summary(model)

# Estimate on all (not possible, because not enough degrees of freedom and 
# collinearities)
# model <- glm(manAutomat ~ ., family = binomial(link = 'logit'), data = train)






