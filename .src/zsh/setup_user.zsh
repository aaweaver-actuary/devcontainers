#! /bin/env zsh

# List the 5 most recently-created users:
echo awk -F':' '{print $1}' /etc/passwd | tail -n 5

# Create /home/user if it does not exist
mkdir -p /home/user

# Add the user
groupadd --gid 150 "user" || { echo "Failed to add group 'user'. Exiting."; exit 1; }
useradd --uid 150 --gid 150 -m "user" || { echo "Failed to add user 'user'. Exiting."; exit 1; }

# Set the permissions for the home directory
chmod 777 /home/user || { echo "Failed to set permissions for home directory. Exiting."; exit 1; }

# Create the app directory
mkdir /app || { echo "Failed to create /app directory. Exiting."; exit 1; }

# Change the owner of the app directory to the new user
chown -R user:user /app || { echo "Failed to change owner of /app. Exiting."; exit 1; }

# Set the permissions for the app directory
chmod -R 777 /app || { echo "Failed to set permissions for /app. Exiting."; exit 1; }