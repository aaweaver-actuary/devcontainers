FROM alpine:3.19

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.76.0 \
    HOME=/home/user \
    NODE_TLS_REJECT_UNAUTHORIZED=0 \
    RUST_BACKTRACE=1 \
    RUST_LOG=info \
    USER=user

WORKDIR /usr/staging

RUN apk update && apk add --no-cache \
    build-base \
    curl \
    bash \
    git \
    libffi-dev \
    openssl-dev \
\
    && mkdir -p /usr/local/rustup \
      /usr/local/cargo \
      /usr/local/cargo/bin \
      /home/user \
\
    && touch /home/user/.profile \
      /home/user/.bashrc \
      /home/user/.bash_profile \
      /home/user/.hushlogin \
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
    && apk del curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /usr/staging

# Set up vs code server to SSH into
RUN apk add --no-cache openssh-server \
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

# Set the default user 
USER user

# Set the default working directory
WORKDIR $HOME

CMD ["/bin/bash"]