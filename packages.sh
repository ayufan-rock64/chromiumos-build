#!/bin/bash

cd $(dirname "$0")

if [[ -e .env ]]; then
  source .env
fi

if [[ -z "$BOARD" ]]; then
  echo "Missing BOARD."
  exit 1
fi

set -xe

../../scripts/build_packages \
  --board="${BOARD}"
