#! /bin/env zsh

# List of packages to install
packages_to_install=(
    "build-essential"
    "libssl-dev"
    "zlib1g-dev"
    "libbz2-dev"
    "libreadline-dev"
    "libsqlite3-dev"
    "curl"
    "make"
    "zsh"
    "git"
    "libncursesw5-dev"
    "xz-utils"
    "tk-dev"
    "libxml2-dev"
    "libxmlsec1-dev"
    "libffi-dev"
    "liblzma-dev"
)

# List of binaries to link to
binaries_to_link=(
    "/usr/local/go/bin/go"
    "/usr/local/go/bin/gofmt"
)

# Update the packages
apt update -y || { echo "install - loc1 - Failed to update packages. Exiting."; exit 1; }
apt upgrade -y || { echo "install - loc2 - Failed to upgrade packages. Exiting."; exit 1; }
apt full-upgrade -y || { echo "install - loc3 - Failed to full-upgrade packages. Exiting."; exit 1; }

# Set to non-interactive
export DEBIAN_FRONTEND=noninteractive || { echo "install - loc4 - Failed to set DEBIAN_FRONTEND. Exiting."; exit 1; }

# Install the packages
apt install -y --no-install-recommends ${packages_to_install[@]} || { echo "install - loc5 - Failed to install packages. Exiting."; exit 1; }

# Remove unnecessary packages
apt autoremove -y || { echo "install - loc6 - Failed to autoremove packages. Exiting."; exit 1; }

# Clean the packages
apt clean -y || { echo "install - loc7 - Failed to clean packages. Exiting."; exit 1; }

# Remove the package lists
rm -rf /var/lib/apt/lists/* || { echo "install - loc8 - Failed to remove package lists. Exiting."; exit 1; }

# Install the specified version of Python and the required packages
curl -k -L https://pyenv.run | zsh || { echo "install - loc9 - Failed to install pyenv. Exiting."; exit 1; }

# Add the pyenv environment variables to the .zshrc file
echo 'export PATH="/home/user/.pyenv/bin:$PATH"' >> /home/user/.zshrc

# Initialize pyenv on shell startup
echo 'eval "$(pyenv init --path)"' >> /home/user/.zshrc
echo 'eval "$(pyenv init -)"' >> /home/user/.zshrc

# Link the pyenv binary to /usr/bin
ln -s /home/user/.pyenv/bin/pyenv /usr/bin/pyenv

# Add r/w/x permissions to the .pyenv directory
chmod -R 777 /home/user/.pyenv

# Reload the .zshrc file
source /home/user/.zshrc

# Install the specified version of Python and the required packages
PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto'
PYTHON_CFLAGS='-march=native -mtune=native'
pyenv install $python_version || { echo "install - loc10 - Failed to install Python. Exiting."; exit 1; }

# Set the global version of Python
pyenv global $python_version || { echo "install - loc11 - Failed to set global version of Python. Exiting."; exit 1; }

# rehash pyenv
pyenv rehash

# Link the Python binary to /usr/bin/py
ln -s /home/user/.pyenv/versions/$python_version/bin/python /usr/bin/py