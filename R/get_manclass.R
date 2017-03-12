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


cat('Load Matlab patent meta-data ... ')
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


cat('Load Matlab patent token incidence matrices ... ')
tic = proc.time()[3]
matlabFile <- readMat('output/dictInc.mat')
toc = proc.time()[3] - tic
cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))

dictInc = matlabFile$dictInc
dictInc <- data.frame(dictInc)

# Load the dictionary
find_dictionary <- read.table('specs/find_dictionary.txt', sep = ",")
dictLen <- length(find_dictionary)

tNames <- list()
aNames <- list()
bNames <- list()

for (i in 1:dictLen) {
  tNames[i] <- paste('t_', find_dictionary[1, i], sep = "")
  aNames[i] <- paste('a_', find_dictionary[1, i], sep = "")
  bNames[i] <- paste('b_', find_dictionary[1, i], sep = "")
}

fullNames <- rbind(tNames, aNames, bNames)

names(dictInc) <- fullNames



# cat('Save patent data ... ')
# tic = proc.time()[3]
# savePath <- paste(getwd(), "/output/pdata.RData", sep = "")
# save(pdata, file = savePath)
# toc = proc.time()[3] - tic
# cat(paste("done. [", round(toc, digits = 1), "s]\n", sep = ""))








