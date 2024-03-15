#!/usr/bin/env zsh

# Check if the correct number of arguments are passed
if (( $# != 3 )); then
    echo "Illegal number of parameters. Please provide username, user_gid, and user_uid."
    exit 1
fi

# Assign the arguments to variables
USERNAME=$1
USER_GID=$2
USER_UID=$3

# Check if the group exists, if not add the group
if getent group $USER_GID > /dev/null 2>&1; then 
    echo "Group $USER_GID already exists"
else 
    groupadd --gid $USER_GID $USERNAME || { echo "Failed to add group $USERNAME. Exiting."; exit 1; }
fi

# Check if the user exists, if not add the user
if id -u $USERNAME > /dev/null 2>&1; then 
    echo "User $USERNAME already exists"
else 
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME || { echo "Failed to add user $USERNAME. Exiting."; exit 1; }
fi

# Update the system and install sudo
apt-get update && apt-get install -y sudo || { echo "Failed to update system and install sudo. Exiting."; exit 1; }

# Add the user to the sudoers file
echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME || { echo "Failed to add $USERNAME to sudoers. Exiting."; exit 1; }

# Set the permissions for the sudoers file
chmod 0440 /etc/sudoers.d/$USERNAME || { echo "Failed to set permissions for sudoers file. Exiting."; exit 1; }

# Set the permissions for the home directory
chmod 777 ${HOME} || { echo "Failed to set permissions for home directory. Exiting."; exit 1; }

# Create the app directory
mkdir /app || { echo "Failed to create /app directory. Exiting."; exit 1; }

# Change the owner of the app directory to the new user
chown -R $USERNAME:$USERNAME /app || { echo "Failed to change owner of /app. Exiting."; exit 1; }

# Set the permissions for the app directory
chmod -R 777 /app || { echo "Failed to set permissions for /app. Exiting."; exit 1; }