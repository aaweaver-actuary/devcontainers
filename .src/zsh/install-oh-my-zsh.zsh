#! /bin/env zsh
OHMYZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install curl and try again."
    exit 1
fi

# Install oh my zsh via curl
sh -c "$(curl -fsSL $OHMYZSH_URL)" \
    || { echo "Failed to install oh-my-zsh. Exiting."; exit 1; }

# Set the default shell to zsh
chsh -s $(which zsh) || { echo "Failed to set default shell to zsh. Exiting."; exit 1; }

# Install .zshrc and .zsh_aliases
chmod +x ./install_dotfiles.zsh
./install_dotfiles.zsh $HOME .zshrc .zsh_aliases

# Reload the shell
exec zsh