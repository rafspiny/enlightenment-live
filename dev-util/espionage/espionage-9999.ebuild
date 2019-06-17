# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# Add experimental python3_{5,7} support, which needs testing!
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit eutils l10n
[ "${PV}" = 9999 ] && inherit git-r3 distutils-r1

DESCRIPTION="A complete D-Bus inspector written in python that use the EFL"
HOMEPAGE="https://phab.enlightenment.org/w/projects/espionage/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

DEPEND=">=dev-python/python-efl-9999[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]"

RDEPEND="
	>=dev-libs/efl-9999
	${DEPEND}"
