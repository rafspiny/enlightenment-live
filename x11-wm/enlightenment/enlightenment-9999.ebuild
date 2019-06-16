# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment DR19 window manager"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/core/${PN}.git"
#EGIT_REPO_URI="https://github.com/Enlightenment/enlightenment.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0.17/${PV%%_*}"

E_MODULES_DEFAULT_MESON=(
	conf conf-applications conf-bindings conf-dialogs conf-display conf-interaction conf-intl conf-menus conf-paths conf-performance conf-randr conf-shelves conf-theme conf-window-manipulation conf-window-remembers
	appmenu backlight battery bluez4 clock connman cpufreq everything fileman fileman-opinfo gadman geolocation ibar ibox lokker luncher mixer msgbus music-control notification packagekit pager pager-plain quickaccess start shot syscon sysinfo systray tasks teamwork temperature tiling time winlist wireless wizard xkbswitch vkbd
)
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
	packagekit wl-desktop-shell wl-drm wl-fb wl-x11 wireless wl-buffer xwayland sysinfo policy-mobile wl-text-input
)
IUSE_E_MODULES=(
	"${E_MODULES_DEFAULT[@]/#/+enlightenment_modules_}"
	"${E_MODULES[@]/#/enlightenment_modules_}"
)
IUSE="doc +eeze egl nls pam pm-utils static-libs systemd +udev ukit wayland ${IUSE_E_MODULES[@]}"

# maybe even dev-libs/wlc for wayland USE flag
RDEPEND="
	>=dev-libs/efl-9999[X,egl?,wayland?]
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
		>=dev-libs/weston-1.11.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/meson"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local emesonargs=(
		-Dinstall-sysactions=true
		-Dinstall-enlightenment-menu=true
		-Dfiles=true
		-Ddevice-udev=true
		-Dnls=$(usex nls true false)
		-Dpam=$(usex pam true false)
		-Dmount-udisks=$(usex ukit true false)
		-Dmount-eeze=$(usex eeze true false)
		-Dsystemd=$(usex systemd true false)
		-Dmount-eeze=$(usex eeze true false)
	)
	# TODO Should we set systemdunitdir as well?

	# Check for wayland flag
	# TODO Maybe we should check for wayland and xwayland
	# TODO wl-text-input and wl-weekeyboard may be dependent on something else...need to check
	if use wayland; then
		emesonargs+=( -Dwayland=true -Dwl-buffer=true -Dwl-drm=true -Dwl-wl=true -Dwl-x11=true -Dwl-desktop-shell=true -Dwl-text-input=true -Dwl-weekeyboard=true )
	fi

	# TODO This should be useless given that the default value for each and one of the module is 'true'
	for i in ${E_MODULES_DEFAULT_MESON}; do
		emesonargs+=( -D${i}=true )
	done

	meson_src_configure
}

src_install() {
	meson_src_install
	prune_libtool_files
}
