#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Please provide username."
    exit 1
fi

# Assign the argument to a variable
USERNAME=$1

# Create the directories if they do not exist
mkdir -p /home/$USERNAME
mkdir -p /app
mkdir -p /home/${USERNAME}/.vscode-server
mkdir -p /home/${USERNAME}/.vscode-server-insiders

# Change the owner and permissions of the home directory
chown -R $USERNAME:$USERNAME /home/$USERNAME
chmod -R 777 /home/$USERNAME

# Change the owner and permissions of the app directory
chown -R $USERNAME:$USERNAME /app
chmod -R 777 /app

# Change the permissions of the .vscode-server and .vscode-server-insiders directories
chmod -R 777 /home/${USERNAME}/.vscode-server
chmod -R 777 /home/${USERNAME}/.vscode-server-insiders