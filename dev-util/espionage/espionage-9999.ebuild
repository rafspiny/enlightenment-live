# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{5..10} pypy3 )
inherit distutils-r1

[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="A complete D-Bus inspector written in python that use the EFL"
HOMEPAGE="https://phab.enlightenment.org/w/projects/espionage/"
EGIT_REPO_URI="http://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
	>=dev-libs/efl-9999
	dev-python/dbus-python
	>=dev-python/python-efl-9999
"
DEPEND="${RDEPEND}"
