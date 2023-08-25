## ---------------------------
## Script name: Automated Survey Analyzer
##
## Purpose of script: Universal utility for analyzing survey data and outputting usable results and visualizations
##
## Author: Martin Hayford
##
## Date Created: 27.07.2023 (version 2.0)
##
## Copyright (c) University of Tartu Centre for Applied Social Sciences, 2023
## Email: martin.hayford@ut.ee 
##
## Notes: Internship project code for CASS summer internship program 2023
## ---------------------------
## set working directory for Mac and PC
# automatically set to local github repository
# setwd("")
## ---------------------------

#clear environment if not empty
if (length(ls()) > 0)
{
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

#source the functions for this script from the dedicated function script
source("ASAfunctions.R")

#Import and clean DataFrames
df <- read.csv("SchoolLunchSurvey.csv")
clean_df <- clean_df(df)

scales <- as.list(read.csv("SchoolLunchScales.csv"))
scales <- lapply(scales, function(z){ z[!is.na(z) & z != ""]}) #remove NA elements from the end of lists (artifact from importing procedure, all are imported as the same length)

# Manual Inputs ----
#column to start and end
column_range_start <- 19 #first question
column_range_end <- 25 #last question

demoList <- c(3,2) #each column number that will be used for demographic analysis (in the desired order of appearance in the frequency table)


column_range <- seq(from = column_range_start, to = column_range_end)

# analysis ----
for (question in column_range)
{
  #use cleaned_df to create frequency tables
  #Frequency function
  freq <- frequency2(clean_df[question])
  rowVector <- c("Total") #declare vector and add Total row

  #add demographics
  for (demo in demoList)
  {
    optionList <- sort(unique(clean_df[[demo]]))#enumerate all the options in the demographic (optionList)
    
    for (option in optionList)
    {
      #create a subset of the data based on the [option]
      subset <- filter(clean_df, !!as.symbol(names(clean_df[demo])) == option) #ugly filter requiring changing datatype and syntactic sugar indicating that the internal functions should run before, not parallel to the external function
      #do a frequency of that subset
      freqD <- frequency2(subset[question])
      #append that frequency row to the above frequency table
      freq <- bind_rows(freq,freqD)
      #add demographic option to the row label list
      rowVector <- append(rowVector,option)
    }
  }
  
  #sort columns, record the color palette
  j=0 #reset counter variable (this allows us to refer to the column after the correctly matched scale by its index)
  for(scale in scales)
  {
    j <- j+1
    
    if(identical(sort(scale),sort(colnames(freq)))) #proceed if the scale of the frequency table matches the scale we are checking against in the scales csv file
    {
      freq <- freq[scale] #this line orders the columns based on the order of the scale csv file
      factors <- scale # this preserves the correct order for later when we must set the factor levels
      customcolors <- unlist(scales[j+1]) #this creates an array of colors in the same order of the scale from the csv
      names(customcolors) = scale # this names the elements of the array based on that scale
    }
  }
  freqNames <- freq %>% # create new df with the names of the rows as the first column
    add_column(rowVector, .before = 1) %>% #add subgroup names as the first column
    rename(Alagrupid = rowVector) #alagrupid = subgroups, rename the auto-named column from the descriptive variable name "rowVector"
  print(freqNames)
  
  #convert to percentage
  #hypothesis test
  #    Fisher's exact test
  #charts
  
  freqLong <- freqNames %>% #convert from wide to long data (for the ggPlot)
    pivot_longer(cols=colnames(freq), #use the column names from the original freq df to enlongate ( all the different responses)
                 names_to='response', #call this new column response
                 values_to='frequency') # call the column of values associated with each response frequency
  freqLong$response <- factor(freqLong$response, levels = factors) # set the factor levels to the ones saved earlier based on the scales.csv manual input file
    
  ggOut <- frequency_chart(freqLong,customcolors) #call the ggplot2 frequency chart function, pass through the Long form of the frequency table and the custom colors we imported from the scales.csv manual input file
  print(ggOut)

  #output report
}
