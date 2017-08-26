
library(tidyverse)
library(R.matlab)
library(readstata13)

matlabFile <- readMat("output/sicData.mat")

varNames <- names(matlabFile$sicData[,,1])
datList = matlabFile$sicData
datList = lapply(datList, unlist, use.names=FALSE)
sicData <- as.data.frame(datList)
names(sicData) <- varNames

sicData$overcat[(sicData$overcat == "not applicable")] <- NA

# R likes to replace . with _ in variable names, so revert that
names(sicData) <- gsub("\\.", "_", names(sicData))

save.dta13(data = sicData, 
           file = "output/sicData.dta",
           version = 13)
