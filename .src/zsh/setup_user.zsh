#!/usr/bin/env zsh

# Check if the correct number of arguments are passed
if (( $# != 3 )); then
    echo "Illegal number of parameters. Please provide username, gid, and uid."
    exit 1
fi

# Set execution trace and others to debug
set -x
set -e
set -u
set -o pipefail


# Assign the arguments to variables with default values if they are set to 'root' or '0'
USER=${1:-user}
GID=${2:-1001}
UID=${3:-1001}

# Ensure USERNAME is not 'root'. If so, default to 'user'
if [[ "$USER" == "root" ]]; then
    echo "Username cannot be 'root'. Defaulting to 'user'."
    echo "Username before: $USER"
    USER="user"
    echo "Username after: $USER"
fi

# Ensure GID and UID are not '0'. If so, default to 1001
if [[ $GID -eq 0 ]]; then
    echo "User GID cannot be '0'. Defaulting to 1001."
    echo "User GID before: $GID"
    GID=1001
    echo "User GID after: $GID"
fi

if [[ $UID -eq 0 ]]; then
    echo "User UID cannot be '0'. Defaulting to 1001."
    echo "User UID before: $UID"
    UID=1001
    echo "User UID after: $UID"
fi

# # Prevent creating users or groups with names or IDs reserved for system use
# if [[ "$USER" == "root" || $UID -eq 0 || $GID -eq 0 ]]; then
#     echo "Attempted to use a reserved username or ID. Exiting."
#     exit 1
# fi

# # Check if the group with the specified GID already exists
# if getent group | cut -d: -f3 | grep -qw "$GID"; then
#     echo "Group with GID $GID already exists"
# elif getent group "$USER" >/dev/null; then
#     echo "Group $USER already exists"
# else
groupadd --gid $GID $USER || { echo "Failed to add group $USER. Exiting."; exit 1; }
# fi

# # Check if the group exists, if not add the group
# if getent group $GID > /dev/null 2>&1; then 
#     echo "Group $GID already exists"
# else 
#     groupadd --gid $GID $USER || { echo "Failed to add group $USER. Exiting."; exit 1; }
# fi

# # Check if the user exists, if not add the user
# if id -u $USER > /dev/null 2>&1; then 
#     echo "User $USER already exists"
# else 
useradd --uid $UID --gid $GID -m $USER || { echo "Failed to add user $USER. Exiting."; exit 1; }
# fi

# Update the system and install sudo
apt-get update && apt-get install -y sudo || { echo "Failed to update system and install sudo. Exiting."; exit 1; }

# Add the user to the sudoers file
echo "$USER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER || { echo "Failed to add $USER to sudoers. Exiting."; exit 1; }

# Set the permissions for the sudoers file
chmod 0440 /etc/sudoers.d/$USER || { echo "Failed to set permissions for sudoers file. Exiting."; exit 1; }

# Set the permissions for the home directory
chmod 777 ${HOME} || { echo "Failed to set permissions for home directory. Exiting."; exit 1; }

# Create the app directory
mkdir /app || { echo "Failed to create /app directory. Exiting."; exit 1; }

# Change the owner of the app directory to the new user
chown -R $USER:$USER /app || { echo "Failed to change owner of /app. Exiting."; exit 1; }

# Set the permissions for the app directory
chmod -R 777 /app || { echo "Failed to set permissions for /app. Exiting."; exit 1; }