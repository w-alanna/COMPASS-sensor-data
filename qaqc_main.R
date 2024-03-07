
library(dplyr)
compute_na_sd_forList <- function(f_site, f_year) {
  #gets name of folder
  file = paste(f_site, f_year, sep = "_")
  folder = paste("data\\", file, "\\", sep = "")
  
  #gets the files from the folder
  listOfFiles <- list.files(folder, pattern = "csv$", full.names = TRUE)
  
  list <- lapply(listOfFiles, compute_na_sd)
  
  bind_rows(list) %>% return()
}

#> site <- "MSM" > year <- "2023" > > folder <- file.path("data", paste(site, year, sep = "_""))
#site <- "MSM" 

#year <- "2023"

#folder <- file.path("data", paste(site, year, sep = "_""))

#then list.files(folder)...