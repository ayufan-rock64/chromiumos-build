EAPI=5

VARIANT="rockpro64"
VERSION="2017.09-rockchip-ayufan-1060-g56bd958253"
CROS_BINARY_URI="https://github.com/ayufan-rock64/linux-u-boot/releases/download/${VERSION}/u-boot-flash-spi-${VARIANT}.img.xz"

DESCRIPTION="Rockchip U-boot"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND=""
RDEPEND=""

S=${WORKDIR}

inherit cros-binary

src_install() {
	insinto /boot
	doins -r *
}
