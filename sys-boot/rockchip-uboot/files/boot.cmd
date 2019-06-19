# Detect device type
i2c dev 4
if i2c probe 62; then
  echo "Detected i2c4@62 charger circuit."
  echo "It seems to be Pinebook Pro."
  setenv fdtfile rockchip/rk3399-pinebook-pro.dtb
else
  echo "Did not detect i2c4@62 charger circuit."
  echo "It seems to be RockPro64."
  setenv fdtfile rockchip/rk3399-rockpro64.dtb
fi

# Detect bootdevice
if test "${devtype}${devnum}" = "mmc0"; then
  setenv bootdevice mmcblk1 # SDHCI
elif test "${devtype}${devnum}" = "mmc1"; then
  setenv bootdevice mmcblk0 # SD
else
  setenv bootdevice sda # USB?
fi

echo "FDT: ${fdtfile}"
echo "Bootdevice: ${bootdevice}"

# Scan ROOT-A
setenv prefix /boot/
setenv distro_bootpart 3
setenv bootdevice_part 3
run boot_extlinux

# Scan ROOT-B
setenv prefix /boot
setenv distro_bootpart 5
setenv bootdevice_part 5
run boot_extlinux
