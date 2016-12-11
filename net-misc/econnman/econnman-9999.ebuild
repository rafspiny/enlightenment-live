# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="EFL user interface for connman"
HOMEPAGE="https://www.enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
	=dev-python/python-efl-9999
	net-misc/connman:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
	)

	econf "${config[@]}"
}

src_install() {
	default
	prune_libtool_files
}
