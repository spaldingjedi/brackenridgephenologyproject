
# Load required libraries
library(hazer)
library(jpeg)
library(data.table)

# Set up the main directory containing subfolders with images
main_dir <- '/Users/spald/Downloads/May 2024 download/May 2024 download/Timelapse'

# Get a list of all subdirectories within the main directory
sub_dirs <- list.dirs(path = main_dir, recursive = TRUE, full.names = TRUE)

# Initialize an empty data.table to store results
haze_mat <- data.table()

# Initialize a progress counter
total_files <- 0
for (sub_dir in sub_dirs) {
  jpg_files <- list.files(path = sub_dir, pattern = '\\.jpg$', ignore.case = TRUE, full.names = TRUE)
  total_files <- total_files + length(jpg_files)
}

# Initialize the progress bar
pb <- txtProgressBar(min = 0, max = total_files, style = 3)

# Initialize a file counter for the progress bar
file_counter <- 0

# Loop through each subdirectory
for (sub_dir in sub_dirs) {
  # Get a list of all .jpg files in the subdirectory
  jpg_files <- list.files(path = sub_dir, pattern = '\\.jpg$', ignore.case = TRUE, full.names = TRUE)
  
  # Loop through each image file
  for (image_path in jpg_files) {
    # Extract the file name
    file_name <- basename(image_path)
    
    # Assuming the site name starts at the 16th character (just an example, adjust based on actual format)
    start_pos <- 70
    site_name_length <- 3
    
    # Extract the site name "C01" by counting forwards
    site_name <- substr(image_path, start_pos, start_pos + site_name_length -  1)
    
    # Extract the first letter of the site name
    first_letter <- substr(site_name, 1, 1)
    
    # Read the image
    img <- jpeg::readJPEG(image_path)
    
    # Calculate the haze factor
    haze <- getHazeFactor(img)
    
    # Append the results to the haze_mat data.table
    haze_mat <- rbind(haze_mat, data.table(file = image_path, site = site_name, first_letter = first_letter, haze = haze[1], A0 = haze[2]))
    
    # Update the progress bar
    file_counter <- file_counter + 1
    setTxtProgressBar(pb, file_counter)
  }
}
# Calculate the proportion of images with haze index < 0.4 for each unique site name
haze_summary <- haze_mat[, .(
  total_images = .N,
  haze_less_than_0_4 = sum(haze < 0.4),
  proportion_haze_less_than_0_4 = mean(haze < 0.4)
), by = site]

# Print the summary table
print(haze_summary)
# Calculate the proportion of images with haze index < 0.4 for each unique site name
haze_summary2 <- haze_mat[, .(
  total_images = .N,
  haze_less_than_0_4 = sum(haze < 0.4),
  proportion_haze_less_than_0_4 = mean(haze < 0.4)
), by = first_letter]

# Print the summary table
print(haze_summary2)

# Close the progress bar
close(pb)
# Ensure 'haze' and 'A0' are numeric vectors
haze_mat[, haze := as.numeric(haze)]
haze_mat[, A0 := as.numeric(A0)]
# Print the resulting data table
print(haze_mat)
write.csv(haze_summary,"/Users/spald/Downloads/MayPhotosHazinessSummary1.csv")
write.csv(haze_summary2,"/Users/spald/Downloads/MayPhotosHazinessSummary2.csv")
write.csv(haze_mat,"/Users/spald/Downloads/MayPhotosByHaziness.csv") 