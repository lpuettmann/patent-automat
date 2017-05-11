
rm(list=ls()) # clear all variables from memory

library(dplyr)
library(readr)

# Set working directory
if (identical(.Platform$OS.type, "windows") &
    identical(Sys.getenv("USERNAME"), "Puettmann")) {
  wdpath <- 'D:/patent-automat'
} else if (identical(.Platform$OS.type, "unix")) { # Unix includes Mac
  wdpath <- '/Users/Lukas/Documents/mydocs/projects/PatentSearch_Automation/patent-automat'
} else if (identical(.Platform$OS.type, "windows") &
           identical(Sys.getenv("USERNAME"), "puttman")) {
  wdpath <- 'C:/Users/puttman/Desktop/patent-automat'
}


setwd(wdpath)

sicData <- read_rds('output/sicData.rds')

nameList <- c('Agriculture, Forestry, And Fishing', 'Mining', 'Construction', 'Manufacturing', 
              'Transportation, Communications, Electric, Gas, And Sanitary Services', 'Wholesale trade', 'Retail trade', 
              'Finance, Insurance, And Real Estate', 'Services', 'Public Administration')


for (i in 1:10) {
  sicData$overcatName[(sicData$overcat == LETTERS[i])] <- nameList[i]
}


manuf <- sicData %>% filter(overcat == 'D')
manuf$majorGroup <- NA
manuf$majorGroupName <- NA
manufMajorGroupList <- c('Food And Kindred Products',
                        'Tobacco Products',
                        'Textile Mill Products',
                        'Apparel And Other Finished Products Made From Fabrics And Similar Materials',
                        'Lumber And Wood Products, Except Furniture',
                        'Furniture And Fixtures',
                        'Paper And Allied Products',
                        'Printing, Publishing, And Allied Industries',
                        'Chemicals And Allied Products',
                        'Petroleum Refining And Related Industries',
                        'Rubber And Miscellaneous Plastics Products',
                        'Leather And Leather Products',
                        'Stone, Clay, Glass, And Concrete Products',
                        'Primary Metal Industries',
                        'Fabricated Metal Products, Except Machinery And Transportation Equipment',
                        'Industrial And Commercial Machinery And Computer Equipment',
                        'Electronic And Other Electrical Equipment And Components, Except Computer Equipment',
                        'Transportation Equipment',
                        'Measuring, Analyzing, And Controlling Instruments; Photographic, Medical And Optical Goods; Watches And Clocks',
                        'Miscellaneous Manufacturing Industries')

stopifnot(length(manufMajorGroupList) == length(20:39))

for (i in 1:20) {
  st <- (i + 19) * 100
  en <- (i + 20) * 100 - 1
  manuf$majorGroup[((manuf$sic >= st) & (manuf$sic <= en))] <- (i + 19)
  manuf$majorGroupName[((manuf$sic >= st) & (manuf$sic <= en))] <- manufMajorGroupList[i]
}










