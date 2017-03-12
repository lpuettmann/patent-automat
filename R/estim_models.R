# Estimate predictive models to classify patents.

rm(list=ls())

library(dplyr)

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

train <- cbind(manAutomat = pdata$manAutomat,
                    select(pdata, starts_with("t_")),
                    select(pdata, starts_with("a_")),
                    select(pdata, starts_with("b_")))

# as.factor(train$manAutomat)

model <- glm(manAutomat ~ b_automat, family = binomial(link = 'logit'), data = train)

# Estimate on all (not possible, because not enough degrees of freedom and 
# collinearities)
# model <- glm(manAutomat ~ ., family = binomial(link = 'logit'), data = train)


summary(model)
