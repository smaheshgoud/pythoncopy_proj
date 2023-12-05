# script.py

import shutil
import os

def copy_file(source_path, destination_path):
    try:
        shutil.copy(source_path, destination_path)
        print(f"File copied successfully from {source_path} to {destination_path}")
    except Exception as e:
        print(f"Error copying file: {e}")

if __name__ == "__main__":
    # Specify the source and destination paths
    source_folder = 'C:\\Path\\To\\Your\\Source\\Folder'
    destination_folder = 'C:\\Path\\To\\Your\\Destination\\Folder'
    file_to_copy = 'YourFile.txt'

    source_path = os.path.join(source_folder, file_to_copy)
    destination_path = os.path.join(destination_folder, file_to_copy)

    # Call the copy_file function
    copy_file(source_path, destination_path)
