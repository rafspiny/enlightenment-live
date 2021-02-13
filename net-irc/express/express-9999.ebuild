# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment IRC client"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0.17/${PV%%_*}"

IUSE="nls"

RDEPEND="
	>=dev-libs/efl-1.18.0
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/meson"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local emesonargs=(
		-Dnls=$(usex nls true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
