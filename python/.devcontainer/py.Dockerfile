FROM mcr.microsoft.com/devcontainers/base:bookworm as base

ARG python_version=3.11.8

# Setup a non-root user
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV HOME=/home/${USERNAME}

# pyenv environment variables
ENV PYENV_ROOT=/home/user/.pyenv

# Copy over the Makefile
COPY python/.devcontainer/Makefile /usr/local/Makefile

# Add a command to install dotfiles
COPY ../install_dotfiles.bash /home/user/install_dotfiles
RUN ln -s /home/user/install_dotfiles /usr/local/bin/install_dotfiles

# Switch to the user's home directory
WORKDIR $HOME

# Create the user with specified USER_UID and USER_GID
COPY ../../setup_user.bash /tmp/setup_user.bash
RUN /tmp/setup_user.bash "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm /tmp/setup_user.bash

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
        make \
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
    && mv ./dotfiles/.gitconfig /home/user/.gitconfig \
    && mv ./dotfiles/.gitignore_global /home/user/.gitignore_global \
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
    && chmod -R 777 /app  \
    && chmod -R 777 /home/${USERNAME}/.vscode-server \
    && chmod -R 777 /home/${USERNAME}/.vscode-server-insiders
# \
#     && install_dotfiles /app .prettierrc .ruff.toml .mypy.ini

CMD sleep infinity