#!/bin/bash

set -eo pipefail

cd "$(dirname "$0")/"

# Get CHROME_BRANCH and CHROMEOS_BUILD
export $("../../third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh" | grep -E 'CHROMEOS_BUILD|CHROME_BRANCH')

if [[ -z "$CHROMEOS_BUILD" ]] || [[ -z "$CHROME_BRANCH" ]]; then
  echo "Missing CHROME_BRANCH or CHROMEOS_BUILD."
  exit 1
fi

cd "patches/R$CHROME_BRANCH-$CHROMEOS_BUILD/"

while read TARGET_PATH; do
  echo "Processing $TARGET_PATH..."

  PATCH_PATH="$PWD/$TARGET_PATH"
  REL_TARGET_PATH="../../../../$TARGET_PATH"

  git -C "$REL_TARGET_PATH" reset --hard
  git -C "$REL_TARGET_PATH" clean -fdx
  git -C "$REL_TARGET_PATH" apply "$PATCH_PATH"/*.patch
done < <(find src -name '*.patch' -printf '%h\n' | sort -u)
