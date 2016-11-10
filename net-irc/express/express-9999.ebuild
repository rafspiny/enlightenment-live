# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Enlightenment IRC client"
HOMEPAGE="http://www.enlightenment.org/"
EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0.17/${PV%%_*}"

IUSE="doc nls static-libs"

RDEPEND="
	>=dev-libs/efl-1.10.0
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		$(use_enable nls)
		$(use_enable static-libs static)
	)

	econf "${config[@]}"
}

src_install() {
	default
	prune_libtool_files
}
