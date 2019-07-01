#!/bin/bash

cd $(dirname "$0")/

if [[ -e .env ]]; then
  source .env
fi

if [[ -n "$1" ]]; then
  BUILD_NUMBER="${1}"
elif [[ -n "$CI_PIPELINE_IID" ]]; then
  BUILD_NUMBER=$(($CI_PIPELINE_IID+1000))
else
  echo "Usage: $0 <build-id> [board]"
  exit 1
fi

export $("../../third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh" | grep CHROMEOS_BUILD)

if [[ -z "$CHROMEOS_BUILD" ]]; then
  echo "Missing CHROMEOS_BUILD."
  exit 1
fi

if [[ -z "$BOARD" ]]; then
  export BOARD="${2:-rockpro64}"
fi

SHA=$(git rev-parse --short HEAD)
LOCAL_VERSION=$(cat VERSION)

export VERSION="${CHROMEOS_BUILD}.${LOCAL_VERSION}.${BUILD_NUMBER}.g${SHA}"
export RELEASE="R${CHROME_BRANCH}-${VERSION}"
export FLAGS_version="${VERSION}"

# print current version
(
  ../../third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh
)

set -xe

./packages.sh
./release.sh
./publish.sh
