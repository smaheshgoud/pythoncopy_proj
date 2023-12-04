import sys
import shutil

def copy_files(source_network_drive_letter, destination_network_drive_letter):
    source_network_path = f"{source_network_drive_letter}\\path\\to\\source_file.txt"
    destination_network_path = f"{destination_network_drive_letter}\\path\\to\\destination_file.txt"

    shutil.copy(source_network_path, destination_network_path)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python copy_files.py <source_network_drive_letter> <destination_network_drive_letter>")
        sys.exit(1)

    source_network_drive_letter = sys.argv[1]
    destination_network_drive_letter = sys.argv[2]

    copy_files(source_network_drive_letter, destination_network_drive_letter)
        