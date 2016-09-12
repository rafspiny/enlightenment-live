# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Basic widget set, based on EFL for mobile touch-screen devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Elementary"
EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.bz2"

LICENSE="LGPL-2.1"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="X debug doc examples fbcon nls quicklaunch sdl static-libs test wayland"

RDEPEND="
	>=dev-libs/efl-1.9.0_beta2[X?,fbcon?,png,sdl?,wayland?]
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-libs/check-0.9.5 )"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		$(use_enable X ecore-x)
		$(use_enable fbcon ecore-fb)
		$(use_enable sdl ecore-sdl)
		$(use_enable wayland ecore-wayland)
		--disable-ecore-cocoa
		--disable-ecore-psl1ght
		--disable-ecore-win32
		--disable-ecore-wince

		$(use_enable debug)
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable quicklaunch quick-launch)
		--disable-elocation
		--disable-emap
		--disable-eweather

		--with-tests=$(usex test regular none)

		--with-elementary-web-backend=none
	)

	econf "${config[@]}"
}

src_install() {
	default
	prune_libtool_files --modules
}
