EAPI=5

VARIANT="rockpro64"
VERSION="2017.09-rockchip-ayufan-1062-gbb4886a528"
CROS_BINARY_URI="https://github.com/ayufan-rock64/linux-u-boot/releases/download/${VERSION}/u-boot-flash-spi-${VARIANT}.img.xz"

DESCRIPTION="Rockchip U-boot"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND=""
RDEPEND=""

S=${WORKDIR}

inherit cros-binary

src_compile() {
	mkimage -O linux -T script -C none -a 0 -e 0 \
		-n "boot" -d "${FILESDIR}/boot.cmd" "boot.scr" || die
}

src_install() {
	dd if="${S}/u-boot-flash-spi-${VARIANT}.img" of="${S}/bootloader.bin" skip=64 count=8127

	insinto /boot
	doins boot.scr
	doins bootloader.bin
}
