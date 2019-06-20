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
