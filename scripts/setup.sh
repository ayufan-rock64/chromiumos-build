#!/bin/bash

cd "$(dirname "$0")/../"

if [[ -e .env ]]; then
  source .env
fi

if [[ -z "$BOARD" ]]; then
  echo "Missing BOARD."
  exit 1
fi

if [[ -d "/build/${BOARD}" ]]; then
  echo "/build/${BOARD} seems to be present, skipping setup."
  exit 0
fi

set -xe

setup_board --board="${BOARD}" --default
