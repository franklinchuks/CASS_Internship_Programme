### ---------------------------
##
## Script name: Automated Survey Analyzer Functions
##
## Purpose of script: functions for Universal utility for analyzing survey data and outputting usable results and visulaizations
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

frequencies <- function(data) {
  #calculate frequency table for column
  freq_table <- table(data)
  #transpose data frame
  freq_df_t <- t(as.data.frame(freq_table))
  #include column name
  colnames(freq_df_t) <- freq_df_t[1,]
  #rem first row
  freq_df_t <- t(freq_df_t[-1,])
  
  freq_df_t <- freq_df_t[, !colnames(freq_df_t) %in% c("-NA-")] #columns counting the frequency of NA are not being named NA?
  return(as.data.frame(t(freq_df_t)))
}

clean_df <- function(df, value = "-NA-") 
{
  #standardize column names
  names(df) <- tolower(names(df))
  names(df) <- gsub("[^[:alnum:]]+", "_", names(df))
  names(df) <- make.unique(names(df))
  
  #remove columns and rows with all missing values
  df <- df[, colSums(is.na(df)) < nrow(df)]
  df <- df[rowSums(is.na(df)) < ncol(df), ]
  df <- df[!duplicated(df), ]
  df[df == ""] <- value
  
  return(df)
}

fpercent <- function(ordinals) #convert frequencies to percentages in df
{
  rownames <- row.names(ordinals)
  ordinals[] <- lapply(ordinals, function(x) as.numeric(as.character(x))) #convert to numeric
  row.names(ordinals) <- rownames #save rownames as they are not preserved in future steps
  ordinalsPercent <- adorn_percentages(ordinals, denominator = "row", na.rm = TRUE, 1:ncol(ordinals)) #convert to percentages based on rows
  row.names(ordinalsPercent) <- rownames
  ordinalsPercent[1:ncol(ordinalsPercent)] <- sapply(ordinalsPercent[1:ncol(ordinalsPercent)], 
                                                     function(x) percent(x, accuracy=1)) #format as a percentage rounded to nearest tenth
  ordinalsPercent[ordinalsPercent == "0%"] <- NA #convert zeroes to NA so they are ignored by charting algorithm
  row.names(ordinalsPercent) <- rownames
  
  return(ordinalsPercent)
}