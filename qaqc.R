# qaqc.R

library(dplyr)
library(readr)
library(ggplot2)
compute_na_sd <- function(filename) {
  message("Reading ", filename)
  #read in file
  compassData <- read_csv(filename)
  #add add column
  compassData <- compassData %>% mutate(date = as.Date(TIMESTAMP))
  
  #test
  test <- nrow(compassData$value)
  
  #get the number of na rows and standard Deviation
  compassData %>% 
    group_by(research_name, date) %>%
    summarise(n_NA = sum(is.na(value)),
              average = mean(value, na.rm = TRUE),
              stdev = sd(value, na.rm = TRUE),
              p_sd = n_NA/(sum(!is.na(ID))),
              site = "MSM",
              plot = substring(design_link,tail(unlist(gregexpr("MSM", design_link)))+4,nchar(design_link))) %>%
    return()
} #portion = tail(unlist(gregexpr("MSM", design_link)))

out <- compute_na_sd("data\\COMPASS-dataset.csv")

#plots with n_NA column
ggplot(out, aes(x=date, y=n_NA)) + geom_bar(stat="identity") + facet_wrap(~research_name, scales = "free")
#plots with p_sd
ggplot(out, aes(x=date, y=p_sd)) + geom_bar(stat = "identity") + facet_wrap(~research_name, scales = "free")

library(dplyr)
compute_na_sd_forList <- function(folder) {
  #gets the files from the folder
  listOfFiles <- list.files(folder, pattern = "csv$", full.names = TRUE)
  
  list <- lapply(listOfFiles, compute_na_sd)
  
  bind_rows(list) %>% return()
}








# ssh  hart187@compass.pnl.gov <- connect to COMPASS on powershell
# /compass/datasets/fme_data_release/sensor_data/Level1/v0-9/ <- all the COMMPASS files
# scp hart187@compass.pnl.gov:/compass/datasets/fme_data_release/sensor_data/Level1/v0-9/PTR_2022/PTR_20220701-20220731_L1_v0-9.csv .
#fme20002


#> site <- "MSM" > year <- "2023" > > folder <- file.path("data", paste(site, year, sep = "_""))
#site <- "MSM" 

#year <- "2023"

#folder <- file.path("data", paste(site, year, sep = "_""))
 
#then list.files(folder)...