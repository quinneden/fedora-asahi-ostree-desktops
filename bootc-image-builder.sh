#!/bin/zsh

set -ex

sudo podman build . -t kinoite-asahi:39
# sudo podman login quay.io
sudo podman push kinoite-asahi:39 quay.io/qeden/kinoite-asahi:39
sudo podman rmi --all

mkdir -p output

sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --security-opt label=type:unconfined_t \
  -v $(pwd)/config.json:/config.json \
  -v $(pwd)/output:/output \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type qcow2 \
  --config /config.json \
  quay.io/qeden/kinoite-asahi:39

