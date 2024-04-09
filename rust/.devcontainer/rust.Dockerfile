FROM mcr.microsoft.com/devcontainers/rust as base

ENV LANGUAGE=rust
WORKDIR /app
COPY ../../Makefile /app/Makefile

RUN apt-get update -o Acquire::https::Verify-Peer false && apt-get install -o Acquire::https::Verify-Peer=false -y \
        make \
        git \
        zsh \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rustup component add rustfmt clippy \
    && make install_dotfiles \
    && install_dotfiles ~ install_oh_my_zsh \
    && chmod +x ./install_oh_my_zsh \
    && . ./install_oh_my_zsh \
    && rm install_oh_my_zsh \
    && install_dotfiles ~ .zshrc .zsh_aliases install_rust_analyzer \
    && chmod +x ./install_rust_analyzer \
    && . ./install_rust_analyzer \
    && rm install_rust_analyzer \
    && exec zsh

CMD [ "zsh" ]
