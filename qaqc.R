# qaqc.R
# Author - Alanna Hart 2024

library(dplyr)
library(readr)
library(ggplot2)
library(lubridate)
compute_na_sd <- function(filename, mainsite) {
  message("Reading ", filename)
  #read in file
  compassData <- read_csv(filename)
  #add add column
  compassData <- compassData %>% mutate(date = as.Date(TIMESTAMP, format="%m/%d/%y"))
  compassData <- compassData %>% group_by(research_name, date) %>% mutate(MAD=mad(value, na.rm=TRUE))
  
  #get the number of na rows and standard Deviation
  compassData %>% 
    group_by(research_name, date) %>%
    summarise(n_NA = sum(is.na(value)),
              average = mean(value, na.rm = TRUE),
              
              stdev = sd(value, na.rm = TRUE),
              pct_NA = n_NA/(sum(!is.na(ID))),
              site = mainsite,
              plot = substring(design_link,tail(unlist(gregexpr(mainsite, design_link)))+4,nchar(design_link)),
              outlier = if_else(value > average+MAD | value < average-MAD, plot, NA)) %>%
    return()
}


# case_when(value>average+MAD | value<average+mad ~plot))
#ifelse(value > average+MAD, plot, NULL)


<<<<<<< Updated upstream



=======
>>>>>>> Stashed changes
#out <- compute_na_sd("data\\MSM_2023\\MSM_20230101-20230131_L1_v0-9.csv", "MSM")


#plots with n_NA column
ggplot(out, aes(x=date, y=n_NA)) + geom_bar(stat="identity") + facet_wrap(~research_name, scales = "free")
#plots with p_sd
ggplot(out, aes(x=date, y=p_sd)) + geom_bar(stat = "identity") + facet_wrap(~research_name, scales = "free")


<<<<<<< Updated upstream





=======
>>>>>>> Stashed changes
# ssh  hart187@compass.pnl.gov <- connect to COMPASS on powershell
# /compass/datasets/fme_data_release/sensor_data/Level1/v0-9/ <- all the COMMPASS files
# scp hart187@compass.pnl.gov:/compass/datasets/fme_data_release/sensor_data/Level1/v0-9/PTR_2022/PTR_20220701-20220731_L1_v0-9.csv .
#fme20002
