# Assuming you have already created the join_freq_df using the provided code

# Remove NAs (if necessary)
join_freq_df <- join_freq_df[complete.cases(join_freq_df), ]

# Sort the table by frequency count (descending order)
join_freq_df <- join_freq_df[order(-join_freq_df[[colnames(join_freq_df)[2]]]), ]

# Reset row names
rownames(join_freq_df) <- NULL

# Print the cleaned frequency table
print(join_freq_df)
