# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{5..10} pypy3 )
inherit distutils-r1

# TODO: re-add python 3.7 support, once python-distutils-extra and
# libtorrent-rasterbar have it supported.

inherit distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="https://www.enlightenment.org/about-epour"
EGIT_REPO_URI="http://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]
		>=dev-libs/efl-1.15.0
		~dev-python/python-efl-9999
		dev-python/pyxdg
		net-libs/libtorrent-rasterbar[python,${PYTHON_USEDEP}]
		sys-apps/dbus
		x11-misc/xdg-utils
		"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_install() {
	distutils-r1_src_install
	# README.txt gets installed twice
	rm -r "${ED%/}"/usr/share/doc/"${PN}" || die "failed to remove dir"
}
