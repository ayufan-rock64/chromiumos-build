# ChromiumOS for Pinebook Pro and RockPro64

The image is compatible with RockPro64 and Pinebook Pro.
Check the compatibility list to see what is supported: https://docs.google.com/spreadsheets/d/1pCqJg0VSzvihUOoxCOq3wt5JeGB4iApAyBBfc_BGv2A/edit#gid=1505794447

Image variants:

- `Base`: the system in fairly secure configuration,
- `Development`: the system with development dependencies and SSH server (`chronos/chronos`).

## Notes

This is development system, not ready for production usage,
and build in insecure configuration. This does not support secure
boot, nor it does not perform rootfs verification ubon boot.

### 1. Resize STATE

After installing Chromium OS you should resize STATE partition:

1. Press: `Ctrl+Alt+F2`,
2. Login: `chronos/chronos`,
3. Run: `sudo rockpro64-resize-statefs.sh`, enter password `chronos`,
4. Exit and go back to the Chromium OS with `Ctrl+Alt+F1`.

### 2. Install Widevine DRM

The build supports Widevine DRM, but does not ship the binary
as this is against Google license. You can install it manually,
but first follow the resize manual:

1. Press: `Ctrl+Alt+F2`,
2. Login: `chronos/chronos`,
3. Run: `sudo rockpro64-install-widevine.sh`,
4. Reboot: `sudo reboot`.

## Changelog

- R77-12371.7.x: update to R77,
- R76-12239.7.x: update kernel to 4.4.190,
- R76-12239.7.x: update u-boot to 2017.09-1065 (`95f6152134`) (enables LED support for all boards),
- R76-12239.6.x: update kernel to 4.4.189 (improves suspend, fixes DMA, etc.),
- R76-12239.6.x: fix BT audio (set UART to 1.5M),
- R76-12239.6.x: add support for sleep button,
- R76-12239.6.x: update linux-package,
- R76-12239.5.x: update kernel to 4.4.184,
- R76-12239.4.x: initial release,
