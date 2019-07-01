#!/bin/bash

cd $(dirname "$0")

if [[ -z "$BOARD" ]]; then
  echo "Missing BOARD."
  exit 1
fi

if [[ -z "$VERSION" ]]; then
  echo "Missing VERSION."
  exit 1
fi

set -xe

../../scripts/build_image \
  --noenable_rootfs_verification \
  --board="${BOARD}" \
  --version="${VERSION}" \
  base dev
