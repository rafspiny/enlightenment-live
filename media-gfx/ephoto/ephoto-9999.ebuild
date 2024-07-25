# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment image viewer built on the EFL."
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="nls"

RDEPEND="
	>=dev-libs/efl-1.19.0[eet,X]
	nls? ( sys-devel/gettext )
	"
DEPEND="${RDEPEND}
	dev-build/meson"

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
}
