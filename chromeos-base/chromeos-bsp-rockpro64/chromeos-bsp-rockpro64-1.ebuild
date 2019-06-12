EAPI=5

DESCRIPTION="RockPro64 BSP package (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND="
    >=chromeos-base/tty-0.0.1-r99
    >=chromeos-base/chromeos-bsp-baseboard-gru-0.0.3
"

EXTRA_RDEPEND="
    app-crypt/gnupg
    app-emulation/lxc
    app-emulation/virt-what
    chromeos-base/chromeos-init
    chromeos-base/openssh-server-init
    chromeos-base/shill
    dev-python/python-dateutil
    dev-python/pyyaml
    net-analyzer/fping
    net-firewall/iptables
    net-ftp/tftp-hpa
    net-misc/bridge-utils
    net-misc/dhcp
    net-misc/rsync
    sys-apps/ethtool
    sys-apps/file
    sys-fs/e2fsprogs
    net-dns/bind-tools
    net-analyzer/speedtest-cli
    dev-python/cachetools
"

RDEPEND="
    $DEPEND
    sys-boot/rockchip-uboot
"
