# Obtain the manually classified sample of patents.

rm(list=ls()) # clear all variables from memory

library(R.matlab)

# Set working directoyr
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  # wdpath <- 
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- "/Users/Lukas/Documents/mydocs/econ/projects/PatentSearch_Automation/patent-automat"
}

setwd(wdpath)


cat('Load Matlab articles ... ')
tic = proc.time()[3]
matlabFile <- readMat('output/pdataTest.mat')
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))

# cat('Load Matlab articles ... ')
# tic = proc.time()[3]
# matlabFile <- readMat('output/pdata.mat')
# toc = proc.time()[3] - tic
# cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))


datList = matlabFile$pdataTest
datList = lapply(datList, unlist, use.names=FALSE)
pdata <- as.data.frame(datList) # now has correct number of obs and vars

names(pdata) <- c('patentnr', 'indic_year', 'indic_week', 'manAutomat', 
               'manCognitive', 'manManual', 'uspc_nr', 'title_str')

pdata$manCognitive[is.nan(pdata$manCognitive)] <- 0
pdata$manManual[is.nan(pdata$manManual)] <- 0
