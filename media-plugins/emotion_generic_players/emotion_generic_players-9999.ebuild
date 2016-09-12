# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"
EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.bz2"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug +vlc"

RDEPEND="
	>=dev-libs/efl-1.8.1
	vlc? ( >=media-video/vlc-2.0 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		--with-profile=$(usex debug debug release)
		$(use_with vlc)
	)

	econf "${config[@]}"
}
