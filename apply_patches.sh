#!/bin/bash

cd $(dirname "$0")/patches/

set -eo pipefail

while read TARGET_PATH; do
  echo "Processing $TARGET_PATH..."

  PATCH_PATH="$PWD/$TARGET_PATH"
  REL_TARGET_PATH="../../../../$TARGET_PATH"

  git -C "$REL_TARGET_PATH" reset --hard
  git -C "$REL_TARGET_PATH" clean -fdx
  git -C "$REL_TARGET_PATH" apply "$PATCH_PATH"/*.patch
done < <(find src -name '*.patch' -printf '%h\n' | sort -u)
