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
