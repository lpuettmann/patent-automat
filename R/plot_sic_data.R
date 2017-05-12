
rm(list=ls()) # clear all variables from memory

library(dplyr)
library(readr)
library(ggplot2)

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

nameListShort <- c('Agriculture', 'Mining', 'Construction', 'Manufacturing', 
              'Utilities', 'Wholesale trade', 'Retail trade', 
              'Finance', 'Services', 'Public Administration')

sicData$majorGroup <- substr(sicData$sic, 1, 2)





for (i in 1:10) {
  sicData$overcatName[(sicData$overcat == LETTERS[i])] <- nameList[i]
  sicData$overcatNameShort[(sicData$overcat == LETTERS[i])] <- nameListShort[i]
}


serv <- sicData %>% filter(overcatName == 'Services')
serv$majorGroupName <- NA
serv$majorGroupNameShort <- NA
servMajorGroupNum <- c(70, 72, 73, 75, 76, 78, 79, 80, 81, 82, 83, 84, 86, 87, 88, 89)
servMajorGroupList <- c('Hotels, Rooming Houses, Camps, And Other Lodging Places',
                      'Personal Services (Laundry, Photo, Beauty, Barber, Shoe Repair, Funeral, Tax)',
                      'Business Services (Advertising, Computer Programming)',
                      'Automotive Repair, Services, And Parking',
                      'Miscellaneous Repair (Electric, Watches, Furniture)',
                      'Motion Pictures',
                      'Amusement And Recreation Services',
                      'Health Services',
                      'Legal Services',
                      'Educational Services',
                      'Social Services',
                      'Museums, Art Galleries, And Botanical And Zoological Gardens',
                      'Membership Organizations',
                      'Engineering, Accounting, Research, Management, And Related Services',
                      'Private Households (Babysitting, farm homes, maids)',
                      'Miscellaneous Services')
servMajorGroupListShort <- c('Tourism',
                             'Personal',
                             'Business',
                             'Automotive',
                             'Repair',
                             'Cinema',
                             'Amusement',
                             'Health',
                             'Legal',
                             'Education',
                             'Social',
                             'Museums',
                             'Organizations',
                             'Research',
                             'Private',
                             'Miscellaneous')
stopifnot(length(servMajorGroupNum) == 16)
stopifnot(length(servMajorGroupList) == 16)
stopifnot(length(servMajorGroupList) == length(servMajorGroupListShort))

for (i in 1:16) {
  serv$majorGroupName[serv$majorGroup == servMajorGroupNum[i]] <- servMajorGroupList[i]
  serv$majorGroupNameShort[serv$majorGroup == servMajorGroupNum[i]] <- servMajorGroupListShort[i]
}

sum(serv$automix.use)

ggplot(serv, aes(x = majorGroupNameShort, y = automix.use)) +
  stat_summary(fun.y = sum, geom = "bar") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Services patents, 1976-2014\n(SIC 1987 major groups)") +
  xlab('') + ylab("Total number of automation patents")


sum(serv$automix.use[(serv$majorGroupNameShort == 'Repair')])
sum(serv$automix.use[(serv$majorGroupNameShort == 'Research')])

sum(serv$automix.use) - 
  sum(serv$automix.use[(serv$majorGroupNameShort == 'Repair')]) -
  sum(serv$automix.use[(serv$majorGroupNameShort == 'Research')]) -
  sum(serv$automix.use[(serv$majorGroupNameShort == 'Health')])

health <- serv %>% 
  filter(majorGroupNameShort == 'Health') %>% 
  group_by(sic) %>% 
  summarize(sumAutomixUse = sum(automix.use))


ggplot(health, aes(x = sic, y = automix.use)) +
  stat_summary(fun.y = sum, geom = "bar") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

health <- health[order(health$sumAutomixUse, decreasing = TRUE),]



manuf <- sicData %>% filter(overcat == 'D')
manuf$majorGroup <- NA
manuf$majorGroupName <- NA
manuf$majorGroupNameShort <- NA
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

manufMajorGroupListShort <- c('Food',
                           'Tobacco',
                           'Textile mill products',
                           'Apparel',
                           'Lumber and wood',
                           'Furniture and fixtures',
                           'Paper',
                           'Printing and publishing',
                           'Chemicals',
                           'Petroleum refining',
                           'Rubbe and plastics',
                           'Leather',
                           'Stone, clay, glass, concrete',
                           'Primary Metal Industries',
                           'Fabricated metal products',
                           'Machinery and computers',
                           'Electronics',
                           'Transportation equipment',
                           'Measuring instruments; watches',
                           'Miscellaneous')


stopifnot(length(manufMajorGroupList) == length(20:39))
stopifnot(length(manufMajorGroupList) == length(manufMajorGroupListShort))


