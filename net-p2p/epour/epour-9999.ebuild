# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: re-add python 3.7 support, once python-distutils-extra and
# libtorrent-rasterbar have it supported.
PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} )

inherit eutils distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="https://www.enlightenment.org/about-epour"
EGIT_REPO_URI="http://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]
		>=dev-libs/efl-1.15.0
		~dev-python/python-efl-9999[${PYTHON_USEDEP}]
		>=net-libs/libtorrent-rasterbar-1.0.10:=[python,${PYTHON_USEDEP}]
		sys-apps/dbus
		x11-misc/xdg-utils
		${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_install() {
	distutils-r1_src_install
	# README.txt gets installed twice
	rm -r "${ED%/}"/usr/share/doc/"${PN}" || die "failed to remove dir"
}
