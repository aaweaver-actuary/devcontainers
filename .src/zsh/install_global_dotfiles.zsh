#! /bin/env zsh

# Create /home/user if it does not exist
mkdir -p /home/user

# Clone the dotfiles repository
if ! git clone https://github.com/aaweaver-actuary/dotfiles.git; then
    echo "Failed to clone repository."
    exit 1
fi

# Define an array of files to move
files_to_move=(".profile" ".hushlogin" ".gitconfig" ".gitignore_global" ".zshrc" ".zsh_aliases")

# Move the files to the user's home directory
for file in "${files_to_move[@]}"; do
    if ! mv "./dotfiles/$file" "/home/user/$file"; then
        echo "Failed to move $file."
        exit 1
    fi
done

# Remove the dotfiles directory
rm -rf ./dotfiles