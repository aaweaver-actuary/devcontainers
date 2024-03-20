FROM alpine:3.19

WORKDIR /app

RUN mkdir -p /root

COPY zsh.tar.gz /root/zsh.tar.gz

RUN apk update \
    && apk add --no-cache python3 py3-pip rust cargo zsh curl git gcc g++ cmake \
    && apk add --no-cache postgresql-dev python3-dev musl-dev \
    && python3 -m venv .venv
RUN . .venv/bin/activate \
    && pip install --upgrade pip
# RUN . .venv/bin/activate \    
#     && pip install postgres polars 
RUN tar -xvf /root/zsh.tar.gz -C /root
#  \
#     && mv /root/zsh /root/.zsh \
#     && rm /root/zsh.tar.gz \
#     && chmod +x /root/.zsh/install_dotfiles.zsh \
#     && mv /root/.zsh/install_dotfiles.zsh /usr/bin/install_dotfiles \
#     && install_dotfiles /root .zshrc .zsh_aliases install_fonts.zsh \
#     && install_dotfiles /app .prettierrc .ruff.toml .mypy.ini \
#     && rm -rf /root/.zsh

RUN apk del rust cargo gcc g++ postgresql-dev python3-dev musl-dev cmake \
    && rm -rf /var/cache/apk/*

CMD [ "/bin/zsh" ]