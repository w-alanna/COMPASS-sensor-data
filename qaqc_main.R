
library(dplyr)
compute_na_sd_forList <- function(f_site, f_year) {
  #gets name of folder
  file = paste(f_site, f_year, sep = "_")
  folder = paste("data\\", file, "\\", sep = "")
  
  #gets the files from the folder
  listOfFiles <- list.files(folder, pattern = "csv$", full.names = TRUE)
  
  list <- lapply(listOfFiles, compute_na_sd, mainsite=f_site)

  bind_rows(list) %>% return()
}

#average
#out2 %>% ggplot(aes(date, average)) + geom_line() + facet_wrap(~research_name, scales="free")
#out2 %>% ggplot(aes(date, p_sd)) + geom_line() + facet_wrap(~research_name, scales="free")

