#!/usr/bin/env zsh

# Check if the correct number of arguments are passed
if (( $# != 1 )); then
    echo "Illegal number of parameters. Please provide username."
    exit 1
fi

# Assign the argument to a variable
USERNAME=$1

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "git could not be found"
    exit 1
fi

# Check if the home directory exists
if [[ ! -d "/home/$USERNAME" ]]; then
    echo "Home directory /home/$USERNAME does not exist."
    exit 1
fi

# Clone the dotfiles repository
if ! git clone https://github.com/aaweaver-actuary/dotfiles.git; then
    echo "Failed to clone repository."
    exit 1
fi

# Define an array of files to move
files_to_move=(".profile" ".hushlogin" ".gitconfig" ".gitignore_global" ".zshrc" ".zsh_aliases")

# Move the files to the user's home directory
for file in "${files_to_move[@]}"; do
    if ! mv "./dotfiles/$file" "/home/$USERNAME/$file"; then
        echo "Failed to move $file."
        exit 1
    fi
done

# Remove the dotfiles directory
rm -rf ./dotfiles