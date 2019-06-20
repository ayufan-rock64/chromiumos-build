#!/bin/bash

cd $(dirname "$0")/

if [[ -e .env ]]; then
  source .env
fi

BUILD_NUMBER="${CI_PIPELINE_IID}"
VERSION="$(cat VERSION)"
DATE=$(date +%Y_%m_%d_%H%M)
SHA=$(git rev-parse --short HEAD)

if [[ -n "$1" ]]; then
  BUILD_NUMBER="${1}"
elif [[ -n "$CI_PIPELINE_IID" ]]; then
  BUILD_NUMBER=$(($CI_PIPELINE_IID+1000))
else
  echo "Usage: $0 <build-id> [board]"
  exit 1
fi

if [[ -z "$BOARD" ]]; then
  export BOARD="${2:-rockpro64}"
fi

export RELEASE="${VERSION}.${BUILD_NUMBER}.${DATE}.g${SHA}"

set -xe

./packages.sh
./release.sh
./publish.sh
