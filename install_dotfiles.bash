#!/bin/bash

# Ensure the script is executed with at least two arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <target_directory> <file_names...>"
    exit 1
fi

# Assign the target directory and remove it from the list of arguments
TARGET_DIRECTORY=$1
shift

# Clone the GitHub repository
REPO_URL="https://github.com/aaweaver-actuary/dotfiles.git"
REPO_DIR="dotfiles_repo"

git clone $REPO_URL $REPO_DIR

# Check if the clone was successful
if [ ! -d "$REPO_DIR" ]; then
    echo "Failed to clone repository. Exiting."
    exit 1
fi

# Move to the repository directory
cd $REPO_DIR

# Loop through all remaining arguments (file names)
for file_name in "$@"; do
    # Check if the file exists in the root of the cloned repo
    if [ -f "$file_name" ]; then
        # Move or copy the file to the target directory
        # Using 'mv' for moving; replace with 'cp' to copy instead
        mv "$file_name" "../$TARGET_DIRECTORY/"
    fi
done

# Move back to the original directory and clean up the cloned repository
cd ..
rm -rf $REPO_DIR

echo "Operation completed."
