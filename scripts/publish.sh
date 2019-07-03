#!/bin/bash

cd "$(dirname "$0")/../"

if [[ -e .env ]]; then
  source .env
fi

if  [[ -z "$GITHUB_USER" ]] || [[ -z "$GITHUB_REPO" ]] || [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Missing GITHUB_USER, GITHUB_REPO or GITHUB_TOKEN. Skipping publish."
  exit 0
fi

if [[ -z "$BOARD" ]] || [[ -z "$VERSION" ]] || [[ -z "$RELEASE" ]]; then
  echo "Missing BOARD, VERSION or RELEASE."
  exit 1
fi

PIPELINE_URL="*local-build*"
if [[ -n "$CI_PIPELINE_ID" ]]; then
  PIPELINE_URL=$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID
fi

RELEASE_TITLE="${RELEASE}"
RELEASE_NAME="${RELEASE}"
RELEASE_TAG="$(git rev-parse HEAD)"
CHANGES=$(head -n 60 RELEASE.md)
DESCRIPTION=$(echo -e "${CHANGES}\n\n${PIPELINE_URL}")

GR=${GOPATH:-~}/go/bin/github-release
if [[ ! -x "$GR" ]]; then
  go get -u github.com/aktau/github-release
fi

set -xe

cd "../../build/images/${BOARD}/${RELEASE}"

compress_and_upload() {
  xz -T 0 -c "$1" > "$2"

  $GR upload \
    --tag "${RELEASE_NAME}" \
    --name "$2" \
    --file "$2"
}

$GR release \
  --tag "${RELEASE_NAME}" \
  --name "${RELEASE_TITLE}" \
  --description "${DESCRIPTION}" \
  --target "${RELEASE_TAG}" --draft

compress_and_upload chromiumos_base_image.bin \
  "chromiumos-${BOARD}-R${CHROME_BRANCH}-${RELEASE}.img.xz"

compress_and_upload chromiumos_image.bin \
  "chromiumos-${BOARD}-R${CHROME_BRANCH}-${RELEASE}-dev.img.xz"

$GR edit \
  --tag "${RELEASE_NAME}" \
  --name "${RELEASE_TITLE}" \
  --description "${DESCRIPTION}" \
  --pre-release
