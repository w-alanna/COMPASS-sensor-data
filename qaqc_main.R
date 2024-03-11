SLURM_ID <- 1


library(dplyr)
compute_na_sd_forList <- function(SLURM_ID) {
  #makes list of folders
  dir_list = list.dirs("data")[-1]
  #makes list of the files
  listOfFiles <- list.files(dir_list[SLURM_ID], pattern = "csv$", full.names = TRUE)
  
  
  list <- lapply(listOfFiles, compute_na_sd, mainsite="MSM")

  bind_rows(list) %>% return()
}

#average
#out2 %>% ggplot(aes(date, average)) + geom_line() + facet_wrap(~research_name, scales="free")
#out2 %>% ggplot(aes(date, p_sd)) + geom_line() + facet_wrap(~research_name, scales="free")

