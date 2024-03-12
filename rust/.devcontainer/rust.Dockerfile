FROM mcr.microsoft.com/devcontainers/rust as base

# Setup a non-root user
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV HOME=/home/${USERNAME}
WORKDIR /home/${USERNAME}

# Create the user with specified USER_UID and USER_GID
RUN if getent group $USER_GID ; then echo "Group $USER_GID already exists"; else groupadd --gid $USER_GID $USERNAME; fi \
    && if id -u $USERNAME > /dev/null 2>&1; then echo "User $USERNAME already exists"; else useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chmod 777 ${HOME}


# Switch to the user's home directory
WORKDIR $HOME

# Install the Rust components, other tools, and dotfiles
RUN rustup component add rust-src \
    && rustup component add rust-std \
    && rustup component add rustfmt \
    && rustup component add clippy \
    && rustup component add rust-analyzer \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    git bash \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/aaweaver-actuary/dotfiles.git \
    && mv ./dotfiles/.bashrc /home/user/.bashrc \ 
    && mv ./dotfiles/.profile /home/user/.profile \ 
    && mv ./dotfiles/.hushlogin /home/user/.hushlogin \
    && mv ./dotfiles/.prettierrc /home/user/.prettierrc \
    && mv ./dotfiles/.gitconfig /home/user/.gitconfig \
    && mv ./dotfiles/.gitignore_global /home/user/.gitignore_global \
    && rm -rf ./dotfiles \
    && ln -s /usr/local/cargo/bin/cargo /usr/bin/cargo \
    && ln -s /usr/local/cargo/bin/rustc /usr/bin/rustc \
    && ln -s /usr/local/cargo/bin/rustup /usr/bin/rustup \
    && ln -s /usr/local/cargo/bin/rustdoc /usr/bin/rustdoc \
    && ln -s /usr/local/cargo/bin/rustfmt /usr/bin/rustfmt \
    && ln -s /usr/local/cargo/bin/cargo-clippy /usr/bin/cargo-clippy \
    && ln -s /usr/local/cargo/bin/rust-analyzer /usr/bin/rust-analyzer \
    && mkdir -p /home/${USERNAME}/.vscode-server \
    && mkdir -p /home/${USERNAME}/.vscode-server-insiders

# Set the default shell to bash rather than sh
SHELL ["/bin/bash", "-c"]

WORKDIR /app

RUN chown -R user:user /home/user \
    && chmod -R 777 /home/user \
    && chown -R user:user /app \
    && chmod -R 777 /app  \
    && chown -R user:user /usr/local/cargo \
    && chmod -R 777 /home/${USERNAME}/.vscode-server \
    && chmod -R 777 /home/${USERNAME}/.vscode-server-insiders

CMD sleep infinity