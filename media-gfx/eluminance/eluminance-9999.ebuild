# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# FIXME: There were python 3.{2,3} implementations listed.
# Probably this also supports python 3.{5,6,7}. Needs testing!
PYTHON_COMPAT=( python3_{5,6,7,8,9} )

inherit distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment photo browser"
HOMEPAGE="https://github.com/DaveMDS/eluminance"
EGIT_REPO_URI="https://github.com/DaveMDS/eluminance.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND=">=dev-libs/efl-1.18.0
		dev-python/python-efl[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
