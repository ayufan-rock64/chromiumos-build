#!/bin/bash

cd $(dirname "$0")

if [[ -e .env ]]; then
  source .env
fi

if [[ -z "$BOARD" ]]; then
  echo "Missing BOARD."
  exit 1
fi

if [[ -z "$RELEASE" ]]; then
  echo "Missing RELEASE."
  exit 1
fi

if [[ -z "$GITHUB_USER" ]]; then
  echo "Missing GITHUB_USER."
  exit 1
fi

if [[ -z "$GITHUB_REPO" ]]; then
  echo "Missing GITHUB_REPO."
  exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Missing GITHUB_REPO."
  exit 1
fi

PIPELINE_URL=
if [[ -n "$CI_PIPELINE_ID" ]]; then
  PIPELINE_URL=$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID
fi

upload() {
  $GR upload \
    --tag "${RELEASE_NAME}" \
    --name "$1" \
    --file "$1"
}

compress_and_upload() {
  xz -T 0 -c "$1" > "$2"
  upload "$2"
}

# get CHROME_BRANCH
export FLAGS_version="${RELEASE}"
source "../../third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh"

RELEASE_TITLE="R${CHROME_BRANCH}-$RELEASE"
RELEASE_NAME="R${CHROME_BRANCH}-$RELEASE"
RELEASE_TAG="$(git rev-parse HEAD)"
CHANGES=$(head -n 60 RELEASE.md)
DESCRIPTION=$(echo -e "${CHANGES}\n\n${PIPELINE_URL}")

GR=${GOPATH:-~}/go/bin/github-release
if [[ -x "$GR" ]]; then
  go get -u github.com/aktau/github-release
fi

set -xe

cd "../../build/images/${BOARD}/R${CHROME_BRANCH}-${RELEASE}"

$GR release \
  --tag "${RELEASE_NAME}" \
  --name "${RELEASE_TITLE}" \
  --description "${DESCRIPTION}" \
  --target "$RELEASE_TAG" --draft

compress_and_upload chromiumos_base_image.bin \
  "chromiumos-${BOARD}-R${CHROME_BRANCH}-${RELEASE}.img.xz"

compress_and_upload chromiumos_image.bin \
  "chromiumos-${BOARD}-R${CHROME_BRANCH}-${RELEASE}-dev.img.xz"

$GR edit \
  --tag "${RELEASE_NAME}" \
  --name "${RELEASE_TITLE}" \
  --description "${DESCRIPTION}"
