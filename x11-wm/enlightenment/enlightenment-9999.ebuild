# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Enlightenment DR19 window manager"
HOMEPAGE="http://www.enlightenment.org/"
EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0.17/${PV%%_*}"

E_MODULES_DEFAULT=(
	conf-applications conf-bindings conf-dialogs conf-display conf-interaction
	conf-intl conf-menus conf-paths conf-performance conf-randr conf-shelves
	conf-theme conf-window-manipulation conf-window-remembers

	appmenu backlight battery bluez4 clock conf connman cpufreq everything
	fileman fileman-opinfo gadman geolocation ibar ibox lokker mixer msgbus music-control
	notification pager pager-plain quickaccess shot start syscon systray tasks time
	teamwork temperature tiling winlist wizard xkbswitch
	wl-weekeyboard wl-wl wl-x11
)
E_MODULES=(
	packagekit #wl-desktop-shell wl-drm wl-fb wl-x11
)
IUSE_E_MODULES=(
	"${E_MODULES_DEFAULT[@]/#/+enlightenment_modules_}"
	"${E_MODULES[@]/#/enlightenment_modules_}"
)
IUSE="doc +eeze egl nls pam pm-utils static-libs systemd +udev ukit wayland ${IUSE_E_MODULES[@]}"

RDEPEND="
	>=dev-libs/efl-1.10.0[X,egl?,wayland?]
	virtual/udev
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	enlightenment_modules_mixer? ( >=media-libs/alsa-lib-1.0.8 )
	nls? ( sys-devel/gettext )
	pam? ( sys-libs/pam )
	pm-utils? ( sys-power/pm-utils )
	systemd? ( sys-apps/systemd )
	wayland? (
		>=dev-libs/wayland-1.3.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		--disable-simple-x11
		#--disable-wayland-only

		--enable-conf
		--enable-device-udev # instead of hal
		#--enable-enotify
		--enable-files
		--enable-install-enlightenment-menu
		--enable-install-sysactions

		$(use_enable doc)
		$(use_enable egl wayland-egl)
		$(use_enable nls)
		$(use_enable pam)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable ukit mount-udisks)
		$(use_enable eeze mount-eeze)
		$(use_enable wayland wayland)
		#$(use_enable wayland wayland-clients)
	)

	local i
	for i in ${E_MODULES_DEFAULT} ${E_MODULES}; do
		config+=( $(use_enable enlightenment_modules_${i} ${i}) )
	done

	if use wayland; then
		config+=( --enable-enlightenment_modules_wl-desktop-shell --enable-wl-x11 --enable-wl-wl --enable-wl-drm --enable-wl-text-input --enable-wl-weekeyboard)
	fi

	econf "${config[@]}"
}

src_install() {
	default
	prune_libtool_files
}
