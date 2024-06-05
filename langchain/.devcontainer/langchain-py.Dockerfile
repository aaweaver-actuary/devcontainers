FROM mcr.microsoft.com/devcontainers/base:1.1.1-ubuntu-22.04 as base

# Switch to the workspace
WORKDIR /workspace

# Copy the commands
# COPY install-install_dotfiles .
# COPY install-rye .
# COPY install-zsh .

COPY ../../install-install_dotfiles .
COPY ../../install-rye .
COPY ../../install-zsh .

# Run the commands - Install the dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get full-upgrade -y && \
    apt-get install -y python3 python3-pip python3-setuptools python3-wheel python3-venv && \
\
    ./install-install_dotfiles && \
    ./install-rye && \
    ./install-zsh && \
\
    exec zsh && \
    rye init -p 3.11.8 && \
    rye sync && \
    rye add ruff ruff-lsp ipython ipykernel \
        langchain langgraph langchain-community langchain-openai langchain-cli "langserve[all]" \
        flask flask-sqlalchemy flask-cors \
        duckdb \
\
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


SHELL ["/bin/zsh", "-c"]

CMD ["zsh"]