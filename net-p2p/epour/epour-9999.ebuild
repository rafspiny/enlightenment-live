# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_2,3_4} pypy2_0 )

inherit eutils distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment torrent client"
HOMEPAGE="http://www.enlightenment.org/about-epour"
EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
# =dev-python/python-efl[${PYTHON_USEDEP}]
RDEPEND="dev-python/python-distutils-extra
		>=dev-libs/efl-1.15.0
		=dev-python/python-efl-9999
		>=net-libs/rb_libtorrent-1.0[python]
		sys-apps/dbus
		x11-misc/xdg-utils
		${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
