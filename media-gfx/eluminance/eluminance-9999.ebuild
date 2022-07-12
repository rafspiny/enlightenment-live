# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{5..10} pypy3 )
inherit distutils-r1 xdg
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment photo browser"
HOMEPAGE="https://github.com/DaveMDS/eluminance"
EGIT_REPO_URI="https://github.com/DaveMDS/eluminance.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND=">=dev-libs/efl-1.18.0
		dev-python/python-efl
		dev-python/pyxdg
		${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
