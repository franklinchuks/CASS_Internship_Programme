clean_func <- function(df, value = "-NA-") 
{
  names(df) <- tolower(names(df))
  names(df) <- gsub("[^[:alnum:]]+", "_", names(df))
  names(df) <- make.unique(names(df))
  df <- df[, colSums(is.na(df)) < nrow(df)]
  df <- df[rowSums(is.na(df)) < ncol(df), ]
  df <- df[!duplicated(df), ]
  df[df == ""] <- value
  return(df)
}

frequency_func <- function(data) {
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

percentage_func <- function(data) {
  frequency <- table(data)
  total <- sum(frequency)
  values <- names(frequency)
  frequency_df <- data.frame(matrix(0, nrow = 1, ncol = length(values)))
  colnames(frequency_df) <- values
  for (i in seq_along(values)) {
    frequency_df[1, i] <- paste0(round(frequency[[values[i]]] / total * 100, 2), "%")
  }
  frequency_df <- frequency_df[, !colnames(frequency_df) %in% c("-NA-"), drop = FALSE]
  return(frequency_df)
}

demo_func <- function(type, data) {
  optionList <- sort(unique(clean_df[[demo]]))
  rowVector <- c()
  for (option in optionList) {
    subset <- filter(clean_df, !!as.symbol(names(clean_df[demo])) == option)
    if (type == "frequency") {
      dataD <- frequency_func(subset[question])
    } else if (type == "percentage") {
      dataD <- percentage_func(subset[question])
    }
    data <- bind_rows(data, dataD)
    rowVector <- append(rowVector, option)
  }
  return(data)
}

sort_func <- function(data, scales) {
  j <- 0
  for (scale in scales) {
    j <- j + 1
    if (identical(sort(scale), sort(colnames(data)))) {
      data <- data[scale]
    }
  }
  return(data)
}


