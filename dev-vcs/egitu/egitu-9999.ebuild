# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# FIXME: There were python 3.{2,4} implementations listed.
# Probably this ebuild also supports python 3.{5,6,7}. Needs testing!
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="GIT client based on EFL"
HOMEPAGE="https://github.com/DaveMDS/egitu"
EGIT_REPO_URI="https://github.com/DaveMDS/egitu.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""
RDEPEND=">=dev-libs/efl-1.13.0
		dev-python/python-efl[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
