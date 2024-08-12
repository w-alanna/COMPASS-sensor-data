library(ggplot2)
library(dbplyr)
library(readr)
library(tidyr)

#Script that will create graphs using processed data
post_process <- function(filename) {
  
  #makes dataframe fro csv file
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

  #makes the plots
  for(rn in research_name_list) {
    #divides dates into weeks
    rn$week <- cut.Date(rn$date, breaks = "1 week", labels = FALSE)
    #filter out na values
    if (all(is.na(rn$mad))) {
      warning("Skipping", rn) #research names with no points are not plotted
      next
    }
    rn_mad <-drop_na(rn, mad)
    #uses outlier to highlight outliers in plots
    rn_mad$outlier <- outlier(rn_mad)
    #mad and outliers
    picture_name <- paste(subdir, rn$research_name[1], "_mad_", siteName, ".png", sep="")
    rn_mad %>% ggplot(aes(date,mad, na.rm = TRUE, color = factor(outlier))) + geom_point() +
      scale_y_continuous(name="emdian absolute deviation") + ggtitle(paste(siteName,year,rn$research_name[1])) + labs(color = "Outliers") 
    ggsave(picture_name, width = 7, height = 7)
    message("Wrote ", picture_name)
    
    #average with plots
    picture_name <- paste(subdir, rn$research_name[1], "_aver_", siteName, ".png", sep="")
    rn %>% ggplot(aes(date,average, na.rm = TRUE, color = factor(plot))) + 
      geom_smooth() + ggtitle(paste(siteName,year,rn$research_name[1])) + labs(color = "Plot") 
    ggsave(picture_name, width = 7, height = 7)
    message("Wrote ", picture_name)
    
    #standard deviation
    picture_name <- paste(subdir, rn$research_name[1], "_std_", siteName, ".png", sep="")
    rn %>% ggplot(aes(date,stdev, na.rm = TRUE, color = factor(plot))) + geom_line() +
      scale_y_continuous(name="standard deviation") + ggtitle(paste(siteName,year,rn$research_name[1])) + labs(color = "Plot") 
    ggsave(picture_name, width = 7, height = 7)
    message("Wrote ", picture_name)
    
    #pct_NA
    picture_name <- paste(subdir, rn$research_name[1], "_NA_", siteName, ".png", sep="")
    rn %>% ggplot(aes(date,pct_NA, na.rm = TRUE)) + 
      geom_bar(stat = "identity") + facet_wrap(vars(plot)) + ggtitle(paste(siteName,year,rn$research_name[1])) + labs(color = "Plot") 
    ggsave(picture_name, width = 7, height = 7)
    message("Wrote ", picture_name)
  }
}

#function that marks if points are outliers
outlier <- function(x, probs=c(0.05, 0.95)) {
  week_list <- split(x, x$week)
  full_outlier <- c()
  for(w in week_list) {
    data <- w$mad
    quan <- quantile(data, probs=probs, na.rm = TRUE)
    is_outlier <- data < quan[1] | data > quan[2]
    full_outlier <- c(full_outlier, is_outlier)
  }
    return(full_outlier)
}

#takes a folder and runs the post_process funtion on each folder
post_process_main <- function(folder) {
  file_list <- list.files(folder, pattern="csv$", full.names=TRUE)
  lapply(file_list, post_process)
}