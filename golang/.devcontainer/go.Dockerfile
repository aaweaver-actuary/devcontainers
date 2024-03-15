FROM mcr.microsoft.com/devcontainers/go:1.22-bookworm as base

ENV LANGUAGE=golang

# Setup a non-root user
ENV USERNAME=user
ENV USER_UID=1001
ENV USER_GID=$USER_UID

# Switch to the user's home directory
WORKDIR $HOME

# Copy over the Makefile
COPY golang/.devcontainer/Makefile /usr/local/Makefile

# Copy the commands
COPY ../../zsh.tar.gz /tmp/zsh.tar.gz
COPY ../../${LANGUAGE}/${LANGUAGE}-install.zsh /usr/bin/${LANGUAGE}-install

USER root

RUN tar -xvf /tmp/zsh.tar.gz -C /usr/local/bin \
    && rm /tmp/zsh.tar.gz \
    && cd /usr/local/bin/.src/zsh \
    && mv ./install_dotfiles.zsh ./install_dotfiles \
    && chmod +x get-all-files.zsh \
    && ./get-all-files.zsh \
    && rm get-all-files.zsh \
    && ./install-zsh.sh \
\
    && ./setup_user.zsh "${USERNAME}" "${USER_GID}" "${USER_UID}" \
    && ./update_user_permissions.zsh "${USERNAME}" \
\
    && ./install_global_dotfiles.zsh "${USERNAME}" \
    && chmod +x /usr/bin/${LANGUAGE}-install \
    && /usr/bin/${LANGUAGE}-install \
    && ln -s /usr/local/bin/zsh/install_dotfiles /usr/bin/install_dotfiles

    # && ./install-oh-my-zsh.zsh \ <<-- maybe I don't need this??
WORKDIR /app

CMD sleep infinity