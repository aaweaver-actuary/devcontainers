#!/usr/bin/env zsh

# Check if the correct number of arguments are passed
if (( $# != 1 )); then
    echo "Illegal number of parameters. Please provide username."
    exit 1
fi

# Assign the argument to a variable
USERNAME=$1

# Define an array of directories to create
directories_to_create=("/home/$USERNAME" "/app" "/home/${USERNAME}/.vscode-server" "/home/${USERNAME}/.vscode-server-insiders")

# Create the directories if they do not exist and set permissions
for dir in "${directories_to_create[@]}"; do
    mkdir -p $dir || { echo "Failed to create directory $dir. Exiting."; exit 1; }
    chmod -R 777 $dir || { echo "Failed to set permissions for directory $dir. Exiting."; exit 1; }
done

# Define an array of directories to change owner
directories_to_chown=("/home/$USERNAME" "/app")

# Change the owner of the directories
for dir in "${directories_to_chown[@]}"; do
    chown -R $USERNAME:$USERNAME $dir || { echo "Failed to change owner for directory $dir. Exiting."; exit 1; }
done