## ---------------------------
##
## Script name: Automated Survey Analyzer
##
## Purpose of script: Universal utility for analyzing survey data and outputting usable results and visulaizations
##
## Author: Martin Hayford
##
## Date Created: 27.07.2023 (version 2.0)
##
## Copyright (c) Universtiy of Tartu Centre for Applied Social Sciences, 2023
## Email: martin.hayford@ut.ee
##
## ---------------------------
##
## Notes: Internship project code for CASS summer internship program 2023
##   
##
## ---------------------------

## set working directory for Mac and PC

# automatically set to local github repository
#setwd("")

## ---------------------------

#clear environment if not empty
if (length(ls()) > 0) {
  rm(list = ls())
  closeAllConnections()
}

#Packages required
packages <- c("tidyverse",
              "janitor",
              "scales",
              "RColorBrewer",
              "officer",
              "flextable",
              "survey")

#Looping through packages
for (package in packages)
{
  #Checking if package is loaded
  if (!require(package, character.only = TRUE)) 
  {
    #Install and load package if not loaded yet
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

#main df
df <- read.csv("SchoolLunchSurvey.csv")
cleaned_df <- df %>%
  clean_names() %>%
  remove_empty(c("rows", "cols"))

scale_df <- read.csv("SchoolLunchScales.csv")

#column to start and end
column_range_start <- 19
column_range_end <- 25
column_range <- seq(from = column_range_start, to = column_range_end)

# loop through each question, questions are manually designated by the column_range
for (i in column_range)
{
  #use cleaned_df to create frequency tables
}

#defining frequency function
frequencies <- function(data) 
{
  
  #convert to list
  frequency_list <- list()
  
  #column names of specified columns
  column_names <- colnames(cleaned_df)[column_range]
  
  for (column_name in column_names) 
  {
    #get frequencies for each column
    frequency_table <- table(data[[column_name]])
    
    #convert list to df
    frequency_df <- as.data.frame(frequency_table)
    
    #get column names
    colnames(frequency_df) <- c("Value", column_name)
    
    #append frequency to the list
    frequency_list[[column_name]] <- frequency_df
  }
  
  #join the frequency tables
  join_freq_df <- Reduce(function(x, y) merge(x, y, by = "Value", all = TRUE), frequency_list)
  
  #get frequency df
  return(join_freq_df)
}



##################################################################

#function to calculate frequencies for a column
get_frequencies_col <- function(data, col) {
  #calculate frequency
  freq_table <- table(data[[col]])
  freq_df <- as.data.frame(freq_table)
  
  #add column name as new column
  freq_df$Column <- col
  return(freq_df)
}

#init freq_list
freq_list <- list()

#loop column range
for (col in column_range) {
  #call frequency function
  freq_df <- get_frequencies_col(cleaned_df, col)
  
  #put each column frequency in freq_list
  freq_list[[col]] <- freq_df
}

#put freq_list in a df
freq_df_combined <- do.call(rbind, freq_list)

View(freq_df_combined)

#######################################################################



