#! /bin/env zsh

# List of packages to install
packages_to_install=(
    "curl"
    "make"
    "git"
    "zsh"
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

# Link to the go binaries
for binary in "${binaries_to_link[@]}"; do
    ln -s $binary /usr/local/bin/$(basename $binary) || { echo "install - loc9 - Failed to link $binary. Exiting."; exit 1; }
done
