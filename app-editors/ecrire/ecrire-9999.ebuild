# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Enlightenment experimental text editor"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="http://git.enlightenment.org/apps/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="nls"

RDEPEND="
	>=dev-libs/efl-1.18.0
	"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local emesonargs=(
		-Dnls=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
