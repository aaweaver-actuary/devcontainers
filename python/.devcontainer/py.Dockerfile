FROM mcr.microsoft.com/devcontainers/base:bookworm as base

ARG python_version=3.11.8

# Setup a non-root user
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV HOME=/home/${USERNAME}

# pyenv environment variables
ENV PYENV_ROOT=/home/user/.pyenv


WORKDIR /home/${USERNAME}

# Create the user with specified USER_UID and USER_GID
RUN if getent group $USER_GID ; then echo "Group $USER_GID already exists"; else groupadd --gid $USER_GID $USERNAME; fi \
    && if id -u $USERNAME > /dev/null 2>&1; then echo "User $USERNAME already exists"; else useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chmod 777 ${HOME} \
    && mkdir /app \
    && chown -R $USERNAME:$USERNAME /app \
    && chmod -R 777 /app

# Copy over the Makefile
COPY ./Makefile /app/Makefile

# Switch to the user's home directory
WORKDIR $HOME

# Install the Python components, other tools, and dotfiles
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        curl \
        bash \
        git \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
\
    && git clone https://github.com/aaweaver-actuary/dotfiles.git \
    && mv ./dotfiles/.bashrc /home/user/.bashrc \ 
    && mv ./dotfiles/.profile /home/user/.profile \ 
    && mv ./dotfiles/.hushlogin /home/user/.hushlogin \
    && mv ./dotfiles/.prettierrc /app/.prettierrc \
    && mv ./dotfiles/.gitconfig /home/user/.gitconfig \
    && mv ./dotfiles/.gitignore_global /home/user/.gitignore_global \
    && mv ./dotfiles/ruff.toml /app/.ruff.toml \
\   
    && rm -rf ./dotfiles \
    && mkdir -p /home/${USERNAME}/.vscode-server \
    && mkdir -p /home/${USERNAME}/.vscode-server-insiders \
\
    && curl -k -L https://pyenv.run | bash \
    && echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /home/user/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> /home/user/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /home/user/.bashrc \
    && ln -s /home/user/.pyenv/bin/pyenv /usr/local/bin/pyenv \
    && chown -R user:user /home/user/.pyenv \
    && chmod -R 777 /home/user/.pyenv

# Install the specified version of Python and the required packages
RUN PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' \
    && PYTHON_CFLAGS='-march=native -mtune=native' \
    && pyenv install $python_version \
    && pyenv global $python_version \
    && pyenv rehash \
    && ln -s /home/user/.pyenv/versions/$python_version/bin/python /usr/local/bin/py

RUN py -m venv /app/.venv \
    && . /app/.venv/bin/activate \
    && py -m pip install --no-cache-dir --upgrade pip \
    && py -m pip install --no-cache-dir --upgrade ruff \
    && py -m pip install --no-cache-dir --upgrade mypy \
    && py -m pip install --no-cache-dir --upgrade flake8 \
    && py -m pip install --no-cache-dir --upgrade pytest \
    && py -m pip install --no-cache-dir --upgrade pytest-flake8 \
    && py -m pip install --no-cache-dir --upgrade coverage \
    && py -m pip install --no-cache-dir --upgrade pytest-cov

# Set the default shell to bash rather than sh
SHELL ["/bin/bash", "-c"]

WORKDIR /app

RUN chown -R user:user /home/user \
    && chmod -R 777 /home/user \
    && chown -R user:user /app \
    && chmod -R 777 /app  \
    && chmod -R 777 /home/${USERNAME}/.vscode-server \
    && chmod -R 777 /home/${USERNAME}/.vscode-server-insiders

CMD sleep infinity