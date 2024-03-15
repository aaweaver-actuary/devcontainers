#! /bin/sh

# Update the packages
apt update -y || { echo "install - loc1 - Failed to update packages. Exiting."; exit 1; }
apt upgrade -y || { echo "install - loc2 - Failed to upgrade packages. Exiting."; exit 1; }

# Set to non-interactive
export DEBIAN_FRONTEND=noninteractive || { echo "install - loc3 - Failed to set DEBIAN_FRONTEND. Exiting."; exit 1; }

# Install zsh and curl
apt install -y zsh || { echo "install - loc4 - Failed to install zsh. Exiting."; exit 1; }
apt install -y curl || { echo "install - loc4a - Failed to install zsh. Exiting."; exit 1; }

# Change the default shell to zsh
chsh -s $(which zsh) || { echo "install - loc5 - Failed to change default shell to zsh. Exiting."; exit 1; }

# Reload the shell
exec zsh