# Get the manually classified sample of patents.

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


cat('Load Matlab patent data ... ')
tic = proc.time()[3]
matlabFile <- readMat('output/pdata.mat')
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))


datList = matlabFile$pdata
datList = lapply(datList, unlist, use.names=FALSE)
pdata <- as.data.frame(datList) # now has correct number of obs and vars

names(pdata) <- c('patentnr', 'indic_year', 'manAutomat', 'manCognitive', 
                  'manManual', 'indic_NotSure', 'coderID', 'coderDate', 
                  'nr_pat_in_file', 'indic_week', 'line_start', 'line_end',
                  'title_str', 'uspc_nr', 'indic_exclclassnr', 'abstract', 
                  'body')

pdata$manCognitive[is.nan(pdata$manCognitive)] <- 0
pdata$manManual[is.nan(pdata$manManual)] <- 0
pdata$title_str <- as.character(pdata$title_str)
pdata$abstract <- as.character(pdata$abstract)
pdata$body <- as.character(pdata$body)

cat('Save patent data ... ')
tic = proc.time()[3]
savePath <- paste(getwd(), "/output/pdata.RData", sep = "")
save(pdata, file = savePath)
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))









