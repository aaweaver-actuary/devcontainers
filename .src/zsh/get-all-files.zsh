#! /bin/env zsh
# Script that creates a text file with the names of all files in the current directory

# Define the name of the file to create
ZSH_FILE_NAME=".zsh_files"

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" || \
    { echo "Failed to get directory of script. Exiting."; exit 1; }

# Append the name of the file to the directory
export ZSH_FILE_LIST="$DIR/$ZSH_FILE_NAME" || \
    { echo "Failed to set ZSH_FILE_LIST. Exiting."; exit 1; }

# Get this script's name
SCRIPT_NAME=$(basename $0) || \
    { echo "Failed to get script name. Exiting."; exit 1; }

# Create the file and write the names of all files in the current directory
# Exclude the .zsh_files file and the get-all-files.zsh script
ls | grep -vE "$ZSH_FILE_NAME|$SCRIPT_NAME" > $ZSH_FILE_LIST || \
    { echo "Failed to create $ZSH_FILE_LIST. Exiting."; exit 1; }

# Loop over those files adding +x permissions
while read -r file; do
    chmod +x $file || { echo "Failed to add +x permissions to $file. Exiting."; exit 1; }
done < $ZSH_FILE_LIST || \
    { echo "Failed to loop over files in $ZSH_FILE_LIST. Exiting."; exit 1; }
