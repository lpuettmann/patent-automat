# Estimate regularized logistic regression.

rm(list=ls())

library(dplyr)
library(glmnet)

# Set working directoyr
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  # wdpath <- 
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- "/Users/Lukas/Documents/mydocs/econ/projects/PatentSearch_Automation/patent-automat"
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

fitLasso <- glmnet(xTrain, yTrain, family = "gaussian", alpha = 1)
fitRidge <- glmnet(xTrain, yTrain, family = "gaussian", alpha = 0)
fitElnet <- glmnet(xTrain, yTrain, family = "gaussian", alpha = 0.5)


# plot(fit, label = T)
# print(fit)
# coef(fit, s = 0.1)

cat('Cross-validate ... '); tic = proc.time()[3]
pb <- progress_estimated(11)
for (i in 0:10) {
  assign(paste("fit", i, sep=""), cv.glmnet(xTrain, yTrain, type.measure="mse", alpha=i/10, family="gaussian"))
  pb$tick()$print()
}
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))


# Plot solution paths:
par(mfrow=c(3,2))

# For plotting options, type '?plot.glmnet' in R console
plot(fitLasso, xvar="lambda")
plot(fit10, main="LASSO")

plot(fitRidge, xvar="lambda")
plot(fit0, main="Ridge")

plot(fitElnet, xvar="lambda")
plot(fit5, main="Elastic Net")

yhat0 <- predict(fit0, s=fit0$lambda.1se, newx=xTest)
yhat1 <- predict(fit1, s=fit1$lambda.1se, newx=xTest)
yhat2 <- predict(fit2, s=fit2$lambda.1se, newx=xTest)
yhat3 <- predict(fit3, s=fit3$lambda.1se, newx=xTest)
yhat4 <- predict(fit4, s=fit4$lambda.1se, newx=xTest)
yhat5 <- predict(fit5, s=fit5$lambda.1se, newx=xTest)
yhat6 <- predict(fit6, s=fit6$lambda.1se, newx=xTest)
yhat7 <- predict(fit7, s=fit7$lambda.1se, newx=xTest)
yhat8 <- predict(fit8, s=fit8$lambda.1se, newx=xTest)
yhat9 <- predict(fit9, s=fit9$lambda.1se, newx=xTest)
yhat10 <- predict(fit10, s=fit10$lambda.1se, newx=xTest)

mse0 <- mean((yTest - yhat0)^2)
mse1 <- mean((yTest - yhat1)^2)
mse2 <- mean((yTest - yhat2)^2)
mse3 <- mean((yTest - yhat3)^2)
mse4 <- mean((yTest - yhat4)^2)
mse5 <- mean((yTest - yhat5)^2)
mse6 <- mean((yTest - yhat6)^2)
mse7 <- mean((yTest - yhat7)^2)
mse8 <- mean((yTest - yhat8)^2)
mse9 <- mean((yTest - yhat9)^2)
mse10 <- mean((yTest - yhat10)^2)

minErr <- c(mse0, mse1, mse2, mse3, mse4, mse5, mse6, mse7, mse8, mse9, mse10)

# cat('Cross-validate ... '); tic = proc.time()[3]
# cvfit = cv.glmnet(x, y, family = "binomial")
# cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))
# 
# plot(cvfit)
# cvfit$lambda.min
# cvfit$lambda.1se
# 
# coef(cvfit, s = "lambda.min")
# 
# predict(cvfit, newx = xTest, s = "lambda.min")



