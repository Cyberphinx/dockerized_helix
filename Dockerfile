FROM alpine:latest

# Install Helix, tree-sitter-grammars, gcc, wget, and various essential tools
RUN apk update && \
    apk add --no-cache helix tree-sitter-grammars && \
    apk add gcc wget curl && \
    apk add --no-cache nodejs npm && \
    apk add --no-cache php

# Install rust and rust-analyzer
RUN wget -O - https://sh.rustup.rs | ash /dev/stdin -y -c rust-analyzer
# Set the PATH to include the cargo bin directory
ENV PATH="/root/.cargo/bin:${PATH}"
# Install taplo, the TOML language server
RUN cargo install taplo-cli --locked --features lsp

# To make Helix support color, set the terminal to support 256 colors
ENV TERM="xterm-256color"

# Copy Helix configuration files
COPY config.toml /root/.config/helix/config.toml
COPY languages.toml /root/.config/helix/languages.toml
COPY ./themes /root/.config/helix/

# Set the working directory to /code
WORKDIR /code

# Install the Dockerfile language server using npm
RUN npm install -g dockerfile-language-server-nodejs \
    # docker compose 
    @microsoft/compose-language-service \
    # bash
    bash-language-server \
    # typescript, javascript, jsx, tsx
    typescript typescript-language-server \
    eslint dprint emmet-ls \
    # php
    intelephense \
    # tailwindcss
    @tailwindcss/language-server \
    # yaml, yml
    yaml-language-server@next \
    # html css
    vscode-langservers-extracted \
    # Svelte
    svelte-language-server typescript-svelte-plugin \
    # sql
    sql-language-server
    

# Install phpactor
RUN curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
RUN chmod a+x phpactor.phar
RUN mkdir -p /root/.local/bin
RUN mv phpactor.phar /root/.local/bin/phpactor
ENV PATH="/root/.local/bin:${PATH}"

ENTRYPOINT [ "hx" ]

# Define the volume for code
VOLUME /code
