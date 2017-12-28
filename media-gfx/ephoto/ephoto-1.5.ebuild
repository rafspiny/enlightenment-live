# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Enlightenment image viewer built on the EFL."
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"
SLOT="0"

IUSE="doc nls static-libs"

RDEPEND="
	>=dev-libs/efl-1.18.0
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
