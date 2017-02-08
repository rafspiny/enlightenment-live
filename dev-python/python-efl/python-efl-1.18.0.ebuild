# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
E_PKG_IUSE="examples"
E_PYTHON="yes"

PYTHON_COMPAT=( python{3_2,3_4} pypy2_0 )

inherit eutils distutils-r1
# inherit git-r3
# http://download.enlightenment.org/rel/bindings/python/python-efl-1.18.0.tar.gz

DESCRIPTION="Python bindings for EFL"
HOMEPAGE="http://www.enlightenment.org/about-epour"
if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="git://git.enlightenment.org/bindings/python/${PN}.git"
else
	SRC_URI="http://download.enlightenment.org/rel/bindings/python/${PN}-${PV}.tar.gz"
fi

LICENSE="LGPL-2.1"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc"
RDEPEND="
		>=dev-python/cython-0.21
		>=dev-python/dbus-python-1.2.0-r1
		>=dev-libs/efl-1.18.0
		doc? ( dev-python/sphinx )
		${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
