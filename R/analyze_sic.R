
rm(list=ls()) # clear all variables from memory

library(R.matlab)
library(dplyr)
library(readr)

# Set working directory
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  wdpath <- 'D:/patent-automat'
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- '/Users/Lukas/Documents/mydocs/projects/PatentSearch_Automation/patent-automat'
}

setwd(wdpath)

cat('Load Matlab file ... '); tic = proc.time()[3]
matlabFile <- readMat('output/sicData.mat')
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))

varNames <- names(matlabFile$sicData[,,1])
datList = matlabFile$sicData
datList = lapply(datList, unlist, use.names=FALSE)
sicData <- as.data.frame(datList)
names(sicData) <- varNames

sicData <- sicData[-(sicData$overcat == 'not applicable'),]

write_rds(sicData, './output/sicData.rds', compress = "xz")
