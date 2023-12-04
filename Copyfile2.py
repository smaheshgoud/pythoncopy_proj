# remote_copy.py

import shutil
import os

def copy_file(source_path, destination_path):
    try:
        shutil.copy(source_path, destination_path)
        print(f"File copied successfully from {source_path} to {destination_path}")
    except Exception as e:
        print(f"Error copying file: {e}")

# Example usage
source_folder = r'C:\Path\To\Your\Source\Folder'
destination_folder = r'C:\Path\To\Your\Destination\Folder'
file_to_copy = 'YourFile.txt'

source_path = os.path.join(source_folder, file_to_copy)
destination_path = os.path.join(destination_folder, file_to_copy)

copy_file(source_path, destination_path)
