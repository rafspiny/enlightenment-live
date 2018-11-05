# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/_/-}

if [[ ${PV} == *9999 ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${MY_P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit xdg-utils

DESCRIPTION="Enlightenment DR17 window manager"
HOMEPAGE="https://www.enlightenment.org"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

LICENSE="BSD-2"
SLOT="0.17/${PV%%_*}"

E_CONF_MODS=(
	applications bindings dialogs display
	interaction intl menus
	paths performance randr shelves theme
	window-manipulation window-remembers
)
E_NORM_MODS=(
	appmenu backlight bluez4 battery
	clock conf connman cpufreq everything
	fileman fileman-opinfo gadman geolocation
	ibar ibox lokker
	mixer msgbus music-control notification
	pager packagekit pager-plain policy-mobile quickaccess
	shot start syscon systray tasks teamwork temperature tiling
	time winlist wireless wizard wl-desktop-shell wl-drm wl-text-input
	wl-weekeyboard wl-wl wl-x11 xkbswitch xwayland
)
IUSE_E_MODULES=(
	${E_CONF_MODS[@]/#/enlightenment_modules_conf-}
	${E_NORM_MODS[@]/#/enlightenment_modules_}
)

IUSE="pam spell static-libs systemd egl +eeze +udev ukit wayland ${IUSE_E_MODULES[@]/#/+}"

RDEPEND="
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	wayland? (
		dev-libs/efl[wayland]
		>=dev-libs/wayland-1.10.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)
	>=dev-libs/efl-1.18.1[X,egl?,wayland?]
	virtual/udev
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# eapply "${FILESDIR}"/"${P}"-quickstart.diff

	xdg_environment_reset
}

# Sanity check to make sure module lists are kept up-to-date.
check_modules() {
	local detected=$(
		awk -F'[\\[\\](, ]' '$1 == "AC_E_OPTIONAL_MODULE" { print $3 }' \
		configure.ac | sed 's:_:-:g' | LC_COLLATE=C sort
	)
	local sorted=$(
		printf '%s\n' ${IUSE_E_MODULES[@]/#enlightenment_modules_} | \
		LC_COLLATE=C sort
	)
	if [[ ${detected} != "${sorted}" ]] ; then
		local out new old
		eerror "The ebuild needs to be kept in sync."
		echo "${sorted}" > ebuild-iuse
		echo "${detected}" > configure-detected
		out=$(diff -U 0 ebuild-iuse configure-detected | sed -e '1,2d' -e '/^@@/d')
		new=$(echo "${out}" | sed -n '/^+/{s:^+::;p}')
		old=$(echo "${out}" | sed -n '/^-/{s:^-::;p}')
		eerror "Add these modules: $(echo ${new})"
		eerror "Drop these modules: $(echo ${old})"
		die "please update the ebuild"
	fi
}

src_configure() {
	check_modules

	local E_ECONF=(
		#--disable-install-sysactions
		# $(use_enable doc)
		# $(use_enable nls)
		$(use_enable egl wayland-egl)
		$(use_enable pam)
		$(use_enable systemd)
		--enable-device-udev
		$(use_enable udev mount-eeze)
		$(use_enable ukit mount-udisks)

		$(use_enable wayland)
	)
	local u c
	for u in ${IUSE_E_MODULES[@]} ; do
		c=${u#enlightenment_modules_}
		# Disable modules by hand since we default to enabling them all.
		case ${c} in
		wl-*|xwayland)
			if ! use wayland ; then
				E_ECONF+=( --disable-${c} )
				continue
			fi
			;;
		esac
		E_ECONF+=( $(use_enable ${u} ${c}) )
	done
	econf "${E_ECONF[@]}"
}

src_install() {
	enlightenment_src_install
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf

	# if use doc ; then
	#        local HTML_DOCS=( doc/. )
	# fi

	einstalldocs
	V=1 emake install DESTDIR="${D}" || die

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	    xdg_desktop_database_update
	    xdg_mimeinfo_database_update
}

pkg_postrm() {
	    xdg_desktop_database_update
	    xdg_mimeinfo_database_update
}
