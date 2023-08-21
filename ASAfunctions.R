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

frequency2 <- function(data) {
  frequency <- table(data)
  
  values <- names(frequency)
  frequency_df <- data.frame(matrix(0, nrow = 1, ncol = length(values)))
  colnames(frequency_df) <- values
  
  for (i in seq_along(values)) {
    frequency_df[1, i] <- frequency[[values[i]]]
  }
  
  frequency_df <- frequency_df[, !colnames(frequency_df) %in% c("-NA-"),drop = FALSE]
  return(frequency_df)
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

percentages <- function(data) {
  values <- colnames(data)
  total_values <- sum(data)
  percentage_df <- data.frame(matrix(0, nrow = 1, ncol = length(values)))
  colnames(percentage_df) <- values
  for (i in seq_along(values)) {
    percentage_df[1, i] <- round(((data[1, i] / total_values) * 100), 2)
  }
  return(percentage_df)
}

frequency_chart <- function(plotData, custom_colors)
{
  ggFreq <- ggplot(plotData, aes(fill= fct_rev(response), y=as.numeric(as.character(frequency)), x = fct_inorder(Alagrupid))) + #basic plot structure
    geom_bar(position="fill", stat = "identity", width = 0.7) + #horizontal bar size and setup
    theme(aspect.ratio = 4/3,legend.position="top", legend.key.size = unit(0.4, 'cm'),legend.text = element_text(size=8), panel.background = element_rect(fill="white"),
          panel.grid.major = element_line(colour = "black")) + coord_flip()+ # size, legend info, grids, backgrounds, etc.
    labs(x ="", y = "Vastuste osakaal (%)",fill = "") + #axis labels
    scale_y_continuous(labels = scales::percent)+ #axis denominations
    guides(fill = guide_legend(nrow=2))+ # make legend 2 rows
    guides(fill = guide_legend(reverse = TRUE))+
    geom_text(data = plotData %>% 
                group_by(Alagrupid) %>%
                mutate(p = as.numeric(as.character(frequency)) / sum(as.numeric(as.character(frequency)))) %>%
                ungroup(),
              aes(y = p, label = ifelse(p>0.039,scales::percent(p,accuracy = 1L),"")),
              position = position_stack(vjust = 0.5),
              show.legend = FALSE,size=2.5)+ #convert long to percentages, why do this? I already have percentages in another table. I guess I just hate myself
    scale_fill_manual(values = custom_colors, drop = FALSE) # manually assign color gradient since palettes do not account for consistency across questions with different numbers of responses, also "I don't know" should be gray
  
  return(ggFreq)
}

