#!/usr/bin/env zsh

# Ensure the script is executed with at least two arguments
if (( $# < 2 )); then
    echo "Usage: $0 <target_directory> <file_names...>"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git and try again."
    exit 1
fi

# Assign the target directory and remove it from the list of arguments
TARGET_DIRECTORY=$1
shift

# Clone the GitHub repository
REPO_URL="https://github.com/aaweaver-actuary/dotfiles.git"
REPO_DIR="dotfiles_repo"

git clone --quiet $REPO_URL $REPO_DIR

# Check if the clone was successful
if [[ ! -d $REPO_DIR ]]; then
    echo "Failed to clone repository. Exiting."
    exit 1
fi

# Move to the repository directory
cd $REPO_DIR || { echo "Failed to change directory. Exiting."; exit 1; }

# Loop through all remaining arguments (file names)
for file_name in "$@"; do
    # Check if the file exists in the root of the cloned repo
    if [[ -f $file_name ]]; then
        # Move or copy the file to the target directory
        # Using 'mv' for moving; replace with 'cp' to copy instead
        mv "$file_name" "$TARGET_DIRECTORY/$file_name" || { echo "Failed to move '$file_name'. Skipping."; continue; }
        echo "Installed '$file_name' at '$TARGET_DIRECTORY/$file_name'"
    fi
done

# Move up one level and remove the dotfiles repo
cd .. || { echo "Failed to change directory. Exiting."; exit 1; }
rm -rf $REPO_DIR