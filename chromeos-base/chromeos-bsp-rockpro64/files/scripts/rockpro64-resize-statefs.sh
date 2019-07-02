#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" != "0" ]]; then
	echo "This script requires to be run as root."
  echo "sudo $0 $@"
	exit 1
fi

if [[ $# -gt 1 ]]; then
  echo "usage: $0 <10M|1G|10G>"
  exit 1
fi

if ! STATE_PATH=$(findmnt -n -o SOURCE -M /mnt/stateful_partition); then
  echo "Failed to find STATE partition."
  exit 1
fi

STATE_DISK=${STATE_PATH/p*/}
STATE_PART=${STATE_PATH/*p/}

if [[ -z "$STATE_DISK" ]] || [[ -z "$STATE_PART" ]]; then
  echo "Failed to find disk and partition for STATE."
  exit 1
fi

sfdisk -N 1 --no-reread "$STATE_DISK" < <(echo ", +$1")
partx -u "$STATE_DISK"
resize2fs "$STATE_PATH"
