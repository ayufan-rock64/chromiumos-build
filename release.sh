#!/bin/bash

cd $(dirname "$0")

if [[ -z "$BOARD" ]]; then
  echo "Missing BOARD."
  exit 1
fi

if [[ -z "$RELEASE" ]]; then
  echo "Missing RELEASE."
  exit 1
fi

set -xe

../../scripts/build_image \
  --noenable_rootfs_verification \
  --board="${BOARD}" \
  --version="${RELEASE}" \
  base dev
