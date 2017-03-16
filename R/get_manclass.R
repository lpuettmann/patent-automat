# Get the manually classified sample of patents.

rm(list=ls()) # clear all variables from memory

library(R.matlab)

# Set working directory
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  wdpath <- 'D:/patent-automat'
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- '/Users/Lukas/Documents/mydocs/projects/PatentSearch_Automation/patent-automat'
}

setwd(wdpath)


cat('Load Matlab patent meta-data ... '); tic = proc.time()[3]
matlabFile <- readMat('output/pdata.mat')
cat(paste("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n", sep = ""))

datList = matlabFile$pdata
datList = lapply(datList, unlist, use.names=FALSE)
pdata <- as.data.frame(datList)

names(pdata) <- c('patentnr', 'indic_year', 'manAutomat', 'manCognitive', 
                  'manManual', 'indic_NotSure', 'coderID', 'coderDate', 
                  'nr_pat_in_file', 'indic_week', 'line_start', 'line_end',
                  'title_str', 'uspc_nr', 'indic_exclclassnr',  'ipc_ocat', 'abstract', 
                  'body')

pdata$manCognitive[is.nan(pdata$manCognitive)] <- 0
pdata$manManual[is.nan(pdata$manManual)] <- 0
pdata$title_str <- as.character(pdata$title_str)
pdata$abstract <- as.character(pdata$abstract)
pdata$body <- as.character(pdata$body)
pdata$ipc_ocat <- as.factor(pdata$ipc_ocat)
pdata$patLength <- pdata$line_end - pdata$line_start

cat('Load Matlab patent token incidence matrices ... ')
tic = proc.time()[3]
matlabFile <- readMat('output/dictInc.mat')
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))

dictInc = matlabFile$dictInc
dictInc <- data.frame(dictInc)

# Load the dictionary
matlabFile <- readMat('output/fDictColNames.mat')
datList = matlabFile$fDictColNames
datList = lapply(datList, unlist, use.names=FALSE)
dictNames <- t(as.data.frame(datList))

# Assign incidence matrix the right variable names
stopifnot(ncol(dictInc) == length(dictNames))
names(dictInc) <- dictNames

# Combine meta-data with incidence matrix
pdata <- cbind(pdata, dictInc)

cat('Save patent data ... ')
tic = proc.time()[3]
savePath <- paste(getwd(), "/output/pdata.RData", sep = "")
save(pdata, file = savePath)
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))






