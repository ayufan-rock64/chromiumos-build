#!/bin/bash

# Re-work of https://github.com/ayufan-rock64/linux-package/blob/master/root/usr/local/sbin/install_widevine_drm.sh

set -e

if [[ "$(id -u)" != "0" ]]; then
	echo "This script requires to be run as root."
  echo "sudo $@"
	exit 1
fi

if [[ "$1" != "--force" ]] && [[ -e /opt/google/chrome/libwidevinecdm.so ]] && [[ -e /opt/google/chrome/PepperFlash/libpepflashplayer.so ]]; then
  echo "Widevine DRM is already installed"
  echo "Use '$0 --force' to overwrite."
  exit 1
fi

echo "Remounting root with read-write..."
mount -o remount,rw /

TEMP_DIR=$(mktemp --tmpdir=/mnt/stateful_partition -td ChromeOS-IMG.XXXXXX)
cleanup() {
  rm -rf "$TEMP_DIR"
  mount -o remount,ro /
}
trap 'cleanup' EXIT

cd "$TEMP_DIR/"

echo "Downloading a list of recovery images..."
curl -L https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf > recovery.conf

echo "Looking for recovery image for CB5-312T..."
if ! CHROMEOS_URL="$(grep -A11 CB5-312T < recovery.conf | sed -n 's/^url=//p')"; then
  echo "Failed to find recovery image for CB5-312T."
  exit 1
fi

echo "Downloading recovery image..."
curl "$CHROMEOS_URL" | zcat > chromeos.img

echo "Looking for system partition..."
root_offset=$(($(cgpt show -b -i 3 "chromeos.img" 3) * 512))
root_size=$(($(cgpt show -s -i 3 "chromeos.img" 3) * 512))

echo "Mounting recovery image ($root_offset:$root_size)..."
mkdir -p rootfs/
mount -o ro,loop,offset=${root_offset},sizelimit=${root_size} "chromeos.img" rootfs/

cleanup() {
  umount rootfs/
  rm -rf "$TEMP_DIR"
  mount -o remount,ro /
}

echo "Copying Widevine DRM..."
cp -av rootfs/opt/google/chrome/libwidevinecdm.so /opt/google/chrome/

echo "Copying PepperFlash..."
cp -av rootfs/opt/google/chrome/pepper/ /opt/google/chrome/

# echo "Copying Drive-File-Stream..."
# cp -av rootfs/opt/google/drive-file-stream /opt/google/
# cp -av rootfs/usr/lib/libdrivefs.so /usr/lib/
# if [[ ! -e /usr/lib/libprotobuf.so.17 ]]; then
#   cp -av rootfs/usr/lib/libprotobuf.so.17* /usr/lib/
# fi

echo "Copying Containers..."
cp -av rootfs/opt/google/containers /opt/google/

echo "Syncing..."
sync

echo "Done. Please reboot now."
