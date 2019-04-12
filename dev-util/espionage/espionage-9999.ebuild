# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_6} pypy2_0 )
inherit eutils l10n
[ "${PV}" = 9999 ] && inherit git-r3 distutils-r1

DESCRIPTION="A complete D-Bus inspector written in python that use the EFL"
HOMEPAGE="https://phab.enlightenment.org/w/projects/espionage/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

DEPEND=">=dev-python/python-efl-9999
	dev-python/dbus-python"

RDEPEND="
	>=dev-libs/efl-9999
	${DEPEND}"