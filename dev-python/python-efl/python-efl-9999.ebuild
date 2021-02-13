# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# FIXME: They are not declared in any official eclass.
# The enlightenment.niifaq overlay at
# https://github.com/niifaq/enlightenment.overlay declares those in their
# efl.eclass but this is not available here.
#E_PKG_IUSE="examples"
#E_PYTHON="yes"

PYTHON_COMPAT=( python{2_7,3_{5,6,7,8,9}} )

inherit eutils distutils-r1
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Python bindings for EFL"
HOMEPAGE="https://www.enlightenment.org/about-epour"
EGIT_REPO_URI="https://git.enlightenment.org/bindings/python/${PN}.git"

LICENSE="LGPL-2.1"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc"
RDEPEND="
		>=dev-python/cython-0.21[${PYTHON_USEDEP}]
		>=dev-python/dbus-python-1.2.0-r1[${PYTHON_USEDEP}]
		>=dev-libs/efl-1.22.99
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
		${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/_/-}"
