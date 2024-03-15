#!/usr/bin/env zsh

# Check if the correct number of arguments are passed
if (( $# != 3 )); then
    echo "Illegal number of parameters. Please provide username, user_gid, and user_uid."
    exit 1
fi

# Set execution trace and others to debug
set -x
set -e
set -u
set -o pipefail


# Assign the arguments to variables with default values if they are set to 'root' or '0'
USERNAME=${1:-user}
USER_GID=${2:-1001}
USER_UID=${3:-1001}

# Ensure USERNAME is not 'root'. If so, default to 'user'
if [[ "$USERNAME" == "root" ]]; then
    echo "Username cannot be 'root'. Defaulting to 'user'."
    echo "Username before: $USERNAME"
    USERNAME="user"
    echo "Username after: $USERNAME"
fi

# Ensure USER_GID and USER_UID are not '0'. If so, default to 1001
if [[ $USER_GID -eq 0 ]]; then
    echo "User GID cannot be '0'. Defaulting to 1001."
    echo "User GID before: $USER_GID"
    USER_GID=1001
    echo "User GID after: $USER_GID"
fi

if [[ $USER_UID -eq 0 ]]; then
    echo "User UID cannot be '0'. Defaulting to 1001."
    echo "User UID before: $USER_UID"
    USER_UID=1001
    echo "User UID after: $USER_UID"
fi

# Prevent creating users or groups with names or IDs reserved for system use
if [[ "$USERNAME" == "root" || $USER_UID -eq 0 || $USER_GID -eq 0 ]]; then
    echo "Attempted to use a reserved username or ID. Exiting."
    exit 1
fi

# Check if the group with the specified GID already exists
if getent group | cut -d: -f3 | grep -qw "$USER_GID"; then
    echo "Group with GID $USER_GID already exists"
elif getent group "$USERNAME" >/dev/null; then
    echo "Group $USERNAME already exists"
else
    groupadd --gid $USER_GID $USERNAME || { echo "Failed to add group $USERNAME. Exiting."; exit 1; }
fi

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