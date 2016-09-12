# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"
EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.bz2"

LICENSE="GPL-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="gstreamer pdf postscript raw svg"

RDEPEND="
	>=dev-libs/efl-1.8.1
	gstreamer? (
		media-libs/gstreamer:1.0
	)
	pdf? ( app-text/poppler:0= )
	postscript? ( app-text/libspectre )
	raw? ( media-libs/libraw )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		$(use_enable gstreamer)
		$(use_enable gstreamer gstreamer1)
		$(use_enable pdf poppler)
		$(use_enable postscript spectre)
		$(use_enable raw libraw)
		$(use_enable svg)
	)

	econf "${config[@]}"
}
