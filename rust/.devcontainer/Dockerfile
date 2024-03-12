# Use a multi-stage build to keep the final image as small as possible
FROM alpine:3.19 as builder

# Install build dependencies
RUN apk add --no-cache build-base curl git

# Install Rust
ENV RUST_VERSION=1.76.0
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUST_VERSION

# Get the dotfiles
RUN git clone https://github.com/aaweaver-actuary/dotfiles.git \
    && mv ./dotfiles/.bashrc $HOME/.bashrc \ 
    && mv ./dotfiles/.profile $HOME/.profile \ 
    && mv ./dotfiles/.hushlogin $HOME/.hushlogin \
    && mv ./dotfiles/.prettierrc $HOME/.prettierrc \
    && mv ./dotfiles/.gitconfig $HOME/.gitconfig \
    && mv ./dotfiles/.gitignore_global $HOME/.gitignore_global \
    && rm -rf ./dotfiles

# Copy necessary build scripts and source code here
# RUN mkdir /source
# COPY ./my_project /source
# WORKDIR /source
# RUN cargo build --release

# Start a new stage from a fresh Alpine image to reduce size
FROM alpine:3.19

LABEL maintainer="Andy Weaver <andrewayersweaver@gmail.com>"

# Copy Rust build environment
COPY --from=builder /root/.cargo /root/.cargo
COPY --from=builder /root/.rustup /root/.rustup
COPY --from=builder /$HOME/.bashrc /root/.bashrc
COPY --from=builder /$HOME/.profile /root/.profile
COPY --from=builder /$HOME/.hushlogin /root/.hushlogin
COPY --from=builder /$HOME/.prettierrc /root/.prettierrc
COPY --from=builder /$HOME/.gitconfig /root/.gitconfig
COPY --from=builder /$HOME/.gitignore_global /root/.gitignore_global

# Install runtime dependencies
RUN apk add --no-cache libffi-dev openssl-dev openssh-server bash

# Copy binaries and any other runtime necessities from the builder stage
# COPY --from=builder /source/target/release/my_executable /usr/local/bin/

ENV USER=user \
    HOME=/home/user \
    RUSTUP_HOME=/root/.rustup \
    CARGO_HOME=/root/.cargo \
    PATH=/root/.cargo/bin:$PATH

# Configure SSH and user
RUN ssh-keygen -A \
    && adduser -D $USER \
    && echo "$USER:$USER" | chpasswd \
    && mkdir -p $HOME/.ssh \
    && chown -R $USER:$USER $HOME/.ssh \
    && chmod 700 $HOME/.ssh \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "AllowUsers $USER" >> /etc/ssh/sshd_config \
    && echo "Port 2222" >> /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# Environment variable settings, .bashrc, .profile, etc., can be copied here
# COPY --from=builder /path/to/dotfiles /home/user/

EXPOSE 2222
WORKDIR $HOME
USER $USER
CMD ["/usr/sbin/sshd", "-D"]
