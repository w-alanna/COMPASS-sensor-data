library(readr)
library(dplyr)
library(lubridate)

# Function to do the analysis for a file
compute_na_sd <- function(filename) {
	message("\treading ", basename(filename))
	fileData <- read_csv(filename, show_col_types = FALSE)
	#adds column holding the date
	fileData <- fileData %>% mutate(date = as.Date(TIMESTAMP, format="%m/%d/%y"))
	
	#summarizes the data
  fileData %>% 
    group_by(research_name, date) %>%
    summarise(n_NA = sum(is.na(Value)),
    average = mean(Value, na.rm = TRUE),
    stdev = sd(Value, na.rm = TRUE),
  	mad=mad(Value, na.rm=TRUE),
  	site=Site,
    pct_NA = n_NA/(sum(!is.na(ID))), .groups="drop") %>% 
  return()
}


#analysis of a folder using rank
send_dir_path <- function(rank, index, out_dir) {
	
  #gets list of the sub directories
  all_data_dirs <- list.dirs("/compass/datasets/fme_data_release/sensor_data/Level1/v1-0", full.names=TRUE)[-1]
  #chooses sub directory to be processed based on rank
  my_dir <- all_data_dirs[rank]
	message("processing ", my_dir)
	
	#gets the files in the folder choosen
	files_in_dir <- list.files(my_dir, pattern="csv$", full.names=TRUE)
	#sends the files to the compute_na_sd function to be processed
	list_files <- lapply(files_in_dir, compute_na_sd)
	finish_files <- bind_rows(list_files)	
  # write results to CSV
  out_file <- file.path(out_dir, paste0("example_output_", rank, "_", index, ".csv"))
  write.csv(finish_files, out_file, row.names = FALSE)
	message("wrote out file ", out_file)
}




# ======= Start of main script; called from the run_example.sl script ======

# The first argument is the SLURM task ID
rank <- Sys.getenv("SLURM_PROCID")
message("running with rank ", rank)

# batch size for the number of runs to process on a single node
# We want to take advantage of the multi-core nature of the compute nodes
batch_size <- 10

# directory to write the output CSV files to
out_dir <- "/compass/fme200002/ahart/COMPASS-sensor-data/output_dir"

# Run the thing and produce output file for each iteration in parallel
for (i in batch_size) {
  send_dir_path(rank, i, out_dir)
}

