# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3 autotools
MY_PN="${PN/enlightenment-/}"

DESCRIPTION="An app for downloading themes and add-ons to Enlightenment WM"
HOMEPAGE="https://extra.enlightenment.org"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${MY_PN}.git"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/efl-1.18[X]"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	default
	cd enlightenment-extra-9999
	# Fix a QA issue, https://phab.enlightenment.org/T7167
	sed -i '/Version=/d' data/desktop/extra.desktop* || die
}

src_configure() {
	cd enlightenment-extra-9999
	local emesonargs=(
		-Dnls=true
	)
	meson_src_configure
}

src_install() {
	cd enlightenment-extra-9999
	meson_src_install
}

