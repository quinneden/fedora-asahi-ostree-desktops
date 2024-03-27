#!/bin/bash

set -ex

sudo podman build -t kinoite-asahi:39 .
sudo podman login -u='qeden' -p='PThLjlAWJ5mwqkq5KP+g/mumguOFG9s9nJAd7lDg5sPYywaJFAwLOzhBiaJyHJ8e' quay.io
sudo podman push kinoite-asahi quay.io/ecurtin/kinoite-asahi
sudo podman push kinoite-asahi quay.io/ecurtin/kinoite-asahi:39

mkdir -p _build
mkdir -p _build/osbuild_store/{objects,refs,sources/org.osbuild.files,tmp}
mkdir -p _build/image_output
# osbuild-mpp kinoite-asahi-container.mpp.yaml _build/kinoite-asahi-container.json
# osbuild-mpp -I . -D image_type="ostree" -D arch="aarch64" -D distro_name="kinoite-asahi" -D target="asahi" kinoite-asahi-container.mpp.yaml _build/kinoite-asahi-container.aarch64.json
osbuild-mpp -I . kinoite-asahi-container.mpp.yaml _build/kinoite-asahi-container.aarch64.json
sudo osbuild --store _build/osbuild_store --output-directory _build/image_output --checkpoint image-tree --checkpoint image --cache-max-size 20GiB --export qcow2 _build/kinoite-asahi-container.aarch64.json

