library(ggplot2)
library(dbplyr)
library(readr)

#add title to plots
#add color to show outliers


post_process <- function(filename) {
  #csv file
  fileData <- read_csv(filename)
  
  #site name
  siteName <- fileData$site[1]
  #year name
  year <- fileData$date[1]
  year <- substring(year, 1, 4)
  
  
  #make subdirectory for the site
  subdir <- paste("C:\\Users\\hart187\\compass-plots\\", siteName, year, "\\", sep="")
  
  #splits the data from file by research name
  research_name_list <-split(fileData,fileData$research_name)

  #I think the script overrides folders
  #makes the plots
  for(rn in research_name_list) {

    rn$outlier <- outlier(rn$mad)
    if (all(is.na(rn$mad))) {
      warning("Skipping", rn)
      next
    }
    picture_name <- paste(subdir, rn$research_name[1], "_", siteName, ".png", sep="")
    rn %>% ggplot(aes(date,mad, na.rm = TRUE, color = factor(outlier))) + 
           geom_point() + ggtitle(paste(siteName,year,rn$research_name[1])) + labs(color = "Outliers") 
    ggsave(picture_name, width = 7, height = 7)
    message("Wrote ", picture_name)
  }
}

outlier <- function(x, probs=c(0.05, 0.95)) {
  q <- quantile(x, probs=probs, na.rm = TRUE)
  
  is_outlier <- x < q[1] | x > q[2]
  return(is_outlier)
}

post_process_main <- function(folder) {
  file_list <- list.files(folder, pattern="csv$", full.names=TRUE)
  lapply(file_list, post_process)
}

size_of_dataframe <- function(folder) {
  file_list <- list.files(folder, pattern="csv$", full.names=TRUE)
  sink("C:\\Users\\hart187\\size-crc2022")
  for(filename in file_list) {
    fileData <- read_csv(filename)
    text <- paste(filename, " - ", fileData$site[1], fileData$date[1], nrow(fileData))
    cat(text)
  }
  sink()
}
#"C:\\Users\\hart187\\output_dir\\example_output_1_10.csv"