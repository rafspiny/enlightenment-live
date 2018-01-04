# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="This is a Video + Audio player mplayer style, based on EFL"
HOMEPAGE="https://www.enlightenment.org/about-rage"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

# TODO vlc USE flag is disabled for the moment, should be re-enabled once EFL has the same USE flag
# TODO Must fix IUSE, RDEPEND for the vlc USE flag on efl and for the flag itself
IUSE="+gstreamer vlc xine"

RDEPEND="
	|| ( >=dev-libs/efl-1.18.0 ( <dev-libs/efl-1.18.0 >=media-libs/elementary-1.15.1 ) )
	|| ( dev-libs/efl[gstreamer] dev-libs/efl[xine] dev-libs/efl[vlc] )
	gstreamer? ( dev-libs/efl[gstreamer] )
	vlc? ( dev-libs/efl[vlc] )
	xine? ( dev-libs/efl[xine] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
	)

	econf "${config[@]}"
}

src_install() {
	default
	prune_libtool_files
}
