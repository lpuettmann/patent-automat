# Estimate regularized logistic regression.

rm(list=ls())

library(dplyr)
library(glmnet)

# Set working directory
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  wdpath <- 'D:/patent-automat'
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- '/Users/Lukas/Documents/mydocs/projects/PatentSearch_Automation/patent-automat'
}

setwd(wdpath)

cat('Load patent data ... '); tic = proc.time()[3]
loadPath <- paste(getwd(), "/output/pdata.RData", sep = "")
load(loadPath)
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))


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

yTrain <- data.matrix(select(train, manAutomat))
xTrain <- data.matrix(select(train, -manAutomat))
yTest <- data.matrix(select(test, manAutomat))
xTest <- data.matrix(select(test, -manAutomat))

fitLasso <- glmnet(xTrain, yTrain, family = "binomial", standardize = TRUE)


cat('Cross-validate ... '); tic = proc.time()[3]
cvfit = cv.glmnet(xTrain, yTrain, family = "binomial", standardize = TRUE)
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))

plot(cvfit)
cvfit$lambda.min
cvfit$lambda.1se

coef(cvfit, s = "lambda.min")
predict(cvfit, newx = xTest, s = "lambda.min")



