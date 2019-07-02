#!/bin/bash

set -eo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <path/to/root> <cmd...>"
  exit 1
fi

if [[ "$UID" == "0" ]]; then
	echo "This script cannot be run as root user."
  echo "Try: sudo -EHu chronos -- $0 $@"
	exit 1
fi

SELF_PATH="$(dirname $(readlink -f "$0"))"
TARGET_PATH="$1"
shift

mkdir -p "$TARGET_PATH/"
cd "$TARGET_PATH/"

if [[ ! -x chromium/tools/depot_tools/cros_sdk ]]; then
  echo "Run ./cros_init.sh $TARGET_PATH."
  exit 1
fi

# Try to check for ourselves
# If not, bind-mount
if [[ ! -f src/overlays/overlay-rockpro64/cros_run.sh ]]; then
  echo "Bind-mounting src/overlays/overlay-rockpro64..."
  mkdir -p src/overlays/overlay-rockpro64
  sudo mount --bind "$SELF_PATH" src/overlays/overlay-rockpro64
fi

chromium/tools/depot_tools/cros_sdk --nouse-image -- "$@"
