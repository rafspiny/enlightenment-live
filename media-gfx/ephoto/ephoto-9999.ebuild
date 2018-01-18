# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment image viewer built on the EFL."
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc nls static-libs"

RDEPEND="
	>=dev-libs/efl-1.18.0
	"
DEPEND="${RDEPEND}
	dev-util/meson"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local emesonargs=(
		-Dnls=$(usex nls true false)
		-Dstatic_libs=$(usex static-libs true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
