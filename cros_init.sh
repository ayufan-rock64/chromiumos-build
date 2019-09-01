#!/bin/bash

set -eo pipefail

if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]; then
  echo "usage: $0 <path/to/root> [manifest-branch]"
  echo "  eg.: manifest-branch: release-R77-12371.B"
  exit 1
fi

if [[ "$(id -u)" == "0" ]]; then
	echo "This script cannot be run as root user."
  echo "Try: sudo -EHu chronos -- $0 $@"
	exit 1
fi

SELF_PATH="$(dirname $(readlink -f "$0"))"
TARGET_PATH="$1"
shift

mkdir -p "$TARGET_PATH/"
cd "$TARGET_PATH/"

if [[ -n "$2" ]]; then
  MANIFEST_BRANCH="$2"
fi

if [[ -z "$MANIFEST_BRANCH" ]]; then
  echo "Missing MANIFEST_BRANCH."
  exit 1
fi

if [[ ! -x repo ]]; then
  curl https://storage.googleapis.com/git-repo-downloads/repo > repo.tmp
  chmod a+x repo.tmp
  mv repo.tmp repo
fi

if [[ ! -e ~/.gitconfig ]]; then
  git config --global user.name "$USERNAME"
  git config --global user.email "$USERNAME@$USERNAME"
fi

./repo init -u https://chromium.googlesource.com/chromiumos/manifest.git \
  --repo-url https://chromium.googlesource.com/external/repo.git \
  --manifest-branch="$MANIFEST_BRANCH"

./repo sync -j 10
