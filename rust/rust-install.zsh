#! /bin/env zsh

# List of components to install
rustup_components_to_install=(
    "rust-src"
    "rust-std"
    "rustfmt"
    "clippy"
    "rust-analyzer"
)

rust_binaries=(
    "cargo"
    "rustc"
    "rustup"
    "rustdoc"
    "rustfmt"
    "cargo-clippy"
    "rust-analyzer"
)

# Install rustup components
for component in ${rustup_components_to_install[@]}; do
    rustup component add $component || { echo "install - loc1 - Failed to install rustup component $component. Exiting."; exit 1; }
done


apt-get update 
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends git zsh
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/* 
    
# Link the rust binaries to /usr/bin (replace '/local/cargo/' with '')
bin_stem="/usr/local/cargo/bin/"
for binary in ${rust_binaries[@]}; do
    ln -s "${bin_stem}${binary}" "/usr/bin/${binary}" || { echo "install - loc2 - Failed to link binary $binary. Exiting."; exit 1; }
done