# qaqc.R

# ssh  hart187@compass.pnl.gov <- connect to COMPASS on powershell
# /compass/datasets/fme_data_release/sensor_data/Level1/v0-9/ <- all the COMMPASS files
# scp hart187@compass.pnl.gov:/compass/datasets/fme_data_release/sensor_data/Level1/v0-9/PTR_2022/PTR_20220701-20220731_L1_v0-9.csv .

process <- function() {
  library(dplyr)
  #fme20002
  #read in file
  compassData <- read.csv("data\\COMPASS-dataset.csv")
  
  #filter na colmuns
  summaryData <- compassData %>% filter(!complete.cases(value) | !complete.cases(F_OOB)) %>% group_by(research_name)
  
  #spliting dataframe based on research_name
  dataSplit <- split(summaryData, f = summaryData$research_name)
  
  #getting list for standard deviation
  deviationList <- split(compassData, f=compassData$research_name)
  
  #getting count for dataSplit
  nullRows <- data.frame(matrix(ncol = 3, nrow = length(dataSplit)))
  colnames(nullRows) <- c('Names', 'numOfNA', 'StandardDeviation')
  
  for(i in 1:length(dataSplit)) {
    nullRows$Names[i] <- dataSplit[[i]]$research_name
    nullRows$numOfNA[i] <- length(dataSplit[[i]]$value)
    nullRows$StandardDeviation[i] <- sd(deviationList[[i]]$value)
  }
  
  
  
}

