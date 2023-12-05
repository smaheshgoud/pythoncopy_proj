import sys
import paramiko
import os

def copy_files_on_windows(remote_server, source_folder, destination_folder, username, password):
    # Create an SSH client
    ssh = paramiko.SSHClient()

    # Automatically add the server's host key
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        # Connect to the remote Windows server
        ssh.connect(remote_server, username=username, password=password)

        # Create an SFTP session
        sftp = ssh.open_sftp()

        # Ensure the destination folder exists on the remote server
        try:
            sftp.stat(destination_folder)
        except FileNotFoundError:
            # If the destination folder doesn't exist, create it
            sftp.mkdir(destination_folder)

        # List files in the source folder on the remote server
        files = sftp.listdir(source_folder)

        # Copy each file from the source to the destination folder
        for file in files:
            source_file_path = os.path.join(source_folder, file)
            destination_file_path = os.path.join(destination_folder, file)
            sftp.get(source_file_path, destination_file_path)
            print(f"File '{file}' copied from {source_folder} to {destination_folder}.")

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Close the SFTP session and SSH connection
        if sftp:
            sftp.close()
        ssh.close()

if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: python copy_files.py <remote_server> <source_folder> <destination_folder> <username> <password>")
        sys.exit(1)

    remote_server = sys.argv[1]
    source_folder = sys.argv[2]
    destination_folder = sys.argv[3]
    username = sys.argv[4]
    password = sys.argv[5]

    copy_files_on_windows(remote_server, source_folder, destination_folder, username, password)
