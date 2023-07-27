#Main script


#Franklin Chukwuemeka

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
setwd("")

#main df
df <- read.csv("SchoolLunchSurvey.csv")
cleaned_df <- df %>%
  clean_names() %>%
  remove_empty(c("rows", "cols"))

scale_df <- read.csv("SchoolLunchScales.csv")

#column to start and end
column_range_start <- 1
column_range_end <- 10
column_range <- seq(from = column_range_start, to = column_range_end)





#Samuel Amankwaa 