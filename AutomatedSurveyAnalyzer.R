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

source("ASAfunctions.R")

#main df
df <- read.csv("SchoolLunchSurvey.csv")

clean_df <- clean_df(df)

scales <- as.list(read.csv("SchoolLunchScales.csv"))
scales <- lapply(scales, function(z){ z[!is.na(z) & z != ""]})

# Manual Inputs ----
#column to start and end
column_range_start <- 19
column_range_end <- 25
column_range <- seq(from = column_range_start, to = column_range_end)

demoList <- list(3,2)




# analysis ----
for (question in column_range)
{
  #use cleaned_df to create frequency tables
  #Frequency function
  freq <- frequencies(df[question])
  #sort columns, record the color palette
  j=0
  for(scale in scales)
  {
    j <- j+1
    
    if(identical(sort(scale),sort(colnames(freq))))
    {
      freq <- freq[scale]
      factors <- scale
      customcolors <- unlist(scales[j+1])
      names(customcolors) = scale
    }
  }
  #add demographics
  for (demo in demoList)
  {
    #enumerate all the options in the demographic (optionList)
    optionList<- unique(clean_df[[demo]])
    for (option in optionList)
    {
      #create a subset of the data based on the [option]
      subset <- filter(clean_df, !!as.symbol(names(clean_df[demo])) == option)
      #do a frequency of that subset
      freqD <- frequencies(subset[question])
      #sort columns
      #append that frequency row to the above frequency table
    }
  }
  
  #convert to percentage
  #hypothesis test
  #charts
  #output report
}
