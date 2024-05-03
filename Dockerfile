FROM alpine:latest

RUN apk update && apk add helix tree-sitter-grammars gcc

VOLUME /code

RUN wget -O - https://sh.rustup.rs | ash /dev/stdin -y -c rust-analyzer
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /code

ENTRYPOINT [ "hx" ]
