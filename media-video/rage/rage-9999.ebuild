# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="This is a Video + Audio player mplayer style, based on EFL"
HOMEPAGE="https://www.enlightenment.org/about-rage"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

S="${WORKDIR}/${P/_/-}"
LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

# TODO vlc USE flag is disabled for the moment, should be re-enabled once EFL has the same USE flag
# TODO Must fix IUSE, RDEPEND for the vlc USE flag on efl and for the flag itself
IUSE="+gstreamer vlc xine"

RDEPEND="
	>=dev-libs/efl-1.18.0
	dev-libs/efl[gstreamer]
"
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-build/meson"

src_configure() {
	local emesonargs=()
	meson_src_configure
}

src_install() {
	meson_src_install
}
