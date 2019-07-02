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

# Get CHROME_BRANCH and CHROMEOS_BUILD
export $("../../third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh" | grep -E 'CHROMEOS_BUILD|CHROME_BRANCH')

if [[ -z "$CHROMEOS_BUILD" ]] || [[ -z "$CHROME_BRANCH" ]]; then
  echo "Missing CHROME_BRANCH or CHROMEOS_BUILD."
  exit 1
fi

if [[ -z "$BOARD" ]]; then
  export BOARD="${2:-rockpro64}"
fi

if [[ -z "$GOOGLE_API_KEY" ]] || [[ -z "$GOOGLE_DEFAULT_CLIENT_ID" ]] || [[ -z "$GOOGLE_DEFAULT_CLIENT_SECRET" ]]; then
  echo "Missing GOOGLE_API_KEY or GOOGLE_DEFAULT_CLIENT_ID or GOOGLE_DEFAULT_CLIENT_SECRET."
  exit 1
fi

# write API keys
cat > ~/.googleapikeys <<EOF
'google_api_key': '$GOOGLE_API_KEY',
'google_default_client_id': '$GOOGLE_DEFAULT_CLIENT_ID',
'google_default_client_secret': '$GOOGLE_DEFAULT_CLIENT_SECRET',
EOF

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

./scripts/setup.sh
./scripts/packages.sh
./scripts/release.sh
./scripts/publish.sh
