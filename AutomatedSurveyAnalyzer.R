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
for (package in packages) {
  #Checking if package is loaded
  if (!require(package, character.only = TRUE)) {
    #Install and load package if not loaded yet
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

#set wd
#setwd("")

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
  
  
