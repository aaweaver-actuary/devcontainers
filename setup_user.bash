#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters. Please provide username, user_gid, and user_uid."
    exit 1
fi

# Assign the arguments to variables
USERNAME=$1
USER_GID=$2
USER_UID=$3

# Check if the group exists, if not add the group
if getent group $USER_GID ; then 
    echo "Group $USER_GID already exists"
else 
    groupadd --gid $USER_GID $USERNAME
fi

# Check if the user exists, if not add the user
if id -u $USERNAME > /dev/null 2>&1; then 
    echo "User $USERNAME already exists"
else 
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
fi

# Update the system and install sudo
apt-get update
apt-get install -y sudo

# Add the user to the sudoers file
echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME

# Set the permissions for the sudoers file
chmod 0440 /etc/sudoers.d/$USERNAME

# Set the permissions for the home directory
chmod 777 ${HOME}

# Create the app directory
mkdir /app

# Change the owner of the app directory to the new user
chown -R $USERNAME:$USERNAME /app

# Set the permissions for the app directory
chmod -R 777 /app

# # bash script that accepts username, user_gid, user_uid arguments, and adds the user

# if getent group $USER_GID ; then echo "Group $USER_GID already exists"; else groupadd --gid $USER_GID $USERNAME; fi \
#     && if id -u $USERNAME > /dev/null 2>&1; then echo "User $USERNAME already exists"; else useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME \
#     && chmod 777 ${HOME} \
#     && mkdir /app \
#     && chown -R $USERNAME:$USERNAME /app \
#     && chmod -R 777 /app