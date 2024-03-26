SLURM_ID <- 1


library(dplyr)
compute_na_sd_forList <- function(SLURM_ID) {
  dir_name <- "data"
  #makes list of folders
  dir_list = list.dirs(dir_name)[-1]
  #makes list of the files
  listOfFiles <- list.files(dir_list[SLURM_ID], pattern = "csv$", full.names = TRUE)
  
  site_name <- substring(dir_list[SLURM_ID],nchar(dir_name)+2,nchar(dir_name)+4)
  
  list <- lapply(listOfFiles, compute_na_sd, mainsite=site_name)

  bind_rows(list) %>% return()
}

#average
#out2 %>% ggplot(aes(date, average)) + geom_line() + facet_wrap(~research_name, scales="free")
#out2 %>% ggplot(aes(date, p_sd)) + geom_line() + facet_wrap(~research_name, scales="free")

