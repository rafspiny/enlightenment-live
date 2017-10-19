# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils l10n
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="EFL Dynamic EDC edtiro"
#HOMEPAGE="http://www.enlightenment.org/"
HOMEPAGE="https://git.enlightenment.org/tools/enventor.git/about/"
EGIT_REPO_URI="https://git.enlightenment.org/tools/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc nls static-libs"

RDEPEND=" || ( >=dev-libs/efl-1.18.0 >=media-libs/elementary-1.16.0 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
DOCS=( AUTHORS NEWS README )

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