for (i in 1:20) {
  st <- (i + 19) * 100
  en <- (i + 20) * 100 - 1
  manuf$majorGroup[((manuf$sic >= st) & (manuf$sic <= en))] <- (i + 19)
  manuf$majorGroupName[((manuf$sic >= st) & (manuf$sic <= en))] <- manufMajorGroupList[i]
  manuf$majorGroupNameShort[((manuf$sic >= st) & (manuf$sic <= en))] <- manufMajorGroupListShort[i]
}

ggplot(manuf, aes(x = majorGroupNameShort, y = automix.use)) +
  stat_summary(fun.y = sum, geom = "bar") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Manufacturing patents, 1976-2014\n(SIC 1987 major groups)") +
  xlab('') + ylab("Total number of automation patents")
ggsave('output/manuf_autom_totals.pdf', width = 10, height = 6)

AA <- manuf %>% 
  group_by(majorGroupNameShort) %>% 
  summarize(shareAutom = sum(automix.use) / sum(patents.use))

ggplot(AA, aes(x = majorGroupNameShort, y = shareAutom) ) +
  geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Manufacturing patents, 1976-2014\n(SIC 1987 major groups)") +
  xlab('') + ylab("Share of patents classified as automation")
ggsave('output/manuf_autom_share.pdf', width = 10, height = 6)




myManufSum <- manuf %>%
  group_by(majorGroupNameShort) %>% 
  summarize(sumAutomixUse = sum(automix.use))


myManufSum <- myManufSum[order(myManufSum$sumAutomixUse, decreasing = TRUE),]
myManufSum$sumAutomixUse[1] / sum(myManufSum$sumAutomixUse)
myManufSum$sumAutomixUse[2] / sum(myManufSum$sumAutomixUse)
myManufSum$sumAutomixUse[3] / sum(myManufSum$sumAutomixUse)
myManufSum$sumAutomixUse[4] / sum(myManufSum$sumAutomixUse)
sum(myManufSum$sumAutomixUse[5:nrow(myManufSum)]) / sum(myManufSum$sumAutomixUse)


restPats <- sicData %>% 
  filter((overcatNameShort != 'Manufacturing') & 
           (overcatNameShort != 'Services'))

myRestPatsSummary <- restPats %>%
  group_by(overcatNameShort) %>% 
  summarize(sumAutomixUse = sum(automix.use))
myRestPatsSummary <- myRestPatsSummary[order(myRestPatsSummary$sumAutomixUse, decreasing = TRUE),]


ggplot(restPats, aes(x = overcatNameShort, y = automix.use) ) +
  stat_summary(fun.y = sum, geom = "bar") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Non-manufacturing patents, 1976-2014\n(SIC 1987 divisions without manufacturing)") +
  xlab('') + ylab("Total number of automation patents")
ggsave('output/restPats_autom_totals.pdf', width = 10, height = 6)

BB <- restPats %>% 
  group_by(overcatNameShort) %>% 
  summarize(shareAutom = sum(automix.use) / sum(patents.use))

ggplot(BB, aes(x = overcatNameShort, y = shareAutom) ) +
  geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Non-manufacturing patents, 1976-2014\n(SIC 1987 divisions without manufacturing)") +
  xlab('') + ylab("Share of patents classified as automation")
ggsave('output/restPats_autom_share.pdf', width = 10, height = 6)


(sum(restPats$automix.use) + sum(serv$automix.use)) / sum(sicData$automix.use)
sum(serv$automix.use) / (sum(restPats$automix.use) + sum(serv$automix.use)) 

sum(health$sumAutomixUse) / sum(serv$automix.use)

health$sumAutomixUse[1] / sum(serv$automix.use)
health$sumAutomixUse[2] / sum(serv$automix.use)

sum(health$sumAutomixUse) - health$sumAutomixUse[1] - health$sumAutomixUse[2]

sum(restPats$automix.use) / sum(sicData$automix.use)
sum(manuf$automix.use) / sum(sicData$automix.use)


myMachinesSummary <- manuf %>%
  filter(majorGroupNameShort == 'Machinery and computers') %>% 
  group_by(sic) %>% 
  summarize(sumAutomixUse = sum(automix.use))
myMachinesSummary <- myMachinesSummary[order(myMachinesSummary$sumAutomixUse, decreasing = TRUE),]

computers <- myMachinesSummary %>% filter(sic %in% 3571:3579)
sum(computers$sumAutomixUse)

myElectronicsSummary <- manuf %>%
  filter(majorGroupNameShort == 'Electronics') %>% 
  group_by(sic) %>% 
  summarize(sumAutomixUse = sum(automix.use))
myElectronicsSummary <- myElectronicsSummary[order(myElectronicsSummary$sumAutomixUse, decreasing = TRUE),]


finance <- sicData %>%
  filter(overcatNameShort == 'Finance') %>% 
  group_by(year) %>% 
  summarize(sumAutomixUse = sum(automix.use),
            sumPatentsUse = sum(patents.use))

sum(finance$sumAutomixUse) / sum(finance$sumPatentsUse)





