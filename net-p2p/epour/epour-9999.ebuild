# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="https://git.enlightenment.org/enlightenment/epour"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"

S="${WORKDIR}/${P/_/-}"
LICENSE="GPL-2"
SLOT="0"

PYTHON_COMPAT=( python3_{5..14} )

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
