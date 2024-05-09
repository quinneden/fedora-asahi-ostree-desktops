#!/bin/zsh

set -ex

sudo podman build . -t kinoite-asahi:latest
# sudo podman login quay.io
# sudo podman push kinoite-asahi:latest quay.io/qeden/kinoite-asahi:latest
# sudo podman rmi --all    ## Optional, if disk space is limited

mkdir -p output

sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/config.toml:/config.toml \
    -v $(pwd)/output:/output \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 \
    --local \
    kinoite-asahi:latest
