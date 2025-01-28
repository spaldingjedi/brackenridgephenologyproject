import pandas as pd
import os
import shutil

# Load your CSV file
csv_file = 'C:/Users/spald/Downloads/FebruaryPhotosByHaziness.csv'
df = pd.read_csv(csv_file)
print(df)
# Destination folder
destination_folder = 'C:/Users/spald/Downloads/FebruaryPhotos/Timelapse/HazyPhotos'

# Loop through each row in the DataFrame
for index, row in df.iterrows():
    # Check if the haze value is greater than 0.4
    if row['haze'] > 0.4:
        # Extract the filename from the 'file' column (everything after the last '/')
        filename = os.path.basename(row['file'])

        # Construct the full destination path
        site = row['site']  # Assuming 'site' is a column in your DataFrame
        destination_path = os.path.join(destination_folder, site, filename)

        # Ensure the destination directory exists
        os.makedirs(os.path.dirname(destination_path), exist_ok=True)

        # Move the file
        shutil.move(row['file'], destination_path)
        print(f"Moved: {row['file']} to {destination_path}")