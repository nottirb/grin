# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install -f cargo-fuzz

## Add source code to the build stage.
ADD . /grin
WORKDIR /grin
RUN cd core && ${HOME}/.cargo/bin/cargo fuzz build --fuzz-dir ./fuzz
RUN cd p2p && ${HOME}/.cargo/bin/cargo fuzz build --fuzz-dir ./fuzz

# Package Stage
FROM ubuntu:20.04

COPY --from=builder grin/core/fuzz/target/x86_64-unknown-linux-gnu/release/block_read_v1 /
COPY --from=builder grin/core/fuzz/target/x86_64-unknown-linux-gnu/release/block_read_v2 /
COPY --from=builder grin/core/fuzz/target/x86_64-unknown-linux-gnu/release/compact_block_read_v1 /
COPY --from=builder grin/p2p/fuzz/target/x86_64-unknown-linux-gnu/release/read_shake /
COPY --from=builder grin/p2p/fuzz/target/x86_64-unknown-linux-gnu/release/read_peer_addrs /
COPY --from=builder grin/p2p/fuzz/target/x86_64-unknown-linux-gnu/release/read_hand /

# COPY --from=builder grin/p2p/fuzz/target/x86_64-unknown-linux-gnu/release/* /