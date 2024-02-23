# qaqc.R

# ssh  hart187@compass.pnl.gov <- connect to COMPASS on powershell
# /compass/datasets/fme_data_release/sensor_data/Level1/v0-9/ <- all the COMMPASS files
# scp hart187@compass.pnl.gov:/compass/datasets/fme_data_release/sensor_data/Level1/v0-9/PTR_2022/PTR_20220701-20220731_L1_v0-9.csv .
#fme20002

library(dplyr)
compute_na_sd <- function(filename) {
  #read in file
  compassData <- read.csv(filename)
  
  #get the number of na rows and standard Deviation
  compassData %>% 
    group_by(research_name) %>%
    summarise(n_NA = sum(is.na(value)), stdev = sd(value, na.rm = TRUE)) %>%
    return()
}

out <- compute_na_sd("data\\COMPASS-dataset.csv")

