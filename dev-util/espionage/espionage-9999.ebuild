# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Add experimental python3_{5,7} support, which needs testing!
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="A complete D-Bus inspector written in python that use the EFL"
HOMEPAGE="https://phab.enlightenment.org/w/projects/espionage/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
	>=dev-libs/efl-9999
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/python-efl-9999[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
