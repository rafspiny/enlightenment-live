# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature xdg
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment DR19 window manager"
HOMEPAGE="https://www.enlightenment.org/"
#EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"
EGIT_REPO_URI="file:///data/projects/enlightenment"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"
[ "${PV}" = 9999 ] || KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"

LICENSE="BSD-2"
# Historically enlightenment was slotted to separate e16 from e17. e16 is now
# packaged as x11-wm/e16, but the slot is kept because it's more complicated to
# reset it rather than just to keep it.
SLOT="0.17/${PV%%_*}"

IUSE="acpi bluetooth connman doc exif geolocation nls pam policykit systemd udisks wayland xwayland"

REQUIRED_USE="xwayland? ( wayland )"
RDEPEND="
	>=dev-libs/efl-9999[X,eet,fontconfig,egl?,wayland?]
	virtual/udev
	x11-apps/setxkbmap
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	bluetooth? ( net-wireless/bluez )
	connman? ( dev-libs/efl[connman] )
	exif? ( media-libs/libexif )
	geolocation? ( app-misc/geoclue:2.0 )
	mixer? ( >=media-libs/alsa-lib-1.0.8 )
	pam? ( sys-libs/pam )
	policykit? ( sys-auth/polkit )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		|| (
			dev-libs/efl[systemd]
			dev-libs/efl[elogind]
		)
		dev-libs/efl[drm,wayland]
		>=dev-libs/wayland-1.3.0
		>=dev-libs/weston-1.11.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1

	)
	xwayland? (
		dev-libs/efl[X,wayland]
		x11-base/xwayland
	)"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/meson"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local emesonargs=(
	    -D install-sysactions=true
	    -D install-enlightenment-menu=true
	    -Dfiles=true
		-D device-udev=true

		-D elput=true
		-D install-system=true
		-D mount-eeze=false
		-D packagekit=false

		$(meson_use udisks mount-udisks)
		$(meson_use bluetooth bluez5)
		$(meson_use connman)
		$(meson_use exif libexif)
		$(meson_use geolocation)
		$(meson_use nls)
		$(meson_use pam)
		$(meson_use policykit polkit)
		$(meson_use systemd)
		$(meson_use wayland wl)
		$(meson_use xwayland)
	)

	if use wayland; then
		emesonargs+=(
			-D wl-buffer=true
			-D wl-desktop-shell=true
			-D wl-drm=true
			-D wl-wl=true
            -D wl-x11=true
			-D wl-text-input=true
			-D wl-weekeyboard=true
			-D wayland=true
		)
	fi

	meson_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( doc/. )
	meson_src_install
    find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
