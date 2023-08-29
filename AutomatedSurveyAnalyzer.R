if (length(ls()) > 0)
{
  rm(list = ls())
  closeAllConnections()
}

packages <- c("tidyverse",
              "janitor",
              "scales",
              "RColorBrewer",
              "officer",
              "flextable",
              "survey")

for (package in packages)
{
  if (!require(package, character.only = TRUE)) 
  {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

source("ASAfunctions.R")

df <- read.csv("SchoolLunchSurvey.csv")
cleaned_df <- clean_func(df)

scales <- as.list(read.csv("SchoolLunchScales.csv"))
scales <- lapply(scales, function(z){ z[!is.na(z) & z != ""]})

column_range_start <- 19
column_range_end <- 25

demo <- 2

column_range <- seq(from = column_range_start, to = column_range_end)

for (question in column_range)
{
  freq <- frequency_func(cleaned_df[question])
  perc <- percentage_func(cleaned_df[question])
  rowVector <- c("Total")

  freq <- demo_func(type = "frequency", data)
  perc <- demo_func(type = "percentage", data)
  
  freq <- sort_func(freq, scales)
  perc <- sort_func(perc, scales)
  
  freqNames <- freq %>%
    add_column(rowVector, .before = 1) %>%
    rename(Alagrupid = rowVector)
  
  percNames <- perc %>%
    add_column(rowVector, .before = 1) %>%
    rename(Alagrupid = rowVector)
  
  
  print(freqNames)
  
  #convert to percentage
  #hypothesis test
  #    Fisher's exact test
}
