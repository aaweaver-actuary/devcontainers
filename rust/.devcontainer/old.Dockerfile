FROM alpine:3.19

LABEL maintainer="Andy Weaver <andrewayersweaver@gmail.com>"

# Set the default environment variables
ENV DOTFILES_REPO=aaweaver-actuary/dotfiles \
    NODE_TLS_REJECT_UNAUTHORIZED=0 \
    USER=user

# Set the language-specific environment variables
ENV LANG=rust \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    RUST_BACKTRACE=1 \
    RUST_LOG=info \
    RUST_VERSION=1.76.0 \
    PATH=/usr/local/rustup:/usr/local/cargo/bin:$PATH

# Language-specific folders
RUN mkdir -p /usr/local/rustup \
      /usr/local/cargo \
      /usr/local/cargo/bin \
      /home/user

# Set the current directory to a staging directory
WORKDIR /usr/staging

# Install updates & dev dependencies
RUN apk update && apk add --no-cache \
    build-base \
    curl \
    bash \
    git \
    libffi-dev \
    openssl-dev \
\
    && curl https://sh.rustup.rs -sSf \
    | sh -s -- -y --default-toolchain $RUST_VERSION \
\
    && rustup component add rust-src \
      clippy \
      rustfmt \
      rust-analyzer \
      cargo \
      llvm-tools \
      rls \
      rust-docs \
      rust-std \
      rustc \
\
    && ln -s /usr/local/cargo/bin/rustc /bin/rustc \
    && ln -s /usr/local/cargo/bin/cargo /bin/cargo \
    && ln -s /usr/local/cargo/bin/rustup /bin/rustup \
    && ln -s /usr/local/cargo/bin/rustdoc /bin/rustdoc \
    && ln -s /usr/local/cargo/bin/rustfmt /bin/rustfmt \
    && ln -s /usr/local/cargo/bin/rust-analyzer /bin/rust-analyzer \
    && ln -s /usr/local/cargo/bin/rls /bin/rls \
    && ln -s /usr/local/cargo/bin/cargo-clippy /bin/cargo-clippy \
    && ln -s /usr/local/cargo/bin/cargo-fmt /bin/cargo-fmt \
    && ln -s /usr/local/cargo/bin/cargo-miri /bin/cargo-miri \
\    
    && git clone https://github.com/aaweaver-actuary/dotfiles.git \
    && mv ./dotfiles/.bashrc $HOME/.bashrc \ 
    && mv ./dotfiles/.profile $HOME/.profile \ 
    && mv ./dotfiles/.hushlogin $HOME/.hushlogin \
    && mv ./dotfiles/.prettierrc $HOME/.prettierrc \
    && mv ./dotfiles/.gitconfig $HOME/.gitconfig \
    && mv ./dotfiles/.gitignore_global $HOME/.gitignore_global \
    && rm -rf ./dotfiles \
\
    && git clone https://github.com/aaweaver-actuary/devcontainers.git \
    && cd ./devcontainers/${LANG}/.devcontainer \
    && ls ./ -lahR \
    && mv ./.test $HOME/.test \
    && mv $HOME/.test/Makefile $HOME/Makefile \
    && cd ../../../ \
    && rm -rf ./devcontainers \
\
    && apk del curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /usr/staging \
\
    && apk add --no-cache openssh-server \
    && ssh-keygen -A \
    && adduser -D user \
    && echo "user:user" | chpasswd \
    && mkdir -p /home/user/.ssh \
    && chown -R user:user /home/user/.ssh \
    && chmod 700 /home/user/.ssh \
    && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \ 
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "AllowUsers user" >> /etc/ssh/sshd_config \
    && echo "Port 2222" >> /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 2222

# Set the default shell
SHELL ["/bin/bash", "-c"]

# Set the default working directory
WORKDIR $HOME

# Set the default user 
USER user

CMD ["/bin/bash"]