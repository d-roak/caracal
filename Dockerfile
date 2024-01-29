FROM rust:1.75 as builder

ARG CARACAL_VERSION=0.2.3

WORKDIR /src/caracal

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/crytic/caracal .
RUN git checkout v$CARACAL_VERSION

RUN cargo install --path . --profile release --force

FROM ubuntu:24.04

ARG SCARB_VERSION

RUN apt-get update && apt-get install -y git curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v $SCARB_VERSION; exit 0
RUN echo "export PATH=$PATH:/root/.local/bin" >> /root/.bashrc

COPY --from=builder /usr/local/cargo/bin/caracal /usr/local/bin/caracal

ENTRYPOINT ["caracal"]
