#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Please provide username."
    exit 1
fi

# Assign the argument to a variable
USERNAME=$1

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit
fi

# Check if the home directory exists
if [ ! -d "/home/$USERNAME" ]; then
    echo "Home directory /home/$USERNAME does not exist."
    exit 1
fi

# Clone the dotfiles repository
if ! git clone https://github.com/aaweaver-actuary/dotfiles.git; then
    echo "Failed to clone repository."
    exit 1
fi

# Move the files to the user's home directory
if ! mv ./dotfiles/.bashrc "/home/$USERNAME/.bashrc"; then
    echo "Failed to move .bashrc."
    exit 1
fi
if ! mv ./dotfiles/.profile "/home/$USERNAME/.profile"; then
    echo "Failed to move .profile."
    exit 1
fi
if ! mv ./dotfiles/.hushlogin "/home/$USERNAME/.hushlogin"; then
    echo "Failed to move .hushlogin."
    exit 1
fi
if ! mv ./dotfiles/.gitconfig "/home/$USERNAME/.gitconfig"; then
    echo "Failed to move .gitconfig."
    exit 1
fi
if ! mv ./dotfiles/.gitignore_global "/home/$USERNAME/.gitignore_global"; then
    echo "Failed to move .gitignore_global."
    exit 1
fi


# Remove the dotfiles directory
rm -rf ./dotfiles