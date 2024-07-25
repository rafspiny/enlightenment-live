# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="https://www.enlightenment.org/about-epour"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

#DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{5..10} )

RDEPEND="
		>=dev-libs/efl-1.15.0
		~dev-python/python-efl-1.26.1
		dev-python/pyxdg
		sys-apps/dbus
		x11-misc/xdg-utils
		net-libs/libtorrent-rasterbar[python]
		${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

#src_install() {
	#distutils-r1_src_install
	# README.txt gets installed twice
#	rm -r "${ED%/}"/usr/share/doc/"${PN}" || die "failed to remove dir"
#}
