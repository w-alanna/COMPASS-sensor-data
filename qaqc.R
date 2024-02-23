# qaqc.R

# ssh  hart187@compass.pnl.gov <- connect to COMPASS on powershell
# /compass/datasets/fme_data_release/sensor_data/Level1/v0-9/ <- all the COMMPASS files
# scp hart187@compass.pnl.gov:/compass/datasets/fme_data_release/sensor_data/Level1/v0-9/PTR_2022/PTR_20220701-20220731_L1_v0-9.csv .
#fme20002

library(dplyr)
summaryOfData <- function() {
  #read in file
  compassData <- read.csv("data\\COMPASS-dataset.csv")
  
  #making dataframe
  dataSummary <- data.frame(matrix(ncol = 3))
  colnames(dataSummary) <- c('Names', 'numOfNA', 'StandardDeviation')

  #get the number of na rows and standard Deviation
  dataSummary <- compassData %>% group_by(research_name) %>%
    summarise(n_NA = sum(is.na(value)), stdev = sd(value, na.rm = TRUE))
}

