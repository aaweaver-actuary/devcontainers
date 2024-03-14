FROM mcr.microsoft.com/devcontainers/go:1.22-bookworm as base

# Setup a non-root user
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV HOME=/home/${USERNAME}
WORKDIR /home/${USERNAME}

# # Create the user with specified USER_UID and USER_GID
# RUN if getent group $USER_GID ; then echo "Group $USER_GID already exists"; else groupadd --gid $USER_GID $USERNAME; fi \
#     && if id -u $USERNAME > /dev/null 2>&1; then echo "User $USERNAME already exists"; else useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME \
#     && chmod 777 ${HOME} \
#     && mkdir /app \
#     && chown -R $USERNAME:$USERNAME /app \
#     && chmod -R 777 /app


# Switch to the user's home directory
WORKDIR $HOME

# Copy over the Makefile
COPY golang/.devcontainer/Makefile /usr/local/Makefile

# Add a command to install dotfiles
COPY ../install_dotfiles.bash /home/user/install_dotfiles

# Create the user with specified USER_UID and USER_GID
COPY ../../setup_user.bash /tmp/setup_user.bash

# Update the user permissions
COPY ../../update_user_permissions.bash /tmp/update_user_permissions

# Install some global dotfiles
COPY ../../install_global_dotfiles.bash /tmp/install_global_dotfiles
RUN chmod +x /tmp/setup_user.bash \
    && /tmp/setup_user.bash "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm /tmp/setup_user.bash \
\
    && chmod +x /tmp/update_user_permissions \
    && /tmp/update_user_permissions "${USERNAME}" \
    && rm /tmp/update_user_permissions \
\
    && chmod +x /tmp/install_global_dotfiles \
    && /tmp/install_global_dotfiles "${USERNAME}" \
    && rm /tmp/install_global_dotfiles \
\
    && ln -s /home/user/install_dotfiles /usr/local/bin/install_dotfiles

# Install the Python components, other tools, and dotfiles
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        # build-essential \
        # libssl-dev \
        # zlib1g-dev \
        # libbz2-dev \
        # libreadline-dev \
        # libsqlite3-dev \
        curl \
        make \
        bash \
        git \
        # libncursesw5-dev \
        # xz-utils \
        # tk-dev \
        # libxml2-dev \
        # libxmlsec1-dev \
        # libffi-dev \
        # liblzma-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
\   
    && rm -rf ./dotfiles \
    && mkdir -p /home/${USERNAME}/.vscode-server \
    && mkdir -p /home/${USERNAME}/.vscode-server-insiders \
\
    && ln -s /usr/local/go/bin/go /usr/local/bin/go \
    && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# Set the default shell to bash rather than sh
SHELL ["/bin/bash", "-c"]

WORKDIR /app

CMD sleep infinity