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

  info "Installed bootloader."
}

install_rockpro64_efi_boot_scr() {
  local image="$1"
  local efi_offset_sectors=$(partoffset "$1" 12)
  local efi_size_sectors=$(partsize "$1" 12)
  local efi_offset=$((efi_offset_sectors * 512))
  local efi_size=$((efi_size_sectors * 512))
  local efi_dir=$(mktemp -d)

  sudo mount -o loop,offset=${efi_offset},sizelimit=${efi_size} "$1" \
    "${efi_dir}"
  sudo cp "${ROOT}/boot/boot.scr" "${efi_dir}/"
  sudo umount "${efi_dir}"
  rmdir "${efi_dir}"
}

make_root_a_b_bootable() {
  local image="$1"

  info "Make ROOT-A/ROOT-B bootable"
  cgpt add -i 3 -B 1 "$image" # ROOT-A
  cgpt add -i 5 -B 1 "$image" # ROOT-B
}

board_setup() {
  install_rockpro64_bootloader "$1"
  install_rockpro64_efi_boot_scr "$1"
  # make_root_a_b_bootable "$1"
}
