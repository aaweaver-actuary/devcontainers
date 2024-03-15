#! /bin/env zsh
OHMYZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install curl and try again."
    exit 1
fi

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Please install zsh and try again."
    exit 1
fi

# # Check if oh my zsh is already installed, if so, remove it
# if [ -d "$HOME/.oh-my-zsh" ]; then
#     rm -rf $HOME/.oh-my-zsh || { echo "Failed to remove $HOME/.oh-my-zsh. Exiting."; exit 1; }
# fi
# if [ -d "/root/.oh-my-zsh" ]; then
#     sudo rm -rf /root/.oh-my-zsh || { echo "Failed to remove /root/.oh-my-zsh. Exiting."; exit 1; }
# fi

# Install oh my zsh via curl
(curl -fsSL $OHMYZSH_URL | zsh) \
    || { echo "Failed to install oh-my-zsh. Exiting."; exit 1; }

# Set the default shell to zsh
chsh -s $(which zsh) || { echo "Failed to set default shell to zsh. Exiting."; exit 1; }

# Install .zshrc and .zsh_aliases
chmod +x ./install_dotfiles.zsh
./install_dotfiles.zsh $HOME .zshrc .zsh_aliases

# Reload the shell
exec zsh