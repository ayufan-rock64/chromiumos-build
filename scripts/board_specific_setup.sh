# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# TODO:
# this is hack needed due to `kernel install script`
# that does not create kernel images that can be put on
# KERN-A/B partition (with included dts)
skip_kernelblock_install=1

install_rockpro64_bootloader() {
  local image="$1"

  info "Installing uboot firmware on ${image}"
  sudo dd if="${ROOT}/boot/bootloader.bin" of="$image" \
    conv=notrunc,fsync \
    bs=512 \
    seek=64 || die "fail to install uboot fireware"

  info "Make ROOT-A/ROOT-B bootable"
  cgpt add -i 3 -B 1 "$image" # ROOT-A
  cgpt add -i 5 -B 1 "$image" # ROOT-B

  info "Installed bootloader."
}

board_setup() {
  install_rockpro64_bootloader "$1"
}
