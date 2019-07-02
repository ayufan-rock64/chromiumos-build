#!/bin/bash

cd "$(dirname "$0")/../"

if [[ -z "$BOARD" ]] || [[ -z "$VERSION" ]]; then
  echo "Missing BOARD or VERSION."
  exit 1
fi

set -xe

../../scripts/build_image \
  --noenable_rootfs_verification \
  --board="${BOARD}" \
  --version="${VERSION}" \
  base dev
